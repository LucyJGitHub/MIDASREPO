     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)                  *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments screen input')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMSIN - Loan amendments screen input                     *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for loan amendments                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD036070           Date 19Oct15               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA076             Date 30Mar04               *
      *                 TDA066             Date 26Mar04               *
      *                 TDA074             Date 24Mar04               *
      *                 TDA053             Date 23Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 01Dec03               *
      *                 CLE030             Date 02Oct02               *
      *                 CAP075  *CREATE    Date 09Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA076 - Consecutive inputs of Principal Increase results    *
      *           to wrong settlement default.                        *
      *  TDA066 - Wrong settlement method and account when enquired.  *
      *  TDA074 - Old loan subtype change not defaulted on input.     *
      *  TDA053 - LOAM - unable to input in the initial screen;       *
      *           F15 (select) should be keyed, in order to input     *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  CLE030 - Release authorisation processing                    *
      *  CAP075 - Lending API enhancements - loan amendments          *
      *                                                               *
      *****************************************************************
     FLOAMD     IF   E           K DISK
     F                                     RENAME(LOAMSDKF:LOAMSD)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
 
      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Current loan amendment in file format
     D C_LOAM_F      E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(C_)
 
      * Current loan amendment in screen format
     D C_LOAM_S      E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@)
 
      * New loan amendment in file format
     D N_LOAM_F      E DS                  EXTNAME(LEVLOAMPD)
     D***CLREC**              321    389                                                      CGL029
     D***CLPAY**              390    948                                                      CGL029
     D***CLREC**              335    389                                               CGL029 TDA066
     D***CLPAY**              404    948                                               CGL029 TDA066
     D***CLRECEx             1194   1211                                               CGL029 TDA066
     D***CLPAYEx             1212   1229                                               CGL029 TDA066
     D  LAREC                335    389                                                       TDA066
     D  LAPAY                404    948                                                       TDA066
     D  LARECEx             1195   1212                                                       TDA066
     D  LAPAYEx             1213   1230                                                       TDA066
 
      * Previous loan amendment in screen format
     D P_LOAM_S      E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@P)
 
      * Error indicators
     D OKAmndScn     E DS                  EXTNAME(LEELOAMPD)
      *
      ***  Loan Details 'A' Format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
     D  CLREC                473    527                                                       TDA066
     D  CLPAY                542   1086                                                       TDA066
     D  CLRECEx             1597   1614                                                       TDA066
     D  CLPAYEx             1615   1632                                                       TDA066
      *
      ***  Loan Details 'B' Format
     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
     D                                     PREFIX(LO_)
     D LB_RECI       E                     EXTFLD(RECI)
     D LB_LNRF       E                     EXTFLD(LNRF)
     D LB_RCDT       E                     EXTFLD(RCDT)
     D LB_MRIN       E                     EXTFLD(MRIN)
     D LB_ORED       E                     EXTFLD(ORED)
     D LB_LCD        E                     EXTFLD(LCD)
     D LB_CHTP       E                     EXTFLD(CHTP)
     D LB_TNLU       E                     EXTFLD(TNLU)
     D LB_FRNT       E                     EXTFLD(FRNT)
     D LB_AFRT       E                     EXTFLD(AFRT)
     D LB_REPA       E                     EXTFLD(REPA)
     D LB_TMST       E                     EXTFLD(TMST)
      *
      ***  Facility Details 'A' Format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
      *
      ***  Facility Details 'B' Format
     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
     D                                     PREFIX(FA_)
     D FB_RECI       E                     EXTFLD(RECI)
     D FB_CNUM       E                     EXTFLD(CNUM)
     D FB_FACT       E                     EXTFLD(FACT)
     D FB_FCNO       E                     EXTFLD(FCNO)
     D FB_RCTP       E                     EXTFLD(RCTP)
     D FB_ORED       E                     EXTFLD(ORED)
     D FB_LCD        E                     EXTFLD(LCD)
     D FB_CHTP       E                     EXTFLD(CHTP)
     D FB_TNLU       E                     EXTFLD(TNLU)
     D FB_FRNT       E                     EXTFLD(FRNT)
     D FB_AFRT       E                     EXTFLD(AFRT)
     D FB_REPA       E                     EXTFLD(REPA)
     D FB_STMP       E                     EXTFLD(STMP)
 
      * File receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
      * File payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
      * File FRA/IRS instructions (needed as a parameter for call
      * to ZASETINSIN etc)
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      *
      ***  Screen FRA/IRS Instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      * Curent screen receive instructions
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(@_)
 
      * Current screen payment instructions
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(@_)
 
      ** Flags to indicate whether pay settlement instruction fields
      **  are valid
     D OKPayInsDS    E DS                  EXTNAME(SDESEPPD)
 
      ** Flags to indicate whether receive settlement instruction fields
      **  are valid
     D OKRecInsDS    E DS                  EXTNAME(SDESERPD)
 
      ***  External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***  Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** PCA ICD Details
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * 24X7 Data Area Structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      * SDSTAT Data Area Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Action code
     D DDACTN          S              1A
 
      ** Loan number
     D DDLOAN          S              6A
 
      ** Display 'Unauthorised Only?'
     D @Unaut          S              1A   inz('N')
 
      ** Build subfile
     D @BDSFL          S              1A
 
      ** Loan / value date / sequence / type selected
     D @LNSel          S              6A
     D @VDSel          S              6A
     D @SQSel          S              3A
     D @ATSel          S              2A
 
      ** Condition availability of function keys:
      * KG - F7 - Roll Backwards
      * KH - F8 - Roll Forwards
      * KJ - F10 - Delete
      * KL - F12 - Cancel
      * KN - F14 - Settlement details
      * KP - F15 - Browse
      * KQ - F16 - Authorise
     D @EINKG          S              1A
     D @EINKH          S              1A
     D @EINKJ          S              1A
     D @EINKL          S              1A
     D @EINKN          S              1A
     D @EINKP          S              1A
     D @EINKQ          S              1A
 
      ** Condition availability of field "Funding Spread/Rate"
     D @Funding        S              1A
 
      ** Condition availability of message "Record Reversed"
     D @Reversed       S              1A
 
      ** F3 Exit
      ** F7 Roll backwards
      ** F8 Roll forwards
      ** F9 Insert
      ** F10 Delete
      ** F12 Cancel
      ** F14 - Settlement details
      ** F15 - Browse
      ** F16 - Authorise
     D @INKC           S              1A
     D @INKG           S              1A
     D @INKH           S              1A
     D @INKJ           S              1A
     D @INKL           S              1A
     D @INKN           S              1A
     D @INKP           S              1A
     D @INKQ           S              1A
 
      ** Option selected
     D @OPSEL          S              1A
 
      ** Read backwards in roll
     D @RDBCK          S              1A
 
      ** Read forwards in roll
     D @RDFWD          S              1A
 
      ** Read next browse
     D @RDNB           S              1A
 
      ** Read subfile
     D @RDSFL          S              1A
 
      ** Screen / function
     D @SCRN           S              1A
 
      ** Control return to key screen after F7/F8 rolls
 
      ** Mode of operation
     D ModeOfOp        S              6A
 
      ** Whether to clear LOAM on inserts
     D ResetLOAM       S             10A
 
      ** Indices of errors/warnings
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Fields (on key screen only) in error
     D DDRAUTOK        S              1A
     D DDRLONOK        S              1A
 
      ** Timestamp for the amendment
     D TimeStamp       S               Z
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      ** Parameters for calling AOSVALR0 (System Value Access Object)                         CLE148
     D PRetCode        S              7A                                                      CLE148
     D PSysValK1       S             20A                                                      CLE148
     D PSysVal1        S            200A                                                      CLE148
     D PSysValK2       S             20A                                                      CLE148
     D PSysVal2        S            200A                                                      CLE148
     D PSysValK3       S             20A                                                      CLE148
     D PSysVal3        S            200A                                                      CLE148
     D PSysValK4       S             20A                                                      CLE148
     D PSysVal4        S            200A                                                      CLE148
     D PSysValK5       S             20A                                                      CLE148
     D PSysVal5        S            200A                                                      CLE148
     D PSysValK6       S             20A                                                      CLE148
     D PSysVal6        S            200A                                                      CLE148
     D PSysValK7       S             20A                                                      CLE148
     D PSysVal7        S            200A                                                      CLE148
     D PSysValK8       S             20A                                                      CLE148
     D PSysVal8        S            200A                                                      CLE148
     D PSysValK9       S             20A                                                      CLE148
     D PSysVal9        S            200A                                                      CLE148
     D PSysValK10      S             20A                                                      CLE148
     D PSysVal10       S            200A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELOAMS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing ---------------------------------+
      ** ¦                                                              ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is ¦
      ** ¦ executed at program activation.                              ¦
      ** ¦                                                              ¦
      ** +--------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LELOAMS002
      *
      * Issue rollback to clear any possible updates in window functions
     C                   IF        @INKL = '1'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   EVAL      @INKL = ' '
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMS003
      *
      /COPY WNCPYSRC,LELOAMS004
      *
      ** Build browse subfile record
     C                   IF        @SCRN = 'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
      *
      ** Read next browse subfile record
     C                   IF        @SCRN = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMS005
      *
      /COPY WNCPYSRC,LELOAMS006
      *
      ** Do while screen: Loan amendment screen
     C                   DOW       @SCRN = 'D'
     C                   EXSR      Scrn@D
     C                   ENDDO
      *
      /COPY WNCPYSRC,LELOAMS007
      *
      ** Do while screen: Settlement details
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
 
      /COPY WNCPYSRC,LELOAMS008
      *
      ** Update files
     C                   IF        @SCRN = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMS009
      *
      ** Terminate program
     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELOAMS010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - Process detail screen
      *****************************************************************
     C     SCRN@D        BEGSR
 
      * Set function key status on screen
     C                   EXSR      SFKEYS
 
      * Setup default values
      *
      **  Default in details for amend type LS
     C                   If        @DDATYP = 'LS'
     C                   EVAL      DDLTYP = LO_LTYP
     C                   EVAL      @DDSTYP = LO_SUTP                                          TDA074
     C                   EVAL      @DDCLAS = LO_CLAS                                          CLE042
     C                   EndIf
 
      **  Enable 'Funding Spread/Rate' field if:
      **   - Analytical Accounting is on and the loan amendment type is
      **     a spread change,  and the loan was directly funded,  or
      **   - Revenue Analysis is on and the loan amendment type is a
      **     spread change
     C                   MOVE      'N'           @Funding                       ING194
     C                   IF        DDACTN <> *BLANKS
     C     BGN0ST        IFEQ      'Y'
     C     DDATYP        ANDEQ     'SC'                                         ING194
     C     LO_FPRC       ANDNE     *BLANKS                                      ING194
     C     CDE002        OREQ      'Y'
     C     DDATYP        ANDEQ     'SC'                                         ING194
     C                   MOVE      'Y'           @Funding
     C                   ENDIF
 
      **  Enable 'Record reversed' message if true
     C                   MOVE      'N'           @Reversed
     C     LO_RECI       IFEQ      'R'
     C                   MOVE      'Y'           @Reversed
     C                   ENDIF
     C                   ENDIF
 
      ** Write/read detail screen
     C     Dsp           TAG
     C                   If        ResetLOAM = 'DontBlank'
     C                   Eval      RetCodeIn = 'DontBlank'
     C                   EndIf
 
      ** Make sure  'Unauthorised Only?' has a default value
     C                   If        DDRAUT = ' '
     C                   Eval      DDRAUT = 'N'
     C                   EndIf
 
     C                   CALLB     'LELOAMDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input parameters :
      * Return code
     C                   PARM                    RetCodeIn
 
      ** Loan amendment in screen format
     C                   PARM                    C_LOAM_S
      *
      **  Output only screen fields : Loan type / status
     C                   PARM                    DDLTYP            2
     C                   PARM                    DDSTAT
     C                   PARM                    WLSNA
 
      ** Loan amendment OK indicators
     C                   PARM                    OKAmndScn
 
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Enabled key & detail fields
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @ESPIC            1
      *
      * Enabled function keys
      * KC - F3 - End program
      * KG - F7 - Roll backwards
      * KH - F8 - Roll forwards
      * KJ - F10 - Delete
      * KL - F12 - Cancel on details screen
      * KN - F14 - Settlement details
      * KP - F15 - Browse
      * KQ - F16 - Authorise
     C                   PARM      'Y'           @EINKG
     C                   PARM      'Y'           @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM      'Y'           @EINKP
     C                   PARM                    @EINKQ
      *
      * Field "Funding Spread/Rate" enabled
     C                   PARM                    @Funding
      *
      * Syndicated facility?
     C                   PARM                    FA_SYIN
      *
      * Reversed loan amendment
     C                   PARM                    @Reversed
      *
      * Run date
     C                   PARM                    WRUNDT
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
 
      * Output parameters :
      * Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
     C                   PARM      '0'           @INKQ
 
     C     @INKP         IFEQ      '1'
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
 
      ** For inserts, we want to clear the screen first time in.
      ** Set flag to prevent details being blanked on subsequent
      ** calls.
     C                   If        @DDACTN = 'I'
     C                   Eval      ResetLOAM = 'DontBlank'
     C                   EndIf
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
      *
      ** Reset all error fields
     C                   EXSR      ResetErr
      *
      * F3 - End program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on details screen
     C     @INKL         CASEQ     '1'           CANC@D
      *
      * F15 - Browse screen
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * F14 - Settlements
      *
      * Validate input to details screen
     C                   CAS                     VAL@D
 
     C                   ENDCS
 
     C     EndScrn@D     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - Validate input to details screen
      *****************************************************************
     C     VAL@D         BEGSR
     C                   EVAL      DDACTN = @DDACTN
     C                   EVAL      DDLOAN = @DDLOAN
     C                   EVAL      DDVDAT = @DDVDAT
     C                   EVAL      DDSEQN = @DDSEQN
     C                   EVAL      DDATYP = @DDATYP
     C                   IF        @settle <> 'Y'
     C                   EXSR      RTVLOAM
     C                   ENDIF
     C                   IF        Idx >0
     C                   GOTO      EndVAL@D
     C                   ENDIF
     C                   IF        DDACTN <> 'I' AND @EKYFD = 'Y'
     C                   EXSR      CVTLOAM
     C                   EVAL      N_LOAM_F = C_LOAM_F
     C                   IF        @DDATYP <> *BLANKS
     C                   EVAL      @DDATYP= DDATYP
     C                   ENDIF
      ** Send appropriate calling module code
     C                   Eval      CallModCod = 'KDP'
     C                   EXSR      CallVal
     C                   IF        Idx = 0
     C                   EVAL      @EKYFD = 'N'
     C                   SELECT
     C                   WHEN      DDACTN = 'A' AND DDATYP = 'PI'
     C                   EVAL      @ESPIC = 'Y'
     C                   EVAL      @EDTFD = 'N'
     C                   OTHER
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @ESPIC = 'N'
     C                   ENDSL
     C                   ENDIF
     C                   GOTO      EndVAL@D
     C                   ENDIF
 
     C                   IF        @EKYFD = 'Y' AND DDACTN = 'I'
      ** Send appropriate calling module code
     C                   Eval      CallModCod = 'KDP'
     C                   EXSR      CallVal
      * If errors returned
     C                   IF        Idx = 0                                      ING195
     C                   EVAL      @EKYFD = 'N'
     C                   EVAL      @EDTFD = 'Y'
 
     C                   IF        DDATYP = 'PI'                                ING192
     C                   EVAL      @ESPIC = 'Y'                                 ING190
     C                   ELSE                                                   ING192
     C                   EVAL      @ESPIC = 'N'                                 ING192
     C                   ENDIF                                                  ING192
 
     C                   ENDIF
     C                   GOTO      EndVAL@D                                     ING195
     C                   ENDIF
      *
      * If Reverse and F10 taken, update
     C                   IF        DDACTN = 'R' and
     C                             @INKJ = '1'
      *
      ** Send appropriate calling module code
     C                   Eval      CallModCod = 'SIN'
     C                   EXSR      CallVal
      *
      * If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
      *
      * If Authorise and F16 taken, update
     C                   IF        DDACTN = 'X' and
     C                             @INKQ = '1'  or                                            CLE030
     C                             DDACTN = 'Q' and                                           CLE030
     C                             @INKQ = '1'  and                                           CLE030
     C                             CLE030 = 'Y'                                               CLE030
      *
      ** Send appropriate calling module code
     C                   Eval      CallModCod = 'SIN'
     C                   EXSR      CallVal
      *
      * If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
 
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
 
     C                   IF        @SCRN = 'U'
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If display settlement details requested, and not insert or amend
      * (if insert or amend, need to validate first)
     C                   IF        DDACTN <> 'I' and
     C                             DDACTN <> 'A' and
     C                             @INKN = '1'
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If Enquire
     C                   IF        DDACTN = 'E'
     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EXSR      CVTLOAM
     C                   ENDIF
 
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If Insert or Amend
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
 
      * Validate loan amendment, and convert to file format
      * Store image of input screen and current number of warnings
     C                   EVAL      P_LOAM_S = C_LOAM_S
      *
      ** Send appropriate calling module code
     C                   Eval      CallModCod = 'SIN'
     C                   EXSR      CallVal
      *
      * If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If any screen defaulting or reformatting has occurred in validation
      * or if the number of warnings has changed, re-display the screen
     C                   IF        C_LOAM_S  <> P_LOAM_S OR
     C                             WIdx      <> PrvN_Warn
     C                   GOTO      EndVAL@D
     C                   ENDIF
     C                   ENDIF
      *
      * If warnings unchanged, reset error flags
     C                   MOVE      *ALL'Y'       OKAmndScn
      *
      ** If not insert, change the settlements flag to prevent screen
      ** appearing automatically.
     C                   IF        DDACTN <> 'I'
     C                   MOVE      'Y'           @Settle
     C                   ENDIF
      *
      * If F14 - settlements - pressed, reset settlements flag
     C                   IF        @INKN = '1'
     C                   MOVE      ' '           @Settle
     C                   MOVE      '0'           @INKN
     C                   ENDIF
      *
      * Otherwise, if principal increase, get settlement details if
      * required.  Update if settlement details ok or not required
     C                   IF        DDATYP = 'PI' and
     C                             @Settle = ' '
     C                   MOVE      'S'           @SCRN
     C                   ELSE
     C                   IF        DDACTN = 'I'  or
     C                             DDACTN = 'A'
     C                   MOVE      'U'           @SCRN
     C                   ENDIF
     C                   ENDIF
 
     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CallVal - Perform call to validation module
      *****************************************************************
     C     CallVal       BEGSR
 
     C                   MOVE      FTTFRT        WFTTFRT           3            213496
 
     C                   CALLB     'LELOAMVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Inputs
      ** Loan amendment in screen format
     C                   PARM                    C_LOAM_S
 
      ** Current loan amendment in file format
     C                   PARM                    C_LOAM_F
 
      * File receive instructions
      * File payment instructions
     C                   PARM                    F_REC
     C                   PARM                    F_PAY
 
      ** Loan 'A' & 'B' formats
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
 
      ** Facility 'A' & 'B' formats
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
 
      ** Front office transaction Id., associated Front office transaction Id.
      ** Repair location
     C                   PARM                    C_FRNT
     C                   PARM                    C_AFRT
     C                   PARM                    C_REPA
 
      ** Date format indicator / local currency / run day
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY
 
      ** Analytical Accounting
     C                   PARM                    BGN0ST
 
      * Authorise amends / authorise principal tfr / base rate change
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPBRCF
 
      * Tolerance for funding rate
     C***************    PARM                    FTTFRT                         213496
     C                   PARM                    WFTTFRT           3            213496
 
      * Outputs
      ** Loan amendment OK inds
     C                   PARM                    OKAmndScn
 
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
     C                   PARM                    WIdx
 
      * Calling module code
     C                   PARM                    CallModCod        3
 
      ** Features
     C                   PARM                    CDE002
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030
     C                   PARM                    CEU004
     C                   PARM                    CEU020
 
      * Valid loan amendments layout (DS) from/to caller
     C                   PARM                    N_LOAM_F
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards and forwards through amendments file
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Clear settlements flag
     C                   Eval      @Settle = *Blanks
      *
      * If action is insert, control return to key screen
      *
      * Default action code to enquiry if action insert or not valid
     C                   IF        DDACTN <> 'A' AND
     C                             DDACTN <> 'X' and                                          CLE030
     C                             DDACTN <> 'R' and
     C                             DDACTN <> 'Q'                                              CLE030
     C                   EVAL      DDACTN = 'E'
     C                   EVAL      @EKYFD = 'N'
     C                   ENDIF
      *
      * Read next or previous record on amendment file
      * according to command key taken (F7/@INKG or F8/@INKH)
     C                   IF        @INKG = '1'
     C                   EVAL      @RDFWD = *BLANK
     C                   EVAL      @RDBCK = 'Y'
     C                   ELSE
     C                   EVAL      @RDFWD = 'Y'
     C                   EVAL      @RDBCK = *BLANK
     C                   ENDIF
      *
     C                   CALLB     'LELOAMRED'
      *
      * Input parameters :
 
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
 
      * Action code
     C                   PARM                    DDACTN
 
      * Read forwards/backwards
     C                   PARM                    @RDFWD
     C                   PARM                    @RDBCK
 
      * Loan number / value date / sequence / amendment type
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT
     C                   PARM                    DDSEQN
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN
 
      * Output parameters :
      * Error message
      * Loan number / value date / sequence
     C                   PARM                    @LNSel
     C                   PARM                    @VDSel
     C                   PARM                    @SQSel
      *
      * If error message returned from read, send it to detail screen
     C                   IF        RetCodeIn <> *BLANK
     C                   EXSR      SndM@S
     C                   GOTO      EROLL
     C                   ENDIF
 
      * If amendment read
     C                   IF        @LNSel <> *BLANK
     C                   EVAL      DDLOAN = @LNSEL
     C                   EVAL      DDVDAT = @VDSEL
     C                   EVAL      DDSEQN = @SQSEL
 
      * Retrieve loan amendment
     C                   EXSR      RTVLOAM
 
      * Return to previous screen if there is an error on amendment/action
      * (the loan amendment will not have been retrieved)
     C                   IF        Idx <>0
 
 
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * Convert Loan amendment
     C                   EXSR      CVTLOAM
     C**********         EVAL      N_LOAM_F = C_LOAM_F                                        CRE073
      *
      * Put the Loan amendment on screen
     C                   EVAL      @SCRN = 'D'
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build browse subfile
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Set/reset return to key screen from primary details
      *
      * Reset read next browse subfile record
     C                   EVAL      @RDNB = *BLANK
     C                   EVAL      RetCodeIn = *BLANK
     C                   IF        @INKP = '1'
     C                   MOVE      *BLANKS       DDLOAN
     C                   MOVE      *BLANKS       DDVDAT
     C                   MOVE      *BLANKS       DDSEQN
     C                   MOVE      *BLANKS       DDATYP
     C                   ENDIF
      *
      * Build browse subfile
     C                   CALLB     'LELOAMBRW'
 
      * Input parameters :
      * Return code
     C                   PARM                    RetCodeIn
 
      * Action code
     C                   PARM                    DDACTN
 
      * Loan amendment / value date / sequence / type pointers
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSEQN            3
     C                   PARM                    DDATYP            2
      *
      ** Review from loan number
     C                   PARM                    DDRLON            6
      *
      * Multi-branching/date format indicators / run date
     C                   PARM                    BJSBRC
     C                   PARM                    BJDFIN
     C                   PARM                    WRUNDT
      *
      * Authorisation required
     C                   PARM                    @Unaut
 
      * Build subfile
     C                   PARM      'Y'           @BDSFL
 
      * Read subfile record
     C                   PARM      *BLANKS       @RDSFL
 
      * Requiring authorisation
     C                   PARM                    DDRAUT            1
      *                                                                                       CLE030
      * Features                                                                              CLE030
     C                   PARM                    CLE030                                       CLE030
      *                                                                                       CLE148
      ** Allow Alpha Loan Reference                                                           CLE148
      *                                                                                       CLE148
     C                   PARM                    wLoanAlpha                                   CLE148
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Output parameters :
      * Option selected
     C                   PARM                    @OPSEL
 
      * Loan number / value date / sequence / type selected
     C                   PARM                    @LNSel
     C                   PARM                    @VDSel
     C                   PARM                    @SQSel
     C                   PARM                    @ATSel
 
      * Command keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *
      ** Reset all error fields
     C                   EXSR      ResetErr
      *
      * If F3 taken in browse, end program
     C                   IF        @INKC = '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * If F12 taken in browse, return to key screen
     C                   IF        @INKL = '1'
     C                   CLEAR                   C_LOAM_S
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDSTAT = *BLANKS
     C                   MOVEL     ' '           @Settle
     C                   EVAL      @EKYFD = 'Y'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @ESPIC = 'N'
     C                   EVAL      @SCRN = 'D'
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      * If Insert (F9) selected from browse, go to key screen
     C                   IF        @OPSEL = 'I'
      *
      ** Enable F12 on key screen
     C                   EVAL      @SCRN = 'D'
     C                   CLEAR                   C_LOAM_S
     C                   EVAL      DDSTAT = *BLANKS
     C                   MOVEL     ' '           @Settle
     C                   EVAL      @DDACTN = 'I'
     C                   EVAL      @EKYFD = 'Y'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @ESPIC = 'N'
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * If error message returned from browse, send it to browse screen
     C                   IF        RetCodeIn  <> *BLANK
     C                   EXSR      SndM@S
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * If loan selected read from subfile
     C                   IF        @OPSel <> *BLANK
      *
      * Retrieve loan amendment
     C                   EVAL      DDACTN = @OPSEL
     C                   EVAL      DDLOAN = @LNSel
     C                   EVAL      DDVDAT = @VDSel
     C                   EVAL      DDSEQN = @SQSel
     C                   EVAL      DDATYP = @ATSel
     C                   EXSR      RTVLOAM
     C                   IF        Idx = 0
     C                   EXSR      CVTLOAM
     C**********         EVAL      N_LOAM_F = C_LOAM_F                                        CRE073
     C                   IF        Idx = 0
     C                   Eval      CallModCod = 'SIN'
     C                   EXSR      CallVal
     C                   IF        Idx = 0
     C                   EVAL      @EKYFD = 'N'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @Settle= 'Y'
     C                   IF        DDACTN = 'A' AND DDATYP = 'PI'
     C                   EVAL      @ESPIC = 'Y'
     C                   ELSE
     C                   EVAL      @ESPIC = 'N'
     C                   ENDIF
     C                   EVAL      @SCRN = 'D'
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        @INKL = '0'
     C                   EVAL      @RDNB = 'Y'
     C                   ENDIF
 
     C                   ELSE
      *
      * Reset positioning fields
     C                   EVAL      DDACTN = *BLANK
     C                   EVAL      DDLOAN = *BLANK
     C                   EVAL      DDVDAT = *BLANK
     C                   EVAL      DDSEQN = *BLANK
     C                   ENDIF
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Store image of input screen
     C                   EVAL      P_LOAM_S = C_LOAM_S
      *
     C                   CALLB     'LELOAMBRW'
 
      * Input parameters :
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
 
      * Action code
     C                   PARM      *BLANKS       DDACTN
 
      * Loan amendment / value date / sequence / type pointers
     C                   PARM      *BLANKS       DDLOAN
     C                   PARM      *BLANKS       DDVDAT
     C                   PARM      *BLANKS       DDSEQN
     C                   PARM      *BLANKS       DDATYP
      *
      ** Review from loan number
     C                   PARM      *BLANKS       DDRLON
      *
      * Multi-branching/date format indicators / run date
     C                   PARM                    BJSBRC
     C                   PARM                    BJDFIN
     C                   PARM                    WRUNDT
      *
      * Display 'Unauthorised only?'
     C                   PARM                    @Unaut
 
      * Build subfile
     C                   PARM      *BLANKS       @BDSFL
 
      * Read subfile record
     C                   PARM      'Y'           @RDSFL
      *
      * 'Unauthorised Only?' to/from caller
     C                   PARM                    DDRAUT
      *                                                                                       CLE030
      * Features                                                                              CLE030
     C                   PARM                    CLE030                                       CLE030
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Output parameters :
 
      * Option selected
     C                   PARM                    @OPSEL
 
      * Loan number / value date / sequence / type selected
     C                   PARM                    @LNSel
     C                   PARM                    @VDSel
     C                   PARM                    @SQSel
     C                   PARM                    @ATSel
 
      * Command keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *
      * If loan selected read from subfile
     C                   IF        @OPSel <> *BLANK
      *
      * Retrieve loan amendment
     C                   EVAL      DDACTN = @OPSEL
     C                   EVAL      DDLOAN = @LNSel
     C                   EVAL      DDVDAT = @VDSel
     C                   EVAL      DDSEQN = @SQSel
     C                   EVAL      DDATYP = @ATSel
     C                   EXSR      RTVLOAM
     C                   IF        Idx = 0
     C                   EXSR      CVTLOAM
     C                   EVAL      N_LOAM_F = C_LOAM_F
     C                   IF        Idx = 0
     C                   Eval      CallModCod = 'SIN'
     C                   EXSR      CallVal
     C                   IF        Idx = 0
     C                   EVAL      @EKYFD = 'N'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @Settle= 'Y'
     C                   IF        DDACTN = 'A' AND DDATYP = 'PI'
     C                   EVAL      @ESPIC = 'Y'
     C                   ELSE
     C                   EVAL      @ESPIC = 'N'
     C                   ENDIF
     C                   EVAL      @SCRN = 'D'
      *
      * Else, rebuild subfile browse
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Else, rebuild subfile browse
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVLOAM - Retrieve loan amendment
      *****************************************************************
     C     RTVLOAM       BEGSR
      *
      * Retrieve loan amendment
     C                   CALLB     'LELOAMRTV'
      *
      * INPUTS
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM      '      '      ModeofOp
      *
      * Response mode
     C                   PARM      'S'           RespMode
      *
      * Action code
     C                   PARM                    DDACTN
      *
      * Front office transaction Id
     C                   PARM                    C_FRNT
      *
      * Loan number / value date / sequence / type
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT
     C                   PARM                    DDSEQN
     C                   PARM                    DDATYP
 
      * Where called from
     C                   PARM                    CallModCod
      *
      * Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN
      *
      * Outputs
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    C_LOAM_F
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
      *
      * Error Indicators
     C                   PARM                    OKAmndScn
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
     C                   PARM                    N_LOAM_F                                     CRE073
 
     C     EndRTVLOAM    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTLOAM - convert loan amendment to screen format
      *****************************************************************
     C     CVTLOAM       BEGSR
      *
      * Call program to fill screen fields with data from LOAMSDK
     C                   CALLB     'LELOAMCVT'
      *
      * Output parameters
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Loan amendment in file format
     C                   PARM                    C_LOAM_F
      *
      * Date format indicator
     C                   PARM                    BJDFIN
 
      ** Output parameters
      ** Loan amendment in screen format
     C                   PARM                    C_LOAM_S
      *
      ** Output only screen field : Loan status
     C                   PARM                    DDSTAT           16
     C                   PARM                    N_LOAM_F                                     CRE073
      *
      ** Add the action code
     C                   MOVE      DDACTN        @DDACTN
 
      ** If no amendment type was entered, update screen field, else
      ** move screen field to file to be validated
     C                   If        DDATYP = *Blank
     C                   MOVE      @DDATYP       DDATYP
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - Set function key status on screen
      *****************************************************************
     C     SFKEYS        BEGSR
 
      * Enable/disable function keys
      * KJ = F10 = Confirm delete
     C                   IF        DDACTN = 'R' and
     C                             Idx    = 0
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
 
      * KQ = F16 = Confirm authorisation
     C                   IF        DDACTN = 'X' and
     C                             Idx    = 0   or                                            CLE030
     C                             DDACTN = 'Q' and                                           CLE030
     C                             CLE030 = 'Y' and                                           CLE030
     C                             Idx    = 0                                                 CLE030
     C                   EVAL      @EINKQ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKQ = 'N'
     C                   ENDIF
 
      * KN = F14 = Settlements
     C                   IF        @DDATYP = 'PI'
     C                   EVAL      @EINKN = 'Y'
     C                   ELSE
     C                   EVAL      @EINKN = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SndM@S - Send messages to screens
      *****************************************************************
     C     SndM@S        BEGSR
      *
      ** Add error message to array passed to detail screen
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     RetCodeIn     MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - Cancel on details screen
      *****************************************************************
     C     CANC@D        BEGSR
      *
     C                   IF        @EKYFD = 'Y'
      * Return to previous screen
     C                   Eval      DDACTN = *Blanks
     C                   Eval      DDLOAN = *Blanks
     C                   Eval      DDSEQN = *Blanks
     C                   Eval      DDVDAT = *Blanks
     C                   Eval      DDATYP = *Blanks
     C                   Eval      DDSTAT = *Blanks
     C                   Eval      @Reversed = 'N'
     C                   Eval      @Settle = *Blanks
     C                   Eval      ResetLOAM = *Blanks
     C                   EVAL      C_LOAM_S = *BLANKS
     C                   EVAL      @EDTFD = 'N'                                 ING191
     C                   EVAL      @ESPIC = 'N'                                 ING191
     C                   ENDIF
 
     C                   IF        @EKYFD = 'N'
     C                   EVAL      @EKYFD = 'Y'
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * Clear settlements flag
     C                   MOVEL     ' '           @Settle
      *
      * If there is no front office ID, use the PCREF created by LELOAMVAL.
     C                   If        LAFRNT = *Blank
     C                   MOVEL     LAPCRF        LAFRNT
     C                   EndIf
      *
      * Loan amendment updates
     C                   CALLB     'LELOAMUPD'
     C                   PARM      *BLANKS       @RTCD
 
      ** Action requested and amendment details
     C                   PARM                    DDACTN
     C                   PARM                    N_LOAM_F
 
      * Calling module code
     C                   PARM                    CallModCod
 
      ** Reservation ID (input from VU only)
     C                   PARM                    ResrvId          10
 
      * Features
     C                   PARM                    CDE001
     C                   PARM                    CDE005
     C                   PARM                    CEU004
     C                   PARM                    CEU020
     C                   PARM                    CLE002
     C                   PARM                    CLE005
     C                   PARM                    CLE009
     C                   PARM                    CLE014
     C                   PARM                    CLE023
     C                   PARM                    CLE030                                       CLE030
 
      * Authorise amends / authorise principal tfr / consolidated conf.
     C                   PARM                    BPLMAU
     C                   PARM                    BPTPAU
     C                   PARM                    BPCONR
 
      ** Date format indicator, local currency & run day number
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    WRNDAY
 
      ** Multi-branching
     C                   PARM                    BGMBIN
 
      * Which system is active (24x7)
     C                   PARM                    System
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program. Otherwise, commit the updates
     C                   IF        @RTCD <> *BLANK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
 
      ** If insert successful, make sure that the settlement details
      ** wil be reset.
     C                   Eval      D#LOAN = *Blanks
     C                   Eval      D#VDAT = *Blanks
     C                   Eval      D#SEQN = *Blanks
 
      ** For inserts, we want to clear the screen first time in.
      ** Clear flag to force details to be blanked on first call.
     C                   Eval      ResetLOAM = *Blanks
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
     C
     C                   IF        @RTCD = '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   ENDIF
      *
      * If records are still to be read from the subfile, read them
     C                   IF        @RDNB = 'Y'
     C                   EXSR      ResetErr
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
      *
      * Else, return to the key or browse screen
     C                   IF        DDACTN = 'I'
     C                   EVAL      RetCodeIn = 'USR5002'
     C                   EXSR      SndM@S
      *
      ** Put last sequence number on key screen and clear the valid layout
     C                   MOVEL     LALASN        WLSNA             3
     C                   ENDIF
     C                   EVAL      @SCRN = 'D'
      ** Reset all error fields
     C                   EXSR      ResetErr
     C                   CLEAR                   N_LOAM_F
     C                   CLEAR                   C_LOAM_S
     C                   EVAL      DDACTN = *BLANKS
     C                   EVAL      DDSTAT = *BLANKS
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErr - Reset errors
      *****************************************************************
     C     ResetErr      BEGSR
 
      * Reset errors
     C                   MOVE      *ALL'Y'       OKAmndScn
     C                   EVAL      DDRAUTOK   = *BLANK
     C                   EVAL      DDRLONOK   = *BLANK
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Idx        = *ZERO
     C                   EVAL      WIdx       = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   EVAL      @SCRN = 'T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details evoked for        *
      *          inserts, amends, enquiries & authorisations          *
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      **  Reset key
     C                   MOVE      '0'           @INKN
      *
      ** If first time for this amendment, set up details
     C     DDLOAN        IFNE      D#LOAN
     C     DDVDAT        ORNE      D#VDAT
     C     DDSEQN        ORNE      D#SEQN
     C                   EXSR      DETP@S
     C                   ENDIF
      *
      ** Save details for this amendment
     C                   MOVEL     DDLOAN        D#LOAN            6
     C                   MOVEL     DDVDAT        D#VDAT            6
     C                   MOVEL     DDSEQN        D#SEQN            3
      *
      ** If no changes are allowed, protect (but still validate)
      ** all instructions by passing action code 'X' to ZASETINSIN
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C                   MOVEL     'X'           ##ACTN
     C                   ELSE
     C                   MOVEL     DDACTN        ##ACTN
     C                   ENDIF
     C                   MOVEL     LO_CNUM       ##CSNM
      *
      **  Settlement instructions input
     C                   CALLB     'ZASETINSIN'
      *
      **  Inputs
      **  Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      **  Action code
     C                   PARM                    ##ACTN            1
      *
      **  Loan number
     C                   PARM      DDLOAN        ##LOAN            6
      *
      **  Protect payment
     C                   PARM                    ##PPAY            1
      *
      **  Protect receive
     C                   PARM                    ##PREC            1
      *
      **  Calling program
     C                   PARM      'LOAM'        ##CALP            4
      *
      **  Payment currency
     C                   PARM      LO_CCY        ##PCCY            3
      *
      **  Receive currency
     C                   PARM      LO_CCY        ##RCCY            3
      *
      **  Customer shortname
     C                   PARM                    ##CSNM           10
      *
      **  Transaction type
     C                   PARM      DDATYP        ##TTYP            2
      *
      **  Federal funds indicator
     C                   PARM      *BLANK        ##FFND            1
      *
      **  Booking branch
     C                   PARM      LO_BRCA       ##BRCA            3
      *
      **  Receipt date
     C                   PARM                    ##DATR            5 0
      *
      **  Payment date
     C                   PARM                    ##DATP            5 0
      *
      ***  Payment instructions
     C                   PARM                    S_PAY
      *
      ***  Receive instructions
     C                   PARM                    S_REC
      *
      ***  FRA/IRS instructions
     C                   PARM                    S_FRI
      *
      ***  Outputs
      ***  Payment instructions
     C                   PARM                    F_PAY
      *
      ***  Receive instructions
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
     C                   PARM                    F_FRI
      *
      ***  Function keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL
      *
      ***  Save fields received from settlement screen
     C                   MOVEL     FLBENN        LAFACO
      *
      **  F3 - End program
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  F12 - Cancel on settlement details
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      ***  Exit from settlement details
     C                   CAS                     EXIT@S
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
      *
      ** Reset screen payment instructions on first run through
     C                   Clear                   S_PAY
     C                   Clear                   S_REC
      *
      **  Protect all fields in settlement instructions
     C                   MOVEL     'Y'           ##PPAY
     C                   MOVEL     'Y'           ##PREC
      *
      ** Principal increases for loans and parts purchased need
      ** pay settlements, parts sold need receive settlements
     C                   MOVE      *BLANKS       PTYPE             4
     C     LO_PTYP       IFEQ      66
     C     LO_PTYP       OREQ      67
     C     LO_PTYP       OREQ      69
     C     LO_PTYP       OREQ      72
     C                   MOVE      'PTSO'        PTYPE
     C                   ENDIF
      *
     C                   IF        DDACTN = 'I' or
     C                             DDACTN = 'A'
     C                   IF        PTYPE = 'PTSO'
     C                   MOVE      'N'           ##PREC
     C                   ELSE
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up date of receipt/payment
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   Z-ADD     ZDAYNO        ##DATR
     C                   Z-ADD     ZDAYNO        ##DATP
      *
      ** Set up payment instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   IF        (DDACTN = 'I')                                             TDA066
     C     PType         IFNE      'PTSO'
     C                   CLEAR                   FLREC
     C                   Z-ADD     0             FLRSTM
     C                   MOVE      *BLANKS       FLRONS                                       TDA076
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     LO_PSTM       FLPSTM                                       CGL029
     C                   MOVEL     LO_CVMR       FLCVMR
     C                   MOVEL     LO_SCCY       FLPSCY
     C                   MOVEL     LO_ICCY       FLIC72
     C                   MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LO_PEXR       FLPEXR                                       CLE031
     C                   MOVE      LO_PEXI       FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ** If part sold, receive branch is our start date branch
     C                   ELSE
     C                   CLEAR                   FLPAY
     C                   Z-ADD     0             FLPSTM
     C                   MOVE      *BLANKS       FLPONS                                       TDA076
     C                   MOVE      LO_OSDB       FLROBR
      *
      ** Set up receive instructions from loan / loan amendment
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     LO_RSTM       FLRSTM                                       CGL029
     C                   MOVEL     LO_SCCY       FLRSCY
     C**********         MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LO_REXR       FLREXR                                       CLE031
     C                   MOVE      LO_REXI       FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ELSE                                                                 TDA066
      *                                                                                       TDA066
      ** On action other than insert, setup setllement instructions                           TDA066
      ** from current loan amendment.                                                         TDA066
     C                   IF        (PType <> 'PTSO')                                          TDA066
     C                   MOVEL     LAPAY         FLPAY                                        TDA066
     C                   MOVEL     LAPAYEx       FLPONS                                       TDA066
     C                   MOVEL     LAPSTM        FLPSTM                                       TDA066
     C                   MOVEL     LACVMR        FLCVMR                                       TDA066
     C                   MOVEL     LAPSCY        FLPSCY                                       TDA066
     C                   MOVEL     LAICCY        FLIC72                                       TDA066
     C                   MOVE      LAOSBR        FLPOBR                                       TDA066
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAPEXR        FLPEXR                                       CLE031
     C                   MOVE      LAPEXI        FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ELSE                                                                 TDA066
     C                   MOVEL     LAREC         FLREC                                        TDA066
     C                   MOVEL     LARECEx       FLRONS                                       TDA066
     C                   MOVE      LAOSBR        FLROBR                                       TDA066
     C                   MOVEL     LARSTM        FLRSTM                                       TDA066
     C                   MOVEL     LASCCY        FLRSCY                                       TDA066
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAREXR        FLREXR                                       CLE031
     C                   MOVE      LAREXI        FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                TDA066
     C                   ENDIF                                                                TDA066
      *
      ***  If settlement instructions are not defined,
      ***  and payment/receipt dates aren't in the past, default them
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
     C     FLRSTM        OREQ      *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     LO_CNUM       ##CSNM
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      ***  Calling program
     C                   PARM      'LEND'        ##CALP
      *
      ***  Payment currency
     C                   PARM      LO_CCY        ##PCCY
      *
      ***  Receive currency
     C                   PARM      LO_CCY        ##RCCY
      *
      ***  Customer shortname
     C                   PARM                    ##CSNM
      *
      ***  Loan type
     C                   PARM      *BLANKS       ##TTYP
      *
      ***  Federal funds indicator
     C                   PARM      *BLANK        ##FFND
      *
      ***  Version of ISDA rules
     C                   PARM      *BLANK        BQISDA            4
      *
      ***  Type of ISDA agreement
     C                   PARM      *BLANK        BQAGTY            6
      *
      ***  Date of ISDA agreement
     C                   PARM      *BLANK        BQAGDT            6
      *
      ***  Version of ISDA agreement
     C                   PARM      *BLANK        BQAGVV            2
      *
      ***  Version of ISDA agreement century
     C                   PARM      *BLANK        Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      ***  Payment instructions
     C                   PARM                    F_PAY
      *
      ***  Receive instructions
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
     C                   PARM                    F_FRI
      *
     C                   ENDIF
      *
      * Clear payment instructions if protected
      *
      ***  Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      ***  File payment settlement instructions
     C                   PARM                    F_PAY
      *
      ***  File receipt settlement instructions
     C                   PARM                    F_REC
      *
      ***  File FRA/IRS settlement instructions
     C                   PARM      *BLANK        F_FRI
      *
      ***  Outputs
      ***  Screen payment settlement instructions
     C                   PARM      *BLANK        S_PAY
      *
      ***  Screen Receipt settlement instructions
     C                   PARM      *BLANK        S_REC
      *
      ***  Screen FRA/IRS settlement instructions
     C                   PARM      *BLANK        S_FRI
     C                   PARM      LO_CCY        #TRCCY                                      CSF011A
     C                   PARM      LO_CCY        #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ** Return to previous screen
     C                   CLEAR                   S_REC
     C                   CLEAR                   S_PAY
     C                   CLEAR                   F_REC
     C                   CLEAR                   F_PAY
     C                   CLEAR                   D#LOAN
     C                   MOVEL     'D'           @SCRN
     C                   MOVEL     'Y'           @Settle
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen                  *
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      **  Return to detail screen
     C                   MOVEL     'D'           @SCRN
      *
      ** If settlement details valid
     C     RetCodeIn     IFNE      '*ERRORS'
      *
      **  Set settlements flag
     C                   MOVEL     'Y'           @Settle           1
      *
      **  Update valid loam: payment settlement instructions
     C**********         MOVEL     FLPAY         CLPAY                                        TDA066
     C**********         MOVEL     FLPONS        CLPAYEx                               CGL029 TDA066
     C                   MOVEL     FLPAY         LAPAY                                        TDA066
     C                   MOVEL     FLPONS        LAPAYEx                                      TDA066
     C                   MOVEL     FLPSTM        LAPSTM                                       CGL029
     C                   MOVEL     FLCVMR        LACVMR
      *
      **  Update valid loam: receipt settlement instructions
     C**********         MOVEL     FLREC         CLREC                                        TDA066
     C**********         MOVEL     FLRONS        CLRECEx                               CGL029 TDA066
     C                   MOVEL     FLREC         LAREC                                        TDA066
     C                   MOVEL     FLRONS        LARECEx                                      TDA066
     C                   MOVEL     FLRSTM        LARSTM                                       CGL029
      *
      ***  Update valid loam: settlement currency & 'IN' ccy in field 72
     C                   MOVEL     FLPSCY        LASCCY
     C                   MOVEL     FLIC72        LAICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        LAREXR                                       CLE031
     C                   Z-ADD     FLPEXR        LAPEXR                                       CLE031
     C                   MOVE      FLREXI        LAREXI                                       CLE031
     C                   MOVE      FLPEXI        LAPEXI                                       CLE031
     C                   MOVE      FLRSCY        LASCCY                                       CLE031
     C                   MOVE      FLPSCY        LAPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C     PType         IFNE      'PTSO'                                                     TDA066
     C                   MOVE      FLPOBR        LAOSBR                                       TDA066
     C                   ELSE                                                                 TDA066
     C                   MOVE      FLROBR        LAOSBR                                       TDA066
     C                   ENDIF                                                                TDA066
      *
      ***  Update current loan amendment
     C                   MOVEL     N_LOAM_F      C_LOAM_F
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go to initial screen (key or browse)
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset read next browse subfile record (if active)
     C                   If        @SCRN = 'R'
     C                   EVAL      @RDNB  = *BLANK
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
      * Otherwise go to key detail screen
     C                   If        @SCRN <> 'B'
     C***************    MOVEL     'K'           @SCRN
     C                   MOVEL     'D'           @SCRN
      *
      * Blank the screen
     C                   EVAL      C_LOAM_S = *BLANK
     C                   ENDIF
     C                   MOVEL     @SCRN         WSCRN             1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
     C                   MOVEL     'LELOAMSIN'   DBPGM
      *
      ** Set up key fields
     C     KLAKEY        KLIST
     C**********         KFLD                    WKLNR             6 0                       CLE148
     C                   KFLD                    WKLNR             6                         CLE148
     C                   KFLD                    WKVDT             5 0
     C                   KFLD                    WKLSN             3 0
      *
      ** Determine if CDE001 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CDE001            1
     C                   ELSE
     C                   MOVEL     'Y'           CDE001
     C                   ENDIF
      *
      ** Determine if CDE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CDE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CDE002
     C                   ENDIF
 
      ** Determine if CDE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CDE005            1
     C                   ELSE
     C                   MOVEL     'N'           CDE005
     C                   ENDIF
 
      ** Determine if CEU004 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU004            1
     C                   ELSE
     C                   MOVEL     'N'           CEU004
     C                   END
 
      ** Determine if CEU020 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CEU020            1
     C                   ELSE
     C                   MOVEL     'N'           CEU020
     C                   END
 
      ** Determine if CLE002 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE002            1
     C                   ELSE
     C                   MOVEL     'N'           CLE002
     C                   END
 
      ** Determine if CLE003 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE003            1
     C                   ELSE
     C                   MOVEL     'N'           CLE003
     C                   END
 
      ** Determine if CLE005 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE005            1
     C                   ELSE
     C                   MOVEL     'N'           CLE005
     C                   ENDIF
 
      ** Determine if CLE009 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE009            1
     C                   ELSE
     C                   MOVEL     'N'           CLE009
     C                   ENDIF
 
      ** Determine if CLE014 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE014            1
     C                   ELSE
     C                   MOVEL     'N'           CLE014
     C                   END
 
      ** Determine if CLE023 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CLE023            1
     C                   ELSE
     C                   MOVEL     'N'           CLE023
     C                   END
      *                                                                                       CLE030
      ** Determine if CLE030 is switched on                                                   CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD                                        CLE030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE030
     C                   IF        @RTCD = *BLANK                                             CLE030
     C                   MOVEL     'Y'           CLE030            1                          CLE030
     C                   ELSE                                                                 CLE030
     C                   MOVEL     'N'           CLE030                                       CLE030
     C                   END                                                                  CLE030
 
      ** Determine if CSC011 is switched on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSC011            1
     C                   ELSE
     C                   MOVEL     'N'           CSC011
     C                   END
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ** File / Data area Accesses required for calling parameters
      ** Access bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM                    DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve customer lending ICD
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCLND        PARM                    DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Midas Module details
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM                    DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Analytical Accounting Module is switched on, access
      ** profit centre accounting details
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDPCACPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @Optn         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 5                                                  CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * If CSC011 is installed and in switchover mode, use
      * S1DATE from DTAARA/SC24x7 as the run day number.
     C                   IN        SC24X7
     C                   IN        SDSTAT
      *
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   CALLB     'ZDATE2'
     C                   PARM      S1DATE        ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Z-ADD     S1DATE        WRNDAY            5 0
     C                   MOVEL     ZADATE        WRUNDT            7
     C                   MOVE      'S'           System            1
 
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   MOVE      BJMRDT        WRUNDT
     C                   MOVE      'M'           System
     C                   ENDIF
      *
      ** Check if authorisation is required
     C     BPLMAU        IFEQ      'Y'
     C     CLE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @Unaut            1
     C                   ENDIF
      *
      * Go to key screen
     C                   MOVE      *ALL'Y'       OKAmndScn
     C                   EXSR      INITIAL
     C                   EVAL      @EKYFD = 'Y'                                               TDA053
      *                                                                                       CLE148
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Return Code (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM      *BLANKS       PRetCode                                     CLE148
      *                                                                                       CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysValK1                                    CLE148
      *                                                                                       CLE148
      ** Value returned (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM      *BLANKS       PSysVal1                                     CLE148
     C                   PARM                    PSysValK2                                    CLE148
     C                   PARM      *BLANKS       PSysVal2                                     CLE148
     C                   PARM                    PSysValK3                                    CLE148
     C                   PARM      *BLANKS       PSysVal3                                     CLE148
     C                   PARM                    PSysValK4                                    CLE148
     C                   PARM      *BLANKS       PSysVal4                                     CLE148
     C                   PARM                    PSysValK5                                    CLE148
     C                   PARM      *BLANKS       PSysVal5                                     CLE148
     C                   PARM                    PSysValK6                                    CLE148
     C                   PARM      *BLANKS       PSysVal6                                     CLE148
     C                   PARM                    PSysValK7                                    CLE148
     C                   PARM      *BLANKS       PSysVal7                                     CLE148
     C                   PARM                    PSysValK8                                    CLE148
     C                   PARM      *BLANKS       PSysVal8                                     CLE148
     C                   PARM                    PSysValK9                                    CLE148
     C                   PARM      *BLANKS       PSysVal9                                     CLE148
     C                   PARM                    PSysValK10                                   CLE148
     C                   PARM      *BLANKS       PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   EVAL      PRetCode = *BLANKS                                         CLE148
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   EVAL      PSysVal1 = *BLANKS                                         CLE148
      *                                                                                       CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
      *                                                                                       CLE148
      ** If Error retrieving the System values                                                CLE148
      *                                                                                       CLE148
     C                   IF        %ERROR OR PRetCode <> *BLANKS                              CLE148
     C                             OR (*INU7 = *ON AND *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 7                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = PsProcPgm                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELOAMS011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
