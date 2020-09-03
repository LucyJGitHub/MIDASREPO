     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Invalid loan amendments repair')              *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LELOAMRPR - Invalid loan amendments repair function          *
      *                                                               *
      *  Function:  This function allows invalid loan amendments to   *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD029046           Date 27Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD021423E          Date 12Sep13               *
      *                 AR868380           Date 11Jun13               *
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
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA066             Date 22Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 01Dec03               *
      *                 222373             Date 29Oct03               *
      *                 CLE030             Date 02Oct02               *
      *                 CAP075  *CREATE    Date 05Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD029046 - Default Principal Increase settlement from        *
      *             SSI (standard settlement instructions) before     *
      *             trying to default from loan.                      *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA066 - Wrong settlement method and account when enquired.  *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  222373 - Parameter Mismatch                                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP075 - Lending API enhancements - Loan Amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid amendments by timestamp/FO id
     FLEILOAML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEILOAMD0:LEILOAMX0)
 
      ** Invalid amendments by FO id/timestamp
     FLEILOAML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LELOAMR001
 
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
      ** ¦ Arrays and data structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60)
 
      ** Array of fields in error, temporary store
     D TmpFldNmAr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs, temporary store
     D TmpMsgIdAr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      * Current loan amendment in file format
     D C_LOAM_F      E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(C_)
 
      * Current loan amendment in screen format
     D C_LOAM_S      E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@)
 
      * New loan amendment in file format
     D N_LOAM_F      E DS                  EXTNAME(LEVLOAMPD)
     D  LAREC                335    389                                                       TDA066
     D  LAPAY                404    948                                                       TDA066
     D  LARECEx             1195   1212                                                       TDA066
     D  LAPAYEx             1213   1230                                                       TDA066
 
      * New loan amendment in screen format
     D N_LOAM_S      E DS                  EXTNAME(LELOAMPD)
 
      * Previous loan amendment in screen format
     D P_LOAM_S      E DS                  EXTNAME(LELOAMPD)
     D                                     PREFIX(@P)
 
      * File receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
      * File payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
      * File FRA/IRS instructions (needed as a parameter for call
      * to ZASETINVAL etc)
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      *
      *  Screen FRA/IRS instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      * Error indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)
 
      ** Customer lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** PCA ICD details
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * LE Amendment extra data in file (D/B) format
     D ExtData       E DS                  EXTNAME(LELOEXPD)
      *
      ***  Loan details 'A' format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                542   1086                                                       CGL029
     D  CLRECEx             1597   1614                                                       CGL029
     D  CLPAYEx             1615   1632                                                       CGL029
      *
      ***  Loan details 'B' format
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
      ***  Facility details 'A' format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
      *
      ***  Facility details 'B' format
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
 
      * 24X7 data area structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      * SDSTAT data area structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Condition availability of function keys:
      * KG - F7 - Roll backwards
      * KH - F8 - Roll forwards
      * KJ - F10 - Delete
      * KN - F14 - Settlement details
      * KP - F15 - Browse
      * KQ - F16 - Authorise
     D @EINKG          S              1A
     D @EINKH          S              1A
     D @EINKJ          S              1A
     D @EINKN          S              1A
     D @EINKP          S              1A
     D @EINKQ          S              1A
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  Comitjobs              4    103                                                       CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @StmpSel        S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Retrieve mode - front office id or by loan/value date/seqn
     D @@Mode          S              6A
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('LELOAMPD')
 
     D Field1          S             10A   INZ('DDACTN')
 
     D FldOffsetA      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D COBMode         S              1A   INZ(*BLANKS)                                    MD021423E
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LELOAMR002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** ¦ Note that this module uses logic-cycle processing; it will     ¦
      ** ¦ repeat the main processing until 'return' is specified.        ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LELOAMR003
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
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMR004
      *
      * Browse invalid inputs
     C                   IF        @SCRN = 'B'
     C                   EXSR      SCRN@B
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMR005
      *
      ** Read next browse subfile record
     C                   IF        @SCRN = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMR006
      *
      ** Do while: display details screen
     C                   EXSR      SNDM@D
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   DOW       @SCRN = 'D'
     C                   EXSR      SCRN@D
     C                   ENDDO
      *
      /COPY WNCPYSRC,LELOAMR011
      *
      ** Do file updates
     C                   IF        @SCRN = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,LELOAMR012
      *
      ** Terminate program
     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LELOAMR013
 
      /EJECT
      *****************************************************************
      * SCRN@B - Browse invalid Amendments
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * Reset read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build browse subfile
     C                   CALLB     'LELOAMRPB'
      *
      * Input parameters
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Build subfile
     C                   PARM      'Y'           @BDSFL            1
      * Read subfile record
     C                   PARM      *BLANKS       @RDSFL            1
      *
      * Multi-branching indicator / runday
     C                   PARM                    BJSBRC
     C                   PARM                    WRUNDT
      *
      * Error in update of previous loan amendment
     C                   PARM                    @ERRUP            1
      *
      * Output parameters
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Option selected
     C                   PARM                    @OPSEL            1
      *
      * Action selected
     C                   PARM                    @ACSEL            1
      *
      * FO transaction ID selected
     C                   PARM                    @FrntSel         20
      *
      * Timestamp of amendment selected
     C                   PARM                    @StmpSel
      *
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * Enhancements for CSC022                                                               CSC022
     C                   PARM                    CSC022                                       CSC022
      *                                                                                       CSC022
      * If error set on external switches
     C                   IF        @ERRMS <> *BLANK
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
      * If F3 or F12 taken in browse, or error message, end
     C                   IF        @INKC = '1' OR
     C                             @INKL = '1' OR
     C                             @ERRMS <> *BLANK
     C                   EXSR      ENDA
     C                   GOTO      ESCRN@B
     C                   ENDIF
      *
      * Read next browse subfile record
     C                   EVAL      @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read next subfile record
     C                   CALLB     'LELOAMRPB'
      *
      * Input parameters
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Build subfile
     C                   PARM      *BLANK        @BDSFL
      *
      * Read subfile record
     C                   PARM      'Y'           @RDSFL
      *
      * Multi-branching indicator / runday
     C                   PARM                    BJSBRC
     C                   PARM                    WRUNDT
      *
      * Error in update of previous loan amendment
     C                   PARM                    @ERRUP
      *
      * Output parameters
      * Error message
     C                   PARM      *BLANK        @ERRMS
      *
      * Option selected
     C                   PARM      *BLANK        @OPSEL
      *
      * Action selected
     C                   PARM      *BLANK        @ACSEL
      *
      * FO transaction ID selected
     C                   PARM      *BLANK        @FrntSel
      *
      * Timestamp of amendment selected
     C                   PARM                    @StmpSel
      *
      * Command keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      * Enhancements for CSC022                                                               CSC022
     C                   PARM                    CSC022                                       CSC022
      *                                                                                       CSC022
      * If F3 taken within invalid amendment deletion function,
      * end program
     C                   IF        @INKC = '1'
     C                   EXSR      ENDA
     C                   GOTO      ERDNBRW
     C                   ENDIF
      *
      * If invalid customer read from subfile
     C                   IF        @OPSEL <> *BLANK
      *
      * Clear file/screen formats
     C                   CLEAR                   N_LOAM_F
     C                   CLEAR                   N_LOAM_S
      *
      * Reset errors
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   Z-ADD     0             Idx
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   Z-ADD     0             WIdx
      *
      * Retrieve Amendment details
     C                   EVAL      DDACTN = @ACSEL
     C                   EVAL      DDFRNT = @FrntSel
      *
      * Make sure invalid amendment's details are passed to 'Retrieve'
      * module for SPF checking.
     C     ZATRNKX0      CHAIN     LEILOAMX0                          99
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      * Otherwise
      *  Set retrieve mode to blank (Access using Midas loan reference).
     C                   IF        DDACTN = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = '      '
     C                   ENDIF
      *
     C                   EXSR      RTVTRN
      *
      * If loan amendment details were retrieved, convert to
      * screen format.
     C**********         IF        C_LNRF <> 0 AND                                            CLE148
     C                   IF        C_LNRF <> *BLANKS AND                                      CLE148
     C                             DDACTN <> 'I'
     C                   EXSR      CVTTRN
     C**********         MOVEL     C_LOAM_F      N_LOAM_F                                     CRE073
     C                   ENDIF
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid Amendments file (except for the Midas Loan
      * reference retrieved above using the front office transaction ID).
      * Access invalid Amendment with timestamp and front office transaction ID.
      *
      * Amendment details:
     C     ZATRNKX0      CHAIN     LEILOAMX0                          99
      *
      * If Amendment details were retrieved and this is an amendment
      * and data substitution is on, scan for the substitution character
     C**********         IF        C_LNRF <> 0 AND                                            CLE148
     C                   IF        C_LNRF <> *BLANKS AND                                      CLE148
     C                             DDACTN = 'A' AND
     C                             GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      N_LOAM_S                               99
     C                   IF        *IN99 = *ON
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      *
      * If action code, or Loan reference were not OK, blank
      * out action code so that the input cannot proceed
     C                   IF        DDACTNOK = 'N' OR
     C                             LOAM_OK  = 'N'
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
      *
      * Send the Amendments error messages to the details screen
      * and go to details screen
     C                   EXSR      SNDM@D
     C                   EVAL      @SCRN = 'D'
 
      * Else if no invalid amendments read from subfile
     C                   ELSE
      *
      * Go to browse screen
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@D - Send error messages to details screen
      *****************************************************************
     C     SNDM@D        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this amendment,
      ** identify this fact.
     C                   IF        DDACTNOK = 'N' OR
     C                             LOAM_OK  = 'N'
     C                   ADD       1             E
      *
      * Ensure that the message 'Amendment cannot proceed' is seen
      * first by the user
     C                   EVAL      TmpfldNmAr = *BLANKS
     C                   EVAL      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialise error indicators
     C                   MOVEA     LOAM_OK       @EI
      *
      ** Read error messages for amendments
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
     C                   DOW       *IN99 = '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetA    F
     C                   IF        F < 1 OR
     C                             F > 60
     C                   EVAL      F = 1
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           LOAM_OK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - Process detail screen
      *****************************************************************
     C     SCRN@D        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed
      * (key fields = action code & amendment reference; detail fields = rest)
      * (Action code can only be 'I', 'A', 'D', or 'E')
 
     C                   EVAL      @EKYFD = 'N'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @ESPIC = 'N'
 
     C                   SELECT
     C                   WHEN      DDACTN = 'I' AND
     C                             @OPSEL = 'U'
     C                   EVAL      @EDTFD = 'Y'
     C                   EVAL      @ESPIC = 'Y'
 
     C                   WHEN      DDACTN = 'A' AND
     C                             @OPSEL = 'U'AND DDATYP = 'PI'
     C                   EVAL      @ESPIC = 'Y'
     C                   ENDSL
 
      **  Enable 'Funding Spread/Rate' field if:
      **   - Analytical Accounting is on and the loan amendment type is
      **     a spread change,  and the loan was directly funded,  or
      **   - Revenue Analysis is on and the loan amendment type is a
      **     spread change
     C                   MOVE      'N'           @Funding          1
     C     BGN0ST        IFEQ      'Y'
     C     DDATYP        ANDEQ     'SC'
     C     C_FPRC        ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
     C     DDATYP        ANDEQ     'SC'
     C                   MOVE      'Y'           @Funding
     C                   ENDIF
 
      **  Enable 'Record reversed' message if true
     C                   MOVE      'N'           @Reversed         1
     C     DDACTN        IFEQ      'E'
     C     C_RECI        ANDEQ     'R'
     C                   MOVE      'Y'           @Reversed
     C                   ENDIF
 
      * Update 'previous' screen
     C                   EVAL      P_LOAM_S  = N_LOAM_S
      *
      * Set function key status
     C                   EXSR      SFKEYS
      *
      ** Write/read display screen
     C                   CALLB     'LELOAMDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input Parameters :
      * Return code
     C                   PARM      'DontBlank'   RetCodeOut
      * Screen format
     C                   PARM                    N_LOAM_S
      ***  Output only screen field : Loan type/status
     C                   PARM                    DDLTYP            2
     C                   PARM                    DDSTAT
     C                   PARM                    WLSNA             3                          222373
      * Fields in error
     C                   PARM                    LOAM_OK
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
      * Enabled key & detail fields
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @ESPIC            1
      *
      * KC - F3 - End program
      * KG - F7 - Roll backwards
      * KH - F8 - Roll forwards
      * KJ - F10 - Delete
      * KL - F12 - Cancel
      * KN - F14 - Settlement details
      * KP - F15 - Browse
      * KQ - F16 - Authorise
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM      'N'           @EINKP
     C                   PARM                    @EINKQ
      *
      * Field "Funding Spread/Rate" required
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
      *
      * OUTPUT PARAMETERS
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1
      *
      * Reset Errors ....
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   EVAL      FldNameArr =  *BLANK
     C                   EVAL      MsgIdArr   =  *BLANK
     C                   EVAL      MsgDtaArr  =  *BLANK
     C                   EVAL      WFldNamArr =  *BLANK
     C                   EVAL      WMsgIdArr  =  *BLANK
     C                   EVAL      WMsgDtaArr =  *BLANK
     C                   EVAL      Idx = 0
     C                   Z-ADD     0             WIdx
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDA
      *
      * F12 - Cancel on Screen
     C     @INKL         CASEQ     '1'           CANC@D
      *
      * Validate input to screen - includes:
      * F10 - Delete
      * F14 - Settlement details
      * F16 - Authorise
     C                   CAS                     VAL@D
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - Validate input to details screen
      *****************************************************************
     C     VAL@D         BEGSR
      *
      * Retrieve loan amendment details
     C                   EXSR      RTVTRN
      *
      * If any errors, re-output screen with error messages on it
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If Delete
     C                   IF        DDACTN = 'D'
      *
      * If F10 taken, go to updates
     C                   IF        @EINKJ = 'Y'
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If authorise
     C*********          IF        DDACTN = 'X'                                               CLE030
     C                   IF        DDACTN = 'X' and                                           CLE030
     C                             CLE030 <> 'Y'                                              CLE030
      *
      * If F16 taken, go to updates
     C                   IF        @EINKQ = 'Y'
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * Only amends and inserts will be processed from here on.
      * Prior to validation, initialise error indicators as 'OK'
      * and clear amendment in file format.
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   CLEAR                   N_LOAM_F
      *
      * Store current number of warnings
      *
      * Validate loan amendment details
 
     C                   CALLB     'LELOAMVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      ** Transaction information (DS) from source system (screen format)
     C                   PARM                    N_LOAM_S
 
      ** Current loan amendment in file format
     C                   PARM                    C_LOAM_F
 
      * File receive instructions
      * File payment instructions
     C                   PARM                    S_REC
     C                   PARM                    S_PAY
 
      ** Loan 'A' & 'B' formats
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
 
      ** Facility 'A' & 'B' formats
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
 
      ** Front Office Transaction Id., Associated Front Office Transaction Id.
      ** Repair Location
     C                   PARM                    LAFRNT
     C                   PARM                    LAAFRT
     C                   PARM                    LAREPA
 
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
     C                   PARM                    FTTFRT
 
      * Outputs:
      ** Field OK flags (DS) from/to caller
     C                   PARM                    LOAM_OK
 
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
     C                   PARM      'RPR'         CallModCod        3
 
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
 
      * Valid amendment layout (DS) from/to caller
     C                   PARM                    N_LOAM_F
      *
      * If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      * If any screen defaulting or reformatting has occurred in validation
      * or if the number of warnings has changed, re-display the screen
     C                   IF        N_LOAM_S  <> P_LOAM_S  OR
     C                             WIdx <> PrvN_Warn
      * Store current number of warnings
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      *  Validate settlement details for principal increases
     C                   IF           DDATYP = 'PI'
     C                   EXSR      ValSettle
     C                   ENDIF
      *
      * Clear any warning messages
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   EVAL      @SCRN = 'U'
      *
     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValSettle  - Routine to validate settlement details            *
      *                                                                *
      ******************************************************************
     C     ValSettle     BEGSR
 
      * Move the customer number to parameter field
     C                   MOVEL     LO_CNUM       ##CSNM
 
      * Apply default settlement instructions if none supplied
     C                   IF        (S_REC = *blank) and
     C                             (S_PAY = *blank)
     C                   EXSR      DftSettmts
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return code
     C                   PARM                    ReturnCode
 
      ** Output:
      ** Calling function type
     C                   PARM      'LOAM'        ##CALP
 
      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3
 
      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3
 
      ** Customer (shortname or number)
     C                   PARM                    ##CSNM
 
      ** Deal type
     C                   PARM                    ##TTYP
 
      ** Federal funds indicator
     C                   PARM                    ##FFND
 
      ** Booking branch
     C                   PARM      LO_BRCA       ##BRCA            3
 
      ** Receipt date
     C                   PARM                    ##DATR            5 0
 
      ** Payment date
     C                   PARM                    ##DATP            5 0
 
      ** Receipt / payment / FRA settlement instructions in screen
      ** format
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
 
      * Action code
     C                   PARM                    DDACTN
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Inputs:
      ** Payment instruction OK flag
     C                   PARM                    OKPayInsDS        1
 
      ** Receive instruction OK flag
     C                   PARM                    OKRecInsDS        1
 
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS        1
 
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
 
      ** Receipt / payment / FRA settlement instructions in file
      ** format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
 
      ** Action code used
     C                   PARM      DDACTN        ##ACTN            1
 
      ** Validation iteration
     C                   PARM      '1ST'         ##ValIter         3
 
     C     ValSetExit    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
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
      ** Set up date of receipt/payment
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   Z-ADD     ZDAYNO        ##DATR            5 0
     C                   Z-ADD     ZDAYNO        ##DATP            5 0
      *                                                                                     MD029046
      ** Default settlement from standard settlement instructions of customer first         MD029046
      ** before trying to default from loan. Placed another call for ZASETINDFT             MD029046
      ** for Principal increase insert.                                                     MD029046
      *                                                                                     MD029046
     C                   IF        DDACTN = 'I'                                             MD029046
     C                             AND DDATYP = 'PI'                                        MD029046
     C                   MOVEL     LO_CNUM       ##CSNM                                     MD029046
     C                   CALLB     'ZASETINDFT'                                             MD029046
      *                                                                                     MD029046
      ** Inputs                                                                             MD029046
      ** Calling program                                                                    MD029046
     C                   PARM      'LEND'        ##CALP                                     MD029046
      *                                                                                     MD029046
      ** Payment currency                                                                   MD029046
     C                   PARM      LO_CCY        ##PCCY                                     MD029046
      *                                                                                     MD029046
      ** Receive currency                                                                   MD029046
     C                   PARM      LO_CCY        ##RCCY                                     MD029046
      *                                                                                     MD029046
      ** Customer shortname                                                                 MD029046
     C                   PARM                    ##CSNM                                     MD029046
      *                                                                                     MD029046
      ** Loan type                                                                          MD029046
     C                   PARM      *BLANKS       ##TTYP                                     MD029046
      *                                                                                     MD029046
      ** Parameters not used in LOAM :                                                      MD029046
      ** Federal funds indicator                                                            MD029046
      ** Version of ISDA rules                                                              MD029046
      ** Type of ISDA agreement                                                             MD029046
      ** Date of ISDA agreement                                                             MD029046
      ** Version of ISDA agreement                                                          MD029046
      ** Version of ISDA agreement century                                                  MD029046
     C                   PARM      *BLANK        ##FFND                                     MD029046
     C                   PARM      *BLANK        BQISDA                                     MD029046
     C                   PARM      *BLANK        BQAGTY                                     MD029046
     C                   PARM      *BLANK        BQAGDT                                     MD029046
     C                   PARM      *BLANK        BQAGVV                                     MD029046
     C                   PARM      *BLANK        Blank2                                     MD029046
                                                                                            MD029046
      ** Deal Subtype                                                                       MD029046
     C                   PARM      *BLANK        BlankSTYP                                  MD029046
                                                                                            MD029046
      ** Branch                                                                             MD029046
     C                   PARM      *BLANK        BlankBRCA                                  MD029046
      *                                                                                     MD029046
      ***  OUTPUTS                                                                          MD029046
      ***  Payment instructions                                                             MD029046
     C                   PARM                    F_PAY                                      MD029046
      *                                                                                     MD029046
      ***  Receive instructions                                                             MD029046
     C                   PARM                    F_REC                                      MD029046
      *                                                                                     MD029046
      ***  FRA/IRS instructions                                                             MD029046
     C                   PARM                    F_FRI                                      MD029046
     C                   ENDIF                                                              MD029046
      *
      ** Set up payment instructions from loan
      ***(on*insertions,*these*fields*will*be*zero/blank)**************                       TDA066
     C                   IF        (DDACTN = 'I')                                             TDA066
     C     PType         IFNE      'PTSO'                                                     TDA066
     C     FLPSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PPAY        ANDNE     'Y'                                                      MD029046
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     LO_PSTM       FLPSTM                                       CGL029
     C                   MOVEL     LO_CVMR       FLCVMR
     C                   MOVEL     LO_SCCY       FLPSCY
     C                   MOVEL     LO_ICCY       FLIC72
     C                   MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_PSCY       FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                TDA066
      *
      ** If part sold, receive branch is our start date branch
     C     PType         IFEQ      'PTSO'
     C     FLPSTM        ANDEQ     *ZERO                                                    MD029046
     C     ##PPAY        ANDNE     'Y'                                                      MD029046
     C                   MOVE      LO_OSDB       FLROBR
      *
      ** Set up receive instructions from loan
      ***(on*insertions,*these fields*will*be*zero/blank)**************                       TDA066
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     LO_RSTM       FLRSTM                                       CGL029
     C                   MOVEL     LO_SCCY       FLRSCY
     C**********         MOVE      LO_OMDB       FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move correct settlement currency.                          CLE031
      ** Note do not default exchange rate from CLOANCL.                                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     LO_SCCY       FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *                                                                                       TDA066
      ** On action other than insert, setup setllement instructions                           TDA066
      ** from current loan amendment.                                                         TDA066
     C                   ELSE                                                                 TDA066
     C                   IF        (PType <> 'PTSO')                                          TDA066
     C                   MOVEL     LAPAY         FLPAY                                        TDA066
     C                   MOVEL     LAPAYEx       FLPONS                                       TDA066
     C                   MOVEL     LAPSTM        FLPSTM                                       TDA066
     C                   MOVEL     LACVMR        FLCVMR                                       TDA066
     C                   MOVEL     LAPSCY        FLPSCY                                       TDA066
     C                   MOVEL     LAICCY        FLIC72                                       TDA066
     C                   MOVE      LAOSBR        FLPOBR                                       TDA066
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
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
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LAREXR        FLREXR                                       CLE031
     C                   MOVE      LAREXI        FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                TDA066
     C                   ENDIF                                                                TDA066
      *
     C                   CALLB     'ZASETINDFT'
      *
      ** Inputs
      ** Calling program
     C                   PARM      'LOAM'        ##CALP            4
      *
      ** Payment currency
     C                   PARM      LO_CCY        ##PCCY            3
      *
      ** Receive currency
     C                   PARM      LO_CCY        ##RCCY            3
      *
      ** Customer shortname
     C                   PARM                    ##CSNM           10
      *
      ** Loan type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ** Parameters not used in LOAM :
      ** Federal funds indicator
      ** Version of ISDA rules
      ** Type of ISDA agreement
      ** Date of ISDA agreement
      ** Version of ISDA agreement
      ** Version of ISDA agreement century
     C                   PARM      *BLANK        ##FFND            1
     C                   PARM      *BLANK        BQISDA            4
     C                   PARM      *BLANK        BQAGTY            6
     C                   PARM      *BLANK        BQAGDT            6
     C                   PARM      *BLANK        BQAGVV            2
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
 
     C     EDFTSETT      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - Retrieve Amendment
      *****************************************************************
     C     RTVTRN        BEGSR
      *
      * Retrieve Amendment
     C                   CALLB     'LELOAMRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Inputs :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    @@MODE
      *
      * Response mode
     C                   PARM                    RespMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM      @FrntSel      DDFRNT
      *
      * Loan number / value date / sequence / type
     C                   PARM                    DDLOAN
     C                   PARM                    DDVDAT
     C                   PARM                    DDSEQN
     C                   PARM                    DDATYP
 
      * Where called from
     C                   PARM      'RPR'         CallModCod
 
      * Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN
      *
      * Outputs :
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    C_LOAM_F
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
      *
      * OK - Amendment Reference
     C                   PARM                    LOAM_OK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    N_LOAM_F                                     CRE073
     C                   PARM                    CobMode                                   MD021423E
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - Put an amendment on screen
      *****************************************************************
     C     CVTTRN        BEGSR
      *
      * Call program to fill screen fields with data
     C                   CALLB     'LELOAMCVT'
      *
      * Inputs :
      * Return code
      * Amendment in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    C_LOAM_F
      *
      * Date format indicator
     C                   PARM                    BJDFIN
 
      * Outputs
      * Amendment in screen format
     C                   PARM                    N_LOAM_S
      *
      ***  Output only screen field : Loan status
     C                   PARM                    DDSTAT           16
     C                   PARM                    N_LOAM_F                                     CRE073
      *
      **  Add the action code
     C                   MOVE      @ACSEL        DDACTN
      *
      * Update 'current' amendment with amendment in screen format
     C                   MOVEL     N_LOAM_S      C_LOAM_S
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - Cancel on details screen
      *****************************************************************
     C     CANC@D        BEGSR
 
      *
      * If Records are still to be read from the subfile, read them
     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
      *
      * Else, return to the browse screen
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * Include Header fields that need to be output to the valid file.
      * If there is no front office ID, use the PCREF created by LELOAMVAL.
     C     DDFRNT        Ifeq      *Blank
     C                   MOVEL     LAPCRF        LAFRNT
     C                   Else
     C                   MOVEL     DDFRNT        LAFRNT
     C                   EndIf
 
     C                   EVAL      LAAFRT = DDAFRT
     C                   EVAL      LAREPA = DDREPR
     C                   EVAL      LATMST = DDSTMP
      *
      * Loan Amendment updates
     C                   CALLB     'LELOAMUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    DDACTN
     C                   PARM                    N_LOAM_F
     C                   PARM      'RPR'         CallModCod        3
 
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
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   ENDIF                                                              AR868380
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program.
      * Otherwise delete the invalid trancsaction actioned & commit the updates.
     C                   IF        @RTCD <> *BLANK AND
     C                             @RTCD <> '*RECUPD'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C     @RTCD         IFNE      '*RECLCK'                                                AR868380
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR868380
     C                   ELSE
     C     ZATRNKD0      CHAIN     LEILOAMD0                          99
     C  N99              DELETE    LEILOAMD0
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
      *
      * If error occurred in updating last Amendment set on flag to
      * display message on 'browse' screen.
     C                   IF        @RTCD = '*RECUPD'
     C                             OR @RTCD = '*RECLCK'                                     AR868380
     C                   EVAL      @ERRUP = 'Y'
     C                   ELSE
     C                   EVAL      @ERRUP = 'N'
     C                   ENDIF
      *
      * If records are still to be read from the subfile, read them
     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
      *
      * Else, return to the browse screen
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - Set function keys
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KJ = F10 - Confirm delete
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
      *
      * KQ = F16 - Confirm authorisation
     C**********         IF        DDACTN = 'X'                                               CLE030
     C                   IF        DDACTN = 'X' or                                            CLE030
     C                             DDACTN = 'Q' and                                           CLE030
     C                             CLE030 = 'Y'                                               CLE030
      *                                                                                       CLE030
     C                   EVAL      @EINKQ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKQ = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDA - End program
      *****************************************************************
     C     ENDA          BEGSR
      *
     C                   EVAL      @SCRN = 'T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Amendment details data substitution                 *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       BEGSR
 
      ** Substitute the data for the various parts of the Amendment,
      ** dependent on the flags that were set earlier.
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
 
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
 
      * Incoming Data
     C                   PARM      N_LOAM_S      IncDATA        2000
 
      * Current Data
     C                   PARM      C_LOAM_S      CurDATA        2000
 
     C                   MOVEL     IncDATA       N_LOAM_S
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'LELOAMRPR'
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
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD                                        CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * Database error                                                                        CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   Z-ADD     5             DBASE                          * DBERR 005 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
 
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
      ** Retrieve Customer lending ICD
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
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC011'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
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
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 6                                                  CSC022
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
      * Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FrntSel
     C                   KFLD                    @StmpSel
     C     ZATRNKX0      KLIST
     C                   KFLD                    @StmpSel
     C                   KFLD                    @FrntSel
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    Field1
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetA = FieldNo - 3
     C                   ENDIF
      *
      * Start on browse screen
     C                   MOVEL     'B'           @SCRN             1
      *
 
     C                   EVAL      @RTCD = *BLANKS
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LELOAMR014
 
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
**CTDATA CPY@
(c) Finastra International Limited 2002
