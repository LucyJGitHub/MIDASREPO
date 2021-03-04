     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Rate Fixed Advices')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE3165 - Rollover Rate Fixed Advices                         *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *  (I/C,CoB)  required for a rollover rate fixing advice. This  *
      *             is available whenever the switchable CLE011 is on *
      *             and UDC module is not used.                       *
      *                                                               *
      *             This is submitted automatically in I/C after loan *
      *             rate fixing process has been requested or will    *
      *             run daily as part of the COB after the daily loan *
      *             rate fixing process has been run. This processes  *
      *             any loans flagged as requiring a rate fixed ad-   *
      *             vice.                                             *
      *                                                               *
      *  Called By: LEC3165 - Rollover Rate Fixing Advices Control    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
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
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CAS009             Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
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
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate *
      *           (Recompile)                                         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         File access indicator for CLOANB                *
      *    11         File access indicator for LELOANL0              *
      *    12         File access indicator for LELOANL2              *
      *    22         Report is for a cancellation                    *
      *    23         'New Currency' field on Advice                  *
      *    60         General file excess indicator                   *
      *                                                               *
      *    98         Date Format: DDMMYY (off); MMDDYY (on)          *
      *    U7+U8      Database error occurs                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChgBranch - Change of branch processing.                   *
      *  SRFormatP1 - Formats fields of P1 report before the output.  *
      *  SROutputP1 - Writes P1 report and handles page overflow.     *
      *  SRUpdate - Handles file update and file update errors.       *
      *  SRFmtNum - Replaces leading blanks with asterisks.           *
      *  SRAudit - Ouputs Audit report and terminates program.        *
      *  SRRCFAU - RCF processing for the Audit printer file.         *
      *  SRRCFP1 - RCF processing for printer file 1.                 *
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
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FCLOANB    UF   E           K DISK    INFSR(*PSSR) COMMIT
      ** Loans by Branch/Customer

     FLELOANL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(L0)
     F                                     RENAME(CLOANCLF:LELOAND0)
      ** Live Loans details

     FLELOANL2  IF   E           K DISK    INFSR(*PSSR) PREFIX(L2)
      ** Live Rollover details

     FLE3165AU  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU) USROPN

     FLE3165P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1) USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D LDA           E DS           256    EXTNAME(LDA)
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

      ** Constant fields(1-3) of the Confirmation's first sentence.

     D WConfTxt1       C                   CONST('We confirm that the +
     D                                     interest rate on')

     D WConfTxt2A      C                   CONST('your Loan')
     D WConfTxt2B      C                   CONST('our Participation +
     D                                     Purchased from you')
     D WConfTxt2C      C                   CONST('our Participation +
     D                                     Sold to you')

     D WConfTxt3A      C                   CONST('has been fixed as +
     D                                     follows:')
     D WConfTxt3B      C                   CONST('is no longer fixed.')

      ** Constant field of the Confirmation's second sentence.
     D WConfTxt4       C                   CONST('A new advice will be +
     D                                     issued once the revised rate +
     D                                     has been agreed.')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D SPOOLU          DS
      ** File information data structure for Audit file
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D SPOOL1          DS
      ** File information data structure for AP0007P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  SOFLN1               188    189B 0
     D  SPRLN1               367    368B 0

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for Currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for Customer details

     D                 DS
      ** DS to enable these two fields to have synchronized values
     D RRFRT1                  1     12
     D RRFRT2                  1     12

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WArr20X1        S              1A   DIM(20)
      ** 20-element alpha array used as an output by SR/SRFmtNum

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *
      ** Read input file
      *
     C                   READ      CLOANB                                 10
      *
      ** Detail processing
      *
     C                   DOW       (*IN10 = *OFF)
      *
      ** Rollover Fixed Rate Advice is required
     C                   IF        RFAR = 'Y'
      *
      ** Change of branch
     C                   IF        BRCA <> WBRCA
     C                   EXSR      SRChgBranch
     C                   ENDIF
      *
      ** Access corresponding record on LF/LELOANL2
     C     LNRF          CHAIN     LELOANL2                           12
     C                   IF        *IN12 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LELOANL2'    DBFILE
     C                   MOVEL     LNRF          DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      SRFormatP1
     C                   EXSR      SROutputP1
     C                   EXSR      SRUpdate
      *
     C                   ENDIF
      *
     C                   READ      CLOANB                                 10
      *
     C                   ENDDO
      *
      ** Termination
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChgBranch - Change of branch processing.                   *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     *PSSR, SRRCFP1                                    *
      *                                                               *
      *****************************************************************
     C     SRChgBranch   BEGSR
      *
      ** Close P1 printer file of the old branch
      *
     C                   IF        WOpenP1 = 'Y'
     C                   CLOSE     LE3165P1
     C                   EVAL      WOpenP1 = 'N'
     C                   ENDIF
      *
      ** Open P1 printer file for the new branch
      *
     C                   OPEN      LE3165P1                             60
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE3165P1'    DBFILE
     C                   MOVEL     '*OPEN   '    DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WOpenP1 = 'Y'
     C                   EXSR      SRRCFP1
      *
      ** Save branch of the current printer file
      *
     C                   EVAL      WBRCA = BRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFormatP1 - Formats fields of P1 report before the output.  *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     AOCUSTR0, *PSSR, ZA0140M, AOCURRR0, SRFmtNum      *
      *                                                               *
      *****************************************************************
     C     SRFormatP1    BEGSR
      *
      ***************
      ** Reference **
      ***************
      *
     C                   MOVEL     LNRF          RREF
      *
      **************
      ** Currency **
      **************
      *
     C                   MOVEL     CCY           RCCY
      *
      ******************
      ** New Currency **
      ******************
      *
     C                   MOVE      *OFF          *IN23
     C                   MOVE      *BLANKS       RNCCY
     C                   IF        L2NCCY <> *BLANKS
     C                   MOVE      *ON           *IN23
     C                   MOVE      L2NCCY        RNCCY
     C                   ENDIF
      *
      **********************
      ** Customer details **
      **********************
      *
     C                   MOVEL     *BLANKS       PICust
     C                   MOVEL     CNUM          PICust
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCde           7
     C                   PARM      '*KEY   '     POption           7
     C                   PARM                    PICust           10
     C                   PARM      *BLANKS       PIChr007          7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     CNUM          DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BBCNA1        RPNAME
     C                   MOVEL     BBCNA2        RPADR2
     C                   MOVEL     BBCNA3        RPADR3
     C                   MOVEL     BBCNA4        RPADR4
      *
      *********************
      ** Loan Start Date **
      *********************
      *
     C                   MOVE      *BLANKS       RVDAT
     C                   Z-ADD     VDAT          PIDay050
     C                   CALLB     'ZA0140M'
     C                   PARM      *BLANKS       PRtnCde01         1
     C                   PARM                    PIDay050          5 0
     C                   PARM      BJDFIN        PIDateFmt         1
     C                   PARM      *ZERO         PODate060         6 0
     C                   PARM      *BLANKS       PODDMMMYY         7
     C                   PARM      *ZERO         PODate080         8 0
     C                   PARM      *ZERO         PODate080B        8 0
     C                   MOVEL     PODDMMMYY     RVDAT
      *
      ************************
      ** Loan Maturity Date **
      ************************
      *
     C                   MOVE      *BLANKS       RMDAT
     C                   IF        MDAT = 0
     C                   MOVEL     'AT CALL'     RMDAT
     C                   ELSE
     C                   Z-ADD     MDAT          PIDay050
     C                   CALLB     'ZA0140M'
     C                   PARM      *BLANKS       PRtnCde01
     C                   PARM                    PIDay050
     C                   PARM      BJDFIN        PIDateFmt
     C                   PARM      *ZERO         PODate060
     C                   PARM      *BLANKS       PODDMMMYY
     C                   PARM      *ZERO         PODate080
     C                   PARM      *ZERO         PODate080B
     C                   MOVEL     PODDMMMYY     RMDAT
     C                   ENDIF
      *
      ************************
      ** Loan Rollover Date **
      ************************
      *
     C                   MOVE      *BLANKS       RRDAT
     C                   IF        RLDT > 0
     C                   Z-ADD     RLDT          PIDay050
     C                   CALLB     'ZA0140M'
     C                   PARM      *BLANKS       PRtnCde01
     C                   PARM                    PIDay050
     C                   PARM      BJDFIN        PIDateFmt
     C                   PARM      *ZERO         PODate060
     C                   PARM      *BLANKS       PODDMMMYY
     C                   PARM      *ZERO         PODate080
     C                   PARM      *ZERO         PODate080B
     C                   MOVEL     PODDMMMYY     RRDAT
     C                   ENDIF
      *
      ***************
      ** Principal **
      ***************
      *
     C                   MOVE      *ALL'*'       RAMNT
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      CCY           PInChr03          3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     PInChr03      DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format amount with decimal point and leading asterisks
     C                   MOVE      *BLANKS       PZField016
     C                   MOVE      CPAM          PZField016
     C                   Z-ADD     A6NBDP        PIDec010
     C                   EXSR      SRFmtNum
     C                   MOVEA     WArr20X1(5)   RAMNT
      *
      *******************
      ** Interest Rate **
      *******************
      *
      ** Format interest rate with decimal point and leading asterisks
     C                   MOVE      *BLANKS       RINTR
     C                   MOVE      *BLANKS       PZField016
     C                   MOVE      INTR          PZField016
     C                   Z-ADD     7             PIDec010
     C                   EXSR      SRFmtNum
     C                   MOVEA     WArr20X1(9)   RINTR
      *
      *************************
      ** Rollover Fixed Rate **
      *************************
      *
      ** Format fixed rate with decimal point and leading asterisks
     C                   MOVE      *BLANKS       RRFRT1
     C                   MOVE      *BLANKS       PZField016
     C                   MOVE      RFRT          PZField016
     C                   Z-ADD     7             PIDec010
     C                   EXSR      SRFmtNum
     C                   MOVEA     WArr20X1(9)   RRFRT1
      *
      *******************************************
      ** Confirmation text / Borrower Customer **
      *******************************************
      *
     C                   MOVE      *BLANKS       RBNAME
     C                   MOVE      *BLANKS       RBADR2
     C                   MOVE      *BLANKS       RBADR3
     C                   MOVE      *BLANKS       RBADR4
     C                   MOVE      *BLANKS       RCONF1
     C                   MOVE      *BLANKS       RCONF2
     C                   MOVEL     WConfTxt1     RCONF1
      *
     C                   SELECT
      *
      ** 'your loan'
      *
     C                   WHEN      (PTYP = 61)
     C                             OR (PTYP = 62)
     C                             OR (PTYP = 63)
     C                             OR (PTYP = 70)
      *
     C                   CAT       WConfTxt2A:1  RCONF1
      *
      ** Participation Purchased
      *
     C                   WHEN      (PTYP = 64)
     C                             OR (PTYP = 65)
     C                             OR (PTYP = 68)
     C                             OR (PTYP = 71)
      ** Borrower customer
     C                   MOVEL     *BLANKS       PICust
     C                   MOVEL     OLNO          PICust
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PICust
     C                   PARM      *BLANKS       PIChr007
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PICust        DBKEY
     C                   Z-ADD     6             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     BBCNA1        RBNAME
     C                   MOVEL     BBCNA2        RBADR2
     C                   MOVEL     BBCNA3        RBADR3
     C                   MOVEL     BBCNA4        RBADR4
      ** Confirmation text
     C                   CAT       WConfTxt2B:1  RCONF1
      *
      ** Participation Sold
      *
     C                   WHEN      (PTYP = 66)
     C                             OR (PTYP = 67)
     C                             OR (PTYP = 69)
     C                             OR (PTYP = 72)
      ** Retrieve 'Sale of Loan' details
     C*****OLNO          CHAIN     LELOANL0                           60                      CSD027
     C**********         Move      OLNO          KOLNO             6 0                 CSD027 CLE148
     C*****KOLNO         CHAIN     LELOANL0                           60               CSD027 CLE148
     C     OLNO          CHAIN     LELOANL0                           60                      CLE148
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LELOANL0'    DBFILE
     C                   MOVEL     OLNO          DBKEY
     C                   Z-ADD     7             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      ** If Sale of Loan refers to a Participation Purchased
     C                   MOVEL     *BLANKS       PICust
     C                   IF        (L0PTYP = 64)
     C                             OR (L0PTYP = 65)
     C                             OR (L0PTYP = 68)
     C                             OR (L0PTYP = 71)
     C                   MOVEL     L0OLNO        PICust
     C                   ELSE
     C                   MOVEL     L0CNUM        PICust
     C                   ENDIF
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PICust
     C                   PARM      *BLANKS       PIChr007
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PICust        DBKEY
     C                   Z-ADD     8             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     BBCNA1        RBNAME
     C                   MOVEL     BBCNA2        RBADR2
     C                   MOVEL     BBCNA3        RBADR3
     C                   MOVEL     BBCNA4        RBADR4
      ** Confirmation text
     C                   CAT       WConfTxt2C:1  RCONF1
      *
     C                   ENDSL
      *
     C                   IF        RFRI <> 'Y'
      ** Cancellation
     C                   CAT       WConfTxt3B:1  RCONF1
     C                   MOVEL     WConfTxt4     RCONF2
     C                   ELSE
     C                   CAT       WConfTxt3A:1  RCONF1
     C                   ENDIF
      *
      ******************************
      ** Rollover Rate Fix Advice **
      ******************************
      *
     C                   MOVE      *OFF          *IN22
     C                   IF        RFRI <> 'Y'
     C                   MOVE      *ON           *IN22
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutputP1 - Writes P1 report and handles page overflow.     *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SROutputP1    BEGSR
      *
     C                   WRITE     HeadP1
     C                   WRITE     DtlP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Handles file update and file update errors.       *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     *PSSR                                             *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C                   MOVE      *BLANK        RFAR
     C                   UPDATE    CLOANCLF                             60
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'CLOANB  '    DBFILE
     C                   MOVEL     '*UPDATE '    DBKEY
     C                   Z-ADD     9             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtNum - Replaces leading blanks with asterisks.           *
      *             Uses WArr20X1 array as input and output parameter.*
      *                                                               *
      *             Input Parameters:                                 *
      *                PZField016 - Amount                            *
      *                PIDec010  - Number of decimals                 *
      *                                                               *
      *             Output Parameters:                                *
      *                WArr20X1  - Formatted amount                   *
      *                                                               *
      *  Called by: SRFormatP1                                        *
      *                                                               *
      *  Calls:     ZEDIT                                             *
      *                                                               *
      *****************************************************************
     C     SRFmtNum      BEGSR
      *
      ** Insert decimal point and suppress leading zeroes
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField016       16
     C                   PARM                    PIDec010          1 0
      *
     C                   MOVEA     *BLANKS       WArr20X1
     C                   MOVEA     PZField016    WArr20X1(5)
     C                   Z-ADD     1             X                 2 0
     C                   DOW       WArr20X1(X) = *BLANK
     C                   MOVEA     '*'           WArr20X1(X)
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Ouputs Audit report and terminates program.        *
      *                                                               *
      *  Called by: *PSSR                                             *
      *                                                               *
      *  Calls:     SRRCFAU                                           *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
     C                   OPEN      LE3165AU
      *
      ** RCF processing
     C                   EXSR      SRRCFAU
      *
      ** Report header and file control
     C                   WRITE     HEADAU
      *
      ** Database error
     C                   WRITE     DBERROR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - RCF processing for the Audit printer file.         *
      *                                                               *
      *  Called by: SRAudit                                           *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSequence     ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM      SFILEU        ZSNAM            10
     C                   PARM      SFNUMU        ZSNUM             6 0
     C                   PARM      *BLANK        ZERR              1
     C                   IF        ZERR = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - RCF processing for printer file 1                  *
      *                                                               *
      *  Called by: SRChgBranch                                       *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSequence     ZSEQ
     C                   PARM      *BLANKS       ZENT
     C                   PARM      SFILE1        ZSNAM
     C                   PARM      SFNUM1        ZSNUM
     C                   PARM      *BLANK        ZERR
     C                   IF        ZERR = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSequence         5
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVEL     PSProcPgm     DBPGM
     C                   MOVEL     PSProcMod     DBMOD
      *
      ** Access bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST  '    POption
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRtnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up data format indicator
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
      ** Previous branch
     C                   MOVE      *BLANK        WBRCA             3
      *
      ** Indicates if P1 printer file is already open
     C                   MOVE      *BLANK        WOpenP1           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Error control subroutine.                            *
      *                                                               *
      *  Called by: Error trapping routine                            *
      *                                                               *
      *  Calls:     SRAudit                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun <> 'Y'
     C                   MOVE      'Y'           WRun              1
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
