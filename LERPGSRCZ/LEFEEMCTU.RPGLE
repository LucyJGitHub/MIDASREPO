     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee details control')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEEMCTU - Fee Control Update                               *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             Fee                                               *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 30Mar07               *
      *                 245099             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG3760            Date 30Jul04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  245099 - Pass CLE006 to LEFEEMAMD                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     FLEIFEEMPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      * Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
 
      * Error indicators
     D OKFee         E DS                  EXTNAME(LEEFEEMPD)
 
      ** Fee Details in file format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
     D***FeemREC              294    362                                                      CGL029
     D***FeemPAY              363    921                                                      CGL029
     D  FeemREC              308    362                                                       CGL029
     D  FeemPAY              377    921                                                       CGL029
     D  FeemRECEx           1076   1093                                                       CGL029
     D  FeemPAYEx           1094   1111                                                       CGL029
 
      * Valid Fee layout
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D                                     PREFIX(V_)
     D***ValidREC             294    362                                                      CGL029
     D***ValidPAY             363    921                                                      CGL029
     D  ValidREC             308    362                                                       CGL029
     D  ValidPAY             377    921                                                       CGL029
     D  ValidRECEx          1076   1093                                                       CGL029
     D  ValidPAYEx          1094   1111                                                       CGL029
 
      * (Current) Fee in Screen Format
     D CurScFee      E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(C_)
 
      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
 
      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     78                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    569                                                       CGL029
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D S_Rec         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_Pay         E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      * Curent Screen Receive instructions
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
 
      * Current Screen Payment instructions
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
 
      ** Branch code
     D  FeeBranch                     3A
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** External DS for Lending ICD Details
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF3MFPD)
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF4MFPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of error message ids etc
     D AmIdx           S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WId             S              3P 0
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                              244636
      ** Parameter for LEFEEMRTV                                                              244636
     D PRcvParm        S             92                                                       244636
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      * Inserts
      *  ======
 
     C     DDACTN        WHENEQ    'I'
 
     C                   EXSR      DftSettmts
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
      *  Amends
      *  ======
 
     C     DDACTN        WHENEQ    'A'
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      CrFeScnFmt                             99
     C     *in99         ifeq      *on
     C                   EXSR      TDtDtaSubs
     C                   endif
     C                   endif
     C                   EXSR      SetupAmend
 
      *  Amends, Authorise, Delete
      *  =========================
 
     C     DDACTN        WHENEQ    'A'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
     C                   EXSR      ValdateAmd
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Do updates for this transaction
      ** according to whether it is valid or invalid
 
     C     Idx           IFEQ      0
     C                   EXSR      UPDAT_VAL
     C                   ENDIF
     C     Idx           IFNE      0
     C                   EXSR      UPDAT_INVAL
     C                   ENDIF
 
      **  Terminate program
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPFLD        BEGSR
 
     C                   MOVEL     F3RPLC        RPLOC             1
      *
      ** Fee details
      *
     C                   CLEAR                   CrFeScnFmt
 
      ** Detail screen
     C                   MOVE      F3ACTN        DDACTN
      *
     C                   MOVEL     F3CNUM        DDCSSN
 
     C     F3FACT        IFNE      *blanks
     C                   MOVE      F3FACT        DDFACT
     C                   ELSE
     C                   MOVE      *BLANK        DDFACT
     C                   ENDIF
 
     C     F3FCNO        IFNE      *blanks
     C                   MOVE      F3FCNO        DDFCNO
     C                   ELSE
     C                   MOVE      *BLANK        DDFCNO
     C                   ENDIF
 
     C     F3LOAN        IFNE      *blanks
     C                   MOVE      F3LOAN        DDLNRF
     C                   ELSE
     C                   MOVE      *BLANK        DDLNRF
     C                   ENDIF
 
     C     F3SEQR        IFNE      *blanks
     C                   MOVE      F3SEQR        DDFSEQ
     C                   ELSE
     C                   MOVE      *BLANK        DDFSEQ
     C                   ENDIF
 
     C                   MOVEL     F3FCOD        DDECOD
     C                   MOVEL     F3FCCY        DDECUR
     C                   MOVEL     F3FAMT        DDEAMT
     C                   MOVEL     F3FAMI        DDESGN
 
     C                   MOVEL     F3PSTD        DDEPSD
     C                   MOVE      F3PSTD        W#TWO             2
     C                   MOVE      W#TWO         DDEPSD
 
     C                   MOVEL     F3PEND        DDEPED
     C                   MOVE      F3PEND        W#TWO             2
     C                   MOVE      W#TWO         DDEPED
 
     C                   MOVEL     F3PYON        DDEPON
     C                   MOVEL     F3AUTO        DDEADV
     C                   MOVEL     F3SHFI        DDESHR
     C                   MOVEL     F3CALT        DDCALT
     C                   MOVEL     F3FRT1        DDRTE1
     C                   MOVEL     F3AMT1        DDFAMT1
     C                   MOVEL     F3FRT2        DDRTE2
     C                   MOVEL     F3AMT2        DDFAMT2
     C                   MOVEL     F3FRT3        DDRTE3
     C                   MOVEL     F3AMT3        DDFAMT3
     C                   MOVEL     F3FRT4        DDRTE4
     C                   MOVEL     F3AMT4        DDFAMT4
     C                   MOVEL     F3FRT5        DDRTE5
     C                   MOVEL     F3AMT5        DDFAMT5
     C                   MOVEL     F3PIND        DDPIND
     C                   MOVEL     F3CALC        DDCALC
     C                   MOVEL     F3ERAT        DDEXRT
     C                   MOVEL     F3ERAI        DDMDIN
 
     C                   MOVEL     F3NPYD        DDNPYD
     C                   MOVE      F3NPYD        W#TWO             2
     C                   MOVE      W#TWO         DDNPYD
 
     C                   MOVEL     F3FREQ        DDFREQ
     C                   MOVEL     F3DYIM        DDDYIM
     C                   MOVEL     F3PRFC        DDPRFC
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      F3RSTM        FLRSTM
     C                   MOVE      F3RONS        FLRONS
     C                   MOVE      F3RIBN        FLRIBN
     C                   MOVE      F3RIBA        FLRIBA
     C                   MOVE      F3ROBN        FLROBN
     C                   MOVE      F3ROCN        FLROCN
     C                   MOVEL     F3RONS        FLROBR
     C                   MOVE      F3SCCY        FLRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      F3PSTM        FLPSTM
     C                   MOVE      F3PONS        FLPONS
     C                   MOVE      F3PIBN        FLPIBN
     C                   MOVE      F3PIBA        FLPIBA
     C                   MOVE      F3POBN        FLPOBN
     C                   MOVE      F3POCN        FLPOCN
     C                   MOVE      F3CVMR        FLCVMR
     C                   MOVE      F3RCRN        FLRCRN
     C                   MOVE      F3RCRA        FLRCRA
     C                   MOVE      F3RVNO        FLRVNO
     C                   MOVE      F3AWBN        FLAWBN
     C                   MOVE      F3AWBA        FLAWBA
     C                   MOVE      F3BENN        FLBENN
     C                   MOVE      F3BENA        FLBENA
     C                   MOVEL     *blanks       FLDTP1
     C                   MOVEL     *blanks       FLDTP2
     C                   MOVEL     *blanks       FLDTP3
     C                   MOVEL     *blanks       FLDTP4
     C                   MOVE      F3DCHG        FLDCHG
     C                   MOVEL     *blanks       FLBTB1
     C                   MOVEL     *blanks       FLBTB2
     C                   MOVEL     *blanks       FLBTB3
     C                   MOVEL     *blanks       FLBTB4
     C                   MOVEL     *blanks       FLBTB5
     C                   MOVEL     *blanks       FLBTB6
     C                   MOVEL     F3PONS        FLPOBR
     C                   MOVE      F3SCCY        FLPSCY
     C                   MOVE      F3ICCY        FLIC72
 
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      F3SCCY        DDRSCY                                       CLE031
     C                   MOVE      F3REXR        DDREXR                                       CLE031
     C     F3REXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F3REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDREXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      F3REXI        DDREXI                                       CLE031
     C     F3REXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      F3PSCY        DDPSCY                                       CLE031
     C                   MOVE      F3PEXR        DDPEXR                                       CLE031
     C     F3PEXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F3PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      F3PEXI        DDPEXI                                       CLE031
     C     F3PEXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEFEEMRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Front Office User
     C                   PARM                    APFOTranUs       16
      *
      * (Midas) Facility Reference Number
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDLNRF
     C                   PARM                    DDFSEQ
      *
      * CSC011 processing date
     C                   PARM                    WRNDAY
      *
      * OUTPUTS
      *
      * (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
      *
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCSSN            1
      *
      * OK - Facility type
     C                   PARM                    OKFACT            1
      *
      * OK - Facility sub type
     C                   PARM                    OKFCNO            1
      *
      * OK - Loan reference
     C                   PARM                    OKLNRF            1
      *
      * OK - Fee sequance
     C                   PARM                    OKFSEQ            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     244636
 
      ** TNLU used in 'record updated by another WS' checking
 
     C                   Z-ADD     FETNLU        H#TNLU
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Fee details
 
     C                   EXSR      ValdFeeScn
 
     C     EValidTr      ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * ValdFeeScn - Validate Fee details                             *
      *                                                               *
      *****************************************************************
     C     ValdFeeScn    BEGSR
 
     C                   CALLB     'LEFEEMVAL'
 
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Transaction Details - screen format
     C                   PARM                    CrFeScnFmt
      ** Details - Settlement instructions
     C                   PARM                    F_Rec
     C                   PARM                    F_Pay
     C                   PARM                    F_Fri
      ** Current Fee file
     C                   PARM                    CrFeFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      ** Loan CL file format
     C                   PARM                    ClilFilFmt
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND
      * Participant Fee indicator
     C                   PARM                    WPTFI
      * Expiry date
     C                   PARM                    WDTEX
      * Facility amount
     C                   PARM                    WFAMT
      * CLE006
     C                   PARM                    CLE006            1
      * CEU004
     C                   PARM                    CEU004            1
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
 
      * OUTPUTS
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
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
     C                   PARM                    WId
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (F_Rec = *blank)
     C                             AND (F_Pay = *blank)
 
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDECUR        ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDECUR        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCSSN        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    F_PAY
      *
      * Receive instructions
     C                   PARM                    F_REC
      *
      * FRA/IRS instructions
     C                   PARM                    F_FRI
 
     C                   ENDIF
 
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** File Payment Settlement Instruction
     C                   PARM                    F_PAY
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    F_REC
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        F_FRI
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        S_Pay
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        S_Rec
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        S_FRI
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
 
      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (DDCSSNOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
      *
      ** PAYMENT DATE & RECEIVE DATE = RUN DATE
      *
     C                   Z-ADD     BJRDNB        ##DATP
     C                   Z-ADD     BJRDNB        ##DATR
      *
      ** DEFINE FEE BRANCH: IF INSERT MODE IT COMES FROM LOAN FILE OR FACILITY FILE
      ** ELSE FROM FEE FILE
     C                   IF        NOT (DDACTN = 'I')
     C                   EVAL         FeeBranch = FEBRCA
     C                   ELSE
 
     C                   IF        NOT (DDLNRF = *Blanks)
     C                   EVAL         FeeBranch = CL_BRCA
     C                   ELSE
     C                   EVAL         FeeBranch = FA_BRCA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM      DDECUR        ##PCCY            3
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      DDECUR        ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCSSN        ##CSNM           10
      ** Deal type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      ** Booking Branch
     C                   PARM      FeeBranch     ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WId                                          222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
      *
      ***  Extra validation after the Extended Settlements
      *
     C                   CALLB     'LECLIPEVL'
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE
      * Fee detail file
     C                   PARM                    CrFeFilFmt
      * Fee detail screen
     C                   PARM                    CrFeScnFmt
      * Fee Valid file
     C                   PARM                    ValidFeem
      * CEU004
     C                   PARM                    CEU004
      * Payment instructions
     C                   PARM                    F_Pay
      *
      *  Receive instructions
     C                   PARM                    F_REC
      *
      *  FRA/IRS instructions
     C                   PARM                    F_FRI
 
      * OUTPUTS
 
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    WId
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate amendments
      *****************************************************************
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee file format
     C                   PARM                    CrFeFilFmt
      *
      * Loan (LN) file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * CLE006
     C                   PARM                    CLE006
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND
      *
      * Output parameters
      *
      * Fee Details - screen format
     C                   PARM                    CurScFee
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
 
 
     C                   CALLB     'LEFEEMAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Fee in Screen Format
     C                   PARM                    CrFeScnFmt
      *
      * (Current) Fee in Screen Format
     C                   PARM                    CurScFee
      *
      * Fee in file format
     C                   PARM                    ValidFeem
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKFee
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *                                                                                       245099
     C                   PARM                    CLE006                                       245099
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
 
      ** If repair in back-office
 
     C     RPLOC         IFEQ      'B'
 
      ** Write to the invalid (repair) files
 
     C                   CALL      'LEC0215'
     C                   PARM                    DDREPN
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    DDTMESTMP
 
     C                   EVAL      DDFOTRANID = F3TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'
 
     C                   WRITE     LEIFEEMD0
     C                   WRITE     APIDSETD0
     C                   EXSR      W_ZATRNERR
 
      ** Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      ** Set up the returned message format
 
     C                   MOVE      F3MSGT        F4MSGT
     C                   MOVE      F3TRUS        F4TRUS
     C                   MOVE      F3TRWS        F4TRWS
     C                   MOVE      F3TNRF        F4TNRF
     C                   MOVE      F3TRSN        F4TRSN
     C                   MOVE      F3ACTN        F4ACTN
     C                   MOVE      F3TRDS        F4TRDS
     C                   MOVE      F3TRTS        F4TRTS
     C                   MOVE      F3NRBA        F4NRBA
     C                   MOVEL     'E'           F4MSGS
     C                   MOVEL     ZAMSID        F4MSGI
     C                   MOVEL     ZAMSTX        F4MSTX
     C                   MOVE      F3CNUM        F4CNUM
     C                   MOVE      F3FACT        F4FACT
     C                   MOVE      F3FCNO        F4FCNO
     C                   MOVE      F3LOAN        F4LOAN
     C                   MOVE      F3SEQR        F4SEQR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
 
      ** Update the database
 
     C                   EXSR      UPD_DBASE
 
      ** If there were errors, rollback any database changes and increment
      ** the error index by 1 to drive the 'invalid' record processing
 
     C*****RetCodeOut    IFNE      *BLANK                                                   AR868380
     C     @@RTCD        IFNE      *BLANK                                                   AR868380
 
     C                   ADD       1             Idx
                                                                                            AR868380
     C     @@RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                 AR868380
     C                   EVAL      MsgIdArr(Idx) =  'LEL0817'                               AR868380
     C                   ENDIF                                                              AR868380
 
     C                   ROLBK
 
     C                   ELSE
 
      ** Commit the database changes
 
     C                   COMMIT
 
      ** Set up the returned message format
 
     C                   MOVE      F3MSGT        F4MSGT
     C                   MOVE      F3TRUS        F4TRUS
     C                   MOVE      F3TRWS        F4TRWS
     C                   MOVE      F3TNRF        F4TNRF
     C                   MOVE      F3TRSN        F4TRSN
     C                   MOVE      F3ACTN        F4ACTN
     C                   MOVE      F3TRDS        F4TRDS
     C                   MOVE      F3TRTS        F4TRTS
     C                   MOVE      F3NRBA        F4NRBA
     C                   MOVE      F3CNUM        F4CNUM
     C                   MOVE      F3FACT        F4FACT
     C                   MOVE      F3FCNO        F4FCNO
     C                   MOVE      F3LOAN        F4LOAN
 
     C     DDACTN        IFEQ      'I'
     C                   MOVE      WFSEQ         F4SEQR
     C                   ELSE
     C                   MOVE      F3SEQR        F4SEQR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFEEMUPD'
     C                   PARM      *BLANKS       @@RTCD            7
      * Mode
     C                   PARM      'B'           P#MODE            1
     C                   PARM                    ValidFeem
     C                   PARM                    CrFeFilFmt                                  BUG3760
     C                   PARM                    CLE002
     C**********         PARM                    CLE009                                       222373
     C                   PARM                    CSC011
      * Fees to be Authorised
     C                   PARM                    BPFEAU
      * Run date
     C                   PARM                    BJRDNB
      * TNLU of funding participant record on FEE file
     C                   PARM      FETNLU        H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OkFee
      * Fee sequence
     C                   PARM                    WFSEQ             2 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) Fee into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVE      CrFeFilFmt    ValidFeem
 
     C**********         EVAL      F_REC      = FeemREC + OSDB                                CGL029
     C                   EVAL      FLREC      = FeemREC + OSDB                                CGL029
     C                   EVAL      FLRONS     = FeemRECEx                                     CGL029
     C                   MOVE      F3RSTM        FLRSTM                                       CGL029
     C                   EVAL      FLRSCY     = F3FCCY
     C**********         EVAL      F_PAY      = FeemPAY + OMDB + CVMR                         CGL029
     C                   EVAL      FLPAY      = FeemPAY + OMDB + CVMR                         CGL029
     C                   EVAL      FLPONS     = FeemPAYEx                                     CGL029
     C                   MOVE      F3PSTM        FLPSTM                                       CGL029
     C                   EVAL      FLPSCY     = F3FCCY
     C                   EVAL      FLIC72     = F3ICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F3REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLREXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F3PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLPEXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      F3REXI        FLREXI                                       CLE031
     C                   MOVE      F3PEXI        FLPEXI                                       CLE031
     C                   MOVE      F3SCCY        FLRSCY                                       CLE031
     C                   MOVE      F3PSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
 
      ** Current Settlement Instruction in input format
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the Fee.
 
     C                   IF            (S_PAY = *blank)
     C                   EVAL      S_PAY = C_PAY
     C                   ENDIF
 
     C                   IF            (S_REC  = *blank)
     C                   EVAL      S_REC = C_REC
     C                   ENDIF
 
      * Do data substitution for Settlement Instructions
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      S_REC                                  99
     C  N99GHSUBS        scan      S_REC                                  99
     C     *in99         ifeq      *on
     C                   EXSR      SDtDtaSubs
     C                   endif
     C                   endif
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   RetCodeIn
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee file format
     C                   PARM                    CrFeFilFmt
      *
      * Loan (LN) file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * CLE006
     C                   PARM                    CLE006
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND
      *
      * Output parameters
      *
      * Fee Details - screen format
     C                   PARM                    CurScFee
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      CrFeScnFmt    IncDATA        2000
      * Current Data
     C                   PARM      CurScFee      CurDATA        2000
 
     C                   MOVEL     IncDATA       CrFeScnFmt
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************
 
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_PAY         IncDATA
      * Current Data
     C                   PARM      C_PAY         CurDATA
 
     C                   MOVEL     IncDATA       S_PAY
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_REC         IncDATA
      * Current Data
     C                   PARM      C_REC         CurDATA
 
     C                   MOVEL     IncDATA       S_REC
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   MOVE      DDREPN        ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = DDTMESTMP
 
      *  Do while error messages found
      *  Write error messages to file
 
     C                   Z-ADD     1             #C                2 0
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     FldNameArr(#C)ABFIELDNAM
     C                   MOVEL     MsgIdArr(#C)  ABMSGID
     C                   WRITE     ZATRNERRD0
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
      *
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
 
      ** Access API ICD via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
 
      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
      *
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
      *
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
 
      ** Determine if CLE009 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE009            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE009
     C                   ENDIF
 
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CEU004 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU004            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU004
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C* Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'D'           F4MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
