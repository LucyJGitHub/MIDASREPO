     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input retrieve')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEEMRTV - Fee Retrieve                                     *
      *                                                               *
      *  Function:  This module retrieves a Fee from                  *
      *             the database. As it does so, it validates the     *
      *             action code and Fee reference                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR375892           Date 26Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025945           Date 19Aug14               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 261546             Date 24Oct09               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      *                 247541             Date 03May07               *
      *                 CPK027             Date 16Apr07               *
      *                 244636             Date 30Mar07               *
      *                 244314             Date 30Mar07               *
      *                 242377             Date 30Mar07               *
      *                 BUG13128           Date 24Jan07               *
      *                 BUG12931A          Date 08Jan07               *
      *                 BUG12931           Date 04Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG6971            Date 16May05               *
      *                 BUG7886            Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4108            Date 06Sep04               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG3813            Date 26Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 19Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR375892 - Incorrect projection for fees attached to parts   *
      *             sold loan. Use Payment Settlement instead of      *
      *             Receipt Settlement.                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025945 - Do not allow deletion of fee loan if PDCL still   *
      *             exist.                                            *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  261546 - Wrong defaulting of settlement details on fee input.*
      *           Correct defaulting of settlement method 05 for      *
      *           Receipt - Our Account.  Apply fix 259718.           *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus (Recompile)         *
      *  247541 - Review user validation.                             *
      *  CPK027 - Errors in compiling MP1_3_TTTS - 244636 incompatible*
      *           with CSD027.                                        *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  242377 - When System Values for LoanCustOriginPurch = 'O',   *
      *           customer for fee that should be displayed should be *
      *           the original borrower for participations purchased. *
      *  BUG13128 - Cannot reject newly inserted fee record.          *
      *  BUG12931A - Do not allow a fee to be deleted if it has       *
      *              already a settlement                             *
      *  BUG12931 - Do not allow a fee to be deleted if it has        *
      *             already a settlement                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if fee was amended after original entry date   *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSC024 - Open Month End                                      *
      *  BUG6971 - Unable to authorise loan fee due to error message  *
      *  BUG7886 - Fee Update Error                                   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4108 - Check for adjustments before deleting Fee.         *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG3813- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Initialise DDFSEQOK to 'Y'.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      **  Fee by Front office Id.
     FLEFEEML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF0)
      **  Fee by Fee reference
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF1)
     F                                     PREFIX(F1_)
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(CL_)
     FCLOANL4   IF   E           K DISK                                                       CLE134
     F                                     PREFIX(pd_) RENAME(CLOANCLF:CLOANL4F)              CLE134
     FFCLTY     IF   E           K DISK
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(FA_)
     FLEFCAML3  IF   E           K DISK
     F                                     PREFIX(F3_)
      ** Compliance Watch Hit List File                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
                                                                                             BUG3760
     FLEFEADL1  IF   E           K DISK                                                      BUG4108
      * Fee Adjustment details - active                                                      BUG4108
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
 
      ** Include the LE standard declares
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
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** Customer lending Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
                                                                                             BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Watch List Tranaction Details File                                                  BUG3760
     D CWLCDS        E DS                  EXTNAME(SDWLTOPD)                                 BUG3760
                                                                                             BUG3760
      ** External DS for Compliance Watch Configuration Data File                            BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
      ** 24X7 status dataarea                                                                BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
                                                                                             BUG3760
      ** SD data area                                                                        BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
                                                                                             BUG3760
      ** External DS for SAR Details                                                         BUG3760
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3760
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(F1_)
      ** Fee in File Format
 
      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
 
      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
 
      * Saved Facility record FM
     D SvFaFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(SV_)
 
     D PRcvParm      E DS                  EXTNAME(SDESSRPD)                                  244636
     D  WComplete             15     15                                                       244636
      ***  Screen Receive Instructions                                                        244636
      *                                                                                       244636
     D PPayParm      E DS                  EXTNAME(SDESSPPD)                                AR375892
                                                                                            AR375892
     D                 DS
      ** Data structure to set partial key
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6                                                       CSD027
     D  WFAC03                 7      9  0
     D  WFAC02                10     11  0
     D  WFACL                  7     11
     D  WFAC05                 7     11  0
     D**WLOAN***              12     17  0                                                    CLE148
     D  WLOAN                 12     17                                                       CLE148
     D  WFSEQ                 18     19  0
 
     D                 DS
      ** Data structure to set work amounts
     D  WFAC3                 20     22  0
 
      ** Datastructure to hold input parameter for AOSVALR0.
     D                 DS
     D  WPARM                  1     20
     D  WPARM1                 1      5
     D  WPARM2                 6     10
     D  WPARM3                11     15
     D  WPARM4                16     20
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
                                                                                             BUG3760
      ** Switchable features - Watch List Checking                                           BUG3760
     D CSD015          S              1A                                                     BUG3760
     D CSC011          S              1A                                                     BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D W2LOAN          S              6                                                      BUG3760
     D W2CNUM          S              6                                                      BUG3760
     D W2FACL          S              5                                                      BUG3760
     D W2FSEQ          S              2                                                      BUG3760
     D PSard           S              6                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
                                                                                              CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
     D CAP086          S              1A                                                      CAP086
     D CLE056          S              1A                                                      CLE056
      *                                                                                       CLE134
      ** Key fields for CLE134 amendments                                                     CLE134
      *                                                                                       CLE134
     D Kpd_LNRF        S                   INZ LIKE(pd_LNRF)                                  CLE134
     D Kpd_RECI        S                   INZ LIKE(pd_RECI)                                  CLE134
                                                                                              CLE134
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
     C                   EXSR      INIT
 
      ** Check whether user is a web browser user, if so overwrite
     C                   CALL      'SFC000026'
     C                   PARM      *BLANKS       USER             10
      *
     C                   IF        USER <> *BLANKS
     C                   EVAL      PSUSER = USER
     C                   ENDIF
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             ModeofOp = *BLANKS                                         CAP086
     C                   EVAL      F1_FEAUTH = *BLANKS                                        CAP086
     C                   ENDIF                                                                CAP086
 
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
     C     DDACTNOK      IFEQ      'N'
     C                   RETURN
     C                   END
     C                   END
 
     C     DDACTN        IFNE      *BLANK
     C     DDCSSN        ORNE      *BLANK
     C     DDLNRF        ORNE      *BLANK
     C     DDFACT        ORNE      *BLANK
     C     DDFCNO        ORNE      *BLANK
     C     DDFSEQ        ORNE      *BLANK
                                                                                             BUG7886
     C                   IF           (DDFACT = '000' AND DDFCNO = '00')                     BUG7886
     C                             OR (DDFACT = '000' AND DDFCNO = '  ')                     BUG7886
     C                             OR (DDFACT = '   ' AND DDFCNO = '00')                     BUG7886
     C                   EVAL      DDFACT = '   '                                            BUG7886
     C                   EVAL      DDFCNO = '  '                                             BUG7886
     C                   ENDIF                                                               BUG7886
      *
     C     DDACTN        CASEQ     'I'           VALINP
     C     DDACTN        CASEQ     'A'           VALAMD
     C     DDACTN        CASEQ     'D'           VALDEL
     C     DDACTN        CASEQ     'E'           VALENQ
     C     DDACTN        CASEQ     'X'           VALAMD
     C                   CAS                     VALERR
     C                   ENDCS
 
     C                   ENDIF
      *
      ** Determine if fee is for against a syndicated facility/loan
     C                   EXSR      VSYND
      *
      ** Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      * ACCESS FEE WITH FRONT OFFICE TRANSACTION ID
 
     C     FOTRID        CHAIN     LEFEEML0                           99
 
      * IF INSERT
     C     DDACTN        IFEQ      'I'
 
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
     C                   ELSE
 
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
 
      * IF NOT INSERT, UPDATE MIDAS Fee reference
     C                   MOVEL     FECNUM        DDCSSN
     C                   MOVEL     FEFACL        DDFACT
     C                   MOVE      FEFACL        DDFCNO
     C                   MOVEL     FELOAN        DDLNRF
     C                   MOVEL     FEFSEQ        DDFSEQ
 
     C                   END
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALINP - Validate Input Key                                  *
      *****************************************************************
     C     VALINP        BEGSR
      *
      ** Test if customer entered
     C     DDCSSN        IFEQ      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0006'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       KEYC             10
     C                   MOVEL     DDCSSN        KEYC
     C                   EXSR      CUSTDT
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0007'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
     C                   MOVE      *BLANKS       DDCSSN
     C                   MOVEL     BBCUST        DDCSSN
     C                   MOVE      BBCUST        WCNUM
     C                   ENDIF
      *
      ** If both FACILITY & LOAN no. entered then error
      *                                                                                      BUG6971
     C     DDFACT        IFEQ      '000'                                                     BUG6971
     C                   MOVE      *BLANKS       DDFACT                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C     DDFCNO        IFEQ      '00'                                                      BUG6971
     C                   MOVE      *BLANKS       DDFCNO                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C                   MOVEL     DDFACT        WFACL
     C                   MOVE      DDFCNO        WFACL
     C     WFACL         IFNE      *BLANKS
     C     DDLNRF        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
      *
      ** If both FACILITY & LOAN no. blank then error
      *
     C     WFACL         IFEQ      *BLANKS
     C     DDLNRF        ANDEQ     *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
      *
      ** Loan number must be a six digit numeric field.
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   MOVE      '0'           TEST6             7
     C                   MOVEL     DDLNRF        TEST6
     C                   TESTN                   TEST6                78
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
      *
     C******IN78         IFEQ      '0'                                                        CLE148
     C**********         MOVEL     'N'           DDLNRFOK                                     CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LER0010'     MsgIdArr(Ix)                                 CLE148
     C**********         GOTO      EVALAI                                                     CLE148
     C**********         ELSE                                                                 CLE148
                                                                                              CLE148
     C     *IN78         IFEQ      '0'                                                        CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        ORNE      *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVEL     'N'           DDLNRFOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PDATA         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PDATA))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PDATA)                     MD000091
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVALAI                                                     CLE148
     C                   ELSE                                                                 CLE148
      *
      ** Validate loan number against customer details file
     C                   MOVE      DDLNRF        WLOAN
     C     KEY004        CHAIN     CLOAN                              78
     C                   SELECT
      *
     C     *IN78         WHENEQ    '1'
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0231'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
      *
     C     CL_RECI       WHENEQ    'M'
     C     CL_RATF       IFEQ      'Y'
     C     CLE005        ANDEQ     'Y'
      *
      *If the loan is a Participation Purchased, & System Value
      * Loan Cust Origin Purch = 'O', use Original Borrower:
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C     PPCUST        IFEQ      'O'
     C     CL_OLNO       IFNE      WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
     C                   MOVE      CL_CNUM       WCNUM
     C                   ENDIF
      *
      * Else, System value LoanCustOriginPurch = 'P'
     C                   ELSE
     C     CL_CNUM       IFNE      WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     CL_CNUM       IFNE      WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0232'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
      *
     C     CL_RECI       WHENNE    'D'
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0218'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
      *
     C     CL_PTYP       WHENEQ    64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C     PPCUST        IFEQ      'O'
     C     CL_OLNO       IFNE      WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
     C                   MOVE      CL_CNUM       WCNUM
     C                   ENDIF
     C                   ELSE
     C     CL_CNUM       IFNE      WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF
      *
     C     CL_CNUM       WHENNE    WCNUM
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0219'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
      *
     C                   ENDSL
      *
     C                   MOVE      CL_BRCA       WRKBRC            3
     C                   MOVE      CL_BRCA       WBKBRC            3
     C                   ENDIF
      *                                                                                       244636
     C                   IF        DDACTN = 'I'                                               244636
     C                   IF        CL_RSTM <> 0                                               244636
     C                   MOVEL     CL_RSTM       DDRSTM                                       244636
     C                   ENDIF                                                                244636
     C                   IF        CL_RONS <> *BLANKS AND                                     244636
     C                             CL_BRCA <> *BLANKS                                         244636
     C**********         IF        WComplete <> *BLANKS                                244636 261546
     C                   IF        CL_RSTM  =  05                                             261546
     C                   MOVE      CL_RONS       DDRONX                                       244636
     C                   MOVEL     CL_BRCA       DDRONX                                       244636
     C                   ELSE                                                                 244636
     C                   EVAL      DDRONX = CL_RONS                                           244636
     C                   ENDIF                                                                244636
     C                   ENDIF                                                                244636
     C**********         IF        CL_ROCN <> 0                                        244636 CPK027
     C                   IF        CL_ROCN <> *BLANKS                                         CPK027
     C                   MOVEL     CL_ROCN       DDROCN                                       244636
     C                   ENDIF                                                                244636
     C**********         IF        CL_ROBN <> 0                                        244636 CPK027
     C                   IF        CL_ROBN <> *BLANKS                                         CPK027
     C                   MOVEL     CL_ROBN       DDROBN                                       244636
     C                   ENDIF                                                                244636
     C                   IF        CL_RIBN <> *BLANKS                                         244636
     C                   EVAL      DDRIBN = CL_RIBN                                           244636
     C                   ENDIF                                                                244636
      *                                                                                     AR375892
     C                   IF        CL_PSTM <> 0                                             AR375892
     C                   MOVEL     CL_PSTM       DDPSTM                                     AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_PONS <> *BLANKS                                       AR375892
     C                   MOVEL     CL_PONS       DDPONX                                     AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_CVMR <> *BLANKS                                       AR375892
     C                   EVAL      DDCVMR = CL_CVMR                                         AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_ICCY <> *BLANKS                                       AR375892
     C                   EVAL      DDIC72 = CL_ICCY                                         AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_POCN <> *BLANKS                                       AR375892
     C                   MOVEL     CL_POCN       DDPOCN                                     AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_POBN <> *BLANKS                                       AR375892
     C                   MOVEL     CL_POBN       DDPOBN                                     AR375892
     C                   ENDIF                                                              AR375892
     C                   IF        CL_PIBN <> *BLANKS                                       AR375892
     C                   EVAL      DDPIBN = CL_PIBN                                         AR375892
     C                   ENDIF                                                              AR375892
     C                   ENDIF                                                                244636
     C                   ELSE
     C**********         Z-ADD     0             WLOAN                                        CLE148
     C                   MOVEL     *BLANK        WLOAN                                        CLE148
     C                   ENDIF
      *
      ** Validate Facility with Customer Det.
      *
     C     WFACL         IFNE      *BLANKS
     C     *LIKE         DEFINE    WFACL         TEST5           + 1
     C                   MOVE      '0'           TEST5
     C                   MOVEL     WFACL         TEST5
     C                   TESTN                   TEST5                78
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ELSE
      *
     C     KEY001        CHAIN     FCLTY                              78
     C     *IN78         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   ENDIF
      *
     C     *IN78         IFEQ      '1'
     C     FA_RECI       ORNE      'D'
     C     WREAC         ANDEQ     *OFF
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0143'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   MOVE      FA_BRCA       WRKBRC
     C                   MOVE      FA_BRCA       WBKBRC
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFAC05
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Fee sequence
      *
     C     DDFSEQ        IFNE      *BLANKS
                                                                                              CSC024
      ***Allow*entry*for*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
                                                                                              CSC024
     C                   MOVEL     'N'           DDFSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)
     C                   MOVEL     'LER0012'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
      ** Check Fee Sequence Duplicate                                                         CSC024
     C                   MOVE      DDFSEQ        WFSEQ                                        CSC024
     C     KEY002        CHAIN     LEFEEDF1                           74                      CSC024
     C     *IN74         IFEQ      *OFF                                                       CSC024
     C                   MOVEL     'N'           DDFSEQOK                                     CSC024
     C                   ADD       1             Ix                                           CSC024
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               CSC024
     C                   MOVEL     'LER0352'     MsgIdArr(Ix)                                 CSC024
     C                   GOTO      EVALAI                                                     CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ENDIF
      *
     C                   MOVE      WRKBRC        WZBRCA            3
      *
     C     ModeofOp      IFNE      '*FRONT'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      SRUAUT
     C                   ENDIF
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALAMD - Validate Amend and Authorise Key                    *
      *****************************************************************
     C     VALAMD        BEGSR
      *
      ** Customer must be entered
      *
     C     DDCSSN        IFEQ      *BLANKS                                      ***B001
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0006'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       KEYC             10
     C                   MOVEL     DDCSSN        KEYC
     C                   EXSR      CUSTDT
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0007'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ELSE
     C                   MOVE      *BLANKS       DDCSSN
     C                   MOVEL     BBCUST        DDCSSN
     C                   MOVE      BBCUST        WCNUM
     C                   ENDIF
      *
      ** If both FACILITY & LOAN no. entered then error
      *
     C     DDFACT        IFEQ      '000'                                                     BUG6971
     C                   MOVE      *BLANKS       DDFACT                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C     DDFCNO        IFEQ      '00'                                                      BUG6971
     C                   MOVE      *BLANKS       DDFCNO                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C                   MOVEL     DDFACT        WFACL
     C                   MOVE      DDFCNO        WFACL
     C     WFACL         IFNE      *BLANKS
     C     DDLNRF        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF
      *
      ** Facility no. must be numeric
      *
     C     WFACL         IFNE      *BLANKS
     C                   MOVE      '0'           TEST5
     C                   MOVEL     WFACL         TEST5
     C                   TESTN                   TEST5                78
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFAC05
     C                   ENDIF
      *
      ** Loan no. must be numeric
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   MOVE      '0'           TEST6
     C                   MOVEL     DDLNRF        TEST6
     C                   TESTN                   TEST6                78
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
      *
     C******IN78         IFEQ      '0'                                                        CLE148
     C**********         MOVEL     'N'           DDLNRFOK                                     CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LER0010'     MsgIdArr(Ix)                                 CLE148
     C**********         GOTO      EVALAA                                                     CLE148
     C**********         ELSE                                                                 CLE148
     C     *IN78         IFEQ      '0'                                                        CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        ORNE      *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVEL     'N'           DDLNRFOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PDATA         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PDATA))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PDATA)                     MD000091
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVALAA                                                     CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVE      DDLNRF        WLOAN
     C                   ENDIF
     C                   ELSE
      *
     C**********         Z-ADD     0             WLOAN                                        CLE148
     C                   MOVEL     *BLANK        WLOAN                                        CLE148
     C                   ENDIF
      *
      ** Validate Fee sequence
      *
     C                   MOVE      '0'           TEST2             3
     C                   MOVEL     DDFSEQ        TEST2
     C                   TESTN                   TEST2                78
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)
     C                   MOVEL     'LER0014'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ELSE
     C                   MOVE      DDFSEQ        WFSEQ
     C                   END
      *
     C*****WLOAN         IFNE      0                                                          CLE148
     C     WLOAN         IFNE      *BLANK                                                     CLE148
     C     PPCUST        ANDEQ     'O'
     C     KEY004        CHAIN     CLOAN                              74
     C     *IN74         IFEQ      '0'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C**********         MOVE      WCNUM         OCNUM             6 0                        CSD027
     C                   MOVE      WCNUM         OCNUM             6                          CSD027
     C                   MOVE      CL_CNUM       WCNUM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * No error found yet, check to see if record on file
      *
     C     Ix            IFEQ      *Zero
     C     KEY002        SETLL     LEFEEDF1
     C     KEY002        READE     LEFEEDF1                               74
      *
     C     *IN74         IFEQ      '0'
     C     PPCUST        ANDEQ     'O'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C     OCNUM         IFNE      CL_OLNO
     C                   MOVE      '1'           *IN74
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN74         IFEQ      '1'
     C     F1_FERECI     ORNE      'D'
     C                   MOVE      '1'           *IN74                                           ??
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFSEQOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0016'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ELSE
      *
     C     BKPRCA        IFNE      'Y'
     C                   MOVE      '0'           *IN61
     C                   ELSE
     C                   MOVE      '1'           *IN61
     C                   ENDIF
      *
     C                   MOVE      F1_FEBRCA     WZBRCA
      *                                                                                       247541
     C     ModeofOp      IFNE      '*FRONT'                                                   247541
     C     RESPMODE      ANDEQ     'S'                                                        247541
     C                   EXSR      SRUAUT
     C                   ENDIF                                                                247541
      *
     C     WFAC05        IFEQ      0
     C     KEY004        CHAIN     CLOAN                              78
     C     *IN78         IFEQ      '1'
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0231'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF
     C                   MOVE      CL_BRCA       WBKBRC
      *
     C                   ELSE
      *
     C     KEY001        CHAIN     FCLTY                              78
     C     *IN78         IFEQ      '1'
     C                   MOVEL     'N'           DDFACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0143'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   ENDIF
     C                   MOVE      FA_BRCA       WBKBRC
     C                   ENDIF
      *
      ** Set the protect indicators depending upon details.                                   ?????
      *
     C     F1_FEPSTD     IFLT      WRNDAY
     C     F1_FEORED     ANDNE     WRNDAY
     C     F1_FEAUTO     IFEQ      'Y'
     C     F1_FECALT     ANDEQ     *BLANKS
 
     C     F1_FEAUTO     OREQ      'C'                                                        CLE134
     C     F1_FECALT     ANDEQ     *BLANKS                                                    CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C     F1_FEAUT2     OREQ      'C'                                                        CLE134
     C     F1_FECALT     ANDEQ     *BLANKS                                                    CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   MOVE      '1'           *IN79
     C                   ENDIF
      *
     C     F1_FEPYON     IFEQ      'S'
     C                   MOVE      '1'           *IN84
     C                   ENDIF
     C     F1_FEPYON     IFEQ      'E'
     C                   MOVE      '1'           *IN85
     C                   ENDIF
     C     F1_FECALT     IFNE      *BLANKS
     C                   MOVE      '1'           *IN77
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** For Authorise action
      *
     C     DDACTN        IFEQ      'X'
     C     Ix            ANDEQ     *Zero
     C                   MOVE      '1'           *IN22
      *
      **  Enable F11 only if BPAURV is not activated
      *
     C     BPAURV        IFNE      'Y'
     C                   MOVE      '1'           *IN51
     C                   ENDIF
      *
     C                   EXSR      SRAUTH
     C                   ENDIF
      *
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALDEL - Validate Delete Key                                 *
      *****************************************************************
     C     VALDEL        BEGSR
      *
      ** Validation below already exists near the bottom of this subroutine                 BUG13128
                                                                                            BUG13128
      ***Fees*cannot*be*deleted*if*they*have*already*a*settlement.*Also,           BUG12931 BUG13128
      ***block*reversal*if*there*is*an*existing*record*within*LEFEEAD.*            BUG12931 BUG13128
      **********                                                                   BUG12931 BUG13128
     C*****KEY002        SETLL     LEFEEDF1                                        BUG12931 BUG13128
     C*****KEY002        READE     LEFEEDF1                               75       BUG12931 BUG13128
      **********                                                                   BUG12931 BUG13128
     C******IN75         IFEQ      *OFF                                            BUG12931 BUG13128
     C**********         MOVEL     'N'           DDCSSNOK                         BUG12931A BUG13128
     C**********         ADD       1             Ix                                BUG12931 BUG13128
      **********                                                                  BUG12931A BUG13128
     C**********         IF        FELOAN = 0                                     BUG12931A BUG13128
     C**********         MOVEL     'N'           DDCSSNOK                         BUG12931A BUG13128
     C**********         MOVEL     'DDCSSN'      FldNameArr(Ix)                   BUG12931A BUG13128
     C**********         ELSE                                                     BUG12931A BUG13128
     C**********         MOVEL     'N'           DDLNRFOK                         BUG12931A BUG13128
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                   BUG12931A BUG13128
     C**********         ENDIF                                                    BUG12931A BUG13128
      **********                                                                  BUG12931A BUG13128
     C**********         MOVEL     'LER0110'     MsgIdArr(Ix)                      BUG12931 BUG13128
     C**********         GOTO      EVALAD                                          BUG12931 BUG13128
     C**********         ENDIF                                                     BUG12931 BUG13128
      **********                                                                   BUG12931 BUG13128
      ** Test if customer entered
      *
     C     DDCSSN        IFEQ      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0006'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       KEYC             10
     C                   MOVEL     DDCSSN        KEYC
     C                   EXSR      CUSTDT
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0007'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ELSE
     C                   MOVE      *BLANKS       DDCSSN
     C                   MOVEL     BBCUST        DDCSSN
     C                   MOVE      BBCUST        WCNUM
     C                   ENDIF
      *
      ** If both FACILITY & LOAN no. entered then error
      *
     C     DDFACT        IFEQ      '000'                                                     BUG6971
     C                   MOVE      *BLANKS       DDFACT                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C     DDFCNO        IFEQ      '00'                                                      BUG6971
     C                   MOVE      *BLANKS       DDFCNO                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C                   MOVEL     DDFACT        WFACL
     C                   MOVE      DDFCNO        WFACL
     C     WFACL         IFNE      *BLANKS
     C     DDLNRF        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Facility no. must be numeric
      *
     C     WFACL         IFNE      *BLANKS
     C                   MOVE      '0'           TEST5
     C                   MOVEL     WFACL         TEST5
     C                   TESTN                   TEST5                78
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFAC05
     C                   ENDIF
      *
      ** Loan no. must be numeric
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   MOVE      '0'           TEST6
     C                   MOVEL     DDLNRF        TEST6
     C                   TESTN                   TEST6                78
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C******IN78         IFEQ      '0'                                                        CLE148
     C**********         MOVEL     'N'           DDLNRFOK                                     CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LER0010'     MsgIdArr(Ix)                                 CLE148
     C**********         GOTO      EVALAD                                                     CLE148
     C**********         ELSE                                                                 CLE148
     C     *IN78         IFEQ      '0'                                                        CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        ORNE      *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVEL     'N'           DDLNRFOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PDATA         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PDATA))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PDATA)                     MD000091
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVALAD                                                     CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVE      DDLNRF        WLOAN
     C                   ENDIF
     C                   ELSE
     C**********         Z-ADD     0             WLOAN                                        CLE148
     C                   MOVEL     *BLANK        WLOAN                                        CLE148
     C                   ENDIF
      *
      ** Validate Fee sequence
      *
     C                   MOVE      '0'           TEST2
     C                   MOVEL     DDFSEQ        TEST2
     C                   TESTN                   TEST2                78
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)
     C                   MOVEL     'LER0014'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ELSE
     C                   MOVE      DDFSEQ        WFSEQ
     C                   ENDIF
      *
     C*****WLOAN         IFNE      0                                                          CLE148
     C     WLOAN         IFNE      *BLANK                                                     CLE148
     C     PPCUST        ANDEQ     'O'
     C     KEY004        CHAIN     CLOAN                              74
     C     *IN74         IFEQ      '0'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C**********         MOVE      WCNUM         OCNUM             6 0                        CSD027
     C                   MOVE      WCNUM         OCNUM             6                          CSD027
     C                   MOVE      CL_CNUM       WCNUM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** No error found yet, check to see if record on file
      *
     C     Ix            IFEQ      *Zero
     C     KEY002        SETLL     LEFEEDF1
     C     KEY002        READE     LEFEEDF1                               74
      *
     C     *IN74         IFEQ      '0'
     C     PPCUST        ANDEQ     'O'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C     OCNUM         IFNE      CL_OLNO
     C                   MOVE      '1'           *IN74
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN74         IFEQ      '1'
     C     F1_FERECI     ORNE      'D'
     C                   MOVE      '1'           *IN74                                            ??
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFSEQOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0016'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ELSE
      *
      ** Make sure that user is authorised to this information before
      ** transferring details to the screen.
      *
     C                   MOVE      F1_FEBRCA     WZBRCA
      *                                                                                       247541
     C     ModeofOp      IFNE      '*FRONT'                                                   247541
     C     RESPMODE      ANDEQ     'S'                                                        247541
     C                   EXSR      SRUAUT
     C                   ENDIF                                                                247541
      *
     C     F1_FECALT     IFNE      *BLANKS
     C     F1_FEAMTS     ANDNE     0
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFSEQOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0110'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ELSE
      *
      ** Set the protect indicators depending upon details.
      *
     C                   MOVE      '1'           *IN22                                        ??
     C                   MOVE      '1'           *IN27                                        ??
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG4108
      ** Check for fee adjustment - cannot delete fee if there are                           BUG4108
      ** adjustments.                                                                        BUG4108
                                                                                            BUG13128
      ** New condition to check if settlement exists by checking the                        BUG13128
      ** Fee Calculation Type (FECALT) field. This should serve as                          BUG13128
      ** part of the resolution for Bug 12931/12931A.                                       BUG13128
      *                                                                                      BUG4108
     C     KEY002        CHAIN     LEFEEADF                           75                     BUG4108
      *                                                                                      BUG4108
     C     *IN75         IFEQ      '0'                                                       BUG4108
     C     FARECI        ANDEQ     'A'                                                       BUG4108
     C     *IN75         OREQ      '0'                                                      BUG13128
     C     F1_FECALT     ANDNE     *BLANKS                                                  BUG13128
     C                   MOVE      'N'           DDCSSNOK                                    BUG4108
     C                   MOVEL     'N'           DDFACTOK                                    BUG4108
     C                   MOVEL     'N'           DDFSEQOK                                    BUG4108
     C                   MOVEL     'N'           DDLNRFOK                                    BUG4108
     C                   ADD       1             Ix                                          BUG4108
     C                   MOVEL     'DDCSSN      'FldNameArr(Ix)                              BUG4108
     C                   IF        FARECI = 'A'                                             BUG13128
     C                   MOVEL     'LER0236'     MsgIdArr(Ix)                                BUG4108
     C                   ELSE                                                               BUG13128
     C                   EVAL      MsgIdArr(Ix) = 'LER0110'                                 BUG13128
     C                   ENDIF                                                              BUG13128
     C                   ENDIF                                                               BUG4108
 
      *                                                                                       CLE134
      ** Check for PDCLs - Cannot delete fee if there are.                                    CLE134
      *                                                                                       CLE134
     C                   EVAL      Kpd_RECI = 'D'                                             CLE134
     C**********         EVAL      Kpd_LNRF = FEPLNR                                 CLE134 MD025945
     C                   EVAL      Kpd_LNRF = F1_FEPLNR                                     MD025945
     C                   IF        F1_FEPLNR <> *BLANKS                                     MD025945
     C     KCLOANL4      CHAIN(E)  CLOANL4                                                    CLE134
      *                                                                                       CLE134
     C                   IF        %FOUND(CLOANL4)                                            CLE134
     C**********                   AND pd_CPAM <> 0                                  CLE134 MD025945
     C                             AND pd_RECI <> 'R'                                       MD025945
     C                   EVAL      DDFACTOK = 'N'                                             CLE134
     C                   EVAL      DDLNRFOK = 'N'                                             CLE134
     C                   EVAL      DDFSEQOK = 'N'                                             CLE134
     C                   EVAL      Ix += 1                                                    CLE134
     C                   EVAL      FldNameArr(Ix) = 'FEPLNR'                                  CLE134
     C                   EVAL      MsgIdArr(Ix) = '5045698'                                   CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                              MD025945
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALENQ - Validate Enquire Key                                *
      *****************************************************************
     C     VALENQ        BEGSR
      *
     C                   MOVE      '0'           *IN74
      ** Test if customer entered
      *
     C     DDCSSN        IFEQ      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0006'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       KEYC             10
     C                   MOVEL     DDCSSN        KEYC
     C                   EXSR      CUSTDT
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDCSSNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0007'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
     C                   MOVE      *BLANKS       DDCSSN
     C                   MOVEL     BBCUST        DDCSSN
     C                   MOVE      BBCUST        WCNUM
     C                   ENDIF
      *
      ** If both FACILITY & LOAN no. entered then error
      *
     C     DDFACT        IFEQ      '000'                                                     BUG6971
     C                   MOVE      *BLANKS       DDFACT                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C     DDFCNO        IFEQ      '00'                                                      BUG6971
     C                   MOVE      *BLANKS       DDFCNO                                      BUG6971
     C                   ENDIF                                                               BUG6971
      *                                                                                      BUG6971
     C                   MOVEL     DDFACT        WFACL             5
     C                   MOVE      DDFCNO        WFACL
     C     WFACL         IFNE      *BLANKS
     C     DDLNRF        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0015'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ENDIF
      *
      ** Facility no. must be numeric or the first 3 digits must be.
      *
     C     DDFACT        IFNE      *BLANKS
     C                   MOVE      '0'           TEST3             4
     C                   MOVEL     DDFACT        TEST3
     C                   TESTN                   TEST3                78
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
     C                   MOVE      DDFACT        WFAC03
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WFAC05
     C                   ENDIF
      *
     C     DDFCNO        IFEQ      *BLANKS
     C                   Z-ADD     0             WFAC02
     C                   ELSE
     C                   MOVE      DDFCNO        WFAC02
     C                   ENDIF
      *
      ** Additional validation in case facility no. is
      ** incomplete.
      *
     C     DDFCNO        IFEQ      *BLANKS
     C     DDFACT        OREQ      *BLANKS
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ENDIF
     C                   ENDIF
      *
      ** Loan no. must be numeric
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   MOVE      '0'           TEST6
     C                   MOVEL     DDLNRF        TEST6
     C                   TESTN                   TEST6                78
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
      *
     C******IN78         IFEQ      '0'                                                        CLE148
     C**********         MOVEL     'N'           DDLNRFOK                                     CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LER0010'     MsgIdArr(Ix)                                 CLE148
     C**********         GOTO      EVALAE                                                     CLE148
     C**********         ELSE                                                                 CLE148
     C     *IN78         IFEQ      '0'                                                        CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        ORNE      *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVEL     'N'           DDLNRFOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PDATA         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PDATA))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PDATA)                     MD000091
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVALAE                                                     CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVE      DDLNRF        WLOAN
      *
      ** Validate loan number against customer details file
     C     KEY004        CHAIN     CLOAN                              78
      *
     C     *IN78         IFEQ      '1'
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LER0231'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ELSE
      *
      ** Additional validation if loan no. is blank
      *
     C     DDFACT        IFNE      *BLANKS
     C     DDFCNO        ANDNE     *BLANKS
     C**********         Z-ADD     0             WLOAN                                        CLE148
     C                   MOVEL     *BLANK        WLOAN                                        CLE148
     C                   ELSE
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFCNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFACT'      FldNameArr(Ix)
     C                   MOVEL     'LER0008'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Fee sequence
      *
     C                   MOVE      '0'           TEST2
     C                   MOVEL     DDFSEQ        TEST2
     C                   TESTN                   TEST2                78
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'N'           DDFSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)
     C                   MOVEL     'LER0014'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
     C                   MOVE      DDFSEQ        WFSEQ
     C                   ENDIF
      *
     C*****WLOAN         IFNE      0                                                          CLE148
     C     WLOAN         IFNE      *BLANK                                                     CLE148
     C     PPCUST        ANDEQ     'O'
     C     KEY004        CHAIN     CLOAN                              74
     C     *IN74         IFEQ      '0'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C**********         MOVE      WCNUM         OCNUM             6 0                        CSD027
     C                   MOVE      WCNUM         OCNUM             6                          CSD027
     C                   MOVE      CL_CNUM       WCNUM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** No error found yet, check to see if record on file
      *
     C     Ix            IFEQ      *Zero
     C     KEY002        SETLL     LEFEEDF1
     C                   READ      LEFEEDF1                               74
      *
     C******IN74*        IFEQ      '0'                                                        242377
     C*****PPCUST        ANDEQ     'O'                                                        242377
     C*****CL_PTYP       IFEQ      64                                                         242377
     C*****CL_PTYP       OREQ      65                                                         242377
     C*****CL_PTYP       OREQ      68                                                         242377
     C*****CL_PTYP       OREQ      71                                                         242377
     C*****OCNUM*        IFNE      CL_OLNO                                                    242377
     C***********        MOVE      '1'           *IN74                                        242377
     C***********        ENDIF                                                                242377
     C***********        ENDIF                                                                242377
     C***********        ENDIF                                                                242377
      *
     C     *IN74         IFEQ      '0'
     C     WCNUM         IFEQ      F1_FECNUM
     C*****WLOAN         IFNE      0                                                          CLE148
     C     WLOAN         IFNE      *BLANK                                                     CLE148
     C     WLOAN         ANDNE     F1_FELOAN
     C                   MOVE      '1'           *IN74
     C                   ENDIF
      *
     C     WFAC03        IFNE      0
     C                   MOVEL     F1_FEFACL     WFAC3
     C     WFAC03        IFNE      WFAC3
     C                   MOVE      '1'           *IN74
     C                   ENDIF
      *
     C     WFAC02        IFNE      0
     C                   Z-ADD     F1_FEFACL     WWFAC2            2 0
     C     WFAC02        IFNE      WWFAC2
     C                   MOVE      '1'           *IN74
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     WFSEQ         IFNE      0
     C     WFSEQ         ANDNE     F1_FEFSEQ
     C                   MOVE      '1'           *IN74
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      '1'           *IN74
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN74         IFEQ      '0'
     C     PPCUST        ANDEQ     'O'
     C     CL_PTYP       IFEQ      64
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      68
     C     CL_PTYP       OREQ      71
     C                   MOVEL     CL_OLNO       DDCSSN
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN74         IFEQ      '1'
     C                   MOVEL     'N'           DDCSSNOK
     C                   MOVEL     'N'           DDFACTOK
     C                   MOVEL     'N'           DDFSEQOK
     C                   MOVEL     'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LER0017'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
      *
     C                   MOVE      F1_FEBRCA     WZBRCA
      *                                                                                       247541
     C     ModeofOp      IFNE      '*FRONT'                                                   247541
     C     RESPMODE      ANDEQ     'S'                                                        247541
     C                   EXSR      SRUAUT
     C                   ENDIF                                                                247541
      *
      ** Set the protect indicators depending upon details
      *
     C                   MOVE      '1'           *IN22                                     ?????
     C                   ENDIF
     C                   ENDIF
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALERR - Error in Action code                                *
      *****************************************************************
     C     VALERR        BEGSR
      *
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0172'     MsgIdArr(Ix)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCKFR  -  Check if the Facility has been reactivated.       *
      *****************************************************************
      *
     C     SRCKFR        BEGSR
      *
     C                   MOVE      *OFF          WREAC             1
      *
     C     FA_RECI       IFEQ      'C'
     C     FA_RECI       OREQ      'E'
      *
     C     KEY006        SETLL     LEFCAML3
     C     KEY006        READE     LEFCAML3                               78
      *
     C     *IN78         DOWEQ     *OFF
     C     WREAC         ANDEQ     *OFF
     C     F3_RECI       IFEQ      'D'
     C     F3_FATP       ANDEQ     'FR'
     C                   Z-ADD     F3_AAMT       WFAMT            13 0
     C                   Z-ADD     F3_NDEX       WDTEX             5 0
     C                   MOVE      *ON           WREAC
     C                   ENDIF
     C     KEY006        READE     LEFCAML3                               78
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN78
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CUSTDT - Subroutine to access customer details file          *
      *****************************************************************
     C     CUSTDT        BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*BLANKS'     PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    KEYC             10
     C                   PARM      *BLANKS       KEYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BBCUST        W#CUST            6
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUAUT  -  Check if user is authorised to the action          *
      *****************************************************************
      *
     C     SRUAUT        BEGSR
      *
      ** If single branch system, check user is authorised to action.
      *
     C     BGMBIN        IFEQ      'N'
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        WZACTN            1
     C                   PARM                    WERR              1 0
      *
     C     WERR          IFNE      0
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0123'     MsgIdArr(Ix)
     C                   GOTO      ESRUA
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If multiple branch system, user must be authorised to action
      ** on branch
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        WZACTN
     C                   PARM      WZBRCA        WZBR              3
     C                   PARM                    WERR
      *
     C     WERR          IFEQ      1
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0121'     MsgIdArr(Ix)
     C                   GOTO      ESRUA
     C                   ENDIF
      *
     C     WERR          IFEQ      2
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0122'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C     ESRUA         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAUTH  -  Validate authorisation action                      *
      *****************************************************************
     C     SRAUTH        BEGSR
      *
      ** If authorisation feature (CLE002) is not installed
      ** authorisation action is not allowed
      *
     C     CLE002        IFEQ      'N'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0161'     MsgIdArr(Ix)
     C                   GOTO      ESRAU
      *
      ** If authorisation feature is installed
      *
     C                   ELSE
      *
     C     BPFEAU        IFEQ      'N'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0162'     MsgIdArr(Ix)
     C                   GOTO      ESRAU
     C                   ELSE
      *
      ** Authorising user must be different from the insert and
      ** amend users
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056
      *
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date and status is 'R' allow auth user to be same as insert user       240968
      *                                                                                       240968
      * Or if system value CLAuthSameORED = 'Y' and status is 'R' and last change             244314
      * type was an amend then allow auth user to be same as insert user.                     244314
     C     ATHRATH       IFEQ      'Y'                                                        240968
     C     ATHSMDT       ANDNE     'Y'                                                        244314
     C     F1_FSTS       ANDNE     'R'                                                        240968
     C     F1_FELCHD     ANDGT     F1_FEORED                                                  240968
     C     F1_FELCHT     ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     F1_FEORED                                                  240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
     C     F1_FSTS       ANDEQ     'R'                                                        244314
     C     F1_FELCHT     ANDEQ     'A'                                                        244314
      *                                                                                       240968
     C     USER          IFEQ      F1_AUSR                                                    240968
     C                   MOVEL     'N'           DDACTNOK                                     240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LER0163'     MsgIdArr(Ix)                                 240968
     C                   GOTO      ESRAU                                                      240968
     C                   ENDIF                                                                240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     USER          IFEQ      F1_IUSR
     C     USER          OREQ      F1_AUSR
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and F1_FEORED = BJRDNB                       CLE056
     C                                           and PSUser = F1_IUSR) or                     CLE056
     C                             (CLE056 = 'Y' and F1_FELCHD = BJRDNB and                   CLE056
     C                              F1_FELCHT = 'A' and PSUser = F1_AUSR)                     CLE056
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0163'     MsgIdArr(Ix)
     C                   GOTO      ESRAU
     C                   ENDIF                                                                CLE056
     C                   ENDIF
     C                   ENDIF                                                                240968
      *
      ** Status of loan must be complete or requiring re-authori-
      ** sation
      *
     C     F1_FSTS       IFNE      'C'
     C     F1_FSTS       ANDNE     'R'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LER0182'     MsgIdArr(Ix)
     C                   GOTO      ESRAU
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG3760
      **  Watch List Checking Applied                                                        BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       W2CNUM                                      BUG3760
     C                   MOVEL     *BLANKS       W2FACL                                      BUG3760
     C                   MOVEL     *BLANKS       W2FSEQ                                      BUG3760
     C                   MOVEL     *BLANKS       W2LOAN                                      BUG3760
     C                   MOVEL     DDCSSN        W2CNUM                                      BUG3760
     C     DDFACT        CAT       DDFCNO        W2FACL                                      BUG3760
     C                   MOVEL     DDFSEQ        W2FSEQ                                      BUG3760
     C                   MOVEL     DDLNRF        W2LOAN                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        W2LOAN = *Blanks                                          BUG3760
     C                   EVAL      WIdntifier = %TRIM(W2CNUM + W2FACL + W2FSEQ)              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WIdntifier = %TRIM(W2LOAN + W2FSEQ)                       BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      WFuncType = 'LEFEED'                                      BUG3760
     C                   EVAL      WBranch = F1_FEBRCA                                       BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                        BUG3760
     C                   ADD       1             Ix                                          BUG3760
     C                   MOVEL     'LEL0564'     MsgIdArr(Ix)                                BUG3760
     C                   EVAL      FldNameArr(Ix)  = 'DDACTN'                                BUG3760
     C                   MOVEL     'N'           DDACTNOK                                    BUG3760
     C                   GOTO      ESRAU                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF
      *
     C     ESRAU         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VSYND - CHECK IF FEE AGAINST SYNDICATED LOAN/FACILITY
      *****************************************************************
     C     VSYND         BEGSR
      *
     C                   MOVE      'N'           WSYND             1
     C     DDLNRF        IFNE      *BLANKS
 
     C     CL_PTYP       IFNE      61
     C     CL_PTYP       ANDNE     62
     C     CL_PTYP       ANDNE     63
     C     CL_PTYP       ANDNE     70
     C     CL_PTYP       ANDNE     80                                                        BUG3813
      *                                                                                      BUG3813
     C     CL_LPFI       IFNE      *BLANKS
     C                   MOVE      'Y'           WSYND
     C                   ENDIF
 
     C                   ELSE
      * Else, not a Participation so check if facility is syndicated:
      * Facility used may be on another customer, so save CNUM value
     C**********         Z-ADD     WCNUM         WCNSAV            6 0                        CSD027
     C                   MOVE      WCNUM         WCNSAV            6                          CSD027
     C                   MOVE      CL_FCUS       WCNUM
     C                   MOVE      CL_FTYP       WFAC03
     C                   MOVE      CL_FSEQ       WFAC02
 
     C     KEY001        CHAIN     FCLTY                              78
     C     *IN78         IFEQ      '0'
     C     FA_SYIN       ANDEQ     'Y'
     C                   MOVE      'Y'           WSYND
     C                   ENDIF
     C**********         Z-ADD     WCNSAV        WCNUM             6 0                        CSD027
     C                   MOVE      WCNSAV        WCNUM             6                          CSD027
     C                   Z-ADD     0             WFAC05
     C                   ENDIF
     C                   ENDIF
 
     C     DDFACT        IFNE      *BLANKS
     C     FA_SYIN       ANDEQ     'Y'
     C     FA_PRTR       ANDNE     'I'
     C     FA_PRTR       ANDNE     'P'
     C                   MOVE      'Y'           WSYND
     C                   ENDIF
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C     FA_PRTR       IFEQ      'I'                                                        CLE106
     C     FA_PRTR       OREQ      'P'                                                        CLE106
     C     FA_PRTR       OREQ      'R'                                                        CLE106
     C     FA_PRTR       OREQ      'S'                                                        CLE106
     C                   MOVE      'Y'           WSYND                                        CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** KLIST for file FCLTY
     C     KEY001        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC03
     C                   KFLD                    WFAC02
     C                   KFLD                    WRCDT
      *
      ** KLIST for file LEFEED
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file CLOAN
     C     KEY004        KLIST
     C                   KFLD                    WLOAN
     C                   KFLD                    WCLRT
 
     C     KCLOANL4      KLIST                                                                CLE134
     C                   KFLD                    Kpd_RECI                                     CLE134
     C                   KFLD                    Kpd_LNRF                                     CLE134
      *
      ** KLIST for file LEFCAMPD
     C     KEY006        KLIST
     C                   KFLD                    FA_CNUM
     C                   KFLD                    FA_FACT
     C                   KFLD                    FA_FCNO
                                                                                             BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
                                                                                             BUG3760
     C                   IN        SDSTAT                                                    BUG3760
     C     CSC011        IFEQ      'Y'                                                       BUG3760
     C                   IN        SC24X7                                                    BUG3760
     C                   END                                                                 BUG3760
      *
      ** CLEAR OUTPUTS
     C                   CLEAR                   CrFeFilFmt
     C                   MOVEL     'Y'           DDACTNOK
     C                   MOVEL     'Y'           DDCSSNOK
     C                   MOVEL     'Y'           DDFACTOK
     C                   MOVEL     'Y'           DDFCNOOK
     C                   MOVEL     'Y'           DDLNRFOK
     C                   MOVEL     'Y'           DDFSEQOK                                     CAP084
 
     C                   MOVE      'A'           WRCDT             1
     C                   MOVE      'A'           WCLRT             1
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Loan number
     C                   PARM                    DDLNRF            6
      * (Midas) Fee Sequence
     C                   PARM                    DDFSEQ            2
      *
      * CSC011 processing date
     C                   PARM                    WRNDAY            6 0
 
      * OUTPUTS
      * (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      * Fclty FM in file format
     C                   PARM                    FacmFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
      * OK - Loan number
     C                   PARM                    DDLNRFOK          1
      * OK - Fee sequence
     C                   PARM                    DDFSEQOK          1
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Expiry date
     C                   PARM                    WDTEX
      * Facility amount
     C                   PARM                    WFAMT
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
     C                   PARM                    PRcvParm                                     244636
     C                   PARM                    PPayParm                                   AR375892
 
      ** Initialize program name
 
     C                   MOVEL     'LEFEEMRTV'   DBPGM
 
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger Detailes
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
      ** Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access Switchable SAR details for the existence of CLE002
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C                   MOVE      'N'           CLE002
     C                   ENDIF
      *                                                                                       CLE106
      **  Access Switchable SAR details for the existence of CLE106                           CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANK        @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANK                                                     CLE106
     C                   MOVE      'Y'           CLE106            1                          CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *
      **  Access Switchable SAR details for the existence of CLE005
      **  (Tranch 3)
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF
      *                                                                                       CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANK                                                     CLE134
     C                   MOVE      'Y'           CLE134            1                          CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
 
      *
      ** Check System Value: Use Original Borrower or Purchased From?
      ** Set up parameter so access object checks LoanCustOriginPurch
     C                   MOVE      *BLANKS       WPARM
     C                   MOVEL     'LoanC'       WPARM1
     C                   MOVEL     'ustOr'       WPARM2
     C                   MOVEL     'iginP'       WPARM3
     C                   MOVEL     'urch'        WPARM4
     C                   MOVEL     WPARM         SVALK1
                                                                                              CLE148
     C                   EVAL      SVALK2 = 'LoanAlphaAllow'                                  CLE148
      *
      * Call Access object:
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
      * If the system value is not found then issue a database error
     C     RTNCDE        IFNE      '        '
     C                   MOVEL     'SDSVALPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   MOVEL     '*FIRST  '    DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ELSE
      *
      * Isolate the first character of SVAL1 which = 'P' or 'O'.
     C                   MOVEL     SVAL1         WRK01             1            1 character fld
     C     WRK01         IFEQ      'O'
     C                   MOVE      'O'           PPCUST            1
     C                   ELSE
     C                   MOVE      'P'           PPCUST
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE148
     C                   MOVEL     SVAL2         wLoanAlpha        1                          CLE148
      *                                                                                      BUG3813
      ** Determine if CLE028 for Flat Rate Personal Loans (Rule of 78s)                      BUG3813
      ** enhancement is installed.                                                           BUG3813
      *                                                                                      BUG3813
     C                   MOVE      'N'           CLE028            1                         BUG3813
     C                   CALLB     'AOSARDR0'                                                BUG3813
     C                   PARM      *BLANKS       @RTCD                                       BUG3813
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3813
     C                   PARM      'CLE028'      @SARD             6                         BUG3813
      *                                                                                      BUG3813
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3813
     C                   MOVE      'Y'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3813
     C                   MOVE      'N'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
      *                                                                                      BUG3813
      ** DATABASE ERROR                                                                      BUG3813
      *                                                                                      BUG3813
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3813
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *BUG3813
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3813
     C                   EXSR      *PSSR                                                     BUG3813
     C                   ENDIF                                                               BUG3813
     C                   ENDIF                                                               BUG3813
      *                                                                                      BUG3760
      **  Access SAR details to see if CSD015 is switched on.                                BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 906                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      **  Access SAR details to see if CSC011 is switched on.                                BUG3760
                                                                                             BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSC011'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
                                                                                             BUG3760
      ** Database error                                                                      BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF   '                                     BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSC011'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 910                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC024 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 5                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
     C                   ENDIF                                                                240968
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 240968
     C                   PARM      CLAuthORED    P@OP02                                       240968
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C**********         PARM      *BLANKS       P@OP03                                CSC024 244314
     C                   PARM      CLAuthSMDT    P@OP03                                       244314
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 6                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
     C**********         ENDIF                                                         CSC024 240968
     C                   MOVEL     P@VL02        ATHRATH           1                          240968
     C                   MOVEL     P@VL03        ATHSMDT           1                          244314
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 7                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   PARM                    PLNRF             6                          CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   PARM                    PValid            6                          CLE148
      ** Check Digit (Output)                                                                 CLE148
     C                   PARM                    PChkDigit         1                          CLE148
     C                   PARM                    PData             2                          CLE148
 
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF'                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 9                                                  CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
