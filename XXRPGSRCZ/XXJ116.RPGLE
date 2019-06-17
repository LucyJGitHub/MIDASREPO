     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Pooling Accounts Incoming Details')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ106*-*Midas*GL*Incoming Account Pooling Details************         JMI108
      *  XXJ116 - Midas GL Incoming Account Pooling Details           *         JMI108
      *                                                               *
      *  Function:  This program will process the account details     *
      *             received by FTP from the head office server.      *
      *                                                               *
      ***Called By: SDJ103  - Pooling Account Status                  *         JMI108
      ***           GLCJ102 - Account Pooling receive background job  *         JMI108
      *  Called By: XXJ103  - Pooling Account Status                  *         JMI108
      *             XXCJ112 - Account Pooling receive background job  *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011             Date 23Jan07               *
      *                 TFJ11A             Date  1Oct05               *
      *                 TFJ011 (CHG002)    Date 20Jun05               *
      *                 TFJ011             Date 16Jun05               *
      *                 TFJ011  *CREATE    Date 10Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Amend Accoutn code size from 4 to 10                *
      *  TFJ11A - Account Transfer Service                            *
      *  TFJ011 - (CHG002) Change to check GL extension file for      *
      *           batch having been used                              *
      *  TFJ011 - Need to handle numeric error                        *
      *  TFJ011 - Account Balance Pooling                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****35*********Error in reading file SDPLACV0                  *         JMI108
      *****45*********End of file for SDPLACV0                        *         JMI108
      *    35         Error in reading file XXPLACV0                  *         JMI108
      *    45         End of file for XXPLACV0                        *         JMI108
      *    60         CHAIN Indicator                                 *
      *    61         CHAIN Indicator                                 *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Account Pooling Incoming Details
     F***GLPIDLPP  IF   E             DISK    INFSR(*PSSR)                      JMI108
     FXXPIDLPP  IF   E             DISK    INFSR(*PSSR)                         JMI108

      * Pooling Account Status
     F***SDPSTSV0  UF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXPSTSV0  UF   E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     PREFIX(A_)

      * Pooling Accounts Details-Brca/Ccy/Schma
     F***SDPLACV3  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXPLACV3  IF   E           K DISK    INFSR(*PSSR)                         JMI108

      * Pooling Accounts Details-Retails Number
     F***SDPLACV4  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     F***                                     RENAME(SDPLACD0:SDPLAC0)          JMI108
     FXXPLACV4  IF   E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     RENAME(XXPLACD0:XXPLAC0)             JMI108
     F                                     PREFIX(A_)

      * Currencies by SWIFT Currency Code
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)

      * Currencies Details Extension File
     F***SDCURRY0  IF   E           K DISK    INFSR(*PSSR)                      JMI108
     F***                                     RENAME(SDCURRD0:SDCURR0)          JMI108
     FXXCURRY0  IF   E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     RENAME(XXCURRD0:XXCURR0)             JMI108

      * Journal interface header  LF Rtv
     FGLJEIHL1  IF   E           K DISK    INFSR(*PSSR)                                       CHG002
     F                                     PREFIX(H_)                                         CHG002
      * JE posting I/Face Extension                                                           CHG002
     F***GLJEIPYA  IF   E           K DISK    INFSR(*PSSR)                             CHG002 JMI108
     F***                                     RENAME(GLJEIPDA:GLJEIP)                  CHG002 JMI108
     FXXJEIPYA  IF   E           K DISK    INFSR(*PSSR)                                CHG002 JMI108
     F                                     RENAME(XXJEIPDA:XXJEIP)                     CHG002 JMI108
     F                                     PREFIX(X_)                                         CHG002

      * JE posting I/Face PF
     FGLJEIPPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      * Journal Entry Extension file
     F***GLJEIPXA  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXJEIPXA  O    E             DISK    INFSR(*PSSR)                         JMI108
     F                                     PREFIX(B_)
     F                                     COMMIT

      * Journal entry header interface
     FGLJEIHPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      * Pooling Details
     F***GLPLDTPP  O    E             DISK    INFSR(*PSSR)                      JMI108
     FXXPLDTPP  O    E             DISK    INFSR(*PSSR)                         JMI108
     F                                     COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Batch Description
     D*BDES************S             30    DIM(4) CTDATA                                      TFJ11A
     D BDES            S             30    DIM(6) CTDATA                                      TFJ11A
      *
      ** Local data area for database error details
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area Rundate

     D*** GLPBTCHDA     E DS                  EXTNAME(GLPBTCHDA)                JMI108
     D XXPBTCHDA     E DS                  EXTNAME(XXPBTCHDA)                   JMI108
      ** Data Area Pooling Account Batch Number

      ** Data structure for Header record
     DHEADER           DS
     D JHREC                   1      1  0                                      Header = 1
     D JHCC                    2      3  0                                      Century
     D JHYY                    4      5  0                                      Year
     D JHMO                    6      7  0                                      Month
     D JHDD                    8      9  0                                      Day
     D JHSCHEM                10     19                                         Scheme Number
     D JHTYPE                 20     22                                         Transaction Type
     D JHHH                   23     24  0                                      Hour
     D JHMM                   25     26  0                                      Minute
     D JHISEQ                 27     31  0                                      Instruction Seq
     D JHIBRCH                32     34                                         Receiver's Int Br
     D JFILL1                 35    400                                         Filler

      ** Data structure for Detail Record for Pooling Instructions
     DDETAILP          DS
     D JPREC                   1      1  0                                      Header = 2
     D JPCC                    2      3  0                                      Century
     D JPYY                    4      5  0                                      Year
     D JPMO                    6      7  0                                      Month
     D JPDD                    8      9  0                                      Day
     D JPSCHEM                10     19                                         Scheme Number
     D JPTYPE                 20     22                                         Transaction Type
     D JPHH                   23     24  0                                      Hour
     D JPMM                   25     26  0                                      Minute
     D JPISEQ                 27     31  0                                      Instruction Seq
     D JPIBRCH                32     34                                         Receiver's Int Br
     D JPPOOL                 35     35                                         Instruction
     D JPREV                  36     36                                         Reverse Flag
     D JPFILL1                37     50                                         Filler 1
     D JPSCHMN                51     90                                         Scheme Name
     D JPFILL2                91     92                                         Filler 2
     D JPCCC                  93     94  0                                      Credit Century
     D JPCYY                  95     96  0                                      Credit Year
     D JPCMM                  97     98  0                                      Credit Month
     D JPCDD                  99    100  0                                      Credit Day
     D JPSTAT                101    101                                         Status
     D JPVCC                 102    103  0                                      Value Century
     D JPVYY                 104    105  0                                      Value Year
     D JPVMM                 106    107  0                                      Value Month
     D JPVDD                 108    109  0                                      Value Day
     D JPFILL3               110    136                                         Filler 3
     D JPREMK                137    166                                         Remarks
     D JPREST                167    169                                         Result
     D JPFILL4               170    200                                         Filler 4
     D JPDACOD               201    201                                         Debit Account Code
     D JPDBRCH               202    204                                         Debit Branch
     D JPDCCY                205    207                                         Debit Currency
     D JPDACNO               208    227                                         Debit Account Number
     D JPDAMT                228    242  0                                      Debit Amount
     D JPFILL5               243    300                                         Filler 5
     D JPCACOD               301    301                                         Credit Account Code
     D JPCBRCH               302    304                                         Credit Branch
     D JPCCCY                305    307                                         Credit Currency
     D JPCACNO               308    327                                         Credit Accnt Number
     D JPCAMT                328    342  0                                      Credit  Amount
     D JPFILL6               343    400                                         Filler 6

      ** Data structure for Detail Record for Money Market Instructions
     DDETAILS          DS
     D JSREC                   1      1  0                                      Header = 2
     D JSCC                    2      3  0                                      Century
     D JSYY                    4      5  0                                      Year
     D JSMO                    6      7  0                                      Month
     D JSDD                    8      9  0                                      Day
     D JSSCHEM                10     19                                         Scheme Number
     D JSTYPE                 20     22                                         Transaction Type
     D JSHH                   23     24  0                                      Hour
     D JSMM                   25     26  0                                      Minute
     D JSISEQ                 27     31  0                                      Instruction Seq
     D JSIBRCH                32     34                                         Receiver's Int Br
     D JSFILL1                35     50                                         Filler 1
     D JSSCHMN                51     90                                         Scheme Name
     D JSFILL2                91     92                                         Filler 2
     D JSCCC                  93     94  0                                      Credit Century
     D JSCYY                  95     96  0                                      Credit Year
     D JSCMM                  97     98  0                                      Credit Month
     D JSCDD                  99    100  0                                      Credit Day
     D JSSTAT                101    101                                         Status
     D JSVCC                 102    103  0                                      Value Century
     D JSVYY                 104    105  0                                      Value Year
     D JSVMM                 106    107  0                                      Value Month
     D JSVDD                 108    109  0                                      Value Day
     D JSDCC                 110    111  0                                      Due Century
     D JSDYY                 112    113  0                                      Due Year
     D JSDMM                 114    115  0                                      Due Month
     D JSDDD                 116    117  0                                      Due Day
     D JSRATE                118    119  0                                      Base Rate Code
     D JSSPRD                120    128                                         Base Rate Spread
     D JSCALC                129    129                                         Calculation Method
     D JSFILL3               130    136                                         Filler 3
     D JSREMK                137    166                                         Remarks
     D JSREST                167    169                                         Result
     D JSFILL4               170    200                                         Filler 4
     D JSDACOD               201    201                                         Debit Account Code
     D JSDBRCH               202    204                                         Debit Branch
     D JSDCCY                205    207                                         Debit Currency
     D JSDACNO               208    227                                         Debit Account Number
     D JSDAMT                228    242  0                                      Debit Amount
     D JSFILL5               243    300                                         Filler 5
     D JSCACOD               301    301                                         Credit Account Code
     D JSCBRCH               302    304                                         Credit Branch
     D JSCCCY                305    307                                         Credit Currency
     D JSCACNO               308    327                                         Credit Accnt Number
     D JSCAMT                328    342  0                                      Credit  Amount
     D JSFILL6               343    400                                         Filler 6

      ** Data structure for Trailer record
     DTRAILER          DS
     D TRECI                   1      1  0                                      Trailer = 9
     D TCC                     2      3  0                                      Century
     D TYY                     4      5  0                                      Year
     D TMO                     6      7  0                                      Month
     D TDD                     8      9  0                                      Day
     D TSCHEM                 10     19                                         Scheme Number
     D TTYPE                  20     22                                         Transaction Type
     D THH                    23     24  0                                      Hour
     D TMM                    25     26  0                                      Minute
     D TISEQ                  27     31  0                                      Instruction Sequence
     D TIBRCH                 32     34                                         Sender's branch code
     D TNOREC                 35     39  0                                      Number of records
     D FILLER2                40    400                                         Filler

      ** Data structure for Date
     D@YDATE           DS
     D WMM                     1      2  0
     D WDD                     3      4  0
     D WYY                     5      6  0
      *
      ** Data Structure for Account
     D@RACNT           DS
     D BTIBCA                  1      3
     D BTCUST                  4      9
     D BTCYCD                 10     12
     D*BTACCD*********        13     16                                                       TFJ011
     D*BTACSN*********        17     18                                                       TFJ011
     D BTACCD                 13     22                                                       TFJ011
     D BTACSN                 23     24                                                       TFJ011
      *
      ** Data Structure for Amount
     D@RAMNT           DS
     D WINT                    1     12  0
     D WDEC                   13     15  0

      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details

     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details

     D*** SDPICD        E DS                  EXTNAME(SDPICDPP)                 JMI108
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    JMI108
      ** External DS for Pooling ICD Details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  @QDFAC       e                     ExtFld(QQDFAC)                                     TFJ011
      ** External DS for Branch Codes

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  @QACCD       e                     ExtFld(QQACCD)                                     TFJ011
      ** External DS for General Ledger Details

     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** External DS for Retail Transaction Types

     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      ** External DS for Retail Account Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D RCount          S              5  0

      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
     D PMMDDYY         S              6  0
     D PDateFmt        S              1
     D PMidasDayNo     S              5  0

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C**** 1             SETLL     GLPIDLPP                                     JMI108
     C****               READ      GLPIDLPP                             3545    JMI108
     C     1             SETLL     XXPIDLPP                                     JMI108
     C                   READ      XXPIDLPP                             3545    JMI108

     C                   IF        EndOfFile <> True
     C                   MOVEL     JINDL         HEADER
     C                   IF        JHREC = 1
     C                   IF        JHTYPE = '002'
     C                   EXSR      SRMoney
     C                   ELSE
     C                   EXSR      SRPool
     C                   ENDIF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'GLPIDLPP'                          JMI108
     C                   EVAL      DBFile = 'XXPIDLPP'                          JMI108
     C                   EVAL      DBase = 004                                  * DBERR 004 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C****************** EVAL      DBFile = 'GLPIDLPP'                          JMI108
     C                   EVAL      DBFile = 'XXPIDLPP'                          JMI108
     C                   EVAL      DBase = 005                                  * DBERR 005 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   COMMIT
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoney - Sweep Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSwPldt                                               *
      *                                                               *
      *****************************************************************

     C     SRMoney       BEGSR

     C****************** READ      GLPIDLPP                             3545    JMI108
     C                   READ      XXPIDLPP                             3545    JMI108
     C                   DOU       EndOfFile = True
     C                   MOVEL     JINDL         DETAILS
     C                   IF        JSREC = 2
      *
      ** Write to Pooling Details File
     C                   EXSR      SRSwPldt
     C                   ENDIF
      *
      ** Read next record.
     C****************** READ      GLPIDLPP                             3545    JMI108
     C                   READ      XXPIDLPP                             3545    JMI108
      *
     C                   ENDDO
      *
      ** Update Pooling Status File
     C                   EVAL      KSeqNo = PSeqNo
     C                   EVAL      KType  = 'R'
     C*****KSTAT         CHAIN     SDPSTSV0                           60        JMI108
     C     KSTAT         CHAIN     XXPSTSV0                           60        JMI108

     C                   IF        *IN60 = '0'
     C                   MOVE      JSTYPE        A_JINST
     C                   MOVE      JHIBRCH       A_JIBRCH
     C****************** UPDATE    SDPSTSD0                                     JMI108
     C                   UPDATE    XXPSTSD0                                     JMI108
     C                   ENDIF

      ** Set Return Type Parameter
     C                   EVAL      PProcTyp = 'S'

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSwPldt - Output to Pooling Details File from Sweep          *
      *                                                               *
      * Called by: SRMoney                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSwPldt      BEGSR

     C****************** CLEAR                   GLPLDTD0                       JMI108
     C                   CLEAR                   XXPLDTD0                       JMI108
      *
      ***Populate*fields*of*GLPLDTPP                                            JMI108
      ** Populate fields of XXPLDTPP                                            JMI108
     C                   EVAL      JCC    = JSCC
     C                   EVAL      JYY    = JSYY
     C                   EVAL      JMM    = JSMO
     C                   EVAL      JDD    = JSDD
     C                   EVAL      JSCHEM = JSSCHEM
     C                   EVAL      JTYPE  = JSTYPE
     C                   EVAL      JHH    = JSHH
     C                   EVAL      JMIN   = JSMM
     C                   EVAL      JISEQ  = JSISEQ
     C                   EVAL      JIBRCH = JSIBRCH
     C                   EVAL      JSCHMN = JSSCHMN
     C                   EVAL      JCCC   = JSCCC
     C                   EVAL      JCYY   = JSCYY
     C                   EVAL      JCMM   = JSCMM
     C                   EVAL      JCDD   = JSCDD
     C                   EVAL      JSTAT  = JSSTAT
     C                   EVAL      JVCC   = JSVCC
     C                   EVAL      JVYY   = JSVYY
     C                   EVAL      JVMM   = JSVMM
     C                   EVAL      JVDD   = JSVDD
     C                   EVAL      JDCC   = JSDCC
     C                   EVAL      JDYY   = JSDYY
     C                   EVAL      JDMM   = JSDMM
     C                   EVAL      JDDD   = JSDDD
     C                   EVAL      JRATE  = JSRATE
     C                   MOVE      JSSPRD        JSPRD
     C                   EVAL      JCALC  = JSCALC
     C                   EVAL      JREMK  = JSREMK
     C                   EVAL      JREST  = JSREST
     C                   EVAL      JDACOD = JSDACOD
     C                   EVAL      JDBRCH = JSDBRCH
     C                   EVAL      JDAMT  = JSDAMT
     C                   EVAL      JCACOD = JSCACOD
     C                   EVAL      JCBRCH = JSCBRCH
     C                   EVAL      JCAMT  = JSCAMT
     C                   EVAL      JSEQ   = PSeqNo
      *
     C                   EVAL      JDACER = ' '
     C                   EVAL      JCACER = ' '
      * Error on account if not set up as a Sweep account
     C                   MOVEL     JSDACNO       @PDACNO          10                          TFJ011
     C                   MOVEL     JSDACNO       #PDACNO          10 0                        TFJ011
     C                   MOVE      #PDACNO       WPDACNO          10                          TFJ011
     C                   IF        WPDACNO = @PDACNO                                          TFJ011
     C                   MOVEL     JSDACNO       RETL10           10 0
     C*****RETL10        CHAIN     SDPLACV4                           60        JMI108
     C     RETL10        CHAIN     XXPLACV4                           60        JMI108
     C     *IN60         IFEQ      *ON
     C     *IN60         OREQ      *OFF
     C     A_JSCHMS      ANDEQ     ' '
     C                   EVAL      JDACER = 'Y'
     C                   EVAL      JCACER = 'Y'
     C                   ENDIF

     C                   Else                                                                 TFJ011
     C                   EVAL      JDACER = 'Y'                                               TFJ011
     C                   EVAL      JCACER = 'Y'                                               TFJ011
     C                   ENDIF                                                                TFJ011
                                                                                              TFJ011
     C                   EVAL      JDACNO = JSDACNO
     C                   EVAL      JCACNO = JSDACNO
      *
      * Obtain Midas Currency code from incoming SWIFT currency code
     C     JSDCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JSDCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 018                                  * DBERR 018 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      JDCCY  = A6CYCD
      *
      * Set currency error flag to 'Y' if Debit currency not
      * the same as account currency and no Debit account error
     C     JDCCY         IFNE      A_JCCY
     C     JDACER        ANDEQ     ' '
     C                   MOVE      'Y'           JDCYER
     C                   ELSE
     C                   MOVE      ' '           JDCYER
     C                   ENDIF

     C     JSCCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JSCCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 019                                  * DBERR 019 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      JCCCY  = A6CYCD
      *
      * Set currency error flag to 'Y' if Credit currency not
      * the same as account currency
     C     JCCCY         IFNE      A_JCCY
     C     JCACER        ANDEQ     ' '
     C                   MOVE      'Y'           JCCYER
     C                   ELSE
     C                   MOVE      ' '           JCCYER
     C                   ENDIF

      ** Output to file
     C****************** WRITE     GLPLDTD0                                     JMI108
     C                   WRITE     XXPLDTD0                                     JMI108

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPool - Pooling Processing                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPoPldt                                               *
      *                                                               *
      *****************************************************************

     C     SRPool        BEGSR

     C                   Z-ADD     0             WBINB             3 0
     C                   Z-ADD     0             WPTAM1           15 0
     C****************** READ      GLPIDLPP                             3545    JMI108
     C                   READ      XXPIDLPP                             3545    JMI108
     C                   DOU       EndOfFile = True
     C                   MOVEL     JINDL         DETAILP
     C                   IF        JPREC = 2

     C                   ADD       1             WBINB
     C****************** CLEAR                   GLPLDTD0                       JMI108
     C                   CLEAR                   XXPLDTD0                       JMI108
     C                   CLEAR                   @BTREMG
     C****************** CLEAR                   GLJEIPDA                       JMI108
     C                   CLEAR                   XXJEIPDA                       JMI108
     C                   EVAL      BTDCIN = 'D'
      *
      ** Write to Journal Entry Interface File - Debit
     C                   EXSR      SRJEIPPD
      *
      ** Write to Journal Entry Interface Extension File - Debit
     C                   EXSR      SRJEIPX0

     C                   ADD       1             WBINB
     C                   CLEAR                   @BTREMG
     C****************** CLEAR                   GLJEIPDA                       JMI108
     C                   CLEAR                   XXJEIPDA                       JMI108
     C                   EVAL      BTDCIN = 'C'
      *
      ** Write to Journal Entry Interface File - Credit
     C                   EXSR      SRJEIPPD
      *
      ** Write to Journal Entry Interface Extension File - Credit
     C                   EXSR      SRJEIPX0
      *
      ** Write to Pooling Details File
     C                   EXSR      SRPoPldt
     C                   ENDIF
      *
      ** Read next record.
     C****************** READ      GLPIDLPP                             3545    JMI108
     C                   READ      XXPIDLPP                             3545    JMI108
      *
     C                   ENDDO
      *
      ** Write to Journal Entry Interface Header File
     C                   EXSR      SRJEIHPD
      *
      ** Update Pooling Status File
     C                   EVAL      KSeqNo = PSeqNo
     C                   EVAL      KType  = 'R'
     C**** KSTAT         CHAIN     SDPSTSV0                           60        JMI108
     C     KSTAT         CHAIN     XXPSTSV0                           60        JMI108

     C                   IF        *IN60 = '0'
     C                   MOVE      JBTCH         A_JIBTCH
     C                   MOVE      JPTYPE        A_JINST
     C                   MOVE      JHIBRCH       A_JIBRCH
     C****************** UPDATE    SDPSTSD0                                     JMI108
     C                   UPDATE    XXPSTSD0                                     JMI108
     C                   ENDIF
      *
      ** Update Batch Number
     C                   MOVE      JBTCH         WBTCH             3 0
     C                   ADD       1             WBTCH
     C**** *LOCK         IN        GLPBTCHDA                                    JMI108
     C     *LOCK         IN        XXPBTCHDA                                    JMI108
     C                   MOVE      WBTCH         JBTCH
     C****************** OUT       GLPBTCHDA                                    JMI108
     C                   OUT       XXPBTCHDA                                    JMI108
      *
      ** Set Return Type Parameter
     C                   EVAL      PProcTyp = 'P'

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJEIPPD - Write Records to Journal Entry Interface File      *
      *                                                               *
      * Called by: SRPool                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRJEIPPD      BEGSR

     C                   EVAL      BTBTNB = JBTCH                               Batch number
     C                   EVAL      BTBINB = WBINB                               Batch item no.
      *
      ** Write Account Details for Debit
     C                   IF        BTDCIN = 'D'
      *
     C                   MOVE      ' '           JDCYER
      * Need to get currency code from incoming SWIFT currency code
     C     JPDCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPDCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 006                                  * DBERR 006 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Save currency code of Debit currency
     C                   MOVE      A6CYCD        DrCCY             3
      *
     C                   SELECT
     C     JPDACOD       WHENEQ    '0'
     C                   MOVEL     JPDACNO       @DACNO           10
     C                   MOVEL     JPDACNO       #DACNO           10 0
     C                   MOVE      #DACNO        WDACNO           10
     C                   If        WDACNO = @DACNO
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY    '    POptn
     C                   Parm      JPDACNO       PRetl            10
     C                   Parm      *Blanks       PCusN             6
     C                   Parm      *Blanks       PCur              3
     C**********         Parm      *Blanks       PAcctcde          4                          TFJ011
     C                   Parm      *Blanks       PAcctcde         10                          TFJ011
     C                   Parm      *Blanks       PAcctSeq          2
     C                   Parm      *Blanks       PBrch             3
     C     ACCNT         Parm      ACCNT         DSSDY
     C                   Else
     C                   MOVE      '*ERROR '     PRtcd
     C                   EndIf

     C     PRtcd         IfNe      *Blank
     C     PRtcd         OrEq      *Blank
     C     RECI          AndNe     'D'
      *
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JDACER = 'Y'
     C                   EVAL      JDACNO = JPDACNO
     C                   ELSE
      *
      * Account must be defined as a Pooling account
     C                   MOVEL     JPDACNO       RETL10
     C**** RETL10        CHAIN     SDPLACV4                           60        JMI108
     C     RETL10        CHAIN     XXPLACV4                           60        JMI108
     C     *IN60         IFEQ      *ON
     C     *IN60         OREQ      *OFF
     C     A_JSCHMI      ANDNE     ' '
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JDACER = 'Y'
     C                   EVAL      JDACNO = JPDACNO
     C                   ELSE

     C                   EVAL      BTIBCA = BRCA
     C                   MOVE      CNUM          BTCUST
     C                   EVAL      BTCYCD = A6CYCD
     C                   MOVE      ACOD          BTACCD
     C                   MOVE      ACSQ          BTACSN
     C                   EVAL      JDACNO = JPDACNO
     C                   MOVEL     JPDACNO       BTRACN
     C                   EVAL      BTACTY = 'R'
      *
      * Currency error if account currency not same as incoming ccy
     C     DrCCY         IFNE      CCY
     C                   MOVE      'Y'           JDCYER
     C                   ENDIF
      *
     C                   ENDif
     C                   ENDif

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPDAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPDAMT        BTPTAM
     C                   MOVE      ' '           JDAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JDAMER
     C                   ENDIF

     C     JPDACOD       WHENEQ    '1'

     C                   EVAL      KCCY   = A6CYCD

     C                   EVAL      KBRCH  = JPDBRCH
     C                   EVAL      KSCHMI = 'I'

     C**** KSPLAC        CHAIN     SDPLACV3                           60        JMI108
     C     KSPLAC        CHAIN     XXPLACV3                           60        JMI108

     C                   IF        *IN60 = '0'
     C                   EVAL      BTIBCA = JBRCA
     C                   MOVE      JCNUM         BTCUST
     C                   EVAL      BTCYCD = JCCY
     C                   MOVE      JACOD         BTACCD
     C                   MOVE      JACSQ         BTACSN
     C                   EVAL      BTRACN = JACNO
     C                   MOVEL     JACNO         JDACNO
     C                   IF        BTRACN = 0
     C                   EVAL      BTACTY = 'N'
     C                   ELSE
     C                   EVAL      BTACTY = 'R'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JDACER = 'Y'
     C                   MOVE      *BLANKS       JDACNO
     C                   EndIF

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPDAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPDAMT        BTPTAM
     C                   MOVE      ' '           JDAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JDAMER
     C                   ENDIF
     C
     C     JPDACOD       WHENEQ    '2'

     C     JPDCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPDCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 007                                  * DBERR 007 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ELSE
     C**** A6CYCD        CHAIN     SDCURRY0                           61        JMI108
     C     A6CYCD        CHAIN     XXCURRY0                           61        JMI108
     C     *IN61         IFEQ      *ON
     C     JACOD         OREQ      0
      *
      * Branch set to Main branch from GL ICD
     C                   EVAL      BTIBCA = BKMABR
      *
     C                   EVAL      BTCUST = '000000'

     C                   EVAL      BTCYCD = A6CYCD
      *
      * Account Code set to Suspense account code from GL ICD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JDACER = 'Y'
     C                   MOVE      *BLANKS       JDACNO
     C                   ELSE
      *
      ** Access Branch details
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      JBRCA         @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JBRCA
     C                   EVAL      DBFile = 'SDBRCHPD'                          *************
     C                   EVAL      DBase = 008                                  * DBERR 008 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      BTIBCA = JBRCA
     C                   EVAL      BTCUST = A8BICN
     C                   EVAL      BTCYCD = A6CYCD
     C                   MOVE      JACOD         BTACCD
     C                   MOVE      JACSQ         BTACSN
     C                   EVAL      JDACNO = @RACNT
     C                   EVAL      BTRACN = 0
     C                   EVAL      BTACTY = 'G'
     C                   EndIf
     C                   EndIf

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPDAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPDAMT        BTPTAM
     C                   MOVE      ' '           JDAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JDAMER
     C                   ENDIF

     C                   ENDSL
     C                   ENDIF
      *
      ** Write Account Details for Credit
     C                   IF        BTDCIN = 'C'
      *
      * Need to get currency code from incoming SWIFT currency code
     C     JPCCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPCCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 009                                  * DBERR 009 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Save currency code of Credit currency
     C                   MOVE      A6CYCD        CrCCY             3
      *
     C                   SELECT
     C     JPCACOD       WHENEQ    '0'
     C                   MOVE      ' '           JCCYER
      *
     C                   MOVEL     JPCACNO       @CACNO           10
     C                   MOVEL     JPCACNO       #CACNO           10 0
     C                   MOVE      #CACNO        WCACNO           10
     C                   If        WCACNO = @CACNO
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY    '    POptn
     C                   Parm      JPCACNO       PRetl            10
     C                   Parm      *Blanks       PCusN             6
     C                   Parm      *Blanks       PCur              3
     C**********         Parm      *Blanks       PAcctcde          4                          TFJ011
     C                   Parm      *Blanks       PAcctcde         10                          TFJ011
     C                   Parm      *Blanks       PAcctSeq          2
     C                   Parm      *Blanks       PBrch             3
     C     ACCNT         Parm      ACCNT         DSSDY
     C                   Else
     C                   MOVE      '*ERROR '     PRtcd
     C                   EndIf

     C     PRtcd         IfNe      *Blank
     C     PRtcd         OrEq      *Blank
     C     RECI          AndNe     'D'
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JCACER = 'Y'
     C                   EVAL      JCACNO = JPCACNO
     C                   ELSE
      *
      * Account must be defined as a Pooling account
     C                   MOVEL     JPCACNO       RETL10
     C**** RETL10        CHAIN     SDPLACV4                           60        JMI108
     C     RETL10        CHAIN     XXPLACV4                           60        JMI108
     C     *IN60         IFEQ      *ON
     C     *IN60         OREQ      *OFF
     C     A_JSCHMI      ANDNE     ' '
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JCACER = 'Y'
     C                   EVAL      JCACNO = JPCACNO
     C                   ELSE

     C                   EVAL      BTIBCA = BRCA
     C                   MOVE      CNUM          BTCUST
     C                   EVAL      BTCYCD = A6CYCD
     C                   MOVE      ACOD          BTACCD
     C                   MOVE      ACSQ          BTACSN
     C                   EVAL      JCACNO = JPCACNO
     C                   MOVEL     JPCACNO       BTRACN
     C                   EVAL      BTACTY = 'R'
      *
      * Currency error if account currency not same as incoming ccy
     C     CrCCY         IFNE      CCY
     C                   MOVE      'Y'           JCCYER
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPCAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPCAMT        BTPTAM
     C                   MOVE      ' '           JCAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JCAMER
     C                   ENDIF

     C     JPCACOD       WHENEQ    '1'

     C                   EVAL      KCCY   = A6CYCD
     C                   EVAL      KBRCH  = JPCBRCH
     C                   EVAL      KSCHMI = 'I'

     C**** KSPLAC        CHAIN     SDPLACV3                           60        JMI108
     C     KSPLAC        CHAIN     XXPLACV3                           60        JMI108

     C                   IF        *IN60 = '0'
     C                   EVAL      BTIBCA = JBRCA
     C                   MOVE      JCNUM         BTCUST
     C                   EVAL      BTCYCD = JCCY
     C                   MOVE      JACOD         BTACCD
     C                   MOVE      JACSQ         BTACSN
     C                   EVAL      BTRACN = JACNO
     C                   MOVEL     JACNO         JCACNO
     C                   IF        BTRACN = 0
     C                   EVAL      BTACTY = 'N'
     C                   Else
     C                   EVAL      BTACTY = 'R'
     C                   EndIF
     C                   ELSE
     C                   EVAL      BTIBCA = BKMABR
     C                   EVAL      BTCUST = '000000'
     C                   EVAL      BTCYCD = A6CYCD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JCACER = 'Y'
     C                   MOVE      *BLANKS       JCACNO
     C                   EndIF

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPCAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPCAMT        BTPTAM
     C                   MOVE      ' '           JCAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JCAMER
     C                   ENDIF
     C
     C     JPCACOD       WHENEQ    '2'

     C     JPCCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPCCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 010                                  * DBERR 010 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ELSE
     C**** A6CYCD        CHAIN     SDCURRY0                           61        JMI108
     C     A6CYCD        CHAIN     XXCURRY0                           61        JMI108
     C     *IN61         IFEQ      *ON
     C     JACOD         OREQ      0
      *
      * Branch set to Main branch from GL ICD
     C                   EVAL      BTIBCA = BKMABR
      *
     C                   EVAL      BTCUST = '000000'

     C                   EVAL      BTCYCD = A6CYCD
      *
      * Account Code set to Suspense account code from GL ICD
     C                   EVAL      BTACCD = BKACCD
     C                   EVAL      BTACSN = '01'
     C                   EVAL      JCACER = 'Y'
     C                   MOVE      *BLANKS       JCACNO
     C                   ELSE
      *
      ** Access Branch details
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      JBRCA         @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JBRCA
     C                   EVAL      DBFile = 'SDBRCHPD'                          *************
     C                   EVAL      DBase = 011                                  * DBERR 011 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      BTIBCA = JBRCA
     C                   EVAL      BTCUST = A8BICN
     C                   EVAL      BTCYCD = A6CYCD
     C                   MOVE      JACOD         BTACCD
     C                   MOVE      JACSQ         BTACSN
     C                   EVAL      JCACNO = @RACNT
     C                   EVAL      BTRACN = 0
     C                   EVAL      BTACTY = 'G'
     C                   EndIf
     C                   EndIf

      * Check if amount is 14 or 15 long, if so flag
     C                   MOVEL     JPCAMT        FLD2              2 0
     C     FLD2          IFEQ      0
     C                   Z-ADD     JPCAMT        BTPTAM
     C                   MOVE      ' '           JCAMER
     C                   ELSE
     C                   Z-ADD     0             BTPTAM
     C                   MOVE      'Y'           JCAMER
     C                   ENDIF

     C                   ENDSL
     C                   ENDIF
      *
      ** Convert Value Date by calling ZDATE1
     C                   EVAL      WYY = JPVYY
     C                   EVAL      WMM = JPVMM
     C                   EVAL      WDD = JPVDD

     C                   MOVE      @YDATE        PMMDDYY

     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMMDDYY
     C                   PARM      'M'           PDateFmt
     C                   PARM      *ZEROS        PMidasDayNo
     C                   EVAL      BTVLDT = PMidasDayNo                         Value date
      *
      ** Other Details
     C                   EVAL      BTNNBI = *Blanks                             Nostro number (Item)
     C                   EVAL      BTRINO = *Blanks                             Retail ind.: Overrid
     C                   EVAL      BTRINE = 'N'                                 Retail ind.: Error
     C                   EVAL      BTPTDT = BJRDNB                              Posting date
     C                   EVAL      BTNVCD = *Blanks                             Narrative code
     C                   EVAL      BTNRDC = JPREMK                              Narrative descriptio
     C                   EVAL      BTACNB = *Blanks                             Assoc. Customer numb
     C                   EVAL      BTCQNB = *Blanks                             Cheque number
     C                   EVAL      BTSWCR = *Blanks                             Swift common referen
     C                   EVAL      BTPRCN = *Blanks                             Profit centre
     C                   EVAL      BTBCBH = BKMABR                              Branch Code (Batch H
     C                   EVAL      BTRADP = *Blanks                             Retail advice printe
     C                   EVAL      BTSHPI = *Blanks                             Shadow post indicato
     C                   EVAL      BTRRNM = 0                                   Relative rec no of m
     C                   EVAL      BTRARC = 'NNNNNNNNNN'                        Retail Ac Referral C
     C                   EVAL      BTTSTY = *Blanks                             Transaction (Sub - T
     C                   EVAL      BTBKCD = *Blanks                             Book Code
     C                   EVAL      BTSPFC = 0                                   Spread Factor
     C                   EVAL      BTRVDI = *Blanks                             Reverse/Void Indicat
     C                   EVAL      BTNITM = 1                                   Number of Items
     C                   EVAL      BTOCCY = *Blanks                             Original Currency
     C                   EVAL      BTOAMT = 0                                   Original amount
      *
      ** Retail Number Entered
     C                   If        BTRACN <> 0
     C                   EVAL      BTRNBE = 'Y'
     C                   Endif
      *
      ** Debit Details
     C                   IF        BTDCIN = 'D'
     C                   EVAL      BTTRTY = JJTRND                              Transaction type

     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      JJTRND        @TRAT             5
     C     SDRETR        PARM      SDRETR        DSFDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'                          *************
     C                   EVAL      DBase = 012                                  * DBERR 012 *
     C                   EVAL      DBKey = @TRAT                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      BTCOIN = A1COIN                              Customer originated
     C                   ENDIF
      *
      ** Credit Details
     C                   IF        BTDCIN = 'C'
     C                   EVAL      BTTRTY = JJTRNC                              Transaction type

     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      JJTRNC        @TRAT             5
     C     SDRETR        PARM      SDRETR        DSFDY                       O:Format

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'                          *************
     C                   EVAL      DBase = 013                                  * DBERR 013 *
     C                   EVAL      DBKey = @TRAT                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      BTCOIN = A1COIN                              Customer originated
     C                   ENDIF
      *
      ** Total Posting Amount
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BTCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'                          *************
     C                   EVAL      DBase = 014                                  * DBERR 014 *
     C                   EVAL      DBKey = @AJCD                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     0             WPTAM            15 0
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C     BTPTAM        MULT      1000          WPTAM
     C                   ADD       WPTAM         WPTAM1
     C     A6NBDP        WHENEQ    1
     C     BTPTAM        MULT      100           WPTAM
     C                   ADD       WPTAM         WPTAM1
     C     A6NBDP        WHENEQ    2
     C     BTPTAM        MULT      10            WPTAM
     C                   ADD       WPTAM         WPTAM1
     C     A6NBDP        WHENEQ    3
     C     BTPTAM        MULT      1             WPTAM
     C                   ADD       WPTAM         WPTAM1
     C                   ENDSL

     C                   If        WFLAG  = *Blanks
     C                   MOVE      BTIBCA        WIBCA             3
     C                   MOVE      'Y'           WFLAG             1
     C                   Else
     C                   If        (BTIBCA <> WIBCA) and (BTIBCA <> *Blanks)
     C                   MOVE      'Y'           WMBRB             1
     C                   EndIf
     C                   EndIf
      *
      ** Output to file
     C                   WRITE     @BTREMG

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJEIPX0 - Write Records to Journal Entry Interface Extension *
      *                                                               *
      * Called by: SRPool                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRJEIPX0      BEGSR

     C                   EVAL      B_JIBTNB = BTBTNB                              Batch number
     C                   EVAL      B_JBINB  = BTBINB                              Batch item no.
     C                   EVAL      B_JINST  = JPTYPE                              Instruction Type
     C                   EVAL      B_JSHMN  = JPSCHEM                             Scheme Number
     C                   EVAL      B_JINSS  = JPISEQ                              Instruction Seq
     C                   MOVE      PSeqNo        B_JSEQ                           File Seq Number
      *
      ** Debit Details
     C                   IF        BTDCIN = 'D'
     C                   MOVE      JPDACOD       B_JACOD
     C                   EVAL      B_JBRCH  = JPDBRCH
     C                   ENDIF
      *
      ** Credit Details
     C                   IF        BTDCIN = 'C'
     C                   MOVE      JPCACOD       B_JACOD
     C                   EVAL      B_JBRCH  = JPCBRCH
     C                   ENDIF
      *
      * Execution Time                                                                        TFJ11A
     C                   EVAL      B_JEHH = JPHH                                              TFJ11A
     C                   EVAL      B_JEMIN = JPMM                                             TFJ11A
      * Execution Date                                                                        TFJ11A
     C                   Z-ADD     JPCC          B_JECC                                       TFJ11A
     C                   Z-ADD     JPYY          B_JEYY                                       TFJ11A
     C                   Z-ADD     JPMO          B_JEMM                                       TFJ11A
     C                   Z-ADD     JPDD          B_JEDD                                       TFJ11A
      ** Output to file
     C****************** WRITE     GLJEIPDA                                     JMI108
     C                   WRITE     XXJEIPDA                                     JMI108

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPoPldt - Output to Pooling Details File from Pool           *
      *                                                               *
      * Called by: SRPool                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPoPldt      BEGSR
      *
      ***Populate*fields*of GLPLDTPP                                            JMI108
      ** Populate fields of XXPLDTPP                                            JMI108
     C                   EVAL      JCC    = JPCC
     C                   EVAL      JYY    = JPYY
     C                   EVAL      JMM    = JPMO
     C                   EVAL      JDD    = JPDD
     C                   EVAL      JSCHEM = JPSCHEM
     C                   EVAL      JTYPE  = JPTYPE
     C                   EVAL      JHH    = JPHH
     C                   EVAL      JMIN   = JPMM
     C                   EVAL      JISEQ  = JPISEQ
     C                   EVAL      JIBRCH = JPIBRCH
     C                   EVAL      JPOOL  = JPPOOL
     C                   EVAL      JREV   = JPREV
     C                   EVAL      JSCHMN = JPSCHMN
     C                   EVAL      JCCC   = JPCCC
     C                   EVAL      JCYY   = JPCYY
     C                   EVAL      JCMM   = JPCMM
     C                   EVAL      JCDD   = JPCDD
     C                   EVAL      JSTAT  = JPSTAT
     C                   EVAL      JVCC   = JPVCC
     C                   EVAL      JVYY   = JPVYY
     C                   EVAL      JVMM   = JPVMM
     C                   EVAL      JVDD   = JPVDD
     C                   EVAL      JREMK  = JPREMK
     C                   EVAL      JREST  = JPREST
     C                   EVAL      JDACOD = JPDACOD
     C                   EVAL      JDBRCH = JPDBRCH
     C                   EVAL      JDAMT  = JPDAMT
     C                   EVAL      JCACOD = JPCACOD
     C                   EVAL      JCBRCH = JPCBRCH
     C                   EVAL      JCAMT  = JPCAMT
     C                   EVAL      JSEQ   = PSeqNo
      *
      * Obtain Midas Currency code from incoming SWIFT currency code
     C     JPDCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPDCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 025                                  * DBERR 025 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      JDCCY  = A6CYCD
      *
     C     JPCCCY        CHAIN     SDCURRLD                           60
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = JPCCCY
     C                   EVAL      DBFile = 'SDCURRLD'                          *************
     C                   EVAL      DBase = 026                                  * DBERR 026 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      JCCCY  = A6CYCD
      ** Output to file
     C****************** WRITE     GLPLDTD0                                     JMI108
     C                   WRITE     XXPLDTD0                                     JMI108

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJEIHPD - Write Records to Journal Entry Interface Extension *
      *                                                               *
      * Called by: SRPool                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRJEIHPD      BEGSR

     C                   CLEAR                   @BRREMA

     C                   EVAL      BRBTNB = JBTCH                               Batch number
     C                   EVAL      BRBCDA = BKMABR                              Branch Code - Alpha
     C                   EVAL      BRDPCD = JJDEPT                              Dept Code
     C                   EVAL      BRWSID = *Blanks                             Workstation id.
     C                   MOVE      WPTAM1        @RAMNT
     C                   EVAL      BRHICC = WINT                                Hash integer calcula
     C                   EVAL      BRHDCC = WDEC                                Hash decimal calcula
     C                   EVAL      BRHINC = WBINB                               Hash item no.calcula
     C                   EVAL      BRHIIN = WINT                                Hash integer input
     C                   EVAL      BRHDIN = WDEC                                Hash decimal input
     C                   EVAL      BRHINI = WBINB                               Hash item no.input
     C                   EVAL      BRBTSF = 'H'                                 Batch status flag
     C                   EVAL      BRBIUF = *Blanks                             Batch in use flag
     C                   EVAL      BRSHPI = *Blanks                             Shadow post indicato
     C                   EVAL      BRRAPI = *Blanks                             Retail advice print
     C                   IF        WMBRB = 'Y'
     C                   EVAL      BRMBRB = 'Y'                                 Multiple Branch Batc
     C                   ELSE
     C                   EVAL      BRMBRB = 'N'                                 Multiple Branch Batc
     C                   EndIf
     C                   EVAL      BRRVVD = *Blanks                             Reversal / Void Indi
      *
      ** Batch Description depends on Instruction Type
     C                   SELECT
     C     JHTYPE        WHENEQ    '001'
     C                   MOVEA     BDES(1)       BRBDES
     C     JHTYPE        WHENEQ    '003'
     C                   MOVEA     BDES(2)       BRBDES
     C     JHTYPE        WHENEQ    '004'
     C                   MOVEA     BDES(3)       BRBDES
     C     JHTYPE        WHENEQ    '005'
     C                   MOVEA     BDES(4)       BRBDES
     C     JHTYPE        WHENEQ    '006'                                                      TFJ11A
     C                   MOVEA     BDES(5)       BRBDES                                       TFJ11A
     C     JHTYPE        WHENEQ    '007'                                                      TFJ11A
     C                   MOVEA     BDES(6)       BRBDES                                       TFJ11A
     C                   EndSL

     C                   EVAL      BRSPTT = 0                                   Spread Total
     C                   EVAL      BRNIST = 0                                   No. of Items to Spre
     C                   EVAL      BRSPRF = *Blanks                             Spread Profile Code
     C                   EVAL      BRDCIN = *Blanks                             Debit/credit indicat
     C                   EVAL      BRIBCF = *Blanks                             Input Branch Cd  All
     C                   EVAL      BRCUSF = *Blanks                             Customer Number  All
     C                   EVAL      BRCYCF = *Blanks                             Currency Code    All
     C                   EVAL      BRACCF = *Blanks                             Account Code     All
     C                   EVAL      BRACSF = *Blanks                             Account Seq No.  All
     C                   EVAL      BRNNBF = *Blanks                             Nostro No. (Item)All
     C                   EVAL      BRRACF = 0                                   Retail A/c No.   All
     C                   EVAL      BRPRCF = *Blanks                             Profit Centre    All
     C                   EVAL      BRAMTF = 0                                   Amount           All
     C                   EVAL      BRIBCT = *Blanks                             Input Branch Cd  All
     C                   EVAL      BRCYCT = *Blanks                             Currency Code    All
     C                   EVAL      BRCNAT = *Blanks                             Customer Number  All
     C                   EVAL      BRACCT = *Blanks                             Account Code     All
     C                   EVAL      BRASNT = *Blanks                             Account Seq No.  All
     C                   EVAL      BRNNBT = *Blanks                             Nostro No. (Item)All
     C                   EVAL      BRRACT = 0                                   Retail A/c No.   All
     C                   EVAL      BRTOJE = 'J'                                 Type of Journal Entr
      *
      ** Output to file
     C                   WRITE     @BRREMA

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    PRetCode          7
     C                   PARM                    PProcTyp          1
     C                   PARM                    PSeqNo            3
      *
      ** Define Data Areas
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBFILE = *Blanks
     C                   EVAL      DBKEY  = *Blanks
     C                   EVAL      DBMOD  = *Blanks
     C                   EVAL      DBPROC = *Blanks
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C**** *DTAARA       DEFINE                  GLPBTCHDA
     C****               IN        GLPBTCHDA
     C     *DTAARA       DEFINE                  XXPBTCHDA
     C                   IN        XXPBTCHDA
      *
      ** Obtain Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'                          *************
     C                   EVAL      DBase = 001                                  * DBERR 001 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain the FTP incoming times from the Pooling ICD
     C****************** CALL      'AOPICDR0'                                   JMI108
     C                   CALL      'XXPICDR0'                                   JMI108
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C**** SDPICD        PARM      SDPICD        DSSDY                          JMI108
     C     XXPICD        PARM      XXPICD        DSSDY                          JMI108

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C*******************EVAL      DBFile = 'SDPICDPP'                          JMI108
     C                   EVAL      DBFile = 'XXPICDPP'                          JMI108
     C                   EVAL      DBKey = POptn                                *************
     C                   EVAL      DBase = 002                                  * DBERR 002 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey = POptn                                *************
     C                   EVAL      DBase = 003                                  * DBERR 003 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***Set*up*Key*List for SDPSTSV0                                           JMI108
      ** Set up Key List for XXPSTSV0                                           JMI108
     C     KSTAT         KLIST
     C                   KFLD                    KSeqNo            3            FTP File Seq No
     C                   KFLD                    KType             1            Type of file FTP
      *
      ***Set*up*Key*List for SDPLACV3                                           JMI108
      ** Set up Key List for XXPLACV3                                           JMI108
     C     KSPLAC        KLIST
     C                   KFLD                    KBRCH             3            Branch
     C                   KFLD                    KCCY              3            Currency
     C                   KFLD                    KSCHMI            1            Scheme Inter-Office
      *
      ***Set*up*Key*List for GLJEIPXA                                                  CHG002 JMI108
      ** Set up Key List for XXJEIPXA                                                         JMI108
     C     KJEIPX        KLIST                                                                CHG002
     C                   KFLD                    KBTCH             3                          CHG002
     C                   KFLD                    KBINB             3 0                        CHG002
      *                                                                                       CHG002
      ** Check if batch no. is not yet used, otherwise, get next available no.
     C                   MOVE      JBTCH         KBTCH                                        CHG002
     C                   Z-ADD     1             KBINB                                        CHG002
     C                   IF        JBTCH ='000'                                               CHG002
     C                   EVAL      JBTCH = '001'                                              CHG002
     C                   ENDIF                                                                CHG002
      *                                                                                       CHG002
     C     JBTCH         CHAIN     GLJEIHL1                           60
     C**** KJEIPX        CHAIN     GLJEIPYA                           63               CHG002 JMI108
     C     KJEIPX        CHAIN     XXJEIPYA                           63                      JMI108

     C     *IN60         DOWEQ     '0'
     C     *IN63         OREQ      '0'
     C                   MOVE      JBTCH         WBTCH
     C                   ADD       1             WBTCH
     C                   MOVE      WBTCH         JBTCH
     C                   IF        JBTCH ='000'
     C                   EVAL      JBTCH = '001'
     C                   ENDIF
     C                   MOVE      JBTCH         KBTCH                                        CHG002
     C     JBTCH         CHAIN     GLJEIHL1                           60
     C**** KJEIPX        CHAIN     GLJEIPYA                           63               CHG002 JMI108
     C     KJEIPX        CHAIN     XXJEIPYA                           63                      JMI108
     C                   ENDDO

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      PRetCode = '*Error'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2018
**  BDES
A/C POOLING - ACTUAL POOLING
A/C POOLING - REVERSE ENTRY
A/C POOLING - POOLING COMM
A/C POOLING - SWEEP COMM
A/C POOLING - A/C TRANSFER                                                                    TFJ11A
A/C POOLING - TRANSFER COMM                                                                   TFJ11A
