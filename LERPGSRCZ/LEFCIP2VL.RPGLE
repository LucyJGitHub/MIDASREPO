     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Second screen validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LEFCIP2VL -  Facility Second screen  Validation              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD035306           Date 14Aug15               *
      *  Prev Amend No. MD024398           Date 11May14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR785547           Date 14Jun11               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21957           Date 22Dec08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22100           Date 16Jan09               *
      *                 256564             Date 17Sep08               *
      *                 248127             Date 22Jun07               *
      *                 249841             Date 24Aug07               *
      *                 244684             Date 26Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 BUG11995           Date 18Jul06               *
      *                 239211             Date 31Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 15Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9597            Date 14Dec05               *
      *                 BUG9656            Date 20Dec05               *
      *                 BUG9094            Date 20Jul05               *
      *                 BUG9459            Date 01Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6936            Date 29Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5863            Date 14Feb04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG4351            Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3914            Date 04Aug04               *
      *                 BUG3723            Date 19Jul04               *
      *                 225447             Date 04Mar04               *
      *                 BUG1866            Date 16Apr04               *
/*    *                 BG1958             Date 19Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035306 - Use DTPX in validating drawn types when CLE028    *
      *             is on.                                            *
      *  MD024398 - API Performance Optimisation                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR785547 - Facility Drawing Types validation against         *
      *             Credit Agreement. Selected Drawing Type/s for     *
      *             Tranche should be covered by specified Cr Agreemnt*
      *             Should auto-default from specified Cr Agreemnt as *
      *             well. (Child: AR785548)                           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG21957 - Applied fix 250214 and 249617                     *
      *  250214 - Consider FI/FD on CA when comparing amount of       *
      *           tranche and CA.                                     *
      *  249617 - Use the converted value and not the original amount *
      *           to check if multi-ccy Tranche exceeds Fclty Amount  *
      *  BUG22100 - Validate Late Payment Penalty Fixed Rate          *
      *             during insert of a facility                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248127  - Late Penalty Percentage could not be entered when  *
      *            CLE036 & Syndication Manager are switched off.     *
      *  249841 - DDCDTE should be dependent to CLE006 OR CLE106.     *
      *           Also apply 246880                                   *
      *  246880 - When CLE006=N, restore 'Closing Date' entry value.  *
      *  244684 - Compare Last Availability Date of tranche against   *
      *           that of the CA facility.                            *
      *  CRE026 - Consumer Banking                                    *
      *  BUG11995 - Error message on multi-ccy field not very helpful *
      *  239211 - Amending user is not captured during closure of     *
      *           facility.  Recompile over changes in LEFCSPPD.      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9597- Agent Customer cannot be zero.                      *
      *  BUG9656 - Fixed rate field should not be validated when      *
      *            CLE036 is off.                                     *
      *  BUG9094 - Field Late Payment Amount/Spread not highlighted   *
      *            Pass the correct field name in error. Allows       *
      *            MidasPlus to highlight invalid field value.        *
      *  BUG9459- Closing Date must not be validated if               *
      *           Syndications Manager feature is off.                *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG6936- Only validate agent customer if CLE006 is on        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collaterised Lending (Recompile)  *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3914 - An error should be shown (not warning) when the    *
      *            tranche facility amount is greater than the credit *
      *            agreement facility amount.                         *
      *  BUG3723- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  225447 - Agent customer not correctly updated.               *
      *  BUG1866- Error message should be a warning message           *
/*    *  BG1958 - Corrupted ANUM (Agent Customer) field on FCLTYFM.   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
      *****************************************************************
 
      **  Funding Participant Details file
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL2)
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      *
      **  Credit Agreement File
     FLEFCLTL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL9)
     F                                     PREFIX(LE)
      *                                                                                       CLE029
      **  Severity Codes File                                                                 CLE029
     FSDSVCDL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE029
      *                                                                                       250214
      **  Facility Amendments FI/FD                                                           250214
     FLEFCAML7  IF   E           K DISK    INFSR(*PSSR)                                       250214
     F                                     PREFIX(FA_)                                        250214
      *****************************************************************
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** Ê End of automatically included D-specsÊ
      ** Ê =====================================Ê
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(75)
 
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D*DTS******       S              1    DIM(5)                              Drawing Types BUG3723
     D DTS             S              1    DIM(6)                                            BUG3723
     D DTSca           S              1    DIM(6)                                           AR785547
      ** Rollover types
     D*ROT******       S              1    DIM(6)                                             CLE064
     D ROT             S              1    DIM(21)                                            CLE064
 
     D ACY             S              3    DIM(12)
     D/COPY ZSRSRC,ZALIGNZ1LE
 
      **  Compile time arrays
     D*ADT******       S              1    DIM(6) CTDATA PERRCD(6)                           BUG3723
     D ADT             S              1    DIM(7) CTDATA PERRCD(7)                           BUG3723
     D*ARO******       S              1    DIM(7) CTDATA PERRCD(7)                            CLE064
     D ARO             S              1    DIM(22) CTDATA PERRCD(22)                          CLE064
 
      ** Flags to indicate whether transaction fields are valid
     D*OKFlagsDS       DS                                                                     CLE064
     D**DDSYINOK                      1A                                                      CLE064
     D**DDSYCPOK                      1A                                                      CLE064
     D**DDANUMOK                      1A                                                      CLE064
     D**DDDTS1OK                      1A                                                      CLE064
     D**DDDTS2OK                      1A                                                      CLE064
     D**DDDTS3OK                      1A                                                      CLE064
     D**DDDTS4OK                      1A                                                      CLE064
     D**DDDTS5OK                      1A                                                      CLE064
     D**DDDICBOK                      1A                                                      CLE064
     D**DDRTS1OK                      1A                                                      CLE064
     D**DDRTS2OK                      1A                                                      CLE064
     D**DDRTS3OK                      1A                                                      CLE064
     D**DDRTS4OK                      1A                                                      CLE064
     D**DDRTS5OK                      1A                                                      CLE064
     D**DDRTS6OK                      1A                                                      CLE064
     D**DDRLPDOK                      1A                                                      CLE064
     D**DDLAIDOK                      1A                                                      CLE064
     D**DDCSELOK                      1A                                                      CLE064
     D**DDCY01OK                      1A                                                      CLE064
     D**DDCY02OK                      1A                                                      CLE064
     D**DDCY03OK                      1A                                                      CLE064
     D**DDCY04OK                      1A                                                      CLE064
     D**DDCY05OK                      1A                                                      CLE064
     D**DDCY06OK                      1A                                                      CLE064
     D**DDCY07OK                      1A                                                      CLE064
     D**DDCY08OK                      1A                                                      CLE064
     D**DDCY09OK                      1A                                                      CLE064
     D**DDCY10OK                      1A                                                      CLE064
     D**DDCY11OK                      1A                                                      CLE064
     D**DDCY12OK                      1A                                                      CLE064
     D**DDCOMDOK                      1A                                                      CLE064
     D**DDCDTEOK                      1A                                                      CLE064
     D**DDAVLDOK                      1A                                                      CLE064
     D**DDLPTPOK                      1A                                                      CLE064
     D**DDLPFROK                      1A                                               CLE106 CLE064
     D**DDLPBROK                      1A                                                      CLE064
     D**DDLPRTOK                      1A                                               CLE106 CLE064
     D**DDLPSROK                      1A                                               CLE106 CLE064
     D**DDLPAMOK                      1A                                                      CLE064
     D**DDLPPSOK                      1A                                                      CLE064
     D**DDDFTPOK                      1A                                                      CLE064
     D**DDDFSTOK                      1A                                                      CLE064
     D**DDCAXROK                      1A                                                      CLE064
     D**DDCMDIOK                      1A                                                      CLE064
     D**DDSVCDOK                      1A                                               CLE029 CLE064
     D**DDDTS6OK                      1A                                              BUG3723 CLE064
     D**DDSLTPOK                      1A                                               CLE106 CLE064
     D**DDSLSTOK                      1A                                               CLE106 CLE064
     D**DDDFCLOK                      1A                                               CLE042 CLE064
     D**DDSLCLOK                      1A                                               CLE042 CLE064
     D OKFlagsDS     E DS                  EXTNAME(LEEFCISPD)                                 CLE064
 
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  A8SYCA               178    183
      ** BRANCH CODES
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** CUSTOMER
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      **  CUSTOMER LENDING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      **   ACCOUNT OFFICER DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   CURRENCY TYPE
 
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      **   FACILITY TYPE
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      **   COUNTRY
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      **   BASE RATE
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      * Data structures:
 
      * SDSTAT Data Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
 
      * 24X7 Data Structure
     D SC24X7        E DS                  EXTNAME(SC24X7)
 
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
      ***  Current Fclty in File Format FM
     D                                     PREFIX(M)
      *
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
      ***  Current Fclty in File Format FN
     D                                     PREFIX(N)
 
     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
      * Valid Facility FM layout -> FCLTYFM
 
     D ValidFacn     E DS                  EXTNAME(LEVFCINPD)
      * Valid Facility FN layout -> FCLTYFN
 
     D TranInPrim    E DS                  EXTNAME(LEFCPPPD)
      * Incoming Transaction
 
     D TranInSeco    E DS                  EXTNAME(LEFCSPPD)
      * Incoming Transaction
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
      * ZMUSER data layout
     D  DBRN                  11     13
 
     D RUNDAT          DS            13
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  AGMBIN                13     13
      * Rundate data area
 
     D                 DS
     D  DDDTX5                 1      5
     D  DDDTX6                 1      6                                                      BUG3723
     D  DDDTS1A                1      1
     D  DDDTS2A                2      2
     D  DDDTS3A                3      3
     D  DDDTS4A                4      4
     D  DDDTS5A                5      5
     D  DDDTS6A                6      6                                                      BUG3723
      *  DS for rollover types
     D                 DS
     D**DDRTX6**               1      6                                                       CLE064
     D  DDRTX6                 1     21                                                       CLE064
     D  DDRTS1A                1      1
     D  DDRTS2A                2      2
     D  DDRTS3A                3      3
     D  DDRTS4A                4      4
     D  DDRTS5A                5      5
     D  DDRTS6A                6      6
      *  (additional rollover types)                                                          CLE064
     D  DDRTS7A                7      7                                                       CLE064
     D  DDRTS8A                8      8                                                       CLE064
     D  DDRTS9A                9      9                                                       CLE064
     D  DDRTS0A               10     10                                                       CLE064
     D  DDRTSAA               11     11                                                       CLE064
     D  DDRTSBA               12     12                                                       CLE064
     D  DDRTSCA               13     13                                                       CLE064
     D  DDRTSDA               14     14                                                       CLE064
     D  DDRTSEA               15     15                                                       CLE064
     D  DDRTSFA               16     16                                                       CLE064
     D  DDRTSGA               17     17                                                       CLE064
     D  DDRTSHA               18     18                                                       CLE064
     D  DDRTSIA               19     19                                                       CLE064
     D  DDRTSJA               20     20                                                       CLE064
     D  DDRTSKA               21     21                                                       CLE064
     D  DDRTSY                 7     21                                                       CLE064
      *  DS for allowable currencies
     D                 DS
     D  DDACCY                 1     36
     D  DDCY01A                1      3
     D  DDCY02A                4      6
     D  DDCY03A                7      9
     D  DDCY04A               10     12
     D  DDCY05A               13     15
     D  DDCY06A               16     18
     D  DDCY07A               19     21
     D  DDCY08A               22     24
     D  DDCY09A               25     27
     D  DDCY10A               28     30
     D  DDCY11A               31     33
     D  DDCY12A               34     36
 
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** +--------------------------------------+
      ** Ê End of D-specs                       Ê
      ** Ê ==============                       Ê
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** Ê Hook for non-core D-specs (all types)  Ê
      ** Ê also any I-specs (if necessary)        Ê
      ** Ê =====================================  Ê
      ** +----------------------------------------+
 
     D C#LPAM          C                   CONST('     0.0000000')
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
      *
      ** Get ZMUSER to access default branch.                                                BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
     C                   EXSR      RESETERRS
      *
      ** Call Validation Modules in Sequence
      *
      ** Validate Syndication indicator
     C                   EXSR      VSyin
      ** Validate Syndication complete
     C                   EXSR      VSycp
      ** Validate Agent Customer
     C                   EXSR      VAnum
      ** Validate Drawing type
     C                   EXSR      VDts1
      ** Validate Default Interest basis
     C                   EXSR      VDicb
      ** Validate Rollover type
     C                   EXSR      VRts1
      ** Validate Irregular Rollover period
     C                   EXSR      VRlpd
      ** Validate Loan Admin. Id
     C                   EXSR      VLaid
      ** Validate Currency selection
     C                   EXSR      VCsel
      ** Validate Allowable ccy
     C                   EXSR      VCy
      ** Validate Approval date
     C                   EXSR      VComd
      ** Validate closing date
     C                   EXSR      VCdte
      ** Validate Last Avail. date
     C                   EXSR      VAvld
      ** Validate Late payment Penalt. type
     C                   EXSR      VLptp
      *                                                                                       CLE106
      ** Validate Late payment Penalty Fixed Rate                                             CLE106
      *                                                                                       CLE106
     C     CLE036        IFEQ      'Y'                                                       BUG9656
     C                   EXSR      VLpfr                                                      CLE106
     C                   ENDIF                                                               BUG9656
      ***Validat**Base*rate********************************************                       CLE106
      *                                                                                       CLE106
      ** Validate Late payment Penalty Base rate code                                         CLE106
      *                                                                                       CLE106
     C                   EXSR      VLpbr
      *                                                                                       CLE106
      ** Validate Late payment Penalty Base rate                                              CLE106
      *                                                                                       CLE106
     C     CLE036        IFEQ      'Y'                                                       BUG9656
     C                   EXSR      VLprt                                                      CLE106
     C                   ENDIF                                                               BUG9656
      *                                                                                       CLE106
      ** Validate Late payment Penalty Spread rate                                            CLE106
      *                                                                                       CLE106
     C                   EXSR      VLpsr                                                      CLE106
      *                                                                                       CLE106
      ** Validate Sign                                                                        CLE106
      *                                                                                       CLE106
     C                   EXSR      VLpps                                                      CLE106
      ** Validate Amount
     C                   EXSR      VLpam
      ***Validate*Sign*************************************************                       CLE106
     C**********         EXSR      VLpps                                                      CLE106
      ** Validate Def.Part.Loan type/Sub type
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EXSR      VDftp106                                                   CLE106
     C                   ELSE                                                                 CLE106
     C                   EXSR      VDftp
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Validate Default Sub-Participation Loan type/Subtype                                 CLE106
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EXSR      VSptp                                                      CLE106
     C                   ENDIF                                                                CLE106
      ** Validate C/a Exchange rate and indicator
     C                   EXSR      VCaxr
      ** Validate Severity Code                                                               CLE029
     C                   EXSR      VSvcd                                                      CLE029
 
     C                   EXSR      UPDATERRS
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      * RETURN
     C                   RETURN
      *****************************************************************
      ** VSYIN   - Validate Syndication indicator
      *****************************************************************
     C     VSYIN         BEGSR
 
     C     CLE006        IFEQ      'Y'
     C                   SELECT
     C     DDSYIN        WHENEQ    *BLANKS
     C     DDACTN        ANDNE     'A'
     C                   MOVE      'N'           DDSYIN
     C     DDSYIN        WHENNE    'Y'
     C     DDSYIN        ANDNE     'N'
     C                   Move      'N'           DDSYINOK
     C                   Add       1             Idx
     C                   Movel     'DDSYIN'      FldNamXAr(Idx)
     C                   Movel     'LEF0063'     MsgIDXAr(Idx)
 
     C     DDACTN        WHENNE    'I'
     C     DDSYIN        ANDEQ     'N'
     C     MSYIN         ANDEQ     'Y'
     C                   MOVE      DDBRCA        K4BRCA
     C                   MOVE      DDCSSN        K4CNUM
     C                   MOVE      DDFACT        K4FACT
     C                   MOVE      DDFCNO        K4FCNO
     C     K#KY04        SETLL     LEFCLTL2                               80
     C     *IN80         IFEQ      *ON
     C                   Move      'N'           DDSYINOK
     C                   Add       1             Idx
     C                   Movel     'DDSYIN'      FldNamXAr(Idx)
     C                   Movel     'LEF0064'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSYCP Validate Syndication complete
      *****************************************************************
     C     VSYCP         BEGSR
      *
     C     CLE006        IFEQ      'Y'
     C                   SELECT
      *
     C     DDSYIN        WHENEQ    'N'
     C     DDSYCP        ANDEQ     'Y'
     C                   Move      'N'           DDSYCPOK
     C                   Add       1             Idx
     C                   Movel     'DDSYCP'      FldNamXAr(Idx)
     C                   Movel     'LEF0105'     MsgIDXAr(Idx)
      *
     C     DDSYCP        WHENEQ    *BLANKS
     C                   MOVE      'N'           DDSYCP
      *
     C     DDSYCP        WHENNE    'Y'
     C     DDSYCP        ANDNE     'N'
     C                   Move      'N'           DDSYCPOK
     C                   Add       1             Idx
     C                   Movel     'DDSYCP'      FldNamXAr(Idx)
     C                   Movel     'LEF0066'     MsgIDXAr(Idx)
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VANUM Validate Agent customer
      *****************************************************************
     C     VANUM         BEGSR
      *
     C     CLE006        IFEQ      'Y'                                                       BUG6936
     C*****WPRTR         IFEQ      'P'                                                        CLE106
     C*****WPRTR         OREQ      'I'                                                        CLE106
     C     WPRTR         IFNE      'P'                                                        CLE106
     C     WPRTR         ANDNE     'I'                                                        CLE106
     C     WPRTR         ANDNE     'S'                                                        CLE106
     C     WPRTR         ANDNE     'R'                                                        CLE106
      *
     C     DDSYIN        IFEQ      'Y'
      *
      **  Default to the agent customer reference of the branch of
      **  the facility
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     DDCSSN        DBKEY
     C                   MOVEL     'LEFCIP2VL'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             BUG9597
      ** Agent Customer cannot be blank                                                      BUG9597
                                                                                             BUG9597
     C                   IF        DDANUM = *BLANKS  AND                                     BUG9597
     C                             A8SYCA = *BLANKS  OR                                      BUG9597
     C                             DDANUM = *BLANKS  AND                                     BUG9597
     C                             A8SYCA = '000000'                                         BUG9597
     C                   EVAL      DDANUMOK = 'N'                                            BUG9597
     C                   EVAL      Idx = Idx + 1                                             BUG9597
     C                   MOVEL     'DDANUM'      FldNamXAr(Idx)                              BUG9597
     C                   MOVEL     'LEF0067'     MsgIDXAr(Idx)                               BUG9597
     C                   ENDIF                                                               BUG9597
                                                                                             BUG9597
     C     DDANUM        IFEQ      *BLANKS
     C**********         MOVEL(P)  A8SYCA        DDANUM                                       225447
     C                   MOVEL     A8SYCA        DDANUM                                       225447
      *
     C                   ELSE
      *
      ** Access the Customer Details file
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDANUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDANUMOK
     C                   Add       1             Idx
     C                   Movel     'DDANUM'      FldNamXAr(Idx)
     C                   Movel     'LEF0067'     MsgIDXAr(Idx)
     C                   ELSE
 
     C*****BBPAIN        IFEQ      'Y'                                                        CLE106
     C     BBPAIN        IFEQ      'P'                                                        CLE106
     C                   Move      'N'           DDANUMOK
     C                   Add       1             Idx
     C                   Movel     'DDANUM'      FldNamXAr(Idx)
     C                   Movel     'LEF0068'     MsgIDXAr(Idx)
     C                   ELSE
 
     C**********         MOVEL(P)  BBCUST        DDANUM                                       225447
     C***********        MOVEL     BBCUST        DDANUM                                225447 CLE106
     C                   EVAL      DDANUM = BBCUST                                            CLE106
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      ' '           W#PRTR            1
     C                   MOVEL     DDANUM        WDANUM            6                          225447
     C*****DDANUM        IFEQ      A8SYCA                                                     225447
     C     WDANUM        IFEQ      A8SYCA                                                     225447
     C*****Idx**         ANDNE     *ZERO                                               225447 CLE106
     C     Idx           ANDEQ     *ZERO                                                      CLE106
     C                   MOVE      'A'           W#PRTR
      *
      ** Default account officer of the agent customer when account
      ** officer is blank and bank is the agent
     C     WBLACF        IFEQ      'Y'
     C     CLE106        OREQ      'Y'                                                        CLE106
     C     DDACOF        ANDEQ     *BLANKS                                                    CLE106
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDANUM        PCNUM            10
     C                   PARM                    PCNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     DDANUM        DBKEY                          * DBERR 12 *
     C                   MOVEL     'LEFCIP2VL'   DBPGM                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BBACOC        DDACOF
     C                   ENDIF
     C                   ENDIF
      *
      **  Check to see if total of participant's facility amount
      **  equal prime facility amount
     C     DDACTN        IFNE      'I'
     C     DDSYCP        ANDEQ     'Y'
     C     CLE106        ANDNE     'Y'                                                        CLE106
      *
     C                   Z-ADD     0             W#TOPF
     C                   MOVE      DDBRCA        K4BRCA
     C                   MOVE      K3CNUM        K4CNUM
     C                   MOVE      K3FACT        K4FACT
     C                   MOVE      K3FCNO        K4FCNO
     C     K#KY04        SETLL     LEFCLTL2
     C     K#KY04        READE     LEFCLTL2                               80
     C     *IN80         DOWEQ     *OFF
      *                                                                                       CLE106
     C     PRTR          IFEQ      'P'                                                        CLE106
     C     PRTR          OREQ      'I'                                                        CLE106
     C                   ADD       FAMT          W#TOPF           13 0
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C     K#KY04        READE     LEFCLTL2                               80
     C                   ENDDO
     C                   MOVE      'A'           K3RCTP
     C     K#KY03        CHAIN     FCLTY                              80
     C     FAMT          IFNE      W#TOPF
     C                   Move      'N'           DDANUMOK
     C                   Add       1             Idx
     C                   Movel     'DDANUM'      FldNamXAr(Idx)
     C                   Movel     'LEF0065'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDSYIN        IFEQ      'N'
     C     DDANUM        ANDNE     *BLANKS
     C                   Move      'N'           DDANUMOK
     C                   Add       1             Idx
     C                   Movel     'DDANUM'      FldNamXAr(Idx)
     C                   Movel     'LEF0106'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                               BUG6936
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDTS1 Validate Drawing type
      *****************************************************************
     C     VDTS1         BEGSR
      *
     C                   MOVE      DDDTS1        DDDTS1A
     C                   MOVE      DDDTS2        DDDTS2A
     C                   MOVE      DDDTS3        DDDTS3A
     C                   MOVE      DDDTS4        DDDTS4A
     C                   MOVE      DDDTS5        DDDTS5A
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVE      DDDTS6        DDDTS6A                                     BUG3723
     C                   ENDIF                                                               BUG3723
 
     C     DDDTX5        IFEQ      *BLANKS
     C     CLE028        ANDEQ     'N'                                                       BUG3723
     C     DDDTX6        OREQ      *BLANKS                                                   BUG3723
     C     CLE028        ANDEQ     'Y'                                                       BUG3723
     C     DDTRCA        IFEQ      'TR'                                                     AR785547
      ** Default to CA drawing types if no entry mnade.                                     AR785547
     C                   MOVE      DDCANM        K3CNUM                                     AR785547
     C                   MOVE      DDCAFT        K3FACT                                     AR785547
     C                   MOVE      DDCAFN        K3FCNO                                     AR785547
     C                   MOVE      'A'           K3RCTP                                     AR785547
     C     K#KY03        CHAIN     FCLTY                              80                    AR785547
     C                   IF        *In80 = *Off                                             AR785547
     C                   MOVEA     DTPS          DTSca                                      AR785547
     C                   EVAL      DDDTS1 = DTSca(1)                                        AR785547
     C                   EVAL      DDDTS2 = DTSca(2)                                        AR785547
     C                   EVAL      DDDTS3 = DTSca(3)                                        AR785547
     C                   EVAL      DDDTS4 = DTSca(4)                                        AR785547
     C                   EVAL      DDDTS5 = DTSca(5)                                        AR785547
     C                   ENDIF                                                              AR785547
     C                   ELSE                                                               AR785547
      *   Default to all if no entry made.
     C                   MOVE      'C'           DDDTS1
     C                   MOVE      'T'           DDDTS2
     C                   MOVE      'D'           DDDTS3
     C                   MOVE      'R'           DDDTS4
     C                   MOVE      'M'           DDDTS5
      *                                                                                      BUG3723
      ** If Flat Rate Personal Loans (Rule of 78s) is installed                              BUG3723
      ** and Syndication indicator is not 'Y', default the 6th                               BUG3723
      ** drawing type to 'F'.                                                                BUG3723
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C     DDSYIN        ANDNE     'Y'                                                       BUG3723
     C                   MOVE      'F'           DDDTS6                                      BUG3723
     C                   ENDIF                                                               BUG3723
     C                   ENDIF                                                              AR785547
      *
     C                   ELSE
      *   Check for valid entries
     C                   Z-ADD     1             Y                 2 0
      *
      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                             BUG3723
      ** validate also the 6th Drawing Type. Validation was amended                          BUG3723
      ** to accept a drawing type value of 'F' for  Flat Rate                                BUG3723
      ** Personal Loans.                                                                     BUG3723
      *                                                                                      BUG3723
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVEA     DDDTX6        DTS                                         BUG3723
     C                   ELSE                                                                BUG3723
     C                   MOVEA     DDDTX5        DTS
     C                   ENDIF                                                               BUG3723
      *
     C*****Y****         DOWLT     6                                                         BUG3723
     C     Y             DOWLT     7                                                         BUG3723
     C     DDDTS1OK      ANDNE     'N'
     C     DTS(Y)        LOOKUP    ADT                                    19
     C     *IN19         IFEQ      *OFF
     C     CLE028        OREQ      'N'                                                       BUG3723
     C     DTS(Y)        ANDEQ     'F'                                                       BUG3723
     C                   Move      'N'           DDDTS1OK
     C                   Add       1             Idx
     C                   Movel     'DDDTS1'      FldNamXAr(Idx)
     C                   Movel     'LEF0070'     MsgIDXAr(Idx)
      *                                                                                      BUG3723
      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                             BUG3723
      ** F is not a valid drawing type for syndicated facilities.                            BUG3723
      *                                                                                      BUG3723
     C                   ELSE                                                                BUG3723
     C     DTS(Y)        IFEQ      'F'                                                       BUG3723
     C     DDSYIN        ANDEQ     'Y'                                                       BUG3723
     C                   Move      'N'           DDDTS1OK                                    BUG3723
     C                   Add       1             Idx                                         BUG3723
     C                   Movel     'DDDTS1'      FldNamXAr(Idx)                              BUG3723
     C                   Movel     'LEF0362'     MsgIDXAr(Idx)                               BUG3723
     C                   ENDIF
     C                   ENDIF                                                               BUG3723
     C                   ADD       1             Y
     C                   ENDDO
      *
     C     DDDTS1OK      IFNE      'N'
      *
      **  Duplicates not allowed
     C                   Z-ADD     1             Y
      *
     C*****Y****         DOWLT     6                                                         BUG3723
     C     Y             DOWLT     7                                                         BUG3723
     C     DDDTS1OK      ANDNE     'N'
     C                   MOVE      DTS(Y)        W#DTS             1
     C                   MOVE      *BLANK        DTS(Y)
     C     W#DTS         LOOKUP    DTS(1)                                 19
     C     *IN19         IFEQ      *ON
     C     W#DTS         ANDNE     *BLANKS
     C                   Move      'N'           DDDTS1OK
     C                   Add       1             Idx
     C                   Movel     'DDDTS1'      FldNamXAr(Idx)
     C                   Movel     'LEF0069'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   ENDIF
      *
      *                                                                                     AR785547
      ** If facility classified as "Tranche": selected Drawing Type/s should be covered     AR785547
      **                                      by specified Credit Agreement                 AR785547
      *                                                                                     AR785547
     C     DDDTS1OK      IFNE      'N'                                                      AR785547
     C     DDTRCA        ANDEQ     'TR'                                                     AR785547
      *                                                                                     AR785547
     C     CLE028        IFEQ      'Y'                                                      AR785547
     C                   MOVEA     DDDTX6        DTS                                        AR785547
     C                   ELSE                                                               AR785547
     C                   MOVEA     DDDTX5        DTS                                        AR785547
     C                   ENDIF                                                              AR785547
                                                                                            AR785547
     C                   MOVE      DDCANM        K3CNUM                                     AR785547
     C                   MOVE      DDCAFT        K3FACT                                     AR785547
     C                   MOVE      DDCAFN        K3FCNO                                     AR785547
     C                   MOVE      'A'           K3RCTP                                     AR785547
     C     K#KY03        CHAIN     FCLTY                              80                    AR785547
     C                   IF        *In80 = *Off                                             AR785547
      *                                                                                     AR785547
     C                   IF        CLE028 = 'Y'                                             MD035306
     C                   MOVEA     DTPX          DTSca                                      MD035306
     C                   ELSE                                                               MD035306
     C                   MOVEA     DTPS          DTSca                                      AR785547
     C                   ENDIF                                                              MD035306
      *                                                                                     MD035306
     C                   Z-ADD     1             y                                          AR785547
     C                   DOW       y < 7                                                    AR785547
     C     DTS(y)        LOOKUP    DTSca                                  19                AR785547
     C     *IN19         IFEQ      *OFF                                                     AR785547
     C                   ADD       1             Idx                                        AR785547
     C                   SELECT                                                             AR785547
     C                   WHEN      y = 1                                                    AR785547
     C                   MOVEL     'DDDTS1'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS1OK                                   AR785547
     C                   WHEN      y = 2                                                    AR785547
     C                   MOVEL     'DDDTS2'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS2OK                                   AR785547
     C                   WHEN      y = 3                                                    AR785547
     C                   MOVEL     'DDDTS3'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS3OK                                   AR785547
     C                   WHEN      y = 4                                                    AR785547
     C                   MOVEL     'DDDTS4'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS4OK                                   AR785547
     C                   WHEN      y = 5                                                    AR785547
     C                   MOVEL     'DDDTS5'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS5OK                                   AR785547
     C                   WHEN      y = 6                                                    AR785547
     C                   MOVEL     'DDDTS6'      FldNamXAr(Idx)                             AR785547
     C                   MOVE      'N'           DDDTS6OK                                   AR785547
     C                   ENDSL                                                              AR785547
     C                   MOVEL     '5045478'     MsgIDXAr(Idx)                              AR785547
     C                   ENDIF                                                              AR785547
     C                   ADD       1             y                                          AR785547
     C                   ENDDO                                                              AR785547
     C                   ENDIF                                                              AR785547
     C                   ENDIF                                                              AR785547
      *                                                                                     AR785547
     C                   ENDIF
      *
     C                   MOVE      DDDTS1        DDDTS1A
     C                   MOVE      DDDTS2        DDDTS2A
     C                   MOVE      DDDTS3        DDDTS3A
     C                   MOVE      DDDTS4        DDDTS4A
     C                   MOVE      DDDTS5        DDDTS5A
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVE      DDDTS6        DDDTS6A                                     BUG3723
     C                   ENDIF                                                               BUG3723
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDICB Validate Default Interest basis
      *****************************************************************
     C     VDICB         BEGSR
      *
      * Retrieve default interest calculation basis for currency
      * entered.
 
     C     DDACTN        IFEQ      'I'
     C     DDDICB        ANDEQ     *BLANKS
     C                   MOVEL     DDFCCY        WCURR
     C                   EXSR      SRCURR
     C                   MOVE      A6DICB        DDDICB
     C                   ENDIF
 
     C     DDDICB        IFEQ      *BLANKS
     C                   Move      'N'           DDDICBOK
     C                   Add       1             Idx
     C                   Movel     'DDDICB'      FldNamXAr(Idx)
     C                   Movel     'LEF0071'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
     C                   TESTN                   DDDICB               19
     C     *IN19         IFEQ      *OFF
     C                   Move      'N'           DDDICBOK
     C                   Add       1             Idx
     C                   Movel     'DDDICB'      FldNamXAr(Idx)
     C                   Movel     'LEF0071'     MsgIDXAr(Idx)
     C                   ELSE
 
     C                   MOVE      DDDICB        W#DICB            1 0
     C     W#DICB        IFGT      6
     C     W#DICB        ORLT      1
     C                   Move      'N'           DDDICBOK
     C                   Add       1             Idx
     C                   Movel     'DDDICB'      FldNamXAr(Idx)
     C                   Movel     'LEF0071'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRTS1 Validate Rollover type
      *****************************************************************
     C     VRTS1         BEGSR
 
     C                   MOVE      DDRTS1        DDRTS1A
     C                   MOVE      DDRTS2        DDRTS2A
     C                   MOVE      DDRTS3        DDRTS3A
     C                   MOVE      DDRTS4        DDRTS4A
     C                   MOVE      DDRTS5        DDRTS5A
     C                   MOVE      DDRTS6        DDRTS6A
     C                   MOVE      DDRTS7        DDRTS7A                                      CLE064
     C                   MOVE      DDRTS8        DDRTS8A                                      CLE064
     C                   MOVE      DDRTS9        DDRTS9A                                      CLE064
     C                   MOVE      DDRTS0        DDRTS0A                                      CLE064
     C                   MOVE      DDRTSA        DDRTSAA                                      CLE064
     C                   MOVE      DDRTSB        DDRTSBA                                      CLE064
     C                   MOVE      DDRTSC        DDRTSCA                                      CLE064
     C                   MOVE      DDRTSD        DDRTSDA                                      CLE064
     C                   MOVE      DDRTSE        DDRTSEA                                      CLE064
     C                   MOVE      DDRTSF        DDRTSFA                                      CLE064
     C                   MOVE      DDRTSG        DDRTSGA                                      CLE064
     C                   MOVE      DDRTSH        DDRTSHA                                      CLE064
     C                   MOVE      DDRTSI        DDRTSIA                                      CLE064
     C                   MOVE      DDRTSJ        DDRTSJA                                      CLE064
     C                   MOVE      DDRTSK        DDRTSKA                                      CLE064
      *
     C     DDRTX6        IFEQ      *BLANKS
      *   Default to all if no entry made.
     C                   MOVE      'M'           DDRTS1
     C                   MOVE      'T'           DDRTS2
     C                   MOVE      'Q'           DDRTS3
     C                   MOVE      'X'           DDRTS4
     C                   MOVE      'Y'           DDRTS5
     C                   MOVE      'Z'           DDRTS6
     C                   MOVE      'D'           DDRTS7                                       CLE064
     C                   MOVE      'W'           DDRTS8                                       CLE064
     C                   MOVE      'F'           DDRTS9                                       CLE064
     C                   MOVE      '4'           DDRTS0                                       CLE064
     C                   MOVE      '5'           DDRTSA                                       CLE064
     C                   MOVE      '7'           DDRTSB                                       CLE064
     C                   MOVE      '8'           DDRTSC                                       CLE064
     C                   MOVE      '9'           DDRTSD                                       CLE064
     C                   MOVE      'V'           DDRTSE                                       CLE064
     C                   MOVE      'E'           DDRTSF                                       CLE064
     C                   MOVE      'C'           DDRTSG                                       CLE064
     C                   MOVE      'I'           DDRTSH                                       CLE064
     C                   MOVE      'J'           DDRTSI                                       CLE064
     C                   MOVE      'N'           DDRTSJ                                       CLE064
     C                   MOVE      'U'           DDRTSK                                       CLE064
      *
     C                   ELSE
      *   Check for valid entries
     C                   Z-ADD     1             Y
     C                   MOVEA     DDRTX6        ROT
      *
     C*****Y****         DOWLT     7                                                          CLE064
     C     Y             DOWLT     22                                                         CLE064
     C     DDRTS1OK      ANDNE     'N'
     C     ROT(Y)        LOOKUP    ARO                                    19
     C     *IN19         IFEQ      *OFF
     C                   Move      'N'           DDRTS1OK
     C                   Add       1             Idx
     C                   Movel     'DDRTS1'      FldNamXAr(Idx)
     C                   Movel     'LEF0072'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C     DDRTS1OK      IFNE      'N'
      *
      **  Duplicates not allowed
     C                   Z-ADD     1             Y
      *
     C*****Y****         DOWLT     7                                                          CLE064
     C     Y             DOWLT     22                                                         CLE064
     C     DDRTS1OK      ANDNE     'N'
     C                   MOVE      ROT(Y)        W#ROT             1
     C                   MOVE      *BLANK        ROT(Y)
     C     W#ROT         LOOKUP    ROT(1)                                 19
     C     *IN19         IFEQ      *ON
     C     W#ROT         ANDNE     *BLANKS
     C                   Move      'N'           DDRTS1OK
     C                   Add       1             Idx
     C                   Movel     'DDRTS1'      FldNamXAr(Idx)
     C                   Movel     'LEF0073'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      DDRTS1        DDRTS1A
     C                   MOVE      DDRTS2        DDRTS2A
     C                   MOVE      DDRTS3        DDRTS3A
     C                   MOVE      DDRTS4        DDRTS4A
     C                   MOVE      DDRTS5        DDRTS5A
     C                   MOVE      DDRTS6        DDRTS6A
     C                   MOVE      DDRTS7        DDRTS7A                                      CLE064
     C                   MOVE      DDRTS8        DDRTS8A                                      CLE064
     C                   MOVE      DDRTS9        DDRTS9A                                      CLE064
     C                   MOVE      DDRTS0        DDRTS0A                                      CLE064
     C                   MOVE      DDRTSA        DDRTSAA                                      CLE064
     C                   MOVE      DDRTSB        DDRTSBA                                      CLE064
     C                   MOVE      DDRTSC        DDRTSCA                                      CLE064
     C                   MOVE      DDRTSD        DDRTSDA                                      CLE064
     C                   MOVE      DDRTSE        DDRTSEA                                      CLE064
     C                   MOVE      DDRTSF        DDRTSFA                                      CLE064
     C                   MOVE      DDRTSG        DDRTSGA                                      CLE064
     C                   MOVE      DDRTSH        DDRTSHA                                      CLE064
     C                   MOVE      DDRTSI        DDRTSIA                                      CLE064
     C                   MOVE      DDRTSJ        DDRTSJA                                      CLE064
     C                   MOVE      DDRTSK        DDRTSKA                                      CLE064
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRLPD Validate Irregular Rollover period
      *****************************************************************
     C     VRLPD         BEGSR
      *
      * If Z (irregular) is used as a rollover period, then entry
      * should be 01-12, default 12; otherwise must be blank/zero.
     C     'Z'           SCAN      DDRTX6        Y
      *
     C     DDRLPD        IFEQ      *BLANKS
     C                   MOVE      *ZEROS        DDRLPD
     C                   ELSE
      *
     C                   TESTN                   DDRLPD               19
     C     *IN19         IFEQ      *OFF
     C                   Move      'N'           DDRLPDOK
     C                   Add       1             Idx
     C                   Movel     'DDRLPD'      FldNamXAr(Idx)
     C                   Movel     'LEF0074'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      DDRLPD        W#RLPD            2 0
     C     W#RLPD        IFGT      12
     C     Y             ANDGT     *ZERO
     C     W#RLPD        ORLT      0
     C     Y             ANDGT     *ZERO
     C     W#RLPD        ORNE      *ZERO
     C     Y             ANDEQ     *ZERO
     C                   Move      'N'           DDRLPDOK
     C                   Add       1             Idx
     C                   Movel     'DDRLPD'      FldNamXAr(Idx)
     C                   Movel     'LEF0075'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLAID Validate Loan Admin. Id
      *****************************************************************
     C     VLAID         BEGSR
      *
     C*****CLE008        IFEQ      'Y'                                                        CLE106
     C*****WPRTR         ANDEQ     'P'                                                        CLE106
     C*****CLE008        OREQ      'Y'                                                        CLE106
     C*****WPRTR         ANDEQ     'I'                                                        CLE106
      *
     C     CLE008        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPRTR         IFNE      'P'                                                        CLE106
     C     WPRTR         ANDNE     'I'                                                        CLE106
     C     WPRTR         ANDNE     'S'                                                        CLE106
     C     WPRTR         ANDNE     'R'                                                        CLE106
     C     DDLAID        IFNE      *BLANKS
     C                   MOVE      DDLAID        ACOKEY
     C                   CALL      'AOACOFR0'    PLIST4
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDLAIDOK
     C                   Add       1             Idx
     C                   Movel     'DDLAID'      FldNamXAr(Idx)
     C                   Movel     'LEF0044'     MsgIDXAr(Idx)
     C                   ELSE
      *
     C                   MOVEL     DDLAID        DDLAI1            1
     C                   MOVE      DDLAID        DDLAI2            1
      *
     C                   MOVE      AZACOC        DDLAID
     C                   ENDIF
     C                   ELSE
     C                   MOVE      DDACOF        DDLAID
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSEL Validate Currency selection
      *****************************************************************
     C     VCSEL         BEGSR
      *
     C     DDMCCY        IFEQ      'Y'
      *
     C                   SELECT
     C     DDCSEL        WHENEQ    *BLANKS
     C                   MOVE      'N'           DDCSEL
     C     DDCSEL        WHENNE    'Y'
     C     DDCSEL        ANDNE     'N'
     C                   Move      'N'           DDCSELOK
     C                   Add       1             Idx
     C                   Movel     'DDCSEL'      FldNamXAr(Idx)
     C                   Movel     'LEF0076'     MsgIDXAr(Idx)
     C                   ENDSL
 
     C                   ELSE
     C                   MOVE      'N'           DDCSEL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCY   Validate Allowable ccy
      *****************************************************************
     C     VCY           BEGSR
      *
     C                   Move      DDCY01        DDCY01A
     C                   Move      DDCY02        DDCY02A
     C                   Move      DDCY03        DDCY03A
     C                   Move      DDCY04        DDCY04A
     C                   Move      DDCY05        DDCY05A
     C                   Move      DDCY06        DDCY06A
     C                   Move      DDCY07        DDCY07A
     C                   Move      DDCY08        DDCY08A
     C                   Move      DDCY09        DDCY09A
     C                   Move      DDCY10        DDCY10A
     C                   Move      DDCY11        DDCY11A
     C                   Move      DDCY12        DDCY12A
 
     C     DDCSEL        IFEQ      'Y'
      *
     C     DDACCY        IFEQ      *BLANKS
      *
      **  At least one currency must be entered
     C                   Move      'N'           DDCY01OK
     C                   Add       1             Idx
     C                   Movel     'DDCY01'      FldNamXAr(Idx)
     C                   Movel     'LEF0077'     MsgIDXAr(Idx)
     C                   ELSE
 
      *   Check for valid entries
     C                   MOVEA     DDACCY        ACY
     C                   Z-ADD     1             Y
      *
     C     Y             DOWLT     13
      *
     C     ACY(Y)        IFNE      *BLANKS
      **  Must be a valid code on SDCURRPD
     C                   MOVE      ACY(Y)        CKEY
      *
     C                   MOVE      '*BLANKS'     @RTCD
     C                   CALLB     'AOCURRR0'    PLIST2
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDCY01OK
     C                   Add       1             Idx
     C                   Movel     'DDCY01'      FldNamXAr(Idx)
     C                   Movel     'LEF0078'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      A6CYCD        ACY(Y)
      *
     C     A6DLCI        IFEQ      'N'
     C                   Move      'N'           DDCY01OK
     C                   Add       1             Idx
     C********           Movel     'DDCY01'      FldNamXAr(Idx)                             BUG11995
     C                   Movel     'DDCSEL'      FldNamXAr(Idx)                             BUG11995
     C                   Movel     'LEF0057'     MsgIDXAr(Idx)
     C                   Movel     A6CYCD        MsgDtaXAr(Idx)                             BUG11995
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             Y
      *
     C                   ENDDO
      *
     C                   MOVEA     ACY           DDACCY
      *
      **  Duplicates not allowed
     C                   Z-ADD     1             Y
      *
     C     Y             DOWLT     7
     C                   MOVE      ACY(Y)        W#ACY             3
     C                   MOVE      *BLANK        ACY(Y)
     C     W#ACY         LOOKUP    ACY(1)                                 19
     C     *IN19         IFEQ      *ON
     C     W#ACY         ANDNE     *BLANKS
     C                   Move      'N'           DDCY01OK
     C                   Add       1             Idx
     C                   Movel     'DDCY01'      FldNamXAr(Idx)
     C                   Movel     'LEF0079'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCSEL        IFEQ      'N'
     C     DDACCY        ANDNE     *BLANKS
     C                   Move      'N'           DDCY01OK
     C                   Add       1             Idx
     C                   Movel     'DDCY01'      FldNamXAr(Idx)
     C                   Movel     'LEF0098'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   Move      DDCY01        DDCY01A
     C                   Move      DDCY02        DDCY02A
     C                   Move      DDCY03        DDCY03A
     C                   Move      DDCY04        DDCY04A
     C                   Move      DDCY05        DDCY05A
     C                   Move      DDCY06        DDCY06A
     C                   Move      DDCY07        DDCY07A
     C                   Move      DDCY08        DDCY08A
     C                   Move      DDCY09        DDCY09A
     C                   Move      DDCY10        DDCY10A
     C                   Move      DDCY11        DDCY11A
     C                   Move      DDCY12        DDCY12A
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCOMD Validate Approval date
      *****************************************************************
     C     VCOMD         BEGSR
 
     C                   Z-ADD     *ZERO         W#COMD
 
      * Retrieve the Start date
     C                   MOVE      WWDTAP        W#DTAP            5 0
      *
     C     DDCOMD        IFEQ      *BLANKS
      * Default to date approved or Run Date, whichever is earlier
      *
     C     W#DTAP        IFLE      WRNDAY
     C                   MOVE      W#DTAP        ZDAYNO
     C                   ELSE
     C                   MOVE      WRNDAY        ZDAYNO
     C                   ENDIF
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDCOMD
      *
     C                   ELSE
      *
      ** convert to Midas date format
     C                   MOVE      DDCOMD        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDCOMDOK
     C                   Add       1             Idx
     C                   Movel     'DDCOMD'      FldNamXAr(Idx)
     C                   Movel     'LEF0080'     MsgIDXAr(Idx)
     C                   ELSE
     C                   ENDIF
     C                   ENDIF
      *
      *  Allow Committed/Approval Date to be any date in the past but
      *  not later than Start date.
      *  and not later than run date
      *
     C                   MOVE      ZDAYNO        W#COMD            5 0
     C     W#COMD        IFGT      W#DTAP
     C                   Move      'N'           DDCOMDOK
     C                   Add       1             Idx
     C                   Movel     'DDCOMD'      FldNamXAr(Idx)
     C                   Movel     'LEF0123'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      **  Introduce new message description to avoid confusion
     C     W#COMD        IFGT      WRNDAY
     C                   Move      'N'           DDCOMDOK
     C                   Add       1             Idx
     C                   Movel     'DDCOMD'      FldNamXAr(Idx)
     C                   Movel     'LEF0295'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCDTE Validate Closing date
      *****************************************************************
     C     VCDTE         BEGSR
 
     C                   Z-ADD     *ZERO         W#CDTE
 
      * Retrieve Expiry date
     C                   MOVE      WWDTEX        W#DTEX            5 0
 
      ** Validate Closing date if CLE006 is on
      ** and CLE106 is *ON                                                                   BUG9459
     C     CLE006        IFEQ      'Y'
     C*****CLE106        ANDEQ     'Y'                                                       BUG9459
     C     CLE106        OREQ      'Y'                                                        249841
      *
     C     DDCDTE        IFEQ      *BLANKS
      * Default to start date
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   MOVE      W#DTEX        ZDAYNO                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      W#DTAP        ZDAYNO
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDCDTE
     C                   ELSE
      *
      ** convert to Midas date format
     C                   MOVE      DDCDTE        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDCDTEOK
     C                   Add       1             Idx
     C                   Movel     'DDCDTE'      FldNamXAr(Idx)
     C                   Movel     'LEF0082'     MsgIDXAr(Idx)
     C                   ELSE
 
     C     ZDAYNO        IFLT      W#DTAP
     C     ZDAYNO        ORGT      W#DTEX
     C                   Move      'N'           DDCDTEOK
     C                   Add       1             Idx
     C                   Movel     'DDCDTE'      FldNamXAr(Idx)
     C                   Movel     'LEF0083'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     ZDAYNO        W#CDTE            5 0
     C                   ENDIF
      *                                                                                       246880
     C                   Else                                                                 246880
      ** CLE006 is OFF                                                                        246880
     C                   If        (DDCDTE<>*BLANKS)                                          246880
     C                   Eval      DATEA = DDCDTE                                             246880
     C                   Callb     'ZDATE1'                                                   246880
     C                   Parm                    DATEA                                        246880
     C                   Parm                    ZDAYNO                                       246880
     C                   Parm                    BJDFIN                                       246880
     C                   Parm                    ErrorFlag                                    246880
     C                   Eval      W#CDTE = ZDAYNO                                            246880
     C                   Endif                                                                246880
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VAVLD Validate Last Avail. date
      *****************************************************************
     C     VAVLD         BEGSR
 
     C                   Z-ADD     *ZERO         W#AVLD
 
      * Save value of DTEX in date form for validation of AVLD
     C                   MOVE      MDTEX         ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DTEXS2            6
 
      *  Save value of AVLD which was output on screen:
     C                   MOVE      MAVLD         ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         AVLDS3            6
 
      * Move New expiry date from entry parm to a work field
     C                   MOVE      WNDTEX        WWNDTEX           5 0
 
      *    If no value of AVLD input or stored on file,
     C     DDAVLD        IFEQ      *BLANKS
      * Or if AVLD was previously same as Expiry Date, and the Expiry
      *  Date has been changed, but the Available Date has not
     C     MAVLD         OREQ      MDTEX
     C     DDDTEX        ANDNE     DTEXS2
     C     DDAVLD        ANDEQ     AVLDS3
      * Default to expiry date
     C                   MOVE      W#DTEX        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDAVLD
     C                   ELSE
      *
      ** convert to Midas date format
     C                   MOVE      DDAVLD        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF
 
     C                   Z-ADD     ZDAYNO        W#AVLD            5 0
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDAVLDOK
     C                   Add       1             Idx
     C                   Movel     'DDAVLD'      FldNamXAr(Idx)
     C                   Movel     'LEF0429'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ** If facility is reactivated use the new expiry date in the
      ** facility amendment file instead of the existing expiry date
      ** in the facilities file
     C     ZDAYNO        IFLT      W#DTAP
     C     ZDAYNO        ORGT      W#DTEX
     C     WREAC         ANDEQ     *OFF
     C     ZDAYNO        ORGT      WWNDTEX
     C     WREAC         ANDEQ     *ON
     C                   Move      'N'           DDAVLDOK
     C                   Add       1             Idx
     C                   Movel     'DDAVLD'      FldNamXAr(Idx)
     C                   Movel     'LEF0111'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLPTP Validate Late payment Penalt. Type
      *****************************************************************
     C     VLPTP         BEGSR
      *
     C     DDLPTP        IFNE      *BLANKS
     C     DDLPTP        ANDNE     'P'
     C     DDLPTP        ANDNE     'A'
     C                   Move      'N'           DDLPTPOK
     C                   Add       1             Idx
     C                   Movel     'DDLPTP'      FldNamXAr(Idx)
     C                   Movel     'LEF0088'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      ** VLPFR Validate Late Payment Penalty Fixed Rate                                       CLE106
      *****************************************************************                       CLE106
     C     VLPFR         BEGSR                                                                CLE106
      *                                                                                       CLE106
     C                   Z-ADD     *ZERO         W#LPFR           11 7                        CLE106
      *                                                                                       CLE106
     C     DDLPTP        IFNE      'P'                                                        CLE106
      *                                                                                       CLE106
     C     DDLPFR        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPFROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPFR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0506'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C     DDLPFR        IFEQ      *BLANKS                                                    CLE106
     C     DDLPFR        OREQ      '0'                                                      BUG22100
      *                                                                                       CLE106
     C     DDLPBR        IFEQ      *BLANKS                                                    CLE106
     C     DDLPRT        ANDEQ     *BLANKS                                                    CLE106
     C     DDLPBR        OREQ      '0'                                                      BUG22100
     C     DDLPRT        ANDEQ     '0'                                                      BUG22100
     C                   Move      'N'           DDLPFROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPFR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0510'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE      DDLPFR        ZFIELD                                       CLE106
     C                   Z-ADD     7             ZADEC                                        CLE106
     C                   Z-ADD     4             ZADIG                                        CLE106
     C                   EXSR      ZALIGN                                                     CLE106
     C     *IN99         IFEQ      *ON                                                        CLE106
     C                   Move      'N'           DDLPFROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPFR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0507'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      ZFIELD        W#LPFR                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
     C*****************************************************************                       CLE106
     C/EJECT
      *****************************************************************
      ** VLPBR Validate Base rate
      *****************************************************************
     C     VLPBR         BEGSR
      *
     C     DDLPTP        IFNE      'P'
      *
     C     DDLPBR        IFNE      *BLANKS
     C                   Move      'N'           DDLPBROK
     C                   Add       1             Idx
     C                   Movel     'DDLPBR'      FldNamXAr(Idx)
     C**********         Movel     'LEF0089'     MsgIDXAr(Idx)                                CLE106
     C                   Movel     'LEF0508'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDLPBR        IFNE      *BLANKS
      *                                                                                       CLE106
     C     DDLPFR        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPBROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPBR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0509'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVE      DDFCCY        BKEY1
     C                   MOVE      DDLPBR        BKEY2
     C                   CALLB     'AOBSRTR0'    PLIST7
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDLPBROK
     C                   Add       1             Idx
     C                   Movel     'DDLPBR'      FldNamXAr(Idx)
     C**********         Movel     'LEF0090'     MsgIDXAr(Idx)                                CLE106
     C                   Movel     'LEF0511'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE
     C     DDLPBR        IFEQ      '?'
     C                   MOVE      'Y'           WSELT             1
     C                   ENDIF
     C                   MOVE      BABSRC        DDLPBR
     C                   ENDIF
     C                   ENDIF                                                                CLE106
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      ** VLPRT Validate Late Payment Penalty Base Rate                                        CLE106
      *****************************************************************                       CLE106
     C     VLPRT         BEGSR                                                                CLE106
      *                                                                                       CLE106
     C                   Z-ADD     *ZERO         W#LPRT           11 7                        CLE106
      *                                                                                       CLE106
     C     DDLPTP        IFNE      'P'                                                        CLE106
      *                                                                                       CLE106
     C     DDLPRT        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPRTOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPRT'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0512'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C     DDLPRT        IFNE      *BLANKS                                                    CLE106
     C     DDLPRT        ANDNE     '0'                                                      BUG22100
      *                                                                                       CLE106
     C     DDLPFR        IFNE      *BLANKS                                                    CLE106
     C     DDLPFR        ANDNE     '0'                                                      BUG22100
     C                   Move      'N'           DDLPRTOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPRT'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0515'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C     DDLPBR        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPRTOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPRT'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0513'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE      DDLPRT        ZFIELD                                       CLE106
     C                   Z-ADD     7             ZADEC                                        CLE106
     C                   Z-ADD     4             ZADIG                                        CLE106
     C                   EXSR      ZALIGN                                                     CLE106
     C     *IN99         IFEQ      *ON                                                        CLE106
     C                   Move      'N'           DDLPRTOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPRT'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0514'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      ZFIELD        W#LPRT                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
     C*****************************************************************                       CLE106
     C/EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      ** VLPSR Validate Late Payment Penalty Spread Rate                                      CLE106
      *****************************************************************                       CLE106
     C     VLPSR         BEGSR                                                                CLE106
      *                                                                                       CLE106
     C                   Z-ADD     *ZERO         W#LPSR           11 7                        CLE106
      *                                                                                       CLE106
     C     DDLPTP        IFNE      'P'                                                        CLE106
      *                                                                                       CLE106
     C     DDLPSR        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPSROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPSR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0516'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C     DDLPSR        IFNE      *BLANKS                                                    CLE106
     C     DDLPBR        IFEQ      *BLANKS                                                   BUG9656
     C                   Move      'N'           DDLPSROK                                    BUG9656
     C                   Add       1             Idx                                         BUG9656
     C                   Movel     'DDLPSR'      FldNamXAr(Idx)                              BUG9656
     C                   Movel     'LEF0528'     MsgIDXAr(Idx)                               BUG9656
     C                   ENDIF                                                               BUG9656
      *                                                                                       CLE106
     C     DDLPFR        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPSROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPSR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0517'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE      DDLPSR        ZFIELD                                       CLE106
     C                   Z-ADD     7             ZADEC                                        CLE106
     C                   Z-ADD     4             ZADIG                                        CLE106
     C                   EXSR      ZALIGN                                                     CLE106
     C     *IN99         IFEQ      *ON                                                        CLE106
     C                   Move      'N'           DDLPSROK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPSR'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0518'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      ZFIELD        W#LPSR                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
     C/EJECT
      *****************************************************************
      ** VLPAM Validate Amount
      *****************************************************************
     C     VLPAM         BEGSR
 
     C                   Z-ADD     *ZERO         W#LPAM
      *
     C*****DDLPAM        IFNE      *BLANKS                                                    CLE106
     C*****DDLPAM        ANDNE     C#LPAM                                                     CLE106
      *****************************************************************                       CLE106
     C*****DDLPTP        IFEQ      *BLANKS                                                    CLE106
     C**********         Move      'N'           DDLPAMOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0091'     MsgIDXAr(Idx)                                CLE106
     C**********         ELSE                                                                 CLE106
      **********                                                                              CLE106
     C*****DDLPTP        IFEQ      'P'                                                        CLE106
      **********                                                                              CLE106
      ****Must*be*valid*per*ZALIGN*************************************                       CLE106
     C**********         MOVE      *BLANKS       ZFIELD                                       CLE106
     C**********         MOVE      DDLPAM        ZFIELD                                       CLE106
     C**********         Z-ADD     7             ZADEC                                        CLE106
     C**********         Z-ADD     4             ZADIG                                        CLE106
     C**********         EXSR      ZALIGN                                                     CLE106
     C******IN99         IFEQ      *ON                                                        CLE106
     C**********         Move      'N'           DDLPAMOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0092'     MsgIDXAr(Idx)                                CLE106
     C**********         ELSE                                                                 CLE106
     C**********         MOVE      ZFIELD        W#LPAM           13 0                        CLE106
     C**********         ENDIF                                                                CLE106
      **********                                                                              CLE106
     C**********         ELSE                                                                 CLE106
      **********                                                                              CLE106
     C*****DDLPTP        IFEQ      'A'                                                        CLE106
      *****************************************************************                       CLE106
      ****Must*be*valid*per*ZALIGN*************************************                       CLE106
     C**********         MOVE      *BLANKS       ZFIELD                                       CLE106
     C**********         MOVE      DDLPAM        ZFIELD                                       CLE106
     C**********         MOVE      WWNBDP        W#NBDP                                       CLE106
     C**********         Z-ADD     W#NBDP        ZADEC                                        CLE106
     C*****13***         SUB       W#NBDP        ZADIG                                        CLE106
     C**********         EXSR      ZALIGN                                                     CLE106
     C******IN99         IFEQ      *ON                                                        CLE106
     C**********         Move      'N'           DDLPAMOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0092'     MsgIDXAr(Idx)                                CLE106
     C**********         ELSE                                                                 CLE106
     C**********         MOVE      ZFIELD        W#LPAM           13 0                        CLE106
     C**********         ENDIF                                                                CLE106
      **********                                                                              CLE106
     C**********         ENDIF                                                                CLE106
     C**********         ENDIF                                                                CLE106
     C**********         ENDIF                                                                CLE106
      **********                                                                              CLE106
     C**********         ELSE                                                                 CLE106
     C*****DDLPTP        IFEQ      'P'                                                        CLE106
     C*****DDLPBR        ANDEQ     *BLANKS                                                    CLE106
     C*****DDLPTP        OREQ      'A'                                                        CLE106
     C**********         Move      'N'           DDLPAMOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0097'     MsgIDXAr(Idx)                                CLE106
     C**********         ENDIF                                                                CLE106
     C**********         ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** If CLE036 is off, & Late Payment Type is 'P',                                        248127
      ** allow this field to still contain a percentage rate:                                 248127
     C     CLE036        IFNE      'Y'                                                        248127
     C     DDLPTP        IFEQ      'P'                                                        248127
      *                                                                                       248127
      *   Must be valid rate per ZALIGN                                                       248127
     C                   MOVE      *BLANKS       ZFIELD                                       248127
     C                   MOVE      DDLPAM        ZFIELD                                       248127
     C                   Z-ADD     7             ZADEC                                        248127
     C                   Z-ADD     4             ZADIG                                        248127
     C                   EXSR      ZALIGN                                                     248127
     C     *IN99         IFEQ      *ON                                                        248127
     C                   Move      'N'           DDLPAMOK                                     248127
     C                   Add       1             Idx                                          248127
     C                   Movel     'DDLPAM'      FldNamXAr(Idx)                               248127
     C                   Movel     'LEF0092'     MsgIDXAr(Idx)                                248127
     C                   ELSE                                                                 248127
     C                   MOVE      ZFIELD        W#LPAM           13 0                        248127
     C                   ENDIF                                                                248127
      *                                                                                       248127
     C                   ENDIF                                                                248127
      *                                                                                       248127
     C                   ELSE                                                                 248127
      * Else, CLE036 is switched on, so this field should only be used                        248127
      * to hold an amount (use the Fixed Rate field for a Percentage instead)                 248127
      *                                                                                       248127
     C     DDLPTP        IFNE      'A'                                                        CLE106
      *                                                                                       CLE106
     C     DDLPAM        IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPAMOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0519'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       248127
     C                   ENDIF                                                 End If not A   248127
      *                                                                                       248127
     C                   ENDIF                                                 End if CLE036  248127
      **********                                                                       CLE106 248127
     C**********         ELSE                                                          CLE106 248127
      *                                                                                       248127
     C     DDLPTP        IFEQ      'A'                                                        248127
      *                                                                                       CLE106
     C     DDLPAM        IFEQ      *BLANKS                                                    CLE106
     C                   Move      'N'           DDLPAMOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0520'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE      DDLPAM        ZFIELD                                       CLE106
     C                   MOVE      WWNBDP        W#NBDP                                       CLE106
     C                   Z-ADD     W#NBDP        ZADEC                                        CLE106
     C     13            SUB       W#NBDP        ZADIG                                        CLE106
     C                   EXSR      ZALIGN                                                     CLE106
     C     *IN99         IFEQ      *ON                                                        CLE106
     C                   Move      'N'           DDLPAMOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDLPAM'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0521'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      ZFIELD        W#LPAM           13 0                        CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLPPS Validate Sign
      *****************************************************************
     C     VLPPS         BEGSR
      *
     C                   SELECT
     C     DDLPTP        WHENNE    'P'
     C     DDLPPS        IFNE      *BLANKS
     C                   Move      'N'           DDLPPSOK
     C                   Add       1             Idx
     C**********         Movel     'DDLPPS'      FldNamXAr(Idx)                              BUG9094
     C                   MOVEL     'DDLPAM'      FldNamXAr(Idx)                              BUG9094
     C                   Movel     'LEF0093'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C     DDLPPS        WHENEQ    *BLANKS
     C*****DDLPAM        ANDNE     *BLANKS                                                    CLE106
     C*****DDLPAMOK      ANDNE     'N'                                                        CLE106
     C*****DDLPBR        ANDNE     *BLANKS                                                    CLE106
     C     DDLPTP        ANDEQ     'P'                                                        CLE106
     C     DDLPSR        ANDNE     *BLANKS                                                    CLE106
     C     DDLPSROK      ANDNE     'N'                                                        CLE106
     C     DDLPRTOK      ANDNE     'N'                                                        CLE106
     C     DDLPBROK      ANDNE     'N'
     C                   MOVE      '+'           DDLPPS
     C*****DDLPPS        WHENEQ    '-'                                                        CLE106
     C*****DDLPPS        OREQ      '+'                                                        CLE106
     C*****DDLPBR        IFEQ      *BLANKS                                                    CLE106
     C*****DDLPAM        ANDNE     *BLANKS                                                    CLE106
     C*****DDLPAMOK      ANDNE     'N'                                                        CLE106
     C**********         Move      'N'           DDLPPSOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPPS'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0094'     MsgIDXAr(Idx)                                CLE106
     C**********         ELSE                                                                 CLE106
      **********                                                                              CLE106
     C*****DDLPBR        IFNE      *BLANKS                                                    CLE106
     C*****DDLPAM        ANDEQ     *BLANKS                                                    CLE106
     C*****DDLPBROK      ANDNE     'N'                                                        CLE106
     C**********         Move      'N'           DDLPPSOK                                     CLE106
     C**********         Add       1             Idx                                          CLE106
     C**********         Movel     'DDLPPS'      FldNamXAr(Idx)                               CLE106
     C**********         Movel     'LEF0097'     MsgIDXAr(Idx)                                CLE106
     C**********         ENDIF                                                                CLE106
     C**********         ENDIF                                                                CLE106
     C     DDLPPS        WHENNE    '-'
     C     DDLPPS        ANDNE     '+'
     C     DDLPPS        ANDNE     *BLANKS
     C                   Move      'N'           DDLPPSOK
     C                   Add       1             Idx
     C                   Movel     'DDLPPS'      FldNamXAr(Idx)
     C                   Movel     'LEF0095'     MsgIDXAr(Idx)
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      ** VDFTP106 Validate Def. Part.Loan type/Sub type (CLE106 switched on)                  CLE106
      *****************************************************************                       CLE106
     C     VDFTP106      BEGSR                                                                CLE106
      *                                                                                       CLE106
     C     DDSYIN        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPRTR         IFNE      'P'                                                        CLE106
     C     WPRTR         ANDNE     'I'                                                        CLE106
     C     WPRTR         ANDNE     'S'                                                        CLE106
     C     WPRTR         ANDNE     'R'                                                        CLE106
     C     DDTRCA        ANDNE     'AG'                                                       CLE106
      *                                                                                       CLE106
      ** Default Participation Loan type/subtype is mandatory                                 CLE106
      *                                                                                       CLE106
     C     DDDFTP        IFEQ      *BLANKS                                                    CLE106
     C     DDDFST        ANDEQ     *BLANKS                                                    CLE106
     C     DDDFCL        ANDEQ     *BLANKS                                                    CLE042
     C                   Move      'N'           DDDFTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0501'     MsgIDXAr(Idx)                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVEL     DDDFTP        ATCD                                         CLE106
     C                   MOVEL     DDDFST        AUCD                                         CLE106
     C                   MOVEL     DDDFCL        AUCL                                         CLE042
     C                   CALL      'AOLOANR0'    PLIST9                                       CLE106
     C     @RTCD         IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDDFTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0096'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** If '?' entered, display selected values to screen                                    CLE106
      *                                                                                       CLE106
     C     DDDFTP        IFEQ      '?'                                                        CLE106
     C     DDDFST        OREQ      '?'                                                        CLE106
     C     DDDFCL        OREQ      '?'                                                        CLE042
     C                   MOVE      'Y'           WSELT                                        CLE106
     C                   MOVE      AYLNTY        DDDFTP                                       CLE106
     C                   MOVE      AYLNST        DDDFST                                       CLE106
     C                   MOVE      AYLNCL        DDDFCL                                       CLE042
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Only allow processing types 66, 67, 69 or 72 to be entered for default               CLE106
      ** participation loan type/sub type.                                                    CLE106
      *                                                                                       CLE106
     C     AYLNPT        IFEQ      67                                                         CLE106
     C     AYLNPT        OREQ      66                                                         CLE106
     C     CLE005        OREQ      'Y'                                                        CLE106
     C     AYLNPT        ANDEQ     69                                                         CLE106
     C     CLE005        OREQ      'Y'                                                        CLE106
     C     AYLNPT        ANDEQ     72                                                         CLE106
     C                   ELSE                                                                 CLE106
     C                   Move      'N'           DDDFTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0113'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
     C     DDSYIN        IFEQ      'N'                                                        CLE106
     C     DDDFTP        IFNE      *BLANKS                                                    CLE106
     C     DDDFST        ORNE      *BLANKS                                                    CLE106
     C     DDDFCL        ORNE      *BLANKS                                                    CLE042
     C                   Move      'N'           DDDFTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0107'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C*                                                                                       CLE106
     C                   ENDSR                                                                CLE106
     C*****************************************************************                       CLE106
     C/EJECT
      *****************************************************************
      ** VDFTP Validate Def. Part.Loan type/Sub type
      *****************************************************************
     C     VDFTP         BEGSR
      *
     C     DDSYIN        IFEQ      'Y'
      *
      ** Check if there are funding participants
      *
     C                   MOVE      DDBRCA        K4BRCA
     C                   MOVE      DDCSSN        K4CNUM
     C                   MOVE      DDFACT        K4FACT
     C                   MOVE      DDFCNO        K4FCNO
     C     K#KY04        SETLL     LEFCLTL2                               80
      *
     C                   MOVEL     DDDFTP        ATCD
     C                   MOVEL     DDDFST        AUCD
     C                   MOVEL     DDDFCL        AUCL                                         CLE042
     C                   CALL      'AOLOANR0'    PLIST9
      *
      ** No need to validate default participation loan type and
      ** subtype if both are blanks and agent is not the bank and
      ** there are no funding participants attached to the facility.
      *
     C                   MOVEL     A8SYCA        W3ANUM            6
      *
     C     DDDFTP        IFEQ      *BLANKS
     C     DDDFST        ANDEQ     *BLANKS
     C     DDDFCL        ANDEQ     *BLANKS                                                    CLE042
     C     DDANUM        ANDNE     W3ANUM
     C     *IN80         ANDEQ     *OFF
     C                   ELSE
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** If there are funding participants, and loan type/subtype
      ** equal to blanks, send appropriate error message
     C     *IN80         IFEQ      *ON
     C     DDDFTP        ANDEQ     *BLANKS
     C     DDDFST        ANDEQ     *BLANKS
     C     DDDFCL        ANDEQ     *BLANKS                                                    CLE042
     C                   Move      'N'           DDDFTPOK
     C                   Add       1             Idx
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)
     C                   Movel     'LEF0313'     MsgIDXAr(Idx)
     C                   ELSE
     C                   Move      'N'           DDDFTPOK
     C                   Add       1             Idx
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)
     C                   Movel     'LEF0096'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE
      *
      ** If '?' entered, display selected values to screen
     C     DDDFTP        IFEQ      '?'
     C     DDDFST        OREQ      '?'
     C     DDDFCL        OREQ      '?'                                                        CLE042
     C                   MOVE      'Y'           WSELT
     C                   MOVE      AYLNTY        DDDFTP
     C                   MOVE      AYLNST        DDDFST
     C                   MOVE      AYLNCL        DDDFCL                                       CLE042
     C                   ENDIF
      *
      *  Only allow processing types 66 or 67 to be entered for default
      *  participation loan type/sub type.
     C     AYLNPT        IFEQ      67
     C     AYLNPT        OREQ      66
     C     CLE005        OREQ      'Y'
     C     AYLNPT        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     AYLNPT        ANDEQ     72
     C                   ELSE
     C                   Move      'N'           DDDFTPOK
     C                   Add       1             Idx
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)
     C                   Movel     'LEF0113'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
     C     DDSYIN        IFEQ      'N'
     C     DDDFTP        IFNE      *BLANKS
     C     DDDFST        ORNE      *BLANKS
     C     DDDFCL        ORNE      *BLANKS                                                    CLE042
     C                   Move      'N'           DDDFTPOK
     C                   Add       1             Idx
     C                   Movel     'DDDFTP'      FldNamXAr(Idx)
     C                   Movel     'LEF0107'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      ** VSPTP Validate Default Sub-Participation Loan Type/Subtype)                          CLE106
      *****************************************************************                       CLE106
     C     VSPTP         BEGSR                                                                CLE106
      *                                                                                       CLE106
     C     DDSYIN        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPRTR         IFNE      'P'                                                        CLE106
     C     WPRTR         ANDNE     'I'                                                        CLE106
     C     WPRTR         ANDNE     'S'                                                        CLE106
     C     WPRTR         ANDNE     'R'                                                        CLE106
     C     DDTRCA        ANDNE     'AG'                                                       CLE106
      *                                                                                       CLE106
      ** Default Sub-Participation Loan type/subtype is mandatory                             CLE106
      *                                                                                       CLE106
     C     DDSLTP        IFEQ      *BLANKS                                                    CLE106
     C     DDSLST        ANDEQ     *BLANKS                                                    CLE106
     C     DDSLCL        ANDEQ     *BLANKS                                                    CLE042
     C                   Move      'N'           DDSLTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0502'     MsgIDXAr(Idx)                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   MOVEL     DDSLTP        ATCD                                         CLE106
     C                   MOVEL     DDSLST        AUCD                                         CLE106
     C                   MOVEL     DDSLCL        AUCL                                         CLE042
     C                   CALL      'AOLOANR0'    PLIST9                                       CLE106
     C     @RTCD         IFNE      *BLANKS                                                    CLE106
     C                   Move      'N'           DDSLTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0503'     MsgIDXAr(Idx)                                CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** If '?' entered, display selected values to screen                                    CLE106
      *                                                                                       CLE106
     C     DDSLTP        IFEQ      '?'                                                        CLE106
     C     DDSLST        OREQ      '?'                                                        CLE106
     C     DDSLCL        OREQ      '?'                                                        CLE042
     C                   MOVE      'Y'           WSELT                                        CLE106
     C                   MOVE      AYLNTY        DDSLTP                                       CLE106
     C                   MOVE      AYLNST        DDSLST                                       CLE106
     C                   MOVE      AYLNCL        DDSLCL                                       CLE042
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Only allow processing types 66, 67, 69 or 72 to be entered for default               CLE106
      ** sub-participation loan type/sub type.                                                CLE106
      *                                                                                       CLE106
     C     AYLNPT        IFEQ      67                                                         CLE106
     C     AYLNPT        OREQ      66                                                         CLE106
     C     CLE005        OREQ      'Y'                                                        CLE106
     C     AYLNPT        ANDEQ     69                                                         CLE106
     C     CLE005        OREQ      'Y'                                                        CLE106
     C     AYLNPT        ANDEQ     72                                                         CLE106
     C                   ELSE                                                                 CLE106
     C                   Move      'N'           DDSLTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0504'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ELSE                                                                 CLE106
     C     DDSYIN        IFEQ      'N'                                                        CLE106
     C     DDSLTP        IFNE      *BLANKS                                                    CLE106
     C     DDSLST        ORNE      *BLANKS                                                    CLE106
     C     DDSLCL        ORNE      *BLANKS                                                    CLE042
     C                   Move      'N'           DDSLTPOK                                     CLE106
     C                   Add       1             Idx                                          CLE106
     C                   Movel     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   Movel     'LEF0505'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
     C*****************************************************************                       CLE106
     C/EJECT
      *****************************************************************
      ** VCAXR Validate C/A Exchange rate
      *****************************************************************
     C     VCAXR         BEGSR
 
     C                   Z-ADD     *ZERO         W#CAXR
     C                   MOVE      *BLANK        W#CACY
      *
      **  Must only be validated and entered if Tranche
      *
     C     DDTRCA        IFEQ      'TR'
      *
      ** Validate first if the entered exchange rate is numeric
     C     DDCAXR        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   Move      'N'           DDCAXROK
     C                   Add       1             Idx
     C                   Movel     'DDCAXR'      FldNamXAr(Idx)
     C                   Movel     'LEF0352'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   Move      ZFIELD        W#CAXR           13 8
     C                   ENDIF
      *
      * Need to obtain the correct cross rate between CA and TR
      * Credit Facility currency
      *  Use previously saved value of the Credit Agreement currency
     C     DDCAXROK      IFNE      'N'
     C                   MOVEL     WCACCY        WCURR             3
     C                   EXSR      SRCURR
     C                   MOVE      A6MDIN        WMDIN             1
     C                   Z-ADD     A6SPRT        WSPRT            13 8
      *
      * Tranche Facility currency
     C                   MOVEL     DDFCCY        WCURR
     C                   EXSR      SRCURR
     C                   Z-ADD     A6NBDP        WNBDP             1 0
     C                   MOVE      A6MDIN        ZMDI1             1
     C                   Z-ADD     A6SPRT        ZRATE1           13 8
     C                   MOVE      WMDIN         ZMDI2             1
     C                   Z-ADD     WSPRT         ZRATE2           13 8
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C                   Z-ADD     ZRATEX        WSPOT            13 8
      *
      **  Determine cross rate and mult/div indicator
     C                   Z-ADD     A6SPRT        WSVRT            13 8
     C                   Z-ADD     A6NBDP        WCDPF             1 0
      *
      **  Validate Credit/Agreement Exchange Rate Indicator
     C     DDCMDI        IFEQ      *BLANKS
      *
      **  Default to the Cross Rate Indicator if blank
     C                   MOVE      ZMDIX         DDCMDI
     C                   ELSE
      *
      **  Must be either 'M' or 'D' if entered
     C     DDCMDI        IFNE      'M'
     C     DDCMDI        ANDNE     'D'
     C                   Move      'N'           DDCMDIOK
     C                   Add       1             Idx
     C                   Movel     'DDCMDI'      FldNamXAr(Idx)
     C                   Movel     'LEF0262'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Validate Credit/Agreement Exchange Rate
     C     DDCAXR        IFEQ      *BLANK
     C                   MOVE      WSPOT         WSVFX
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WSPOT         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   MOVE      ZFIELD        DDCAXR
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C                   Move      ZFIELD        W#CAXR
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        WSVFX            13 8
     C                   ENDIF
      *
     C                   MOVE      DDCANM        K1CNUM
     C                   MOVE      DDCAFT        K1FACT
     C                   MOVE      DDCAFN        K1FCNO
      *
     C     K#KY01        CHAIN     FCLTY                              80
     C     *IN80         IFEQ      '0'
     C                   MOVE      FCCY          W#CACY            3
     C     FCCY          IFEQ      DDFCCY
     C                   MOVE      *BLANKS       ZFIELD
     C                   Z-ADD     1             WDCAXR           13 8
     C                   MOVE      WDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   MOVE      ZFIELD        DDCAXR
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C                   Move      ZFIELD        W#CAXR
     C                   ELSE
      *
      **  Check that the Exchange Rate is within 25% of Cross Rate
     C     DDCMDI        IFNE      ZMDIX
     C     1             DIV(H)    WSPOT         WSPOT
     C                   ENDIF
     C     WSPOT         MULT(H)   0.75          WRATM            13 8
     C     WSPOT         MULT(H)   1.25          WRATP            13 8
      *
     C     WSVFX         IFLE      WRATM
     C     WSVFX         ORGT      WRATP
     C*****W#CNT2        IFLT      1                                                         BUG1866
     C**********         Move      'N'           DDCAXROK                                    BUG1866
     C**********         Add       1             Idx                                         BUG1866
     C**********         Movel     'DDCAXR'      FldNamXAr(Idx)                              BUG1866
     C**********         Movel     'LEF0263'     MsgIDXAr(Idx)                               BUG1866
     C                   Move      'W'           DDCAXROK                                    BUG1866
     C                   Add       1             WId                                         BUG1866
     C                   Movel     'DDCAXR'      WFldNmXAr(WId)                              BUG1866
     C                   Movel     'LEF0263'     WMsgIDXAr(WId)                              BUG1866
     C**********         ENDIF                                                               BUG1866
     C**********         ADD       1             W#CNT2            1 0                       BUG1866
     C                   Z-ADD     WSVFX         WSVFY            13 8
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WSVFX         ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   MOVE      ZFIELD        DDCAXR
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCAXR        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   EXSR      ZALIGN
     C                   Move      ZFIELD        W#CAXR
     C                   ENDIF
      *
     C                   ENDIF
      *
      * The Tranche agreement facility amount cannot exceed the
      * amount for the Credit Agreement.
     C                   Z-ADD     FAMT          WAMNT            13 0
     C                   MOVE      DDCANM        K0CANM
     C                   MOVE      DDCAFT        K0CAFT
     C                   MOVE      DDCAFN        K0CAFN
      *
      * Access all existing Tranches for the Credit Agreement
      *
     C     *LOVAL        SETLL     FCLTYFL9
     C     K#KY10        CHAIN     FCLTYFL9                           05
      *
     C     *IN05         DOWEQ     '0'
      *
     C     LERECI        IFEQ      'D'
     C                   MOVE      LEFACT        WFACT             3
     C                   MOVE      LEFCNO        WFCNO             2
      *
      * Subtract Tranche amount from (remaining) Credit Agreement amount
     C     DDACTN        IFEQ      'I'
     C     DDACTN        ORNE      'I'
     C     WFACT         ANDNE     DDFACT
     C     WFCNO         ANDNE     DDFCNO
     C     DDACTN        ORNE      'I'
     C     WFACT         ANDEQ     DDFACT
     C     WFCNO         ANDNE     DDFCNO
     C     DDACTN        ORNE      'I'
     C     WFACT         ANDNE     DDFACT
     C     WFCNO         ANDEQ     DDFCNO
      *
      * Straight subtraction if currencies are the same
     C     LEFCCY        IFEQ      FCCY
     C                   SUB       LEFAMT        WAMNT
      *
      * Else convert to Credit Agreement currency before subtracting
      *
     C                   ELSE
     C     LECMDI        IFEQ      'M'
     C     LEFAMT        MULT      LECAXR        WTAMT            13 0
     C                   ELSE
     C     LEFAMT        DIV       LECAXR        WTAMT
     C                   ENDIF
     C                   SUB       WTAMT         WAMNT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      FCLTYFL9                               05
     C     LECANM        IFNE      K0CANM
     C     LECAFT        ORNE      K0CAFT
     C     LECAFN        ORNE      K0CAFN
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *                                                                                       250214
      ** Consider FI/FD on CA                                                                 250214
      *                                                                                       250214
     C                   Z-ADD     FAMT          WFAMT            13 0                        250214
     C                   Z-ADD     FAMT          XFAMT            13 0                        250214
     C     *LOVAL        SETLL     LEFCAMPF                                                   250214
     C                   READ      LEFCAMPF                               98                  250214
     C     *IN98         DOWEQ     '0'                                                        250214
     C     FA_CNUM       IFEQ      K0CANM                                                     250214
     C     FA_FACT       ANDEQ     K0CAFT                                                     250214
     C     FA_FCNO       ANDEQ     K0CAFN                                                     250214
     C     FA_VLDT       ANDLE     W#DTAP                                                     250214
     C     FA_FATP       IFEQ      'FI'                                                       250214
     C                   ADD       FA_AAMT       WFAMT                                        250214
     C                   ADD       FA_AAMT       WAMNT                                        250214
     C     FA_ASTS       IFEQ      'A'                                                        250214
     C                   ADD       FA_AAMT       XFAMT                                        250214
     C                   ENDIF                                                                250214
     C                   ELSE                                                                 250214
     C                   SUB       FA_AAMT       WFAMT                                        250214
     C                   SUB       FA_AAMT       WAMNT                                        250214
     C                   ENDIF                                                                250214
     C                   ENDIF                                                                250214
     C                   READ      LEFCAMPF                               98                  250214
     C                   ENDDO                                                                250214
      *
      * Convert amount of this Tranche if necessary before comparing
      * with remaining Credit Agreement amount.
     C     DDFCCY        IFEQ      FCCY
     C                   Z-ADD     W#FAMT        WTAMT
     C                   ELSE
     C     DDCMDI        IFEQ      'M'
     C     W#FAMT        MULT      WSVFX         WTAMT
     C                   ELSE
     C     W#FAMT        DIV       WSVFX         WTAMT
     C                   ENDIF
     C                   ENDIF
     C*****W#FAMT        IFGT      FAMT                                               BUG3914 249617
     C*****WTAMT         IFGT      FAMT                                                249617 250214
     C     WTAMT         IFGT      WFAMT                                                      250214
     C                   Move      'N'           DDCAXROK                                    BUG3914
     C                   Add       1             Idx                                         BUG3914
     C                   Movel     'DDFAMT'      FldNamXAr(Idx)                              BUG3914
     C                   Movel     'LEF0135'     MsgIDXAr(Idx)                               BUG3914
     C                   ELSE                                                                BUG3914
     C     WTAMT         IFGT      XFAMT                                                      250214
     C     WTAMT         ANDLE     WFAMT                                                      250214
     C                   Move      'N'           DDCAXROK                                     250214
     C                   Add       1             Idx                                          250214
     C                   Movel     'DDFAMT'      FldNamXAr(Idx)                               250214
     C                   Movel     'LEF0137'     MsgIDXAr(Idx)                                250214
     C                   ELSE                                                                 250214
     C     WTAMT         IFGT      WAMNT
     C*****WTAMT         ANDNE     WAMT                                                      BUG4351
     C                   Move      'W'           DDCAXROK
     C                   Add       1             WId
     C                   Movel     'DDCAXR'      WFldNmXAr(WId)
     C                   Movel     'LEF0129'     WMsgIDXAr(WId)
     C                   ENDIF
     C                   ENDIF                                                                250214
     C                   ENDIF                                                               BUG3914
     C**********         Z-ADD     W#FAMT        WAMT             13 0                       BUG4351
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                                       244684
      * The last availability date of tranche cannot be after the                             244684
      * last availability date of the credit agreement facility                               244684
     C     W#AVLD        IFGT      AVLD                                                       244684
     C                   Move      'N'           DDAVLDOK                                     244684
     C                   Add       1             Idx                                          244684
     C                   Movel     'DDAVLD'      FldNamXAr(Idx)                               244684
     C                   Movel     'LEF0529'     MsgIDXAr(Idx)                                244684
     C                   ENDIF                                                                244684
      *
     C                   ELSE
      *
      **  Credit Agreement Exchange Rate and Indicator must only be
      **  entered for a tranche
      *
     C     DDCAXR        IFNE      *BLANKS
     C                   Move      'N'           DDCAXROK
     C                   Add       1             Idx
     C                   Movel     'DDCAXR'      FldNamXAr(Idx)
     C                   Movel     'LEF0274'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDCMDI        IFNE      *BLANKS
     C                   Move      'N'           DDCAXROK
     C                   Add       1             Idx
     C                   Movel     'DDCAXR'      FldNamXAr(Idx)
     C                   Movel     'LEF0275'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCMDI Validate Exchange rate ind
      *****************************************************************
     C     VCMDI         BEGSR
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE029
      ** VSVCD Validate Severity Code                                                         CLE029
      *****************************************************************                       CLE029
     C     VSVCD         BEGSR                                                                CLE029
                                                                                              CLE029
      ** Severity Code is not mandatory                                                       CLE029
     C                   IF        DDSVCD <> *BLANKS                                          CLE029
     C     DDSVCD        CHAIN     SDSVCDL0                           80                      CLE029
                                                                                              CLE029
     C                   If        *in80 = '1'                                                CLE029
     C                   Move      'N'           DDSVCDOK                                     CLE029
     C                   Add       1             Idx                                          CLE029
     C                   Movel     'DDSVCD'      FldNamXAr(Idx)                               CLE029
     C                   Movel     'LEF0430'     MsgIDXAr(Idx)                                CLE029
     C                   ENDIF                                                                CLE029
                                                                                              CLE029
     C                   ENDIF                                                                CLE029
      *                                                                                       CLE029
     C                   ENDSR                                                                CLE029
      *****************************************************************                       CLE029
     C/EJECT                                                                                  CLE029
      *****************************************************************
      * SRCURR   - Access currency details                            *
      * Calls    : AOCURRR0                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRCURR        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      WCURR         CKEY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     11            DBASE                          * DBERR 11 *
     C                   MOVEL     WCURR         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
      *
      * File LEVFCIMPD - FM file
 
     C                   MOVEL     DDSYIN        FPSYIN
     C                   MOVEL     DDSYCP        FPSYCP
     C*********          MOVE      DDANUM        FPANUM                                       BG1958
     C                   MOVEL     DDANUM        FPANUM                                       BG1958
     C     CLE028        IFEQ      'Y'                                                       BUG3723
     C                   MOVEL     DDDTX6        DPDTPX                                      BUG3723
     C                   ENDIF                                                               BUG3723
     C                   MOVEL     DDDTX5        FPDTPS
     C                   MOVE      DDDICB        FPDICB
     C                   MOVEL     DDRTX6        FPRTPS
     C                   MOVEL     DDRTSY        FPRTS15                                      CLE064
     C                   MOVEL     DDRLPD        FPRLPD
     C                   MOVEL     DDLAID        FPLAID
     C                   MOVEL     DDCSEL        FPCSEL
     C                   MOVEL     DDACCY        FPALCY
     C                   Z-ADD     W#COMD        FPCOMD
     C                   Z-ADD     W#CDTE        FPCDTE
     C                   Z-ADD     W#AVLD        FPAVLD
     C                   MOVEL     DDLPTP        FPLPTP
     C                   MOVE      DDLPBR        FPLPBR
     C                   Z-ADD     W#LPAM        FPLPAM
     C                   MOVE      DDLPPS        FPLPPS
     C                   MOVEL     DDDFTP        FPDFTP
     C                   MOVEL     DDDFST        FPDFST
     C                   MOVEL     DDDFCL        FPDFCL                                       CLE042
     C                   Z-ADD     W#CAXR        FPCAXR
     C                   MOVEL     DDCMDI        FPCMDI
     C                   MOVEL     W#CACY        FPCACY
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   MOVE      WPRTR         FPPRTR                                       CLE106
     C                   ELSE                                                                 CLE106
     C     WPRTR         IFNE      'P'
     C     WPRTR         ANDNE     'I'
     C                   MOVE      W#PRTR        FPPRTR
     C                   ENDIF
     C                   ENDIF                                                                CLE106
     C                   MOVE      DDSVCD        FPSVCD                                       CLE029
     C                   MOVE      DDLMTI        FPLMTI                                       CLE029
      *
      * File LEVFCINPD - FN file
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      ** Facility Primary   Details
     C                   PARM                    TranInPrim
      ** Facility Secondary Details
     C                   PARM                    TranInSeco
      * Facility - file formats
     C                   PARM                    FacmFilFmt
     C                   PARM                    FacnFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    WWDTAP            5
      * Expiry date
     C                   PARM                    WWDTEX            5
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * Next expiry date
     C                   PARM                    WNDTEX            5
      * Facility decimal places
     C                   PARM                    WWNBDP            1
      * OK indicator - filed TRCA
     C                   PARM                    OKTRCA            1
 
      * OK indicator - filed CAFT
     C                   PARM                    OKCAFT            1
      * OK indicator - filed CAFN
     C                   PARM                    OKCAFN            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facilty amount
     C                   PARM                    W#FAMT           13 0
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    WPRTR             1
 
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
 
      *
      **  GET ZMUSER to access default branch.
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  GET RUNDAT to access multi-branching indicator
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFCIP2VL'   DBPGM
     C                   OUT       LDA
 
      ** Define work field
     C     *LIKE         DEFINE    A6NBDP        W#NBDP
      *
      ** Determine if 24x7 Midas Availability active?
      ** CSC011 is a redundant feature. No need to check                                    MD024398
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANK        @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD                                      MD024398
     C*
     C*****@RTCD         IFEQ      *BLANKS                                                  MD024398
     C**********         MOVE      'Y'           CSC011            1                        MD024398
     C**********         ELSE                                                               MD024398
     C                   MOVE      'N'           CSC011
     C**********         ENDIF                                                              MD024398
      *
      ** Access Switchable SAR details for the existence of CLE006
      ** (Syndications)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE006            1
     C                   ELSE
     C                   MOVE      'N'           CLE006
     C                   ENDIF
      *
      ** Access Switchable SAR details for the existence of CLE008
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE008            1
     C                   ELSE
     C                   MOVE      'N'           CLE008
     C                   ENDIF
      *                                                                                      BUG3723
      ** Access Switchable SAR details for the existence of CLE028                           BUG3723
      *                                                                                      BUG3723
     C                   CALLB     'AOSARDR0'                                                BUG3723
     C                   PARM      *BLANK        @RTCD                                       BUG3723
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3723
     C                   PARM      'CLE028'      @SARD                                       BUG3723
      *                                                                                      BUG3723
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3723
     C                   MOVE      'Y'           CLE028            1                         BUG3723
     C                   ELSE                                                                BUG3723
     C                   MOVE      'N'           CLE028                                      BUG3723
     C                   ENDIF                                                               BUG3723
      *                                                                                       CLE106
      ** Access Switchable SAR details for the existence of CLE106                            CLE106
      *                                                                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANK        @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106            1                          CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                      BUG9656
      ** Access Switchable SAR details for the existence of CLE036                           BUG9656
      *                                                                                      BUG9656
     C                   CALLB     'AOSARDR0'                                                BUG9656
     C                   PARM      *BLANK        @RTCD                                       BUG9656
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9656
     C                   PARM      'CLE036'      @SARD                                       BUG9656
      *                                                                                      BUG9656
     C     @RTCD         IFEQ      *BLANKS                                                   BUG9656
     C                   MOVE      'Y'           CLE036            1                         BUG9656
     C                   ELSE                                                                BUG9656
     C                   MOVE      'N'           CLE036                                      BUG9656
     C                   ENDIF                                                               BUG9656
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
 
     C     *DTAARA       DEFINE                  SC24X7
     C                   IN        SC24X7
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* Is the support system on?
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     BPAURV        IFEQ      'Y'
     C                   MOVE      *ON           *IN88
     C                   MOVE      'Y'           W#IN88            1
     C                   ELSE
     C                   MOVE      *OFF          *IN88
     C                   MOVE      'N'           W#IN88
     C                   ENDIF
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      **  Chain to LEFCLTL0
     C     K#KY01        KLIST
     C**********         KFLD                    K1CNUM            6 0                        CSD027
     C                   KFLD                    K1CNUM            6                          CSD027
     C                   KFLD                    K1FACT            3 0
     C                   KFLD                    K1FCNO            2 0
      **  Facility
     C     K#KY03        KLIST
     C**********         KFLD                    K3CNUM            6 0                        CSD027
     C                   KFLD                    K3CNUM            6                          CSD027
     C                   KFLD                    K3FACT            3 0
     C                   KFLD                    K3FCNO            2 0
     C                   KFLD                    K3RCTP            1
      **  Facility participant (LEFCLTL2)
     C     K#KY04        KLIST
     C                   KFLD                    K4BRCA            3
     C**********         KFLD                    K4CNUM            6 0                        CSD027
     C                   KFLD                    K4CNUM            6                          CSD027
     C                   KFLD                    K4FACT            3 0
     C                   KFLD                    K4FCNO            2 0
      ** used for CLOAN
     C     K#KY05        KLIST
     C**********         KFLD                    K5LNRF            6 0                        CLE148
     C                   KFLD                    K5LNRF            6                          CLE148
     C                   KFLD                    K5RCTP            1
 
      ** Key for LEFEDL1
     C     K#KY07        KLIST
     C                   KFLD                    K7CNUM            6 0
     C                   KFLD                    K7FCTY            5 0
 
      **  Used for LEREF
     C     K#KY08        KLIST
     C                   KFLD                    K8CNUM            6 0
     C                   KFLD                    K8FACT            3 0
     C                   KFLD                    K8FCNO            2 0
      **  Used for LEFCAML0
     C     K#KY09        KLIST
     C                   KFLD                    K9BRCA            3
     C                   KFLD                    K9CUST            6 0
     C                   KFLD                    K9FCTY            3 0
     C                   KFLD                    K9FTNO            2 0
 
      **  Used for LEFCLTL9
     C     K#KY10        KLIST
     C**********         KFLD                    K0CANM            6 0                        CSD027
     C                   KFLD                    K0CANM            6                          CSD027
     C                   KFLD                    K0CAFT            3 0
     C                   KFLD                    K0CAFN            2 0
 
     C     K#FCTYP       KLIST
     C                   KFLD                    K#CNUM            6 0
     C                   KFLD                    K#FACT            3 0
     C                   KFLD                    K4FCNO            2 0
 
     C     PLIST1        PLIST
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    FKEY              3
     C     SDFACT        PARM      SDFACT        DSFDY
 
     C     PLIST2        PLIST
     C                   PARM                    @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CKEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PLIST4        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    ACOKEY            2
     C     SDACOF        PARM      SDACOF        DSFDY
 
 
     C     PLIST5        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CTRYKY            2
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C     PLIST7        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    BKEY1             3
     C                   PARM                    BKEY2             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PLIST9        PLIST
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    ATCD              2
     C                   PARM                    AUCD              2
     C                   PARM                    AUCL              4                          CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
     C/COPY ZSRSRC,ZALIGNZ2LE
      /EJECT
      *                                                                                      BUG3723
      ** Elements of Array ADT were amended to include 'F'.                                  BUG3723
      *                                                                                      BUG3723
      *                                                                                       CLE064
      ** Elements of Array ARO were amended from 'MTQXYZ' to 'DWFMTQ45X789VEYCIJNUZ'          CLE064
      *                                                                                       CLE064
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** ADT
 CTDRMF                                                                                      BUG3723
** ARO
 DWFMTQ45X789VEYCIJNUZ
