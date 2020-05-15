     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan Amendment retrieve a record')            *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LELOAMR   - LE Loan Amendments retrieve a record             *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD026384           Date 25Jan18               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR878735           Date 13Dec11               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247171             Date 10May07               *
      *                 243619A            Date 20Nov06               *
      *                 243619             Date 08Nov06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9493            Date 07Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2480            Date 26May04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA091             Date 31Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 06JAN04               *
      *                 CLE030             Date 02Oct02               *
      *                 CAP084  *CREATE    Date 02Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026384 - Added generation by assignment processing.        *
      *             Recompiled due to changes in LELOA2PD.            *
      *           - Applied for MD049367.                             *      
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR878735 - Field CVMR not properly inserted/updated in       *
      *             LOAMSDK. Ensure that CVMR will be written in file *
      *             Pattern fix after TCA091. (Child: AR878736)       *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247171 - Corrected position of EXTDATA in the buffer. It     *
      *           should be at the end of the buffer.                 *
      *  243619A - Reverse 243619. (Recompile)                        *
      *  243619 - Principal increase gave an exception error          *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9493 - Corrected position of ExtData and Infdata data     *
      *            structure on buffer.                               *
      *  CLE106 - Syndications Manager. Facility UTN was shown.       *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA091 - DS settlement changes.                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Buffer rebuilt incorrectly                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
     D LOAMScnFmt    E DS                  EXTNAME(LELOAMPD)
      ***  New Fclty in Screen Format - Screen 1
      *
 
     D LOA2ScnFmt    E DS                  EXTNAME(LELOA2PD)                                  CLE106
      ***  New Fclty in Screen Format - Screen 2                                              CLE106
      *                                                                                       CLE106
                                                                                              CLE106
     D InfData       E DS                  EXTNAME(LELEIFPD)                                 BUG9493
     D                                     PREFIX(IF_)                                       BUG9493
     D ExtData       E DS                  EXTNAME(LELOEXPD)                                 BUG9493
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK)
     D LoamFilXFmt   E DS                  EXTNAME(LEVLOAMPD)                                 CRE073
     D***CLREC**              321    389                                                      CGL029
     D***CLPAY**              390    948                                                      CGL029
     D  CLREC                335    389                                                       CGL029
     D  CLPAY                404    948                                                       CGL029
     D  CLRECEx             1195   1212                                                       CGL029
     D  CLPAYEx             1213   1230                                                       CGL029
      ***  Current Loan Amendment in File Format
 
      * Error indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)
      *
      ***  Loan Details 'A' Format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
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
      * to ZASETINVAL etc)
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Pay Settlement Instructions - Input
     D S_Pay         E DS                  EXTNAME(SDESSPPD)
 
      * Receive Settlement Instructions - Input
     D S_Rec         E DS                  EXTNAME(SDESSRPD)
 
      *  Screen FRA/IRS instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      *
      ***  Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure                                  CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      ** Work Variable for Facility UTN                                                       CLE106
     D CLE106          S              1A                                                      CLE106
     D CLE034          S              1A                                                      CLE034
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
 
      ** Reservation ID - Blank field here to ensure similarity with VU module
     D*ReservID********S             10    INZ(*BLANKS)                         BUG2480
 
      ************************ MAIN PROCESSING *****************************
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   LoamFilFmt
     C                   CLEAR                   LoamFilXFmt                                  CRE073
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      LELOAMRED
     C                   ELSE
     C                   MOVEL     DDLNRF_In     @LNRed
     C                   MOVEL     DDVDAT_In     @VDRed
     C                   MOVEL     DDLASN_In     @SQRed
     C                   MOVEL     *BLANK        RetCodeOut
     C                   ENDIF
      *
      * If facility read
      * and no error message returned
      *
     C     @LNRed        IFNE      *BLANK
     C     RetCodeOut    ANDEQ     *BLANK
      *
      * Retrieve facility details (all key fields required for call to rtv module)
      *
     C                   MOVEL     @LNRed        DDLNRF
     C                   MOVEL     @VDRed        DDVDAT
     C                   MOVEL     @SQRed        DDLASN
     C                   EXSR      LELOAMRTV
     C     CLE106        IFEQ      'Y'                                                        CLE106
      * Facility UTN was extracted from the FM file format data structure                     CLE106
     C                   EVAL      DDLUTN = PCRF                                              CLE106
     C                   ENDIF                                                                CLE106
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      LELOAMCVT
     C                   ENDIF
 
     C                   ENDIF
     C     CLE034        IFEQ      'Y'                                                        CLE034
      * Facility UTN was extracted from the FM file format data structure                     CLE034
     C                   EVAL      DDSTAL = STAL                                              CLE034
     C                   ENDIF                                                                CLE034
 
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDLNRF'      FldNameArr(1)
     C                   MOVEL     RetCodeOut    MsgIDArr(1)
     C                   ENDIF
                                                                                              CSF011
      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
 
      * Build buffer with required output
     C*******************EVAL           Buffer = LoamScnFmt + S_REC + S_PAY                   CGP001
     C*******************                         +ReservID + DDSTAT                          CGP001
     C*******************EVAL           Buffer = LoamScnFmt + ReservID +        CGP001BUG2480
     C*******************               DDSTAT + S_REC + S_PAY                  CGP001BUG2480
     C                   EVAL           Buffer = LoamScnFmt +                   BUG2480
     C**********                        DDSTAT + S_REC + S_PAY                        BUG2480 CLE106
     C**********                        Loa2ScnFmt + S_REC + S_PAY                    CLE106 BUG9493
     C**********                        Loa2ScnFmt + ExtData + S_REC + S_PAY +        BUG9493 247171
     C**********                        InfData                                       BUG9493 247171
     C**********                        Loa2ScnFmt + S_REC + S_PAY +                   247171 CSF011
     C                                  Loa2ScnFmt +                                         CSF011A
     C                                  S_REC + S_PAY +                                       CSF011
     C                                  InfData + ExtData                                     247171
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
 
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LELOAMRED     BEGSR
      *
     C                   CALLB     'LELOAMRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action code
     C                   PARM                    DDACTN
 
      * Read forwards/backwards
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
 
      * Loan number / value date / sequence
     C                   PARM                    DDLNRF_In
     C                   PARM                    DDVDAT_In
     C                   PARM                    DDLASN_In
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN            1
     C                   PARM                    BJDFIN            1
 
      * Output Parameters :
      * Error message
 
      * Loan number / value date / sequence
     C                   PARM      *BLANK        @LNRed            6
     C                   PARM      *BLANK        @VDRed            6
     C                   PARM      *BLANK        @SQRed            3
      *
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
     C     LELOAMRTV     BEGSR
 
     C                   CALLB     'LELOAMRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Front Office Transaction ID
      * Front office transaction Id
     C                   PARM                    C_FRNT           20
      * Loan number / value date / sequence
     C                   PARM                    DDLNRF            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDLASN            3
     C                   PARM                    DDATYP            2
 
      * Where called from
     C                   PARM                    CallModCod        3
      * Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN
      *
      * OUTPUTS
      * Outputs
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    LOAMFilFmt
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
 
      * Error Indicators
     C                   PARM                    LOAM_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    LOAMFilXFmt                                  CRE073
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
     C     LELOAMCVT     BEGSR
      *
      **  Save the action code (LOAMScnFmt is blanked)
     C                   MOVE      DDACTN        @DDACTN           1
 
     C                   CALLB     'LELOAMCVT'
      * Inputs
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Amendment - file format
     C                   PARM                    LoamFilFmt
      *
      * Date format indicator
     C                   PARM                    BJDFIN
      *
      * Output parameters
      * Amendment Details - screen formats
     C                   PARM                    LoamScnFmt
      *
      **  Output only screen field : Loan status
     C**********         PARM                    DDSTAT           16                          CLE106
     C                   PARM                    DDASTS                                       CLE106
     C                   PARM                    LoamFilXFmt                                  CRE073
      *
      ** Add the action code
     C                   MOVE      @DDACTN       DDACTN
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
      ***  Convert settlement details from file to screen format
 
     C                   EVAL      FLPAY = CLPAY
     C                   EVAL      FLREC = CLREC
     C                   EVAL      FLRONS = CLRECEx                                           CGL029
     C                   EVAL      FLRSTM = RSTM                                              CGL029
     C                   EVAL      FLROBR = OSBR                                              TCA091
     C                   EVAL      FLCVMR = CVMR                                            AR878735
     C                   EVAL      FLPONS = CLPAYEx                                           CGL029
     C                   EVAL      FLPSTM = PSTM                                              CGL029
     C                   EVAL      FLPOBR = OSBR                                              TCA091
     C                   EVAL      FLCVMR = CVMR                                             CSF011A
      *                                                                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
      *
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
     C                   PARM      CCY           #TRCCY                                      CSF011A
     C                   PARM      CCY           #TPCCY                                      CSF011A
 
 
     C                   ENDSR
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCNUM <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCNUM                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDVDAT_In         6
     C                   PARM                    DDLASN_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      * Hook to enable non-core Message files to be included
     D/COPY WNCPYSRC,LELOAMM01
 
      ** Retrieve Midas Module details
     C                   CALL      'AOMMODR0'
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
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
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
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
                                                                                              CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C     @RTCD         IFEQ      '*NRF'                                                     CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
                                                                                              CLE106
      ** Database error                                                                       CLE106
                                                                                              CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE106
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE106
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
      *                                                                                       CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
                                                                                              CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
     C     @RTCD         IFEQ      '*NRF'                                                     CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
      ** Database error                                                                       CLE034
      *                                                                                       CLE034
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE034
     C                   MOVEL     '009'         DBASE                          * DBERR 009 * CLE034
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
      *                                                                                       CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003