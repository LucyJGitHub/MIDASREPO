     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Initialisation program for CAS009(CLOAN)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000017 - Lending Transactions Initialisation         *
      *                   for CAS009.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 06Aug12               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 233545             Date 18May05               *
      *                 232348             Date 21Feb05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  233545 - Cut-off Date (Recompile)                            *
      *  232348 - Introduce cut-off date for non-linear amortisation  *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  01 - Record not found                                        *
      *  10 - End of File in CLOAN                                    *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SRDfltFlds - Default fields                                  *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
      ** Loans File
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     COMMIT

     FLECFLSPD  UF A E           K DISK    INFSR(*PSSR)                                       232348
      ** Midas LE Cash Flows Using All-in-Rate                                                232348
                                                                                              232348
     FLEHISTL4  IF   E           K DISK    INFSR(*PSSR)                                       232348
     F                                     PREFIX(HS)                                         232348
      ** Midas LE History Amount Detail                                                       232348
                                                                                              232348
     FSDLOANL3  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Type/subtype file

     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Fees File

     FSDFEEL0   IF   E           K DISK    INFSR(*PSSR)
      ** Fee Codes File

     FLEFHSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Fee history file

     FLE000017AUO    E             PRINTER
      ** Lending Transactions Initialisation Audit Report
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access programs

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

      ** External data structure for the Hedging ICD                                          232348
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  232348
                                                                                              232348
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details

     D PSDS           SDS
      ** Program Status Data Structure

     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263

      ** Work fields
     D WFACL           S              5S 0
     D WFCOD           S              2A
     D WDUMP           S              1A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D BIS@            S             80
     D KVDAT           S              5P 0                                                    232348
                                                                                              232348
      ** ZDATE2 parameters                                                                    232348
     D PDayNoIn        S              5  0                                                    232348
     D PDateOut        S              6  0                                                    232348
     D PADate          S              7A                                                      232348
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************

     C     *LOVAL        SETLL     CLOAN
     C                   DOU       %EOF(CLOAN)
     C                   READ      CLOAN
      *                                                                                       232348
      ** Only process EIR cost accounting if loan's value date is same                        232348
      ** as or after the non-linear amortisation cut-off date                                 232348
     C                   IF        FSNLAC > VDAT                                              232348
     C                   IF        %EOF(CLOAN)                                                232348
     C                   LEAVE                                                                232348
     C                   ENDIF                                                                232348
     C                   READ      CLOAN                                                      232348
     C                   ITER                                                                 232348
     C                   ENDIF                                                                232348

      ** Process live transaction details.

     C                   IF        NOT %EOF(CLOAN) AND
     C                             RECI = 'D'

     C                   EVAL      WCOUNTF = WCOUNTF + 1

      ** Check Loan Type/Subtype, proccess if amortised indicator is 'Y'

     C     KyLoan        CHAIN     SDLOANL3
     C                   IF        %FOUND(SDLOANL3)
     C                   EXSR      SRDfltFlds
                                                                                              232348
      ** Generate historic cash flows for existing records                                    232348
      ** in LEHISTL4 from the last rollover date or value date                                232348
                                                                                              232348
     C                   IF        LRLD  <> *ZERO                                             232348
     C                   EVAL      KVDAT = LRLD                                               232348
     C                   ELSE                                                                 232348
     C                   EVAL      KVDAT = VDAT                                               232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C     KyHist1       SETLL     LEHISTL4                                                   232348
     C     KyHist2       READE     LEHISTL4                                                   232348
                                                                                              232348
     C                   DOW       NOT %EOF(LEHISTL4)                                         232348
     C                   IF        HSPTYP <> 70 AND                                           232348
     C                             HSPTYP <> 71 AND                                           232348
     C                             HSPTYP <> 72                                               232348
     C                   IF        HSAMTP = 'ST' OR                                           232348
     C                             HSAMTP = 'PI' OR                                           232348
     C                             HSAMTP = 'MR' OR                                           232348
     C                             HSAMTP = 'IN' OR                                           232348
     C                             HSAMTP = 'RE' OR                                           232348
     C                             HSAMTP = 'PF' OR                                           232348
     C                             HSAMTP = 'PT' OR                                           232348
     C                             HSAMTP = 'MA'                                              232348
     C                   EXSR      SRGenHistCFs                                               232348
     C                   ENDIF                                                                232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C     KyHist2       READE     LEHISTL4                                                   232348
     C                   ENDDO                                                                232348
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON

      ** Write File Controls Report.

     C                   EXSR      SRAudit

      *****************************************************************
      * SRDfltFlds - Subroutine that default fields                   *
      *****************************************************************
     C     SRDfltFlds    BEGSR

      ** Initialise key fields

     C                   EVAL      TFDP = TOTI
     C                   EVAL      TFDPA = TOTI
     C                   EVAL      TFAM = TOTI
     C                   EVAL      TFAC = TOTI
     C                   EVAL      TFOF = TOTI
     C                   EVAL      DSAM = TOTI

     C     KyFee         CHAIN     LEFEEDL1                           01
     C                   DOW       *IN01 = *OFF

      ** Total Fees/Discount/Premium

     C                   EVAL      TFDP  = TFDP + FEFAMT

     C                   SELECT

      ** Total Amortising Fee Adjustment to Yield

     C                   WHEN      FEPYON = 'S'
     C                   EVAL      TFAM  = TFAM + FEFAMT

      ** Total Accruing Fee Adjustment to Yield

     C                   WHEN      FEPYON = 'E'
     C                   EVAL      TFAC  = TFAC + FEFAMT

      ** Total One off Fee Adjustment to Yield

     C                   WHEN      FEPYON = ' '
     C                   EVAL      TFOF  = TFOF + FEFAMT

     C                   ENDSL

      ** Check if Fee code is defined as having an
      ** Adjustment to Yield as 'Y'

     C                   MOVE      FEFCOD        WFCOD
     C     WFCOD         CHAIN     SDFEEL0
     C                   IF        %FOUND(SDFEEL0) AND
     C                             AUADJY = 'Y'

      ** Total Fees/Discount/Premium Adjustmnet to Yield

     C                   EVAL      TFDPA = TFDPA + FEFAMT
     C                   ENDIF

     C     KyFee         READE     LEFEEDL1                               01
     C                   ENDDO

      ** Access Fee History file

     C     LNRF          CHAIN     LEFHSTL0                           01
     C                   DOW       *IN01 = *OFF

      ** Total Fees/Discount/Premium

     C                   EVAL      TFDP  = TFDP + FEFAMT
     C     LNRF          READE     LEFHSTL0                               01
     C                   ENDDO

     C                   UPDATE    CLOANCLF

      ** Increment counter only if fields are initialised with values

     C                   EVAL      WCOUNTCL = WCOUNTCL + 1

     C                   ENDSR
      *****************************************************************                       232348
      /EJECT                                                                                  232348
      *****************************************************************                       232348
      *  SRGenHistCFs - Generate cash flows for existing historic     *                       232348
      *                 amount details                                *                       232348
      *****************************************************************                       232348
     C     SRGenHistCFs  BEGSR                                                                232348
                                                                                              232348
     C                   CLEAR                   LECFLSD0                                     232348
                                                                                              232348
     C**********         Z-ADD     HSLNRF        LFLNRF                                232348 CLE148
     C                   MOVEL     HSLNRF        LFLNRF                                       CLE148
     C                   Z-ADD     *ZERO         LFFSEQ                                       232348
     C                   MOVE      HSLTYP        LFLTYP                                       232348
     C                   MOVE      HSSUTP        LFLNST                                       232348
     C                   MOVE      HSCLAS        LFLNCL                                       CLE042
     C                   Z-ADD     HSVDAT        LFFLDT                                       232348
                                                                                              232348
     C                   MOVE      *BLANK        LFDATE                                       232348
     C                   Z-ADD     HSVDAT        PDayNoIn                                     232348
     C                   EXSR      SrZDate2                                                   232348
     C                   MOVE      PADate        LFDATE                                       232348
     C                   Z-ADD     HSPRAM        LFCAMT                                       232348
                                                                                              232348
     C                   SELECT                                                               232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'ST'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 67 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SSAM'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'SAMT'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'PI'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SPIN'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'PINC'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'RE'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SSRP'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'SRPY'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'MR'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 67 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SRPA'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'RPAY'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'PF'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 67 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SPTF'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'PTFA'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'PT'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 67 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SPTT'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'PTTA'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'IN'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SINT'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'INTP'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   WHEN      HSAMTP = 'MA'                                              232348
     C                   IF        HSPTYP = 66 OR                                             232348
     C                             HSPTYP = 67 OR                                             232348
     C                             HSPTYP = 69                                                232348
     C                   MOVE      'SMAM'        LFFTYP                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'MAMT'        LFFTYP                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   ENDSL                                                                232348
                                                                                              232348
     C                   IF        HSAMTP = 'ST' OR                                           232348
     C                             HSAMTP = 'PI' OR                                           232348
     C                             HSAMTP = 'PT'                                              232348
     C                   MOVE      'O'           LFIOIN                                       232348
     C                   ELSE                                                                 232348
     C                   MOVE      'I'           LFIOIN                                       232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   IF        LRLD  <> *ZERO                                             232348
     C     LRLD          SUB       BJRDNB        LFNDYP                                       232348
     C                   ELSE                                                                 232348
     C     VDAT          SUB       BJRDNB        LFNDYP                                       232348
     C                   ENDIF                                                                232348
     C                   MOVE      ICBS          LFICBS                                       232348
                                                                                              232348
      ** Calculation methods are:                                                             232348
                                                                                              232348
     C                   SELECT                                                               232348
                                                                                              232348
      ** 1 Actual/365, 4 365/365 (excluding 29/02)                                            232348
                                                                                              232348
     C                   WHEN      ICBS = 1 OR                                                232348
     C                             ICBS = 4                                                   232348
     C                   Z-ADD     365           LFNDYY                                       232348
                                                                                              232348
      ** 2 Actual/360, 3 360/360 (sometimes called 30/360), 5 365/360 (excluding 29/02)       232348
                                                                                              232348
     C                   WHEN      ICBS = 2 OR                                                232348
     C                             ICBS = 3 OR                                                232348
     C                             ICBS = 5                                                   232348
     C                   Z-ADD     360           LFNDYY                                       232348
                                                                                              232348
      ** 6 Actual/366                                                                         232348
                                                                                              232348
     C                   WHEN      ICBS = 6                                                   232348
     C                   Z-ADD     366           LFNDYY                                       232348
                                                                                              232348
     C                   ENDSL                                                                232348
                                                                                              232348
     C                   Z-ADD     HSINTR        LFIRAT                                       232348
     C                   MOVE      HSCNUM        LFCNUM                                       232348
     C                   MOVE      HSBRCA        LFBRCA                                       232348
     C                   MOVE      HSCCY         LFCYCD                                       232348
     C                   MOVE      BOKC          LFBKCD                                       232348
                                                                                              232348
     C                   Z-ADD     CPAM          LFCPAM                                       232348
     C                   MOVE      FSYLDC        LFYLDC                                       232348
     C                   MOVE      FSFYLD        LFFYLD                                       232348
     C                   Z-ADD     RTSP          LFSPRR                                       232348
                                                                                              232348
     C                   IF        LFCAMT <> *ZERO                                            232348
     C                   WRITE     LECFLSD0                                                   232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Write separate cash flow record for Interest Amount                                  232348
                                                                                              232348
     C                   IF        HSINTA <> *ZERO                                            232348
     C                   Z-ADD     HSINTA        LFCAMT                                       232348
     C                   MOVE      'INTP'        LFFTYP                                       232348
     C                   WRITE     LECFLSD0                                                   232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   ENDSR                                                                232348
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - Subroutine to Write Audit Report                    *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Write File Control Report Heading

     C                   WRITE     HEADAU

     C                   IF        WCOUNTF <> 0
     C                   WRITE     CONTROL

     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEA     CPY@          BIS@

      **  Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'LE000017'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If not found, database error

     C                   IF        @RTCD <>  *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'LE000017'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Object for Hedge ICD                                                          232348
     C                   CALL      'AOHEDGR0'                                                 232348
     C                   PARM      *BLANKS       @RTCD                                        232348
     C                   PARM      '*FIRST '     @OPTN                                        232348
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        232348
                                                                                              232348
     C                   IF        @RTCD <> *BLANKS                                           232348
     C     *LOCK         IN        LDA                                                        232348
     C                   EVAL      DbFile = 'SDHEDGPD'                                        232348
     C                   EVAL      Dbase = 2                                                  232348
     C                   EVAL      DbKey = @OPTN                                              232348
     C                   OUT       LDA                                                        232348
     C                   EXSR      *PSSR                                                      232348
     C                   ENDIF                                                                232348
                                                                                              232348
     C                   Z-ADD     *ZERO         WCOUNTF
     C                   Z-ADD     *ZERO         WCOUNTCL
     C                   Z-ADD     *ZERO         WFACL

      ** Key List for Fees File

     C     KyFee         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    WFACL
     C                   KFLD                    LNRF

      ** Key List for Loan types/subtypes file

     C     KyLoan        KLIST
     C                   KFLD                    LTYP
     C                   KFLD                    SUTP
     C                   KFLD                    CLAS                                         CLE042
                                                                                              232348
      ** Key Lists for History amount detail                                                  232348
                                                                                              232348
     C     KyHist1       KLIST                                                                232348
     C                   KFLD                    BRCA                                         232348
     C                   KFLD                    CNUM                                         232348
     C                   KFLD                    LNRF                                         232348
     C                   KFLD                    KVDAT                                        232348
                                                                                              232348
     C     KyHist2       KLIST                                                                232348
     C                   KFLD                    BRCA                                         232348
     C                   KFLD                    CNUM                                         232348
     C                   KFLD                    LNRF                                         232348

     C                   ENDSR
      *****************************************************************                       232348
      /EJECT                                                                                  232348
      *****************************************************************                       232348
      *  SrZDate2 - Convert day number to date                        *                       232348
      *****************************************************************                       232348
     C     SrZDate2      BEGSR                                                                232348
                                                                                              232348
     C                   CALL      'ZDATE2'                                                   232348
     C                   PARM                    PDayNoIn                                     232348
     C                   PARM                    BJDFIN                                       232348
     C                   PARM      *ZERO         PDateOut                                     232348
     C                   PARM      *BLANK        PADate                                       232348
                                                                                              232348
     C                   ENDSR                                                                232348
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WDUMP = *BLANKS
     C                   EVAL      WDUMP = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      ** Write File Control Report Heading

     C                   WRITE     HEADAU

      ** Write Database error

     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
** CPY@
(c) Finastra International Limited 2004
