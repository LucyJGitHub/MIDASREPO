     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Interest Rate Fixing in COB')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2460 - Rollover Interest Rate Fixing in COB                *
      *                                                               *
      *  Function:  This module processes all transactions on the     *
      *  (CoB)      Live Loans file and determines the effective      *
      *             interest rate to be fixed on the loan and performs*
      *             the required updates to this file.                *
      *                                                               *
      *  Component of: LEC2460 - Rollover Rate Fixing  Fixing Prompt  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238541             Date 21Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 235907             Date 06Jun06               *
      *                 CLE042             Date 06Sep05               *
      *                 223823R (Reopen)   Date 19Dec03               *
      *                 CLE036             Date 22Sep03               *
      *                 CAS009             Date 16May05               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 25May01               *
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  238541 - Applied fix 235907.                                 *
      *  235907 - Wrong base rate applied on loans on rollover date.  *
      *           Ensure that rollover fixed rate is correctly        *
      *           processed based on fixing days. (Reopen)            *
      *         - If rate to be used is today's rate, do not look on  *
      *           history file.                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  235907 - The rate used should be the new rate on the Base    *
      *           Rates file if the value date of the new change is   *
      *           earlier than the rollover fixing date.  Applied fix *
      *           225209.                                             *
      *         - Ensure that rollover fixed rate are correctly       *
      *           processed based on fixing days.  Applied fix 222208.*
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  223823R- (Reopen) Rate was not fixed if Loan hadn't been     *
      *           attached to a Base rate previously so CHIN <> 'R'.  *
      *           Check new change indicator on rollover details too. *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate *
      *           (Recompile)                                         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CSD006 - Use DSSDY for call to AOBSRTR0.                     *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         End of file indicator for LELOANL0              *
      *    12         File access indicator for LELOANL2              *
      *    60         General file-, program-, module-access error    *
      *               indicator                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Detail processing on the read record             *
      *  SRFixRate - Calculation of rates.                            *
      *  SRFixUpd  - Updates rate fixing fields on the primary file   *
      *  SRAudit - Ouputs Audit report and terminates program         *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialization                                       *
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

      ** Live Loan details
     FLELOANL0  UF   E           K DISK    INFSR(*PSSR) PREFIX(L0)

      ** Live Rollover details
     FLELOANL2  IF   E           K DISK    INFSR(*PSSR) PREFIX(L2)

     FLE2460AU  O    E             PRINTER INFSR(*PSSR) USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Externally described DS for Historic Base rate
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRUN            S              1
     D WWorkBase       S              2S 0
     D WWorkCcy        S              3
     D WRateFixedInd   S              1
     D WFixedRate      S             11P 7
     D WBaseRate       S             11P 7
     D WSpreadInd      S              1
     D WSpread         S             11P 7

      ** Parameter definition
     D PRtnCde         S              7
     D POption         S              7
     D PCYCD           S              3
     D PBase           S              2

      ** Parameter definition of standard modules
     D PZInpDay        S              5P 0
     D PZDaysFwd       S              2P 0
     D PZOutDay        S              5P 0
     D PZCcy           S              3
     D PZLocation      S              3

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      *
      ** Do Initial reading on the primary file
      *
     C                   READ      LELOANL0                               10
      *
      ** Do while end of file has not been reached
      *
     C                   DOW       *IN10 = *OFF
      *
      ** - Rate Changes are applied on rollover date
      ** - Rollover rate is not yet fixed
      ** - Rollover Rate Fixing Days exist
      *
     C**********         IF        (L0CHIN = 'R')                                            223823R
     C**********                   AND (L0RFRI <> 'Y')                                       223823R
     C**********                   AND (L0RFDY <> '00')                                      223823R
      * Process loan if New Change Indicator = 'R' (change at Rollover)                       223823
      * or New Change Indicator is blank & previous value was 'R'.                            223823
     C                   IF        L0NCHI = 'R'                                               223823
     C                             OR (L0CHIN = 'R')                                         223823R
     C                             AND (L0NCHI = ' ')                                        223823R
      * If Number of Rate fixing days is not Zero:                                           223823R
     C                   IF            (L0RFDY <> '00')                                      223823R
     C                             AND (L0RFDY <> *BLANKS)
     C                             AND (L0RFRI <> 'Y')                                        235907
     C                   EXSR      SRProcess
     C                   ENDIF
     C                   ENDIF                                                               223823R
      *
     C                   READ      LELOANL0                               10
      *
     C                   ENDDO
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Performs the detail processing on the record     *
      *              read from the primary file.                      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     SRAudit, AOBSRTR0, ZFWDT, SRFixRate, SRFixUpd     *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ***************
      ** Base Rate **
      ***************
      *
     C                   EVAL      WWorkBase = 0
     C                   SELECT
      ** Next Base Rate Type is present
     C                   WHEN      L0NBRA <> 0
     C                   EVAL      WWorkBase = L0NBRA
      ** Next Rate/Spread is also zero, then old base rate continues
     C                   WHEN      L0NRTS = 0
     C                   EVAL      WWorkBase = L0BRTT
     C                   ENDSL
      *
      **************
      ** Currency **
      **************
      *
     C     L0LNRF        CHAIN     LELOANL2                           12
     C                   IF        *IN12 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     L0LNRF        DBKEY
     C                   EVAL      DBFILE = 'LELOANL2'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** Set to New Currency else to Loan Currency
      *
     C                   EVAL      WWorkCcy = *BLANKS
     C                   IF        L2NCCY <> *BLANKS
     C                   EVAL      WWorkCcy = L2NCCY
     C                   ELSE
     C                   EVAL      WWorkCcy = L0CCY
     C                   ENDIF
      *
      ** If Next Base Rate Type or Base Rate Code is used
      *
     C                   IF        WWorkBase <> 0
      *
     C                   MOVE      WWorkBase     PBase
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      WWorkCcy      PCYCD
     C                   PARM                    PBase
     C*****SDBSRT        PARM      *BLANKS       SDBSRT                                       CSD006
     C     SDBSRT        PARM      *BLANKS       DSSDY                                        CSD006
     C                   IF        PRtnCde = *BLANKS
      ** Working day which is the loan rollover rate fixing days
      ** forward from the run date.
     C                   MOVE      L0RFDY        PZDaysFwd
     C                   CALLB     'ZFWDT'
     C                   PARM      BJRDNB        PZInpDay
     C                   PARM                    PZDaysFwd
     C                   PARM      *ZERO         PZOutDay
     C                   PARM      WWorkCcy      PZCcy
     C                   PARM      *BLANKS       PZLocation
     C                   IF        (L0RLDT <> 0)
     C                             AND (L0RLDT <= PZOutDay)
     C                   EXSR      SRFixRate
     C                   EXSR      SRFixUpd
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFixRate - Performs calculation of rates.                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRFixRate     BEGSR
      *
     C                   EVAL      WRateFixedInd = 'Y'
     C                   EVAL      WFixedRate = 0
     C                   EVAL      WBaseRate = 0
      *
      ***************
      ** Base Rate **
      ***************
      *
     C**********         IF        L0RFDY = '00'                                              235907
      **********                                                                              235907
     C**********         EVAL      WBaseRate = BANBRT                                         235907
      **********                                                                              235907
     C**********         ELSE                                                                 235907
      *
      ** Working day which is the loan rollover rate fixing days
      ** back from the rollover date
     C                   MOVE      L0RFDY        PDaysBck
     C                   CALLB     'ZBKDT'
     C                   PARM      L0RLDT        PInpOutDay        5 0
     C                   PARM      WWorkCcy      PCYCD
     C                   PARM      *BLANKS       PZLocation
     C                   PARM                    PDaysBck          2 0
     C                   PARM                    PDayNbr           5 0
      *                                                                                       235907
      ** Use the new base rate if the value date of the new rate is                           235907
      ** before the fixing date                                                               235907
      *                                                                                       235907
     C                   IF        BAVDNR <= PDayNbr                                          235907
     C                   EVAL      WBaseRate = BANBRT                                         235907
     C                   ELSE                                                                 235907
      *
      ** Determine the historic base rate applicable
     C                   MOVE      WWorkBase     PBaseP
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      WWorkCcy      PCYCD
     C                   PARM                    PBaseP            2 0
     C                   PARM      PDayNbr       PDayNo            5 0
     C     SDBSHS        PARM                    SDBSHS
      *
     C                   IF        PRtnCde = *BLANKS
     C                   EVAL      WBaseRate = G0CBSR
     C                   ELSE
     C                   EVAL      WBaseRate = BANBRT
     C                   ENDIF
     C**********         ENDIF                                                         235907 235907
      *
     C                   ENDIF
      *
      ***********************************
      ** Rate/Spread, Spread Indicator **
      ***********************************
      *
     C                   IF        L0NSIN <> *BLANK
     C                   EVAL      WSpreadInd = L0NSIN
     C                   EVAL      WSpread = L0NRTS
     C                   ELSE
     C                   EVAL      WSpreadInd = L0SPIN
     C                   EVAL      WSpread = L0RTSP
     C                   ENDIF
      *
      ****************
      ** Fixed Rate **
      ****************
      *
     C                   SELECT
     C                   WHEN      WSpreadInd = 'A'
     C                   EVAL      WFixedRate = WBaseRate + WSpread
     C                   WHEN      WSpreadInd = 'S'
     C                   EVAL      WFixedRate = WBaseRate - WSpread
     C                   WHEN      WSpreadInd = 'P'
     C                   EVAL      WFixedRate = WBaseRate * (WSpread/100)
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFixUpd  - Updates rate fixing fields on the primary file.  *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls:     *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     SRFixUpd      BEGSR
      *
      ** Set up fields for update
      *
     C                   EVAL      L0RFRT = WFixedRate
     C                   EVAL      L0RFRI = 'Y'
     C                   EVAL      L0RFAR = 'Y'
      *
      ** Update file
      *
     C                   UPDATE    CLOANCLF                             60
      *
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     L0LNRF        DBKEY
     C                   EVAL      DBFILE = 'LELOANL0'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Ouputs Audit report and terminates program.        *
      *                                                               *
      *  Called by: Main processing, SRChgBranch, SRFormatP1, SRUpdate*
      *             SRFmtNum, SRRCFP1, *INZSR, *PSSR                  *
      *                                                               *
      *  Calls:    None.                                              *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
     C                   OPEN      LE2460AU
      *
      ** Report header and file control
     C                   WRITE     HEADAU
      *
      ** Database error
     C                   WRITE     DBERROR
      *
      ** Terminate program
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, SRAudit                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
