     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG LE rollover rate fixed advices extract')      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6075 - Lending Rollover Rate Fixed Advices - Driver        *
      *                                                               *
      *  Function:  This program produces the customer correspondence *
      *             onto the UDC extract files required for production*
      *             of the Lending Rollover Rate Fixing Advices       *
      *             through UDC.                                      *
      *                                                               *
      *             This is called by the driver program, CG6070. It  *
      *             processes all transactions identified by CG6070.  *
      *             It also handles the update of the rate fixed ad-  *
      *             vice flag under commitment control.               *
      *                                                               *
      *  Called By: CG6070 - LE Rollover Rate Fixed Advices Driver    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 AR933763           Date 27Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR822053           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241335             Date 29Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAS009             Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP074             Date 08Aug03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR933763 - Rollover confirmation (Rate Change) does not have *
      *             correct date format. Populate ##RDEC with 'Date'  *
      *             so that date formatting will be done.             *
      *             (Child: AR933765)                                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
      *             in CGUXMLPD                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  241335 - Applied fix 235843.                                 *
      *  235843 - Correct date and amount extract.                    *
      *           Correct extract for CM.                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
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
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *                                                               *
      *  10 - File access indicator for LELOANL0                      *
      *  12 - File access indicator for LELOANL2                      *
      *  61 - General purpose indicator                               *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain - Performs validation and invokes top group set.      *
      *  SRl13RO - Top group set.                                     *
      *  SRPartic   - Customer/Participant correspondence details.    *
      *  SRBorrow - Borrower's correspondence data.                   *
      *  SRDl13RO - All other RDE's not included in the Participant's *
      *             and Borrower's data.                              *
      *  SRCorDta - Correspondent data.                               *
      *  SRGenRef - Generate reference number and write to CGUDCRPD.  *
      *  SRInitial - Initial processing.                              *
      *  SRPath - Set up path string.                                 *
      *  SRRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *            store it in ##R.                                   *
      *  SRFmtDta - Reformat data before packing it.                  *
      *  SRFmtNum - Replaces leading blanks with asterisks.           *
      *             Uses WArr20X1 array as input and output parameter.*
      *  SRPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *  SROutDta - Output packed data to extract data files.         *
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

     FLELOANL0  IF   E           K DISK    INFSR(*PSSR) PREFIX(L0)
     F                                     RENAME(CLOANCLF:LELOANF0)
      ** Live Loans details

     FLELOANL2  IF   E           K DISK    INFSR(*PSSR) PREFIX(L2)
      ** Live Rollover details

     FCLOANB    UF   E           K DISK    INFSR(*PSSR) COMMIT
      ** Loans by Branch/Customer

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D WCPrtItmTyp     C                   CONST('LOAN ROLLO')
      ** Print Item Type

     D WCPrtItmSubTyp  C                   CONST('RATE FIX  ')
      ** Print Item Sub-Type

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure Customer details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure Currency details

     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
      ** Data structure for UDC data reference file

     D PEDsCGUDTAPD  E DS                  EXTNAME(CGUDTAPD)
      ** Data structure for UDC extracted data file

     D WEDs1CLOANCL  E DS                  EXTNAME(CLOANCL) PREFIX(L0)
      ** Live Loans details DS1, used to capture record read from LELOANL0
      ** into a data structure

     D WEDs2CLOANCL  E DS                  EXTNAME(CLOANCL) PREFIX(CL)
      ** Live Loans details DS2, loan referred to by P0LoanRef
                                                                                              CCG015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CCG015
      ** Data structure for SAR data                                                          CCG015

     D WMDsPath        DS                  OCCURS(20)
      ** Multi-occurence data structure to store path starting from l13RO
     D  WMDsPathGrp            1      6

     D WDs##S          DS          5120
      ** Data structure to capture content of ##S array after packing
      ** RDE's and their data

     D                 DS
      ** General data structure to define fields that need to share data
     D WGrp10                  1     10
     D  WGrpName               1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)

     D P0RtnCode       S              6A
      ** Entry parameter return code
     D P0DsParm        DS           256
      ** Entry parameter data structure
     D**P0LoanRef              1      6S 0                                                    CLE148
     D  P0LoanRef              1      6A                                                      CLE148
     D**P0CustNum              7     12S 0                                                    CSD027
     D  P0CustNum              7     12A                                                      CSD027
     D  P0Brch                13     15A
     D  P0OrigBrch            16     18A
     D  P0Commit              19     21A

     D*WArr20X1********S              1A   DIM(20)                                            235843
     D WArr20X1        S             20A                                                      235843
      ** 20-element alpha runtime-array used as an output by SR/SRFmtNum

      ** Compile-time array to contain RDE definitions
     D*WTbGrp***       S             10    DIM(27) CTDATA PERRCD(1)                           CLE143
     D*WTbRDE***       S             22    DIM(27) ALT(WTbGrp)                                CLE143
     D WTbGrp          S             10    DIM(30) CTDATA PERRCD(1)                           CLE143
     D WTbRDE          S             22    DIM(30) ALT(WTbGrp)                                CLE143

     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D OLNOAlpha               1      6                                                       CSD027
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WCoCustNumA     S              6A
      ** Customer number

     D WPathStr        S            256A
      ** String that contains the concatenated path

     D WPx             S              3P 0
      ** Index for WMDsPath only

     D WOutSeq         S              9P 0
      ** Output Sequence counter

     D WConfCode       S             10A
      ** Confirmation Text code
                                                                                              CCG015
     D ##ITEM          S              8  0                                                    CCG015
      ** Confirmation Text code                                                               CCG015

      ** General purpose variables
     D WFound          S              1A
     D WProduce        S              1A
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D CLE143          S              1A                                                      CLE143

      ** Parameter fields
     D PAction8        S              8A
     D PCommit         S              3A
     D PPath           S            256A
     D POption         S              7A
     D PRtnCode        S              7A
     D PRtnCode01      S              1A
     D PSARD           S              6A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PIDateFmt       S              1A
     D PIDay050        S              5P 0
     D PODate060       S              6P 0
     D POYYYYMMDD      S              8P 0
     D POMMDDYYYY      S              8P 0
     D PODDMMMYY       S              7A
     D PChr003         S              3A
     D PChr007         S              7A
     D PChr010         S             10A
     D PChr016         S             16A
     D PNum010P        S              1P 0
     D PMode           S             10A
     D PTitle          S              7A
     D PTitleUL        S              7A

     D/COPY CGCPYSRC,CGPACKDLE
      ** Data pack arrays and data structures

     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for
      ** CG error processing

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
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)
      *
      ** Initial processing
      *
     C                   EXSR      SRInitial
      *
      ** Execute main subroutine
      *
     C                   EXSR      SRMain
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Termination
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Performs validation and invokes top group set.      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     SRGenRef, SRl13RO                                 *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMain    '  @STK(Q)
      *
      ** Generate reference number by writing to PF/CGUDCRPD.
      ** If no confirmation to produce, then bypass.
      *
     C                   EXSR      SRGenRef
      *
      ** Top group set
      *
     C                   IF        WProduce = 'Y'
     C                   EXSR      SRl13RO
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRl13RO - Top group set.                                     *
      *                                                               *
      *  Called by: SRMain                                            *
      *                                                               *
      *  Calls:     SRPath, SRERR, SRPartic, SRBorrow, SRDl13RO       *
      *                                                               *
      *****************************************************************
     C     SRl13RO       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRl13RO   '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   Z-ADD     1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'l13RO '      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *                                                                                       CCG015
     C                   EXSR      PSHGRS                                                     CCG015
      *
      ******************************
      ** Access Loan master files **
      ******************************
      *
     C     P0LoanRef     CHAIN     LELOANL0                           10
     C                   IF        *IN10 = *ON
     C                   MOVEL     'LELOANL0'    W0File
     C                   MOVEL     P0LoanRef     W0Key
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Copy captured data from LELOANL0 to a data structure to have
      ** re-accessing LELOANL0 m LELOANL0 to a data structure to avoid
     C                   MOVEL     WEDs1CLOANCL  WEDs2CLOANCL
      *
     C     P0LoanRef     CHAIN     LELOANL2                           12
     C                   IF        *IN12 = *ON
     C                   MOVEL     'LELOANL2'    W0File
     C                   MOVEL     P0LoanRef     W0Key
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *********************************************
      ** Customer/Participant's customer details **
      *********************************************
      *
     C                   EXSR      SRPartic
      *
      *********************************
      ** Borrower's customer details **
      *********************************
      *
     C                   EXSR      SRBorrow
      *
      *********************************************************
      ** All other fields not included in the Borrower's and **
      **    Participant's groups.                            **
      *********************************************************
      *
     C                   EXSR      SRDl13RO
      *
      **************************************************
      ** Update Advice indicator on Loans master file **
      **************************************************
      *
     C                   MOVEL     CLBRCA        KBRCA
     C**********         Z-ADD     CLCNUM        KCNUM                                        CSD027
     C**********         Z-ADD     CLFCUS        KFCUS                                        CSD027
     C                   EVAL      KCNUM  = CLCNUM                                            CSD027
     C                   EVAL      KFCUS  = CLFCUS                                            CSD027
     C                   Z-ADD     CLFTYP        KFTYP
     C                   Z-ADD     CLFSEQ        KFSEQ
      *
      ** Position file pointer
     C     KLoanB        SETLL     CLOANB                               61
     C                   IF        *IN61 = *ON
     C                   MOVEL     'CLOANB  '    W0File
     C                   MOVEL     *BLANKS       W0Key
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Do while no error AND not end of file AND loan not yet found
     C                   MOVEL     'N'           WFound
      *
     C                   DOW       (*IN61 = *OFF)
     C                             AND (WFound = 'N')
      *
     C     KLoanB        READE     CLOANB                               6161
      *
     C                   IF        LNRF = P0LoanRef
     C                   MOVEL     'Y'           WFound
     C                   MOVEL     *BLANK        RFAR
     C                   UPDATE    CLOANCLF                             61
     C                   IF        *IN61 = *ON
     C                   MOVEL     'CLOANB  '    W0File
     C                   MOVEL     P0LoanRef     W0Key
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5002'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If loan was not found, then error
     C                   IF        (*IN61 = *ON)
     C                             AND (WFound = 'N')
     C                   MOVEL     'CLOANB  '    W0File
     C                   MOVEL     P0LoanRef     W0Key
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *                                                                                       CCG015
     C                   EXSR      POPGRS                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPartic   - Customer/Participant correspondence details.    *
      *                                                               *
      *  Called by: SRl13RO                                           *
      *                                                               *
      *  Calls:     SRPath, SRRtvRDE, SRCorDta, SRPackDta, SROutDta   *
      *                                                               *
      *****************************************************************
     C     SRPartic      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPartic  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'PARTIC'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *                                                                                       CCG015
     C                   EXSR      PSHGRS                                                     CCG015
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'CORDTA'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Set up fields to be passed to SRCorrData
      *
     C                   MOVEL     CLCNUM        WCoCustNumA
     C                   EXSR      SRCorDta
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C**********         EXSR      SRPackDta                                                  235843
     C**********         EXSR      SROutDta                                                   235843
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *                                                                                       CCG015
     C                   EXSR      POPGRS                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBorrow - Borrower's correspondence data.                   *
      *                                                               *
      *  Called by: SRl13RO                                           *
      *                                                               *
      *  Calls:     SRPath, SRRtvRDE, SRERR, SRCorDTa, SRPackDta,     *
      *             SROutDta                                          *
      *                                                               *
      *****************************************************************
     C     SRBorrow      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBorrow  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'BORROW'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *                                                                                       CCG015
     C                   EXSR      PSHGRS                                                     CCG015
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'CORDTA'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ** Initialize input parameter to SR/SRCorDta
      *
     C                   MOVEL     *BLANKS       WCoCustNumA
     C                   MOVEL     *BLANKS       WConfCode
      *
      ** Determine the borrower customer, if any.
      *
     C                   SELECT
      *
      ** Your loan
      *
     C                   WHEN      (CLPTYP = 61)
     C                             OR (CLPTYP = 62)
     C                             OR (CLPTYP = 63)
     C                             OR (CLPTYP = 70)
      *
      ** No Borrower
     C                   MOVEL     *BLANKS       WCoCustNumA
      *
     C                   IF        CLRFRI <> 'Y'
      ** Cancellation
     C                   MOVEL     '_LOAN'       WConfCode
     C                   ELSE
     C                   MOVEL     'LOAN'        WConfCode
     C                   ENDIF
      *
      ** Participation purchased
      *
     C                   WHEN      (CLPTYP = 64)
     C                             OR (CLPTYP = 65)
     C                             OR (CLPTYP = 68)
     C                             OR (CLPTYP = 71)
      *
      ** Pass the Borrower field of the loan
     C                   MOVEL     CLOLNO        WCoCustNumA
      *
     C                   IF        CLRFRI <> 'Y'
      ** Cancellation
     C                   MOVEL     '_PURCHASED'  WConfCode
     C                   ELSE
     C                   MOVEL     'PURCHASED '  WConfCode
     C                   ENDIF
      *
      ** Participation Sold
      *
     C                   WHEN      (CLPTYP = 66)
     C                             OR (CLPTYP = 67)
     C                             OR (CLPTYP = 69)
     C                             OR (CLPTYP = 72)
      *
      ** Retrieve 'Sale of Loan' details
     C*****CLOLNO        CHAIN     LELOANL0                           10                      CSD027
     C                   EVAL      OLNOALpha = CLOLNO                                         CSD027
     C*****OLNONum       CHAIN     LELOANL0                           10               CSD027 CLE148
     C     OLNOAlpha     CHAIN     LELOANL0                           10                      CLE148
     C                   IF        *IN10 = *ON
     C                   MOVEL     'LELOANL0'    W0File
     C                   MOVEL     CLOLNO        W0Key
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'MEM5004'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If Sale of Loan refers to a Participation Purchased
     C                   IF        (L0PTYP = 64)
     C                             OR (L0PTYP = 65)
     C                             OR (L0PTYP = 68)
     C                             OR (L0PTYP = 71)
     C                   MOVEL     L0OLNO        WCoCustNumA
     C                   ELSE
     C                   MOVEL     L0CNUM        WCoCustNumA
     C                   ENDIF
      *
     C                   IF        CLRFRI <> 'Y'
      ** Cancellation
     C                   MOVEL     '_SOLD'       WConfCode
     C                   ELSE
     C                   MOVEL     'SOLD '       WConfCode
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   EXSR      SRCorDta
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C**********         EXSR      SRPackDta                                                  235843
     C**********         EXSR      SROutDta                                                   235843
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *                                                                                       CCG015
     C                   EXSR      POPGRS                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDl13RO - All other RDE's not included in the Participant's *
      *             and Borrower's data.                              *
      *                                                               *
      *  Called by: SRl13RO                                           *
      *                                                               *
      *  Calls:     SRPath, SRRtvRDE, ZA0140M, SRERR, AOCURRR0,       *
      *             SRFmtNum, SRPackDTa, SROutDta                     *
      *                                                               *
      *****************************************************************
     C     SRDl13RO      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDl13RO  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'Dl13RO'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *                                                                                       CCG015
     C                   EXSR      PSHGRS                                                     CCG015
      *
      ** Retrieve RDE info
      *
     C                   MOVEL     'Dl13RO'      WGrpName
     C                   EXSR      SRRtvRDE
      *
      ******************
      ** Report title **
      ******************
      *
     C                   MOVEL     BJURPT        ##D(1)
      *
      ***************************
      ** Loan reference number **
      ***************************
      *
     C                   MOVEL     CLLNRF        ##D(2)
      *
      *******************
      ** Loan currency **
      *******************
      *
     C                   MOVEL     CLCCY         ##D(3)
      *
      ******************
      ** New currency **
      ******************
      *
     C                   MOVEL     L2NCCY        ##D(4)
      *
      ****************
      ** Value date **
      ****************
      *
     C**********         Z-ADD     CLVDAT        PIDay050                                     235843
     C**********         CALLB     'ZA0140M'                                                  235843
     C**********         PARM      *BLANKS       PRtnCode01                                   235843
     C**********         PARM                    PIDay050                                     235843
     C**********         PARM      BJDFIN        PIDateFmt                                    235843
     C**********         PARM      *ZERO         PODate060                                    235843
     C**********         PARM      *BLANKS       PODDMMMYY                                    235843
     C**********         PARM      *ZERO         POYYYYMMDD                                   235843
     C**********         PARM      *ZERO         POMMDDYYYY                                   235843
      ** Pass date as YYYYMMDD and do the actual formatting of date
      ** on UDC Layout maintenance
     C**********         MOVEL     POYYYYMMDD    ##D(5)                                       235843
     C                   MOVEL     CLVDAT        ##D(5)                                       235843
     C                   MOVEL     ##R(5)        R#DEFN                                     AR933763
     C                   MOVEL     'Date  '      ##RDEC                                     AR933763
     C                   MOVEL     R#DEFN        ##R(5)                                     AR933763
      *
      *******************
      ** Maturity date **
      *******************
      *
     C                   IF        CLMDAT = 0
     C                   MOVEL     'AT CALL'     ##D(6)
     C                   ELSE
     C**********         Z-ADD     CLMDAT        PIDay050                                     235843
     C**********         CALLB     'ZA0140M'                                                  235843
     C**********         PARM      *BLANKS       PRtnCode01                                   235843
     C**********         PARM                    PIDay050                                     235843
     C**********         PARM      BJDFIN        PIDateFmt                                    235843
     C**********         PARM      *ZERO         PODate060                                    235843
     C**********         PARM      *BLANKS       PODDMMMYY                                    235843
     C**********         PARM      *ZERO         POYYYYMMDD                                   235843
     C**********         PARM      *ZERO         POMMDDYYYY                                   235843
      ** Pass date as YYYYMMDD and do the actual formatting of date
      ** on UDC Layout maintenance
     C**********         MOVEL     POYYYYMMDD    ##D(6)                                       235843
     C                   MOVEL     CLMDAT        ##D(6)                                       235843
     C                   MOVEL     ##R(6)        R#DEFN                                     AR933763
     C                   MOVEL     'Date  '      ##RDEC                                     AR933763
     C                   MOVEL     R#DEFN        ##R(6)                                     AR933763
     C                   ENDIF
      *
      *******************
      ** Rollover date **
      *******************
      *
     C                   IF        CLRLDT > 0
     C**********         Z-ADD     CLRLDT        PIDay050                                     235843
     C**********         CALLB     'ZA0140M'                                                  235843
     C**********         PARM      *BLANKS       PRtnCode01                                   235843
     C**********         PARM                    PIDay050                                     235843
     C**********         PARM      BJDFIN        PIDateFmt                                    235843
     C**********         PARM      *ZERO         PODate060                                    235843
     C**********         PARM      *BLANKS       PODDMMMYY                                    235843
     C**********         PARM      *ZERO         POYYYYMMDD                                   235843
     C**********         PARM      *ZERO         POMMDDYYYY                                   235843
      ** Pass date as YYYYMMDD and do the actual formatting of date
      ** on UDC Layout maintenance
     C**********         MOVEL     POYYYYMMDD    ##D(7)                                       235843
     C                   MOVEL     CLRLDT        ##D(7)                                       235843
     C                   MOVEL     ##R(7)        R#DEFN                                     AR933763
     C                   MOVEL     'Date  '      ##RDEC                                     AR933763
     C                   MOVEL     R#DEFN        ##R(7)                                     AR933763
     C                   ENDIF
      *
      ***************
      ** Principal **
      ***************
      *
      ** Retrieve number of decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      CLCCY         PChr003
     C     SDCURR        PARM      SDCURR        DSSDY
     C     PRtnCode      IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    W0File
     C                   MOVEL     POption       W0Key
     C                   Z-ADD     7             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Format interest rate with decimal point and leading asterisks
     C                   MOVE      *BLANKS       PChr016
     C                   MOVE      CLCPAM        PChr016
     C                   Z-ADD     A6NBDP        PNum010P
     C                   EXSR      SRFmtNum
     C**********         MOVEA     WArr20X1(5)   ##D(8)                                       235843
     C                   MOVEL     WArr20X1      ##D(8)                                       235843
      *
      *******************
      ** Interest rate **
      *******************
      *
      ** Format interest rate with decimal point and leading asterisks
     C                   MOVE      *BLANKS       PChr016
     C                   MOVE      CLINTR        PChr016
     C                   Z-ADD     7             PNum010P
     C                   EXSR      SRFmtNum
     C**********         MOVEA     WArr20X1(9)   ##D(9)                                       235843
     C                   MOVEL     WArr20X1      ##D(9)                                       235843
      *
      *************************
      ** Rollover Fixed rate **
      *************************
      *
      ** Format interest rate with decimal point and leading asterisks
     C                   MOVE      *BLANKS       PChr016
     C                   MOVE      CLRFRT        PChr016
     C                   Z-ADD     7             PNum010P
     C                   EXSR      SRFmtNum
     C**********         MOVEA     WArr20X1(9)   ##D(10)                                      235843
     C                   MOVEL     WArr20X1      ##D(10)                                      235843
      *
      ****************************
      ** Cancellation indicator **
      ****************************
      *
     C                   IF        CLRFRI = 'Y'
     C                   MOVEL     'N'           ##D(11)
     C                   ELSE
      ** Cancellation
     C                   MOVEL     'Y'           ##D(11)
     C                   ENDIF
      *
      ****************************
      ** Confirmation Text code **
      ****************************
      *
     C                   MOVEL     WConfCode     ##D(12)
     C                   IF        CLE143 = 'Y'                                               CLE143
     C                   MOVEL     CLOCDT        ##D(13)                                      CLE143
     C                   MOVEL     CLEAIR        ##D(14)                                      CLE143
     C                   MOVEL     'Y'           ##D(15)                                      CLE143
     C                   ENDIF                                                                CLE143
      *
      ** Accumulate RDEs and associated data and output to CGUDTAPD
      *
     C                   EXSR      SRPackDta
     C                   EXSR      SROutDta
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *                                                                                       CCG015
     C                   EXSR      POPGRS                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCorDta - Correspondent data.                               *
      *                                                               *
      *  Called by: SRPartic, SRBorrow                                *
      *                                                               *
      *  Calls:     SRPath, AOCUSTR0, SRERR                           *
      *                                                               *
      *****************************************************************
     C     SRCorDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCorDta  '  @STK(Q)
      *
      ** Set up path multi-occurence data structure & path string
      *
     C                   ADD       1             WPx
     C     WPx           OCCUR     WMDsPath
     C                   MOVEL     'CORDTA'      WMDsPathGrp
      *
     C                   EXSR      SRPath
      *                                                                                       CCG015
     C                   EXSR      PSHGRS                                                     CCG015
      *
     C                   IF        WCoCustNumA <> *BLANKS
      *
      ** Access customer details
      *
     C                   MOVEL     *BLANKS       PChr010
     C                   MOVEL     WCoCustNumA   PChr010
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PChr010
     C                   PARM      *BLANKS       PChr007
     C     SDCUST        PARM      *BLANKS       DSSDY
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0File
     C                   MOVEL     PChr010       W0Key
     C                   Z-ADD     8             W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS'       W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Correspondent type
      *
     C                   MOVEL     ##D(1)        ##D(1)
      *
      ** Customer number
      *
     C                   MOVEL     BBCUST        ##D(2)
      *
      ** Customer name
      *
     C                   MOVEL     BBCRNM        ##D(3)
      *
      ** Customer town
      *
     C                   MOVEL     BBCRTN        ##D(4)
      *
      ** Account line
      *
     C                   MOVEL     ##D(5)        ##D(5)
      *
      ** Retail account
      *
     C                   MOVEL     ##D(6)        ##D(6)
      *
      ** MIDAS account number
      *
     C                   MOVEL     ##D(7)        ##D(7)
      *
      ** Account name
      *
     C                   MOVEL     ##D(8)        ##D(8)
      *
      ** SWIFT ID
      *
     C                   MOVEL     BBCSID        ##D(9)
      *
      ** Address line 1
      *
     C                   MOVEL     BBCNA1        ##D(10)
      *
      ** Address line 2
      *
     C                   MOVEL     BBCNA2        ##D(11)
      *
      ** Address line 3
      *
     C                   MOVEL     BBCNA3        ##D(12)
      *
      ** Address line 4
      *
     C                   MOVEL     BBCNA4        ##D(13)
      *
      ** Address line 5
      *
     C                   MOVEL     ##D(14)       ##D(14)
      *
      ** Portfolio reference
      *
     C                   MOVEL     ##D(15)       ##D(15)
      *
     C                   ENDIF
      *                                                                                       235843
     C                   EXSR      SRPackDta                                                  235843
     C                   EXSR      SROutDta                                                   235843
      *
      ** Decrement Path DS index
      *
     C     WPx           OCCUR     WMDsPath
     C                   CLEAR                   WMDsPathGrp
     C                   SUB       1             WPx
      *                                                                                       CCG015
     C                   EXSR      POPGRS                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenRef - Generate reference number and write to CGUDCRPD.  *
      *                                                               *
      *  Called by: SRMain                                            *
      *                                                               *
      *  Calls:     CG9010, SRERR                                     *
      *                                                               *
      *****************************************************************
     C     SRGenRef      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGenRef  '  @STK(Q)
      *
      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.
      *
     C                   MOVEL     'N'           WProduce
      *
      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010
      *
     C                   CLEAR                   PEDsCGUDCRPD
      *
      ** Booking/Main branch (mandatory)
      *
     C                   MOVEL     P0Brch        DRBRCA
      *
      ** Originating branch (Optional)
      *
     C                   MOVEL     P0OrigBrch    DRORBR
      *
      ** Module ID (madatory)
      *
     C                   MOVEL     'LE'          DRMODI
      *
      ** MIDAS Transaction number
      *
     C                   MOVEL     P0LoanRef     DRMTRN
      *
      ** Print Item Type
      *
     C                   MOVEL     WCPrtItmTyp   DRPTYP
      *
      ** Print Item Subtype
      *
     C                   MOVEL     WCPrtItmSubTypDRPSTP
      *
      ** Auto Transmission indicator
      *
     C                   MOVEL     'N'           DRATRM
      *
      ** Customer
      *
     C                   MOVE      *BLANKS       PCustNumChr6
     C                   MOVE      P0CustNum     PCustNumChr6
      *
      ** Output to CGUDCRPD
      *
     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM      P0Commit      PCommit
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef
      *
     C                   SELECT
      *
      ** No error, generate correspondence
     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVEL     PItmRef       ##ITEM                                       CCG015
     C     DRPTYP        CAT       ':':0         COLON            11                          CCG015
     C     COLON         CAT       DRPSTP:0      ##REFR                                       CCG015
     C                   EXSR      WRAPRF                                                     CCG015
      *
      ** No error, suppress output
     C                   WHEN      PRtnCode = 'CGD1270'
      *
      ** Error.
     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     9             W0ERNB
     C                   MOVEL     'CGD1286'     W0MsgD
     C                   MOVEL     'CGUSRMSG'    W0MsgF
     C                   EXSR      SRERR
      *
     C                   ENDSL
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Initial processing.                              *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRInitial     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRInitial '  @STK(Q)
      *
      ** Index of WMDsPath
      *
     C                   Z-ADD     0             WPx
      *
      ** Output Sequence counter
      *
     C                   Z-ADD     0             WOutSeq
      *                                                                                       CCG015
      ** Initialise XML increment                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      INIXML                                                     CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPath - Set up path string.                                 *
      *                                                               *
      *  Called by: SRl13RO, SRPartic, SRBorrow, SRDl13RO, SRCorDta   *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRPath        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPath    '  @STK(Q)
      *
      ** Reset output path string
      *
     C                   MOVEL     *BLANKS       WPathStr
      *
      ** Copy path from multi-occurence DS to string. Each entry is to be
      ** preceded by '\'.
      *
     C                   DO        WPx           Wx1
     C     Wx1           OCCUR     WMDsPath
     C                   CAT       '\':0         WPathStr
     C                   CAT       WMDsPathGrp:0 WPathStr
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *            store it in ##R.                                   *
      *                                                               *
      *  Called by: SRPartic, SRBorrow, SRDl13RO                      *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRRtvRDE      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRtvRDE  '  @STK(Q)
      *
      ** Reset primary arrays
      *
     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S
      *
      ** Get info from compile time array of the 20 RDEs in group set
      *
     C                   Z-ADD     1             Wx1
     C                   Z-ADD     1             WGrpSeq
     C                   DOU       *IN61 = *OFF
     C                             OR (Wx1 > 20)
     C                   Z-ADD     1             Wx2
     C     WGrp10        LOOKUP    WTbGrp(Wx2)                            61
     C                   IF        *IN61 = *ON
     C                   MOVEL     WTbRDE(Wx2)   ##R(Wx1)
     C                   ADD       1             Wx1
     C                   ADD       1             WGrpSeq
     C                   ENDIF
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDta - Reformat data before packing it.                  *
      *                                                               *
      *  Called by: SRPackDta                                         *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     SRFmtDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFmtDta  '  @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             Wx1
      *
     C     Wx1           DOUEQ     20
      *
      ** Move RDE's and its data to their templates
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
      *
      ** Reformat only if data is present and RDE is edited
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
      *
      ** Right-align amount
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
     C     Wx2           DOWGT     1
     C     Wx2           ANDLE     20
     C     Wx3           ANDGT     1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO
      *
      ** Sign
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
      *
      ** Edit type
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
      *
      ** Default decimal places
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF
      *
      ** New RDE data
     C                   MOVEL     R#DATA        ##D(Wx1)
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
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
      *                PChr016  - Amount                              *
      *                PNum010P - Number of decimals                  *
      *                                                               *
      *             Output Parameters:                                *
      *                WArr20X1  - Formatted amount                   *
      *                                                               *
      *  Called by: SRDl13RO                                          *
      *                                                               *
      *  Calls:     ZEDIT                                             *
      *                                                               *
      *****************************************************************
     C     SRFmtNum      BEGSR
      *
      ** Insert decimal point and suppress leading zeroes
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    PChr016
     C                   PARM                    PNum010P
      *
     C**********         MOVEA     *BLANKS       WArr20X1                                     235843
     C                   MOVEL     *BLANKS       WArr20X1                                     235843
     C**********         MOVEA     PChr016       WArr20X1(5)                                  235843
     C                   eval      WArr20X1 = %trim(PChr016)                                  235843
     C**********         Z-ADD     1             Wx1                                          235843
     C**********         DOW       WArr20X1(Wx1) = *BLANK                                     235843
     C**********         MOVEA     '*'           WArr20X1(Wx1)                                235843
     C**********         ADD       1             Wx1                                          235843
     C**********         ENDDO                                                                235843
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPackDta - Pack/Unpack RDEs and their corresponding data.   *
      *                                                               *
      *  Called by: SRPartic, SRBorrow, SRDl13RO                      *
      *                                                               *
      *  Calls:     SRFmtDta, CG3999, SRERR                           *
      *                                                               *
      *****************************************************************
     C     SRPackDta     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPackDta '  @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SRFmtDta
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   MOVEL     '*NEWARR '    PAction8                                     CCG015
     C                   MOVEL     WPathStr      W0SPAT                                       CCG015
     C                   ELSE                                                                 CCG015
     C                   MOVEL     '*PACK   '    PAction8                                     CCG015
     C                   MOVEL     *BLANK        W0SPAT                                       CCG015
     C                   ENDIF                                                                CCG015
      *
      ** Pack RDEs and associated data into data strings
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C**********         PARM      '*PACK   '    PAction8                                     CCG015
     C                   PARM                    PAction8                                     CCG015
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70                          CCG015
     C                   PARM                    ##RN                                         CCG015
     C                   PARM                    ##DN                                         CCG015
     C                   PARM                    ##FM                                         CCG015
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   EXSR      WRTRDE                                                     CCG015
      *                                                                                       CCG015
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutDta - Output packed data to extract data files.         *
      *                                                               *
      *  Called by: SRPartic, SRBorrow, SRDl13RO                      *
      *                                                               *
      *  Calls:     CG9020, SRERR                                     *
      *                                                               *
      *****************************************************************
     C     SROutDta      BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROutDta  '  @STK(Q)
      *
      ** Initialize Write Format Parameter
      *
     C                   CLEAR                   PEDsCGUDTAPD
      *
      ** Set up control information
      *
     C                   MOVE      PItmRef       DEITEM
     C                   ADD       1             WOutSeq
     C                   Z-ADD     WOutSeq       DEOSEQ
     C                   Z-ADD     1             DEPBIN
     C                   Z-ADD     1             DETBIN
     C                   MOVEL     'FR'          DEFSLI
      *
      ** Append output data from *Pack routine
      *
     C                   CLEAR                   WDs##S
     C                   MOVEA     ##S           WDs##S
     C                   CAT       WDs##S:0      PEDsCGUDTAPD
      *                                                                                       CCG015
     C     CCG015        IFEQ      'N'                                                        CCG015
      *
      ** Output CGUDTAPD record
      *
     C                   CALL      'CG9020'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*WRITE  '    PAction8
     C                   PARM      WPathStr      PPath
     C                   PARM                    PEDsCGUDTAPD
     C                   PARM      *BLANKS       PTitle
     C                   PARM      *BLANKS       PTitleUL
     C                   PARM      P0Commit      PCommit
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG9020'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     11            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine.                              *
      *                                                               *
      *  Called by: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     AOBANKR0, SRERR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM      W0RTN         P0RtnCode
     C                   PARM                    P0DsParm
      *
     C     KLoanB        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFCUS
     C                   KFLD                    KFTYP
     C                   KFLD                    KFSEQ
      *
     C     *LIKE         DEFINE    BRCA          KBRCA
     C     *LIKE         DEFINE    CNUM          KCNUM
     C     *LIKE         DEFINE    FCUS          KFCUS
     C     *LIKE         DEFINE    FTYP          KFTYP
     C     *LIKE         DEFINE    FSEQ          KFSEQ
     C     *LIKE         DEFINE    PCommit       W0CMT                                        CCG015
     C                   MOVEL     PCommit       W0CMT                                        CCG015
      *
     C                   MOVEL     ##PGM         DBPGM
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
     C     PRtnCode      IFNE      *BLANKS
     C                   EVAL      W0File = 'SDBANKPD'
     C                   EVAL      W0Key = POption
     C                   EVAL      W0ERNB = 12
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS  '
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Determine if Correspondence Manager Phase 1 Development is                           CCG015
      ** installed                                                                            CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       PRtnCode                                     CCG015
     C                   PARM      '*VERIFY'     POption                                      CCG015
     C                   PARM      'CCG015'      PSard                                        CCG015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CCG015
      *                                                                                       CCG015
     C     PRtnCode      IFEQ      *BLANKS                                                    CCG015
     C                   MOVE      'Y'           CCG015            1                          CCG015
     C                   ELSE                                                                 CCG015
     C                   MOVE      'N'           CCG015                                       CCG015
      *                                                                                       CCG015
     C     PRtnCode      IFNE      '*NRF  '                                                   CCG015
     C                   EVAL      W0File = 'SCSARDPD'                                        CCG015
     C                   EVAL      W0Key = '*CALL'                                            CCG015
     C                   EVAL      W0ERNB = 13                                                CCG015
     C                   EVAL      W0MsgD = 'MEM5003'                                         CCG015
     C                   EVAL      W0MsgF = 'MIDAS  '                                         CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      ** Check if 'CLE143' is switched 'ON'                                                   CLE143
                                                                                              CLE143
     C                   CALL      'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       PRtnCode                                     CLE143
     C                   PARM      '*VERIFY'     POption                                      CLE143
     C                   PARM      'CLE143'      PSard                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
      *                                                                                       CLE143
     C                   IF        PRtnCode = *BLANKS                                         CLE143
     C                   EVAL      CLE143 = 'Y'                                               CLE143
     C                   ELSE                                                                 CLE143
      *                                                                                       CLE143
     C                   EVAL      CLE143 = 'N'                                               CLE143
     C                   ENDIF                                                                CLE143
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
     C/COPY CGCPYSRC,CGNWEXILE                                                                CCG015
      /EJECT                                                                                  CCG015
      *****************************************************************
