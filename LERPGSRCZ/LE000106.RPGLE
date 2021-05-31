     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Initialisation Program for CLE106')           *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000106 - Initialisation Program for CLE106                 *
      *                                                               *
      *  Function:  This module will initialise new fields in the     *
      *             following files:                                  *
      *                                                               *
      *  FCLTYFM - LE Facility File                                   *
      *                                                               *
      *  CLOANCL - LE Customer Loans File                             *
      *                                                               *
      *  LEFCLTQD - LE Facility Extension File                        *
      *                                                               *
      *  LEAGFTQD - LE Aggregate Facilities Trailer File              *
      *                                                               *
      *  LEPARTPD - LE Participant details files                      *
      *                                                               *
      *  MTRAND - LE Accrued Margin Adjustments File                  *
      *                                                               *
      *  LEFCAMPD - LE Facility Amendment File                        *
      *                                                               *
      *  LEAGAMPD - LE Aggregate Facility Amendment File              *
      *                                                               *
      *  MCLONCL - LE Matured Loans File                              *
      *                                                               *
      *  LEFEED - LE Fees Master Details File                         *
      *                                                               *
      *  LEADINPD - LE Adjustments to Accrued Interest Detail File    *
      *                                                               *
      *  STRAN - GL Single Transactions file                          *
      *                                                               *
      *  LOAMSDK - LE Loan Amendments file                            *
      *                                                               *
      *  LEFEEAD - LE Fees Settlement/Adjustment Detail File          *
      *                                                               *
      *  T_MLMTRAN - GP Manual Transactions File                      *
      *                                                               *
      *  LEMNFUPD - LE Manual Utilisation Transaction                 *
      *                                                               *
      *  LETREFPD - LE Transaction References File                    *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD026171           Date 07Apr14               *
      *  Prev Amend No. MD055657           Date 14May20               *
      *                 AR674226           Date 04Dec19               *
      *                 CER050             Date 16Jun19               *
      *                 CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD040963           Date 06Sep16               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE147             Date 30Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248520             Date 26Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106  *CREATE    Date 12Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026171 - Decimal data error occurred. Initialise field     *
      *             INMAAN to zero this will prevent the DBERR.       *
      *  MD055657 - Manual transaction from FFC TI Interface went to  *
      *             repair queue because the facility exchange rate is*
      *             longer than the defined facility exchange rate in *
      *             Midas. Increase the field definition of the Midas *
      *             facility exchange rate. (Recompile)               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040963 - CLE106 initialisation program ended in error      *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248520 - Initialise completely UTN field for fees, loans and *
      *           loan amendments.                                    *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE106 - Syndication Manager                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read indicator                                  *
      *    U7         Database error indicator                        *
      *    U8         Database error indicator                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+

      ** Midas LE Generated PC Reference file (Conssolidated)
     FLEPCRFL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RF_)

      ** Midas LE Facility File
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F                                     PREFIX(F)
      ** Midas LE Aggregate Facilities
     FLEAGFCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
     F                                     RENAME(FCLTYFMF:AGLTYFMF)
     F                                     PREFIX(A)
      ** Midas LE Customer Loans File
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     RENAME(CLOANCLF:CLOANC2F)
      ** Midas LE Facility Extension File
     FLEFCLTQD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Aggregate Facilities Trailer File
     FLEAGFTQD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(LEFCLTD0:LEAGFTD0)

      ** Midas LE Participant details files
     FLEPARTPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(PA)


      ** Midas LE Accrued Margin Adjustments File
     FMTRAND    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(M)

      ** Midas LE Facility Amendment File
     FLEFCAMPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(FC)

      ** Midas LE Aggregate Facility Amendment File
     FLEAGAMPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(LEFCAMPF:LEAGAMPF)
     F                                     PREFIX(AG)

      ** Midas LE Customer Loans File
     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Matured Loans File
     FMCLONCL   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(CLOANCLF:MCLONCLF)

      ** Midas LE Fees Master Details File
     FLEFEED    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(FE)

      ** Midas LE Adjustments to Accrued Interest Detail File
     FLEADINPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(IN)

      ** Midas GL Single Transactions file
     FSTRAN     UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(ST)

      ** Midas LE Loan Amendments file
     FLOAMSDK   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(DK)

      ** Midas LE Fees Settlement/Adjustment Detail File
     FLEFEEAD   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(FA)

      ** Midas GP Manual Transactions File
     FT_MLMTRAN UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(T_MLMTRAN:MLMTRAN)

      ** Midas LE Manual Utilisation Transaction
     FLEMNFUL9  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas LE Transaction References File
     F***LETREFPD  O    E             DISK    INFSR(*PSSR)                                  MD040963
     FLETREFL0  UF A E           K DISK    INFSR(*PSSR)                                     MD040963
     F                                     COMMIT
     F                                     PREFIX(TR)

      ** Midas LE Aggregate Facilities
     FLEFEEDFC  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEADF)

      ** Midas LE Printer File for LE000106
     FLE000106P1O    E             PRINTER INFDS(SPOOL)
     F                                     INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** Ê D-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+

      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+

     D FIRSTTIME       S              1

     D WRUN            S              1
     D KRCTP           S              1
     D WKCNUM          S              6
     D WKFACT          S              3
     D WKFCNO          S              2
     D WKLAST          S              8
     D WKSQNO          S              3
     D WKYYYY          S              8
     D WKLNRF          S              6
     D WKLASN          S              3
     D @BRCD           S              3
     D PRDNB           S              5P 0
     D PCHGDAT         S              8S 0
     D PRTN            S              1A
     D TIMESTAMP       S             26Z
     D WKFSEQ          S              2
     D KFACL           S              5  0
     D FEEKEY          S             11  0
     D WKFILE          S             10
     D WKMODE          S              6
     D PMODE           S              1
     D WKRQDLIN        S              3S 0
     D WKDIFLIN        S              3S 0
      ** ZSEdit parms
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
      *** Facility Key Data Structure
     D FACKEY          DS            12
     D**KCNUM***               1      6  0                                                   CSD027A
     D  KCNUM                  1      6                                                      CSD027A
     D  KFACT                  7      9  0
     D  KFCNO                 10     11  0
     D  KRCPT                 12     12
      *** Data Structure for ZZ199 field of STRAN
     D STZZ199         DS
     D**INLNRF**               1      6  0                                                    CLE148
     D  INLNRF                 1      6                                                       CLE148
     D**INCNUM**               7     12  0                                                   CSD027A
     D  INCNUM                 7     12                                                      CSD027A
     D  INCCY                 13     15
     D  INADJA                16     22P 0
     D  INADJS                23     23
     D  INBRCA                24     26
     D**INFCUS**              27     32  0                                                   CSD027A
     D  INFCUS                27     32                                                      CSD027A
     D  INFTYP                33     35  0
     D  INFSEQ                36     37  0
     D  INACAJ                68     74P 0
     D  INCASN                75     75
     D**INMAAN**              76     82P 0                                                  MD026171
     D  INMAAN                76     82P 0 INZ(0)                                           MD026171
     D  INMASN                83     83
     D  INUDTM               188    193  0
     D  NAVT                 194    196  0
     D  NATN                 197    199  0
      *                                                                                       248520
     D WTREF           DS                                                                     248520
     D WPCRF                   1     15                                                       248520
     D WBRCA                   1      3                                                       248520
     D WRK12                   4     15                                                       248520

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

     D QQDFAC2       E                     EXTFLD(QQDFAC)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * LE Loans details Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** LEALLO Data Structure
     D LEALLO        E DS                  EXTNAME(LEALLO)
     D**********                           DTAARA(LEALLO)                                     CLE148

      ** LEMUTN Data Structure
     D LEMUTN        E DS                  EXTNAME(LEMUTN)
     D                                     DTAARA(LEMUTN)
     D MCLAST        E                     EXTFLD(PCLAST)
     D MILLER        E                     EXTFLD(FILLER)

      ** File Information Data Structure for LE000106P1
     D SPOOL           DS
     D  WKOVRFLW             188    189B 0
     D  WKCRTLIN             367    368B 0
      *
     D PRTCD           S              7A                                                      CLE148
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C                   SELECT

     C                   WHEN      PMODE = 'U'
     C                   EVAL      WKMODE = 'Update'

     C                   WHEN      PMODE = 'A'
     C                   EVAL      WKMODE = 'Audit'

     C                   ENDSL

      ** Initialise new PCRF field on Accrued Margin Adjustment File

     C                   EVAL      WKLAST = *BLANKS

     C     1             SETLL     MTRAND
     C                   READ      MTRAND                                 01

     C                   DOW       *IN01 = *OFF
     C                   IF        MRECI = 'J'

     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      MPCRF = MBRCA + WKLAST + '0001'
     C                   MOVEL     'A'           MASTS
     C                   MOVEL     'I'           MCHTP
     C                   MOVEL     'MM'          MAMTP

     C                   IF        PMODE = 'U'
     C                   UPDATE    MTRANDF
     C                   ENDIF

     C                   ENDIF

     C                   READ      MTRAND                                 01

     C                   ENDDO

      * Initialise new fields on Facility Extension File
     C                   EVAL      WKFILE = 'LEFCLTQD'

     C                   WRITE     HEADFCLT

     C     1             SETLL     LEFCLTQD
     C                   READ      LEFCLTQD                               01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRNODETL
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

     C                   Z-ADD     *ZEROS        FCXAFA
     C                   EVAL      FCXFAS = ' '
     C                   EVAL      FCXAFC = '  '
     C                   Z-ADD     *ZEROS        FCXFBC
     C                   Z-ADD     *ZEROS        FCXFBR
     C                   Z-ADD     *ZEROS        FCXFSR
     C                   EVAL      FCXSRS = ' '
     C                   Z-ADD     *ZEROS        FCXFFR
     C                   EVAL      FCXRLT = '  '
     C                   EVAL      FCXRLS = '  '
     C                   Z-ADD     *ZEROS        FCXPRT
     C                   Z-ADD     *ZEROS        FCXPFR
     C                   Z-ADD     *ZEROS        FCXPSR
     C                   EVAL      FCXSLT = '  '
     C                   EVAL      FCXSLS = '  '
     C                   MOVEL     FCXFCU        KCNUM
     C                   MOVEL     FCXFTP        KFACT
     C                   MOVEL     FCXFNO        KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        FLPTP = 'P' AND FLPAM <> 0
     C                   IF        FLPBR = 0
     C                   MOVE      FLPAM         FCXPFR
     C                   ELSE
     C                   MOVE      FLPAM         FCXPSR
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FCXSLT = FDFTP
     C                   EVAL      FCXSLS = FDFST
     C                   EVAL      FCXSLC = FDFCL                                             CLE042
     C                   EVAL      FCXAMT = FFAMT

     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEFCLTD0
     C                   ENDIF

     C                   READ      LEFCLTQD                               01

     C                   ENDDO

      * Initialise new fields on Aggregate Facilities Trailer File
     C                   EVAL      WKFILE = 'LEAGFTQD'

     C                   WRITE     HEADAGFT

     C     1             SETLL     LEAGFTQD
     C                   READ      LEAGFTQD                               01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRNODETL
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

     C                   Z-ADD     *ZEROS        FCXAFA
     C                   EVAL      FCXFAS = ' '
     C                   EVAL      FCXAFC = '  '
     C                   Z-ADD     *ZEROS        FCXFBC
     C                   Z-ADD     *ZEROS        FCXFBR
     C                   Z-ADD     *ZEROS        FCXFSR
     C                   EVAL      FCXSRS = ' '
     C                   Z-ADD     *ZEROS        FCXFFR
     C                   EVAL      FCXRLT = '  '
     C                   EVAL      FCXRLS = '  '
     C                   Z-ADD     *ZEROS        FCXPRT
     C                   Z-ADD     *ZEROS        FCXPFR
     C                   Z-ADD     *ZEROS        FCXPSR
     C                   EVAL      FCXSLT = '  '
     C                   EVAL      FCXSLS = '  '
     C                   MOVEL     FCXFCU        KCNUM
     C                   MOVEL     FCXFTP        KFACT
     C                   MOVEL     FCXFNO        KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     LEAGFCL0

     C                   IF        NOT %FOUND(LEAGFCL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'LEAGFMPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        ALPTP = 'P' AND ALPAM <> 0
     C                   IF        ALPBR = 0
     C                   MOVE      ALPAM         FCXPFR
     C                   ELSE
     C                   MOVE      ALPAM         FCXPSR
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FCXSLT = ADFTP
     C                   EVAL      FCXSLS = ADFST
     C                   EVAL      FCXSLC = ADFCL                                             CLE042
     C                   EVAL      FCXAMT = AFAMT

     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEAGFTD0
     C                   ENDIF

     C                   READ      LEAGFTQD                               01

     C                   ENDDO

      * Initialise new fields on Assignments File:
     C     1             SETLL     LEPARTPD
     C                   READ      LEPARTPD                               01

     C                   DOW       *IN01 = *OFF

     C                   EVAL      PAPRTR = ' '
     C                   Z-ADD     *ZEROS        PAAFEE
     C                   EVAL      PAAGFS = ' '
     C                   EVAL      PAAFCD = '  '
     C                   Z-ADD     *ZEROS        PAASFE
     C                   EVAL      PAASFS = ' '
     C                   EVAL      PAASCD = '  '
     C                   EVAL      PAGTYP = ' '
     C                   Z-ADD     *ZEROS        PASEQN

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEPARTD0
     C                   ENDIF

     C                   READ      LEPARTPD                               01

     C                   ENDDO

      ** Initialise new fields on Facility Amendment File

     C                   EVAL      WKFILE = 'LEFCAMPD'

     C                   WRITE     HEADFCAM

     C     1             SETLL     LEFCAMPD
     C                   READ      LEFCAMPD                               01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRNODETL
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

     C                   MOVEL     FCCNUM        KCNUM
     C                   MOVEL     FCFACT        KFACT
     C                   MOVEL     FCFCNO        KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      FCNPRT = 'N'

     C                   IF        FCPCRF = *BLANKS

     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      FCPCRF = FCBRCA + WKLAST + '0001'
     C                   ENDIF

     C                   EVAL      TRPCRF = FCPCRF
     C                   EVAL      TRBRCA = FCBRCA
     C                   EVAL      TRCNUM = FCCNUM
     C                   EVAL      TRFACT = FCFACT
     C                   EVAL      TRFCNO = FCFCNO
     C**********         EVAL      TRLNRF = 0                                                 CLE148
     C                   EVAL      TRLNRF = *BLANKS                                           CLE148

     C                   SELECT
     C                   WHEN      FCFATP = 'FI'
     C                   EVAL      TRTDSC = 'Facility Increase'
     C                   WHEN      FCFATP = 'FD'
     C                   EVAL      TRTDSC = 'Facility Decrease'
     C                   WHEN      FCFATP = 'RC'
     C                   EVAL      TRTDSC = 'Revolving Credit Change'
     C                   WHEN      FCFATP = 'FR'
     C                   EVAL      TRTDSC = 'Facility Reactivation'
     C                   ENDSL

     C                   IF        FCCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        FCAUSR <> *BLANKS
     C                   EVAL      TRUSID = FCAUSR
     C                   ELSE
     C                   EVAL      TRUSID = FCIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = FPCRF
     C                   MOVEL     FCCNUM        WKCNUM
     C                   MOVEL     FCFACT        WKFACT
     C                   MOVEL     FCFCNO        WKFCNO
     C                   MOVEL     FCSQNO        WKSQNO

      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C                   CALLB     'ZDATE9'
     C                   PARM      FCVLDT        PRDNB
     C                   PARM      0             PCHGDAT
     C                   PARM                    PRTN

     C                   MOVEL     PCHGDAT       WKYYYY

     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO + '¦' + FCFATP + '¦' +
     C                                      WKYYYY + '¦' + WKSQNO

     C                   SELECT
     C                   WHEN      FCFATP = 'FI'
     C                   EVAL      TRTRTP = 'FAMD FI'
     C                   WHEN      FCFATP = 'FD'
     C                   EVAL      TRTRTP = 'FAMD FD'
     C                   WHEN      FCFATP = 'RC'
     C                   EVAL      TRTRTP = 'FAMD RC'
     C                   WHEN      FCFATP = 'FR'
     C                   EVAL      TRTRTP = 'FAMD FR'
     C                   ENDSL

     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   UPDATE    LEFCAMPF
     C                   ENDIF

     C                   READ      LEFCAMPD                               01
     C                   ENDDO

      ** Initialise new field on Aggregate Facility Amendment File

     C                   EVAL      WKFILE = 'LEAGAMPD'

     C                   WRITE     HEADAGAM

     C     1             SETLL     LEAGAMPD
     C                   READ      LEAGAMPD                               01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRNODETL
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

     C                   MOVEL     AGCNUM        KCNUM
     C                   MOVEL     AGFACT        KFACT
     C                   MOVEL     AGFCNO        KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     LEAGFCL0

     C                   IF        NOT %FOUND(LEAGFCL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'LEAGFMPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      AGNPRT = 'N'

     C                   IF        AGPCRF = *BLANKS
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      AGPCRF = AGBRCA + WKLAST + '0001'
     C                   ENDIF

     C                   EVAL      TRPCRF = AGPCRF
     C                   EVAL      TRBRCA = AGBRCA
     C                   EVAL      TRCNUM = AGCNUM
     C                   EVAL      TRFACT = AGFACT
     C                   EVAL      TRFCNO = AGFCNO
     C**********         EVAL      TRLNRF = 0                                                 CLE148
     C                   EVAL      TRLNRF = *BLANKS                                           CLE148

     C                   SELECT
     C                   WHEN      AGFATP = 'FI'
     C                   EVAL      TRTDSC = 'Facility Increase'
     C                   WHEN      AGFATP = 'FD'
     C                   EVAL      TRTDSC = 'Facility Decrease'
     C                   WHEN      AGFATP = 'RC'
     C                   EVAL      TRTDSC = 'Revolving Credit Change'
     C                   WHEN      AGFATP = 'FR'
     C                   EVAL      TRTDSC = 'Facility Reactivation'
     C                   ENDSL

     C                   IF        AGCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        AGAUSR <> *BLANKS
     C                   EVAL      TRUSID = AGAUSR
     C                   ELSE
     C                   EVAL      TRUSID = AGIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = FPCRF
     C                   MOVEL     FCCNUM        WKCNUM
     C                   MOVEL     FCFACT        WKFACT
     C                   MOVEL     FCFCNO        WKFCNO
     C                   MOVEL     FCSQNO        WKSQNO

      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C                   CALLB     'ZDATE9'
     C                   PARM      FCVLDT        PRDNB
     C                   PARM      0             PCHGDAT
     C                   PARM                    PRTN

     C                   MOVEL     PCHGDAT       WKYYYY

     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO + '¦' + FCFATP + '¦' +
     C                                      WKYYYY + '¦' + WKSQNO

     C                   SELECT
     C                   WHEN      FCFATP = 'FI'
     C                   EVAL      TRTRTP = 'FAMD FI'
     C                   WHEN      FCFATP = 'FD'
     C                   EVAL      TRTRTP = 'FAMD FD'
     C                   WHEN      FCFATP = 'RC'
     C                   EVAL      TRTRTP = 'FAMD RC'
     C                   WHEN      FCFATP = 'FR'
     C                   EVAL      TRTRTP = 'FAMD FR'
     C                   ENDSL

     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   UPDATE    LEAGAMPF
     C                   ENDIF

     C                   READ      LEAGAMPD                               01
     C                   ENDDO

      ** Initialise new fields on Customer Loans File

     C                   EVAL      WKFILE = 'CLOANCL'

     C                   WRITE     HEADLOAN
     C     1             SETLL     CLOANCL
     C                   READ      CLOANCL                                01

     C                   DOW       *IN01 = *OFF

     C**********         IF        PTFC = 0                                                  CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A

     C                   EVAL      TRCNUM = FCUS
     C                   EVAL      TRFACT = FTYP
     C                   EVAL      TRFCNO = FSEQ
     C                   MOVEL     FCUS          KCNUM
     C                   MOVEL     FTYP          KFACT
     C                   MOVEL     FSEQ          KFCNO

     C                   ELSE

     C                   EVAL      TRCNUM = PTFC
     C                   EVAL      TRFACT = PTFT
     C                   EVAL      TRFCNO = PTFN
     C                   MOVEL     PTFC          KCNUM
     C                   MOVEL     PTFT          KFACT
     C                   MOVEL     PTFN          KFCNO

     C                   ENDIF

     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SLTP = DFTP
     C                   EVAL      SLST = DFST
     C                   EVAL      SLCL = DFCL                                                CLE042

     C                   MOVE      PCRF          WPCRF                                        248520
      *                                                                                       248520
     C                   IF        PCRF = *BLANKS
     C                             OR WBRCA = *BLANKS                                         248520
      *                                                                                       248520
     C                   IF        PCRF = *BLANKS                                             248520
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      PCRF = BRCA + WKLAST + '0001'
      *                                                                                       248520
     C                   ELSE                                                                 248520
     C                   EVAL      PCRF  = BRCA + WRK12                                       248520
     C                   ENDIF                                                                248520
      *                                                                                       248520
     C                   ENDIF

     C                   EVAL      TRPCRF = PCRF
     C                   EVAL      TRBRCA = BRCA
     C                   EVAL      TRLNRF = LNRF

     C                   SELECT
     C                   WHEN      PTYP = 61 OR PTYP = 62 OR PTYP = 63
     C                             OR PTYP = 70 OR PTYP = 80
     C                   EVAL      TRTDSC = 'Loans'
     C                   WHEN      PTYP = 64 OR PTYP = 65 OR PTYP = 68
     C                             OR PTYP = 71
     C                   EVAL      TRTDSC = 'Parts Purchased'
     C                   WHEN      PTYP = 66 OR PTYP = 67 OR PTYP = 69
     C                             OR PTYP = 72
     C                   EVAL      TRTDSC = 'Parts Sold'
     C                   ENDSL

     C                   IF        CHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        AUSR <> *BLANKS
     C                   EVAL      TRUSID = AUSR
     C                   ELSE
     C                   EVAL      TRUSID = IUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = FPCRF
     C                   MOVEL     LNRF          WKLNRF
     C                   EVAL      TRAREF = WKLNRF + '¦' + 'E'
     C                   EVAL      TRTRTP = 'CLIP'
     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   UPDATE    CLOANCLF
     C                   ENDIF

     C                   READ      CLOANCL                                01

     C                   ENDDO

      ** Initialise new fields on Matured Loans File

     C                   EVAL      WKFILE = 'MCLONCL'

     C                   WRITE     HEADMOAN

     C     1             SETLL     MCLONCL
     C                   READ      MCLONCL                                01

     C                   DOW       *IN01 = *OFF

     C                   EVAL      SLTP = DFTP
     C                   EVAL      SLST = DFST
     C                   EVAL      SLCL = DFCL                                                CLE042

     C                   EXSR      SRREPORT

     c                   IF        PMODE = 'U'
     C                   UPDATE    MCLONCLF
     C                   ENDIF

     C                   READ      MCLONCL                                01
     C                   ENDDO

      ** Initialise new fields on Fees Master Details File

     C                   EVAL      WKFILE = 'LEFEED'

     C     1             SETLL     LEFEED
     C                   EVAL      FEPCRF = *BLANKS
     C                   EVAL      FIRSTTIME = 'Y'

     C                   READ      LEFEED                                 01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRNODETL
     C                   ENDIF

     C                   DOW       *IN01 = *OFF

     C                   IF        FEFERECI = 'D'

     C**********         IF        FEFELOAN = 0                                               CLE148
     C                   IF        FEFELOAN = *BLANKS                                         CLE148

     C                   EVAL      *IN30 = *OFF
     C                   MOVEL     FEFECNUM      KCNUM
     C                   MOVEL     FEFEFACL      KFACT
     C                   MOVE      FEFEFACL      KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      FEFESYIN = FSYIN

     C                   ELSE

     C                   EVAL      *IN30 = *ON
     C     FEFELOAN      CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     FEFELOAN      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         IF        PTFC = 0                                                  CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A
     C                   MOVEL     FCUS          KCNUM
     C                   MOVEL     FTYP          KFACT
     C                   MOVEL     FSEQ          KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      FEFESYIN = FSYIN

     C                   ELSE

     C                   MOVEL     PTFC          KCNUM
     C                   MOVEL     PTFT          KFACT
     C                   MOVEL     PTFN          KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      FEFESYIN = FSYIN
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      FEFEMASF = 'N'
     C                   MOVE      FEPCRF        WPCRF                                        248520

     C                   IF        FEPCRF = *BLANKS
     C                             OR WBRCA = *BLANKS                                         248520
      *                                                                                       248520
     C                   IF        FEPCRF = *BLANKS                                           248520
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      FEPCRF = FEFEBRCA + WKLAST + '0001'
      *                                                                                       248520
     C                   ELSE                                                                 248520
     C                   EVAL      FEPCRF = FEFEBRCA + WRK12                                  248520
      *                                                                                       248520
     C                   ENDIF                                                                248520
     C                   ENDIF

     C**********         IF        PTFC = 0                                                  CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A

     C                   EVAL      TRCNUM = FCUS
     C                   EVAL      TRFACT = FTYP
     C                   EVAL      TRFCNO = FSEQ

     C                   ELSE

     C                   EVAL      TRCNUM = PTFC
     C                   EVAL      TRFACT = PTFT
     C                   EVAL      TRFCNO = PTFN

     C                   ENDIF

     C                   EVAL      TRPCRF = FEPCRF
     C                   EVAL      TRBRCA = FEFEBRCA
     C                   EVAL      TRLNRF = FEFELOAN

     C**********         IF        FEFELOAN = 0                                               CLE148
     C                   IF        FEFELOAN = *BLANKS                                         CLE148
     C                   EVAL      TRTDSC = 'Facility Fees'
     C                   ELSE
     C                   EVAL      TRTDSC = 'Loan Fees'
     C                   ENDIF

     C                   IF        FEFELCHT = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        FEAUSR <> *BLANKS
     C                   EVAL      TRUSID = FEAUSR
     C                   ELSE
     C                   EVAL      TRUSID = FEIUSR
     C                   ENDIF

     C**********         IF        FEFELOAN = 0                                               CLE148
     C                   IF        FEFELOAN = *BLANKS                                         CLE148
     C                   EVAL      TRSPRN = FPCRF
     C                   ELSE
     C                   EVAL      TRSPRN = PCRF
     C                   ENDIF

     C                   MOVEL     FEFEFSEQ      WKFSEQ
     C                   MOVEL     KFCNO         WKFCNO
     C                   MOVEL     FEFELOAN      WKLNRF
     C                   MOVEL     FEFECNUM      WKCNUM

     C**********         IF        FEFELOAN = 0                                               CLE148
     C                   IF        FEFELOAN = *BLANKS                                         CLE148
     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO + '¦¦' + WKFSEQ
     C                   ELSE
     C                   EVAL      TRAREF = WKCNUM + '¦¦¦' + WKLNRF +
     C                                      '¦' + WKFSEQ
     C                   ENDIF

     C                   EVAL      TRTRTP = 'FEEM'

     C                   EXSR      SRREPORT

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   UPDATE    LEFEEDF
     C                   ENDIF

     C                   ENDIF

     C                   READ      LEFEED                                 01

     C                   ENDDO

      ** Initialise new fields on Adjustments to Accrued Interest Detail File

     C     1             SETLL     STRAN
     C                   READ      STRAN                                  01

     C                   DOW       *IN01 = *OFF

     C                   IF        STRECI = 'J'
     C                   EVAL      INRECI = 'D'
     C                   EVAL      INZZ120 = *BLANKS
     C                   EVAL      INTNLU = NATN
     C                   EVAL      INASTS = 'A'
     C                   EVAL      INCHTP = 'I'
     C                   EVAL      INAMTP = 'MI'
     C                   MOVEL     CNUM          WKCNUM

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      WKCNUM        @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     WKCNUM        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      INCRNM = BBCRNM
     C                   EVAL      INCTWN = BBCRTN
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C     INLNRF        CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     INLNRF        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      INPCRF = INBRCA + WKLAST + '0001'

     C                   IF        PMODE = 'U'
     C                   WRITE     LEADINP0
     C                   DELETE    STRANF
     C                   ENDIF

     C                   ENDIF

     C                   READ      STRAN                                  01

     C                   ENDDO

     ** Initialise PC Reference fields

     C                   EXSR      SRINITPCRF

     ** Initialise new fields on Manual Transactions File

     C     1             SETLL     T_MLMTRAN
     C                   READ      T_MLMTRAN                              01

     C                   DOW       *IN01 = *OFF

     C                   IF        MTUTN = *BLANKS
     C     *LOCK         IN        LEMUTN
     C                   MOVEL     MCLAST        WKLAST
     C                   EVAL      MCLAST = MCLAST + 1
     C                   OUT       LEMUTN
     C                   EVAL      MTUTN = 'LE0' + WKLAST + '0001'
     C                   ENDIF

     C                   IF        MTFACCUST <> *BLANKS AND MTFACTYPE <> *BLANKS
     C                             AND MTFACSEQ <> *BLANKS
     C                   EVAL      @BRCD = MTBRCHCODE

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     MTFACCUST     KCNUM
     C                   MOVEL     MTFACTYPE     KFACT
     C                   MOVEL     MTFACSEQ      KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      MTFUTN = FPCRF

     C     MTID          CHAIN     LEMNFUL9

     C                   IF        NOT %FOUND(LEMNFUL9)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'LEMNFUPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   MOVEL     MTID          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      MUTN = MTUTN
     C                   EVAL      FUTN = MTFUTN

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEMNFUPF
     C                   ENDIF

     C                   ENDIF

     C                   IF        PMODE = 'U'
     C                   UPDATE    MLMTRAN
     C                   ENDIF

     C                   ENDIF

     C                   READ      T_MLMTRAN                              01

     C                   ENDDO

     ** Populate Transaction Reference File (LETREFPD)

     C                   EXSR      SRPOPLTREF

     C                   EXSR      SRSKIPPAGE
     C                   WRITE     TRAILPY

     C                   IF        PMODE = 'U'
     C                   COMMIT
     C                   ENDIF

     C                   EXSR      SRENDPGM


      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRINITPCRF - Initialise PC Reference fields                       *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRINITPCRF    BEGSR

      ** FCLTYFM
     C     *LOVAL        SETLL     FCLTY
     C                   READ      FCLTY                                  01

     C                   DOW       *IN01 = *OFF

     C                   IF        FPCRF = *BLANKS
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      FPCRF = FBRCA + WKLAST + '0001'

     C                   IF        PMODE = 'U'
     C                   UPDATE    FCLTYFMF
     C                   ENDIF

     C                   ENDIF

     C                   READ      FCLTY                                  01

     C                   ENDDO

      ** LOAMSDK
     C     1             SETLL     LOAMSDK
     C                   READ      LOAMSDK                                01

     C                   DOW       *IN01 = *OFF

     C                   MOVE      DKPCRF        WPCRF                                        248520
      *                                                                                       248520
     C                   IF        DKPCRF = *BLANKS
     C                             OR WBRCA = *BLANKS                                         248520
      *                                                                                       248520
     C                   IF        DKPCRF = *BLANKS                                           248520
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      DKPCRF = DKBRCA + WKLAST + '0001'
     C                   ENDIF                                                                248520
      *                                                                                       248520
     C                   IF        WBRCA = *BLANKS                                            248520
     C                   EVAL      DKPCRF = DKBRCA + WRK12                                    248520
     C                   ENDIF                                                                248520

     C                   IF        PMODE = 'U'
     C                   UPDATE    LOAMSDKF
     C                   ENDIF

     C                   ENDIF

     C                   READ      LOAMSDK                                01

     C                   ENDDO

      ** LEFEEAD
     C     1             SETLL     LEFEEAD
     C                   READ      LEFEEAD                                01

     C                   DOW       *IN01 = *OFF

     C                   IF        FAPCRF = *BLANKS
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         MOVEL     PCLAST        WKLAST                                       CLE148
     C**********         EVAL      PCLAST = PCLAST + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVEL     PCLAST        WKLAST                                       CLE148

     C                   EVAL      FAPCRF = FAFABRCA + WKLAST + '0001'

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEFEEADF
     C                   ENDIF

     C                   ENDIF

     C                   READ      LEFEEAD                                01

     C                   ENDDO

     C                   ENDSR
      /EJECT
      *********************************************************************
      *
      * SRPOPLTREF - Populate Transaction Reference File (LETREFPD)       *
      *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRPOPLTREF    BEGSR

      ** FCLTYFM
     C     *LOVAL        SETLL     FCLTY
     C                   READ      FCLTY                                  01

     C                   DOW       *IN01 = *OFF

     C                   EVAL      TRPCRF = FPCRF
     C                   EVAL      TRBRCA = FBRCA
     C                   EVAL      TRCNUM = FCNUM
     C                   EVAL      TRFACT = FFACT
     C                   EVAL      TRFCNO = FFCNO
     C**********         EVAL      TRLNRF = 0                                                 CLE148
     C                   EVAL      TRLNRF = *BLANKS                                           CLE148
     C                   EVAL      TRTDSC = 'Facility'

     C                   IF        FCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        FAUSR <> *BLANKS
     C                   EVAL      TRUSID = FAUSR
     C                   ELSE
     C                   EVAL      TRUSID = FIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = *BLANKS
     C                   MOVEL     FCNUM         WKCNUM
     C                   MOVEL     FFACT         WKFACT
     C                   MOVEL     FFCNO         WKFCNO
     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO
     C                   EVAL      TRTRTP = 'FCIP'

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   READ      FCLTY                                  01

     C                   ENDDO

      ** LOAMSDK
     C     1             SETLL     LOAMSDK
     C                   READ      LOAMSDK                                01

     C                   DOW       *IN01 = *OFF
     C
     C                   IF        DKAMTP <> 'PT'

     C     DKLNRF        CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   Z-ADD     14            DBASE
     C                   MOVEL     DKLNRF        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      SRLOANFCLTY
     C                   EVAL      TRPCRF = DKPCRF
     C                   EVAL      TRBRCA = DKBRCA
     C                   EVAL      TRLNRF = DKLNRF

     C                   SELECT
     C                   WHEN      DKAMTP = 'BC'
     C                   EVAL      TRTDSC = 'Base Rate Code Change'
     C                   WHEN      DKAMTP = 'SC'
     C                   EVAL      TRTDSC = 'Fixed/Spread Rate Change'
     C                   WHEN      DKAMTP = 'LS'
     C                   EVAL      TRTDSC = 'Loan Subtype Change'
     C                   WHEN      DKAMTP = 'SA'
     C                   EVAL      TRTDSC = 'Stop / Start Accrual'
     C                   WHEN      DKAMTP = 'PI'
     C                   EVAL      TRTDSC = 'Principal Increase'
     C                   WHEN      DKAMTP = 'MR'
     C                   EVAL      TRTDSC = 'Manual Repayment'
     C                   WHEN      DKAMTP = 'RE'
     C                   EVAL      TRTDSC = 'Repayment Schedule'
     C                   WHEN      DKAMTP = 'PF'
     C                   EVAL      TRTDSC = 'Principal Transfer'
     C                   ENDSL

     C                   IF        DKCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        DKAUSR <> *BLANKS
     C                   EVAL      TRUSID = DKAUSR
     C                   ELSE
     C                   EVAL      TRUSID = DKIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = PCRF
     C                   MOVEL     DKLNRF        WKLNRF
     C                   MOVEL     DKLASN        WKLASN
      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C                   CALLB     'ZDATE9'
     C                   PARM      DKVDAT        PRDNB
     C                   PARM      0             PCHGDAT
     C                   PARM                    PRTN

     C                   MOVEL     PCHGDAT       WKYYYY
     C                   EVAL      TRAREF = WKLNRF + '¦' + WKYYYY + '¦' +
     C                                      WKLASN
     C                   SELECT
     C                   WHEN      DKAMTP = 'BC'
     C                   EVAL      TRTRTP = 'LOAM BC'
     C                   WHEN      DKAMTP = 'SC'
     C                   EVAL      TRTRTP = 'LOAM SC'
     C                   WHEN      DKAMTP = 'LS'
     C                   EVAL      TRTRTP = 'LOAM LS'
     C                   WHEN      DKAMTP = 'SA'
     C                   EVAL      TRTRTP = 'LOAM SA'
     C                   WHEN      DKAMTP = 'PI'
     C                   EVAL      TRTRTP = 'LOAM PI'
     C                   WHEN      DKAMTP = 'MR'
     C                   EVAL      TRTRTP = 'MAPY'
     C                   WHEN      DKAMTP = 'RE'
     C                   EVAL      TRTRTP = 'RPSC'
     C                   WHEN      DKAMTP = 'PF'
     C                   EVAL      TRTRTP = 'PTPF'
     C                   ENDSL

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   ENDIF

     C                   READ      LOAMSDK                                01
     C                   ENDDO

      ** LEADINPD
     C     1             SETLL     LEADINPD
     C                   READ      LEADINPD                               01

     C                   DOW       *IN01 = *OFF

     C     INLNRF        CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   Z-ADD     15            DBASE
     C                   MOVEL     DKLNRF        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      SRLOANFCLTY
     C                   EVAL      TRPCRF = INPCRF
     C                   EVAL      TRBRCA = INBRCA
     C                   EVAL      TRLNRF = INLNRF
     C                   EVAL      TRTDSC = 'Adjustments to Accrued Interest'

     C                   IF        INCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        INAUSR <> *BLANKS
     C                   EVAL      TRUSID = INAUSR
     C                   ELSE
     C                   EVAL      TRUSID = INIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = PCRF
     C                   MOVEL     LNRF          TRAREF
     C                   EVAL      TRTRTP = 'AIAJ'

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   READ      LEADINPD                               01

     C                   ENDDO

      ** MTRAND
     C     1             SETLL     MTRAND
     C                   READ      MTRAND                                 01

     C                   DOW       *IN01 = *OFF

     C                   IF        MRECI = 'J'

     C     MLNRF         CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'CLOANCL'     DBFILE
     C                   Z-ADD     16            DBASE
     C                   MOVEL     MLNRF         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      SRLOANFCLTY
     C                   EVAL      TRPCRF = MPCRF
     C                   EVAL      TRBRCA = MBRCA
     C                   EVAL      TRLNRF = MLNRF
     C                   EVAL      TRTDSC = 'Adjustments to Accrued Margin'

     C                   IF        MCHTP = 'I'
     C                   EVAL      TRACTM = 'I'
     C                   ELSE
     C                   EVAL      TRACTM = 'A'
     C                   ENDIF

     C                   IF        MAUSR <> *BLANKS
     C                   EVAL      TRUSID = MAUSR
     C                   ELSE
     C                   EVAL      TRUSID = MIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = PCRF
     C                   MOVEL     LNRF          TRAREF
     C                   EVAL      TRTRTP = 'AMAJ'

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   ENDIF

     C                   READ      MTRAND                                 01

     C                   ENDDO

      ** LEFEEAD
     C     1             SETLL     LEFEEAD
     C                   READ      LEFEEAD                                01

     C                   DOW       *IN01 = *OFF

     C                   IF        FAFARECI <> '*'
     C                   MOVEL     FAFACNUM      KCNUM
     C                   MOVEL     FAFAFACL      KFACL
     C                   MOVEL     FAFAFACL      KFACT
     C                   MOVE      FAFAFACL      KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFEE        CHAIN     LEFEEDFC

     C                   MOVEL     KCNUM         FEEKEY
     C                   MOVE      KFACL         FEEKEY

     C                   IF        NOT %FOUND(LEFEEDFC)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'LEFEED'      DBFILE
     C                   Z-ADD     17            DBASE
     C                   MOVEL     FEEKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     18            DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      TRPCRF = FAPCRF
     C                   EVAL      TRBRCA = FAFABRCA
     C                   EVAL      TRCNUM = FAFACNUM
     C                   EVAL      TRFACT = KFACT
     C                   EVAL      TRFCNO = KFCNO
     C**********         EVAL      TRLNRF = 0                                                 CLE148
     C                   EVAL      TRLNRF = *BLANKS                                           CLE148
     C                   SELECT
     C                   WHEN      FAFARECI = 'A'
     C                   EVAL      TRTDSC = 'Fee Adjustment'
     C                   WHEN      FAFARECI = 'S'
     C                   EVAL      TRTDSC = 'Fee Settlement'
     C                   ENDSL

     C                   IF        FAFAACTN = 'I'
     C                   EVAL      TRACTM = 'A'
     C                   ELSE
     C                   EVAL      TRACTM = 'I'
     C                   ENDIF

     C                   IF        FAAUSR <> *BLANKS
     C                   EVAL      TRUSID = FAAUSR
     C                   ELSE
     C                   EVAL      TRUSID = FAIUSR
     C                   ENDIF

     C                   EVAL      TRSPRN = FEPCRF
     C                   MOVEL     FAFACNUM      WKCNUM
     C                   MOVEL     FAFAFACL      WKFACT
     C                   MOVE      FAFAFACL      WKFCNO
     C                   MOVEL     FAFAFSEQ      WKFSEQ

      ** Convert Midas Day No to YYYYMMDD format for Change Date
     C                   CALLB     'ZDATE9'
     C                   PARM      FAFAVDAT      PRDNB
     C                   PARM      0             PCHGDAT
     C                   PARM                    PRTN

     C                   MOVEL     PCHGDAT       WKYYYY

     C                   SELECT
     C                   WHEN      FAFARECI = 'A'
     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO + '¦' + WKFSEQ
     C                   EVAL      TRTRTP = 'FEAD'
     C                   WHEN      FAFARECI = 'S'
     C                   EVAL      TRAREF = WKCNUM + '¦' + WKFACT + '¦' +
     C                                      WKFCNO + '¦' + WKFSEQ + '¦' +
     C                                      WKYYYY
     C                   EVAL      TRTRTP = 'FEST'
     C                   ENDSL

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   IF        PMODE = 'U'
     C                   UPDATE    LEFEEADF
     C                   ENDIF
     C                   ENDIF
     C                   READ      LEFEEAD                                01
     C                   ENDDO

      ** T_MLMTRAN
     C     1             SETLL     T_MLMTRAN
     C                   READ      T_MLMTRAN                              01
     C                   DOW       *IN01 = *OFF
     C                   IF        MTFACCUST <> *BLANKS AND MTFACTYPE <> *BLANKS
     C                             AND MTFACSEQ <> *BLANKS
     C                   EVAL      @BRCD = MTBRCHCODE
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     MTFACCUST     KCNUM
     C                   MOVEL     MTFACTYPE     KFACT
     C                   MOVEL     MTFACSEQ      KFCNO
     C                   EVAL      KRCTP = 'A'

     C     CHKFAC        CHAIN     FCLTY

     C                   IF        NOT %FOUND(FCLTY)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVEL     'FCLTYFM'     DBFILE
     C                   Z-ADD     19            DBASE
     C                   MOVEL     FACKEY        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      TRPCRF = MTUTN
     C                   EVAL      TRBRCA = MTBRCHCODE
     C                   MOVEL     MTFACCUST     TRCNUM
     C                   MOVEL     MTFACTYPE     TRFACT
     C                   MOVEL     MTFACSEQ      TRFCNO
     C**********         EVAL      TRLNRF = 0                                                 CLE148
     C                   EVAL      TRLNRF = *BLANKS                                           CLE148
     C                   EVAL      TRTDSC = 'Manual Transaction'
     C                   EVAL      TRACTM = 'I'
     C                   EVAL      TRUSID = MTUSERID
     C                   EVAL      TRSPRN = FPCRF
     C                   EVAL      TRTRTP = 'MLMTRAN'

     C                   IF        PMODE = 'U'
     C                   EXSR      SRWRITELTREF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   READ      T_MLMTRAN                              01
     C                   ENDDO

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRWRITELTREF - Write on Transaction Reference File (LETREFPD)     *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRWRITELTREF  BEGSR

      ** Generate Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TIMESTAMP
     C                   EVAL      TRSTMP = TIMESTAMP

     C                   EVAL      TRPRNT = *BLANKS
     C                   EVAL      TRISTS = 'X'
     C                   EVAL      TRAUTN = *BLANKS
     C                   EVAL      TRWPID = 0
     C                   EVAL      TRTSRC = *BLANKS
     C                   EVAL      TRCDAT = BJRDNB
     C                   EVAL      TRSHPC = 0
     C                   EVAL      TRPRTR = FPRTR

     C                   IF        PMODE = 'U'
     C     TRPCRF        CHAIN     LETREFL0                                                 MD040963
     C                   IF        NOT %FOUND(LETREFL0)                                     MD040963
     C                   WRITE     LETREFD0
     C                   ENDIF                                                              MD040963
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRREPORT - Produce report                                         *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRREPORT      BEGSR

      ** Choose which file to process
     C                   SELECT

      ** LEFCLTQD
     C                   WHEN      WKFILE = 'LEFCLTQD'
     C                   EVAL      WKFRPT = FCXFCU + '-' + FCXFTP + '-' + FCXFNO
     C                   MOVE      FCXPFR        ZFLD15
     C                   EVAL      ZDECS = 7
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKFRTO
     C                   MOVE      FCXPSR        ZFLD15
     C                   EVAL      ZDECS = 7
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKSRTO
     C                   EVAL      WKLTTO = FDFTP
     C                   EVAL      WKSTTO = FDFST
     C                   EVAL      WKCLTO = FDFCL                                             CLE042
     C                   MOVE      FFAMT         ZFLD15
     C                   EVAL      ZDECS = 0
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKFATO

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADFCLT
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETFCLT


      ** LEAGFTQD

     C                   WHEN      WKFILE = 'LEAGFTQD'
     C                   EVAL      WKFRPT = FCXFCU + '-' + FCXFTP + '-' + FCXFNO
     C                   MOVE      FCXPFR        ZFLD15
     C                   EVAL      ZDECS = 7
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKFRTO
     C                   MOVE      FCXPSR        ZFLD15
     C                   EVAL      ZDECS = 7
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKSRTO
     C                   EVAL      WKLTTO = ADFTP
     C                   EVAL      WKSTTO = ADFST
     C                   EVAL      WKCLTO = ADFCL                                             CLE042
     C                   MOVE      AFAMT         ZFLD15
     C                   EVAL      ZDECS = 0
     C                   EXSR      SRZSEDIT
     C                   MOVE      ZOUT21        WKFATO

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADAGFT
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETAGFT

      ** LEFCAMPD

     C                   WHEN      WKFILE = 'LEFCAMPD'

     C                   MOVEL     FCCNUM        WKCNUM
     C                   MOVEL     FCFACT        WKFACT
     C                   MOVEL     FCFCNO        WKFCNO
     C                   EVAL      WKFRPT = WKCNUM + '-' + WKFACT + '-' + WKFCNO
     C                   EVAL      WKNPTO = FCNPRT

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADFCAM
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETFCAM

      ** LEAGAMPD

     C                   WHEN      WKFILE = 'LEAGAMPD'

     C                   MOVEL     AGCNUM        WKCNUM
     C                   MOVEL     AGFACT        WKFACT
     C                   MOVEL     AGFCNO        WKFCNO
     C                   EVAL      WKFRPT = WKCNUM + '-' + WKFACT + '-' + WKFCNO
     C                   EVAL      WKNPTO = AGNPRT

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADAGAM
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETAGAM

      ** CLOANCL

     C                   WHEN      WKFILE = 'CLOANCL'

     C                   MOVEL     LNRF          WKLOAN
     C                   EVAL      WKSLTP = SLTP
     C                   EVAL      WKSLST = SLST
     C                   EVAL      WKSLCL = SLCL                                              CLE042

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADLOAN
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETLOAN

      ** MCLONCL

     C                   WHEN      WKFILE = 'MCLONCL'

     C                   MOVEL     LNRF          WKLOAN
     C                   EVAL      WKSLTP = SLTP
     C                   EVAL      WKSLST = SLST
     C                   EVAL      WKSLCL = SLCL                                              CLE042

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADMOAN
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETMOAN

      ** LEFEED

     C                   WHEN      WKFILE = 'LEFEED'

     C                   IF        FIRSTTIME = 'Y'
     C                   WRITE     HEADFEES
     C                   EVAL      FIRSTTIME = 'N'
     C                   ENDIF

     C                   IF        *IN30 = *ON
     C                   MOVEL     FEFELOAN      WKLOAN
     C                   ELSE
     C                   MOVEL     KCNUM         WKCNUM
     C                   MOVEL     KFACT         WKFACT
     C                   MOVEL     KFCNO         WKFCNO
     C                   EVAL      WKFRPT = WKCNUM + '-' + WKFACT + '-' + WKFCNO
     C                   MOVEL     FEFEFSEQ      WKFSEQ
     C                   ENDIF

     C                   EVAL      WKSYIN = FSYIN
     C                   EVAL      WKMASF = 'N'

      ** Write header when overflow line is reached
     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     HEADFEES
     C                   ENDIF

      ** Write Detail line
     C                   WRITE     DETFEES

     C                   ENDSL

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRLOANFCLTY - Process conditioning of CLOAN and FCLTY fields.     *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRLOANFCLTY   BEGSR

     C**********         IF        PTFC = 0                                                  CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A

     C                   MOVEL     FCUS          WKCNUM
     C                   MOVEL     FTYP          WKFACT
     C                   MOVEL     FSEQ          WKFCNO

     C                   ELSE

     C                   MOVEL     PTFC          WKCNUM
     C                   MOVEL     PTFT          WKFACT
     C                   MOVEL     PTFN          WKFCNO

     C                   ENDIF

     C     CHKFAC        CHAIN     FCLTY

     C**********         IF        PTFC = 0                                                  CSD027A
     C                   IF        PTFC = *Blanks                                            CSD027A
     C                   EVAL      TRCNUM = FCUS
     C                   EVAL      TRFACT = FTYP
     C                   EVAL      TRFCNO = FSEQ

     C                   ELSE

     C                   EVAL      TRCNUM = PTFC
     C                   EVAL      TRFACT = PTFT
     C                   EVAL      TRFCNO = PTFN
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRINITLEALLO - Access LEPCRFL1 for initialising LEALLO            *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      *********************************************************************
     C     SRINITLEALLO  BEGSR

     C     *LIKE         DEFINE    PCLAST        NCPCRF

     C     *HIVAL        SETGT     LEPCRFL2
     C                   READP     LEPCRFL2

     C                   MOVE      RF_CPCRF      NCPCRF

     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         EVAL      PCLAST = NCPCRF + 1                                        CLE148

     C**********         IF        PMODE = 'U'                                                CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        PMODE = 'U'                                                CLE148
     C                   EVAL      PUPDT = 'Y'                                                CLE148
     C                   ELSE                                                                 CLE148
     C                   EVAL      PUPDT = *BLANK                                             CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM                    PUPDT                                        CLE148
     C                   PARM      NCPCRF        PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRNODETL   - Write No Details to Report                           *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      *********************************************************************
     C     SRNODETL      BEGSR

     C                   EXSR      SRSKIPPAGE
     C                   WRITE     NODETL

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRSKIPPAGE - Skip page when overflow line is reached              *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      *********************************************************************
     C     SRSKIPPAGE    BEGSR

     C                   EVAL      WKRQDLIN = 2
     C                   EVAL      WKDIFLIN = WKOVRFLW - WKCRTLIN

     C                   IF        WKDIFLIN <= WKRQDLIN
     C                   WRITE     SKIPAG
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRENDPGM   - End the program                                      *
      *                                                                   *
      * Called by: Main Processing                                        *
      *                                                                   *
      *********************************************************************
     C     SRENDPGM      BEGSR

     C                   EVAL      *INLR = *ON

     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRZSEDIT - Format amount for printing.                            *
      *                                                                   *
      * Called by: SRREPORT                                               *
      *                                                                   *
      *********************************************************************
     C     SRZSEDIT      BEGSR

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C                   EVAL      ZFLD15 = *ZEROS

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      **Program Mode
     C                   PARM                    PMODE
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C     CHKFAC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
     C                   KFLD                    KRCTP

     C     CHKFEE        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL


     C                   EXSR      SRINITLEALLO

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C     *LOCK         IN        LEMUTN
     C                   EVAL      MCLAST = MCLAST + 1
     C                   OUT       LEMUTN

     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
