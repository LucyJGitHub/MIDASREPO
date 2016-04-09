     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Accruals Using Net-Treasury-Rate Extract')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL5110 - Midas DL Accruals Using Net-Treasury-Rate Extract   *
      *                                                               *
      *  Function:  This program calculates accruals by using the     *
      *             Net-Treasury-Rate interest fields.                *
      *                                                               *
      *  NOTE: Check DL0500 for changes that may apply to it if there *
      *        are amendments done to this program.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 18Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005  *CREATE    Date 16Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus                                      *
      *  CSC042 - COB Performance improvements. Try to keep number of *
      *           accesses to AOBRCHR0 to a minimum.                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALS     IF   E           K DISK    IGNORE(DEALSDAF)
     F                                     INFSR(*PSSR)
      ** Midas Deals File
 
     FDLCFSCPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Cash Flow Schedule
                                                                                              CIR014
     FDLDEALL5  IF   E           K DISK    IGNORE(DLDLDBD0)                                   CIR014
     F                                     IGNORE(DLDLDCD0)                                   CIR014
     F                                     INFSR(*PSSR)                                       CIR014
      ** Midas DL Deals Extension File                                                        CIR014
 
     FACCEXNN   O    E             DISK    PREFIX(NN) INFSR(*PSSR)
      ** Midas DL Accruals Using N-T-R Extract Header
 
     FACCEXNO   O    E             DISK    PREFIX(NO) INFSR(*PSSR)
      ** Midas DL Accruals Using N-T-R Extract Detail
 
     FACCEXNP   O    E             DISK    PREFIX(NP) INFSR(*PSSR)
      ** Midas DL Accruals Using N-T-R Extract Trailer
 
     FDL5110AU  O    E             PRINTER
      ** Midas DL Accruals Using N-T-R Extract Audit
 
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Deals File - Swaps                              *
      *    02         Deals File - Loans/Deposits                     *
      *    03         Deals File - Negotiable Assets Purchased        *
      *    04         Deals File - Trailer                            *
      *    05         Deals File - Catchall                           *
      *    06         Deals File - Neg. Assets Sold                   *
      *    07         Deals File - FRA/IRS                            *
      *    21         Notice Days Negative                            *
      *    22         Next Interest Date = Zero                       *
      *    23         Sale Date - N. A. Purchased = Zero              *
      *    30         Initial Rate Set  (U/TDNSI Bit 0)               *
      *    31         Negative Interest (U/TDSTI Bit 1)               *
      *    33         Ave. Rate Cap/Collar (U/TDSTI Bit 3)            *
      *    34         Cap/Collar Floor Rate Entered (U/TDSTI Bit 4)   *
      *    40         "No Details to Report" Indicator                *
      *    47         Foreign Exchange Record - Swap                  *
      *    49         Start/Last Int. Date later than Rpt. Ctrl. Date *
      *    50         Position Swap Record                            *
      *    51         Ignore 01 Type                                  *
      *    52         Ignore 02 Type                                  *
      *    53         Ignore 03 Type                                  *
      *    54         N/A Record has Deal Type C1, C2, BD, or BP      *
      *    55         N/A Record has Deal Type TA, TB, or DA          *
      *    56         Write Extract for Internal Deposit from swap    *
      *    58         Accrue on Last Day Indicator = 'Y'              *
      *    59         N. A. Accruals Indicator = 'Y'                  *
      *    64         Deal Type = 'C1'                                *
      *    65         No Start/Last Int. Date since Acc. Ctrl. Date   *
      *    70         Maturity Date precedes Next Interest Date       *
      *    71         Last Interest Date later than Value Date        *
      *    80         File Controls Out of Balance                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Switchable Feature Count Constant
     D*SFC******       C                   CONST(5)                                           CAS006
     D*SFC******       C                   CONST(6)                                    CAS006 CIR014
     D SFC             C                   CONST(7)                                           CIR014
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ##BR            S              3    DIM(999)                             Branch Codes  CSC042
     D ##BC            S              3    DIM(999)                             Company Codes CSC042
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** Accumulation Arrays
     D INT             S             15  0 DIM(2)
     D DEC             S              3  0 DIM(2)
 
      ** Data Structure for the Total Values of Deal Records
     D                 DS
     D DAMT                    1     13  0
     D PUAM                    1     13  0
     D PCPL                    1     13  0
     D PUPR                    1     13  0
     D SAPRDE                  1     13  0
     D UPAMT                   1     13  0
 
      ** Date Divider Data Structure
     D                 DS
     D ZA                             6  0
     D  ZX                            2  0 OVERLAY(ZA)
     D  ZY                            2  0 OVERLAY(ZA : *NEXT)
     D  ZZ                            2  0 OVERLAY(ZA : *NEXT)
 
      ** Midas DL Accruals Using N-T-R Extract Data Structures
     D AENN          E DS                  EXTNAME(ACCEXNN) PREFIX(NN)
     D AENO          E DS                  EXTNAME(ACCEXNO) PREFIX(NO)
     D AENP          E DS                  EXTNAME(ACCEXNP) PREFIX(NP)
 
      ** Midas DL Accruals Extract Data Structures
     D AEAN          E DS                  EXTNAME(ACCEXAN)
     D AEAO          E DS                  EXTNAME(ACCEXAO)
     D  AORECI       E                     EXTFLD(RECI)
     D  AOCCY        E                     EXTFLD(CCY)
     D  AODTYP       E                     EXTFLD(DTYP)
     D  AODLST       E                     EXTFLD(DLST)
     D  AOPCPL       E                     EXTFLD(PCPL)
     D  AOCLAS       E                     EXTFLD(CLAS)                                       CDL038
     D AEAP          E DS                  EXTNAME(ACCEXAP)
     D  APRECI       E                     EXTFLD(RECI)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas Modules Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Dealing Details Data Structure
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  ACCDB1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** FRA/IRS Details Data Structure
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Access Object Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Access Object Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Switchable Feature Declarations      ¦
      ** +--------------------------------------+
 
      ** Switchable Feature Identifiers
 
      ** 1. IRS Interest Rate Calendars
      ** 2. Compounding of Interest
      ** 3. FRA/IRS New Calculation Method for Eurobond Basis
      ** 4. FRA/IRS Business Day Conventions Up To 10 Ccys
      ** 5. FRA/IRS Amortisation of Caps, Collars, Floors & ICS
 
     D SFID            DS
     D                                6A   INZ('CIR001')
     D                                6A   INZ('CIR002')
     D                                6A   INZ('CIR004')
     D                                6A   INZ('CIR005')
     D                                6A   INZ('CIR006')
     D                                6A   INZ('CAS006')                                      CAS006
     D                                6A   INZ('CIR014')                                      CIR014
 
      ** Switchable Feature Array
     D  SF                            6A   DIM(SFC) OVERLAY(SFID)
 
      ** Switchable Feature Indicator Data Structure
     D SFIN            DS
     D  CIR001                        1A   INZ('N')
     D  CIR002                        1A   INZ('N')
     D  CIR004                        1A   INZ('N')
     D  CIR005                        1A   INZ('N')
     D  CIR006                        1A   INZ('N')
     D  CAS006                        1A   INZ('N')                                           CAS006
     D  CIR014                        1A   INZ('N')                                           CIR014
 
      ** Switchable Feature Indicator Array
     D  SFI                           1A   DIM(SFC) OVERLAY(SFIN)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
     D PBrch           S              3A
     D PCcy            S              3A
 
      ** Working Variables
     D WDetTyp         S              1A
     D WCtr            S              2P 0
     D WRun            S              1A
     D ZZStartDate     S              8S 0                                                    CIR013
     D ZZEndDate       S              8S 0                                                    CIR013
     D @@Rtn           S              1A                                                      CIR013
     D #29Feb          S              1A                                                      CIR013
     D WDLNO           S              6A                                                      CIR014
 
      ** +--------------------------------------+
      ** ¦ Legacy Variables                     ¦
      ** +--------------------------------------+
 
     D #EDAT           S              5P 0
     D AMTAD           S             13P 0
     D AMTTA           S             13P 0
     D CHK             S              1P 0
     D CHK2            S              1P 0
     D DAY1            S              2P 0
     D DAYS            S              5P 0
     D DATEND          S              6P 0
     D DATST           S              6P 0
     D DLYACC          S             15P 5
     D ELEAP           S              5P 0
     D ENDDAY          S              2P 0
     D ENDMTH          S              2P 0
     D ENDWRK          S              4P 0
     D ENDYR           S              2P 0
     D ICIR            S             13P 7
     D INT6DY          S             15P 7
     D MTHS            S              2P 0
     D MTHS2           S              4P 0
     D*PCUS*****       S              6P 0                                                    CSD027
     D PCUS            S              6A                                                      CSD027
     D PDLNO           S              6P 0
     D PERIOD          S              5P 0
     D PFRDT           S              5P 0
     D PINT            S             13P 0
     D PINTAM          S             13P 0
     D POTCD           S              1A
     D PRODUC          S             15P 0
     D PRTNC           S              1A
     D PTOAC           S              1A
     D PTODT           S              5P 0
     D QINT            S             13P 0
     D RECRED          S              5P 0
     D RECRIT          S              5P 0
     D REPCD           S              5P 0
     D SLEAP           S              5P 0
     D STDAY           S              2P 0
     D STMTH           S              2P 0
     D STORE           S              4P 0
     D STWRK           S              4P 0
     D STYR            S              2P 0
     D SVBRTT          S              2P 0
     D SVEINR          S             11P 7
     D SWIPRD          S             13P 0
     D SWKINT          S             13P 0
     D SZACTD          S              5P 0
     D SZAIAN          S             13P 0
     D SZAIAP          S             13P 0
     D SZAITC          S             13P 0
     D SZAITD          S             13P 0
     D SZAMAD          S             13P 0
     D SZAMTA          S             13P 0
     D SZDISC          S             11P 7
     D SZDSA           S             15P 0
     D SZEDAT          S              5P 0
     D SZFIX           S             11P 7
     D SZFLT           S             11P 7
     D SZIANP          S             13P 0
     D SZICB           S              1P 0
     D SZICVL          S              3P 0
     D SZINPM          S              1A
     D SZIPRD          S             13P 0
     D SZMDAT          S              5P 0
     D SZPPL           S             13P 0
     D SZSDAT          S              5P 0
     D SZSETL          S             15P 0
     D SZSLID          S              5P 0
     D SZVDAT          S              5P 0
     D SZPER           S              5P 0
     D SZRDF           S             11P 7
     D SZRSA           S             15P 0
     D SZRDS           S             13P 0
     D SZWRK1          S             11P 7
     D SZWRK2          S             20P 7
     D SZWRK3          S              5P 0
     D SZWRK4          S             14P 7
     D SZWRK5          S             14P 7
     D SZWRK6          S             15P 0
     D SZWRK7          S             12P 9
     D SZWRK8          S             15P 0
     D SZWRK9          S             15P 7
     D TODAT           S              5P 0
     D TOTINT          S             13P 0
     D W@MDY           S              4P 0
     D WACTD           S              5P 0
     D WAMAD           S             15P 0
     D WAMTA           S             15P 0
     D WIACD           S              5P 0
     D WINTR           S             30P 9
     D WKINT           S             13P 0
     D WSLIP           S              5P 0
     D WTAMAD          S             13P 0
     D WUAMAD          S             13P 0
     D X               S              1P 0
     D YEAR1           S              4P 0
     D YEAR2           S              4P 0
     D ZADATE          S              7A
     D ZDATE           S              6P 0
     D ZDATFM          S              1A
     D ZDAY            S              2P 0
     D ZDAYN1          S              5P 0
     D ZDAYNO          S              5P 0
     D ZFULPD          S              5P 0
     D ZIAMT           S             15P 0
     D ZIBEG           S              5P 0
     D ZICALC          S              1P 0
     D ZIEND           S              5P 0
     D ZINT6DY         S             15P 7
     D ZINTR           S             30P 9
     D ZIRATE          S             11P 7
     D ZIWRK1          S             30P 9
     D ZIWRK2          S             30P 9
     D ZIWRK3          S              5P 0
     D ZIWRK4          S             15P 7
     D ZIWRK5          S             15P 9
     D ZMTH            S              2P 0
     D ZPARPD          S              5P 0
     D ZRTCD           S              7A
     D ZRTCDIN         S             10A
     D ZYEAR           S              2P 0
     D ZZAMT           S             15P 3
     D ZZAMTI          S             15P 0
     D ZZAMTD          S              3P 0
     D ZZBEG           S              5P 0
     D ZZCALC          S              1A
     D ZZEND           S              5P 0
     D ZZINDY          S              5P 0
     D ZZNEGD          S              5A
     D ZZTOTI          S             15P 0
     D ZZTOTD          S              3P 0
     D ZZWK2           S              4P 0
     D ZZWK3           S             15P 0
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     IDEALSDDF
     I              CNUM                        PCUS
     I              PINT1                       PINT
      ** Deals File - Detail Record - Negotiable Assets Purchased
 
     IDEALSDEF
     I              SAPR                        SAPRDE
     I              PUPR                        PUPRDE
      ** Deals File - Detail Record - Negotiable Assets Sold
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Output Header Record.
 
     C                   EXSR      SRAENN
 
     C                   READ      DEALS
 
      ** Output 'No Details to Report' if there are no deals available.
 
     C                   IF        %EOF(DEALS)
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   DOW       NOT %EOF(DEALS)
 
      ** Reset the relevant indicators.
 
     C                   EXSR      SRIIND
 
      ** Execute the Record Identification Code subroutine.
 
     C                   EXSR      SRRICD
 
     C                   IF        *IN04 = *ON OR *IN05 = *ON
     C                   EXSR      SRDETAIL
     C                   READ      DEALS
     C                   ITER
     C                   ENDIF
 
      ** Accumulate the value of live records read in INT,2 and DEC,2.
 
     C                   IF        RECI = 'D'
     C                   EVAL      RECRED = RECRED + 1
     C                   EVAL      X = 2
     C                   MOVE      DAMT          ZZAMT
     C                   EXSR      SRHASH
     C                   ENDIF
 
      ** Access Branch Details.
 
     C                   MOVEL     BRCA          ##KB                                         CSC042
     C                   EXSR      ##CHKB                                                     CSC042
      * If branch is in the array then use the details                                        CSC042
     C     ##FIC         IFEQ      'Y'                                          *** B10       CSC042
     C                   EXSR      ##SETB                                                     CSC042
     C                   ELSE                                                   *** X10       CSC042
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey = PBrch
     C                   EVAL      DBase = 106
     C                   EXSR      *PSSR
     C                   ELSE                                                                 CSC042
      * Details found on the DB so add them to the array                                      CSC042
      * if the array still has room                                                           CSC042
     C                   EXSR      ##ADDB                                                     CSC042
     C                   ENDIF
     C                   END                                                    *** E10       CSC042
 
      ** Begin Deal Processing
      ** =====================
 
     C                   SELECT
 
      ** Foreign Exchange Deals
      ** ----------------------
 
     C                   WHEN      *IN01 = *ON
     C                   EXSR      SRFX
 
      ** Loans/Time Deposits
      ** -------------------
 
     C                   WHEN      *IN02 = *ON
     C                   EXSR      SRLD
 
      ** Negotiable Assets Purchased
      ** ---------------------------
 
     C                   WHEN      *IN03 = *ON
     C                   EXSR      SRNAP
 
      ** Negotiable Assets Sold
      ** ----------------------
 
     C                   WHEN      *IN06 = *ON
     C                   EXSR      SRDETAIL
 
      ** Forward Rate Agreements/Interest Rate Swaps
      ** -------------------------------------------
 
     C                   WHEN      *IN07 = *ON
     C                   EXSR      SRFI
 
     C                   ENDSL
 
      ** End Deal Processing
      ** ===================
 
     C                   READ      DEALS
 
     C                   ENDDO
 
     C                   EXSR      SRDETAIL
     C                   EXSR      SROBP
 
      ** Return to the calling program.
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIIND - Initialises relevant indicators.                    *
      *                                                               *
      *****************************************************************
      /EJECT                                                                                  CSC042
     C********************************************************************                    CSC042
      *                                                                                       CSC042
      * ##CHKB - Subroutine to check the Branch in the arrays                                 CSC042
      *                                                                                       CSC042
     C     ##CHKB        BEGSR                                                                CSC042
      *                                                                                       CSC042
     C     *LIKE         DEFINE    A8BRCD        ##KB                                         CSC042
      *                                                                                       CSC042
      * Set off the branch found indicator                                                    CSC042
     C                   MOVEL     *BLANK        ##FIC             1                          CSC042
      *                                                                                       CSC042
      * Save the state of indicator 30 so it can be reset at the end                          CSC042
      * of the SR as it may be used elsewhere in the code                                     CSC042
     C     *IN30         IFEQ      *ON                                                        CSC042
     C                   MOVEL     'Y'           #IN30             1                          CSC042
     C                   ELSE                                                                 CSC042
     C                   MOVEL     'N'           #IN30                                        CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
     C                   SETOFF                                           30                  CSC042
      *                                                                                       CSC042
      * Restore the saved Value of B                                                          CSC042
     C                   Z-ADD     ##BSV         B                                            CSC042
      *                                                                                       CSC042
     C* Check whether details for Branch already in array                                     CSC042
      *                                                                                       CSC042
      * Is this the same as the last LOKUP, if so we can bypass                               CSC042
      * the LOKUP                                                                             CSC042
      * Defend against B being 0                                                              CSC042
     C     B             IFEQ      0                                                          CSC042
     C                   Z-ADD     1             B                                            CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      * If the branch being checked is the same then use these                                CSC042
      * details rather than doing a LOKUP                                                     CSC042
     C     ##KB          IFEQ      ##BR(B)                                                    CSC042
      * Found so seton 30                                                                     CSC042
     C                   SETON                                            30                  CSC042
     C                   ELSE                                                                 CSC042
     C                   Z-ADD     1             B                                            CSC042
     C     ##KB          LOOKUP    ##BR(B)                                30                  CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      * Save the last update to B                                                             CSC042
     C     *IN30         IFEQ      *ON                                                        CSC042
     C                   Z-ADD     B             ##BSV                                        CSC042
      * Set the indicator to show the data was found                                          CSC042
     C                   MOVEL     'Y'           ##FIC                                        CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      * Reset the state of indicator 30.                                                      CSC042
     C     #IN30         IFEQ      'Y'                                                        CSC042
     C                   MOVEL     *ON           *IN30                                        CSC042
     C                   ELSE                                                                 CSC042
     C                   MOVEL     *OFF          *IN30                                        CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
     C                   ENDSR                                                                CSC042
      ********************************************************************                    CSC042
      /EJECT                                                                                  CSC042
      ********************************************************************                    CSC042
      *                                                                                       CSC042
      * ##SETB - Sets up the SDBRCHPD fields used in the code from the                        CSC042
      * arrays                                                                                CSC042
      *                                                                                       CSC042
     C     ##SETB        BEGSR                                                                CSC042
      *                                                                                       CSC042
     C                   MOVEL     ##BR(B)       A8BRCD                                       CSC042
     C                   MOVEL     ##BC(B)       A8CMCD                                       CSC042
      *                                                                                       CSC042
     C                   ENDSR                                                                CSC042
      *                                                                                       CSC042
      ********************************************************************                    CSC042
      /EJECT                                                                                  CSC042
      ********************************************************************                    CSC042
      *                                                                                       CSC042
      * ##ADDB - Adds the SDBRCHPD fields used in the code to the                             CSC042
      * arrays                                                                                CSC042
      *                                                                                       CSC042
     C     ##ADDB        BEGSR                                                                CSC042
      *                                                                                       CSC042
      * If there is still room in the array then add the details                              CSC042
     C     ##BNDX        IFLT      999                                                        CSC042
     C                   ADD       1             ##BNDX                                       CSC042
     C                   Z-ADD     ##BNDX        B                                            CSC042
     C                   MOVEL     A8BRCD        ##BR(B)                                      CSC042
     C                   MOVEL     A8CMCD        ##BC(B)                                      CSC042
     C                   END                                                                  CSC042
      *                                                                                       CSC042
      * Update ##BSV  so next call to ##CHKB checks this latest adddition                     CSC042
      * to the array firss                                                                    CSC042
     C                   Z-ADD     B             ##BSV                                        CSC042
      *                                                                                       CSC042
     C                   ENDSR                                                                CSC042
      ********************************************************************                    CSC042
      /EJECT                                                                                  CSC042
     C     SRIIND        BEGSR
 
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *OFF
     C                   EVAL      *IN55 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      *IN70 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFX - Foreign Exchange Processing.                          *
      *                                                               *
      *****************************************************************
     C     SRFX          BEGSR
 
     C                   EVAL      *IN51 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN50 = *ON
     C                   EVAL      *IN51 = *OFF
 
     C                   IF        RCDC <> 14
 
     C                   EVAL      *IN51 = *ON
 
     C                   IF        RCDC <> 20
     C                   EVAL      *IN50 = *OFF
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *IN51 = *OFF
 
     C                   IF        FSLI <> 2
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
      ** Has the 1st Leg Value been reached?
 
     C                   IF        REPCD < OTDT
     C                   EVAL      *IN57 = *ON
     C                   ENDIF
 
     C                   IF        RCDC <> 20
     C                   EVAL      *IN50 = *OFF
     C                   EXSR      SRSWPL
     C                   LEAVESR
     C                   ENDIF
 
      ** Output record for Internal Deposit.
 
     C                   EVAL      ZIBEG = OTDT
 
      ** If Value Date is less than Report Control Date, use Value
      ** Date as the End Date.
 
     C                   IF        VDAT < REPCD
     C                   EVAL      ZIEND = VDAT
     C                   ELSE
     C                   EVAL      ZIEND = REPCD
     C                   ENDIF
 
     C                   MOVE      IDCM          ZICALC
     C                   EVAL      ZIAMT = IDAM
     C                   EVAL      ZIRATE = IDIR
 
     C                   TESTB     '6'           DSTI                     35
 
     C                   IF        *IN35 = *ON
     C                   Z-SUB     ZIRATE        ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   IF        JDRDF = 'Y'
     C                   EVAL      AMAD = ZINTR
     C                   ELSE
     C                   EVAL(H)   AMAD = ZINTR
     C                   ENDIF
 
     C                   IF        REPCD < OTDT
     C                   EVAL      AMAD = *ZERO
     C                   ENDIF
 
     C                   EVAL      AMTA = IDIA - AMAD
     C                   Z-SUB     AMAD          AMAD
     C                   Z-SUB     AMTA          AMTA
     C                   EVAL      ICIR = IDIR
 
     C                   EVAL      *IN56 = *ON
     C                   EVAL      WDetTyp = 'E'
     C                   EXSR      SRAENO
     C                   EVAL      *IN56 = *OFF
 
      ** Output record for Internal Loan.
 
     C                   MOVE      ILCM          ZICALC
     C                   EVAL      ZIAMT = ILAM
     C                   EVAL      ZIRATE = ILIR
 
     C                   TESTB     '5'           DSTI                     35
 
     C                   IF        *IN35 = *ON
     C                   Z-SUB     ZIRATE        ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   IF        JLRDF = 'Y'
     C                   EVAL      AMAD = ZINTR
     C                   ELSE
     C                   EVAL(H)   AMAD = ZINTR
     C                   ENDIF
 
     C                   IF        REPCD < OTDT
     C                   EVAL      AMAD = *ZERO
     C                   ENDIF
 
     C                   EVAL      AMTA = ILIA - AMAD
     C                   EVAL      ICIR = ILIR
 
     C                   EVAL      WDetTyp = 'E'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of Internal Contract Extract
      ** Records written in INT,1 and DEC,1.
 
     C                   EVAL      RECRIT = RECRIT + 2
     C                   MOVE      IDAM          ZZAMT
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
     C                   MOVE      ILAM          ZZAMT
     C                   EXSR      SRHASH
 
     C                   EXSR      SRDETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSWPL - Swaps Processing.                                   *
      *                                                               *
      *****************************************************************
     C     SRSWPL        BEGSR
 
      ** Set indicator for swap.
 
     C                   EVAL      *IN47 = *ON
 
      ** Calculate 'Accrued to Date' and place it in AMAD.
 
     C                   EVAL      DAYS = REPCD - OTDT
     C                   EVAL      PERIOD = VDAT - OTDT
 
     C                   EVAL      PRODUC = SPLA * DAYS
     C                   EVAL(H)   AMAD = PRODUC / PERIOD
 
     C                   IF        REPCD < OTDT
     C                   EVAL      AMAD = *ZERO
     C                   ENDIF
 
     C                   EVAL      AMTA = SPLA - AMAD
 
     C                   EXSR      SREND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLD - Loans and Deposits Processing.                        *
      *                                                               *
      *****************************************************************
     C     SRLD          BEGSR
 
     C                   IF        FSLQPS = '+'
     C                   EVAL      INTR = INTR + FSLQPR
     C                   ENDIF
     C                   IF        FSLQPS = '-'
     C                   EVAL      INTR = INTR - FSLQPR
     C                   ENDIF
 
     C                   EVAL      *IN52 = *OFF
 
     C                   IF        RECI <> 'D'
     C                   EVAL      *IN52 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        RCDC <> 15 AND
     C                             RCDC <> 16
     C                   EVAL      *IN52 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if the Start/Last Interest Date was reached.
 
     C                   EVAL      *IN49 = *OFF
 
     C                   IF        SLID > *ZERO
 
     C                   IF        (BKALDI = 'Y' AND SLID > REPCD) OR
     C                             (BKALDI <> 'Y' AND SLID >= REPCD)
     C                   EVAL      AMAD = *ZERO
     C                   EVAL      *IN49 = *ON
     C                   EXSR      SRCITA
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Place 'Interest Calculated' in ZINTR.
 
      ** Except for Call/Notice Deals where MDAT = 0, if IACD is
      ** greater than or equal to Maturity Date, set ZINTR = 0.
 
     C                   IF        MDAT > *ZERO
 
     C                   IF        IACD >= MDAT
     C                   EVAL      ZINTR = *ZERO
     C                   EXSR      SRATID
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Maturity Date is less than Report Control Date, use
      ** Maturity Date as End Date.
 
     C                   IF        MDAT > *ZERO AND
     C                             MDAT < REPCD
     C                   EVAL      ZIEND = MDAT
     C                   ELSE
     C                   EVAL      ZIEND = REPCD
     C                   ENDIF
 
     C                   EVAL      ZIBEG = IACD
 
      ** Subtract one from ZIEND if we have a First Day Accrual and
      ** a Last Day Interest.
 
     C                   IF        BKALDI <> 'Y' AND
     C                             JFLID = 'Y'
     C                   EVAL      ZIEND = ZIEND - 1
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
     C                   EVAL      ZIAMT = PCPL
 
     C                   EVAL      ZIRATE = INTR
 
     C                   EXSR      SRGLINTC
 
      ** Accumulate the 'Total Interest to Date'.
 
     C                   EXSR      SRATID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRATID - Accumulates the 'Total Interest to Date'.           *
      *                                                               *
      *****************************************************************
     C     SRATID        BEGSR
 
      ** Accumulate 'Total Interest to Date' in TOTINT.
 
      ** If Round Down Interest Indicator <> 'Y', enable Half Adjust.
 
     C                   IF        JRDFC = 'Y'
     C                   EVAL      TOTINT = ZINTR + FSAITN
     C                   ELSE
     C                   EVAL(H)   TOTINT = ZINTR + FSAITN
     C                   ENDIF
 
     C                   EVAL      TOTINT = TOTINT + FSAINN + FSAIAN
 
     C                   EVAL      *IN70 = *ON
 
     C                   IF        NIDT > REPCD
     C                   EVAL      *IN70 = *OFF
     C                   IF        MDAT <= NIDT
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        NIDT = REPCD
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
 
     C                   EVAL      ZIBEG = IACD
 
     C                   IF        *IN70 = *ON
     C                   EVAL      ZIEND = MDAT
     C                   ELSE
     C                   EVAL      ZIEND = NIDT
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
     C                   EVAL      ZIAMT = PCPL
 
     C                   EVAL      ZIRATE = INTR
 
     C                   EXSR      SRGLINTC
 
      ** Accumulate 'Total Interest to Date' in QINT.
 
      ** If Round Down Interest Indicator <> 'Y', enable Half Adjust.
 
     C                   IF        JRDFC = 'Y'
     C                   EVAL      QINT = ZINTR + FSAITN
     C                   ELSE
     C                   EVAL(H)   QINT = ZINTR + FSAITN
     C                   ENDIF
 
     C                   EVAL      QINT = QINT + FSAINN + FSAIAN -
     C                             FSIPRN - FSICTN
 
      ** Place 'Interest Accrued to Date' in AMAD.
 
     C                   EVAL      AMAD = TOTINT - FSIPRN - FSICTN
 
      ** Negate QINT and AMAD if Record Code is equal to 16.
 
     C                   IF        RCDC = 16
     C                   Z-SUB     QINT          QINT
     C                   Z-SUB     AMAD          AMAD
     C                   ENDIF
 
      ** Calculate the 'Interest to Accrue'.
 
     C                   EXSR      SRCITA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCITA - Calculates the 'Interest to Accrue'.                *
      *                                                               *
      *****************************************************************
     C     SRCITA        BEGSR
 
      ** If Notice Days is not negative, there's no point in further
      ** processing.
 
     C                   IF        *IN21 = *OFF
     C                   EXSR      SRNNEG
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN70 = *ON
 
     C                   IF        NIDT > REPCD
     C                   EVAL      *IN70 = *OFF
     C                   IF        MDAT <= NIDT
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        NIDT = REPCD
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
 
      ** If Maturity Date is less than or equal to Report Control Date,
      ** set Interest to Accrue to zero.
 
     C                   IF        MDAT <= REPCD
     C                   EVAL      AMTA = *ZERO
     C                   EXSR      SRNNEG
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        *IN70 = *ON
     C                   EVAL      ZIEND = MDAT
     C                   ELSE
     C                   EVAL      ZIEND = NIDT
     C                   ENDIF
 
     C                   IF        *IN49 = *ON
     C                   EVAL      ZIBEG = SLID
     C                   ELSE
     C                   EVAL      ZIBEG = REPCD
     C                   ENDIF
 
      ** Subtract one from ZIBEG if we have a First and Last Day
      ** Interest.
 
     C                   IF        JFLID = 'Y'
 
     C                   IF        BKALDI <> 'Y' OR
     C                             (BKALDI = 'Y' AND
     C                             *IN49 = *ON)
     C                   EVAL      ZIBEG = ZIBEG - 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
     C                   EVAL      ZIAMT = PCPL
 
     C                   EVAL      ZIRATE = INTR
 
     C                   EXSR      SRGLINTC
 
      ** If Round Down Interest Indicator <> 'Y', enable Half Adjust.
 
     C                   IF        JRDFC = 'Y'
     C                   EVAL      AMTA = ZINTR
     C                   ELSE
     C                   EVAL(H)   AMTA = ZINTR
     C                   ENDIF
 
      ** Negate AMTA if Record Code is equal to 16.
 
     C                   IF        RCDC = 16
     C                   Z-SUB     AMTA          AMTA
     C                   ENDIF
 
     C                   IF        *IN49 = *ON
     C                   EXSR      SRNNEG
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      AMTA = QINT - AMAD
 
     C                   EXSR      SRNNEG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNNEG - Non-negative Notice Days Processing for SRCITA.     *
      *                                                               *
      *****************************************************************
     C     SRNNEG        BEGSR
 
     C                   IF        *IN21 = *OFF
     C                   EVAL      AMTA = *ZERO
     C                   ENDIF
 
     C                   EXSR      SREND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAP - Negotiable Assets Purchased Processing.              *
      *                                                               *
      *****************************************************************
     C     SRNAP         BEGSR
 
     C                   EVAL      *IN53 = *OFF
 
      ** Take out liquidity premium from the interest rate
 
     C                   IF        FSLQPS = '+'
     C                   EVAL      INTR = INTR + FSLQPR
     C                   ENDIF
     C                   IF        FSLQPS = '-'
     C                   EVAL      INTR = INTR - FSLQPR
     C                   ENDIF
 
     C                   IF        RECI <> 'D'
     C                   EVAL      *IN53 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        RCDC <> 17
     C                   EVAL      *IN53 = *ON
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        DTYP <> 'C1' AND
     C                             DTYP <> 'C2' AND
     C                             DTYP <> 'BD' AND
     C                             DTYP <> 'BP'
     C                   EVAL      *IN54 = *OFF
     C                   EXSR      SRNITB
     C                   LEAVESR
     C                   ELSE
     C                   EVAL      *IN54 = *ON
     C                   ENDIF
 
     C                   EVAL      *IN65 = *OFF
 
     C                   IF        IACD > SLID
     C                   EVAL      *IN65 = *ON
     C                   ENDIF
 
     C                   EVAL      ZIBEG = IACD
     C                   EVAL      ZIEND = REPCD
     C                   EVAL      TAMAD = *ZERO
 
      ** Check if the Value Date is reached.
 
     C                   IF        (BKALDI = 'Y' AND VDAT > REPCD) OR
     C                             (BKALDI <> 'Y' AND VDAT >= REPCD)
     C                   EVAL      AMAD = *ZERO
     C                   EXSR      SRSTOD
     C                   LEAVESR
     C                   ENDIF
 
      ** Use Maturity Date as End Date if it is less than the Report
      ** Control Date.
 
     C                   IF        MDAT < REPCD
     C                   EVAL      ZIEND = MDAT
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
 
     C                   IF        BNNAIA = 'Y'
     C                   EVAL      ZIAMT = FVAL
 
     C                   EVAL      ZIRATE = INTR
     C                   ELSE
     C                   EVAL      ZIAMT = PUPR
     C                   EVAL      ZIRATE = YRAT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
      ** If Round Down Interest Indicator = 'Y', enable Half Adjust.
 
     C                   IF        JRDFC = 'Y'
     C                   EVAL      AMAD = ZINTR
     C                   EVAL      TAMAD = ZINTR
     C                   ELSE
     C                   EVAL(H)   AMAD = ZINTR
     C                   EVAL(H)   TAMAD = ZINTR
     C                   ENDIF
 
      ** If Last Interest Date is later than Value Date, output Last
      ** Interest Date as 'Accrual From' Date.
 
     C                   EVAL      *IN71 = *OFF
 
     C                   IF        SLID > VDAT
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
 
      ** If IACD is >= to Maturity Date, set ZINTR = 0.
 
     C                   IF        IACD >= MDAT
     C                   EVAL      AMAD = FSAIAN + FSAINN
     C                   EXSR      SRSTOD
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if there has been an Interim Interest Date since the
      ** Accruals Control Date.
 
     C                   EVAL      *IN65 = *OFF
 
     C                   IF        IACD > SLID
     C                   EVAL      *IN65 = *ON
     C                   ENDIF
 
      ** Accumulate 'Total Interest to Date'.
 
     C                   EVAL      AMAD = AMAD + FSAINN + FSAIAN +
     C                             FSAITN - FSIPRN
 
      ** If FSIPRN is not equal to zero, consider FSPINN as FSIPRN.
 
     C                   IF        FSIPRN <> 0
     C                   EVAL      AMAD = AMAD + FSPINN
     C                   ENDIF
 
      ** Calculate interest to the earliest of MDAT, NIDT, and SADT
      ** which is greater than the Report Control Date.
 
     C                   EXSR      SRSTOD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSTOD - Calculates interest to the earliest of MDAT, NIDT,  *
      *           and SADT.                                           *
      *                                                               *
      *****************************************************************
     C     SRSTOD        BEGSR
 
     C                   IF        NIDT = *ZERO AND
     C                             SADT = *ZERO
     C                   EVAL      TODAT = MDAT
     C                   EXSR      SRINTC
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN70 = *OFF
 
     C                   IF        NIDT = *ZERO OR
     C                             NIDT < REPCD
 
     C                   EVAL      *IN70 = *ON
 
     C                   IF        MDAT <= SADT
     C                   EVAL      TODAT = MDAT
     C                   ELSE
 
     C                   IF        SADT > *ZERO
     C                   IF        SADT > REPCD
     C                   EVAL      TODAT = SADT
     C                   ELSE
     C                   EVAL      TODAT = MDAT
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SADT = *ZERO
     C                   EVAL      TODAT = MDAT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRINTC
     C                   LEAVESR
 
     C                   ENDIF
 
     C                   IF        SADT = *ZERO
 
     C                   IF        MDAT > NIDT
     C                   EVAL      TODAT = NIDT
     C                   ELSE
     C                   EVAL      TODAT = MDAT
     C                   ENDIF
 
     C                   EXSR      SRINTC
     C                   LEAVESR
 
     C                   ENDIF
 
     C                   IF        MDAT > NIDT
 
     C                   IF        NIDT > SADT
 
     C                   IF        SADT <= REPCD
     C                   EVAL      TODAT = NIDT
     C                   ENDIF
 
     C                   EVAL      TODAT = SADT
 
     C                   ELSE
     C                   EVAL      TODAT = NIDT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        MDAT > SADT
     C                   EVAL      TODAT = SADT
 
     C                   IF        SADT <= REPCD
     C                   EVAL      TODAT = MDAT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      TODAT = MDAT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRINTC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINTC - Handles interest calculations.                      *
      *                                                               *
      *****************************************************************
     C     SRINTC        BEGSR
 
     C                   MOVE      TODAT         ZIEND
 
      ** To eliminate the discrepancy in calculating the 'To Accrue'
      ** value, calculate first the Total Interest from AICD to TODAT,
      ** then subtract the interest from AICD to REPCD (TAMAD).
 
     C                   IF        BNNAIA = 'Y'
     C                   EVAL      ZIAMT = FVAL
     C                   EVAL      ZIRATE = INTR
     C                   ELSE
     C                   EVAL      ZIAMT = PUPR
     C                   EVAL      ZIRATE = YRAT
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
 
     C                   EXSR      SRGLINTC
 
      ** If Round Down Interest Indicator <> 'Y', enable Half Adjust.
 
     C                   IF        JRDFC = 'Y'
     C                   EVAL      AMTA = ZINTR
     C                   ELSE
     C                   EVAL(H)   AMTA = ZINTR
     C                   ENDIF
 
      ** (REPCD to TODAT) Int. = (IACD to TODAT) Int. - (IACD to REPCD)
      ** Int.
 
     C                   EVAL      AMTA = AMTA - TAMAD
 
      ** If TODAT is less than or equal to Report Control Date, set
      ** 'Interest to Accrue' to zero.
 
     C                   IF        TODAT <= REPCD
     C                   EVAL      AMTA = *ZERO
     C                   ENDIF
 
     C                   EVAL      *IN64 = *OFF
 
     C                   IF        DTYP = 'C1'
     C                   EVAL      *IN64 = *ON
     C                   EXSR      SREND
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        BNNAIA = 'Y'
     C                   EXSR      SRINBY
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SREND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNITB - Deal Type = TB, DA, or TA - Non-Interest Bearing    *
      *           Processsing.                                        *
      *                                                               *
      *****************************************************************
     C     SRNITB        BEGSR
 
     C                   IF        DTYP <> 'TB' AND
     C                             DTYP <> 'DA' AND
     C                             DTYP <> 'TA'
     C                   EVAL      *IN55 = *OFF
     C                   EXSR      SRDETAIL
     C                   LEAVESR
     C                   ELSE
     C                   EVAL      *IN55 = *ON
     C                   ENDIF
 
     C                   EXSR      SRINBY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINBY - Deal Type = C2, BD, or BP - Interest Bearing        *
      *           Processing (N. A. Accruals Indicator = 'Y').        *
      *                                                               *
      *****************************************************************
     C     SRINBY        BEGSR
 
     C                   EVAL      PERIOD = MDAT - VDAT
     C                   EVAL      DAYS = REPCD - VDAT
 
     C                   EVAL      *IN49 = *OFF
 
     C                   IF        DAYS < *ZERO
 
     C                   EVAL      *IN49 = *ON
 
     C                   IF        DTYP <> 'C1' AND
     C                             DTYP <> 'C2' AND
     C                             DTYP <> 'BD' AND
     C                             DTYP <> 'BP'
     C                   EVAL      AMAD = *ZERO
     C                   EVAL      AMTA = DISA
     C                   EXSR      SREND
     C                   LEAVESR
     C                   ELSE
 
     C                   IF        BNNAIA = 'Y'
     C                   EVAL      AMTAD = *ZERO
     C                   EVAL      AMTTA = DISA
     C                   EVAL      WDetTyp = 'E'
     C                   EXSR      SRAENO
     C                   EXSR      SREND
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PRODUC = DISA * DAYS
 
     C                   IF        DTYP <> 'C1' AND
     C                             DTYP <> 'C2' AND
     C                             DTYP <> 'BD' AND
     C                             DTYP <> 'BP'
     C                   EVAL(H)   AMAD = PRODUC / PERIOD
     C                   EVAL      AMTA = DISA - AMAD
     C                   ELSE
 
     C                   IF        BNNAIA = 'Y'
     C                   EVAL(H)   AMTAD = PRODUC / PERIOD
     C                   EVAL      AMTTA = DISA - AMTAD
     C                   EVAL      WDetTyp = 'E'
     C                   EXSR      SRAENO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SREND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFI - FRA/IRS Processing.                                   *
      *                                                               *
      *****************************************************************
     C     SRFI          BEGSR
 
     C                   IF        *IN07 = *ON AND
     C                             RECI = 'D'
 
     C                   IF        BOVD <> 0 AND
     C                             CIR001 = 'Y'
 
     C                   IF        BOVD < MDAT
     C                   EVAL      MDAT = BOVD
     C                   ENDIF
 
     C                   IF        BOVD < TNIPD
     C                   EVAL      TNIPD = BOVD
     C                   EVAL      TNICD = BOVD
     C                   ENDIF
 
     C                   IF        BOVD < UNIPD
     C                   EVAL      UNIPD = BOVD
     C                   EVAL      UNICD = BOVD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      OTUI = *ZERO
     C                   EVAL      TTUI = *ZERO
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      RCDC = 21
     C                   EXSR      SRFR
 
     C                   WHEN      RCDC = 22
     C                   EXSR      SRRS
 
     C                   WHEN      RCDC = 23
     C                   EXSR      SRRX
 
     C                   ENDSL
 
     C                   IF        RCDC = 24
     C                   TESTB     '3'           UDSTI                    33
     C                   IF        *IN33 = *OFF
     C                   EXSR      SRRLNA
     C                   ELSE
     C                   EXSR      SRRLAV
     C                   ENDIF
     C                   ENDIF
 
      ** Call IRS Fee Amortization Processing.
 
     C                   IF        CIR001 = 'Y'
     C                   IF        RCDC = 22 OR
     C                             RCDC = 23 OR
     C                             RCDC = 24
     C                   EXSR      SRFAMO
     C                   ENDIF
     C                   ENDIF
 
      ** Bypass extract records hash totalling as FRA/IRS extract
      ** records are hashed when written.
 
     C                   EXSR      SRDETAIL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - End Processing Subroutine.                           *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
 
      ** Accumulate the number and value of extract records written in
      ** INT,1 and DEC,1.
 
      ** If BNGEST='Y', use Face Value for 'C1' Hash Totalling.
 
     C                   IF        (*IN01 = *ON AND *IN51 = *OFF) OR
     C                             (*IN02 = *ON AND *IN52 = *OFF) OR
     C                             (*IN03 = *ON AND *IN53 = *OFF)
     C                   EVAL      RECRIT = RECRIT + 1
     C                   ENDIF
 
     C                   IF        *IN64 = *OFF AND *IN03 = *ON AND
     C                             *IN59 = *ON AND *IN54 = *ON
     C                   EVAL      RECRIT = RECRIT + 1
     C                   ENDIF
 
     C                   IF        *IN01 = *ON AND *IN51 = *OFF
     C                   MOVE      SPLA          ZZAMT
     C                   ENDIF
 
     C                   IF        *IN02 = *ON AND *IN52 = *OFF
     C                   MOVE      PCPL          ZZAMT
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   MOVE      PUPR          ZZAMT
     C                   ENDIF
 
     C                   IF        *IN03 = *ON AND
     C                             *IN59 = *ON AND
     C                             *IN64 = *ON
     C                   MOVE      FVAL          ZZAMT
     C                   ENDIF
 
     C                   EVAL      X = 1
 
     C                   IF        (*IN01 = *ON AND *IN51 = *OFF) OR
     C                             (*IN02 = *ON AND *IN52 = *OFF) OR
     C                             (*IN03 = *ON AND *IN53 = *OFF)
     C                   EXSR      SRHASH
     C                   ENDIF
 
      ** Accumulate the Additional Value (Face Value) of extract
      ** records. If N. A. Accruals Indicator = 'Y', then this only
      ** applies to (Live) C1 N. A. Purchased Interest Bearing Deals.
 
     C                   IF        *IN64 = *OFF AND
     C                             *IN03 = *ON  AND
     C                             *IN59 = *ON  AND
     C                             *IN54 = *ON
     C                   MOVE      FVAL          ZZAMT
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
     C                   ENDIF
 
     C                   EXSR      SRDETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETAIL - Detail Processing Subroutine.                     *
      *                                                               *
      *****************************************************************
     C     SRDETAIL      BEGSR
 
     C                   EVAL      WDetTyp = 'D'
     C                   EXSR      SRAENO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROBP - Out of Balance Processing Subroutine.                *
      *                                                               *
      *****************************************************************
     C     SROBP         BEGSR
 
     C                   EVAL      *IN80 = *OFF
 
     C                   IF        INT(2) <> VLAF OR
     C                             DEC(2) <> VLAL OR
     C                             RECRED <> NLRA
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   EVAL      RECRIT = RECRIT + 2
 
      ** Output Trailer Record.
 
     C                   EXSR      SRAENP
 
      ** Output Audit Report.
 
     C                   EXSR      SRAURPT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHASH - Hashes the values accumulated in the INT and DEC    *
      *           arrays.                                             *
      *                                                               *
      *****************************************************************
     C     SRHASH        BEGSR
 
     C                   EVAL      ZZTOTI = INT(X)
     C                   EVAL      ZZTOTD = DEC(X)
 
      ** For deals, the file counter takes the real value of the
      ** amount.
 
     C                   IF        X = 1
     C                   IF        ZZAMT < *ZERO
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRGLZADD
 
     C                   EVAL      INT(X) = ZZTOTI
     C                   EVAL      DEC(X) = ZZTOTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZSAVE - Saves the current state of Indicators 90 to 97.    *
      *                                                               *
      *****************************************************************
     C     SRZSAVE       BEGSR
 
     C                   BITOFF    '01234567'    ZBITS             1
 
     C                   IF        *IN90 = *ON
     C                   BITON     '0'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN91 = *ON
     C                   BITON     '1'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN92 = *ON
     C                   BITON     '2'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN93 = *ON
     C                   BITON     '3'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN94 = *ON
     C                   BITON     '4'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN95 = *ON
     C                   BITON     '5'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN96 = *ON
     C                   BITON     '6'           ZBITS
     C                   ENDIF
 
     C                   IF        *IN97 = *ON
     C                   BITON     '7'           ZBITS
     C                   ENDIF
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZRSTOR - Restores the state of Indicators 90 to 97 by      *
      *             using the backup information saved by subroutine  *
      *             SRZSAVE.                                          *
      *                                                               *
      *****************************************************************
     C     SRZRSTOR      BEGSR
 
     C                   TESTB     '0'           ZBITS                    90
     C                   TESTB     '1'           ZBITS                    91
     C                   TESTB     '2'           ZBITS                    92
     C                   TESTB     '3'           ZBITS                    93
     C                   TESTB     '4'           ZBITS                    94
     C                   TESTB     '5'           ZBITS                    95
     C                   TESTB     '6'           ZBITS                    96
     C                   TESTB     '7'           ZBITS                    97
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZADD - Adds the running amount to the total amount.      *
      *                                                               *
      *****************************************************************
     C     SRGLZADD      BEGSR
 
     C                   IF        ZZAMT = *ZERO
     C                   LEAVESR
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields.
 
     C                   EVAL      ZZAMTI = ZZAMT
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD now contain a 'sign' zone.
 
     C                   EXSR      SRGLZSUM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZSUM - Handles the addition for subroutines SRGLZADD,    *
      *             SRGLZSUB, SRGLZCMP.                               *
      *                                                               *
      *****************************************************************
     C     SRGLZSUM      BEGSR
 
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZZAMTI = *ZERO AND
     C                             ZZAMTD = *ZERO
     C                   EXSR      SRZSEND
     C                   LEAVESR
     C                   ENDIF
 
      ** Determine the sign of ZZAMTI & ZZAMTD.
 
     C                   IF        ZZAMTI < *ZERO OR
     C                             ZZAMTD < *ZERO
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
      ** Determine the sign of ZZTOTI and ZZTOTD.
 
     C                   IF        ZZTOTI = *ZERO AND
     C                             ZZTOTD = *ZERO
     C                   EVAL      ZZTOTI = ZZAMTI
     C                   EVAL      ZZTOTD = ZZAMTD
     C                   EXSR      SRZSEND
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        ZZTOTI < *ZERO OR
     C                             ZZTOTD < *ZERO
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
      ** If the signs differ, bypass overflow checks.
 
     C                   IF        *IN91 <> *IN92
     C                   EXSR      SRZOFPS
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      ZZWK2 = ZZAMTD + ZZTOTD
 
     C                   IF        ZZWK2 > 999 OR
     C                             ZZWK2 < -999
 
     C                   IF        *IN92 = *ON
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZAMTI + 1
     C                   ENDIF
 
     C                   EVAL      ZZWK3 = ZZWK3 + ZZTOTI
 
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZTOTI + ZZAMTI
     C                   ENDIF
 
      ** If mod. ZZWK3 is < mod. ZZTOTI, then overflow has occurred.
 
     C                   IF        (*IN92 = *ON AND ZZWK3 > ZZTOTI) OR
     C                             (*IN92 = *OFF AND ZZWK3 < ZZTOTI)
     C                   EVAL      ZZAMT = *ZERO
     C                   EVAL      *IN99 = *ON
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
 
     C                   EXSR      SRZSEND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZOFPS - Bypass overflow processing for SR/SRGLZSUM.        *
      *                                                               *
      *****************************************************************
     C     SRZOFPS       BEGSR
 
      ** If ZZAMT was neg., make it pos. for comparison with ZZTOT.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was neg., make it pos. for comparison with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZTOT = ZZAMT, return zero.
 
     C                   IF        ZZTOTI = ZZAMTI AND
     C                             ZZTOTD = ZZAMTD
     C                   EVAL      ZZTOTI = *ZERO
     C                   EVAL      ZZTOTD = *ZERO
     C                   EXSR      SRZSEND
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN93 = *OFF
 
     C                   IF        ZZTOTI > ZZAMTI OR
     C                             ZZTOTD > ZZAMTD
 
     C                   EVAL      *IN93 = *ON
 
     C                   IF        ZZAMTD > ZZTOTD
     C                   EVAL      ZZTOTI = ZZTOTI - 1
     C                   EVAL      ZZWK2 = ZZTOTD + 1000
     C                   EVAL      ZZTOTD = ZZWK2 - ZZAMTD
     C                   ELSE
     C                   EVAL      ZZTOTD = ZZTOTD - ZZAMTD
     C                   ENDIF
 
     C                   EVAL      ZZTOTI = ZZTOTI - ZZAMTI
 
     C                   ELSE
 
     C                   IF        ZZTOTD > ZZAMTD
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   EVAL      ZZWK2 = ZZAMTD + 1000
     C                   EVAL      ZZTOTI = ZZWK3 - ZZTOTI
     C                   EVAL      ZZTOTD = ZZWK2 - ZZTOTD
     C                   ELSE
     C                   EVAL      ZZTOTI = ZZAMTI - ZZTOTI
     C                   EVAL      ZZTOTD = ZZAMTD - ZZTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse the sign of ZZTOT if the larger I/P fields were neg.
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        (*IN93 = *ON AND *IN91 = *ON) OR
     C                             (*IN93 = *OFF AND *IN92 = *ON)
     C                   EVAL      *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore the sign of ZZAMTI & ZZAMTD if it was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C                   EXSR      SRZSEND
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZSEND - End processing for SR/SRGLZSUM.                    *
      *                                                               *
      *****************************************************************
     C     SRZSEND       BEGSR
 
      ** If ZZTOTD = zero and ZZTOTI is neg., set ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN91 = *OFF
 
     C                   IF        ZZTOTD = *ZERO AND
     C                             ZZTOTI < *ZERO
     C                   EVAL      ZZNEGD = '.000-'
     C                   EVAL      *IN96 = *ON
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFR - Forward Rate Agreement Processing.                    *
      *                                                               *
      *****************************************************************
     C     SRFR          BEGSR
 
      ** Extract Hedged Deals only.
 
     C                   IF        HEDIN = 'Y'
 
      ** Clear/set fields for processing and output.
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      WAMAD = *ZERO
     C                   EVAL      WAMTA = *ZERO
 
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   Z-ADD     FSUPAM        SZPPL                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   Z-ADD     UPAMT         SZPPL
     C                   ENDIF                                                                CAS006
     C                   Z-ADD     VDAT          SZVDAT
     C                   Z-ADD     VDAT          SZSDAT
     C                   Z-ADD     MDAT          SZMDAT
     C                   Z-ADD     MDAT          SZEDAT
     C                   Z-ADD     UICBS         SZICB
 
     C                   IF        UBRTT <> *ZERO
     C                   EVAL      SZFLT = UEINR
     C                   EVAL      SZFIX = TEINR
     C                   TESTB     '1'           UDSTI                    31
 
     C                   IF        *IN31 = *ON
     C                   Z-SUB     UEINR         SZFLT
     C                   Z-SUB     TEINR         SZFIX
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     TEINR         SZFLT
     C                   Z-ADD     UEINR         SZFIX
     C                   TESTB     '1'           TDSTI                    31
 
     C                   IF        *IN31 = *ON
     C                   Z-SUB     TEINR         SZFLT
     C                   Z-SUB     UEINR         SZFIX
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   IF        FSUPRB <> 0                                                CAS006
     C                   EVAL      FSIPRN = FSUPRB                                            CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      FSIPRN = FSTPRB                                            CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        UIPRD <> 0
     C                   EVAL      IPRD = UIPRD
     C                   ELSE
     C                   EVAL      IPRD = TIPRD
     C                   ENDIF
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
     C                   MOVE      UCUCY         CCY
     C                   Z-ADD     VDAT          ACFD
     C                   Z-ADD     MDAT          ACTD
     C                   Z-ADD     UEINR         INTR
     C                   Z-ADD     0             AMAD
     C                   Z-ADD     0             AMTA
 
     C                   IF        UBRTT <> *ZERO
     C                   TESTB     '0'           UDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           URTPI
     C                   ELSE
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
 
     C                   TESTB     '0'           TDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
     C                   MOVE      'N'           TRTPI
     C                   ENDIF
 
     C                   MOVE      'Y'           URTPI
     C                   ENDIF
 
     C                   Z-ADD     VDAT          TACFD
     C                   Z-ADD     MDAT          TACTD
     C                   Z-ADD     0             TAMAD
     C                   Z-ADD     0             TAMTA
     C                   MOVE      'N'           FLRIND
 
      ** Extract Criteria Difference for First/Last Day Accrual.
 
     C                   IF        BKALDI = 'Y'
 
     C                   IF        VDAT > REPCD
 
      ** At this point, the deal hasn't been settled (i.e. hasn't
      ** started accruing) so the Amount to Accrue is equal to the
      ** calculated Discounted Settlement Amount.
 
      ** Calculations are possible only if the Floating Rate is set.
 
     C                   IF        URTPI = 'Y' AND
     C                             TRTPI = 'Y'
 
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   IF        UEINR >= TEINR                                             CAS006
     C                   EVAL      SZIANP = FSUINB - FSTINB                                   CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      SZIANP = FSTINB - FSUINB                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        UEINR >= TEINR
     C                   EVAL      SZIANP = UAIAN - TAIAN
     C                   ELSE
     C                   EVAL      SZIANP = TAIAN - UAIAN
     C                   ENDIF
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
     C                   EXSR      SRDLRADS
     C                   EVAL      WAMTA = SZDSA
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        MDAT > REPCD
 
      ** If the deal has been settled, calculate the Amount Accrued to
      ** Date and To Accrue.
 
     C                   EVAL      PERIOD = MDAT - VDAT
 
     C                   IF        PERIOD > *ZERO
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL(H)   DLYACC = FSIPRN / PERIOD                                   CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL(H)   DLYACC = IPRD / PERIOD
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE
     C                   EVAL      DLYACC = *ZERO
     C                   ENDIF
 
     C                   EVAL      DAYS = REPCD - VDAT
     C                   EVAL(H)   WAMAD = DLYACC * DAYS
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      WAMTA = FSIPRN - WAMAD                                     CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WAMTA = IPRD - WAMAD
     C                   ENDIF                                                                CAS006
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        BKALDI <> 'Y'
 
     C                   IF        VDAT >= REPCD
 
      ** At this point, the deal hasn't been settled (i.e. hasn't
      ** started accruing) so the Amount to Accrue is equal to the
      ** calculated Discounted Settlement Amount.
 
      ** Calculations are possible only if the Floating Rate is set.
 
     C                   IF        URTPI = 'Y' AND
     C                             TRTPI = 'Y'
     C                   EXSR      SRDLRADS
     C                   EVAL      WAMTA = SZDSA
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        MDAT >= REPCD
 
      ** If the deal has been settled, calculate the Amount Accrued to
      ** Date and To Accrue.
 
     C     MDAT          SUB       VDAT          PERIOD
 
     C     PERIOD        IFGT      0
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C     FSIPRN        DIV(H)    PERIOD        DLYACC                                       CAS006
     C                   ELSE                                                                 CAS006
     C     IPRD          DIV(H)    PERIOD        DLYACC
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE
     C                   Z-ADD     0             DLYACC
     C                   ENDIF
 
     C     REPCD         SUB       VDAT          DAYS
     C     DLYACC        MULT(H)   DAYS          WAMAD
 
     C                   IF        CAS006 = 'Y'                                               CAS006
     C     FSIPRN        SUB       WAMAD         WAMTA                                        CAS006
     C                   ELSE                                                                 CAS006
     C     IPRD          SUB       WAMAD         WAMTA
     C                   ENDIF                                                                CAS006
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Put Accrual Amounts in the appropriate details field (reverse
      ** amounts if the amount is being paid).
 
     C     UBRTT         IFNE      0
     C     SZFLT         IFGE      SZFIX
     C                   Z-SUB     WAMAD         AMAD
     C                   Z-SUB     WAMTA         AMTA
     C                   ELSE
     C                   Z-ADD     WAMAD         TAMAD
     C                   Z-ADD     WAMTA         TAMTA
     C                   ENDIF
     C                   ENDIF
 
     C     TBRTT         IFNE      0
     C     SZFLT         IFGT      SZFIX
     C                   Z-ADD     WAMAD         TAMAD
     C                   Z-ADD     WAMTA         TAMTA
     C                   ELSE
     C                   Z-SUB     WAMAD         AMAD
     C                   Z-SUB     WAMTA         AMTA
     C                   ENDIF
     C                   ENDIF
 
      ** Output a PF/ACCEXNO record.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   EVAL      RECRIT = RECRIT + 1
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVE      FSUPAM        ZZAMT                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      UPAMT         ZZAMT
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRS - Single Currency Interest Rate Swap Processing.        *
      *                                                               *
      *****************************************************************
     C     SRRS          BEGSR
 
      ** Clear/set fields for processing and output.
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      CCY = UCUCY
     C                   EVAL      ACFD = USLIP
 
      ** Get effective interest rate from base-rate-adjusted field
 
     C                   EVAL      UEINR = FSUEFR
 
     C                   EVAL      INTR = UEINR
     C                   EVAL      ACTD = *ZERO
     C                   EVAL      NOTD = *ZERO
     C                   EVAL      AMAD = *ZERO
     C                   EVAL      AMTA = *ZERO
 
     C                   IF        UBRTT <> 0
     C                   TESTB     '0'           UDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           URTPI
     C                   ELSE
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'Y'           URTPI
     C                   ENDIF
 
     C                   IF        TBRTT <> 0
     C                   TESTB     '0'           TDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
     C                   MOVE      'N'           TRTPI
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'Y'           TRTPI
     C                   ENDIF
 
      ** This code will force the calculation of "Interest Accrued to
      ** Date" and "Interest to Accrue".
 
     C                   IF        UICFR = 'O'
     C                   EVAL      URTPI = 'Y'
     C                   ENDIF
 
     C                   IF        TICFR = 'O'
     C                   EVAL      TRTPI = 'Y'
     C                   ENDIF
 
     C                   Z-ADD     TSLIP         TACFD
     C                   Z-ADD     0             TACTD
     C                   Z-ADD     0             TAMAD
     C                   Z-ADD     0             TAMTA
     C                   MOVE      'N'           FLRIND
 
      ** Set Accrual to Date to the earliest date present.
 
     C     UNIPD         IFNE      0
     C                   Z-ADD     UNIPD         ACTD
     C                   ELSE
     C     UNICD         IFNE      0
     C                   Z-ADD     UNICD         ACTD
     C                   ELSE
     C                   Z-ADD     MDAT          ACTD
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C                   IF        CIR005 = 'Y' AND L1AMCN = 'A '
     C                   IF        CIR001 = 'N' OR
     C                             (CIR001 = 'Y' AND UIPFR <> 'Z')
     C                   IF        UIPBD <> 0
     C                   EVAL      ACTD = UIPBD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        UNICD <> 0 AND
     C                             UNICD < ACTD
     C                   EVAL      ACTD = UNICD
     C                   ENDIF
 
      ** Select Our Details for accrual only if the rate is present.
 
     C                   IF        URTPI = 'Y'
 
      ** Set details to calculate Interest Accrued to Date.
 
     C                   EVAL      ZIBEG = UIACD
 
     C                   IF        ACTD <= REPCD
     C                   EVAL      ZIEND = ACTD
     C                   ELSE
     C                   EVAL      ZIEND = REPCD
     C                   ENDIF
 
     C                   EVAL      ZICALC = UICBS
     C                   EVAL      ZIAMT = FSUPAM
     C                   EVAL      ZIRATE = UEINR
     C                   EVAL      ZINTR = *ZERO
 
      ** If interest is Up-Front, use SR/SRUFACC to calculate accruals.
 
     C                   IF        (UINPM = 'Y' AND CIR001 = 'Y') OR
     C                             (UINPM = 'D' AND CIR001 = 'Y')
 
     C                   Z-ADD     FSUPRB        SZIPRD
     C                   Z-ADD     FSUINB        SZAIAN
     C                   Z-ADD     FSUIAB        SZAIAP
     C                   Z-ADD     FSUITB        SZAITC
     C                   Z-ADD     USLIP         SZSLID
     C                   Z-ADD     ACTD          SZACTD
     C                   MOVE      UINPM         SZINPM
 
     C                   EXSR      SRUFACC
 
     C                   Z-ADD     SZAMAD        AMAD
     C                   Z-ADD     SZAMTA        AMTA
 
     C                   ELSE
 
      ** Calculate Interest Accrued to Date if the deal has started
      ** accruing.
 
      ** If this is a Cash Flow Swap, obtain the Cash Flow Schedule.
 
     C                   IF        UIPFR = 'C' AND
     C                             CIR001 = 'Y'
 
     C                   EVAL      OTIN = 'U'
     C                   EVAL      PRDT = ACTD
 
     C     KCFSC         CHAIN     DLCFSCPD
 
     C                   IF        NOT %FOUND(DLCFSCPD)
     C                   EVAL      CFLA = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        USLIP <= REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C                   IF        UIPFR = 'C' AND
     C                             CIR001 = 'Y'
     C                   EVAL      SZSLID = USLIP
     C                   EVAL      SZACTD = ACTD
     C                   EXSR      SRCFACC
     C                   EVAL      ZINTR = WKINT
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing
      ** also for Our Interest Processing Methods 'A', 'I',
      ** or 'L' when CIR006 is installed.
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND UINPM = 'A') OR
     C                             (CIR006 = 'Y' AND UINPM = 'I') OR
     C                             (CIR006 = 'Y' AND UINPM = 'L')
     C                   EVAL      ZIAMT = ZIAMT + OUSI + OUSA
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      ZIEND = USLIP
 
     C                   ENDIF
 
     C                   EVAL      WINTR = ZINTR
     C                   EVAL(H)   AMAD = ZINTR + FSUINB
     C                   EVAL      AMAD = AMAD + FSUIAB + FSUITB - FSUPRB
 
      ** If our side of the deal is an OIS (UICFR = 'O'), call DL1651
      ** to calculate the Interest Accrued to Date.
 
     C                   IF        UICFR = 'O'
 
      ** Check the Rate Fix Day Adjustment.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      UCUCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 107
     C                   EVAL      DBKey = PCcy
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Add 1 to ZIBEG to give the correct number of days.
 
     C                   EVAL      PFRDT = ZIBEG + 1
 
     C                   CALL      'DL1651'
     C                   PARM      DLNO          PDLNO
     C                   PARM      'O'           POTCD
     C                   PARM                    PFRDT
     C                   PARM      ZIEND         PTODT
     C                   PARM                    PINTAM
     C                   PARM                    PRTNC
     C                   PARM      *BLANK        PTOAC
 
     C                   IF        PRTNC <> *BLANKS
     C                   EVAL      DBFile = 'DL1651'
     C                   MOVEL     PDLNO         DBKey
     C                   EVAL      DBase = 108
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Add Accrued Interest Adjusted Not Posted and Accrued Interest
      ** Adjusted and Posted.
 
     C                   EVAL      WINTR = PINTAM
     C                   EVAL      PINTAM = PINTAM + FSUINB + FSUIAB
     C                   EVAL      AMAD = PINTAM
 
      ** If A6FXDY is not equal to zero, update ZIEND with 'To Date'
      ** field from DL1651.
 
     C                   IF        A6FXDY <> 0
     C                   EVAL      ZIEND = PTODT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   EVAL      ZIEND = ACTD
     C                   EVAL      ZINTR = *ZERO
 
     C                   IF        ACTD >= REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C                   IF        UIPFR = 'C' AND
     C                             CIR001 = 'Y'
 
     C                   EVAL      ZIBEG = USLIP
     C                   EVAL      ZIEND = REPCD
 
     C                   IF        USLIP > REPCD
     C                   EVAL      ZIEND = USLIP
     C                   ENDIF
 
     C                   Z-ADD     USLIP         SZSLID
     C                   Z-ADD     ACTD          SZACTD
     C                   EXSR      SRCFACC
     C     CFLA          SUB       WKINT         AMTA
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      ZIAMT = FSUPAM
     C                   ENDIF
 
      ** Add the Unsettled Interest and the Unsettled Interest
      ** Adjustment to the Principal Amount if CIR002 is enabled.
      ** Do this processing also for Our Processing Method 'A', 'I',
      ** or 'L' when CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND UINPM = 'A') OR
     C                             (CIR006 = 'Y' AND UINPM = 'I') OR
     C                             (CIR006 = 'Y' AND UINPM = 'L')
     C                   EVAL      ZIAMT = ZIAMT + OUSI + OUSA
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   EVAL(H)   AMTA = ZINTR - WINTR
 
      ** If Our side of the deal is an OIS (UICFR = 'O'), call DL1956
      ** to calculate the Interest to Accrue.
 
     C                   IF        UICFR = 'O'
 
      ** Add 1 to ZIBEG to give the correct number of days.
 
     C                   EVAL      PFRDT = ZIBEG + 1
 
     C                   CALL      'DL1651'
     C                   PARM      DLNO          PDLNO
     C                   PARM      'O'           POTCD
     C                   PARM                    PFRDT
     C                   PARM      ZIEND         PTODT
     C                   PARM                    PINTAM
     C                   PARM                    PRTNC
     C                   PARM      'Y'           PTOAC
 
     C                   IF        PRTNC <> *BLANKS
     C                   EVAL      DBFile = 'DL1651'
     C                   MOVEL     PDLNO         DBKey
     C                   EVAL      DBase = 109
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL(H)   AMTA = PINTAM - WINTR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse Accrual Amounts as being paid.
 
     C                   Z-SUB     AMAD          AMAD
     C                   Z-SUB     AMTA          AMTA
 
     C                   ENDIF
 
      ** Set Accrual to Date to the earliest date present.
 
     C                   IF        TNIPD <> 0
     C                   EVAL      TACTD = TNIPD
     C                   ELSE
     C                   IF        TNICD <> 0
     C                   EVAL      TACTD = TNICD
     C                   ELSE
     C                   EVAL      TACTD = MDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C                   IF        CIR005 = 'Y' AND L1AMCN = 'A '
     C                   IF        CIR001 = 'N' OR
     C                             (CIR001 = 'Y' AND TIPFR <> 'Z')
     C                   IF        TIPBD <> 0
     C                   EVAL      TACTD = TIPBD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TNICD <> 0 AND
     C                             TNICD < TACTD
     C                   EVAL      TACTD = TNICD
     C                   ENDIF
 
      ** Select their details for accrual only if the rate is present.
 
     C                   IF        TRTPI = 'Y'
 
      ** Set details to calculate Interest Accrued to Date.
 
     C                   EVAL      ZIBEG = TIACD
 
     C                   IF        TACTD <= REPCD
     C                   EVAL      ZIEND = TACTD
     C                   ELSE
     C                   EVAL      ZIEND = REPCD
     C                   ENDIF
 
     C                   EVAL      ZICALC = TICBS
     C                   EVAL      ZIAMT = FSTPAM
 
      ** Get effective interest rate from base-rate-adjusted field
 
     C                   EVAL      TEINR = FSTEFR
 
     C                   EVAL      ZIRATE = TEINR
     C                   EVAL      ZINTR = *ZERO
 
      ** If interest is Up-Front, use SR/SRUFACC to calculate accruals.
 
     C                   IF        (TINPM = 'Y' AND CIR001 = 'Y') OR
     C                             (TINPM = 'D' AND CIR001 = 'Y')
 
     C                   Z-ADD     FSTPRB        SZIPRD
     C                   Z-ADD     FSTINB        SZAIAN
     C                   Z-ADD     FSTIAB        SZAIAP
     C                   Z-ADD     FSTITB        SZAITC
     C                   Z-ADD     TSLIP         SZSLID
     C                   Z-ADD     TACTD         SZACTD
     C                   MOVE      TINPM         SZINPM
 
     C                   EXSR      SRUFACC
 
     C                   Z-ADD     SZAMAD        TAMAD
     C                   Z-ADD     SZAMTA        TAMTA
     C                   ELSE
 
      ** Calculate Interest Accrued to Date if the deal has started
      ** accruing.
 
      ** If this is a Cash Flow Swap, obtain the Cash Flow Schedule.
 
     C                   IF        TIPFR = 'C' AND
     C                             CIR001 = 'Y'
     C                   EVAL      OTIN = 'T'
     C                   EVAL      PRDT = TACTD
 
     C     KCFSC         CHAIN     DLCFSCPD
 
     C                   IF        NOT %FOUND(DLCFSCPD)
     C                   EVAL      CFLA = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        TSLIP <= REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the cash flow accrual. Otherwise, use SR/SRGLINTC.
 
     C                   IF        TIPFR = 'C' AND
     C                             CIR001 = 'Y'
     C                   EVAL      SZSLID = TSLIP
     C                   EVAL      SZACTD = TACTD
     C                   EXSR      SRCFACC
     C                   EVAL      ZINTR = WKINT
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Processing Methods 'A', 'I', or 'L' when CIR006 is
      ** enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND TINPM = 'A') OR
     C                             (CIR006 = 'Y' AND TINPM = 'I') OR
     C                             (CIR006 = 'Y' AND TINPM = 'L')
     C                   EVAL      ZIAMT = ZIAMT + TUSI + TUSA
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      ZIEND = TSLIP
     C                   ENDIF
 
     C                   EVAL      WINTR = ZINTR
     C                   EVAL(H)   TAMAD = ZINTR + FSTINB
     C                   EVAL      TAMAD = TAMAD + FSTIAB + FSTITB -
     C                             FSTPRB
 
      ** If their side of the deal is an OIS (TICFR = 'O'), call
      ** DL1651 to calculate the Interest Accrued to Date.
 
     C                   IF        TICFR = 'O'
 
      ** Check the Rate Fix Day Adjustment.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TCUCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 110
     C                   EVAL      DBKey = PCcy
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Add 1 to ZIBEG to give the correct number of days.
 
     C                   EVAL      PFRDT = ZIBEG + 1
 
     C                   CALL      'DL1651'
     C                   PARM      DLNO          PDLNO
     C                   PARM      'T'           POTCD
     C                   PARM                    PFRDT
     C                   PARM      ZIEND         PTODT
     C                   PARM                    PINTAM
     C                   PARM                    PRTNC
     C                   PARM      *BLANK        PTOAC
 
     C                   IF        PRTNC <> *BLANKS
     C                   EVAL      DBFile = 'DL1651'
     C                   MOVEL     PDLNO         DBKey
     C                   EVAL      DBase = 111
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Add Accrued Interest Adjusted Not Posted and Accrued Interest
      ** Adjusted and Posted.
 
     C                   EVAL      WINTR = PINTAM
     C                   EVAL      PINTAM = PINTAM + FSTINB + FSTIAB
     C                   EVAL      TAMAD = PINTAM
 
      ** If A6FXDY is not equal to 0, update ZIEND with 'To Date'
      ** field from DL1651.
 
     C                   IF        A6FXDY <> 0
     C                   EVAL      ZIEND = PTODT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   EVAL      ZIEND = TACTD
     C                   EVAL      ZINTR = *ZERO
 
     C                   IF        TACTD >= REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C                   IF        TIPFR = 'C' AND
     C                             CIR001 = 'Y'
 
     C                   EVAL      ZIBEG = TSLIP
     C                   EVAL      ZIEND = REPCD
 
     C                   IF        TSLIP > REPCD
     C                   EVAL      ZIEND = TSLIP
     C                   ENDIF
 
     C                   EVAL      SZSLID = TSLIP
     C                   EVAL      SZACTD = TACTD
     C                   EXSR      SRCFACC
     C                   EVAL      TAMTA = CFLA - WKINT
 
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      ZIAMT = FSTPAM
     C                   ENDIF
 
      ** Set ZIAMT to Principal Amount + Unsettled Interest +
      ** Unsettled Interest Adjustment. Do this processing also for
      ** Their Processing Methods 'A', 'I', or 'L' when CIR006 is
      ** enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND TINPM = 'A') OR
     C                             (CIR006 = 'Y' AND TINPM = 'I') OR
     C                             (CIR006 = 'Y' AND TINPM = 'L')
     C                   EVAL      ZIAMT = ZIAMT + TUSI + TUSA
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   EVAL(H)   TAMTA = ZINTR - WINTR
 
      ** If their side of the deal is an OIS (TICFR = 'O'), call DL1956
      ** to calculate the Interest to Accrue.
 
     C                   IF        TICFR = 'O'
 
      ** Add 1 to ZIBEG to give the correct number of days.
 
     C                   EVAL      PFRDT = ZIBEG + 1
 
     C                   CALL      'DL1651'
     C                   PARM      DLNO          PDLNO
     C                   PARM      'T'           POTCD
     C                   PARM                    PFRDT
     C                   PARM      ZIEND         PTODT
     C                   PARM                    PINTAM
     C                   PARM                    PRTNC
     C                   PARM      'Y'           PTOAC
 
     C                   IF        PRTNC <> *BLANKS
     C                   EVAL      DBFile = 'DL1651'
     C                   MOVEL     PDLNO         DBKey
     C                   EVAL      DBase = 112
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL(H)   TAMTA = PINTAM
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set Our Total Unsettled Interest and Their Total Unsettled
      ** Interest. Do this processing also for Our/Their Interest
      ** Processing Method 'A', 'I', or 'L' when CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
 
     C                   EVAL      OTUI = *ZERO
     C                   EVAL      TTUI = *ZERO
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND UINPM = 'A') OR
     C                             (CIR006 = 'Y' AND UINPM = 'I') OR
     C                             (CIR006 = 'Y' AND UINPM = 'L')
     C                   EVAL      OTUI = OUSI + OUSA
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND TINPM = 'A') OR
     C                             (CIR006 = 'Y' AND TINPM = 'I') OR
     C                             (CIR006 = 'Y' AND TINPM = 'L')
     C                   EVAL      TTUI = TUSI + TUSA
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output a PF/ACCEXNO record.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   EVAL      RECRIT = RECRIT + 1
     C                   MOVE      FSUPAM        ZZAMT
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRX - Cross Currency Interest Rate Swap Processing.         *
      *                                                               *
      *****************************************************************
     C     SRRX          BEGSR
 
      ** Clear/set fields for processing and output.
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      CCY = UCUCY
     C                   EVAL      ACFD = USLIP
     C                   EVAL      ACTD = *ZERO
     C                   EVAL      NOTD = *ZERO
 
      ** Get effective interest rate from base-rate-adjusted field
 
     C                   EVAL      UEINR = FSUEFR
 
     C                   EVAL      INTR = UEINR
     C                   EVAL      AMAD = *ZERO
     C                   EVAL      AMTA = *ZERO
 
     C                   IF        UBRTT <> *ZERO
 
     C                   TESTB     '0'           UDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   EVAL      URTPI = 'Y'
     C                   ELSE
     C                   EVAL      URTPI = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      URTPI = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      TRTPI = 'N'
     C                   EVAL      TACFD = *ZERO
     C                   EVAL      TACTD = *ZERO
     C                   EVAL      TAMAD = *ZERO
     C                   EVAL      TAMTA = *ZERO
     C                   EVAL      FLRIND = 'N'
 
     C                   EVAL      SVBRTT = TBRTT
 
      ** Get effective interest rate from base-rate-adjusted field
 
     C                   EVAL      TEINR = FSTEFR
 
     C                   EVAL      SVEINR = TEINR
     C                   EVAL      TBRTT = *ZERO
     C                   EVAL      TEINR = *ZERO
 
      ** Set Accrual to Date to earliest date present.
 
     C                   IF        UNIPD <> *ZERO
     C                   EVAL      ACTD = UNIPD
     C                   ELSE
     C                   IF        UNICD <> *ZERO
     C                   EVAL      ACTD = UNICD
     C                   ELSE
     C                   EVAL      ACTD = MDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C                   IF        CIR005 = 'Y' AND L1AMCN = 'A '
     C                   IF        CIR001 = 'N' OR
     C                             (CIR001 = 'Y' AND UIPFR <> 'Z')
     C                   IF        UIPBD <> 0
     C                   EVAL      ACTD = UIPBD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        UNICD <> *ZERO AND
     C                             UNICD < ACTD
     C                   EVAL      ACTD = UNICD
     C                   ENDIF
 
      ** Select our details for accrual only if the rate is present.
 
     C                   IF        URTPI = 'Y'
 
      ** Set details to calculate Interest Accrued to Date.
 
     C                   EVAL      ZIBEG = UIACD
 
     C                   IF        ACTD <= REPCD
     C                   EVAL      ZIEND = ACTD
     C                   ELSE
     C                   EVAL      ZIEND = REPCD
     C                   ENDIF
 
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     FSUPAM        ZIAMT
 
     C                   EVAL      ZIRATE = UEINR
     C                   Z-ADD     0             ZINTR
 
      ** If interest is Up-Front, use SR/SRUFACC to calculate accruals.
 
     C     UINPM         IFEQ      'Y'
     C     CIR001        ANDEQ     'Y'
     C     UINPM         OREQ      'D'
     C     CIR001        ANDEQ     'Y'
 
     C                   Z-ADD     FSUPRB        SZIPRD
     C                   Z-ADD     FSUINB        SZAIAN
     C                   Z-ADD     FSUIAB        SZAIAP
     C                   Z-ADD     FSUITB        SZAITC
     C                   Z-ADD     USLIP         SZSLID
     C                   Z-ADD     ACTD          SZACTD
     C                   MOVE      UINPM         SZINPM
 
     C                   EXSR      SRUFACC
 
     C                   Z-ADD     SZAMAD        AMAD
     C                   Z-ADD     SZAMTA        AMTA
 
     C                   ELSE
 
      ** Calculate Interest Accrued to Date if the deal has started
      ** accruing.
 
      ** If this is a Cash Flow Swap, obtain the Cash Flow Schedule.
 
     C                   IF        UIPFR = 'C' AND CIR001 = 'Y'
     C                   EVAL      OTIN = 'U'
     C                   EVAL      PRDT = ACTD
 
     C     KCFSC         CHAIN     DLCFSCPD
 
     C                   IF        NOT %FOUND(DLCFSCPD)
     C                   EVAL      CFLA = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C     USLIP         IFLE      REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C     UIPFR         IFEQ      'C'
     C     CIR001        ANDEQ     'Y'
     C                   Z-ADD     USLIP         SZSLID
     C                   Z-ADD     ACTD          SZACTD
     C                   EXSR      SRCFACC
     C                   Z-ADD     WKINT         ZINTR
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     USLIP         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     ZINTR         WINTR
     C     ZINTR         ADD(H)    FSUINB        AMAD
     C                   ADD       FSUIAB        AMAD
     C                   ADD       FSUITB        AMAD
     C                   SUB       FSUPRB        AMAD
 
      ** Calculate the Interest to Accrue.
 
     C                   Z-ADD     ACTD          ZIEND
     C                   Z-ADD     0             ZINTR
 
     C     ACTD          IFGE      REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C     UIPFR         IFEQ      'C'
     C     CIR001        ANDEQ     'Y'
     C                   Z-ADD     USLIP         ZIBEG
     C                   Z-ADD     REPCD         ZIEND
     C     USLIP         IFGT      REPCD
     C                   Z-ADD     USLIP         ZIEND
     C                   ENDIF
     C                   Z-ADD     USLIP         SZSLID
     C                   Z-ADD     ACTD          SZACTD
     C                   EXSR      SRCFACC
     C     CFLA          SUB       WKINT         AMTA
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I' or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     FSUPAM        ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C     ZINTR         SUB(H)    WINTR         AMTA
 
      ** If CIR014 is on, recompute the Calculated Interest Amt                               CIR014
                                                                                              CIR014
     C                   IF        CIR014 = 'Y'                                               CIR014
                                                                                              CIR014
      ** If there is a revaluation rate defined for the deal,                                 CIR014
      ** add the Principal Change Amt to the Calculated Interest Amt                          CIR014
                                                                                              CIR014
     C                   MOVE      DLNO          WDLNO                                        CIR014
     C     WDLNO         CHAIN     DLDEALL5                                                   CIR014
                                                                                              CIR014
     C                   IF        %FOUND(DLDEALL5) AND                                       CIR014
     C                             F1PRVI = 'O' AND                                           CIR014
     C                             F1LRRC > USLIP AND                                         CIR014
     C                             USLIP < MDAT AND                                           CIR014
     C                             F1LRVR <> *ZERO                                            CIR014
     C                   EVAL      AMTA = AMTA + F1PCHA                                       CIR014
     C                   ENDIF                                                                CIR014
     C                   ENDIF                                                                CIR014
                                                                                              CIR014
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse Accrual Amounts as being paid.
 
     C                   Z-SUB     AMAD          AMAD
     C                   Z-SUB     AMTA          AMTA
 
     C                   ENDIF
 
      ** Set Our Total Unsettled Interest and Their Total Unsettled
      ** Interest. Do this processing also for Our Interest Processing
      ** Methods 'A', 'I', or 'L' when CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     0             OTUI
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C     OUSI          ADD       OUSA          OTUI
     C                   ENDIF
 
     C                   Z-ADD     0             TTUI
     C                   ENDIF
 
      ** Output PF/ACCEXAO record for Our Details.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   ADD       1             RECRIT
     C                   MOVE      FSUPAM        ZZAMT
     C                   Z-ADD     1             X
     C                   EXSR      SRHASH
 
      ** Clear/set fields for processing and output of Their Details.
 
     C                   EVAL      *IN30 = *ON
 
     C                   Z-ADD     SVBRTT        TBRTT
     C                   Z-ADD     SVEINR        TEINR
 
     C                   MOVE      TCUCY         CCY
     C                   Z-ADD     FSTPAM        PCPL
     C                   Z-ADD     0             ACFD
     C                   Z-ADD     0             ACTD
     C                   Z-ADD     0             NOTD
     C                   Z-ADD     0             INTR
     C                   Z-ADD     0             AMAD
     C                   Z-ADD     0             AMTA
     C                   Z-ADD     0             UBRTT
     C                   MOVE      'N'           URTPI
 
     C                   IF        TBRTT <> 0
     C                   TESTB     '0'           TDNSI                    30
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
     C                   MOVE      'N'           TRTPI
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      'Y'           TRTPI
     C                   ENDIF
 
     C                   Z-ADD     TSLIP         TACFD
     C                   Z-ADD     0             TACTD
     C                   Z-ADD     0             TAMAD
     C                   Z-ADD     0             TAMTA
     C                   MOVE      'N'           FLRIND
 
      ** Set Accrual to Date to the earliest date present.
 
     C     TNIPD         IFNE      0
     C                   Z-ADD     TNIPD         TACTD
     C                   ELSE
     C     TNICD         IFNE      0
     C                   Z-ADD     TNICD         TACTD
     C                   ELSE
     C                   Z-ADD     MDAT          TACTD
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C     CIR005        IFEQ      'Y'
     C     L2AMCN        ANDEQ     'A '
     C     CIR001        IFEQ      'N'
     C     CIR001        OREQ      'Y'
     C     TIPFR         ANDNE     'Z'
     C     TIPBD         IFNE      0
     C                   Z-ADD     TIPBD         TACTD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     TNICD         IFNE      0
     C     TNICD         ANDLT     TACTD
     C                   Z-ADD     TNICD         TACTD
     C                   ENDIF
 
      ** Selest their details for accrual only if the rate is present.
 
     C     TRTPI         IFEQ      'Y'
 
      ** Set details to calculate Interest Accrued to Date.
 
     C                   Z-ADD     TIACD         ZIBEG
     C     TACTD         IFLE      REPCD
     C                   Z-ADD     TACTD         ZIEND
     C                   ELSE
     C                   Z-ADD     REPCD         ZIEND
     C                   ENDIF
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     FSTPAM        ZIAMT
 
     C                   EVAL      ZIRATE = TEINR
     C                   Z-ADD     0             ZINTR
 
      ** If interest is Up-Front, use SR/SRUFACC to calculate accruals.
 
     C     TINPM         IFEQ      'Y'
     C     CIR001        ANDEQ     'Y'
     C     TINPM         OREQ      'D'
     C     CIR001        ANDEQ     'Y'
 
     C                   Z-ADD     FSTPRB        SZIPRD
     C                   Z-ADD     FSTINB        SZAIAN
     C                   Z-ADD     FSTIAB        SZAIAP
     C                   Z-ADD     FSTITB        SZAITC
     C                   Z-ADD     TSLIP         SZSLID
     C                   Z-ADD     TACTD         SZACTD
     C                   MOVE      TINPM         SZINPM
 
     C                   EXSR      SRUFACC
 
     C                   Z-ADD     SZAMAD        TAMAD
     C                   Z-ADD     SZAMTA        TAMTA
 
     C                   ELSE
 
      ** Calculate Interest Accrued to Date.
 
      ** If this is a Cash Flow Swap, obtain the Cash Flow Schedule.
 
     C                   IF        TIPFR = 'C' AND CIR001 = 'Y'
 
     C                   EVAL      OTIN = 'T'
     C                   EVAL      PRDT = TACTD
 
     C     KCFSC         CHAIN     DLCFSCPD
 
     C                   IF        NOT %FOUND(DLCFSCPD)
     C                   EVAL      CFLA = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C     TSLIP         IFLE      REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C     TIPFR         IFEQ      'C'
     C     CIR001        ANDEQ     'Y'
     C                   Z-ADD     TSLIP         SZSLID
     C                   Z-ADD     TACTD         SZACTD
     C                   EXSR      SRCFACC
     C                   Z-ADD     WKINT         ZINTR
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     TSLIP         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     ZINTR         WINTR
     C     ZINTR         ADD(H)    FSTINB        TAMAD
     C                   ADD       FSTIAB        TAMAD
     C                   ADD       FSTITB        TAMAD
     C                   SUB       FSTPRB        TAMAD
 
      ** Calculate Interest to Accrue.
 
     C                   Z-ADD     TACTD         ZIEND
     C                   Z-ADD     0             ZINTR
 
     C     TACTD         IFGE      REPCD
 
      ** If a Cash Flow Schedule has been specified, use SR/SRCFACC to
      ** calculate the Cash Flow Accrual. Otherwise, use SR/SRGLINTC.
 
     C     TIPFR         IFEQ      'C'
     C     CIR001        ANDEQ     'Y'
     C                   Z-ADD     TSLIP         ZIBEG
     C                   Z-ADD     REPCD         ZIEND
     C     TSLIP         IFGT      REPCD
     C                   Z-ADD     TSLIP         ZIEND
     C                   ENDIF
     C                   Z-ADD     TSLIP         SZSLID
     C                   Z-ADD     TACTD         SZACTD
     C                   EXSR      SRCFACC
     C     CFLA          SUB       WKINT         TAMTA
     C                   ELSE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     FSTPAM        ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C     ZINTR         SUB(H)    WINTR         TAMTA
 
      ** If CIR014 is on, recompute the Calculated Interest Amt                               CIR014
                                                                                              CIR014
     C                   IF        CIR014 = 'Y'                                               CIR014
                                                                                              CIR014
      ** If there is a revaluation rate defined for the deal,                                 CIR014
      ** add the Principal Change Amt to the Calculated Interest Amt                          CIR014
                                                                                              CIR014
     C                   MOVE      DLNO          WDLNO                                        CIR014
     C     WDLNO         CHAIN     DLDEALL5                                                   CIR014
                                                                                              CIR014
     C                   IF        %FOUND(DLDEALL5) AND                                       CIR014
     C                             F1PRVI = 'T' AND                                           CIR014
     C                             F1LRRC > TSLIP AND                                         CIR014
     C                             TSLIP < MDAT AND                                           CIR014
     C                             F1LRVR <> *ZERO                                            CIR014
     C                   EVAL      TAMTA = TAMTA + F1PCHA                                     CIR014
     C                   ENDIF                                                                CIR014
     C                   ENDIF                                                                CIR014
                                                                                              CIR014
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set Our Total Unsettled Interest and Their Total Unsettled
      ** Interest. Do this processing also for Their Interest
      ** Processing Methods 'A', 'I', or 'L' when CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     0             OTUI
     C                   Z-ADD     0             TTUI
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C     TUSI          ADD       TUSA          TTUI
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output PF/ACCEXAO record for their details.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   ADD       1             RECRIT
     C                   MOVE      FSTPAM        ZZAMT
     C                   Z-ADD     1             X
     C                   EXSR      SRHASH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRLNA - Interest Rate Cap/Collar (Non-Average Rate)         *
      *           Processing.                                         *
      *                                                               *
      *****************************************************************
     C     SRRLNA        BEGSR
 
      ** Clear/set fields for processing and output.
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      WACTD = *ZERO
     C                   EVAL      WSLIP = *ZERO
     C                   EVAL      WUAMAD = *ZERO
     C                   EVAL      WTAMAD = *ZERO
 
     C                   MOVE      UCUCY         CCY
     C                   Z-ADD     USLIP         ACFD
     C                   Z-ADD     0             ACTD
     C                   Z-ADD     0             NOTD
     C                   Z-ADD     0             INTR
     C                   Z-ADD     0             AMAD
     C                   Z-ADD     0             AMTA
 
     C                   IF        UBRTT <> *ZERO
     C                   TESTB     '0'           UDNSI                    30
     C                   TESTB     '4'           UDSTI                    34
 
     C                   IF        *IN30 = *ON
     C                   Z-ADD     UEINR         INTR
     C                   MOVE      'Y'           URTPI
     C                   ELSE
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   MOVE      'N'           TRTPI
     C                   ELSE
     C                   TESTB     '0'           TDNSI                    30
     C                   TESTB     '4'           TDSTI                    34
 
     C                   IF        *IN30 = *ON
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
     C                   MOVE      'N'           TRTPI
     C                   ENDIF
 
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   Z-ADD     TSLIP         TACFD
     C                   Z-ADD     0             TACTD
     C                   Z-ADD     0             TAMAD
     C                   Z-ADD     0             TAMTA
 
     C                   IF        *IN34 = *ON
     C                   MOVE      'Y'           FLRIND
     C                   ELSE
     C                   MOVE      'N'           FLRIND
     C                   ENDIF
 
      ** Use Provider's Details.
 
      ** Provider's Details are ours.
 
     C     UBRTT         IFNE      0
 
      ** Set Accrual to Date to the earliest date present.
 
     C     UNIPD         IFNE      0
     C                   Z-ADD     UNIPD         ACTD
     C                   ELSE
     C     UNICD         IFNE      0
     C                   Z-ADD     UNICD         ACTD
     C                   ELSE
     C                   Z-ADD     MDAT          ACTD
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C     CIR005        IFEQ      'Y'
     C     L1AMCN        ANDEQ     'A '
     C     UIPBD         ANDNE     0
     C                   Z-ADD     UIPBD         ACTD
     C                   ENDIF
 
     C     UNICD         IFNE      0
     C     UNICD         ANDLT     ACTD
     C                   Z-ADD     UNICD         ACTD
     C                   ENDIF
 
     C                   Z-ADD     ACTD          WACTD
     C                   Z-ADD     USLIP         WSLIP
     C                   Z-ADD     UIACD         WIACD
 
     C                   TESTB     '1'           UDSTI                    31
 
     C                   ENDIF
 
      ** Provider's Details are theirs.
 
     C     TBRTT         IFNE      0
 
      ** Set Accrual to Date to the earliest date present.
 
     C     TNIPD         IFNE      0
     C                   Z-ADD     TNIPD         TACTD
     C                   ELSE
     C     TNICD         IFNE      0
     C                   Z-ADD     TNICD         TACTD
     C                   ELSE
     C                   Z-ADD     MDAT          TACTD
     C                   ENDIF
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if Business Day Enhancement is enabled.
 
     C     CIR005        IFEQ      'Y'
     C     L1AMCN        ANDEQ     'A '
     C     TIPBD         ANDNE     0
     C                   Z-ADD     TIPBD         TACTD
     C                   ENDIF
 
     C     TNICD         IFNE      0
     C     TNICD         ANDLT     TACTD
     C                   Z-ADD     TNICD         TACTD
     C                   ENDIF
 
     C                   Z-ADD     TACTD         WACTD
     C                   Z-ADD     TSLIP         WSLIP
     C                   Z-ADD     TIACD         WIACD
 
     C                   TESTB     '1'           TDSTI                    31
 
     C                   ENDIF
 
      ** Using our details, calculate Interest Accrual Amounts.
 
      ** Accrued Interest to Date.
 
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     UPAMT         ZIAMT
     C                   Z-ADD     WIACD         ZIBEG
 
     C     WACTD         IFLE      REPCD
     C                   Z-ADD     WACTD         ZIEND
     C                   ELSE
     C                   Z-ADD     REPCD         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     0             ZINTR
 
     C     UBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C     WSLIP         IFLE      REPCD
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WUAMAD
     C                   ELSE
     C                   Z-ADD     WSLIP         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN34 = *ON
 
     C     UBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ENDIF
 
     C     WSLIP         IFLE      REPCD
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WUAMAD
     C                   ELSE
     C                   Z-ADD     WSLIP         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   Z-ADD     ZIEND         ZIBEG
     C                   Z-ADD     WACTD         ZIEND
     C                   Z-ADD     0             ZINTR
 
     C     WACTD         IFGE      REPCD
 
     C     UBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         AMTA
     C                   ENDIF
 
     C                   IF        *IN34 = *ON
 
     C     UBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         AMTA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Using their details, calculate Interest Accrual Amounts.
 
      ** Accrued Interest to Date.
 
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     TPAMT         ZIAMT
     C                   Z-ADD     WIACD         ZIBEG
 
     C     WACTD         IFLE      REPCD
     C                   Z-ADD     WACTD         ZIEND
     C                   ELSE
     C                   Z-ADD     REPCD         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     0             ZINTR
 
     C     TBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C     WSLIP         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment.  Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WTAMAD
     C                   ELSE
     C                   Z-ADD     WSLIP         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C     *IN34         IFEQ      *ON
 
     C     TBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ENDIF
 
     C     WSLIP         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     TPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WTAMAD
     C                   ELSE
     C                   Z-ADD     WSLIP         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   Z-ADD     ZIEND         ZIBEG
     C     UBRTT         IFNE      0
     C                   Z-ADD     ACTD          ZIEND
     C                   ELSE
     C                   Z-ADD     TACTD         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     0             ZINTR
 
     C     WACTD         IFGE      REPCD
 
     C     TEINR         IFGT      CLRAT
 
     C     TBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      ZIAMT = TPAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         TAMTA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN34 = *ON
 
     C     TBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment.  Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     TPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         TAMTA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Accumulate Accrued Interest to Date.
 
     C                   EVAL      AMAD = WUAMAD + UAIAN + UAITC +
     C                             UAIAP - UIPRD
 
     C                   EVAL      TAMAD = WTAMAD + TAIAN + TAITC +
     C                             TAIAP - TIPRD
 
     C     UBRTT         IFNE      0
     C     TAMAD         SUB       AMAD          AMAD
     C                   Z-ADD     0             TAMAD
     C     TAMTA         SUB       AMTA          AMTA
     C                   Z-ADD     0             TAMTA
     C                   ELSE
     C     TAMAD         SUB       AMAD          TAMAD
     C                   Z-ADD     0             AMAD
     C     TAMTA         SUB       AMTA          TAMTA
     C                   Z-ADD     0             AMTA
     C                   ENDIF
 
      ** Set Our Total Unsettled Interest and Their Total Unsettled
      ** Interest. Do this processing also for Our/Their Interest
      ** Processing Methods 'A', 'I', or 'L' when CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     0             OTUI
     C                   Z-ADD     0             TTUI
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C     OUSI          ADD       OUSA          OTUI
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C     TUSI          ADD       TUSA          TTUI
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output PF/ACCEXAO record.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   ADD       1             RECRIT
     C                   MOVE      UPAMT         ZZAMT
     C                   Z-ADD     1             X
     C                   EXSR      SRHASH
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRRLAV - Interest Rate Cap/Collar (Ave. Rate) Processing.    *
      *                                                               *
      *****************************************************************
     C     SRRLAV        BEGSR
 
      ** Clear/set fields for processing and output.
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   Z-ADD     0             WACTD
     C                   Z-ADD     0             WUAMAD
     C                   Z-ADD     0             WTAMAD
 
     C                   MOVE      UCUCY         CCY
     C                   Z-ADD     USLIP         ACFD
     C                   Z-ADD     0             ACTD
     C                   Z-ADD     0             NOTD
     C                   Z-ADD     0             INTR
     C                   Z-ADD     0             AMAD
     C                   Z-ADD     0             AMTA
     C                   Z-ADD     0             TEINR
 
     C     UBRTT         IFNE      0
     C                   TESTB     '0'           UDNSI                    30
     C                   TESTB     '4'           UDSTI                    34
 
     C     *IN30         IFEQ      *ON
     C                   Z-ADD     AACRT         INTR
     C                   Z-ADD     AACRT         UEINR
     C                   MOVE      'Y'           URTPI
     C                   ELSE
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   MOVE      'N'           TRTPI
     C                   ELSE
     C                   TESTB     '0'           TDNSI                    30
     C                   TESTB     '4'           TDSTI                    34
 
     C                   IF        *IN30 = *ON
     C                   Z-ADD     AACRT         TEINR
     C                   MOVE      'Y'           TRTPI
     C                   ELSE
     C                   MOVE      'N'           TRTPI
     C                   ENDIF
 
     C                   MOVE      'N'           URTPI
     C                   ENDIF
 
     C                   Z-ADD     TSLIP         TACFD
     C                   Z-ADD     0             TACTD
     C                   Z-ADD     0             TAMAD
     C                   Z-ADD     0             TAMTA
 
     C                   IF        *IN34 = *ON
     C                   MOVE      'Y'           FLRIND
     C                   ELSE
     C                   MOVE      'N'           FLRIND
     C                   ENDIF
 
      ** Use the Provider's Details.
 
      ** The Provider's Details are ours.
 
     C                   IF        UBRTT <> 0
 
      ** Set Accrual to Date to the earliest date present.
 
     C                   IF        UNIPD <> *ZERO
     C                   EVAL      ACTD = UNIPD
     C                   ELSE
 
     C                   IF        UNICD <> *ZERO
     C                   EVAL      ACTD = UNICD
     C                   ELSE
     C                   EVAL      ACTD = MDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if CIR005 is enabled.
 
     C                   IF        CIR005 = 'Y' AND
     C                             L1AMCN = 'A ' AND
     C                             UIPBD <> *ZERO
     C                   EVAL      ACTD = UIPBD
     C                   ENDIF
 
     C                   IF        UNICD <> *ZERO AND
     C                             UNICD < ACTD
     C                   EVAL      ACTD = UNICD
     C                   ENDIF
 
     C                   EVAL      WACTD = ACTD
 
     C                   TESTB     '1'           UDSTI                    31
 
     C                   ENDIF
 
      ** The Provider's Details are theirs.
 
     C                   IF        TBRTT <> *ZERO
 
      ** Set Accrual to Date to the earliest date present.
 
     C                   IF        TNIPD <> *ZERO
     C                   EVAL      TACTD = TNIPD
     C                   ELSE
 
     C                   IF        TNICD <> *ZERO
     C                   EVAL      TACTD = TNICD
     C                   ELSE
     C                   EVAL      TACTD = MDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Use Interest Payment Base Date instead of Next Interest
      ** Payment Date if CIR005 is enabled.
 
     C                   IF        CIR005 = 'Y'  AND
     C                             L1AMCN = 'A ' AND
     C                             TIPBD <> 0
     C                   EVAL      TACTD = TIPBD
     C                   ENDIF
 
     C                   IF        TNICD <> *ZERO AND
     C                             TNICD < TACTD
     C                   EVAL      TACTD = TNICD
     C                   ENDIF
 
     C                   EVAL      WACTD = TACTD
 
     C                   TESTB     '1'           TDSTI                    31
 
     C                   ENDIF
 
      ** Using Our Details, calculate Interest Accrual Amounts.
 
      ** Accrued Interest to Date.
 
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     UPAMT         ZIAMT
     C                   Z-ADD     SDCAR         ZIBEG
 
     C     WACTD         IFLE      REPCD
     C                   Z-ADD     WACTD         ZIEND
     C                   ELSE
     C                   Z-ADD     REPCD         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     0             ZINTR
 
     C     UBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C     SDCAR         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WUAMAD
     C                   ELSE
     C                   Z-ADD     SDCAR         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C     *IN34         IFEQ      *ON
 
     C     UBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ENDIF
 
     C     SDCAR         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WUAMAD
     C                   ELSE
     C                   Z-ADD     SDCAR         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   Z-ADD     ZIEND         ZIBEG
     C                   Z-ADD     WACTD         ZIEND
     C                   Z-ADD     0             ZINTR
 
     C     WACTD         IFGE      REPCD
 
     C     UBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         AMTA
     C                   ENDIF
 
     C     *IN34         IFEQ      *ON
 
     C     UBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *OFF
 
     C     UBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *ON
 
     C     UBRTT         IFNE      0
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Our Unsettled Interest +
      ** Our Unsettled Interest Adjustment. Do this processing also
      ** for Our Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     UPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     UINPM         ANDEQ     'L'
     C                   ADD       OUSI          ZIAMT
     C                   ADD       OUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         AMTA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Using their details, calculate Interest Accrual Amounts.
 
      ** Accrued Interest to Date.
 
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     TPAMT         ZIAMT
     C                   Z-ADD     TIACD         ZIBEG
 
     C     WACTD         IFLE      REPCD
     C                   Z-ADD     WACTD         ZIEND
     C                   ELSE
     C                   Z-ADD     REPCD         ZIEND
     C                   ENDIF
 
     C                   Z-ADD     0             ZINTR
 
     C     TBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C     SDCAR         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is installed.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WTAMAD
     C                   ELSE
     C                   Z-ADD     SDCAR         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C     *IN34         IFEQ      *ON
 
     C     TBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ENDIF
 
     C     SDCAR         IFLE      REPCD
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C                   Z-ADD     TPAMT         ZIAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         WTAMAD
     C                   ELSE
     C                   Z-ADD     SDCAR         ZIEND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate the Interest to Accrue.
 
     C                   Z-ADD     ZIEND         ZIBEG
     C                   Z-ADD     WACTD         ZIEND
     C                   Z-ADD     0             ZINTR
 
     C     WACTD         IFGE      REPCD
 
     C     TEINR         IFGT      CLRAT
 
     C     TBRTT         IFNE      0
     C     *IN30         ANDEQ     *ON
     C     TEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         OREQ      0
     C     *IN30         ANDEQ     *ON
     C     UEINR         ANDGT     CLRAT
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     TEINR         SUB       CLRAT         ZIRATE
     C                   ELSE
     C     UEINR         SUB       CLRAT         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      ZIAMT = TPAMT
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND TINPM = 'A') OR
     C                             (CIR006 = 'Y' AND TINPM = 'I') OR
     C                             (CIR006 = 'Y' AND TINPM = 'L')
     C                   EVAL      ZIAMT = ZIAMT + TUSI + TUSA
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
 
     C                   EVAL(H)   TAMTA = ZINTR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN34 = *ON
 
     C     TBRTT         IFEQ      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     UEINR
     C     *IN31         ANDEQ     *OFF
 
     C     TBRTT         ORNE      0
     C     *IN30         ANDEQ     *ON
     C     FLRAT         ANDGT     TEINR
     C     *IN31         ANDEQ     *ON
 
     C     TBRTT         IFNE      0
     C     FLRAT         SUB       TEINR         ZIRATE
     C                   ELSE
     C     FLRAT         SUB       UEINR         ZIRATE
     C                   ENDIF
 
     C                   EXSR      SRZSAVE
 
      ** Set ZIAMT to Principal Amount + Their Unsettled Interest +
      ** Their Unsettled Interest Adjustment. Do this processing also
      ** for Their Interest Processing Methods 'A', 'I', or 'L' when
      ** CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
     C                   EVAL      ZIAMT = TPAMT
     C                   ENDIF
 
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     TINPM         ANDEQ     'L'
     C                   ADD       TUSI          ZIAMT
     C                   ADD       TUSA          ZIAMT
     C                   ENDIF
 
     C                   EXSR      SRGLINTC
 
     C                   EXSR      SRZRSTOR
     C                   Z-ADD(H)  ZINTR         TAMTA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Accumulate the Accrued Interest to Date.
 
     C                   EVAL      AMAD = WUAMAD + UAIAN + UAITC +
     C                             UAIAP - UIPRD
 
     C                   EVAL      TAMAD = WTAMAD + TAIAN + TAITC +
     C                             TAIAP - TIPRD
 
     C     UBRTT         IFNE      0
     C     TAMAD         SUB       AMAD          AMAD
     C                   Z-ADD     0             TAMAD
     C     TAMTA         SUB       AMTA          AMTA
     C                   Z-ADD     0             TAMTA
     C                   ELSE
     C     TAMAD         SUB       AMAD          TAMAD
     C                   Z-ADD     0             AMAD
     C     TAMTA         SUB       AMTA          TAMTA
     C                   Z-ADD     0             AMTA
     C                   ENDIF
 
      ** Set Our Total Unsettled Interest and Their Total Unsettled
      ** Interest. Do this processing also for Our/Their Interest
      ** Processing Methods 'A', 'I', or 'L' when CIR006 is enabled.
 
     C                   IF        CIR002 = 'Y' OR
     C                             CIR006 = 'Y'
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND UINPM = 'A') OR
     C                             (CIR006 = 'Y' AND UINPM = 'I') OR
     C                             (CIR006 = 'Y' AND UINPM = 'L')
     C                   EVAL      OTUI = OUSI + OUSA
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y' OR
     C                             (CIR006 = 'Y' AND TINPM = 'A') OR
     C                             (CIR006 = 'Y' AND TINPM = 'I') OR
     C                             (CIR006 = 'Y' AND TINPM = 'L')
     C                   EVAL      TTUI = TUSI + TUSA
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output PF/ACCEXAO record.
 
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
 
      ** Accumulate the number and value of extract records written.
 
     C                   EVAL      RECRIT = RECRIT + 1
     C                   MOVE      UPAMT         ZZAMT
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDLRADS - Calculates the Discounted Settled Amount for Fwd. *
      *             Rate Agreements.                                  *
      *                                                               *
      *****************************************************************
     C     SRDLRADS      BEGSR
 
     C                   Z-ADD     0             SZICVL
     C                   Z-ADD     0             SZSDAT
     C                   Z-ADD     0             SZEDAT
     C                   Z-ADD     0             SZPER
     C                   Z-ADD     0             STYR
     C                   Z-ADD     0             STWRK
     C                   Z-ADD     0             STDAY
     C                   Z-ADD     0             STMTH
     C                   Z-ADD     0             ENDYR
     C                   Z-ADD     0             ENDWRK
     C                   Z-ADD     0             ENDDAY
     C                   Z-ADD     0             ENDMTH
     C                   Z-ADD     0             YEAR1
     C                   Z-ADD     0             STORE
     C                   Z-ADD     0             CHK
     C                   Z-ADD     0             YEAR2
     C                   Z-ADD     0             DAY1
     C                   Z-ADD     0             MTHS
     C                   Z-ADD     0             MTHS2
     C                   Z-ADD     0             SZWRK1
     C                   Z-ADD     0             SZWRK2
     C                   Z-ADD     0             SZWRK3
     C                   Z-ADD     0             SZWRK4
     C                   Z-ADD     0             SZWRK5
     C                   Z-ADD     0             SZWRK6
     C                   Z-ADD     0             SZWRK7
     C                   Z-ADD     0             SZWRK8
     C                   Z-ADD     0             SZWRK9
     C                   Z-ADD     0             SZSETL
     C                   Z-ADD     0             SZRDF
     C                   Z-ADD     0             SZRSA
     C                   Z-ADD     0             SZRDS
     C                   Z-ADD     0             SZDISC
     C                   Z-ADD     0             SZDSA
     C                   Z-ADD     0             DATST
     C                   Z-ADD     0             DATEND
     C                   Z-ADD     0             SLEAP
     C                   Z-ADD     0             ELEAP
     C                   Z-ADD     0             CHK2
 
     C                   EVAL      *IN89 = *OFF
 
      ** Calculate the Discounted Settlement Amount using the
      ** Australian Formula if necessary.
 
     C                   IF        SETF = 'A'
 
      ** Calculate Days to Maturity.
 
     C                   EVAL      SZWRK3 = SZMDAT - SZVDAT
 
      ** Multiply the Face Value by (No. of Days in a Year * 100).
 
     C                   EVAL      SZSETL = SZPPL * 36500
 
      ** Calculate Proceeds from the Floating Rate.
 
     C                   EVAL      SZWRK2 = (SZWRK3 * SZFLT) + 36500
 
     C                   IF        SZWRK2 <> *ZERO
     C                   EVAL(H)   SZRSA = SZSETL / SZWRK2
     C                   ELSE
     C                   EVAL      SZRSA = *ZERO
     C                   ENDIF
 
      ** Calculate Proceeds from the Fixed Amount.
 
     C                   EVAL      SZWRK2 = (SZWRK3 * SZFIX) + 36500
 
     C                   IF        SZWRK2 <> *ZERO
     C                   EVAL(H)   SZWRK8 = SZSETL / SZWRK2
     C                   ELSE
     C                   EVAL      SZWRK8 = *ZERO
     C                   ENDIF
 
      ** Calculate the Discounted Settlement Amount.
 
     C                   IF        SZRSA > SZWRK8
     C                   EVAL      SZRDS = SZRSA - SZWRK8
     C                   ELSE
     C                   EVAL      SZRDS = SZWRK8 - SZRSA
     C                   ENDIF
 
     C                   ELSE
 
      ** Calculate the Discounted Settlement Amount using the
      ** USA Formula if necessary.
 
     C                   IF        SETF = 'U'
 
      ** Calculate Days to Maturity.
 
     C                   EVAL      SZWRK3 = SZMDAT - SZVDAT
 
      ** Multiply Interest Settlement Rate by Days to Maturity and
      ** add (No. of Days in a Year * 100).
 
     C                   EVAL      SZWRK9 = (SZFLT * SZWRK3) + 36000
 
      ** Calculate the difference in rates.
 
     C                   IF        SZFLT > SZFIX
     C                   EVAL      SZWRK1 = SZFLT - SZFIX
     C                   ELSE
     C                   EVAL      SZWRK1 = SZFIX - SZFLT
     C                   ENDIF
 
      ** Multiply the calculated difference by Days to Maturity and
      ** Contract Amount.
 
     C                   EVAL      SZWRK2 = SZWRK1 * SZWRK3 * SZPPL
 
      ** Calculate the Discounted Settlement Amount.
 
     C                   IF        SZWRK9 <> *ZERO
     C                   EVAL(H)   SZRDS = SZWRK2 / SZWRK9
     C                   ELSE
     C                   EVAL      SZRDS = *ZEROS
     C                   ENDIF
 
     C                   ELSE
 
      ** Calculate the Discounted Settlement Amount using the
      ** UK Formula if necessary.
 
      ** Determine the value associated with the Interest Calculation
      ** Basis.
 
     C                   IF        SZICB = 2 OR
     C                             SZICB = 3 OR
     C                             SZICB = 5
     C                   EVAL      SZICVL = 360
     C                   ENDIF
 
     C                   IF        SZICB = 1 OR
     C                             SZICB = 4
     C                   EVAL      SZICVL = 365
     C                   ENDIF
 
     C                   IF        SZICB = 6
     C                   EVAL      SZICVL = 366
     C                   ENDIF
 
      ** Set Start Date equal to Value Date.
 
     C                   EVAL      SZSDAT = SZVDAT
 
      ** Process until End Date is greater than Maturity Date.
 
     C                   DOU       *IN89 = *ON
 
      ** Execute subroutine SRZDATE2.
 
     C                   EVAL      ZDAYNO = SZSDAT
     C                   EXSR      SRZDATE2
 
      ** Slice the date information.
 
     C                   EVAL      ZA = ZDATE
 
     C                   IF        ZDATFM = 'M'
     C                   EVAL      ZMTH = ZX
     C                   EVAL      ZDAY = ZY
     C                   ELSE
     C                   EVAL      ZMTH = ZY
     C                   EVAL      ZDAY = ZX
     C                   ENDIF
 
     C                   EVAL      ZYEAR = ZZ
 
      ** Increment the year by 1.
 
     C                   EVAL      ZYEAR = ZYEAR + 1
     C                   MOVE      ZYEAR         ZDATE
 
      ** 29th February does not exist in a non-leap year.
 
     C     ZMTH          IFEQ      02
     C     ZDAY          ANDEQ     29
     C                   Z-ADD     28            ZDAY
 
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     ZDAY          ZDATE
     C                   ELSE
     C                   MOVE(P)   ZDAY          W@MDY
     C                   MOVEL     ZMTH          W@MDY
     C                   MOVEL     W@MDY         ZDATE
     C                   ENDIF
     C                   ENDIF
 
      ** Execute subroutine SRZDATE1.
 
     C                   EXSR      SRZDATE1
     C                   EVAL      SZEDAT = ZDAYNO
 
      ** Check to see if Maturity Date falls between Period End Date
      ** and Period End Date + 10 (this will only happen if a FRA
      ** was entered with an increased Maturity Date due to the
      ** actual Maturity Date falling on a non-working day). If it
      ** does, calculate the Discounted Settlement Amount up to
      ** Maturity Date. Otherwise, calculate it up to the Period
      ** End Date. The number 10 was chosen because this is the worst
      ** possible case of non-working days in a row (Easter).
 
     C                   EVAL      #EDAT = SZEDAT + 10
 
      ** If End Date is greater than Maturity Date, replace End Date
      ** by Maturity Date.
 
     C                   IF        SZEDAT >= SZMDAT OR
     C                             (SZEDAT < SZMDAT AND
     C                             #EDAT >= SZMDAT)
     C                   EVAL      *IN89 = *ON
     C                   EVAL      SZEDAT = SZMDAT
     C                   ENDIF
                                                                                              CIR013
      ** If calculation method 9 for FRA/IRS/CCF                                              CIR013
     C                   If        SZICB = 9                                                  CIR013
                                                                                              CIR013
      ** Convert start and end dates to YYYYMMDD                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    SZSDAT                                       CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    SZEDAT                                       CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
      ** Check if the period contains a Feb 29                                                CIR013
     C                   CallB     'ZFEB29CHK'                                                CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    #29Feb                                       CIR013
                                                                                              CIR013
     C                   If        #29Feb = 'Y'                                               CIR013
     C                   Eval      SZICVL = 366                                               CIR013
     C                   Else                                                                 CIR013
     C                   Eval      SZICVL = 365                                               CIR013
     C                   Endif                                                                CIR013
                                                                                              CIR013
     C                   Endif                                                                CIR013
 
      ** Calculate the period between Start Date and End Date.
 
     C                   IF        SZICB = 1 OR
     C                             SZICB = 2 OR
     C                             SZICB = 6
     C                             or (SZICB = 9 and #29Feb = 'Y')                            CIR013
     C                   EVAL      SZPER = SZEDAT - SZSDAT
     C                   ENDIF
 
      ** If End Date is less than or equal to Maturity Date
 
     C                   IF        *IN89 = *OFF
 
     C                   IF        SZICB = 3 OR
     C                             SZICB = 4
     C                             or (SZICB = 9 and #29Feb = 'N')                            CIR013
     C                   EVAL      SZPER = SZICVL
     C                   ENDIF
 
     C                   IF        SZICB = 5
     C                   EVAL      SZPER = 365
     C                   ENDIF
 
     C                   ELSE
 
      ** The End Date was replaced by the Maturity Date.
 
     C     SZICB         IFEQ      4
     C     SZICB         OREQ      5
     C     SZICB         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     SZEDAT        SUB       SZSDAT        SZPER
 
      ** Convert both Start and End Day Numbers to dates.
 
     C                   EVAL      ZDAYNO = SZSDAT
     C                   EXSR      SRZDATE2
     C                   EVAL      DATST = ZDATE
 
     C                   EVAL      ZDAYNO = SZEDAT
     C                   EXSR      SRZDATE2
     C                   EVAL      DATEND = ZDATE
 
      ** Attempt to calculate the Day Number for Feb 29.
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     '2902'        DATST
     C                   MOVEL     '2902'        DATEND
     C                   ELSE
     C                   MOVEL     '0229'        DATST
     C                   MOVEL     '0229'        DATEND
     C                   ENDIF
 
     C                   EVAL      ZDATE = DATST
     C                   EXSR      SRZDATE1
     C                   EVAL      SLEAP = ZDAYNO
 
      ** If a Day Number is found, check if it lies between Start Date
      ** and End Date.
 
     C                   IF        *IN99 = *OFF
 
     C                   IF        SLEAP >= SZSDAT AND
     C                             SLEAP <= SZEDAT
     C                   EVAL      SZPER = SZPER - 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      ZDATE = DATEND
     C                   EXSR      SRZDATE1
     C                   EVAL      ELEAP = ZDAYNO
 
     C                   IF        *IN99 = *OFF
 
     C                   IF        ELEAP >= SZSDAT AND
     C                             ELEAP <= SZEDAT
     C                   EVAL      SZPER = SZPER - 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** For Method 3, split both Start and End Dates into their
      ** respective day, month, and year portions.
 
     C                   IF        SZICB = 3
 
     C                   EVAL      SZPER = *ZERO
 
     C                   EVAL      ZDAYNO = SZSDAT
     C                   EXSR      SRZDATE2
     C                   EVAL      DATST = ZDATE
 
     C                   MOVE      DATST         STYR
     C                   MOVE      DATST         STWRK
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     DATST         STDAY
     C                   MOVEL     STWRK         STMTH
     C                   ELSE
     C                   MOVEL     DATST         STMTH
     C                   MOVEL     STWRK         STDAY
     C                   ENDIF
 
     C                   EVAL      ZDAYNO = SZEDAT
     C                   EXSR      SRZDATE2
     C                   EVAL      DATEND = ZDATE
 
     C                   MOVE      DATEND        ENDYR
     C                   MOVE      DATEND        ENDWRK
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     DATEND        ENDDAY
     C                   MOVEL     ENDWRK        ENDMTH
     C                   ELSE
     C                   MOVEL     DATEND        ENDMTH
     C                   MOVEL     ENDWRK        ENDDAY
     C                   ENDIF
 
      ** Check Start Date for Leap Year.
 
     C                   EVAL      YEAR1 = STYR + 1900
     C     YEAR1         DIV       4             STORE
     C                   MVR                     CHK
 
      ** Check End Date for Leap Year allowing for change in century.
 
     C                   EVAL      YEAR2 = ENDYR + 1900
 
     C                   IF        YEAR2 < YEAR1
     C                   EVAL      YEAR2 = YEAR2 + 100
     C                   ENDIF
 
     C     YEAR2         DIV       4             STORE
     C                   MVR                     CHK2
 
      ** If the start month does not equal 2, subtract the day portion
      ** from 30 thereby setting a negative or zero result for the
      ** actual days in a month.
 
     C                   IF        STMTH <> 2
     C                   EVAL      SZPER = 30 - STDAY
 
     C                   IF        SZPER < 0
     C                   EVAL      SZPER = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        STMTH = 2
 
      ** If it is not a Leap Year subtract the day portion from 28.
 
     C                   IF        CHK <> 0
     C                   EVAL      SZPER = 28 - STDAY
     C                   ELSE
 
      ** If it is a Leap Year subtract the day portion from 29.
 
     C                   EVAL      SZPER = 29 - STDAY
     C                   ENDIF
 
     C                   ENDIF
 
      ** Adjust the Start Month & Year to cater for the year end.
 
     C                   IF        STMTH = 12
     C                   EVAL      STMTH = 0
     C                   EVAL      YEAR1 = YEAR1 + 1
     C                   ENDIF
 
      ** If the End Month is not equal to 2 and End Day is 31 or Month
      ** equals 2 and it is not a Leap Year and the End Day equals 28
      ** or Month equals 2 and it is a Leap Year and the End Day equals
      ** 29, then add 30 to the Period Count.
 
     C                   IF        (ENDMTH <> 2 AND ENDDAY = 31) OR
     C                             (ENDMTH = 2 AND CHK2 <> 0 AND
     C                             ENDDAY = 28) OR
     C                             (ENDMTH = 2 AND CHK2 = 0 AND
     C                             ENDDAY = 29)
     C                   EVAL      SZPER = SZPER + 30
     C                   ELSE
 
      ** Add the Day Number portion to Period Count.
 
     C                   EVAL      SZPER = SZPER + ENDDAY
 
     C                   ENDIF
 
      ** Subtract 1 from the End Month.
 
     C                   EVAL      ENDMTH = ENDMTH - 1
 
      ** If the Start Year and End Year are the same, subtract Start
      ** Month from End Month.
 
     C                   IF        YEAR1 = YEAR2
     C                   EVAL      MTHS = ENDMTH - STMTH
     C                   ELSE
 
      ** Add End Month to the result of subtracting Start Month
      ** from 12.
 
     C                   EVAL      MTHS = 12 - STMTH + ENDMTH
     C                   ENDIF
 
      ** Multiply the No. of Months by 30 and add to the Period Count.
 
     C                   EVAL      MTHS2 = MTHS * 30
     C                   EVAL      SZPER = SZPER + MTHS2
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Calculate this period's Discounted Settlement Amount using
      ** the following equation:
      **
      ** SA =    (Base Rate - Fixed Rate) * D * Principal
      **      ----------------------------------------------
      **      (Interest Calc. Basis * 100) + (Base Rate * D)
      **
      ** Where SA = Settlement Amount and D = Period
 
     C                   IF        SZFLT >= SZFIX
     C                   EVAL      SZWRK1 = SZFLT - SZFIX
     C                   ELSE
     C                   EVAL      SZWRK1 = SZFIX - SZFLT
     C                   ENDIF
 
     C                   EVAL      SZWRK2 = SZWRK1 * SZPER
 
      ** Multiply by Principal now to get a larger dividend and to
      ** avoid errors due to half-adjusting small numbers later.
 
     C                   EVAL      SZWRK6 = SZWRK2 * SZPPL
 
     C                   EVAL      SZWRK3 = SZICVL * 100
     C                   EVAL      SZWRK4 = SZFLT * SZPER
     C                   EVAL      SZWRK5 = SZWRK3 + SZWRK4
 
     C                   EVAL(H)   SZSETL = SZWRK6 / SZWRK5
 
      ** If Value Date equals Start Date, initialise the Running
      ** Discount Factor to 1.
 
     C                   IF        SZVDAT = SZSDAT
 
     C                   EVAL      SZRDF = 1
     C                   EVAL      SZRDS = SZSETL
     C                   ELSE
 
      ** Divide the Discounted Settlement Amount by the Running
      ** Discount Factor to Rediscount this Period's Settlement
      ** Amount back to Start Date.
 
     C                   EVAL(H)   SZRSA = SZSETL / SZRDF
 
      ** Add the rediscounted Settlement Amount to the Running
      ** Discounted Settlement Total.
 
     C     SZRSA         ADD       SZRDS         SZRDS
 
     C                   ENDIF
 
      ** Calculate this Period's Discount Factor using the following
      ** equation:
 
      ** Factor = 1 +       (D x Base Rate)
      **              ----------------------------
      **              (Interest Calc. Basis * 100)
 
     C                   EVAL(H)   SZWRK7 = SZWRK4 / SZWRK3
     C                   EVAL(H)   SZDISC = 1 + SZWRK7
 
      ** Multiply the Discount Factor by the Running Discount Factor
      ** to obtain the new Running Discount Factor for rediscounting
      ** Settlement Amounts back to Start Date.
 
     C                   EVAL(H)   SZRDF = SZRDF * SZDISC
 
      ** Set the Start Date to the End Date.
 
     C                   EVAL      SZSDAT = SZEDAT
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Add the Net Accrued Interest Adjustments Not Posted to the
      ** Running Discounted Settlement Total to give the Discounted
      ** Settlement Amount Total.
 
     C                   EVAL      SZDSA = SZIANP + SZRDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFAMO - IRS Fee Amortization Processing.                    *
      *                                                               *
      *****************************************************************
     C     SRFAMO        BEGSR
 
      ** Write a ACCEXNO file record if the Up-Front Fee Value Date is
      ** not zero and is less than or equal to the Report Control Date.
 
     C                   IF        UPVD <> *ZERO AND
     C                             UPVD <= REPCD
 
      ** Initialise the ACCEXNO fields.
 
     C                   EVAL      NOTD = *ZERO
     C                   EVAL      INTR = *ZERO
     C                   EVAL      UBRTT = *ZERO
     C                   EVAL      TBRTT = *ZERO
     C                   EVAL      TEINR = *ZERO
     C                   EVAL      URTPI = *BLANK
     C                   EVAL      TRTPI = *BLANK
     C                   EVAL      TACFD = *ZERO
     C                   EVAL      TACTD = *ZERO
     C                   EVAL      TAMAD = *ZERO
     C                   EVAL      TAMTA = *ZERO
     C                   EVAL      CLRAT = *ZERO
     C                   EVAL      FLRAT = *ZERO
     C                   EVAL      FLRIND = *BLANK
     C                   EVAL      OTUI = *ZERO
     C                   EVAL      TTUI = *ZERO
 
      ** Set the Record ID.
 
     C                   EVAL      RECI = 'G'
 
      ** Set the Currency Code.
 
     C                   IF        UPPR = 'P'
     C                   EVAL      CCY = UCUCY
     C                   ELSE
     C                   EVAL      CCY = TCUCY
     C                   ENDIF
 
      ** Set the Accural From Date.
 
     C                   EVAL      ACFD = UPVD
 
      ** Set the Accural Control Date.
 
     C                   EVAL      ACTD = MDAT
 
      ** If the Up-Front Fee Payment/Receipt Flag is equal to 'P',
      ** negate the Principal Amount and the Total Interest Accrued
      ** to Date. Otherwise, get the amounts directly from the
      ** deals file.
 
     C                   IF        UPPR = 'P'
     C                   EVAL      PCPL = -1 * UPFE
     C                   EVAL      AMAD = -1 * UPAD
     C                   ELSE
     C                   EVAL      PCPL = UPFE
     C                   EVAL      AMAD = UPAD
     C                   ENDIF
 
      ** Set the Amount to Accrue.
 
     C                   EVAL      AMTA = PCPL - AMAD
 
      ** Output the PF/ACCEXAO record.
 
     C                   EVAL      *IN74 = *ON
     C                   EVAL      WDetTyp = 'A'
     C                   EXSR      SRAENO
     C                   EVAL      *IN74 = *OFF
 
      ** Accumulate the number and value of extract records written.
 
     C                   EVAL      RECRIT = RECRIT + 1
     C                   MOVE      UPFE          ZZAMT
     C                   EVAL      X = 1
     C                   EXSR      SRHASH
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUFACC - Calculates accrual amounts for IRS if interest is  *
      *            up-front.                                          *
      *                                                               *
      *****************************************************************
     C     SRUFACC       BEGSR
 
      ** Calculate interest from the Last Interest Payment Date to
      ** the Next Interest Payment Date.
 
     C                   EVAL      ZIBEG = SZSLID
     C                   EVAL      ZIEND = SZACTD
 
      ** Yield Basis Calculation
      ** -----------------------
 
     C                   IF        SZINPM = 'Y'
     C                   EVAL      ZDAYN1 = ZIEND - ZIBEG
     C                   EXSR      SRCALIYD
     C                   ELSE
 
      ** Discounted Basis Calculation
      ** ----------------------------
 
     C                   EXSR      SRGLINTC
     C                   EVAL(H)   WKINT = ZINTR
     C                   ENDIF
 
      ** If the deal started accruing, subtract the interest calculated
      ** above from the Interest Accrued to Control Date and add the
      ** Accrued Interest Adjustments Posted to obtain the Interest
      ** Accrued to Last Payment Date.
 
     C                   IF        SZSLID <= REPCD
 
     C                   EVAL      SWIPRD = SZIPRD - WKINT
     C                   EVAL      SZAITD = SZAITC - WKINT
     C                   EVAL      SZAITD = SZAITD + SZAIAP + SZAIAN
     C                   EVAL      SWKINT = WKINT
 
      ** Calculate Interest from the Last Interest Payment Date to
      ** the Report Control Date.
 
     C                   EVAL      SZAMTA = *ZERO
 
     C                   IF        SZACTD >= REPCD
 
      ** Yield Basis Calculation
      ** -----------------------
 
     C                   IF        SZINPM = 'Y'
     C                   EVAL      ZDAYN1 = SZACTD - REPCD
     C                   If        ZICALC = 9                                                 CIR013
     C                   Eval      ZIBEG = REPCD                                              CIR013
     C                   Eval      ZIEND = SZACTD                                             CIR013
     C                   Endif                                                                CIR013
     C                   EXSR      SRCALIYD
     C                   EVAL      SZAMTA = WKINT
     C                   EVAL      WKINT = SWKINT - WKINT
     C                   ELSE
 
      ** Discounted Basis Calculation
      ** ----------------------------
 
     C                   EVAL      ZIEND = REPCD
     C                   EXSR      SRGLINTC
     C                   EVAL(H)   WKINT = ZINTR
     C                   EVAL      SZAMTA = SWKINT - WKINT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Add the calculated interest to Interest Accrued to Control
      ** Date.
 
     C                   EVAL      SZAITD = SZAITD + WKINT
 
      ** Calculate the Interest Accrued to Date.
 
     C                   EVAL      SZAMAD = SZAITD - SWIPRD
 
     C                   ELSE
 
      ** At this point, the deal hasn't started yet.
 
     C                   EVAL      SZAMAD = *ZERO
     C                   EVAL      SZAMTA = WKINT
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALIYD - Calculates the Yield Amount.                      *
      *                                                               *
      *****************************************************************
     C     SRCALIYD      BEGSR
                                                                                              CIR013
      ** If calculation method 9 for FRA/IRS/CCF                                              CIR013
     C                   If        ZICALC = 9                                                 CIR013
                                                                                              CIR013
      ** Convert start and end dates to YYYYMMDD                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    ZIBEG                                        CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    ZIEND                                        CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
      ** Check if the period contains a Feb 29                                                CIR013
     C                   CallB     'ZFEB29CHK'                                                CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    #29Feb                                       CIR013
                                                                                              CIR013
     C                   Endif                                                                CIR013
 
      ** Interest = P (1 - 1 / (1 + R * N / 360))
      **          = P (1 - 360 / (360 + R * N))
 
      ** Where P = Principal, R = Rate, and N = No. of Days.
 
     C                   IF        ZICALC = 2 OR
     C                             ZICALC = 3 OR
     C                             ZICALC = 5
     C                   EVAL      ZIWRK3 = 36000
     C                   ELSE
 
     C                   IF        ZICALC = 1 OR
     C                             ZICALC = 4
     C                             or (ZICALC = 9 and #29Feb = 'N')                           CIR013
     C                   EVAL      ZIWRK3 = 36500
     C                   ELSE
     C                   EVAL      ZIWRK3 = 36600
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      ZIWRK4 = (ZDAYN1 * ZIRATE) + ZIWRK3
 
     C                   EVAL(H)   ZIWRK5 = ZIWRK3 / ZIWRK4
     C                   EVAL      ZIWRK5 = 1 - ZIWRK5
     C                   EVAL(H)   WKINT = ZIAMT * ZIWRK5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCFACC - Calculates accrual amounts for cash flow IRS       *
      *            deals.                                             *
      *                                                               *
      *****************************************************************
     C     SRCFACC       BEGSR
 
     C                   EVAL      ZPARPD = ZIEND - ZIBEG
     C                   EVAL      ZFULPD = SZACTD - SZSLID
 
      ** Pro-rate the payment amount in this accrual period.
 
     C                   EVAL      WKINT = CFLA * ZPARPD
 
     C                   IF        ZFULPD <> *ZERO
     C                   EVAL(H)   WKINT = WKINT / ZFULPD
     C                   ELSE
     C                   EVAL      WKINT = *ZERO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE1 - Converts a date into a Midas Day Number.          *
      *                                                               *
      *****************************************************************
     C     SRZDATE1      BEGSR
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZRTCD
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM      *ZERO         ZDAYNO
 
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZRTCD <> *BLANKS
     C                   EVAL      *IN99 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE2 - Converts a Midas Day Number into a date.          *
      *                                                               *
      *****************************************************************
     C     SRZDATE2      BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZDATFM
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZDATE = *ZERO OR
     C                             ZADATE = *BLANKS
     C                   EVAL      *IN99 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLINTC - Calculates the interest between two Day Numbers.  *
      *                                                               *
      *****************************************************************
     C     SRGLINTC      BEGSR
 
      ** Calculate the number of days of the Calculation Method used.
 
     C                   Z-ADD     ZIBEG         ZZBEG
     C                   Z-ADD     ZIEND         ZZEND
     C                   MOVE      ZICALC        ZZCALC
     C                   EXSR      SRZINTDY
                                                                                              CIR013
      ** If calculation method 9 for FRA/IRS/CCF                                              CIR013
     C                   If        ZICALC = 9                                                 CIR013
                                                                                              CIR013
      ** Convert start and end dates to YYYYMMDD                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    ZIBEG                                        CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
     C                   CallB     'ZDATE9'                                                   CIR013
     C                   Parm                    ZIEND                                        CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    @@Rtn                                        CIR013
                                                                                              CIR013
      ** Check if the period contains a Feb 29                                                CIR013
     C                   CallB     'ZFEB29CHK'                                                CIR013
     C                   Parm                    ZZStartDate                                  CIR013
     C                   Parm                    ZZEndDate                                    CIR013
     C                   Parm                    #29Feb                                       CIR013
                                                                                              CIR013
     C                   Endif                                                                CIR013
 
      ** Multiply Rate & Day No. first.
 
     C     ZIAMT         MULT      ZIRATE        ZIWRK1
     C     ZICALC        IFEQ      6
     C     ZICALC        OREQ      9                                                          CIR013
     C     #29Feb        ANDEQ     'Y'                                                        CIR013
     C     ZIWRK1        MULT      INT6DY        ZIWRK2
     C                   ELSE
     C     ZIWRK1        MULT      ZZINDY        ZIWRK2
     C                   ENDIF
 
     C     ZICALC        IFEQ      2
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      7
     C     CIR004        ANDEQ     'Y'
     C     ZICALC        OREQ      0                                                         CER016A
     C     ZIWRK2        DIV(H)    36000         ZINTR
     C                   ENDIF
 
     C     ZICALC        IFEQ      1
     C     ZICALC        OREQ      4
     C     ZICALC        OREQ      9                                                          CIR013
     C     #29Feb        ANDEQ     'N'                                                        CIR013
     C     ZIWRK2        DIV(H)    36500         ZINTR
     C                   ENDIF
 
     C     ZICALC        IFEQ      6
     C     ZICALC        OREQ      9                                                          CIR013
     C     #29Feb        ANDEQ     'Y'                                                        CIR013
     C     ZIWRK2        DIV(H)    36600         ZINTR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZINTDY - Calculates the No. of Days the given Calculation  *
      *             Method used.                                      *
      *                                                               *
      *****************************************************************
     C     SRZINTDY      BEGSR
 
     C                   CALLB     'ZINTDY'
     C                   PARM      *BLANKS       ZRTCDIN
     C                   PARM      *ZERO         ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM      *ZERO         INT6DY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRICD - Record Identification Codes Subroutine.             *
      *                                                               *
      *****************************************************************
     C     SRRICD        BEGSR
 
     C                   EVAL      *IN01 = *OFF
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN04 = *OFF
     C                   EVAL      *IN05 = *OFF
     C                   EVAL      *IN06 = *OFF
     C                   EVAL      *IN07 = *OFF
 
     C                   IF        RECI = 'D' OR RECI = 'E' OR
     C                             RECI = 'M' OR RECI = 'R'
 
      ** Begin Record Identification
      ** ===========================
 
     C                   SELECT
 
      ** Foreign Exchange
      ** ----------------
 
     C                   WHEN      RCDT = 'B'
     C                   EVAL      *IN01 = *ON
 
      ** Money Market Loans and Deals
      ** ----------------------------
 
     C                   WHEN      RCDT = 'C'
     C                   EVAL      *IN02 = *ON
 
     C                   IF        NOTD < *ZERO
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
 
      ** Negotiable Assets Purchased
      ** ---------------------------
 
     C                   WHEN      RCDT = 'D'
     C                   EVAL      *IN03 = *ON
 
     C                   IF        NIDT = *ZERO
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
 
     C                   IF        SADT = *ZERO
     C                   EVAL      *IN23 = *ON
     C                   ENDIF
 
      ** Negotiable Assets Sold
      ** ----------------------
 
     C                   WHEN      RCDT = 'E'
     C                   EVAL      *IN06 = *ON
 
      ** Forward Rate Agreements/Interest Rate Swaps
      ** -------------------------------------------
 
     C                   WHEN      RCDT = 'G'
     C                   EVAL      *IN07 = *ON
 
     C                   ENDSL
 
     C                   LEAVESR
 
     C                   ENDIF
 
      ** Trailer Record
      ** --------------
 
     C                   IF        RECI = 'T'
     C                   EVAL      *IN04 = *ON
     C                   LEAVESR
     C                   ENDIF
 
      ** Catchall
      ** --------
 
     C                   EVAL      *IN05 = *ON
 
      ** End Record Identification
      ** =========================
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAENN - Writes the Accruals Using N-T-R Extract Header.     *
      *                                                               *
      *****************************************************************
     C     SRAENN        BEGSR
 
     C                   CLEAR                   AENN
 
     C                   EVAL      NNRECI = 'A'
     C                   EVAL      NNDTYP = '00'
     C                   EVAL      NNDLST = '00'
     C                   EVAL      NNCLAS = '    '                                            CDL038
     C                   EVAL      NNTDAT = TDAT
     C                   EVAL      NNACLD = BKALDI
 
     C                   WRITE     ACCEXNNF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAENO - Writes the Accruals Using N-T-R Extract Details.    *
      *           As for RS and RX, writes accruals Using Base Rate   *
      *           Extract Details                                     *
      *                                                               *
      *****************************************************************
     C     SRAENO        BEGSR
 
     C                   CLEAR                   AENO
 
     C                   SELECT
 
     C                   WHEN      WDetTyp = 'E'
 
     C                   IF        *IN01 = *ON AND
     C                             *IN50 = *ON AND
     C                             *IN51 = *OFF
 
     C                   CLEAR                   AENO
 
     C                   EVAL      NORECI = 'D'
 
     C                   IF        *IN56 = *ON
     C                   EVAL      NOCCY = IDCY
     C                   EVAL      NOPCPL = IDAM
     C                   ELSE
     C                   EVAL      NOCCY = ILCY
     C                   EVAL      NOPCPL = ILAM
     C                   ENDIF
 
     C                   EVAL      NODTYP = DTYP
     C                   EVAL      NODLST = DLST
     C                   EVAL      NOCLAS = CLAS                                              CDL038
     C                   EVAL      NOCNUM = CNUM
     C                   EVAL      NODLNO = DLNO
     C                   EVAL      NOACFD = OTDT
     C                   EVAL      NOACTD = VDAT
     C                   EVAL      NOINTR = ICIR
     C                   EVAL      NOAMAD = AMAD
     C                   EVAL      NOAMTA = AMTA
     C                   EVAL      NORCDC = RCDC
     C                   EVAL      NOBRCA = BRCA
     C                   EVAL      NOCMPYM = A8CMCD
     C                   EVAL      NOUBRTT = *ZERO
     C                   EVAL      NOTBRTT = *ZERO
     C                   EVAL      NOURTPI = 'N'
     C                   EVAL      NOTRTPI = 'N'
     C                   EVAL      NOFLRIND = 'N'
 
     C                   WRITE     ACCEXNOF
 
     C                   ENDIF
 
     C                   IF        *IN03 = *ON AND
     C                             *IN54 = *ON AND
     C                             *IN59 = *ON
 
     C                   CLEAR                   AENO
 
     C                   EVAL      NORECI = 'E'
     C                   EVAL      NOCCY = CCY
     C                   EVAL      NODTYP = DTYP
     C                   EVAL      NODLST = DLST
     C                   EVAL      NOCLAS = CLAS                                              CDL038
     C                   EVAL      NOCNUM = ISCN
     C                   EVAL      NODLNO = DLNO
 
     C                   IF        *IN65 = *ON
     C                   EVAL      NOACFD = IACD
     C                   ELSE
     C                   EVAL      NOACFD = SLID
     C                   ENDIF
 
     C                   EVAL      NOACTD = MDAT
     C                   EVAL      NOINTR = YRAT
     C                   EVAL      NOPCPL = PUPR
     C                   EVAL      NOAMAD = AMTAD
     C                   EVAL      NOAMTA = AMTTA
     C                   EVAL      NORCDC = RCDC
     C                   EVAL      NOBRCA = BRCA
     C                   EVAL      NOCMPYM = A8CMCD
     C                   EVAL      NOUBRTT = *ZERO
     C                   EVAL      NOTBRTT = *ZERO
     C                   EVAL      NOURTPI = 'N'
     C                   EVAL      NOTRTPI = 'N'
     C                   EVAL      NOFLRIND = 'N'
 
     C                   WRITE     ACCEXNOF
 
     C                   ENDIF
 
     C                   WHEN      WDetTyp = 'A'
 
     C                   IF        (*IN74 = *ON AND *IN10 = *ON) OR
     C                             (*IN74 = *ON AND *IN11 = *ON) OR
     C                             (*IN74 = *OFF AND *IN10 = *ON) OR
     C                             (*IN74 = *OFF AND *IN11 = *ON) OR
     C                             (*IN10 = *OFF AND *IN11 = *OFF)
 
     C                   CLEAR                   AENO
 
     C                   IF        (*IN74 = *ON AND *IN10 = *ON) OR
     C                             (*IN74 = *ON AND *IN11 = *ON)
     C                   EVAL      NORECI = 'G'
     C                   ELSE
     C                   EVAL      NORECI = 'D'
     C                   ENDIF
 
     C                   EVAL      NOCCY = CCY
     C                   EVAL      NODTYP = DTYP
     C                   EVAL      NODLST = DLST
     C                   EVAL      NOCLAS = CLAS                                              CDL038
     C                   EVAL      NOCNUM = CNUM
     C                   EVAL      NODLNO = DLNO
     C                   EVAL      NOACFD = ACFD
     C                   EVAL      NOACTD = ACTD
     C                   EVAL      NOINTR = INTR
     C                   EVAL      NOPCPL = PCPL
     C                   EVAL      NOAMAD = AMAD
     C                   EVAL      NOAMTA = AMTA
     C                   EVAL      NORCDC = RCDC
     C                   EVAL      NOBRCA = BRCA
     C                   EVAL      NOCMPYM = A8CMCD
     C                   EVAL      NOUBRTT = UBRTT
     C                   EVAL      NOTBRTT = TBRTT
     C                   EVAL      NOTEINR = TEINR
     C                   EVAL      NOURTPI = URTPI
     C                   EVAL      NOTRTPI = TRTPI
     C                   EVAL      NOTACFD = TACFD
     C                   EVAL      NOTACTD = TACTD
     C                   EVAL      NOTAMAD = TAMAD
     C                   EVAL      NOTAMTA = TAMTA
     C                   EVAL      NOCLRAT = CLRAT
     C                   EVAL      NOFLRAT = FLRAT
     C                   EVAL      NOFLRIND = FLRIND
     C                   EVAL      NOOTUI = OTUI
     C                   EVAL      NOTTUI = TTUI
 
     C                   WRITE     ACCEXNOF
 
     C                   ENDIF
 
     C                   WHEN      WDetTyp = 'D'
 
     C                   IF        (*IN01 = *ON AND *IN47 = *ON) OR
     C                             (*IN02 = *ON AND *IN52 = *OFF) OR
     C                             (*IN03 = *ON AND *IN54 = *ON) OR
     C                             (*IN03 = *ON AND *IN55 = *ON)
 
     C                   CLEAR                   AENO
 
     C                   SELECT
 
     C                   WHEN      *IN01 = *ON AND *IN47 = *ON
     C                   EVAL      NORECI = 'F'
 
     C                   WHEN      *IN55 = *ON AND *IN59 = *ON
     C                   EVAL      NORECI = 'E'
 
     C                   OTHER
     C                   EVAL      NORECI = 'D'
 
     C                   ENDSL
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON OR *IN02 = *ON
     C                   EVAL      NOCCY = CCY
 
     C                   WHEN      *IN01 = *ON
     C                   EVAL      NOCCY = SPLC
 
     C                   ENDSL
 
     C                   EVAL      NODTYP = DTYP
     C                   EVAL      NODLST = DLST
     C                   EVAL      NOCLAS = CLAS                                              CDL038
 
     C                   IF        *IN03 = *ON
     C                   EVAL      NOCNUM = ISCN
     C                   ELSE
     C                   EVAL      NOCNUM = CNUM
     C                   ENDIF
 
     C                   EVAL      NODLNO = DLNO
 
     C                   SELECT
 
     C                   WHEN      (*IN03 = *ON AND *IN55 = *ON) OR
     C                             (*IN01 = *ON AND *IN47 = *OFF)
     C                   EVAL      NOACFD = VDAT
 
     C                   WHEN      *IN01 = *ON AND *IN47 = *ON
     C                   EVAL      NOACFD = OTDT
 
     C                   WHEN      *IN65 = *OFF
     C                   EVAL      NOACFD = SLID
 
     C                   WHEN      (*IN65 = *ON  AND
     C                              *IN03 = *ON  AND
     C                              *IN54 = *ON) OR
     C                             (*IN65 = *ON  AND
     C                              *IN02 = *ON)
     C                   EVAL      NOACFD = IACD
 
     C                   ENDSL
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON AND *IN54 = *ON
     C                   EVAL      NOACTD = TODAT
 
     C                   WHEN      *IN03 = *ON AND *IN55 = *ON
     C                   EVAL      NOACTD = MDAT
 
     C                   WHEN      *IN02 = *ON AND *IN70 = *OFF
     C                   EVAL      NOACTD = NIDT
 
     C                   WHEN      *IN02 = *ON AND *IN70 = *ON
     C                   EVAL      NOACTD = MDAT
 
     C                   WHEN      *IN01 = *ON AND *IN47 = *OFF
     C                   EVAL      NOACTD = OTDT
 
     C                   WHEN      *IN01 = *ON AND *IN47 = *ON
     C                   EVAL      NOACTD = VDAT
 
     C                   ENDSL
 
     C                   IF        *IN02 = *ON
     C                   EVAL      NONOTD = NOTD
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      (*IN59 = *ON AND
     C                              *IN03 = *ON AND
     C                              *IN54 = *ON)
     C                   EVAL      NOINTR = INTR
     C                   EVAL      NOPCPL = FVAL
 
     C                   WHEN      *IN03 = *ON
     C                   EVAL      NOINTR = YRAT
     C                   EVAL      NOPCPL = PUPR
 
     C                   WHEN      *IN02 = *ON
     C                   EVAL      NOINTR = INTR
     C                   EVAL      NOPCPL = PCPL
 
     C                   WHEN      *IN01 = *ON
     C                   EVAL      NOPCPL = SPLA
 
     C                   ENDSL
 
     C                   EVAL      NOAMAD = AMAD
 
     C                   IF        *IN02 = *OFF OR *IN21 = *ON
     C                   EVAL      NOAMTA = AMTA
     C                   ENDIF
 
     C                   EVAL      NORCDC = RCDC
     C                   EVAL      NOBRCA = BRCA
     C                   EVAL      NOCMPYM = A8CMCD
     C                   EVAL      NOUBRTT = *ZERO
     C                   EVAL      NOTBRTT = *ZERO
     C                   EVAL      NOURTPI = 'N'
     C                   EVAL      NOTRTPI = 'N'
     C                   EVAL      NOFLRIND = 'N'
 
     C                   WRITE     ACCEXNOF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAENP - Writes the Accruals Using N-T-R Extract Trailer.    *
      *                                                               *
      *****************************************************************
     C     SRAENP        BEGSR
 
     C                   CLEAR                   AENP
 
     C                   EVAL      NPRECI = 'T'
     C                   EVAL      NPKEY = 'ZZZ9999'
     C                   EVAL      NPNORE = RECRIT
     C                   EVAL      NPHRWN = INT(1)
     C                   EVAL      NPHRDC = DEC(1)
 
     C                   WRITE     ACCEXNPF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAURPT - Writes the Audit Report.                           *
      *                                                               *
      *****************************************************************
     C     SRAURPT       BEGSR
 
     C                   EVAL      RNLRA = NLRA
     C                   EVAL      RVLAF = VLAF
     C                   EVAL      RVLAL = VLAL
     C                   EVAL      RRECR = RECRED
     C                   EVAL      RINT2 = INT(2)
     C                   EVAL      RDEC2 = DEC(2)
     C                   EVAL      RRECT = RECRIT
     C                   EVAL      RINT1 = INT(1)
     C                   EVAL      RDEC1 = DEC(1)
 
     C                   WRITE     HEADER
 
     C                   SELECT
 
     C                   WHEN      *INU7 = *ON
     C                   WRITE     DBERROR
 
     C                   WHEN      *IN40 = *ON
     C                   WRITE     NODTLS
 
     C                   OTHER
     C                   WRITE     CONTROL
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not been called already.
 
     C                   IF        WRun = *BLANK
 
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
      ** If *PSSR already ran, write the final detail plus audit
      ** report and return to the calling program.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   EXSR      SRAURPT
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Midas DL Cash Flow Schedule Key List
 
     C     KCFSC         KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
 
      ** Set the Database Program Name.
 
     C                   EVAL      DBPgm = 'DL5110'
 
     C                   MOVEA     CPY@          BIS@             80                          CSC042
     C                   Z-ADD     0             ##BNDX            4 0                        CSC042
     C     *LIKE         DEFINE    ##BNDX        B                                            CSC042
     C     *LIKE         DEFINE    ##BNDX        ##BSV                                        CSC042
      ** Initialised data structures
 
     C                   CLEAR                   AEAN
     C                   CLEAR                   AEAO
     C                   CLEAR                   AEAP
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the Date Format Indicator.
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   EVAL      ZDATFM = 'M'
     C                   ENDIF
 
      ** Access General Ledger Details.
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the Accrue on Last Day Indicator.
 
     C                   IF        BKALDI = 'Y'
     C                   EVAL      *IN58 = *ON
     C                   ENDIF
 
      ** Set the Title Date.
 
     C                   IF        BKAPDT < BJDNWD
     C                   EVAL      TDAT = BKAPDT + 1
     C                   ELSE
     C                   EVAL      TDAT = BJDNWD
     C                   ENDIF
 
      ** Set the Report Control Date.
 
     C                   SELECT
 
     C                   WHEN      BKAPDT < BJDNWD AND
     C                             BKALDI = 'Y'
     C                   EVAL      REPCD = BKAPDT
 
     C                   WHEN      BKAPDT < BJDNWD
     C                   EVAL      REPCD = BKAPDT + 1
 
     C                   WHEN      BKALDI = 'Y'
     C                   EVAL      REPCD = BJDNWD - 1
 
     C                   OTHER
     C                   EVAL      REPCD = BJDNWD
 
     C                   ENDSL
 
      ** Access Dealing Details.
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDDEALPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check for the Negotiable Assets Accruals Indicator.
 
     C                   IF        BNNAIA = 'Y'
     C                   EVAL      *IN59 = *ON
     C                   ENDIF
 
      ** Access Module Details.
 
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 104
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access FRA/IRS Details if necessary.
 
     C                   IF        BGFIIN = 'Y'
 
     C                   CALL      'AOFAISR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDFAIS        PARM      SDFAIS        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFAISPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 105
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      BQHFRA = 'N'
 
     C                   ENDIF
 
      ** Access SAR details to see if all mapped enhancements in the
      ** Switchable Feature Array are enabled.
 
     C                   FOR       WCtr = 1 TO %ELEM(SF)
 
     C                   EVAL      PSARD = SF(WCtr)
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      SFI(WCtr) = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = WCtr
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   IF        CIR001 = 'Y'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
