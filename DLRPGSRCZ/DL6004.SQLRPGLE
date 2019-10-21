     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL APR Calculation - with history')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6004 - APR Calculation                                     *
      *                                                               *
      *  (C) Copyright Finastra International Limited, 2016           *
      *                                                               *
      *  Function: To calculate APR rates                             *
      *                                                               *
      *  Called by: DL6005 Trigger program for DEALSDC                *
      *             DL6006 Trigger program for DEAMSDI                *
      *                                                               *
      *  Calls    : GL000050 APR Calculation program                  *
      *                                                               *
      *  Last Amend No. MD054544           Date 04Oct19               *
      *  Prev Amend No. MD054479           Date 27Sep19               *
      *                 MD054107           Date 11Sep19               *
      *                 MD054017           Date 04Sep19               *
      *                 CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054544 - Cashflow is incorrect for CALL LOAN after         *
      *             authorising the amendment on Maturity Date and    *
      *             Next Interest Payment Date                        *
      *  MD054479 - Correction on CashFlow for MMLoans / MMDeposits   *
      *  MD054107 - No APR Recalculation on Deal Amendment            *
      *  MD054017-Change on validation of System Value "APR Formula"  *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
     FDEAMS     IF   E           K DISK
     F                                     IGNORE(DEAMSDHF)
     F                                     IGNORE(DEAMSDJF)
      *
      ** Deal Amendments File
     FTABTG30   IT   F   40        DISK
      *
      ** Curriencies Record 3
     FDEALS     IF   E           K DISK
      *
      ** Deals file
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
     FDLHISTI0  IF   E           K DISK
     F** Deals history
      *
     FSDBRCHL1  IF   E           K DISK
      *
      ** Branch Codes Retrieval
     FDLAPRHI0  IF   E           K DISK
      *
      ** APR History File Retieval
     FDLAPRHTD  O    E             DISK    COMMIT
     F                                     RENAME(DLAPRHD0:DLAPRHD1)
      *
      ** APR History File
     FGLAPRCTD  O    E             DISK    USROPN
      *
      ** APR Work File
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *    05   Chain failure - deals
      *    06   Deal amendment record - live
      *    11   Deal amendment reocrd - reversed
      *    17   Analytical accounting module present
      *    22   Maturity date present
      *    23   Facility type present
      *    24   Rollover of deal not present
      *    25   Rollover by deal not present
      *    26   Interest payment frequency blank
      *    27   Next interest date zero
      *    28   Deal amendment value date absent
      *    29   Sale date present
      *    33   Calculate interest to next interest date
      *    35   Obtaining conversion on factor for CCY
      *    41   Negative interest indicator on
      *    42   Rollover indicator on
      *    43   Federal funds indicator on
      *    44   Outgoing
      *    49   General purpose
      *   50-57 General use
      *    58   Chain fail indicator/EOF DLHISTPP
      *    59   Interest is capitalised
      *    60   Deals is an internal contract 1st leg
      *    61   Accounting bit set in ACEI
      *    62   A history record has been written to the events file
      *    63   Event date is date of next working day
      *    64   Maturity date is <= event control date
      *    65   Value date is > date of next working day
      *    66   Call/Notice deal has a maturity date
      *    67   Portfolio Management is switched on.
      *    70   Next interest date after deal amend value date
      *    80   Read failure
      *    87   Multiply/divide indicator is zero
      *    88   General use
      *  90-99  Z-SUBROUTINES
      *    U7   Database error
      *    U8   File control totals disagree
      *    U1
      *    LR   Last record
      *****************************************************************
      /EJECT
      *****************************************************************
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZFREQBZ1LE
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZPOWERZ1IL
      *
      ** Array containing Copyright statement
      *
      *       Key to tables -
      *  TAB1 contains deal type and last 2 characters of event code.
      *  TAB2 contains corresponging values for the output fields -
      *  first 2 chars. of event codes event date, event amount,
      *  event CCY, other amount, other CCY, other date, int/exch rate,
      *  S.I.IND, I/O IND. representations are -
      *
      *     Amount                        Date
      *     1  Zero                       1  Zero
      *     2  Purchased AMT/ Principal/  2  Value
      *        Purchase/Sale price        3  Maturity/Other LEG value
      *     3  Sold                       4  Maturity/Notice
      *     4  Principal INCR/DECREASE    5  Interest
      *     5  Face value                 6  Sale
      *     6  SWAP profit/loss           7  Amend value
      *     7  Interest
      *     9  LEG 1 Amount - Purch/Sale
      *
      *     Curriencies                   Interest/Exchange Rates
      *        Blank                         Zero
      *     D  Deal                       E  Exchange
      *     L  P/L                        I  Interest
      *     P  Purchase                   Y  Yield
      *     S  Sale
      *
      *     Instruction INDS -            I/O INDS -
      *     0  0                          Blank
      *     1  1                          I  I
      *     2  2                          O  O
      *     3  3
      *     4  2/3
      *
     D*TAB1******      S              4    DIM(42) CTDATA PERRCD(1)
     D*TAB2******      S             11    DIM(42) ALT(TAB1)
     D*TAB1*****       S              4    DIM(50) CTDATA PERRCD(1)                         MD054107
     D*TAB2*****       S             11    DIM(50) ALT(TAB1)                                MD054107
     D TAB1            S              4    DIM(86) CTDATA PERRCD(1)                         MD054107
     D TAB2            S             11    DIM(86) ALT(TAB1)                                MD054107
     D FRQ             S              1    DIM(5) CTDATA PERRCD(5)              Freqs for NWD chk
      *
      ** Output fields
      *
      ** Output outputs
      *
      ** Output dates
     D BR              S              3    DIM(100)                             Branch Codes
     D CO              S              3    DIM(100)                             Company codes
     D IC              S              6    DIM(100)                             Internal Cust no.
      ** Standard code for loading array of branch and company codes
     D CP              S              6    DIM(100)                             Branch Parent
     D CR              S             20    DIM(100)                             Branch report name
     D CT              S             10    DIM(100)                             Branch town
     D CA              S              8    DIM(100)                             Branch ALFA sort
     D CZ              S              2    DIM(100)                             Branch CTRY CTZN
     D CL              S              2    DIM(100)                             Branch CTRY loccatio
     D PI              S              2    DIM(100)                             Branch PARNT IND
     D PR              S             20    DIM(100)                             Parent report name
     D PT              S             10    DIM(100)                             Parent town
     D PA              S              8    DIM(100)                             Parent ALFA sort
     D CY              S              3    DIM(200) FROMFILE(TABTG30) PERRCD(1) CCY/CCY details
     D CYD             S             37    DIM(200) ALT(CY)
     D CC              S              2    DIM(200)                             Country codes
     D RC              S              2    DIM(200)                             Region codes
     D P@OP01          S             20                                                  MD054017
     D P@VL01          S            200                                                  MD054017
     D P@OP02          S             20                                                  MD054017
     D P@VL02          S            200                                                  MD054017
     D P@OP03          S             20                                                  MD054017
     D P@VL03          S            200                                                  MD054017
     D P@OP04          S             20                                                  MD054017
     D P@VL04          S            200                                                  MD054017
     D P@OP05          S             20                                                  MD054017
     D P@VL05          S            200                                                  MD054017
     D P@OP06          S             20                                                  MD054017
     D P@VL06          S            200                                                  MD054017
     D P@OP07          S             20                                                  MD054017
     D P@VL07          S            200                                                  MD054017
     D P@OP08          S             20                                                  MD054017
     D P@VL08          S            200                                                  MD054017
     D P@OP09          S             20                                                  MD054017
     D P@VL09          S            200                                                  MD054017
     D P@OP10          S             20                                                  MD054017
     D P@VL10          S            200                                                  MD054017
     D SYSVAL1         S              1                                                  MD054017
     D SYSVAL2         S              1                                                  MD054017
     D SYSVAL3         S             30                                                  MD054017
     D SYSVAL3A        S             30                                                  MD054017
      ** Save of branch and report name and address
     D/COPY ZSRSRC,ZHOLELE
     D*
     D @ACPY           DS
      *
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **
     D PSDS           SDS
      *
      ** Retrieve WSID from program status data structure
     D  PGM              *PROC
     D  @FILE                201    208
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Data Structures
      ** Amount and Date Arrays
     D                 DS
     D  AMT                    1     91  0
     D                                     DIM(7)
     D  PUAM                  14     26  0
     D  PCPL                  14     26  0
     D  PUPR                  14     26  0
     D  SAPR                  14     26  0
     D  SLAM                  27     39  0
     D  DAAM                  40     52  0
     D  FVAL                  53     65  0
     D  SPLA                  66     78  0
     D  INTDUE                79     91  0
     D                 DS
     D  DAT                    1     35  0
     D                                     DIM(7)
     D  VDAT                   6     10  0
     D  MDAT                  11     15  0
     D  OTDT                  11     15  0
     D  NOTD                  18     20  0
     D  TODATE                21     25  0
     D  SADT                  26     30  0
     D  VDATM                 31     35  0
      *
      ** Evntx Output Keys
     D                 DS
     D  KEY                    1      4
     D  DTYP                   1      2
     D  CODE2                  3      4
     D  KEYDS                  5     15
     D  NN                     5      6
     D  ED                     7      7  0
     D  EA                     8      8  0
     D  EC                     9      9
     D  OA                    10     10  0
     D  OC                    11     11
     D  OD                    12     12  0
     D  RAT                   13     13
     D  SIIND                 14     14
     D  IOIND                 15     15
      *
      ** Deals Amendments file chaining keys
     D                 DS
     D  DAMKEZ                 1     14
     D  DLNO                   1      6  0
     D  DATE                   7     11  0
     D  SEQNO                 12     14  0
      *
      ** Data Structure to contain equivalent fields from different
      ** record types
     D                 DS
      *
      ** Settlement Details
     D  SETTLE                 1     30
     D  SETTYP                 1      2  0
     D  SETAC                  3     14
     D  SETNOS                15     24
      *
     D  SETST                 31     60
     D  PCST                  31     32  0
     D  SDST                  31     32  0
     D  SETP                  31     32  0
     D  OPCA                  33     50
     D  OSDA                  33     50
     D  OSAC                  33     50
     D  TSCN                  51     60
     D  TSTN                  51     60
     D  TSEN                  51     60
      *
     D  SETMAT                61     90
     D  SCST                  61     62  0
     D  MDST                  61     62  0
     D  OSCA                  63     80
     D  OMDA                  63     80
     D  FACO                  81     90
      *
     D  SETDM                 91    120
     D  SETPM                 91     92  0
     D  OSACM                 93    110
     D  TSENM                111    120
     D  RCRNM                111    118
      *
      ** Customer Number
     D  CUSTNO               121    126
     D  CNUM                 121    126
     D  ISCN                 121    126
      *
      ** Counterparty Customer Number
     D  CPCN                 127    132
     D  CHNA                 127    132
     D  PCUS                 127    132
     D  ISCNDE               127    132
      *
      ** GLINTC & ZFREQ fields
     D  ZICALC               133    133  0
     D  ICBS                 133    133  0
     D  ZIRATE               134    144  7
     D  INTR                 134    144  7
     D  ZFREQ                145    145
     D  IPFR                 145    145
     D  ZMDAY                146    147  0
     D  INTF                 146    147  0
      *
      ** Currency details from TABTG10
     D CYDDS           DS
     D  CDP                    1      1  0
     D  SPOT                   2      8P 8
     D  MDIN                   9      9  0
     D  ERLC                  10     16P 8
     D  TNOT                  17     17  0
     D  CCNM                  18     31
     D  TEAC                  32     35
     D  SSNO                  36     37  0
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZDAT10Z1LE
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  RUND         E                     EXTFLD(BJRDNB)
      *
      ** Access object for bank details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Access object for module details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** Access object for dealing data
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Access object for country codes
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACD1       E                     EXTFLD(QQACCD)
      *
      ** Access object for trading ICD data
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Access object for customer details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD2       E                     EXTFLD(QQACCD)
      *
      ** Access object for general ledger ICD
     D SDEXPM        E DS                  EXTNAME(SDEXPMPD)
      *
      ** Access object for exposure management data
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACD3       E                     EXTFLD(QQACCD)
      *
      ** Access object for nostro accounts
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Data structure for rollover switch on file
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second DS for access programs, long data structure
     D RUNDAT          DS
      *
      ** RUNDAT data structure - to access multi-branching flag
     D  @MBIN                 13     13
      *
                                                                                         MD054017
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'                  MD054017
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                  MD054017
                                                                                         MD054017
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Rename
     IDEAMSDIF
     I              VDAT                        VDATM
     I*
     IDLHISTD0
     I              DLNO                        HDLNO
     I              PCPL                        HPCPL
     I              DTYP                        HDTYP
     I              MDAT                        HMDAT
     I              CCY                         HCCY
     I              INTC                        HINTC
     I              ICBS                        HICBS
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EMAIN:    Start Program                                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
      ** Initial Processing
     C     *ENTRY        PLIST
     C                   PARM                    UIECOD            7            Error code
     C                   PARM                    UIDEAL            6            Deal number
      *
      ** Initial Processing
     C                   EXSR      #EINIT
      *
      ** Main Processing
     C                   EXSR      #EPROC
      *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      * #EINIT:    Main Processing                                    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #EINIT        BEGSR
      *
     C                   MOVE      *BLANKS       UIECOD
     C                   MOVE      UIDEAL        UIDLNO            6 0
      *
     C                   MOVEL     CPY@(1)       COPY             80
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
      ** Read RUNDAT for multi branching indicator
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT           13
      *
      ** Call access object AOBANKR0
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Set up date format
     C     BJDFIN        COMP      'M'                                98
      ** Set up system location for future use
     C                   MOVEL     BJSLCD        ZLOC
      *
      ** Check Rollover Switch on
     C                   CALL      'AOSARDR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      'S01434'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01434            1
     C                   ELSE
     C                   MOVE      'N'           S01434
     C                   ENDIF
      *
      ** Call acess object AODEALR0
     C                   CALL      'AODEALR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Access GL details.
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
                                                                                         MD054017
      ** Call Access Program for System Values                                           MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL1 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRMMDeposits  '                            MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       @RTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017
                                                                                         MD054017
      ** Handle Database Error                                                           MD054017
                                                                                         MD054017
     C                   If        @RTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 19                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      *PSSR                                                 MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL1 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL2 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRMMLoans     '                            MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       @RTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017
                                                                                         MD054017
      ** Handle Database Error                                                           MD054017
                                                                                         MD054017
     C                   If        @RTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 20                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      *PSSR                                                 MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL2 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL3 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRFormula     '                            MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       @RTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017

      ** Handle Database Error

     C                   If        @RTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 21                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      *PSSR                                                 MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL3 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
      *
