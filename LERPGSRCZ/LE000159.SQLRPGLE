     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Facility Fee History Amortization Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE0000159 - Midas LE Fcty Fee Hist Amortization Ext    *
      *                                                               *
      *   Function:   Create facility history extract for accelerated *
      *               Fee Amortization.                               *
      *                                                               *
      *  (C) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. AR674226           Date  04Dec19              *
      *  Prev Amend No. CLE159   *Create   Date  18Jul18              *
      *                 xxxxxx             Date  ddmmmyy              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  CLE159 - LE Fee Amortization Enhancement                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   During COB, extract Fee info from LEFEED and FACHISA for    *
      *   use with fee amortization in LER130.                        *
      *                                                               *
      *   Amend the amortized fee processing, to generate an          *
      *   acceleration adjustment for the value date of the           *
      *   facility decrease of the transaction to which the fee       *
      *   is linked.                                                  *
      *                                                               *
      *   The enhancement affects only 'Fees to be Amortized'         *
      *   (non-calculated fees) which are linked to facilities.       *
      *   If several fees are linked to the same facility,            *
      *   the new processing applies to all fees equally.             *
      *                                                               *
      * When acculumlating the Facility History, read through all of  *
      * the related fees for each facility by value date.             *
      * In other words, for each facility customer (FACNUM), facility *
      * number (FAFCTY) by value date (FADATE), read all of the       *
      * related facility sequence numbers (FAFSEQ) for all fees.      *
      *                                                               *
      * Since the fee period start dates can vary for fees            *
      * for one or more facilities, the fee change percentage         *
      * must be calculated and output to LEFHISTD for each fee        *
      * (signified by the fee sequence number FEFSEQ).                *
      *                                                               *
      *****************************************************************
      *
     FLE000159AUO    E             PRINTER
      * Audit Printer File
      *
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20  - Multibranching ON                                     *
      *   79  - No records processed from primary file LEFEED         *
      *   80  - First Cycle indicator                                 *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   FACHL2 - Read FACHISA records for the same posting date.    *
      *   FDSR -   Calculate facility amount for facility decrease.   *
      *   FISR -   Calculate facility amount for facility increase.   *
      *   INIT   - Set-up Initial values                              *
      *   LASTSR - Output file controls Report                        *
      *   PCNTSR - Calculate the facility change percentage           *
      *            to be used for adjusting the fee amortization      *
      *   RESET  - Clear values from previous facility action date.   *
      *   UPDAT  - Output LEFHISTD extract file for LEFEED records.   *
      *   *PSSR  - Program exception error roine                      *
      *                                                               *
      *****************************************************************
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for bank details
      *
     D LEFEE         E DS                  EXTNAME(LEFEED)
     D FACH1         E DS                  EXTNAME(FACHISA)
     D FHIS          E DS                  EXTNAME(LEFHISTD)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Data Structure for LDA
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access program, short Data Structure
      *
     D SDate           S                   Like(FADATE)
     D WSBrca          S                   Like(FHBRCA)
     D WSCnum          S                   Like(FHCNUM)
     D WSFcty          S                   Like(FHFCTY)
     D WSLoan          S                   Like(FHLOAN)
     D WSDate          S                   Like(FHDATE)
     D WSAdif          S                   Like(FHADIF)
     D WSCfam          S                   Like(FHCFAM)
     D WSPcnt          S                   Like(FHPCNT)
     D WSGndt          S                   Like(FHGNDT)
     D Fadat@          S                   Like(FADATE)
     D NbrRcds         S              6S 0
      *****************************************************************
     C/EJECT
      *****************************************************************
      *================================================================
      * Initial Processing
      *================================================================
      *
     C  N80              exsr      INIT
     C  N80              Seton                                        80
      *
      *================================================================
      * Main Processing
      *================================================================
      *
      ** For each LEFEED record:
      *
      ** Detail processing
     C                   z-add     *Zero         WSADIF
      *
     c/Exec Sql
     c+ Declare LEFEECur scroll Cursor for
     c+ Select * From LEFEED
      ** Midas LE Fees
     c+   Where FECALT = '' and
     c+   FEPYON = 'S' and
     c+   FEFAMT <> 0 and
     c+   FEPEND <> 0 and
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
      *  For each Lending Fee record (non-unique key) keyed by
      *  Branch, Fclty Customer, Fclty No., Loan No. & Fee Seq.:
      *
     C                   Dow       SQLSTT = '00000'
     C                   add       1             RCNTFE
     C                   z-add     *Zero         SDATE
      *
      *  Read each corresponding Facility History Action record by Fcty Cust and Fcty Ref
      *
     c/Exec Sql
     c+ Declare LEFACH1Cur scroll Cursor for
     c+ Select * from FACHISA
      ** Midas LE Facility History amounts
     c+   where FACNUM = :FECNUM and
     c+   FAFCTY = :FEFACL and
     c+   FADATE >= :FEPSTD
     c/End-Exec

     c/Exec Sql
     c+ Open LEFACH1Cur
     c/End-Exec

     c/Exec Sql
     c+ Fetch first
     c+   from LEFACH1Cur
     c+   into :FACH1
     c/End-Exec
      *
     C     SQLSTT        Ifeq      '00000'
     C                   movel     FARECI        FAREC@            1
     C                   Endif
      *
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     C     SQLSTT        Doweq     '00000'
      *
      *  If the Facility History Action Date >= Fee Period Start date,
      *  then test this action for the Fee Percentage.
      *
     C                   exsr      FACHL2
      *
     C                   move      FA_Sqlstt     SQLSTT
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     C                   Enddo
      *
     C/Exec SQL
     C+ Close LEFACH1Cur
     C/End-Exec
      *
     C                   z-add     *Zero         WSADIF
      *  Read next fee.

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
      *---------------------------------------------------------------
     C                   move      '1'           *INLR
      *
      * Print audit report
     C                   exsr      LASTSR
      *
     C                   Return
      *
      *================================================================
      * End of main processing
      *================================================================
      /EJECT
      *================================================================
      * Subroutines
      *================================================================
     C/SPACE
      *****************************************************************
      *
      *   Subroutine FACHL2 - Read FACHISA records for the same posting
      *                       date.
      *
      *   A facility increase is considered a correction of
      *   a facility decrease if the value dates of the
      *   increase and the decrease are equal.
      *
      *   The facility increase is netted against the facility decrease
      *   on the basis of the value date.
      *
      *   Access relevant records for this facility customer/number/date
      *   and recalculate the Fee Change Percentage.
      *
      *   Called from:  Main Processing
      *   Calls:        RESET, PCNTSR, FDSR, FISR
      *
      *****************************************************************
      *
     C     FACHL2        BEGSR
      *
      *  Clear work fields and LEFHISTD output fields
     C                   exsr      RESET
      *
     C                   z-add     FADATE        FADAT@
      *
      *-------------------------------------------------------------------
     C     FADATE        Doweq     FADAT@
     C     SQLSTT        andeq     '00000'
      *
     C     FALOAN        Ifeq      *BLANKS
      *
      *  Add to the Facility Decrease by the amount of the "FD"
      *  (regardless of the facility revolving credit indicator.)
     C     FAACTN        Ifeq      'FD'
     C                   exsr      FDSR
     C                   Endif
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Reduce the Facility Decrease by the amount of the 'FI'
      *  (regardless of the facility revolving credit indicator.)
     C     FAACTN        Ifeq      'FI'
     C                   exsr      FISR
     C                   Endif
      *
     C                   Endif
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *   A back valued facility increase results from the reversal
      *   of a loan principal repayment, where the loan is linked to
      *   a non-revolving facility.
      *   A back valued facility decrease results from a positive
      *   loan principal repayment, where the loan is linked to
      *   a non-revolving facility.
      *
     C     FAACTN        Ifeq      'MR'                                         manual repayment
     C     FAACTN        oreq      'RE'                                         Sched repay
      *
      *  Add to the Facility Decrease by the amount of these actions
      *  if the facility revolving credit indicator = NO.
      *
     C     FAACTN        oreq      'UD'                                         util. decr
     C     FAACTN        oreq      'UE'                                         util. end
     C     FAACTN        oreq      'WO'                                         Write-off
     C     FAACTN        oreq      'MT'                                         Maturity
      *
     C     FARCIN        Ifeq      'N'                                          non-revolving
     C                   exsr      FDSR
     C                   Endif
      *
     C                   Endif
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     c/Exec Sql
     c+ Fetch next
     c+   from LEFACH1Cur
     c+   into :FACH1
     c/End-Exec
     C                   Enddo
     C                   movel     SQLSTT        FA_Sqlstt         5
      *
      *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  If previous facility amount is zero, set equal to action amount.
      *  This will ensure that SR/PCNTSR will calculate change as 100%.
     C     WSCFAM        Ifeq      *ZERO
     C                   z-add     WSADIF        WSCFAM                         fclty amt (fee)
     C                   Endif
      *
      *  If Facility Decrease > zero, calculate backvalued adjustment
      *  percentages and write a LEFHISTD extract record.
     C     WSADIF        Ifgt      *ZERO
     C                   exsr      PCNTSR
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine FDSR - Calculate the facility amount for an
      *                     effective facility decrease.
      *
      *   Called from:  FACHL2
      *
      *****************************************************************
      *
     C     FDSR          BEGSR
      *
      *  Add to the Facility Decrease by the FACHISA action amount.
      *  (Note: The action amount here will normally be positive.)
      *  ----------------------------------------------------------------
      *  - For Repayments, the following exception applies:             -
      *  - Addition of a negative repayment action amount reduces       -
      *  - the Facility Decrease.                                  (FI) -
      *  - Addition of a positive repayment action amount increases     -
      *  - the Facility Decrease.                                  (FD) -
      *  ----------------------------------------------------------------
     C     WSADIF        Add       FAAAMT        WSADIF                         tot action amt
     C                   z-add     FADATE        WSDATE                         action date
     C                   z-add     FAGNDT        WSGNDT                         generation date
      *
      *  Calculate the facility amount at the START of each facility
      *  action date. (COUNT = 0 for the first action of a given day.)
      *
      *  Since the Facility Amount on FACHISA includes the action amt,
      *  reverse out (by adding) this action from the facility amount
      *  in order to derive the initial "facility amt prior to decrease".
      *  ----------------------------------------------------------------
      *  - For Repayments, the following exception applies:             -
      *  - Adding negative repay decreases initial facility amt.   (FI) -
      *  - Adding positive repay increases initial facility amt.   (FD) -
      *  ----------------------------------------------------------------
     C     COUNT         Ifeq      0
     C                   z-add     FACFAM        WSCFAM                         fclty amt (fee)
     C     WSCFAM        add       FAAAMT        WSCFAM
     C                   Endif
      *
     C                   add       1             COUNT
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine FISR - Calculate the facility amount for a
      *                     facility increase ('FI').
      *
      *   Called from:  FACHL2
      *
      *****************************************************************
      *
     C     FISR          BEGSR
      *
      *  Reduce the Facility Decrease by the amount of the 'FI'
      *  (Note: The action amount here will always be positive.)
     C     WSADIF        Sub       FAAAMT        WSADIF                         tot action amt
     C                   z-add     FADATE        WSDATE                         action date
     C                   z-add     FAGNDT        WSGNDT                         generation date
      *
      *  Calculate the facility amount at the START of each facility
      *  action date. (COUNT = 0 for the first action of a given day.)
      *  Since the Facility Amount on FACHISA includes the FI action,
      *  reverse out (by subt) this action from the facility amount.
      *  in order to derive the initial "facility amt prior to increase".
     C     Count         Ifeq      0
     C                   z-add     FACFAM        WSCFAM                         fclty amt (fee)
     C     WSCFAM        Sub       FAAAMT        WSCFAM
     C                   Endif
      *
     C                   add       1             COUNT
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine PCNTSR - Calculate the facility change percentage
      *                    to be used for adjusting the fee amortization
      *
      *   Called from:  FACHL2
      *
      *****************************************************************
      *
     C     PCNTSR        BEGSR
      *
      *  If the result is a net facilty decrease ( > 0), because the
      *  facility increase amount is smaller than the facility decrease
      *  amount (and the resulting Current Facility Amount is not zero),
      *  calculate the effective Fee Change Percentage as the
      *  (Facility Action Amount divided by the Current Facility Amount)
      *  multiplied times 100.
      *
     C     WSADIF        Ifgt      *ZERO
     C     WSCFAM        andne     *ZERO
     C     WSADIF        div       WSCFAM        WSW139                         (13,9) work
     C     WSW139        mult      100           WSPCNT                         Fee change %
      *
      *  Write LEFHISTD extract record.
     C                   exsr      UPDAT
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine UPDAT  - Output LEFHISTD extract file for each
      *                       LEFEED record keyed by:
      *   branch/customer/facility number/fee action date/fee seq.
      *
      *   Called from:  PCNTSR
      *
      *****************************************************************
      *
     C     UPDAT         BEGSR
      *
     c/Exec Sql
     c+ Select count(*) into :NbrRcds
     c+   from LEFHISTD
     c+   where FHBRCA = :BRCA and
     c+   FHCNUM = :FECNUM and
     c+   FHFCTY = :FEFACL and
     c+   FHDATE = :FADAT@ and
     c+   FHFSEQ = :FEFSEQ
     c/End-Exec
      *
     C     SQLSTT        Ifeq      '00000'
     C     NbrRcds       andgt     0
      *
     c/Exec Sql
     c+ Update LEFHISTD
     C+  Set FHRECI = :FAREC@, FHDATE = :WSDATE, FHADIF = :WSADIF,
     C+      FHCFAM = :WSCFAM, FHPCNT = :WSPCNT, FHGNDT = :WSGNDT
     c+   where FHBRCA = :BRCA and
     c+   FHCNUM = :FECNUM and
     c+   FHFCTY = :FEFACL and
     c+   FHDATE = :FADAT@ and
     c+   FHFSEQ = :FEFSEQ
     c/End-Exec
      *
     C                   Else
      *
     C                   move      BRCA          FHBRCA
     C                   move      FECNUM        FHCNUM
     C                   move      FEFACL        FHFCTY
     C                   move      FELOAN        FHLOAN
     C                   move      FEFSEQ        FHFSEQ
      *
     C                   move      FAREC@        FHRECI
     C                   move      WSDATE        FHDATE
     C                   move      WSADIF        FHADIF
     C                   move      WSCFAM        FHCFAM
     C                   move      WSPCNT        FHPCNT
     C                   move      WSGNDT        FHGNDT
      *
     c/Exec Sql
     c+ Insert into LEFHISTD Values(:FHIS)
     c/End-Exec
      *
      * Keep count of number of records output to LEFHISTD
     C                   add       1             RCNTAD
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine INIT - Set-up Initial values
      *
      *   Called from:  Main Processing
      *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
     C     *Dtaara       Define                  LDA
     C     *LOCK         In        LDA
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       DBKey
     C                   MOVEL     'LE000159'    DBPGM
     C                   Z-ADD     0             DBase
     C                   out       LDA
      *
      * Read first ICD details for report heading and Run Date
      *
     C                   Call      'AOBANKR0'
     C                   parm                    @Rtcd             7
     C                   parm      '*FIRST '     @Optn             7
     C     SDBANK        parm      SDBANK        Dsfdy
      *
     C     @RTCD         Ifne      *BLANKS
     C     *LOCK         In        LDA
     C                   movel     'SDBANKPD'    DBFile
     C                   movel     @RTCD         DBKey                          ************
     C                   z-add     1             DBase                          * DBASE 01 *
     C                   out       LDA                                          ************
     C                   exsr      *PSSR
     C                   Endif
      *
      *  Clear all fields on LEFHISTD extract for first cycle
     C                   Exsr      RESET
     C                   z-add     *ZERO         RCNTFE
      *
      * Write audit file header
     C                   write     HEADAU
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine RESET  - Clear values from previous facility action
      *                       date.
      *
      *   Called from:  INIT, FACHL2
      *
      *****************************************************************
      *
     C     RESET         BEGSR
      *
     C                   Clear                   FHIS
      *
     C                   move      *Blanks       WSBRCA
     C                   move      *Blanks       WSCNUM
     C                   z-add     *Zeros        WSFCTY
     C                   move      *Blanks       WSLOAN
     C                   z-add     *Zeros        WSDATE
     C                   z-add     *Zeros        WSADIF
     C                   z-add     *Zeros        WSCFAM
     C                   z-add     *Zeros        WSW139           13 9
     C                   z-add     *Zeros        WSPCNT
     C                   z-add     *Zeros        WSGNDT
     C                   z-add     *Zero         COUNT             9 0
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE
      *****************************************************************
      *
      *   Subroutine LASTSR - Output file controls Report
      *
      *   Called from:  Main Processing
      *
      *****************************************************************
      *
     C     LASTSR        BEGSR
      *
     C     RCNTFE        comp      *ZEROS                                 79
     C                   write     CONTROL
     C                   write     NODTLS
      *
     C                   Seton                                        LR
     C                   Return
      *
     C                   ENDSR
      *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (NONE)                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          Ifeq      *Blank
     C                   move      'Y'           @RUN              1
     C                   dump
     C                   Endif
      *
     C                   write     HEADAU
     C                   write     DBERROR
      *
     C                   Seton                                        U7U8LR
      *
     C                   ENDSR
      *
      ********************************************************************
