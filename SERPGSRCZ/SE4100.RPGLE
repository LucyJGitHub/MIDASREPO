     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Repo and bond lending confirmations')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Tradin Module                             *
      *                                                               *
      *  SE4100 - Repo and Bond Lending Confirmations                 *
      *                                                               *
      *  Function:  This module produces Confirmations for Repos,     *
      *             Reverse Repos, Bond Borrowing, Bond Lending,      *
      *             Pledge Loans and Pledge deposits.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 26Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198177             Date 24Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 10Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  208051 - 198177 sets interest always as +ve so use opposite  *
      *           way if INTR on DEALSDC says it was negative.        *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  198177 - Interest should be a positive amount on the         *
      *           confirmations.                                      *
      *  CSE006 - Repurchase Agreement enhancements                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALS     IF   E           K DISK
     F
     FMMDEALLL  IF   E           K DISK
     F
     FSECTY     IF   E           K DISK
     F
     FINVTP     IF   E             DISK
     F
     FSECRTNL1  IF   E           K DISK
     F
     FSEDPMVL3  IF   E           K DISK
     F
     FSE4100P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FSE4100AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
 
     D*
     D** Table containing text for Narrative
     D ##TXT           S             55    DIM(6) CTDATA PERRCD(1)
 
     D*
     D** Array for month short names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
     D SPOOL1          DS
     D*
     D**  DS for P1 spool file name
     D*
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D*
 
     D SPOOL2          DS
     D*
     D**  DS for P2 spool file name
     D*
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
 
     D SPOOLU          DS
     D*
     D**  DS for Audit spool file name
     D*
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D*
     D
     D DealFilFmt    E DS                  EXTNAME(DEALS)
     D**  Branch Details
     D
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  Branch Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
     D**  Customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D**  Currency details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** Nostro details
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
     D**  Broker details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Long data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure
 
     D**  Data Structure for date returned from ZDATE9
     D                 DS
     D  VDT                    1      8  0
     D  YR                     1      4  0
     D  MM                     5      6  0
     D  DD                     7      8  0
 
     D**  Data Structure for date in DDMMMYY Format
     D                 DS
     D  Date                   1      7
     D  Day                    1      2
     D  Mnth                   3      5
     D  Year                   6      7
 
      ** Formatted input from ZSEDIT
     D   ZFLD15        S             15  0
 
      ** Number of decimal position
     D   ZADEC         S              1P 0
 
      ** AONOSTR0 Parameters
     D*P@ACCD***       S              4A                                                      CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSN          S              2A
     D P@BRCD          S              3A
     D P@CSSN          S             10A
     D P@CUST          S              6A
     D P@CYCD          S              3A
     D P@NONB          S              2A
     D P@PNOI          S              1A
 
      ** AOCUSTR0 Parameters
     D @KEY1           S             10A
     D @KYST           S              7A
 
     D RptHdr          S              1A
 
      *
      ** Register Spool File via RCF
     C                   EXSR      INIT
      *
      ** Open Printer File 1
     C                   OPEN      SE4100P1
      *
      ** Register Spool File via RCF
     C                   EXSR      RCFP1
      *
      ** Write out Header Details
     C                   EXSR      HEADR1
      *
      ** Write out Repo Details
     C                   EXSR      REPOS
      *
      ** Set up Header Details for second page
     C                   Z-ADD     1             PPAGE
     C                   EXSR      HEADR2
      *
      ** Set Lower Limits to Depot Movement File
     C     HKDN38        SETLL     SEDPMVL3                               89
     C                   IF        *IN89 = *On
     C     HKDN38        READE     DPTMVDF                                89
      *
      ** Read through Depot Movements File
     C                   DOW       *IN89 = *Off
      *
      ** Set up Depot Movement Details
     C                   EXSR      DEPOTS
     C                   ADD       DPNA          W#DPNA           12 0
     C
     C     HKDN38        READE     DPTMVDF                                89
     C                   ENDDO
      *
      ** Write out Total amount format
     C                   MOVE      W#DPNA        ZFLD15
     C                   Z-ADD     0             W#DPNA
     C                   MOVE      NMDP          ZADEC
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        PTOTL
     C                   WRITE     DETAIL3
      *
     C                   ELSE
      *
     C                   WRITE     NONE
      *
     C                   ENDIF
      *
      ** Close Printer File
     C                   CLOSE     SE4100P1
      *
      ** Return
     C                   EVAL      *INLR = *On
      *
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  HEADR1 -- SUBROUTINE TO WRITE HEADER DETAILS
     C*
     C********************************************************************
     C*
     C     HEADR1        BEGSR                                                   ** RCFP1 **
      *
      **  Access Branch Details via Access Object
      *  (database error handling done in access program)
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCA          @BR               3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   EVAL      PBRCA = A8BRNM
      *
     C                   WRITE     HEAD1
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  HEADR2 -- SUBROUTINE TO WRITE HEADER DETAILS FOR SECOND PAGE
     C*
     C********************************************************************
     C*
     C     HEADR2        BEGSR                                                   ** RCFP1 **
      *
      ** Set up Our Reference
     C                   MOVE      DLNO          PDLNO
     C*
     C** Set up Customer Address
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     CNUM          @KEY1
 
     C                   EXSR      AOCUST
      *
     C                   EVAL      PCNA1 = BBCNA1
     C                   EVAL      PCNA2 = BBCNA2
     C                   EVAL      PCNA3 = BBCNA3
     C                   EVAL      PCNA4 = BBCNA4
     C
     C                   ADD       1             PPAGE
     C*
     C                   WRITE     HEAD2
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  INIT -- Initial Subroutine
     C*
     C********************************************************************
     C*
     C     INIT          BEGSR                                                   ** RCFP1 **
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    DealNo            6 0
 
     C     DealNo        CHAIN     DEALS                              89
     C
     C** Record not Found
     C                   IF        *IN89 = *On
     C     *LOCK         IN        LDA
     C                   MOVEL     'SE4100  '    DBPGM
     C                   MOVE      *BLANK        DBKEY
     C                   MOVEL     DealNo        DBKEY
     C                   MOVEL     'DEALS   '    DBFILE
     C                   MOVE      ' 03'         DBASE
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      ERROR
     C                   END
      *
      ** RCF Processing for Audit File
      *
     C*                  MOVE      '     '       SEQ               5
     C                   EXSR      RCFAU
     C                   WRITE     HEADAU
     C
     C                   ENDSR
     C*
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  REPOS -- SUBROUTINE TO WRITE REPO, BOND or PLEDGE DETAILS
     C*
     C********************************************************************
     C*
     C     REPOS         BEGSR                                                   ** RCFP1 **
     C*
     C** Set up First Narrative
     C                   IF        CHTP = 'A'
     C                   EVAL      AMND1 = 'AMENDMENT'
     C                   ENDIF
      *
     C                   IF        CHTP = 'R'
     C                   EVAL      AMND1 = 'CANCELLATION'
     C                   ENDIF
     C*
     C** Set up Customer Address
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     CNUM          @KEY1
 
     C                   EXSR      AOCUST
      *
     C                   EVAL      CNA1 = BBCNA1
     C                   EVAL      CNA2 = BBCNA2
     C                   EVAL      CNA3 = BBCNA3
     C                   EVAL      CNA4 = BBCNA4
     C*
     C** Set up Narrative
     C     DLNO          CHAIN     MMDEALLL                           89
     C
     C*
     C** Record not Found
     C                   IF        *IN89 = *On
     C     *LOCK         IN        LDA
     C                   MOVEL     'SE4100  '    DBPGM
     C                   MOVE      *BLANK        DBKEY
     C                   MOVEL     DLNO          DBKEY
     C                   MOVEL     'MMDEALLL'    DBFILE
     C                   MOVE      ' 01'         DBASE
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      ERROR
     C                   END
     C*
     C** Set up Narrative
     C                   IF        HKDRID = 'R'
     C                   IF        HKMTYP = 'IT' or HKMTYP = 'CD'
     C                             or HKMTYP = 'TD'
     C                   EVAL      RPTXT = ##TXT(1)
     C                   ENDIF
     C
     C                   IF        HKMTYP = 'IP' or HKMTYP = 'CL'
     C                             or HKMTYP = 'TI'
     C                   EVAL      RPTXT = ##TXT(2)
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        HKDRID = 'B'
     C                   IF        HKMTYP = 'IT' or HKMTYP = 'CD'
     C                             or HKMTYP = 'TD'
     C                   EVAL      RPTXT = ##TXT(3)
     C                   ENDIF
     C
     C                   IF        HKMTYP = 'IP' or HKMTYP = 'CL'
     C                             or HKMTYP = 'TI'
     C                   EVAL      RPTXT = ##TXT(4)
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        HKDRID = 'P'
     C                   IF        HKMTYP = 'IT' or HKMTYP = 'CD'
     C                             or HKMTYP = 'TD'
     C                   EVAL      RPTXT = ##TXT(5)
     C                   ENDIF
     C
     C                   IF        HKMTYP = 'IP' or HKMTYP = 'CL'
     C                             or HKMTYP = 'TI'
     C                   EVAL      RPTXT = ##TXT(6)
     C                   ENDIF
     C                   ENDIF
     C*
     C** Transaction Date
     C*
     C**Convert Value Date a Midas Day Number
     C                   CALLB     'ZDATE9'
     C                   PARM                    DDAT
     C                   PARM                    VDT
     C                   PARM                    @@RTN             1
 
     C                   EXSR      CVTDAT
 
     C                   EVAL      TDAT = Date
 
     C                   EVAL      Date = *Blanks
     C                   EVAL      VDT = *Zero
     C*
     C** Value Date
     C*
     C**Convert Value Date a Midas Day Number
     C                   CALLB     'ZDATE9'
     C                   PARM                    VDAT
     C                   PARM                    VDT
     C                   PARM                    @@RTN             1
 
     C                   EXSR      CVTDAT
 
     C                   EVAL      VDAT1 = Date
 
     C                   EVAL      Date = *Blanks
     C                   EVAL      VDT = *Zero
     C*
     C** Maturity Date
     C*
     C**Convert Maturity date a Midas Day Number
     C                   IF        MDAT > 0
     C                   CALLB     'ZDATE9'
     C                   PARM                    MDAT
     C                   PARM                    VDT
     C                   PARM                    @@RTN             1
 
     C                   EXSR      CVTDAT
 
     C                   EVAL      VDAT1 = Date
 
     C                   EVAL      Date = *Blanks
     C                   EVAL      VDT = *Zero
     C                   ENDIF
      *
      ** Set up Broker Detail
     C                   EXSR      BRKDTL
      *
      ** Set up Currency
     C                   EVAL      CCY1 = HKCCY
      *
      ** Set up Total Proceeds
     C     HKAMNP        IFLT      0                                            208051
     C                   Z-SUB     HKAMNP        HKAMNP                         208051
     C                   END                                                    208051
      *
      ** Access Currency Decimal Places
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      HKCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   Z-ADD     HKAMNP        ZFLD15
     C                   MOVE      A6NBDP        ZADEC
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        TPRC1
      *
      ** Set up Repurchase Rate
     C                   MOVE      HKINTR        RPRT1
      *
     C                   Z-ADD     7             ZADEC
     C                   MOVE      RPRT1         ZFLD15
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        RPRT1
      *
      ** Set up Repurchase Interest
     C
     C     HKIMAT        IFGE      0                                            198177
     C                   Z-ADD     HKIMAT        ZFLD15
     C                   ELSE                                                   198177
     C                   Z-SUB     HKIMAT        ZFLD15                         198177
     C                   END                                                    198177
     C     INTR          IFLT      0                                            208051
     C                   Z-SUB     ZFLD15        ZFLD15                         208051
     C                   END                                                    208051
     C                   MOVE      A6NBDP        ZADEC
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        RINT1
      *
      ***Set*up*Repurchase*Interest****                                         208051
      ** Set up Total Maturity Proceeds                                         208051
     C
     C     HKIMAT        IFGE      0                                            198177
     C                   Z-ADD     HKIMAT        ZFLD15
     C                   ELSE                                                   198177
     C                   Z-SUB     HKIMAT        ZFLD15                         198177
     C                   END                                                    198177
     C     INTR          IFLT      0                                            208051
     C                   SUB       HKAMNP        ZFLD15                         208051
     C                   Z-SUB     ZFLD15        ZFLD15                         208051
     C                   ELSE                                                   208051
     C                   ADD       HKAMNP        ZFLD15
     C                   END                                                    208051
     C                   MOVE      A6NBDP        ZADEC
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        MPRC1
      *
      ** Set up Settlement Details
     C                   EXSR      SETDTL
      *
      ** Set up Settlement Details
     C                   WRITE     DETAIL1
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  DEPOTS -- SUBROUTINE TO SET UP DEPOT MOVEMENT DETAILS
     C*
     C********************************************************************
     C*
     C     DEPOTS        BEGSR                                                   ** RCFP1 **
      *
      ** Get Security Details
     C     DPSS          CHAIN     SECTY                              89
     C*
     C** Record not Found
     C                   IF        *IN89 = *On
     C     *LOCK         IN        LDA
     C                   MOVEL     'SE4100  '    DBPGM
     C                   MOVE      *BLANK        DBKEY
     C                   MOVEL     DPSS          DBKEY
     C                   MOVEL     'SECTYD  '    DBFILE
     C                   MOVE      ' 02'         DBASE
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      ERROR
     C                   END
     C*
     C** Set up Instrument on Repo
     C                   EVAL      PSRPN = SRPN
     C*
     C** Set up Maturity Date
     C                   IF        DPMD > DPDO
     C                   MOVE      DPMD          MatDat            5 0
     C                   ELSE
     C                   MOVE      DPDO          MatDat            5 0
     C                   ENDIF
     C*
     C**Convert Maturity Date to Date
     C                   CALLB     'ZDATE9'
     C                   PARM                    MatDat
     C                   PARM                    VDT
     C                   PARM                    @@RTN             1
 
     C                   EXSR      CVTDAT
 
     C                   EVAL      PMTDY = Date
     C*
     C** Set up Nominal
     C                   MOVE      DPNA          ZFLD15
     C                   MOVE      NMDP          ZADEC
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        PNOML
     C*
     C** Set up Switch
     C                   IF        SIOI = 'O'
     C                   EVAL      PSWCH = 'OUT'
     C                   ENDIF
     C
     C                   IF        SIOI = 'I'
     C                   EVAL      PSWCH = 'IN'
     C                   ENDIF
     C*
     C** Set up Certificate Number and write DETAIL2 records
     C                   EXSR      CRTDTL
 
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** BRKDTL SR to Format Broker Detail
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     BRKDTL        BEGSR
     C*
     C                   SELECT
     C*
     C                   WHEN      BRKC = *BLANKS
     C                   EVAL      ARBY1 = *BLANKS
     C*
     C                   WHEN      BRKC = 'SWAP'
     C                   EVAL      ARBY1 = 'SWAP'
     C*
     C                   WHEN      BRKC = 'MAIL'
     C                   EVAL      ARBY1 = 'MAIL'
     C*
     C                   WHEN      BRKC = 'PHON'
     C                   EVAL      ARBY1 = 'PHONE'
     C*
     C                   WHEN      BRKC = 'TELX'
     C                   EVAL      ARBY1 = 'TELEX'
     C*
     C                   OTHER
     C*
     C                   CALLB     'AOBROKR0'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      BRKC          P@BROK            4            I:Key field    S0123
     C     SDBROK        PARM      SDBROK        DSSDY                          O:Format
     C*
     C                   EVAL      ARBY1 = A9BKNM
     C*
     C                   ENDSL
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SETDTL SR to Format Settlement Details
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     SETDTL        BEGSR
     C*
     C** Value Date Settlement Methods
     C                   SELECT
     C*
     C** Settlement Type is 00 or 06
     C                   WHEN      SDST = 0 or SDST = 6
     C                   EVAL      PNARF1 = 'INSTRUCTION TO BE ADVISED'
     C*
     C** Settlement Type is 01,07 or 08
     C                   WHEN      SDST = 1 or SDST = 7 or SDST = 8
     C*
     C                   EVAL      PNARF1 = 'PAYMENT FROM'
     C                   EXSR      PYMFRV
     C*
     C                   EVAL      PNART1 = 'PAYMENT TO'
     C                   EXSR      PYMTOV
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARA1 = 'FOR ACCOUNT OF'
     C*
     C** Access Customer Details
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     CNUM          @KEY1
     C                   EXSR      AOCUST
     C                   MOVE      BBCUST        W#CUST            6
     C*
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     FACO          @KEY1
     C                   EXSR      AOCUST
     C*
     C                   IF        BBCUST <> W#CUST
     C                   EVAL      PFAN1 = BBCRNM
     C                   EVAL      PFAT1 = BBCRTN
     C                   ELSE
     C                   EVAL      PFAN1 = 'YOURSELVES'
     C                   ENDIF
     C                   ENDIF
     C*
     C** Settlement Type is 02
     C                   WHEN      SDST = 2
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF1 = 'WE AWAIT YOUR REMITTANCE'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF1 = 'WE WILL SEND REMITTANCE'
     C                   ENDIF
     C*
     C** Settlement Type is 03
     C                   WHEN      SDST = 3
     C*
     C                   EVAL      PNARF1 = 'AS PER OUR INSTRUCTION'
     C*
     C** Settlement Type is 04
     C                   WHEN      SDST = 4
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF1 = 'BY DEBIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF1 = 'BY CREDIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   EVAL      PFRN1 = OSDA
     C*
     C** Settlement Type is 12
     C                   WHEN      SDST = 12
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF1 = 'WE SHALL COLLECT REMITTANCE'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF1 = 'YOU WILL COLLECT REMITTANCE'
     C                   ENDIF
     C*
     C** Settlement Type is 14
     C                   WHEN      SDST = 14
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF1 = 'BY DEBIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF1 = 'BY CREDIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   ENDSL
     C*
     C** Maturity Date Settlement Methods
     C                   SELECT
     C*
     C** Settlement Type is 00 or 06
     C                   WHEN      MDST = 0 or MDST = 6
     C                   EVAL      PNARF2 = 'INSTRUCTION TO BE ADVISED'
     C*
     C** Settlement Type is 01,07 or 08
     C                   WHEN      MDST = 1 or MDST = 7 or MDST = 8
     C*
     C                   EVAL      PNARF2 = 'PAYMENT FROM'
     C                   EXSR      PYMFRM
     C*
     C                   EVAL      PNART2 = 'PAYMENT TO'
     C                   EXSR      PYMTOM
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARA2 = 'FOR ACCOUNT OF'
     C*
     C** Access Customer Details
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     CNUM          @KEY1
     C                   EXSR      AOCUST
     C                   MOVE      BBCUST        W#CUST            6
     C*
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVEL     FACO          @KEY1
     C                   EXSR      AOCUST
     C*
     C                   IF        BBCUST <> W#CUST
     C                   EVAL      PFAN2 = BBCRNM
     C                   EVAL      PFAT2 = BBCRTN
     C                   ELSE
     C                   EVAL      PFAN2 = 'YOURSELVES'
     C                   ENDIF
     C                   ENDIF
     C*
     C** Settlement Type is 02
     C                   WHEN      MDST = 2
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF2 = 'WE AWAIT YOUR REMITTANCE'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF2 = 'WE WILL SEND REMITTANCE'
     C                   ENDIF
     C*
     C** Settlement Type is 03
     C                   WHEN      MDST = 3
     C*
     C                   EVAL      PNARF2 = 'AS PER OUR INSTRUCTION'
     C*
     C** Settlement Type is 04
     C                   WHEN      MDST = 4
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF2 = 'BY DEBIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF2 = 'BY CREDIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   EVAL      PFRN2 = OMDA
     C*
     C** Settlement Type is 12
     C                   WHEN      MDST = 12
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF2 = 'WE SHALL COLLECT REMITTANCE'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C                   EVAL      PNARF2 = 'YOU WILL COLLECT REMITTANCE'
     C                   ENDIF
     C*
     C** Settlement Type is 14
     C                   WHEN      MDST = 14
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF2 = 'BY DEBIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C                   EVAL      PNARF2 = 'BY CREDIT TO ACCOUNT'
     C                   ENDIF
     C*
     C                   ENDSL
     C*
     C** Special Instructions
     C                   IF        SPI <> *Blanks
     C                   EVAL      PSPI = SPI
     C                   EVAL      PNARSP = 'SPECIAL INSTRUCTIONS'
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** PYMFRV SR to Format Payment From Details (Value Date)
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     PYMFRV        BEGSR
     C
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C*
     C** Access Nostro Details
     C                   EVAL      P@CYCD = CCY
     C                   EVAL      P@NONB = OSDA
     C                   EXSR      AONOST
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = A7CUST
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PFRN1 = BBCRNM
     C                   EVAL      PFRA1 = BBCRTN
     C*
     C                   ENDIF
 
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C*
     C                   IF        TSTN <> *Blanks
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = TSTN
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PFRN1 = BBCRNM
     C                   EVAL      PFRA1 = BBCRTN
     C*
     C                   ELSE
     C                   EVAL      PFRN1 = 'WE AWAIT YOUR ADVICE'
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** PYMTOV SR to Format Payment From Details (Value Date)
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     PYMTOV        BEGSR
     C
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C*
     C** Access Nostro Details
     C                   EVAL      P@CYCD = CCY
     C                   EVAL      P@NONB = OSDA
     C                   EXSR      AONOST
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = A7CUST
     C                   EXSR      AOCUST
     C*
     C** Set up Payment To Address
     C                   EVAL      PTON1 = BBCRNM
     C                   EVAL      PTOA1 = BBCRTN
     C*
     C                   ENDIF
 
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C*
     C                   IF        TSTN <> *Blanks
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = TSTN
     C                   EXSR      AOCUST
     C*
     C** Set up Payment To Address
     C                   EVAL      PTON1 = BBCRNM
     C                   EVAL      PTOA1 = BBCRTN
     C*
     C                   ELSE
     C                   EVAL      PTON1 = 'WE AWAIT YOUR ADVICE'
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** PYMFRM SR to Format Payment From Details (Maturity Date)
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     PYMFRM        BEGSR
     C
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C*
     C** Access Nostro Details
     C                   EVAL      P@CYCD = CCY
     C                   EVAL      P@NONB = OMDA
     C                   EXSR      AONOST
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = A7CUST
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PFRN2 = BBCRNM
     C                   EVAL      PFRA2 = BBCRTN
     C*
     C                   ENDIF
 
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C*
     C                   IF        TMAN <> *Blanks
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = TMAN
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PFRN2 = BBCRNM
     C                   EVAL      PFRA2 = BBCRTN
     C*
     C                   ELSE
     C                   EVAL      PFRN2 = 'WE AWAIT YOUR ADVICE'
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** PYMTOM SR to Format Payment From Details (Maturity Date)
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     PYMTOM        BEGSR
     C
     C                   IF        DTYP = 'IP' or DTYP = 'CL' or DTYP = 'TI'
     C*
     C** Access Nostro Details
     C                   EVAL      P@CYCD = CCY
     C                   EVAL      P@NONB = OMDA
     C                   EXSR      AONOST
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = A7CUST
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PTON2 = BBCRNM
     C                   EVAL      PTOA2 = BBCRTN
     C*
     C                   ENDIF
 
     C                   IF        DTYP = 'IT' or DTYP = 'CD' or DTYP = 'TD'
     C*
     C                   IF        TMAN <> *Blanks
     C*
     C** Access Customer Details
     C                   EVAL      @KEY1 = TMAN
     C                   EXSR      AOCUST
     C*
     C** Set up Payment From Address
     C                   EVAL      PTON2 = BBCRNM
     C                   EVAL      PTOA2 = BBCRTN
     C*
     C                   ELSE
     C                   EVAL      PTON2 = 'WE AWAIT YOUR ADVICE'
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** CRTDTL SR to Format Certificate Details
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     CRTDTL        BEGSR
     C*
     C** Access Certificate Details
     C     DPRN          SETLL     SECRTNL1                               89
     C                   IF        *IN89 = *On
     C     DPRN          READE     SECRTNF1                               89
     C                   DOW       *IN89 = *Off
     C*
     C** Write single line if there is only one certificate number
     C                   IF        CNRNN2 = *Zeros
     C                   MOVEL     CNRNN1        PCRT1
     C                   ADD       1             COUNT             2 0
     C                   ELSE
     C*
     C** Set up two lines of printer file for ranges
     C                   MOVEL     'EACH'        W#EACH            4
     C                   MOVE      'TO'          W#TO              2
     C                   MOVEL     CNRNN2        W#RNN2           10
     C                   MOVEL     CNRNN1        PCRT1
     C     PCRT1         CAT       W#TO:1        PCRT1
     C     PCRT1         CAT       W#RNN2:1      PCRT1
     C                   MOVEL     CNUNIT        PCRT2
     C     PCRT2         CAT       W#EACH:1      PCRT2
     C                   ADD       2             COUNT
     C                   ENDIF
      *
      ** Set up Header rewrite
     C     COUNT         IFGE      45
     C                   EVAL      RptHdr = 'Y'
     C                   IF        PCRT2 <> *Blanks
     C                   Z-ADD     2             Count
     C                   ELSE
     C                   Z-ADD     1             Count
     C                   ENDIF
     C                   ENDIF
      *
      ** Reprint Header if Required
     C     RptHdr        IFEQ      'Y'
     C                   ADD       1             PPAGE
     C                   WRITE     HEAD2
     C                   EVAL      RptHdr = *Blank
     C                   ENDIF
      *
      *
      ** Write out Detail Record
     C                   WRITE     DETAIL2
      *
      ** Set Indicator so only Certificate fields are written for each
      ** depot movement for further certificates records
     C                   EVAL      *IN32 = *ON
      *
      ** Write second line of certifactes information if required
     C                   IF        PCRT2 <> *Blanks
     C                   EVAL      *IN31 = *ON
     C                   WRITE     DETAIL2
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF
     C
     C                   EVAL      PCRT1 = *Blanks
     C                   EVAL      PCRT2 = *Blanks
     C                   EVAL      PSRPN = *Blanks
     C                   EVAL      PMTDY = *Blanks
     C                   EVAL      PNOML = *Blanks
     C                   EVAL      PSWCH = *Blanks
      *
     C     DPRN          READE     SECRTNF1                               89
     C                   ENDDO
     C                   ELSE
      *
      ** Set up Header rewrite
     C                   ADD       1             COUNT             2 0
     C     COUNT         IFGE      45
     C                   ADD       1             PPAGE
     C                   WRITE     HEAD2
     C                   Z-ADD     1             COUNT             2 0
     C                   ENDIF
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C                   EVAL      *IN32 = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AONOST - Subroutine to retrieve Nosto Details                 *
      *                                                               *
      *****************************************************************
     C     AONOST        BEGSR
 
     C                   CALLB     'AONOSTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM                    P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM                    P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOCUST - Subroutine to retrieve Customer Details              *
      *                                                               *
      *****************************************************************
     C     AOCUST        BEGSR
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSFDY
 
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  RCFP1 -- SUBROUTINE TO REGISTER P1 PRINTER FILE VIA RCF
     C*
     C********************************************************************
     C*
     C     RCFP1         BEGSR                                                   ** RCFP1 **
     C*
     C**      Ensure Report Spool File Recorded by RCF
     C*
     C                   Z-ADD     SFNUM1        ZSNUM1            6 0
     C**
     C                   CALL      'ZSFILE'
     C                   PARM      *Blanks       SEQ               5
     C                   PARM      BRCA          SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM1
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C*
     C**  Error during ZSFILE processing return to calling program
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C*
     C                   ENDSR
     C*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFAU -- SUBROUTINE TO REGISTER AU PRINTER FILE VIA RCF      *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   ** RCFAU **
      *
      ** Ensure audit spool file recorded by RCF
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *Blanks       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
     C     ZSERR         IFEQ      'Y'
      *
      ** Error during ZSFILE processing, return to calling program
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
      *
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** ERROR SR.To write a record to SE4110AU
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C** Database Error Occurred
     C*  ~~~~~~~~~~~~~~~~~~~~~~~
     C     ERROR         BEGSR
     C*
     C     *INU7         IFEQ      '1'
     C
     C                   WRITE     AUDBER
     C*
     C                   DUMP
     C*
     C                   RETURN
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** CVTDAT SR to convert date to DDMMMYY Format
     C*  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     CVTDAT        BEGSR
     C*
     C                   MOVE      YR            Year
     C*
     C                   MOVE      DD            Day
     C*
     C                   MOVE      ZMNM(MM)      Mnth
     C*
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  ##TXT
WE CONFIRM OUR REPURCHASE AGREEMENT AS FOLLOWS
WE CONFIRM OUR REVERSE REPURCHASE AGREEMENT AS FOLLOWS
WE CONFIRM OUR BOND LENDING AGREEMENT AS FOLLOWS
WE CONFIRM OUR BOND BORROWING AGREEMENT AS FOLLOWS
WE CONFIRM OUR PLEDGE DEPOSIT AGREEMENT AS FOLLOWS
WE CONFIRM OUR PLEDGE LOAN AGREEMENT AS FOLLOWS
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