tina  ** For Accrual for Non-working Days Processing Types 0 and 1,
 ¦    ** Event Control Date is DNWD - 1.
 ¦   C     BJDNWD        SUB       1             ECD               5 0
      *
      ** If Accrual for Non-working days indicator is equal 2, then
      ** if the Accrual/Profit Date is less than or equal to Date of
      ** Next Working Day minus 1, the Event Control Date should be
      ** the Accrual/Profit Date.  Otherwise, it should be Run Date.
      ** This is because Processing Type 2 processes non-working days
      ** retrospectively and will only generate events up to today,
      ** unless the next accrual day is before the next working day, in
      ** which case it will generate events to accrual day.
     C     BKANWD        IFEQ      '2'
      *
     C     BKAPDT        IFLE      ECD
     C                   Z-ADD     BKAPDT        ECD
     C                   ELSE
     C                   Z-ADD     RUND          ECD
  ¦  C                   ENDIF
  ¦   *
tina C                   ENDIF
      *
      ** Access Dealing details
     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Call access object AOMMODR0
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Check if Analytical Accounting Module is switched on
     C     BGN0ST        IFEQ      'Y'
     C                   MOVE      *ON           *IN17
     C                   ELSE
     C                   MOVE      *OFF          *IN17
     C                   ENDIF
      *
     C                   Z-ADD     1             I                 3 0
     C     BJCYCD        LOOKUP    CY(I)                                  50
     C     *IN50         IFEQ      *ON
     C                   MOVE      CYD(I)        CYDDS
     C                   Z-ADD     CDP           BCD               1 0
     C                   ELSE
      *
      ** Error if not found
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     BJCYCD        UIERR            20
     C                   MOVE      '- NO CCY'    UIERR
     C                   MOVE      UIERR         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Limit CCY details
     C                   Z-ADD     1             I
     C     BNCYCD        LOOKUP    CY(I)                                  50
     C     *IN50         IFEQ      *ON
     C                   MOVE      CYD(I)        CYDDS
     C                   Z-ADD     CDP           LMD               1 0
     C                   ELSE
      *
      ** Error if not found
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     BNCYCD        UIERR
     C                   MOVE      '- NO CCY'    UIERR
     C                   MOVE      UIERR         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   Z-ADD     0             AMT(1)
     C                   Z-ADD     0             DAT(1)
      *
      ** Set number of days forward to zero for use in ZFWDT
     C                   Z-ADD     0             ZNRDYS
      ** Zeroise sale date - not used
     C                   Z-ADD     0             SADT
      *
      ** Load array of branch and company codes from SDBRCHPD
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               80
     C                   Z-ADD     1             X                 2 0
      *
     C     *IN80         DOWEQ     *OFF
     C                   MOVE      A8BRCD        BR(X)
     C                   MOVE      A8CMCD        CO(X)
     C                   MOVE      A8BICN        IC(X)
      *
      ** Access Customer Details of Branch
     C                   MOVE      *BLANK        @KEY1
     C                   MOVEL     A8BICN        @KEY1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVE      @KEY1         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   MOVE      BBPCNB        CP(X)
     C                   MOVE      BBCRNM        CR(X)
     C                   MOVE      BBCRTN        CT(X)
     C                   MOVE      BBCASC        CA(X)
     C                   MOVE      BBCNCZ        CZ(X)
     C                   MOVE      BBCOLC        CL(X)
     C                   MOVE      BBPAIN        PI(X)
      *
      ** Access Customer Details of Parent
     C     BBPCNB        IFNE      *BLANK
     C                   MOVE      *BLANK        @KEY1
     C                   MOVEL     BBPCNB        @KEY1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVE      @KEY1         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   MOVE      BBCRNM        PR(X)
     C                   MOVE      BBCRTN        PT(X)
     C                   MOVE      BBCASC        PA(X)
     C                   ENDIF
      *
     C                   ADD       1             X
     C                   READ      SDBRCHL1                               80
     C                   ENDDO
      *
      ** Set initial pointer for top-down array of country/region
     C                   Z-ADD     200           II                3 0
      *
      ** Get Exposure Management ICD
     C     BGEXMG        IFEQ      'Y'
      *
     C                   CALL      'AOEXPMR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C     SDEXPM        PARM      SDEXPM        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDEXPMPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Determine if Portfolio Management is swicthed on.
     C     BGPFMG        IFEQ      'Y'
     C                   MOVE      *ON           *IN67
     C                   ENDIF
      *
      ** Defined Key list
     C     DAMKEY        KLIST
     C                   KFLD                    DLNO              6 0
     C                   KFLD                    DATE              5 0
     C                   KFLD                    SEQNO             3 0
      *
     C     DLKEY         KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    RUND
      *
      ** Key lists for History file
     C     HISKY1        KLIST
     C                   KFLD                    HISK01            6 0          Deal No.
      *
     C     HISKY2        KLIST
     C                   KFLD                    HISK01                         Deal No.
     C                   KFLD                    HISK02            5 0          Event date
      *
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *INU7
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EPROC:    Main Processing                                    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EPROC        BEGSR
      *
      ** Set input fields for holiday subroutine
     C                   Z-ADD     0             INTDUE
      *
      ** Check if deal number exists
     C     UIDLNO        CHAIN     DEALS                              05
      *
     C     *IN05         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN06
     C                   MOVE      *OFF          *IN61
      *
      ** Store record ID of deal
     C                   MOVE      RECI          RECISV            1
      ** Store interest accrual control date
     C                   Z-ADD     IACD          IACDWK            5 0
      *
      ** Deal with interest frequency not 'N' has matured, so bypass
     C     RECISV        IFEQ      'M'
     C     IPFR          IFNE      'N'
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Only calculate APR for IP/TI/LN/IT/TD/CI/CL/DL/CD deal types
     C     DTYP          IFNE      'IP'
     C     DTYP          ANDNE     'TI'
     C     DTYP          ANDNE     'LN'
     C     DTYP          ANDNE     'IT'
     C     DTYP          ANDNE     'TD'
     C     DTYP          ANDNE     'CI'
     C     DTYP          ANDNE     'CL'
     C     DTYP          ANDNE     'DL'
     C     DTYP          ANDNE     'CD'
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      *    Process history if a valid record exists
     C                   MOVE      UIDLNO        HISK01
     C                   MOVE      VDAT          HISK02
     C     HISKY2        SETLL     DLHISTI0
     C                   EXSR      NXTREC
     C     *IN58         IFEQ      *OFF
      *     History Processing
     C                   EXSR      PROHIS
     C                   END
      *
      ** Check accounting bit set
     C                   TESTB     '1'           ACEI                     61
      *
      ** Set up counterparty customer number, and zeroise facility and
      ** number
     C     DTYP          COMP      'IP'                                   50
     C  N50DTYP          COMP      'TI'                                   50
     C  N50DTYP          COMP      'LN'                                   50
     C  N50DTYP          COMP      'IT'                                   50
     C  N50DTYP          COMP      'TD'                                   50
     C  N50DTYP          COMP      'CI'                                   50
     C  N50              MOVE      CUSTNO        CPCN
      *
      ** Reset indicator upon which calculation of principal depends
     C                   MOVE      *OFF          *IN65
      *
     C     IPFR          IFEQ      *BLANK
     C                   MOVE      *ON           *IN26
     C                   ENDIF
     C     NIDT          IFEQ      0
     C                   MOVE      *ON           *IN27
     C                   ENDIF
     C     DAVD          IFEQ      0
     C                   MOVE      *ON           *IN28
     C                   ENDIF
      *
      ** Go to appropriate calculations
     C     NOTD          COMP      -999                                   50
     C  N50              GOTO      CALNOT
      *
      **   F I X E D   L O A N S / D E P O S I T S
     C                   TESTB     '1'           DSTI                     41
      *
      ** Check if a CD, CL or DL deal with a maturity date
     C     DTYP          COMP      'CD'                                   66
     C  N66DTYP          COMP      'CL'                                   66
     C  N66DTYP          COMP      'DL'                                   66
     C  N66DTYP          COMP      'TD'                                   66
     C  N66DTYP          COMP      'IT'                                   66
     C  N66DTYP          COMP      'TI'                                   66
     C  N66DTYP          COMP      'IP'                                   66
     C  N66              GOTO      BYPASS
      *
      ** Check for interest frequency 'N'
     C                   MOVE      *OFF          *IN88
     C     IPFR          IFEQ      'N'
     C                   MOVE      *ON           *IN88
     C                   MOVE      'L'           IPFR
     C                   ENDIF
      *
     C                   MOVE      'V1'          KEY
     C                   EXSR      #EEVNT
     C     *INU7         IFEQ      *ON
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     '*ERROR  '    DBFILE
     C                   Z-ADD     12            DBASE
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** Set indicators and fields for call deals
     C     INTC          IFEQ      'Y'
     C     *IN06         OREQ      *ON
     C     AMTP          ANDEQ     'CI'
     C                   MOVE      *ON           *IN59
     C                   ENDIF
      *
     C     AITC          ADD       AIAN          INTDUE           13 0
     C     INTDUE        ADD       AIAP          INTDUE
     C     INTDUE        SUB       IPRD          INTDUE
     C     INTDUE        SUB       ICTD          INTDUE
      *
     C                   Z-ADD     PCPL          PRINAM           13 0
      *
     C     LOOP1         TAG
     C   27
     CAN 28              GOTO      ENDCNX
      *
     C                   Z-ADD     DAVD          DATE
     C                   Z-ADD     DASN          SEQNO
     C                   MOVE      *OFF          *IN70
     C  N27
     CANN28NIDT          COMP      DAVD                               70
      *
      ** Calculate interest from IACD to next action date
     C                   Z-ADD     IACD          ZIBEG
     C  N27
     CANN28
     CAN 70
     COR 27              Z-ADD     DAVD          ZIEND
     C  N27
     CANN28
     CANN70
     COR 28              Z-ADD     NIDT          ZIEND
     C                   Z-ADD     PRINAM        ZIAMT
     C                   EXSR      GLINTC
      *
      ** If loan/deposit with round down interest = 'Y'
     C     JRDFC         IFEQ      'Y'
     C     INTDUE        ADD       ZINTR         INTDUE
     C                   ELSE
     C     INTDUE        ADD(H)    ZINTR         INTDUE
     C                   ENDIF
     C                   Z-ADD     ZIEND         IACD
      *
      ** Generate event for interest payment
     C  N27
     CANN28
     CAN 70
     COR 27              GOTO      AMDEVX
      *
      ** If interest is capitalised add to principal
     C   59PRINAM        ADD       INTDUE        PRINAM
     C   59              GOTO      CLCID
      *
      ** Interest not cap D - generate event
     C                   MOVE      *OFF          *IN06
     C                   Z-ADD     NIDT          TODATE
     C                   MOVE      'I2'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
      *
     C     *IN88         IFEQ      '1'
     C     NIDT          ANDGT     MDAT
     C                   Z-ADD     0             INTDUE
     C                   GOTO      ENDN
     C                   ENDIF
      *
      ** Calculate next interest date
     C     CLCID         TAG
      *
     C     IPFR          IFEQ      *BLANK
     C                   MOVE      *ON           *IN26
     C                   ENDIF
      *
     C                   Z-ADD     0             INTDUE
     C   26              Z-ADD     0             NIDT
     C   26              MOVE      *ON           *IN27
     C   26              GOTO      LOOP1
      *
     C                   MOVE      CCY           ZCCY
     C                   Z-ADD     IBDT          ZDAYNO
      *
      ** Check whether loan or deposit in order to set up location
     C     PCPL          IFGT      0
      *
      ** Set up location - if Our PAY Settlement
      ** Method is a nostro then use nostro code and currency to find
      ** Nostro Location
     C     PSTM          IFEQ      01
     C     PSTM          OREQ      02
     C     PSTM          OREQ      07
     C     PSTM          OREQ      08
     C     PSTM          OREQ      12
      *
     C     STCY          IFNE      *BLANK
     C                   MOVE      STCY          XCCY              3
     C                   ELSE
     C                   MOVE      CCY           XCCY              3
     C                   ENDIF
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      XCCY          @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PONS          @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
     C                   ELSE
      *
      **  PCPL is less than zero so deal is a loan
      ** Set up location - if Our receive Settlement
      ** Method is a nostro then use nostro code and currency to find
      ** Nostro Location
     C     RSTM          IFEQ      01
     C     RSTM          OREQ      02
     C     RSTM          OREQ      07
     C     RSTM          OREQ      08
     C     RSTM          OREQ      12
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      CCY           @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      RONS          @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   Z-ADD     14            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      ZFREQB
     C                   Z-ADD     ZDAYNO        IBDT
      *
      ** ZFREQ may return a non-working day for freq W,F,S,R and L
      ** check with ZDATE5 and get next working day
     C     ZFREQ         LOOKUP    FRQ                                    50
     C     *IN50         IFEQ      '1'
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        NIDT
     C                   ELSE
     C                   Z-ADD     ZDAYNO        NIDT
     C                   ENDIF
      *
     C     NIDT          COMP      MDAT                               27
     C   27              Z-ADD     0             NIDT
      *
     C                   GOTO      LOOP1
      *
      ** Chain to deals amendment file and write event records
     C     AMDEVX        TAG
     C                   EXSR      #EDCHN
     C   U7              MOVEL     'DEAMS'       UIERR
     C   U7              MOVE      DAMKEZ        UIERR
     C   U7              GOTO      END
      *  if no deal amendments exist
     C     *IN50         IFEQ      '1'
     C                   MOVE      *ON           *IN28
     C                   GOTO      LOOP1
     C                   ENDIF
      *
      ** If deal amendment reversed, get next deal amendment record
     C   11              GOTO      NXTAMX
      *
      ** If value date > next working date do not include this
      ** amendment in the principal calculation
     C     NIDT          IFNE      0
     C     VDATM         COMP      NIDT                               65
     C                   ELSE
     C     VDATM         COMP      BJDNWD                             65
     C                   ENDIF
      *
      ** If value date > next working date, skip this amendment record
     C   65              GOTO      NXTAMX
     C     AMTP          COMP      'PD'                                   50
     C     AMTP          COMP      'PI'                                   51
     C   50              MOVE      'M4'          KEY
     C   51              MOVE      'V3'          KEY
     C   50
     COR 51              EXSR      #EEVNT
     C   U7              GOTO      END
     C     AMTP          COMP      'PD'                                   50
     C     AMTP          COMP      'PI'                                   51
     C   50
     CANN65PRINAM        SUB       DAAM          PRINAM
     C   51
     CANN65PRINAM        ADD       DAAM          PRINAM
     C   50
     COR 51              GOTO      NXTAMX
      *
      ** Process other deal amendment types
     C     AMTP          COMP      'SC'                                   49    Spread change
     C   49RTSP          ADD       BRTE          INTR
     C   49              GOTO      NXTAMX
      *
     C     AMTP          COMP      'SI'                                   49    Settle interest
     C   49              MOVE      'I2'          KEY
     C   49              Z-ADD     VDATM         TODATE
     C   49              EXSR      #EEVNT
     C   U7              GOTO      END
     C   49              Z-ADD     0             INTDUE
     C   49              GOTO      NXTAMX
      *
     C     AMTP          COMP      'CI'                                   49    Capit. interest
     C   49PRINAM        ADD       INTDUE        PRINAM
     C   49              Z-ADD     0             INTDUE
      *
     C     NXTAMX        TAG
     C                   Z-ADD     NAAD          DAVD                     28
     C                   Z-ADD     NASN          DASN
     C                   GOTO      LOOP1
      *
      ** Write 'M1' event record
     C     ENDCNX        TAG
     C                   MOVE      *OFF          *IN06
      *
     C                   Z-ADD     PRINAM        PCPL
      *
      ** Calculate interest at maturity
     C                   Z-ADD     IACD          ZIBEG
     C                   Z-ADD     MDAT          ZIEND
     C                   Z-ADD     PCPL          ZIAMT
      *
     C                   EXSR      GLINTC
      *
      ** If loan/deposit with round down interest = 'Y'
     C     JRDFC         IFEQ      'Y'
     C     INTDUE        ADD       ZINTR         INTDUE
     C                   ELSE
     C     INTDUE        ADD(H)    ZINTR         INTDUE
     C                   ENDIF
      *
      ** If interest is capitalised add to principal
     C   59PCPL          ADD       INTDUE        PCPL
     C   59              Z-ADD     0             INTDUE
      *
     C     ENDN          TAG
      *
     C                   MOVE      'M1'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
      *
     C     *IN88         IFEQ      '0'
     C  N59              MOVE      'M2'          KEY
     C  N59              EXSR      #EEVNT
     C                   ENDIF
      *
     C                   GOTO      END
      *
     C     BYPASS        TAG
      *
      ** Check for interest frequency 'N'
     C                   MOVE      '0'           *IN88
     C     IPFR          IFEQ      'N'
     C                   MOVE      '1'           *IN88
     C                   MOVE      'L'           IPFR
     C                   ENDIF
      *
     C                   MOVE      'V1'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
      *
      ** If next interest date greater than E.C.D., write 'I2' record
     C                   Z-ADD     0             TOTINT           13 0
      *
     C     NIDT          COMP      ECD                                53
     C   53              MOVE      *ON           *IN33
     C   53              EXSR      #EINTR
     C   53              MOVE      *OFF          *IN33
     C   53              Z-ADD     NIDT          TODATE
     C   53              MOVE      'I2'          KEY
     C   53              EXSR      #EEVNT
     C   U7              GOTO      END
     C   53TOTINT        ADD       INTDUE        TOTINT
      *
      ** Bypass interim interest processing for frequency 'N'
      ** if next interest date is past maturity date
      *
     C     *IN88         IFEQ      '1'
     C     NIDT          IFGE      MDAT
     C                   GOTO      NOINTR
     C                   ENDIF
     C                   ENDIF
      *
      ** Bypass interim interest processing for frequency 'N' if
      ** next interest date is zero
     C     *IN88         IFEQ      '1'
     C     NIDT          IFEQ      0
     C                   GOTO      NOINTR
     C                   ENDIF
     C                   ENDIF
      *
      ** Calculate interest date and interest due at maturity
     C  N26
     CORN28              EXSR      #EINTD
     C   U7              MOVEL     '#EINTD'      UIERR
     C   U7              MOVE      DAMKEZ        UIERR
     C   U7              GOTO      END
      *
     C     NOINTR        TAG
      *
      ** Set interest due to zero for interest frequency 'N'
     C     *IN88         IFEQ      '1'
     C                   MOVE      *ZEROS        INTDUE
     C                   GOTO      NOINTD
     C                   ENDIF
      *
     C                   TESTB     '2'           DNSI                     50
     C  N50TOTI          SUB       IPRD          INTDUE
     C  N50INTDUE        SUB       TOTINT        INTDUE
     C   50              EXSR      #EINTR
     C   50INTDUE        SUB       TOTINT        INTDUE
      *
     C     NOINTD        TAG
      *
      ** Write maturity event records
      *
     C                   MOVE      'M1'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
      *
     C     *IN88         IFEQ      '0'
     C                   MOVE      'M2'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
     C                   ENDIF
      *
     C                   GOTO      END
      *
      *    C A L L / N O T I C E
     C     CALNOT        TAG
      *
     C                   TESTB     '1'           DSTI                     41
      *
     C                   MOVE      'V1'          KEY
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
     C                   Z-ADD     0             TOTPRN           13 0
     C   28              GOTO      ENDCN
      *
     C                   Z-ADD     DAVD          DATE
     C                   Z-ADD     DASN          SEQNO
      *
      ** Chain to deals amendment file and write event records
     C     AMDEV         TAG
     C                   EXSR      #EDCHN
     C   U7              MOVEL     'DEAMS'       UIERR
     C   U7              MOVE      DAMKEZ        UIERR
     C   U7              GOTO      END
      *
      *  if no deal amendments exist
     C     *IN50         IFEQ      '1'
     C                   GOTO      ENDCN
     C                   ENDIF
      ** If deal amendment reversed, get next deal amendment record
     C   11              GOTO      NXTAMD
     C     VDATM         COMP      NIDT                               65
      *
      ** If value date > next working date, skip this amendment record
     C   65              GOTO      NXTAMD
     C     AMTP          COMP      'PD'                                   50
     C     AMTP          COMP      'PI'                                   51
     C   50              MOVE      'M4'          KEY
     C   51              MOVE      'V3'          KEY
     C   50
     COR 51              EXSR      #EEVNT
     C   U7              GOTO      END
     C     AMTP          COMP      'PD'                                   50
     C     AMTP          COMP      'PI'                                   51
      *
      ** If the deal amendment value date is less than the next
      ** interest payment date on the deal (If it is defined)
     C     VDATM         IFLE      NIDT
     C     NIDT          OREQ      *ZERO
      *
      ** Calculate interest due as at this deal amendment value date
     C                   Z-ADD     IACD          ZIBEG
     C                   Z-ADD     VDATM         ZIEND
     C     PCPL          ADD       TOTPRN        ZIAMT
      *
     C                   EXSR      GLINTC
      *
     C     AITC          ADD(H)    ZINTR         AITC
     C                   Z-ADD     ZIEND         IACD
     C     AITC          ADD       AIAN          INTDUE
     C                   ADD       AIAP          INTDUE
     C                   SUB       IPRD          INTDUE
     C                   SUB       ICTD          INTDUE
      *
      ** Maintain total of changes to principal (+ interest capitialized)
     C     AMTP          IFEQ      'PI'
     C                   ADD       DAAM          TOTPRN
     C                   ENDIF
      *
     C     AMTP          IFEQ      'PD'
     C                   SUB       DAAM          TOTPRN
     C                   ENDIF
      *
     C     AMTP          IFEQ      'CI'
     C                   ADD       INTDUE        TOTPRN
     C                   ADD       INTDUE        ICTD
     C                   ENDIF
      *
      ** Update effective interest rate if amendment is a rate change
     C     AMTP          IFEQ      'SC'
     C     RTSP          ADD       BRTE          INTR
     C                   ENDIF
      *
      ** If amendment is settle interest, generate an interest due evenT
      ** - amendment amount carries the interest due and maintain
      ** interest paid/received
     C     AMTP          IFEQ      'SI'
     C                   MOVE      'I2'          KEY
     C                   Z-ADD     DAAM          INTDUE
     C                   Z-ADD     VDATM         TODATE
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
     C                   ADD       INTDUE        IPRD
     C                   ENDIF
     C                   ENDIF
      *
     C     NXTAMD        TAG
     C                   Z-ADD     NAAD          DATE                 50
     C                   Z-ADD     NASN          SEQNO
     C   50              GOTO      AMDEV
      *
     C     ENDCN         TAG
      *
      ** If the next interest payment date on the deal is defined
      ** generate an interest due event
     C     NIDT          IFNE      *ZERO
     C     NIDT          OREQ      *ZERO
     C     NOTD          ANDNE     *ZERO
     C                   MOVE      *OFF          *IN06
     C                   Z-ADD     IACD          ZIBEG
     C     NIDT          IFNE      *ZERO
     C                   Z-ADD     NIDT          ZIEND
     C                   ELSE
     C     IACD          ADD       NOTD          ZIEND
     C                   ENDIF
     C     PCPL          ADD       TOTPRN        ZIAMT
      *
     C                   EXSR      GLINTC
      *
     C     AITC          ADD(H)    ZINTR         INTDUE
     C                   ADD       AIAN          INTDUE
     C                   ADD       AIAP          INTDUE
     C                   SUB       IPRD          INTDUE
     C                   SUB       ICTD          INTDUE
     C                   MOVE      'I2'          KEY
     C                   Z-ADD     ZIEND         TODATE
     C                   EXSR      #EEVNT
     C   U7              GOTO      END
     C                   ENDIF
      *
     C     PCPL          ADD       TOTPRN        PCPL
     C                   Z-ADD     *ZERO         INTDUE
     C                   MOVE      *OFF          *IN06
     C                   MOVE      'M1'          KEY
     C                   EXSR      #EEVNT
      *
     C     END           TAG
      *
     C     *INU7         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C                   ELSE
     C                   EXSR      SRAPR
     C                   ENDIF
     C                   MOVE      *BLANK        RECISV
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAPR:     Call GL000050 to get the rate                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRAPR         BEGSR
      *
      ** When all data written to GLAPRCTD, call GL000050 to get rate
      ** Only call GL000050 if record have been written to GLAPRCTD
     C     *IN60         IFEQ      *ON
     C                   CLOSE     GLAPRCTD
      * Set day number basis
     C     ICBS          IFEQ      1
     C     ICBS          OREQ      4
     C                   MOVE      '365'         AEDNB
     C                   ENDIF
      *
     C     ICBS          IFEQ      2
     C     ICBS          OREQ      3
     C     ICBS          OREQ      5
     C     ICBS          OREQ      7
     C                   MOVE      '360'         AEDNB
     C                   ENDIF
      *
     C     ICBS          IFEQ      6
     C                   MOVE      '366'         AEDNB
     C                   ENDIF
      *
     C                   EVAL      AERATE = *BLANKS                                      MD054017
     C                   IF        SYSVAL1 = 'Y' OR SYSVAL2  = 'Y'                       MD054017
     C                   IF        SYSVAL3 <> *BLANKS                                    MD054017
     C                   EVAL      SYSVAL3A = *BLANKS                                    MD054017
     C                   EVAL      SYSVAL3A = %XLATE(LO:UP:SYSVAL3)                      MD054017
     C                   IF        SYSVAL3A = 'SPAIN'                                    MD054017
     C                   CALL      'GL000050'
     C                   PARM      *BLANKS       AERATE            6
     C                   PARM                    AEDNB             3
     C                   ENDIF                                                           MD054017
     C                   ENDIF                                                           MD054017
     C                   ENDIF                                                           MD054017
      *
     C                   MOVEL     AERATE        AERATM            1
     C                   MOVE      AERATE        AERATF            5 0
      *
     C     AERATM        IFEQ      '-'                                          -ve rate
     C                   Z-SUB     AERATF        AERATN
     C                   ELSE
     C                   MOVE      AERATE        AERATN            6 0
     C                   ENDIF
      *
     C     AERATN        DIV       100           NAERAT            6 2
      *
      ** Only write new rate if different to last or no last exists
      ** Access rates history file
     C     DLKEY         SETLL     DLAPRHD0
     C                   READ      DLAPRHD0                               55
     C     *IN55         IFEQ      '1'                                          not found
     C     *IN55         OREQ      '0'                                          same loan &
     C     DLNO          ANDEQ     IDLNO                                        date
     C     RUND          ANDEQ     IAPRD                                        different
     C     NAERAT        ANDNE     IAPRR                                        rate
     C     *IN55         OREQ      '0'
     C     DLNO          ANDEQ     IDLNO
     C     RUND          ANDNE     IAPRD
     C     *IN55         OREQ      '0'
     C     DLNO          ANDNE     IDLNO
      *
      ** Add sequence number
     C     *IN55         IFEQ      '1'
     C     DLNO          ORNE      IDLNO
     C     RUND          ORNE      IAPRD
     C                   Z-ADD     1             ITSEQ
     C                   ELSE
     C                   ADD       1             ITSEQ
     C                   END
      *
      ** write new rate
     C                   Z-ADD     DLNO          IDLNO
     C                   Z-ADD     RUND          IAPRD
     C                   Z-ADD     NAERAT        IAPRR
     C                   WRITE     DLAPRHD1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
     C   U7              MOVE      '*ERROR '     UIECOD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EEVNT:    Event Currency                                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #EEVNT        BEGSR
      *
     C     FACT          IFGT      0
     C                   MOVE      *ON           *IN23
     C                   ENDIF
      *
      ** Find field values from tables - see comments in extension specs
     C                   MOVE      ' '           EXEI              1
      *
     C     KEY           LOOKUP    TAB1          TAB2                     50
     C  N50              GOTO      ENDEV
     C                   MOVE      TAB2          KEYDS                          Data structure
      *
      ** Event type
     C                   MOVE      KEY           EVCODE            4
     C                   MOVEL     NN            EVCODE
      *
     C                   MOVEL     CODE2         UICOD             1
      *
     C     UICOD         IFEQ      'V'                                          b1
     C     CODE2         IFNE      'V3'                                         b2
      * value date
     C                   Z-ADD     0             APRDAY
     C                   ELSE                                                   x2
      * amendment value date
     C     VDATM         SUB       VDAT          APRDAY
     C                   ENDIF                                                  e2
     C                   ELSE                                                   x1
      * maturity or interest
     C     CODE2         IFEQ      'M4'                                         b2
     C     VDATM         SUB       VDAT          APRDAY
     C                   ELSE                                                   x2
     C     MDAT          IFEQ      0                                            b3
     C     NIDT          IFEQ      0                                            b4
     C                   Z-ADD     NOTD          APRDAY
     C                   ELSE                                                   x4
     C     NIDT          SUB       VDAT          APRDAY
     C                   ENDIF                                                  e4
     C                   ELSE                                                   x3
     C     MDAT          SUB       VDAT          APRDAY
     C                   ENDIF                                                  e3
     C                   ENDIF                                                  e2
     C                   ENDIF                                                  e1
      *
     C     UICOD         IFEQ      'I'
     C     ZIEND         SUB       VDAT          APRDAY
     C                   ENDIF
      *
     C     S01434        IFEQ      'Y'
     C     RBDN          IFNE      0
      *
     C     IPDS          IFEQ      'Y'
     C     EVCODE        IFEQ      '15M2'
     C     EVCODE        OREQ      '16M2'
     C                   MOVE      '2'           SIIND
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      IPDS          IPSI              1
     C                   ENDIF
     C                   ENDIF
      *
      ** Event Date
     C     ED            COMP      4                                      50
     C     MDAT          IFGT      0
     C                   MOVE      *ON           *IN22
     C                   ENDIF
      *
     C   50
     CAN 22              Z-ADD     3             ED
      *
      ** Event Amount
     C     EA            COMP      9                                      50
     C   50              Z-ADD     3             EA
      *
      ** Event Currency
     C                   EXSR      #EQCCY
     C                   MOVE      OTHCCY        EVCCY             3
      *
      ** Event amount for loans/deposits
      ** If front-up interest = Y and M2 event, set equal to zero
     C     NN            IFEQ      '15'
     C     NN            OREQ      '16'
     C     FUID          IFEQ      'Y'
     C     CODE2         ANDEQ     'M2'
     C                   Z-ADD     1             EA
     C                   ENDIF
     C                   ENDIF
     C*
     C*    OTHER CCY
     C                   MOVE      OC            EC
     C                   EXSR      #EQCCY
      *
      ** Other amount for loans/deposits
     C     NN            IFEQ      '15'
     C     NN            OREQ      '16'
      *
      ** If front-up interest = Y and V1 event, set equal to interest
      ** If front-up interest = Y and M1 event, set equal to zero
     C     FUID          IFEQ      'Y'
     C     CODE2         IFEQ      'V1'
     C                   Z-ADD     7             OA
     C                   Z-ADD     TOTI          INTDUE
     C                   ENDIF
      *
     C     CODE2         IFEQ      'M1'
     C                   Z-ADD     1             OA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             I
     C     EVCCY         LOOKUP    CY(I)                                  50
     C     *IN50         IFEQ      '1'
     C                   MOVE      CYD(I)        CYDDS
      *
      ** Error if not found
     C                   ELSE
     C                   MOVE      '1'           *INU7
     C                   MOVEL     'NO CCY'      UIERR
     C                   MOVE      EVCCY         UIERR
     C                   GOTO      ENDEV
     C                   ENDIF
      *
      ** Check mult/div indicator
     C     MDIN          COMP      0                                      87
      *
      ** Spot limit CCY equiv of event amount
     C     EVCCY         COMP      BNCYCD                                 50
     C   50              Z-ADD     AMT(EA)       LCEQ
     C   50              GOTO      SETDE
     C   50              Z-ADD     AMT(OA)       LCEQ
     C   50              GOTO      SETDE
     C     CDP           SUB       LMD           N                 1 0  35
     C     N             ADD       4             N
     C   87ERLC          MULT      POWER(N)      WK159            15 9
     C   87AMT(EA)       DIV(H)    WK159         LCEQ             13 0
     C  N87ERLC          DIV       POWER(N)      WK159
     C  N87AMT(EA)       MULT(H)   WK159         LCEQ
      *
      ** Settlement details - see data structure - and full
      ** instructions present indicator
     C     SETDE         TAG
     C                   MOVE      *BLANKS       SETTLE
     C                   z-add     0             SETTYP
     C                   MOVE      *BLANKS       @SBR              3
     C                   MOVE      ' '           FIPI              1
      *
     C     SIIND         COMP      '0'                                    50
     C   50              GOTO      ROLLOV
     C     SIIND         COMP      '3'                                52  50
     C                   If        SETDM = *Blanks
     C                   z-add     0             SETPM
     C                   Endif
     C   50
     COR 52
     CAN 06              MOVE      SETDM         SETTLE                         Amendment rec.
     C   50
     COR 52
     CAN 06              MOVE      OSBR          @SBR                           Amendment rec.
     C     SIIND         COMP      '2'                                  5051
     C                   If        SETST = *Blanks
     C                   z-add     0             PCST
     C                   Endif
     C   50              MOVE      SETST         SETTLE                         Start/purchase
     C                   If        SETMAT = *Blanks
     C                   z-add     0             SCST
     C                   Endif
     C   51
     COR 52
     CANN06              MOVE      SETMAT        SETTLE                         Maturity/sale
      *
     C     IOIND         IFEQ      'I'
     C                   MOVE      ROBR          @SBR
     C                   ENDIF
      *
     C     IOIND         IFEQ      'O'
     C                   MOVE      POBR          @SBR
     C                   ENDIF
      *
     C                   MOVE      @SBR          OSBR
      *
     C     OSBR          IFEQ      ' '
     C     SETTYP        IFEQ      1
     C     SETTYP        OREQ      7
     C     SETTYP        OREQ      8
     C                   MOVEL     SETAC         @KEYE
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      CCY           @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM                    @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   Z-ADD     15            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      A7BRCD        OSBR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Indicator 54 chould be set off, otherwise may be left on
     C                   MOVE      '0'           *IN54
      *
     C     SETTYP        COMP      1                                    5051
     C  N51SETTYP        COMP      7                                      51
     C  N51SETTYP        COMP      8                                      51
     C  N50SETAC         COMP      ' '                                    50
     C   51
     CANN50SETNOS        COMP      ' '                                    50
     C  N51SETTYP        COMP      3                                      54
     C  N51
     CANN54SETTYP        COMP      6                                      54
     C   54              MOVE      *OFF          *IN50
     C   50              MOVE      'N'           FIPI
     C  N50              MOVE      'Y'           FIPI
      *
      ** Rollover indicator
     C     ROLLOV        TAG
      *
     C     RODN          IFGT      0
     C                   MOVE      *ON           *IN24
     C                   ENDIF
      *
     C     RBDN          IFGT      0
     C                   MOVE      *ON           *IN25
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN42
     C   25CODE2         COMP      'M1'                                   42
     C   25
     CANN42CODE2         COMP      'M2'                                   42
     C   24
     CANN42CODE2         COMP      'V1'                                   42
      *
      ** Deal amendment sequence number
     C  N06              Z-ADD     0             OTDASN            3 0
     C   06              Z-ADD     DASN          OTDASN
      *
      ** Federal funds value date and indicator
     C                   Z-ADD     DAT(ED)       FFVD              5 0
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN43
     C                   TESTB     '2'           DSTI                     56
     C                   MOVE      ' '           FFIN              1
     C                   MOVE      ' '           OCFF              1
     C                   EXSR      #EFEDT
      *
      ** For account of, special instructions
     C     IOIND         COMP      'O'                                    44
     C   44
     CANN06              MOVE      FACO          OTFACO           10
     C   44
     CANN06              MOVE      SPI           OTSPI            35
      *
      ** TO move company code for booking branch and set up event
      ** branch company
     C                   MOVE      *BLANKS       COBB              3
     C                   MOVE      *BLANKS       ECPY              3
     C                   MOVE      BRCA          EBRC              3
     C                   Z-ADD     1             X
     C     BRCA          LOOKUP    BR(X)                                  55
      *
     C     *IN55         IFEQ      '1'
     C                   MOVE      CO(X)         COBB
     C                   MOVE      CO(X)         ECPY
     C                   MOVE      IC(X)         WRKCNO            6
     C                   ENDIF
      *
      ** To move company code for originating branch
     C                   MOVE      *BLANKS       COOB              3
     C                   Z-ADD     1             X
     C     ORBR          LOOKUP    BR(X)                                  55
     C     *IN55         IFEQ      '1'
     C                   MOVE      CO(X)         COOB
     C                   ENDIF
      *
      ** Check to see if the event date is equal
      ** the date next working day
     C   U1DAT(ED)       COMP      BJDNWD                                 63
      *
      ** Write record to file
     C                   MOVE      CUSTNO        CNMR              6
     C                   MOVE      IOIND         @INOI             1
     C                   MOVE      'N'           IBRE              1
     C                   MOVE      'Y'           ICYE              1
      *
      ** Set Suppress Revaluation Flag
     C                   MOVE      ' '           RSUPR             1
      *
     C                   Z-ADD     AMT(EA)       EVAMNT           13 0
     C                   EXSR      #ERCT
      *
     C                   MOVE      *OFF          *IN06
     C                   MOVE      *OFF          *IN44
     C                   MOVE      *OFF          *IN63
      *
     C     ENDEV         ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ERCT:     Event Currency                                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #ERCT         BEGSR
      *
      * Do not write 'V1' records if history has been written
     C     *IN62         IFEQ      *OFF
     C     *IN62         OREQ      *ON
     C     CODE2         ANDNE     'V1'
      *
     C                   MOVE      IOIND         INOUT             1
      *
      ** Reverse value of IN/OUT indicator if event amount negative
     C     EVAMNT        IFLT      0
     C                   Z-SUB     EVAMNT        EVAMNT
     C                   ENDIF
      *
      ** Output record to file GLAPRCTD if 'INOUT' not blank and the
      ** amount is not zero
     C     INOUT         IFNE      ' '
     C     EVAMNT        ANDNE     0
      *
      ** Open the file if *IN60 is off
     C     *IN60         IFEQ      *OFF
     C                   OPEN      GLAPRCTD
     C                   ENDIF
     C                   MOVE      INOUT         APRTYP
     C                   MOVE      EVAMNT        APRAMT
     C                   WRITE     GLAPRCD0
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EQCCY:    Event Currency                                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EQCCY        BEGSR
     C                   MOVE      '   '         OTHCCY            3
     C     EC            COMP      'D'                                51  50
     C   50              MOVE      CCY           OTHCCY
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN52
     C*  51      EC        COMP 'P'                  525051
     C*  50                MOVE SPLC      OTHCCY
     C*  51                MOVE PUCY      OTHCCY
     C*  52                MOVE SLCY      OTHCCY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EINTT:    Calaulate interest date for deal or deal amend     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EINTD        BEGSR
      *
     C     SADT          IFGT      0
     C                   MOVE      *ON           *IN29
     C                   ENDIF
      *
     C     *IN26         IFEQ      *OFF
      *
      ** Bypass if next interest is zero
     C     NIDT          IFNE      0
      *
      ** RR - Interest date for deal
     C                   MOVE      CCY           ZCCY
     C                   Z-ADD     IBDT          DATE1             5 0
     C                   Z-ADD     NIDT          FROMDT            5 0
     C                   Z-ADD     INTF          INTF1             2 0
     C                   Z-ADD     INTF1         ZMDAY
      * zeroise count of loop occurrencies
     C                   Z-ADD     0             COUNT1            5 0
      *
      ** Calculate base date - Date1 - and to-date
     C     REPEAT        TAG
     C                   Z-ADD     DATE1         ZDAYNO
      *
      ** Check whether loan or deposit in order to set up location
     C     PCPL          IFGT      0
      *
      ** Set up location - if Our PAY Settlement
      ** Method is a nostro then use nostro code and currency to find
      ** Nostro Location
     C     PSTM          IFEQ      01
     C     PSTM          OREQ      02
     C     PSTM          OREQ      07
     C     PSTM          OREQ      08
     C     PSTM          OREQ      12
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      CCY           @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PONS          @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   Z-ADD     16            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
     C                   ELSE
      *
      **  PCPL is less than zero so deal is a loan
      ** Set up location - if Our receive Settlement
      ** Method is a nostro then use nostro code and currency to find
      ** Nostro Location
     C     RSTM          IFEQ      01
     C     RSTM          OREQ      02
     C     RSTM          OREQ      07
     C     RSTM          OREQ      08
     C     RSTM          OREQ      12
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      CCY           @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      RONS          @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   Z-ADD     17            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      ZFREQB
     C                   Z-ADD     ZDAYNO        DATE1
      * increment count of loop occurrencies
     C                   ADD       1             COUNT1
      *
      ** ZFREQ may retain a non-working day for FREQ W,F,S,R and L
      ** check with ZDATE5 and get next working day
     C     ZFREQ         LOOKUP    FRQ                                    50
      *
      ** Leave date unchanged, if interest frequency 'N'
     C     *IN88         IFEQ      '1'
     C                   MOVE      '0'           *IN50
     C                   ENDIF
      *
     C     *IN50         IFEQ      '1'
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        TODATE
     C                   ELSE
      * check if loop to be broken
     C     COUNT1        IFGT      0
     C     ZFREQ         ANDEQ     ' '
     C     ZDAYNO        ANDEQ     TODATE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        TODATE
     C                   ENDIF
      *
      ** Finish if NA purchased with non-zero sale date, or
      ** otherwise if to-date equal to or greater than maturity date
     C  N29TODATE        COMP      MDAT                               50  50
     C   29TODATE        COMP      SADT                               50
      *
      ** Calculate interin interest, if interest frequency 'N'
     C   50              EXSR      #EINTT
     C   50              GOTO      ENDDAT
      *
      ** Calculate interim interest and rate 'I2' event record
     C                   Z-ADD     PCPL          ZIAMT
     C                   EXSR      #EINTM
     C                   Z-ADD     TODATE        FROMDT
     C                   GOTO      REPEAT
      *
      ** SS - deal amendment interest date
     C                   ENDIF
      *
     C                   Z-ADD     NIDT          FROMDT                   50
     C   50              Z-ADD     SLID          FROMDT
     C                   Z-ADD     DAVD          DATE
     C                   Z-ADD     DASN          SEQNO
      *
      ** Chain to deals amendment file
     C     RECALC        TAG
     C                   EXSR      #EDCHN
     C   U7              GOTO      ENDDAT
      *
      *  if no deal amendments exist
     C     *IN50         IFEQ      '1'
     C                   GOTO      ENDDAT
     C                   ENDIF
      ** If deal amendment live, & if amend type 'SI', find interim
      ** interest & write 'I2' record
     C     AMTP          COMP      'SI'                                   50
     C   50              Z-ADD     VDATM         TODATE
     C   50              Z-ADD     PCPL          ZIAMT
     C   50
     CAN 06              EXSR      #EINTM
      *
     C                   Z-ADD     TODATE        FROMDT
     C                   Z-ADD     NAAD          DATE                 50
     C                   Z-ADD     NASN          SEQNO
     C   50              GOTO      RECALC
     C                   ENDIF
      *
     C     ENDDAT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EINTT:    Calaulate interest due at maturity                 *
      *            write '12' event record fot interest frequency 'N' *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EINTT        BEGSR
      *
      ** Store status of *IN50 which is a work indicator in subroutine
      ** EVENT
     C                   MOVE      '0'           IND50             1
     C   50              MOVE      '1'           IND50
      *
     C     *IN88         IFEQ      *ON
     C     MDAT          IFNE      *ZEROS
      *
     C                   TESTB     '2'           DNSI                     51
      *
     C     *IN51         IFEQ      *OFF
     C     TOTI          SUB       IPRD          INTDUE
     C     INTDUE        SUB       TOTINT        INTDUE
     C                   ENDIF
      *
     C     *IN51         IFEQ      *ON
     C                   Z-ADD     IACD          ZIBEG
     C                   Z-ADD     MDAT          ZIEND
     C                   Z-ADD     PCPL          ZIAMT
      *
     C                   EXSR      GLINTC
      *
     C                   Z-ADD(H)  ZINTR         INTDUE
     C     INTDUE        ADD       AITC          INTDUE
     C     INTDUE        ADD       AIAN          INTDUE
     C     INTDUE        ADD       AIAP          INTDUE
     C     INTDUE        SUB       IPRD          INTDUE
     C     INTDUE        SUB       ICTD          INTDUE
     C     INTDUE        SUB       TOTINT        INTDUE
     C                   ENDIF
      *
     C                   MOVE      'I2'          KEY
     C                   EXSR      #EEVNT
      *
      ** Restore status of *IN50
     C     IND50         IFEQ      *ON
     C                   MOVE      *ON           *IN50
     C                   ELSE
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EINTM:    Calaulate interest due at interim interest dates   *
      *            write '12' event record, and keep interest total   *
      *            for fixed L/D                                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EINTM        BEGSR
     C                   Z-ADD     FROMDT        ZIBEG
     C                   Z-ADD     TODATE        ZIEND
      *
     C                   EXSR      GLINTC
      *
      ** If loan/deposit or NA purchased with round down intere
     C     JRDFC         IFEQ      'Y'
     C                   Z-ADD     ZINTR         INTDUE
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         INTDUE
     C                   ENDIF
      *
     C                   MOVE      'I2'          KEY
     C                   EXSR      #EEVNT
      *
     C     TOTINT        ADD       INTDUE        TOTINT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EINTR:    Calculate interest due at next interest date       *
      *            BB - For fixed loans and deposits                  *
      *            CC - For negotiable assets purchased               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EINTR        BEGSR
      *
      ** Get interest calculated
     C                   Z-ADD     IACD          ZIBEG
     C  N33              Z-ADD     MDAT          ZIEND
     C   33              Z-ADD     NIDT          ZIEND
      *
      ** Use Maturity date, if next interest date is greater
     C     *IN88         IFEQ      '1'
     C     NIDT          IFGT      MDAT
     C                   Z-ADD     MDAT          ZIEND
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     PCPL          ZIAMT
      *
     C                   EXSR      GLINTC
      *
      ** If loan/deposit or NA purchased with round down interest = 'Y'
     C     JRDFC         IFEQ      'Y'
     C                   Z-ADD     ZINTR         INTDUE
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         INTDUE
     C                   ENDIF
      *
      ** Accrued interest adjustment posted or not posted to be
      ** included for negotiable assets purchased
      *
      ** Get interest due for fixed loan/deposit & negotiable a
      ** purchased
     C     INTDUE        ADD       AIAN          INTDUE
     C     INTDUE        ADD       AIAP          INTDUE
      *
      ** Exclude this if calculation is for negotiable assets purchased
      ** (*IN03  = 1)
     C     INTDUE        ADD       AITC          INTDUE
     C     INTDUE        SUB       IPRD          INTDUE
     C     INTDUE        SUB       ICTD          INTDUE
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EDCHN:    Subroutine to find a deal amendment                *
      *                                                               *
      * Called By:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #EDCHN        BEGSR
      *
     C                   MOVE      *OFF          *IN06
     C                   MOVE      *OFF          *IN11
     C                   Z-ADD     UIDLNO        DLNO
     C     DAMKEY        CHAIN     DEAMS                              50
      *
     C     *IN50         IFEQ      *OFF
     C     RECI          IFEQ      'D'
     C                   MOVE      *ON           *IN06
     C                   ENDIF
      *
     C     RECI          IFEQ      'R'
     C                   MOVE      *ON           *IN11
     C                   ENDIF
      *
     C     *IN06         IFEQ      *OFF
     C     *IN11         ANDEQ     *OFF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #ECLIN:    Subroutine to calculate federal fund value date for*
      *            event record                                       *
      *                                                               *
      * Called By:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #ECLIN        BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'DL6004'      DBPGM
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     18            DBASE
     C                   MOVEL     @KEY1         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #EFEDT:    Subroutine to calculate federal fund value date for*
      *            event record                                       *
      *                                                               *
      * Called By:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #EFEDT        BEGSR
      *
     C     EVCCY         IFEQ      BLUSCY
      *
     C     *IN56         IFEQ      *ON
     C     *IN57         OREQ      *ON
     C                   MOVE      'F'           FFIN
     C                   ENDIF
      *
      ** Ignore specific federal fund processing for event dates on or
      ** after 01 October 81 (=03562).
     C     DAT(ED)       IFLT      3562
     C                   MOVE      EVCCY         ZCCY
     C                   Z-ADD     DAT(ED)       ZDAYNO
      *
      ** Federal fund indicator = Y
     C     BLFFIN        IFNE      'Y'
      *
     C     *IN56         IFEQ      *OFF
     C     *IN57         OREQ      *OFF
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        FFVD
     C                   ENDIF
     C                   ELSE
      *
     C     *IN56         IFEQ      *ON
     C     *IN57         ANDEQ     *ON
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        FFVD
     C                   ENDIF
     C                   ENDIF
      *
     C     FFVD          IFLT      0
     C                   Z-ADD     0             FFVD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     OTHCCY        IFLT      BLUSCY
      *
     C     *IN56         IFEQ      *ON
     C     *IN57         OREQ      *ON
     C                   MOVE      'F'           OCFF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *    SUBROUTINE - PROCESS HISTORY DETAILS
      *
     C     PROHIS        BEGSR
      *
      *    LOOP WHILE VALID HISTORY RECORDS READ
     C     *IN58         DOWEQ     *OFF
      *
      *    PROCESS A VALID HISTORY RECORD
     C                   EXSR      PROCSS
      *
      *    GET NEXT VALID RECORD TO PROCESS
     C                   EXSR      NXTREC
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      *      PROCSS SR  PROCESS EVENT RECORD.
      *
     C     PROCSS        BEGSR                                                  *** PROCSS ***
      *
      *    SET EVENT DAYS AND AMOUNT
     C     EDAT          SUB       VDAT          APRDAY
     C                   Z-ADD     EAMT          EVAMNT
      *
      *    FORMAT EVENT FLOW INDICATOR
     C     RTYP          IFEQ      'LD'
     C     RTYP          OREQ      'RO'
     C     RTYP          OREQ      'PI'
     C                   MOVE      'I'           IOIND
     C                   ELSE
     C                   MOVE      'O'           IOIND
     C                   ENDIF
     C*****HDTYP         Ifeq      'CL'                                                     MD054544
     C*****HDTYP         oreq      'LN'                                                     MD054544
     C     HDTYP         IFEQ      'LN'                                                     MD054544
     C*****HDTYP         OREQ      'DL'                                            MD054107 MD054479
     C*****HDTYP         OREQ      'TI'                                            MD054107 MD054479
     C*****HDTYP         OREQ      'IP'                                            MD054107 MD054479
     C     RTYP          Ifeq      'LD'
     C     RTYP          oreq      'RO'
     C     RTYP          oreq      'PI'
     C                   Move      'O'           IOIND
     C                   Else
     C                   Move      'I'           IOIND
     C                   Endif
     C                   Endif
      *
      *    WRITE HISTORY RECORD TO TEMPORARY EVENTS FILE
     C     EVAMNT        IFNE      0
     C                   MOVE      *ON           *IN62
     C                   EXSR      #ERCT
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      *    FIND THE NEXT VALID HISTORY RECORD - *IN58 = NO RECORD
      *
     C     NXTREC        BEGSR
      *
     C     NXTTAG        TAG
      *
     C     HISKY1        READE     DLHISTI0                               58
      *
     C     *IN58         IFEQ      *OFF
      *
      *    CHECK THAT DATE IS NOT LATER THAN RUN DATE AND THAT
      *    RECORD TYPE IS ONE TO BE PROCESSED
     C     EDAT          IFLE      RUND
     C     RTYP          IFEQ      'LD'
     C     RTYP          OREQ      'RO'
     C     RTYP          OREQ      'IP'
     C     RTYP          OREQ      'PI'
     C     RTYP          OREQ      'PD'
     C     RTYP          OREQ      'MA'
      *    EXIT WITH A VALID RECORD
     C                   GOTO      NXTEND
     C                   ELSE
      *    OR TRY AGAIN
     C                   GOTO      NXTTAG
     C                   END
      *    END OF HISTORY BEFORE RUND
     C                   ELSE
     C                   MOVE      *ON           *IN58
     C                   END
      *
     C                   END
      *
     C     NXTEND        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR: Program exception error routine. Called automatically  *
      *        if a program error occurs, or directly by the program  *
      *        code using EXSR. This subroutine DUMPs the program     *
      *        just once.                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
      *
     C     DBASE         IFEQ      0
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  @FILE         DBFILE
     C                   Z-ADD     999           DBASE
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZFWDT_ILE
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,GLINTCZ1LE
     C/COPY ZSRSRC,ZFREQBZ2LE
      *****************************************************************
     X/COPY ZSRSRC,ZDATE2Z3
     X/COPY ZSRSRC,ZFREQBZ3
     X/COPY ZSRSRC,ZDATE9Z4
     X/COPY ZSRSRC,ZPOWERZ2
