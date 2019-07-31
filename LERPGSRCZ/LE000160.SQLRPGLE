     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Facility Fee Amortization Load')
      *---------------------------------------------------------------*
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000160 - Midas LE Fee Amortization Detail File Load        *
      *                                                               *
      *  Function: Builds the detail file for each day in the life of *
      *            a fee from Fee Start Posting Date through Event    *
      *            Control Date. Daily Accrual Fee is recalculated    *
      *            to be used in LER130.                              *
      *  (COB)                                                        *
      *                                                               *
      *  Called By: LEC000159 after the call to LE000159              *
      *                                                               *
      *  (C) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD031156           Date 18Jul18               *
      *  Prev Amend No. CLE159  *Create    Date 18Jul18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031156 - LEC000159 00001 Failed in COB due to decimal data *
      *             error in LE000160                                 *
      *  CLE159 - Lending Fee Amortization Enhancement                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   F U N C T I O N    O F    I N D I C A T O R S               *
      *                                                               *
      *  79       No records in LEFEED                                *
      *  98       Used for Date Format                                *
      *  U7, U8  -error processing                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *          Standard                                             *
      *                                                               *
      *  *INZSR  -Initial Time Routine                                *
      *  *PSSR   -Error Processing                                    *
      *                                                               *
      *          Custom                                               *
      *                                                               *
      *  SRCALC  -Calculate Fee                                       *
      *  SRLAST  -Last Record processing                              *
      *  SRMOVD  -Move Detail fields                                  *
      *  SRNADJ  -No Adjustments on that day                          *
      *  SRPROC  -Process records                                     *
      *  SRYADJ  -Adjustments on that day                             *
      *                                                               *
      *****************************************************************
      *
     FLE000160AUO    E             PRINTER
      * Audit Printer File
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Data Structure for LDA
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger Details
      *
     D LEFEE         E DS                  EXTNAME(LEFEED)
     D FHIS          E DS                  EXTNAME(LEFHISTD)
     D FHS2          E DS                  EXTNAME(LEFHS2TD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D @@FAMT          S                   Like(FEFAMT)
     D REOFES          S             30S 9
     D SVOFES          S             30S 9
     D READJS          S             30S 9
     D SVADJS          S             30S 9
     D REMAIN          S                   Like(FEPEND)
     D SVDAYS          S                   Like(FEPEND)
     D REDAFS          S             30S 9
     D SVDAFS          S             30S 9
     D RETOFS          S             30S 9
     D SVTOFS          S             30S 9
     D @@PCNT          S                   Like(FHPCNT)
     D KEYDAT          S                   Like(FEPSTD)
     D DAYDIF          S                   Like(FEPSTD)
     D WPrcss          S              1                                                     MD031156
      *
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** MAIN PROCESSING
      *
      * Read all LE Fee records
      *
     c/Exec Sql
     c+ Declare LEFEECur scroll Cursor for
     c+ Select * From LEFEED
      ** Midas LE Fees
     c+   Where FECALT = '' and
     c+   FEPYON = 'S' and
     c+   FERECI = 'D' and
     c+   FELOAN = ''
     c/End-Exec

     c/Exec Sql
     c+ Open LEFEECur
     c/End-Exec

     c/Exec Sql
     c+ Fetch first
     c+   from LEFEECur
     c+   into :LEFEE
     c/End-Exec
      *
     C     SQLSTT        Doweq     '00000'
      *
     C     FEADAT        Iflt      FEFAMT
     C                   exsr      SRPROC
     C                   Endif
      *
     c/Exec Sql
     c+ Fetch next
     c+   from LEFEECur
     c+   into :LEFEE
     c/End-Exec
      *
     C                   Enddo
      *
     C/Exec SQL
     C+ Close LEFEECur
     C/End-Exec
      *
      ** Print Audit Report
      *
     C                   EXSR      SRLAST
      *
      /EJECT
      *****************************************************************
     C     SRPROC        BEGSR
      *****************************************************************
      *
      * Initialize workfiels (Date to Fee Period Start Date)
      *
     C                   z-add     FEPSTD        KEYDAT                         Period StrDt
     C                   z-add     *Zeros        SVOFES
     C                   z-add     *Zeros        SVADJS
     C                   z-add     *Zeros        SVDAFS
     C                   z-add     *Zeros        SVTOFS
     C                   z-add     *Zeros        SVDAYS
      *
      * Loop from beginning to Event Control Date
      *
     C     KEYDAT        Dowle     WECD
     C                   exsr      SRCALC
     C                   exsr      SRMOVD
     C                   Add       1             KEYDAT
     C                   Enddo
      *
      * Increment the number of Fee records processed
      *
     C                   add       1             RCNTFE
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     SRCALC        BEGSR
      *****************************************************************
      *
      * Initialize workfiels
      *
     C                   z-add     *Zeros        @@PCNT
     C                   z-add     *Zeros        @@FAMT
     C                   z-add     *Zeros        REOFES
     C                   z-add     *Zeros        READJS
     C                   z-add     *Zeros        REMAIN
     C                   z-add     *Zeros        REDAFS
     C                   z-add     *Zeros        RETOFS
     C                   EVAL      WPrcss = 'Y'                                             MD031156
      *
     C                   Do
      *
     C                   SELECT
      *
      *****************************
      * Fee Start Date calculations
      *****************************
      *
     C     KEYDAT        Wheneq    FEPSTD
      *
     C     FEPEND        sub       KEYDAT        REMAIN
     C                   add       1             REMAIN
      *
      * If First Day Accruals - reduce the number of days remaining.
      * If Last Day Accruals - do not accrue on the first day
      *
     C     BKALDI        Ifne      'Y'
     C     FELADT        andeq     *ZEROS
     C                   sub       1             REMAIN
     C                   Else
     C                   Leave
     C                   Endif
      *
      *****************************
      * Not the First, not the Last
      *****************************
      *
     C     KEYDAT        Whenne    FEPSTD
     C     KEYDAT        andne     FEPEND
      *
     C     SVDAYS        sub       1             REMAIN
      *
      * If Last Day Accruals - for the 2nd day (1st day of accruals):
      * initialize o/s amount with Fee Amount
      *
     C     BKALDI        Ifeq      'Y'
     C     SVOFES        andeq     *ZEROS
      *
     C     KEYDAT        sub       FEPSTD        DAYDIF
      *
     C     DAYDIF        Ifeq      1
     C                   z-add     FEFAMT        SVOFES
     C                   Endif
      *
     C                   Endif
      *
      ***************************
      * Fee End Date calculations
      ***************************
      *
     C     KEYDAT        Wheneq    FEPEND
      *
      * If First Day Accruals - do not accrue on the last day.
      * If Last Day Accruals - process.
      *
     C     BKALDI        Ifne      'Y'
     C     FELADT        andeq     *ZEROS
     C                   EVAL      WPrcss = 'N'                                             MD031156
     C                   Leave
     C                   Else
     C     SVDAYS        sub       1             REMAIN
     C                   Endif
      *
     C                   Endsl
      *
      *********
      * Process
      *********
      *
      * Access file LEFHISTD to check if records exist for the date
      *
     c/Exec Sql
     c+ Select * into :FHIS
     c+   from LEFHISTD
     c+   where FHBRCA = :FEBRCA and
     c+   FHCNUM = :FECNUM and
     c+   FHFCTY = :FEFACL and
     c+   FHFSEQ = :FEFSEQ and
     c+   FHDATE = :KEYDAT
     c/End-Exec
      *                                                                                     MD031156
      ** Initialize FHGNDT if no record is retrieved.                                       MD031156
      *                                                                                     MD031156
     C                   IF        SQLSTT = '02000'                                         MD031156
     C                   EVAL      FHGNDT = 0                                               MD031156
     C                   ENDIF                                                              MD031156
      *
     C     KEYDAT        CASEQ     FEPSTD        SRYADJ                         First Time
     C     SQLSTT        CASEQ     '02000'       SRNADJ                         No Adjustmnt
     C     SQLSTT        CASEQ     '00000'       SRYADJ                         Adjustment
     C                   ENDCS
      *
      * Save workfields for the next record calculations
      *
     C                   z-add     REOFES        SVOFES                         Save O/S Amt
     C                   z-add     READJS        SVADJS                         Save Adj Amt
     C                   z-add     REDAFS        SVDAFS                         Save DailyAc
     C                   z-add     RETOFS        SVTOFS                         Save Tot Acc
      *
     C                   Leave
     C                   Enddo                                                  of DO loop
      *
     C                   z-add     REMAIN        SVDAYS
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     CSR   SRNADJ        BEGSR
      *****************************************************************
      *
      * Recalculate Outstanding Fee Amount (prev OutFeeS - prev DaiAcF)
      *
     C     SVOFES        sub       SVDAFS        REOFES
      *
      * Recalculate Current Daily Accrual Fee(same as previous non-adj
      * or prev DailyAccrFee - prev AdjS)
      *
     C     SVADJS        Ifeq      *zeros
     C                   z-add     SVDAFS        REDAFS
     C                   Else
     C     SVDAFS        sub       SVADJS        REDAFS
     C                   Endif
      *
      * Recalculate Total Fees Accrued(prev TotFeeAccr + CurDaiAccrFee)
      *
     C     SVTOFS        add       REDAFS        RETOFS
      *
      * Recalculated Total Fees Accrued cannot exceed the Fee Amount
      *
     C     RETOFS        Ifgt      FEFAMT
     C                   z-add     FEFAMT        RETOFS
     C                   Endif
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     CSR   SRYADJ        BEGSR
      *****************************************************************
      *
      * Set Fee Amount
      *
     C     KEYDAT        Ifeq      FEPSTD
     C                   z-add     FEFAMT        @@FAMT
     C                   else
     C                   Z-ADD     SVOFES        @@FAMT
     C                   Endif
      *
      * Set Change %
      *
     C     SQLSTT        Ifeq      '00000'
     C                   z-add     FHPCNT        @@PCNT
     C                   Endif
      *
      * Recalculate Outstanding Fee Amount
      *
     C     @@FAMT        sub       SVDAFS        REOFES
      *
     C     REOFES        Iflt      *Zeros
     C                   z-add     *Zeros        REOFES
     C                   Endif
      *
      * Recalculate Current Adjustment Amount
      *
     C     REOFES        Mult      @@PCNT        READJS
     C                   Div       100           READJS
      *
      * Recalculate Current Daily Accrual Fee
      *
     C     REOFES        Sub       READJS        REDAFS
      *
     C     REMAIN        Ifne      *ZEROS
     C                   Div       REMAIN        REDAFS
     C                   Endif
      *
     C                   Add       READJS        REDAFS
      *
      * Recalculate Total Fees Accrued
      *
     C     SVTOFS        Add       REDAFS        RETOFS
      *
      * Recalculated Total Fees Accrued cannot exceed the Fee Amount
      *
     C     RETOFS        Ifgt      FEFAMT
     C                   z-add     FEFAMT        RETOFS
     C                   Endif
      *
     CSR                 ENDSR
      *
      /EJECT
      *****************************************************************
     CSR   SRMOVD        BEGSR
      *****************************************************************
      *
      * Initialize record
      *
     C                   Clear                   FHS2
      *
      * Load key fields
      *
     C                   move      FEBRCA        F2BRCA
     C                   move      FECNUM        F2CNUM
     C                   z-add     FEFACL        F2FACL
     C                   z-add     FEFSEQ        F2FSEQ
      *
      * Load other fields
      *
     C                   z-add     KEYDAT        F2DATE
      *
     C                   z-add(H)  REOFES        F2OFEA
      *
     C     F2OFEA        Iflt      *Zeros
     C                   z-add     *Zeros        F2OFEA
     C                   Endif
      *
     C                   z-add     @@PCNT        F2APCT
      *
     C                   z-add(H)  READJS        F2ADJA
      *
     C     F2ADJA        Iflt      *Zeros
     C                   Z-ADD     *Zeros        F2ADJA
     C                   Endif
      *
     C                   z-add     REMAIN        F2DAYS
      *                                                                                     MD031156
     C                   IF        WPrcss = 'Y'                                             MD031156
      *
      * If posting an Event Control Date record:
      * Recalculate Daily Accrual Fee AGAIN based on difference between
      * RETOFS and yesterday's Total Fees Accrued in LEFEED
      *
     C     SQLSTT        Ifeq      '02000'
     C     KEYDAT        andeq     WECD
     C     SQLSTT        Oreq      '00000'
     C     FHGNDT        andeq     WECD
     C     RETOFS        sub       FEADAT        REDAFS
     C                   Endif
      *
     C                   ENDIF                                                              MD031156
      *
     C                   z-add(H)  REDAFS        F2DAFA
     C                   z-add(H)  RETOFS        F2TOFA
      *
     C     F2TOFA        Iflt      *Zeros
     C                   z-add     *Zeros        F2TOFA
     C                   Endif
      *
      * If the date falls between Run Date and Event Control Date -
      * load Event Control Date into Generation/Posting Date
      *
     C     KEYDAT        Ifeq      WECD
     C                   z-add     WECD          F2GNDT
     C                   Endif
      *
      * Output record
      *
     c/Exec Sql
     c+ Insert into LEFHS2TD Values(:FHS2)
     c/End-Exec
      *
     CSR                 ENDSR
      *
      /EJECT
      *****************************************************************
     C     SRLAST        BEGSR
      *****************************************************************
      *
     C     RCNTFE        COMP      *Zeros                                 79
      *
     C                   write     CONTROL
     C                   write     NODTLS
      *
     C                   Seton                                        LR
     C                   Return
      *
     C                   ENDSR
      *
      /EJECT
     C*****************************************************************
     C     *INZSR        BEGSR
     C*****************************************************************
      *
      * Set up LDA and DB error-related fields
      *
     C     *Dtaara       Define                  LDA
     C     *LOCK         In        LDA
     C                   move      *Blanks       DBFILE
     C                   move      *Blanks       DBKEY
     C                   move      *Blanks       DBPGM
     C                   movel     'LE000160'    DBPGM
     C                   z-add     0             DBASE
     C                   out       LDA
      *
     C                   Call      'AOBANKR0'
     C                   parm      '*MSG   '     @Rtcd             7
     C                   parm      '*FIRST '     @Optn             7
     C     SDBANK        parm      SDBANK        Dsfdy
      *
     C     @Rtcd         Ifne      *BLANKS
     C     *Lock         In        LDA
     C                   movel     '*VERIFY'     DBKEY                          ************
     C                   movel     'SDBANKPD'    DBFILE                         * DBERR 01 *
     C                   z-add     1             DBASE                          ************
     C                   Out       LDA
     C                   exsr      *PSSR
     C                   Endif
      *
      ** Access General Ledger details.
      *
     C                   Call      'AOGELRR0'
     C                   parm      '*MSG   '     @RTCD
     C                   parm      '*FIRST '     @OPTN
     C     SDGELR        parm      SDGELR        DSFDY
      *
     C     @RTCD         Ifne      *BLANKS
     C     *LOCK         In        LDA
     C                   movel     '*VERIFY'     DBKEY                          ************
     C                   movel     'SDGELRPD'    DBFILE                         * DBERR 02 *
     C                   z-add     2             DBASE                          ************
     C                   out       LDA
     C                   exsr      *PSSR
     C                   Endif
      *
      ** Set up event control date.
      *
     C                   z-add     BJDNWD        WECD              5 0
     C                   sub       1             WECD
      *
     C     BKAPDT        Ifle      WECD
     C                   z-add     BKAPDT        WECD
     C                   Endif
      *
      * Write audit file header
     C                   write     HEADAU                                       Audit Report
      *
     C                   ENDSR
      *
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      ********************************************************************
      *
     C                   write     DBERROR
      *
     C                   Dump
     C                   Seton                                        U7U8LR
     C                   Return
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
