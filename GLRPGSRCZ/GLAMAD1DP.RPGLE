     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL A/c maintenance display - 1st det'l scrn')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD1DP - Account Maintenance Display - First Detail Scrn  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25803           Date 28Aug09               *
      *                 BUG24157           Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03Aug06               *
      *                 222549             Date 06Jun06               *
      *                 220101             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3365            Date 24Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 225488             Date 10Mar04               *
      *                 CGL029             Date 27Mar04               *
      *                 213342             Date 24Jun03               *
      *                 208237             Date 24Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 29Jun00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 28Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 19Oct99               *
      *                 CAP014             Date 22Dec99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25803 - German Feature fld 'Subject to KWG 24c reporting' *
      *             shown on Account Master Details Enquiry even when *
      *             CER047 is not *ON.                                *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y                            *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD027A- Conversion Of Customer Number to Alpha (additional) *
      *  222549 - API version of Accounts master enquiry should be    *
      *           used in the linked enquiry from the Customer Account*
      *           Balances Enquiry. Introduced linked enquiry         *
      *           processing in the API version of GL accounts        *
      *           maintenance.                                        *
      *  220101 - Primary Account is shown as Secondary Account.      *
      *           If Retail Numbers are used, the Retail Number       *
      *           of the Primary Account should be shown.             *
      *           If Retail Numer are not used, the currency is       *
      *           is missing from the GL account number.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3365 - Set display ind in89 for green screen testing.     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225488 - Underline IBAN field only when IBAN is amendable.   *
      *           Recompiled due to changes in DSPF/GLAMADDDF.        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  213342 - Default statement fee amount should be displayed if *
      *           statement charges (TSTMC) is 'Y' in RE ICD by CCY.  *
      *           Recompiled due to changes in DSPF/GLAMADDDF.        *
      *  208237 - IBAN code should be protected if the IBAN method    *
      *           used is not equal to 1.                             *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  178695 - Review some validation with 'PB' Module             *
      *           in Account Maintenance Processing                   *
      *  176883 - Process of Record "Not Found" added after the call  *
      *           of AOACODR0 and AOCURRR0.                           *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *         - 'Private Banking' Module.                           *
      *  CAP014 - Repair function enhancements                        *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLAMADDDF CF   E             WORKSTN IGNORE(GLAMADD2:GLAMADD3:
     F                                            GLAMADD4:GLAMADD5)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     FRELINKL1  IF   E           K DISK    INFSR(*PSSR)
                                                                                CPB001
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)  USROPN                 CPB001
     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)                         178695
 
      *****************************************************************
      *                                                               *
      *  ID F  C  H  L    FUNCTION OF INDICATORS                      *
      *                                                               *
      *  01 - CFT004 switched on                                      *
      *  06 - Control Ind. for display of CMD6                        *
      *  14 - Charge on Number of Daily Statement                     *
      *  27 - Statement balances in Euros available                   *
      *  28 - Portfolio Management is present                         *
      *     - or Private Banking is present                           *         CPB001
      *  29 - Retail Number is used                                   *
      *  30 - Insert Mode                                             *
      *  32 - Enquiry Mode                                            *
      *  35 - Microfiche is present                                   *
      *  41 - Authorise to Amend                                      *
      *  42 - Set on if the IBAN method is not 1                      *                       208237
      *  46 - Secondary account                                       *
      *  47 - Prime account                                           *
      *  48 - Retail A/c No. Required                                 *
      *  50-73 -  Field Error - highlight screen fields               *
      *  74 - Profit Centres Used                                     *
      *  75 - Display date account closed                             *
      *  76 - Display Interest Taxable                                *
      *  77 - Display Statement Charge & Fee Amount                   *
      *  78 - Display Subject to A/c Charge & A/c Charge Amount       *
      *  87 - Trade Innovation is present                             *
      *  96 - Subfile control                                         *
      *  97 - Subfile end                                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     DEMSDS          E DS                  EXTNAME(EMDTA) DTAARA(EMSDS)                       222549
     D CUSTNO                141    146                                                       222549
     D*CUSTN****             141    146  0                                            222549 CSD027A
     D CUSTN                 141    146                                                      CSD027A
     D CURRCY                147    149                                                       222549
     D ACCODE                150    159                                                       222549
     D ACCDN                 150    159  0                                                    222549
     D ACCSEQ                160    161                                                       222549
     D ACSQN                 160    161  0                                                    222549
     D BRANCH                162    162                                                       222549
     D AREF15                141    161                                                       222549
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(25) CTDATA PERRCD(25)
 
     D @EI             S              1    DIM(33)
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          S            256
 
     D ZMUSER          DS            17
      ** ZMUSER data layout
     D  DBRN                  11     13
 
     D RUNDAT          DS            13
      ** Rundate data area
     D  AGMBIN                13     13
 
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
     D OKAcPrim      E DS                  EXTNAME(GLEAMADPD)
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)
     D NA1BFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D GlRiAcod      E                     EXTFLD(QQACOD)                                     CGL029
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for Retail Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SdGelrAccd    E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for General Ledger Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
                                                                                              208237
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  208237
      ** EXTERNAL DS FOR BRANCH DETAILS                                                       208237
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External DS for Portfolio Customer Details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D SdAcodAccd    E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Account Code Details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** External DS for Portfolio Management ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB001
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Customer Details                                       CPB001
                                                                                CPB001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
                                                                                CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
      * Third DS for access programs, very long data structure                  CPB001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc                           176883
     D Ix              S              3P 0                                      176883
                                                                                176883
     D CER047          S              1A                                                    BUG24157
                                                                                            BUG24157
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
     IFUSIONF1
     I              BRCA                        FBRCA
     I              CNUM                        FCUST
     I              CCY                         LTCCY
     I              ACOD                        FACOD
     I              ACSQ                        FACSQ
     I              LTAB                        LTABD
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *                                                                         CPB001
     C     *IN28         IFEQ      *ON                                          CPB001
     C                   CLOSE     PMPORTLL                                     CPB001
     C                   ENDIF                                                  CPB001
      *
      ** Return
      *
     C     @INKC         IFEQ      '1'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Access Currency details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *                                                                         176883
      * Not Found                                                               176883
     C     @RTCD         IFNE      *BLANKS                                      176883
     C                   MOVEL     'N'           DDCCYOK                        176883
     C                   ADD       1             Ix                             176883
     C                   MOVEL     'DDCCY '      FldNameArr(Ix)                 176883
     C                   MOVEL     'RE71033'     MsgIdArr(Ix)                   176883
     C                   END                                                    176883
      *
      ** Access Account Code details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOACODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      DDACOD        @ACOD             4                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C                   PARM      DDACOD        @ACOD            10                          CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
      *                                                                         176883
      * Not Found                                                               176883
     C     @RTCD         IFNE      *BLANKS                                      176883
     C                   MOVEL     'N'           DDACODOK                       176883
     C                   ADD       1             Ix                             176883
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)                 176883
     C                   MOVEL     'RE71037'     MsgIdArr(Ix)                   176883
     C                   END                                                    176883
      *
      ** Set screen indicators
     C                   EXSR      SRSETI
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OKAcPrim      @EI
      *
      ** Set screen error inds according to status of 'OK' Flags
      *
     C                   Z-ADD     10            C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     33
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
                                                                                            BUG24157
     C                   IF        CER047 = 'Y' and DD24COK = 'N'                           BUG24157
     C                   EVAL      *IN71 = *ON                                              BUG24157
     C                   ELSEIF    CER047 = 'Y' and DD24COK = 'Y'                           BUG24157
     C                   EVAL      *IN71 = *Off                                             BUG24157
     C                   ENDIF                                                              BUG24157
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
      *
      ** Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC1
     C                   WRITE     GLAMADD1
     C                   WRITE     GLAMADF1
      *
      ** Read details screen, if not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLAMADD1                               99
     C                   ENDIF
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKF         @INKF
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKI         @INKI
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *IN49         @IN49
      *
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSETI - SET SCREEN INDICATORS
      *****************************************************************
     C     SRSETI        BEGSR
      *
     C                   MOVE      *OFF          *IN30
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN32
     C***  DDACTN        IFEQ      'E'                                          CAP014
     C***                MOVE      *ON           *IN32                          CAP014
     C***                ENDIF                                                  CAP014
      *                                                                         CAP014
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & DEAL NUMBER)      CAP014
      *                                                                         CAP014
     C     @EDTFD        COMP      'Y'                                3232      CAP014
      *
      ** If enquiry mode and AMDACC not equal 0 then
      ** seton indicator to display it
     C                   MOVE      *OFF          *IN75
     C     *IN32         IFEQ      '1'
     C     DDDACC        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN29
     C     AMATYP        IFEQ      'R'
     C                   MOVE      *ON           *IN29
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN44
     C     RINOALT       IFGT      *ZERO
     C                   MOVE      *ON           *IN44
     C                   ENDIF
      *
      ** Charge on Number of Daily Statement
     C                   MOVE      *OFF          *IN14
     C     CNDS          IFEQ      'Y'
     C                   MOVE      *ON           *IN14
     C                   ENDIF
      *
      ** Retail Number Used
     C                   MOVE      *OFF          *IN48
     C     BMRANR        IFEQ      'Y'
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
      ** Profit Centres Used
     C                   MOVE      *OFF          *IN74
     C     BKPRCU        IFEQ      'Y'
     C                   MOVE      *ON           *IN74
     C                   ENDIF
      *
      ** Microfiche
     C                   MOVE      *OFF          *IN35
     C     BGMFIC        IFEQ      'Y'
     C                   MOVE      *ON           *IN35
     C                   ENDIF
      *
      ** Portfolio Management
      ** or Private Banking Module                                              CPB001
     C                   MOVE      *OFF          *IN28
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   OPEN      PMPORTLL                                     CPB001
     C                   MOVE      *ON           *IN28
     C                   ENDIF
      *
      ** Trade Innovation
     C                   MOVE      *OFF          *IN87
     C     BGN3ST        IFEQ      'Y'
     C                   MOVE      *ON           *IN87
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN27
     C     CEU013        IFEQ      'Y'
     C     A6INCY        ANDEQ     'Y'
     C     BJRDNB        ANDGE     A6TPSD
     C                   MOVE      *ON           *IN27
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
      *
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
     C                   MOVE      *OFF          *IN38
     C     @RTCD         IFEQ      'PMA0008'
     C     @RTCD         OREQ      'PMA0009'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDNE     'B'
     C     AMATYP        ANDNE     'R'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDEQ     'B'
     C     AMATYP        ANDNE     'R'
     C     AMATYP        ANDNE     'N'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDNE     'B'
     C     A5ACTY        ANDNE     'R'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDEQ     'B'
     C     A5ACTY        ANDNE     'R'
     C     A5ACTY        ANDNE     'N'
      *
     C                   MOVE      *ON           *IN38
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         CPB001
      ** Restrict output of Portfolio Reference                                 CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUSN        @KEY10                         CPB001
     C                   CALLB     'AOCUSTR1'                                   CPB001
     C                   PARM      *BLANKS       @RTCD                          CPB001
     C                   PARM      '*KEY   '     @OPTN                          CPB001
     C                   PARM                    @KEY10           10            CPB001
     C                   PARM      *BLANKS       @KEY7             7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
      *                                                                         CPB001
     C     @RTCD         IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVE      *OFF          *IN38                          CPB001
     C                   ELSE                                                   CPB001
     C     BGPFMG        IFNE      'Y'                                          CPB001
     C                   MOVE      *ON           *IN38                          CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
     C     A5ACTY        IFEQ      'R'                                          CPB001
     C     *IN38         ANDEQ     *OFF                                         CPB001
     C     *IN28         ANDEQ     *ON                                          CPB001
     C     DDPTFR        IFEQ      *BLANKS                                      CPB001
     C**********         MOVEL     DDCUSN        KPCNUM            6 0                 CPB001 CSD027
     C                   MOVEL     DDCUSN        KPCNUM            6                          CSD027
     C                   MOVE      DDCUSN        WWCNUM                         178695
     C                   MOVE      DDCCY         WWCCY                          178695
     C                   MOVE      DDACOD        WWACOD                         178695
     C                   MOVE      DDACSQ        WWACSQ                         178695
     C                   MOVE      'N'           WWVAL             1            CPB001
     C     KPCNUM        SETLL     PMPORTLL                                     CPB001
     C     KPCNUM        READE     PMPORTLL                               88    CPB001
      *                                                                         CPB001
     C     *IN88         DOWEQ     *OFF                                         CPB001
     C     WWVAL         ANDEQ     'N'                                          CPB001
     C     PNDPCL        IFEQ      0                                            CPB001
     C                   MOVE      PNPTFR        WWPTFR            4            178695
     C     PTFRK         CHAIN     ACCPTFR                            81        178695
      *                                                                         178695
     C     *IN81         IFEQ      '0'                                          178695
     C     KPCNUM        READE     PMPORTLL                               88    178695
     C                   ELSE                                                   178695
     C                   MOVE      PNPTFR        DDPTFR                         CPB001
     C                   MOVE      'Y'           WWVAL                          CPB001
     C                   ENDIF                                                  178695
      *                                                                         178695
     C                   ELSE                                                   CPB001
     C     KPCNUM        READE     PMPORTLL                               88    CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDDO                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *
      ** Test the A/c if it is a prime account
     C                   MOVE      *OFF          *IN47
     C     AMLTAS        IFEQ      99
     C                   MOVE      *ON           *IN47
     C                   ENDIF
      *
      ** Test if it is a secondary account
     C                   MOVE      *OFF          *IN46                                        220101
     C     *IN47         IFEQ      *OFF
      *
     C**************     MOVE      *OFF          *IN46                                        220101
     C     RELINK        CHAIN     RELINKL1                           81
     C     *IN81         IFEQ      *OFF
     C                   MOVE      *ON           *IN46
     C                   ENDIF
     C                   ENDIF
 
      ** Set on *IN89 if user allowed to amend TI Account No. & Suffix
      ** But only initially set it off if the fields are not already
      ** shown in error.
     C                   if        DDTIACOK = 'Y' and DDTIANOK = 'Y'
     C                                and DDTIASOK = 'Y'
 
      ** Protect TI fields.                                                                  BUG3365
     C                   eval      *in89 = *off
 
     C                   endif
 
     C**********         if        DDTIAC = 'Y' and                                          BUG3365
     C**********                     (DDACTN = 'I' or                                        BUG3365
     C**********                        (DDACTN = 'A' and DDTIAN = *blanks                   BUG3365
     C**********                         and DDTIAS = *blanks                                BUG3365
     C**********                     (DDACTN = 'I' or                                        BUG3365
     C                   if        DDTIAC = 'Y' and DDACTN = 'I' or                          BUG3365
     C                             (DDTIAC = 'Y' and DDACTN = 'A'                            BUG3365
     C                             and DDTIANOK = 'N') or                                    BUG3365
     C                             (DDTIAC = 'Y' and DDACTN = 'A'                            BUG3365
     C                             and DDTIASOK = 'N')                                       BUG3365
     C**********                        )                                                    BUG3365
     C**********                     )                                                       BUG3365
 
      ** TI fields input capable.                                                            BUG3365
     C                   eval      *in89 = *on
 
     C                   endif
 
      ** Prepare Amend Authorisation
     C                   MOVE      'A'           @ZACTN
     C                   MOVE      DBRN          @BRCA
     C                   MOVE      *OFF          *IN41
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRAUTH
     C     @ERR          IFEQ      0
     C                   MOVE      *ON           *IN41
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN41
     C                   ENDIF
      *                                                                                       222549
      ** Check if this is a linked enquiry                                                    222549
      *                                                                                       222549
     C     *LOCK         IN        EMSDS                                                      222549
     C                   MOVE      RQDTD         MODID             2                          222549
     C                   OUT       EMSDS                                                      222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   MOVEL     '1'           *IN36                                        222549
     C                   ENDIF                                                                222549
      *
      ** If enquiry mode and user authorised to amend and if account
      ** flagged for closure, seton indicator to forbid amend.
     C                   MOVE      *ON           *IN06
     C     *IN32         IFEQ      *ON
     C     *IN41         ANDEQ     *ON
     C     AMACST        IFEQ      'C'
     C     *IN36         OREQ      '1'                                                        222549
     C                   MOVE      *OFF          *IN06
     C                   ENDIF
     C                   ENDIF
      *
     C     BGWDPR        IFEQ      'Y'
     C     AMATYP        ANDEQ     'R'
     C     BGSWRT        IFEQ      'Y'
     C     BGNTST        OREQ      'Y'
     C     FACH          OREQ      'Y'
     C     TSTMC         OREQ      'Y'
      *
      ** Show Interest Taxable field
     C                   MOVE      *OFF          *IN76
     C     BGNTST        IFEQ      'Y'
     C                   MOVE      *ON           *IN76
     C                   ENDIF
      *
      ** Show Statement Charge and Fee Amount field
     C                   MOVE      *OFF          *IN77
     C     TSTMC         IFEQ      'Y'
     C                   MOVE      *ON           *IN77
     C                   ENDIF
      *
      ** Show Subject to A/c Charge and A/c Charge Amount field
     C                   MOVE      *OFF          *IN78
     C     FACH          IFEQ      'Y'
     C                   MOVE      *ON           *IN78
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                         CFT004
      ** Show International Bank Account Numbers IBAN                           CFT004
     C                   MOVE      *OFF          *IN01                          CFT004
     C     CFT004        IFEQ      'Y'                                          CFT004
     C                   MOVE      *ON           *IN01                          CFT004
     C                   ENDIF                                                  CFT004
      *                                                                         CFT004
      *
      ** Enable/Disable Roll Function Keys
     C                   MOVE      *OFF          *IN25
     C     @EIN25        IFEQ      'Y'
     C     *IN36         ANDEQ     '0'                                                        222549
     C                   MOVE      *ON           *IN25
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMA1XC03
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAUTH - CHECK ACTION CODE AND BRANCH AUTHORITY
      *****************************************************************
     C     SRAUTH        BEGSR
      *
      ** Multi-branch system, user must be authorised to action on
      ** branch.
      *
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @BRCA             3
     C                   PARM                    @ERR              1 0
      *
     C                   ELSE
      *
      ** Single branch system, check user is authorised to action code
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      ** Account (IN SCREEN FORMAT - First)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NA1BFilFmt
      *
      ** Output Only fields
     C                   PARM                    DDDACC
     C                   PARM                    DDLINK
     C                   PARM                    DDFAMT
      *
      ** ICD
     C                   PARM                    CNDS              1
     C                   PARM                    FACH              1
     C                   PARM                    TSTMC             1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      *
     C                   PARM                    @EIN25            1
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKF             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @IN49             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C/COPY WNCPYSRC,GLAMA1XC01
      *
      ** Key list to access Linked Accounts
     C     RELINK        KLIST
     C                   KFLD                    AMBRCA
     C                   KFLD                    AMCNUM
     C                   KFLD                    AMCCY
     C                   KFLD                    AMACOD
     C                   KFLD                    AMACSQ
      *                                                                         178695
      **  DEfine key list to access ACCPTFR                                     178695
     C     PTFRK         KLIST                                                  178695
     C                   KFLD                    WWPTFR            4            178695
     C**********         KFLD                    WWCNUM            6 0                 178695 CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWCCY             3            178695
     C**********         KFLD                    WWACOD            4 0                 178695 CGL029
     C                   KFLD                    WWACOD           10 0                        CGL029
     C                   KFLD                    WWACSQ            2 0          178695
      *
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      **  GET RUNDAT to access multi-branching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD1DP'   DBPGM
     C                   OUT       LDA
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU013 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CEU013'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     'N'           CEU013            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *                                                                         CFT004
      ** Access SAR file to determine if CFT004 is present.                     CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
     C     @RTCD         IFNE      *BLANKS                                      CFT004
     C     @RTCD         ANDNE     '*NRF   '                                    CFT004
     C     *LOCK         IN        LDA                                          CFT004
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT004
     C                   Z-ADD     1             DBASE                          CFT004
     C                   MOVEL     'CFT004'      DBKEY                          CFT004
     C                   OUT       LDA                                          CFT004
     C                   SETON                                        U7U8LR    CFT004
     C                   EXSR      *PSSR                                        CFT004
     C                   ENDIF                                                  CFT004
     C                   MOVEL     'N'           CFT004            1            CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004                         CFT004
     C                   ENDIF                                                  CFT004
      *                                                                                     BUG24157
     C                   CALLB     'AOSARDR0'                                               BUG24157
     C                   PARM      *BLANKS       @RTCD                                      BUG24157
     C                   PARM      '*VERIFY'     @OPTN                                      BUG24157
     C                   PARM      'CER047'      @SARD                                      BUG24157
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG24157
                                                                                            BUG24157
     C                   EVAL      CER047 = 'N'                                             BUG24157
     C                   IF        @RTCD = *BLANKS                                          BUG24157
     C                   EVAL      CER047 = 'Y'                                             BUG24157
     C                   ENDIF                                                              BUG24157
                                                                                            BUG24157
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                BUG24157
     C     *LOCK         IN        LDA                                                      BUG24157
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG24157
     C                   EVAL      DBKEY = 'CER047'                                         BUG24157
     C                   EVAL      DBASE = 2                                                BUG24157
     C                   OUT       LDA                                                      BUG24157
     C                   EXSR      *PSSR                                                    BUG24157
     C                   ENDIF                                                              BUG24157
                                                                                            BUG25803
     C                   IF        CER047 = 'Y'                                             BUG25803
     C                   EVAL      *IN70  = *Off                                            BUG25803
     C                   ELSE                                                               BUG25803
     C                   EVAL      *IN70  = *On                                             BUG25803
     C                   ENDIF                                                              BUG25803
      *                                                                                     BUG24157
      *                                                                                       208237
      ** Access Branch details                                                                208237
      *                                                                                       208237
     C                   CALL      'AOBRCHR1'                                                 208237
     C                   PARM      *BLANKS       @RTCD                                        208237
     C                   PARM      '*KEY   '     @OPTN                                        208237
     C                   PARM      AMBRCA        @BRCH             3                          208237
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        208237
      *                                                                                       208237
      ** Not Found                                                                            208237
      *                                                                                       208237
     C     @RTCD         IFNE      *BLANKS                                                    208237
     C                   MOVEL     'N'           DDBRCAOK                                     208237
     C                   ADD       1             Ix                                           208237
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)                               208237
     C                   MOVEL     'RE71040'     MsgIdArr(Ix)                                 208237
     C                   ELSE                                                                 208237
     C     A8GENM        IFEQ      '1'                                                        208237
     C     A8GENM        OREQ      ' '                                                        208237
     C                   MOVE      '0'           *IN42                                        208237
     C                   ELSE                                                                 208237
     C                   MOVE      '1'           *IN42                                        208237
     C                   ENDIF                                                                208237
     C                   ENDIF                                                                208237
      *
      ** Access Default Portfolio Reference details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** Get input fields for use on call to AOPLCSR1
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     *BLANKS       I#BOOK
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLAMA1XC02
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for GL *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY GLCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000