**  TAB1 & TAB2   -   See comments in extension speca for key to values
IPV11522D1 3I1I              ***PREVIOUSLY*3I1O                                    MD054107 MD054479
IPI21557D1 1I4O              **************1I4I                                    MD054107 MD054479
IPM11532D7 2I2O              **************2I2I                                    MD054107 MD054479
IPM21537D2 1I0O              **************1I0I                                    MD054107 MD054479
TIV11522D1 3I1I              ***PREVIOUSLY*3I1O                                    MD054107 MD054479
TII21557D1 1I4O              **************1I4I                                    MD054107 MD054479
TIM11532D7 2I2O              **************2I2I                                    MD054107 MD054479
TIM21537D2 1I0O              **************1I0I                                    MD054107 MD054479
LNV11522D1 3I1O
LNI21557D1 1I4I
LNM11532D7 2I2I
LNM21537D2 1I0I
CLV11522D1 1I1I                                                                             MD054479
CLI21557D1 1I4O                                                                             MD054479
CLM11542D7 2I2O              ** PREVIOUSLY CLM11542D1                                       MD054479
CLM21537D2 1I0O                                                                             MD054479
CLV31574D2 1I3I                                                                             MD054479
CLM41574D2 1I3O                                                                             MD054479
DLV11522D1 1I1O
DLI21557D1 1I4I
DLM11542D7 2I2I              ** PREVIOUSLY DLM11542D1
DLM21537D2 1I0I
DLV31574D2 1I3O
DLM41574D2 1I3I
ITV11622D1 3I1I
ITI21657D1 1I4O
ITM11632D7 2I2O
ITM21637D2 1I0O
TDV11622D1 3I1I
TDI21657D1 1I4O
TDM11632D7 2I2O
TDM21637D2 1I0O
CIV11622D1 3I1I
CII21657D1 1I4O
CIM11632D7 2I2O
CIM21637D2 1I0O
CDV11622D1 1I1I
CDI21657D1 1I4O
CDM11642D7 2I2O              ** PREVIOUSLY CDM11642D1
CDM21637D2 1I0O
CDV31674D2 1I3I
CDM41674D2 1I3O
TIV31574D2 1I3I              ** PREVIOUSLY TIV31574D2 1I3I                         MD054107 MD054479
TIM41574D2 1I3O              ** PREVIOUSLY TIM41574D2 1I3O                         MD054107 MD054479
IPV31574D2 1I3I              ** PREVIOUSLY IPV31574D2 1I3I                         MD054107 MD054479
IPM41574D2 1I3O              ** PREVIOUSLY IPM41574D2 1I3O                         MD054107 MD054479
TDV31674D2 1I3I
TDM41674D2 1I3O
ITV31674D2 1I3I
ITM41674D2 1I3O
LNV61522D1 3I1O                                                                             MD054107
LNI61558D1 1I4I                                                                             MD054107
LNM61532D8 2I2I                                                                             MD054107
LNM81538D2 1I0I                                                                             MD054107
ITV61622D1 3I1I                                                                             MD054107
ITI61658D1 1I4O                                                                             MD054107
ITM61632D8 2I2O                                                                             MD054107
ITM81638D2 1I0O                                                                             MD054107
CLV61522D1 1I1I                                                                    MD054107 MD054479
CLI61558D1 1I4O                                                                    MD054107 MD054479
CLM61542D8 2I2O                                                                    MD054107 MD054479
CLM81538D2 1I0O                                                                    MD054107 MD054479
DLV61522D1 1I1O                                                                             MD054107
DLI61558D1 1I4I                                                                             MD054107
DLM61542D8 2I2I                                                                             MD054107
DLM81538D2 1I0I                                                                             MD054107
TDV61622D1 3I1I                                                                             MD054107
TDI61658D1 1I4O                                                                             MD054107
TDM61632D8 2I2O                                                                             MD054107
TDM81638D2 1I0O                                                                             MD054107
CIV61622D1 3I1I                                                                             MD054107
CII61658D1 1I4O                                                                             MD054107
CIM61632D8 2I2O                                                                             MD054107
CIM81638D2 1I0O                                                                             MD054107
CDV61622D1 1I1I                                                                             MD054107
CDI61658D1 1I4O                                                                             MD054107
CDM61642D8 2I2O                                                                             MD054107
CDM81638D2 1I0O                                                                             MD054107
TIV61522D1 3I1I                                                                    MD054107 MD054479
TII61558D1 1I4O                                                                    MD054107 MD054479
TIM61532D8 2I2O                                                                    MD054107 MD054479
TIM81538D2 1I0O                                                                    MD054107 MD054479
IPV61522D1 3I1I                                                                    MD054107 MD054479
IPI61558D1 1I4O                                                                    MD054107 MD054479
IPM61532D8 2I2O                                                                    MD054107 MD054479
IPM81538D2 1I0O                                                                    MD054107 MD054479
**  FRQ - Frequencies requiring non-working day check
FLRSW
**  CPY@ - Copyright
(C) Copyright Finastra International Limited, 2016