** WTbGrp/WTbRDE
Dl13RO0001 BANK NAME                     Report title
Dl13RO0002 LOAN REF                      Loan reference
Dl13RO0003 CURRENCY                      Loan currency
Dl13RO0004 NEW CCY                       New Currency from Loan file
Dl13RO0005 VALUE DATE                    Value date
Dl13RO0006 MATUR DATE                    Maturity date
Dl13RO0007 ROLL DATE                     Rollover date
Dl13RO0008 PRINCIPAL_                    Principal
Dl13RO0009 INT RATE_                     Interest rate
Dl13RO0010 NEWFIXRATE                    New fixed rate
Dl13RO0011 CANCEL                        Cancellation indicator
Dl13RO0012 CONF CODE                     Confirmation code
Dl13RO0013 ORIGCDAT   Date               Original Contract Date                               CLE143
Dl13RO0014 EFFAINTR   Rate  L8           Confirmation code                           CLE143 AR822053
Dl13RO0015 CLE143F                       Confirmation code                                    CLE143
CORDTA0001 COR_TYPE                      Information Type
CORDTA0002 COR_CUST                      Customer
CORDTA0003 COR_CUSNAM                    Customer Name
CORDTA0004 COR_CUSTWN                    Customer Town
CORDTA0005 COR_AC_LIN                    Account line
CORDTA0006 COR_RET_NO                    Retail AC No.
CORDTA0007 COR_ACCT                      Midas Account Identifier
CORDTA0008 COR_AC_NAM                    Account name
CORDTA0009 COR_SWIFT                     SWIFT ID
CORDTA0010 COR_ADDR_1                    Address line 1
CORDTA0011 COR_ADDR_2                    Address line 2
CORDTA0012 COR_ADDR_3                    Address line 3
CORDTA0013 COR_ADDR_4                    Address line 4
CORDTA0014 COR_ADDR_5                    Address line 5
CORDTA0015 COR_PTFR                      Portfolio Reference
