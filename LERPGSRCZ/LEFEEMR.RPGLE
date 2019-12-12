     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Retrieve a record')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMR - LE Fee Input                                       *
      *                                                               *
      *  Function:  This is the API function for Fee Input            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD030856           Date 06Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR904186           Date 01Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10976           Date 30Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5809            Date 17Feb05               *
      *                 BUG4547            Date 23Jun04               *
      *                 BUG3048            Date 23Jun04               *
      *                 CAP084  *CREATE    Date 29Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030856 - Introduced reject processing to FEEM              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR904186 - Customer short name, customer report name and     *
      *             customer report town were not displayed in FEES   *
      *             tab when you click Main list "Edit", "Action" and *
      *             "Enquire" command buttons                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus (Recompile)         *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10976 - Add hidden facility fields.(Recompile)            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. UTN fields were shown.        *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG5809 - Response mode should be 'S'                        *
      *  BUG4547- Check for blank facility number as well as zero.    *
      *  BUG3048- Recompiled due to errors in validation.             *
      *  CAP084 - Midas Plus API development                          *
      *           Added the 10-digit account code CGL029.             *
      *                                                               *
      *****************************************************************
      *                                                               *
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *                                                               *
     FFCLTY     IF   E           K DISK                                                       CLE106
     F                                     PREFIX(FC)                                         CLE106
     F                                     IGNORE(FCLTYHHF)                                   CLE106
     F                                     IGNORE(FCLTYFNF)                                   CLE106
     F                                     IGNORE(FCLTYZZF)                                   CLE106
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
      ** Current Fee in File Format
     D  FeemFilREC           308    362
     D  FeemFilPAY           377    921
     D  FeemFilRECx         1076   1093
     D  FeemFilPAYx         1094   1111
 
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@)
      ** Current Fee in Screen Format
 
     D NwFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(N_)
      ** New Fee in Screen Format
 
     D NwFe2ScnFmt   E DS                  EXTNAME(LEFEEM2PD)
      ** New Fee Work Screen Format
 
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
      ** Customer Loans record CL in file Format
 
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
      ** Facility record FM in file Format
 
     D NwStampTax    E DS                  EXTNAME(LESTMPPD)                                  CER049
      ** File Stamp Tax                                                                       CER049
                                                                                              CER049
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
     D DRejFlg         S              1                                                     MD030856
                                                                                              CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer details                                                     CSF011
                                                                                              CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
                                                                                              CSF011
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** File Receive instructions
     D  FLREC                 21     75
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ** File Payment instructions
     D  FLPAY                 21    565
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File Fra/irs instructions
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen Receive instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen Payment instructions
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** Screen Fra/irs instructions
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
                                                                                              244636
      ** Parameter for LEFEEMRTV                                                              244636
     D PRcvParm        S             92                                                       244636
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D CLE106          S              1A                                                      CLE106
     D CLE034          S              1A                                                      CLE034
      * Work Fields                                                                           CLE031
     D KCNUM           S                   LIKE(FCCNUM)                                       CLE031
     D KFACT           S                   LIKE(FCFACT)                                       CLE031
     D KFCNO           S                   LIKE(FCFCNO)                                       CLE031
     D KRCTP           S                   LIKE(FCRCTP)                                       CLE031
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFEEMS001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
     C                   CLEAR                   CrFeFilFmt
     C                   CLEAR                   NwFeScnFmt
     C                   CLEAR                   NwFe2ScnFmt
     C                   CLEAR                   NwStampTax                                   CER049
     C                   RESET                   ReturnCode
 
      ** If the action code is blank, enquire unless authorising
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
     C                   EXSR      LEFEEMRED
     C                   ELSE
     C                   MOVEL     DDCSSN_In     @CNUMR
     C                   MOVEL     DDFACT_In     @FACTR
     C                   MOVEL     DDFCNO_In     @FCNOR
     C                   MOVEL     DDLNRF_In     @LNRFR
     C                   MOVEL     DDFSEQ_In     @FSEQR
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
 
      ** If fee read and no error message returned
 
     C     @CNUMR        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
 
      ** Retrieve fee details (all key fields required for call to RTV module)
 
     C                   MOVEL     @CNUMR        DDCSSN
 
     C     @FACTR        IFEQ      '000'
     C     @FCNOR        ANDEQ     '00'
     C     @FACTR        OREQ      '000'                                                     BUG4547
     C     @FCNOR        ANDEQ     '  '                                                      BUG4547
     C                   MOVE      *BLANKS       DDFACT
     C                   MOVE      *BLANKS       DDFCNO
     C                   ELSE
     C                   MOVEL     @FACTR        DDFACT
     C                   MOVEL     @FCNOR        DDFCNO
     C                   ENDIF
 
     C*****@LNRFR        IFEQ      '000000'                                                   CLE148
     C     @LNRFR        IFEQ      *BLANKS                                                    CLE148
     C                   MOVE      *BLANKS       DDLNRF
     C                   ELSE
     C                   MOVEL     @LNRFR        DDLNRF
     C                   ENDIF
     C                   MOVEL     @FSEQR        DDFSEQ
     C                   MOVEL     @FTRED        FOTRID
     C                   EXSR      LEFEEMRTV
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C     DDLNRF        IFEQ      *BLANKS                                                    CLE106
     C                   EVAL      KRCTP = 'A'                                                CLE106
     C                   EVAL      KCNUM = FECNUM                                             CLE106
     C                   MOVEL     FEFACL        KFACT                                        CLE106
     C                   MOVE      FEFACL        KFCNO                                        CLE106
     C     CHKFAC        CHAIN     FCLTY                                                      CLE106
     C                   EVAL      DDFUTN = FCPCRF                                            CLE106
     C                   EVAL      DDLUTN = *BLANKS                                           CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      DDFUTN = *BLANKS                                           CLE106
     C                   EVAL      DDLUTN = CL_PCRF                                           CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** UTN fields were extracted                                                            CLE106
      *                                                                                       CLE106
     C                   EVAL      DDEUTN = PCRF                                              CLE106
     C                   EVAL      DDSYIN = FESYIN                                            CLE106
     C                   EVAL      DDPRTR = PTFI                                              CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
 
      ** Convert to screeen format
 
     C     Idx           IFEQ      0
     C                   EXSR      LEFEEMCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      N_DDSTAL = FESTAL                                          CLE034
     C                   EVAL      @DDSTAL = FESTAL                                           CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   ENDIF
 
     C                   Z-ADD     Idx           Ix
     C     @ERRMS        IFNE      *BLANK
     C                   Eval      Ix = Ix + 1
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     @ERRMS        MsgIDArr(Ix)
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF
 
     C     ReturnCode    IFNE      *BLANK
     C                   Eval      Ix = Ix + 1
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCSSN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0035'     MsgIDArr(Ix)
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF
 
     C                   EXSR      SrCustName                                                 CSF011
                                                                                              CSF011
      ** Remerge buffer with all relevant data structures
     C                   MOVE      *BLANKS       DRejFlg                                    MD030856
     C                   EVAL      Buffer = NwFeScnFmt + NwFe2ScnFmt +
     C                                      NwStampTax  +                                     CER049
     C                                      ##RECS + ##PAYS
     C                                      + DRejFlg                                       MD030856
 
     C                   MOVE      '1'           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LEFEEMRED - Read fee details                                 *
      *                                                               *
      *****************************************************************
     C     LEFEEMRED     BEGSR
 
     C                   CALLB     'LEFEEMRED'
 
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
 
      ** Action code
     C                   PARM                    DDACTN            1
 
      ** Customer number
      ** Facility type
      ** Facility number
      ** Loan number
      ** Fee sequence
     C                   PARM      DDCSSN_In     DDCSSN           10
     C                   PARM      DDFACT_In     DDFACT            3
     C                   PARM      DDFCNO_In     DDFCNO            2
     C                   PARM      DDLNRF_In     DDLNRF            6
     C                   PARM      DDFSEQ_In     DDFSEQ            2
 
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
 
      ** Read forwards
      ** Read backwards
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
 
      ** OUTPUT PARAMETERS
      ** Error message
     C                   PARM                    @ERRMS            7
 
      ** Customer number
      ** Facility type
      ** Facility number
      ** Loan number
      ** Fee sequence
     C                   PARM                    @CNUMR            6
     C                   PARM                    @FACTR            3
     C                   PARM                    @FCNOR            2
     C                   PARM                    @LNRFR            6
     C                   PARM                    @FSEQR            2
 
      ** Front Office Fee Read
     C                   PARM                    @FTRED           20
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LEFEEMRTV - Retrieve fee details from file                   *
      *                                                               *
      *****************************************************************
     C     LEFEEMRTV     BEGSR
 
     C                   CALLB     'LEFEEMRTV'
      ** INPUTS
      ** Return code
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
 
      ** Response mode
     C**********         PARM                    RespMode          1                         BUG5809
     C                   PARM      'S'           RespMode          1                         BUG5809
 
      ** Action Code
     C                   PARM                    DDACTN            1
 
      ** Front Office Transaction ID
      ** Front Office User
     C                   PARM                    FOTRID           20
     C                   PARM                    FOUSER           16
 
      ** (Midas) Customer Number
      ** (Midas) Facility Type
      ** (Midas) Facility number
      ** (Midas) Loan number
      ** (Midas) Fee Sequence
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
     C                   PARM                    DDLNRF            6
     C                   PARM                    DDFSEQ            2
 
      ** CSC011 processing date
     C                   PARM                    WRNDAY
 
      ** OUTPUTS
      ** (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
 
      ** Loan CL in file format
      ** Facilty FM in file format
     C                   PARM                    ClilFilFmt
     C                   PARM                    FacmFilFmt
 
      ** OK - Action code
      ** OK - Customer number
      ** OK - Facility type
      ** OK - Facility number
      ** OK - Loan number
      ** OK - Fee sequence
     C                   PARM                    DDactnOK          1
     C                   PARM                    DDcssnOK          1
     C                   PARM                    DDfactOK          1
     C                   PARM                    DDfcnoOK          1
     C                   PARM                    DDlnrfOK          1
     C                   PARM                    DDfseqOK          1
 
      ** Fee against a syndicated facility/loan
      ** Expiry date
      ** Facility amount
     C                   PARM                    WSYND             1
     C                   PARM                    WDTEX             5 0
     C                   PARM                    WFAMT            13 0
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     244636
 
     C     DDACTNOK      IFEQ      'Y'
     C     DDCSSNOK      ANDEQ     'Y'
     C     DDFACTOK      ANDEQ     'Y'
     C     DDFCNOOK      ANDEQ     'Y'
     C     DDLNRFOK      ANDEQ     'Y'
     C     DDFSEQOK      ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LEFEEMCVT - Convert file fields to screen fields             *
      *                                                               *
      *****************************************************************
     C     LEFEEMCVT     BEGSR
 
     C                   MOVE      DDACTN        N_DDACTN
 
      ** Call program to fill screen fields with data from Fee file
 
     C                   CALLB     'LEFEEMCVT'
 
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Fee in file format
     C                   PARM                    CrFeFilFmt
 
      ** Loan in file format
      ** Facility FM in file formats
     C                   PARM                    ClilFilFmt
     C                   PARM                    FacmFilFmt
 
      ** CLE006
      ** Fee against a syndicated facility/loan
     C                   PARM                    CLE006            1
     C                   PARM                    WSYND             1
 
      ** OUTPUT
      ** Fee in screen format
     C                   PARM                    NwFeScnFmt
 
      ** Participant Fee indicator
     C                   PARM                    WPTFI             1
 
      ** Update 'Current' Fee   with Fee   in Screen Format
 
     C                   MOVEL     NwFeScnFmt    CrFeScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASETINCVT- Convert File format to Settlement Screen format  *
      *                                                               *
      *****************************************************************
     C     ZASETINCVT    BEGSR
 
      ** Set up payment instructions from fee
 
     C                   MOVEL     FeemFilPAY    FLPAY
     C                   MOVEL     PSTM          FLPSTM
     C                   MOVEL     PONS          FLPONS
     C                   MOVEL     CVMR          FLCVMR
     C                   MOVEL     FESCCY        FLPSCY
     C                   MOVEL     FEICCY        FLIC72
     C                   MOVE      OMDB          FLPOBR
 
      ** Set up receive instructions from fee
 
     C                   MOVEL     FeemFilREC    FLREC
     C                   MOVEL     RSTM          FLRSTM
     C                   MOVEL     RONS          FLRONS
     C                   MOVEL     FESCCY        FLRSCY
     C                   MOVE      OSDB          FLROBR
      *                                                                                       CLE031
     C                   Z-ADD     FEREXR        FLREXR                                       CLE031
     C                   Z-ADD     FEPEXR        FLPEXR                                       CLE031
     C                   MOVE      FEREXI        FLREXI                                       CLE031
     C                   MOVE      FEPEXI        FLPEXI                                       CLE031
     C                   MOVE      FESCCY        FLRSCY                                       CLE031
     C                   MOVE      FEPSCY        FLPSCY                                       CLE031
 
     C                   EVAL      WTRCcy = N_DDECUR                                         CSF011A
     C                   EVAL      WTPCcy = N_DDECUR                                         CSF011A
     C                                                                                       CSF011A
      ** Convert settlement details from file to screen format
     C                   CALLB     'ZASETINCVT'
 
      ** INPUTS
      ** File Payment Settlement Instruction
      ** File Receipt Settlement Instruction
      ** File FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
 
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
      ** Screen Receipt Settlement Instruction
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
     C                   PARM      *BLANK        ##RECS
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                              CSF011
     C                   EVAL      WCustomer = @DDCSSN                                       CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C**********         EVAL      @DDCRSN = BBCSSN                                 CSF011A AR904186
     C**********         EVAL      @DDCRNM = BBCRNM                                 CSF011A AR904186
     C**********         EVAL      @DDCRTN = BBCRTN                                 CSF011A AR904186
     C                   EVAL      N_DDCRSN = BBCSSN                                        AR904186
     C                   EVAL      N_DDCRNM = BBCRNM                                        AR904186
     C                   EVAL      N_DDCRTN = BBCRTN                                        AR904186
     C                   ELSE                                                                CSF011A
     C**********         EVAL      @DDCRSN = *BLANKS                                CSF011A AR904186
     C**********         EVAL      @DDCRNM = *BLANKS                                CSF011A AR904186
     C**********         EVAL      @DDCRTN = *BLANKS                                CSF011A AR904186
     C                   EVAL      N_DDCRSN = *BLANKS                                       AR904186
     C                   EVAL      N_DDCRNM = *BLANKS                                       AR904186
     C                   EVAL      N_DDCRTN = *BLANKS                                       AR904186
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrRtvCust     BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    WCustomer                                   CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                  CSF011
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCSSN_In        10
     C                   PARM                    DDFACT_In         3
     C                   PARM                    DDFCNO_In         2
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDFSEQ_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
 
      ** Initialize program name
 
     C                   MOVEL     'LEFEEMR'     DBPGM
     C     CHKFAC        KLIST                                                                CLE106
     C                   KFLD                    KCNUM                                        CLE106
     C                   KFLD                    KFACT                                        CLE106
     C                   KFLD                    KFCNO                                        CLE106
     C                   KFLD                    KRCTP                                        CLE106
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
 
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
 
      ** Determine if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   MOVE      BJRDNB        WRNDAY
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
      ** Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C     @RTCD         IFEQ      '*NRF'                                                     CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** Database error                                                                       CLE106
      *                                                                                       CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE106
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE106
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
                                                                                              CLE034
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
                                                                                              CLE034
      ** Database error                                                                       CLE034
                                                                                              CLE034
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE034
     C                   MOVEL     '009'         DBASE                          * DBERR 009 * CLE034
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
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
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
