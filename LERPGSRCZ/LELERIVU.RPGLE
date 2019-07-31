     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover validate and update')                *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LELERIVU - LE Rollover validate and update                   *
      *                                                               *
      *  Function: This Program Validates LE Rollover for             *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For A (=AMEND), X (=AUTHORISE)                   *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *              - Validate the Transaction details fields        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD039547           Date 20Sep16               *
      *                 MD041649           Date 06Oct16               *
      *                 CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 AR702532           Date 13Jan15               *
      *                 MD028338           Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863960           Date 14Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR820267           Date 25Aug11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247628             Date 09May07               *
      *                 246576             Date 28Mar07               *
      *                 BUG13843           Date 02May07               *
      *                 BUG13351           Date 16Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11315           Date 03May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9787            Date 22Feb06               *
      *                 BUG10456           Date 10Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CLE034             Date 05May03               *
      *                 BUG8145            Date 12Aug05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5809            Date 17Feb05               *
      *                 BUG3405 (REOPENED) Date 08Jul04               *
      *                 BUG3405            Date 02Jul04               *
      *                 BUG2579            Date 22Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 BUG827             Date 11May04               *
      *                 CAP084  *CREATE    Date 08Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD041649 - Validation during authorisation should be executed*
      *  CLE168 - Allow Debit of Blocked Account                      *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR016: Settlement Allocation                      *
      *  AR863960 - Settlement Payment fields values are reset to     *
      *             blanks                                            *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR820267 - Mapping error and Contractual Spread error not    *
      *             recognized                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247628 - Applied fix 244446.                                 *
      *  246576 - Buffer field is not set up correctly.               *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  BUG13351 - Apply GEMS 244446                                 *
      *  244446 - Initially set loan currency to settlement currency. *
      *  BUG11315 - Recompiled due to changes in LELERI3PD.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9787 - Added the Loan Processing Type (Recompiled)        *
      *  BUG10456- Validate and update settlement details without     *
      *            limitations.                                       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  BUG8145 - Call to AOMMODDR0 to access Midas Module Info      *
      *            Also add call to LELERIR to get correct record     *
      *            information after file update                      *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG5809 - Response mode should be 'S'                        *
      *  BUG3405 (REOPENED) - Removed DDCCYN from work fields         *
      *  BUG3405 - Added new base rate code currency for LERI.xml     *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - Midas Plus API development.                         *
      *           The existing core version was replaced by this new  *
      *           program.  The following changes were included:      *
      *           CGL029 - Increase Account Code to 10 digits         *
      *           222373 - Parameter Mismatch                         *
      *           TDA067 - Misaligned settlement details (further     *
      *                    corrections were made on this bug)         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
     FLEFCLTL0  IF   E           K DISK
     F                                     PREFIX(F_)
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE168
     F                                     PREFIX(C_)                                         CLE168

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
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      ** Array of Fields in error.                                                           BUG8145
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG8145
                                                                                             BUG8145
      ** Array of error message IDs                                                          BUG8145
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG8145
     D                                     LIKE(#MsgID)                                      BUG8145
                                                                                             BUG8145
      ** Array of error message data.                                                        BUG8145
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG8145
     D                                     LIKE(#MsgData)                                    BUG8145
                                                                                             BUG8145
      ** Array of message files to check                                                     BUG8145
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG8145
                                                                                             BUG8145
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

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

     D HeadIn        E DS                  EXTNAME(APHEADPD)
      ** Incoming Header

     D TranInLERI    E DS                  EXTNAME(LELERIPD)
      ** Incoming Transaction
     D  RLSPIX               151    240

     D TranInLERI2   E DS                  EXTNAME(LELERI2PD)
      ** Incoming Work Fields

     D TranInLERI3   E DS                  EXTNAME(LELERI3PD)
      ** Incoming MidasPlus Work Fields

     D CrRoScnFmt    E DS                  EXTNAME(LELERIPD)
     D                                     PREFIX(@)
      ** (Current) Rollover Instructions Screen Format

     D NwRoScnFmt    E DS                  EXTNAME(LELERIPD)
     D                                     PREFIX(N_)
      ** Rollover Instructions Screen Format

     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
     D                                     PREFIX(N_)
      ** Rollover Instructions Work fields
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (LERI) Extra Data - File (D/B) format                                              CAP086

     D ValidLoanL    E DS                  EXTNAME(LEVLERLPD)
      ** Valid Customer Loans CL layout
     D  CLREC                473    527
     D  CLPAY                542   1086

     D ValidLoanK    E DS                  EXTNAME(LEVLERKPD)
     D                                     PREFIX(K_)
      ** Valid Customer Loans CK layout
     D  CKREC                415    469
     D  CKPAY                558   1102

     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L)
      ** (Current) Customer Loans record CL in file Format
     D  CULREC               473    527
     D  CULPAY               542   1086

     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K)
      ** (Current) Customer Loans record CK in file Format
     D  CUKREC               415    469
     D  CUKPAY               558   1102

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** File Receive Instructions
     D  FLREC                 21     75

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ** File Payment Instructions
     D  FLPAY                 21    565

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** File FRA/IRS Instructions

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen Receive Instructions

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen Payment Instructions

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** Screen FRA/IRS Instructions

     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
      ** Error indicators

      ** Array for job name
     D ARRJBNAM        S             10A   DIM(10)

     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)
      ** Midas SC Jobs handling commitment control data area
     D  COMITNOM               1      3S 0
     D  COMITJOB               4    103

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** External DS for SAR details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details

     D ExtData       E DS                  EXTNAME(LELEEXPD)
      ** LE Rollover Extra Data - File (D/B) format

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

      *                                                                                       CLE168
     D LEFCLY        E DS                  EXTNAME(LEFCLYPP) DTAARA                           CLE168
     D                                     PREFIX(A_)                                         CLE168
      *                                                                                       CLE168

      ** Flags to indicate whether Pay Settlement instruction fields
      ** are valid
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

     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A

      ** Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D ACCYA           S              3    DIM(12)

      ** Counter variable
     D CSC022          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CLE106          S              1A   INZ('N')                                           CLE106

      ** Commitment Flag
     D WCMT01          S              1A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.

     C                   MOVEL     Trans5001     TranInLERI
     C                   MOVEL     Trans5002     TranInLERI2
     C                   MOVEL     Trans5003     TranInLERI3
     C                   MOVEL     InfData500    InfData                                      CAP086
     C**********         MOVEL     Extdata500    Extdata                                      CAP086
     C                   MOVEL     ExtData500    ExtData                                      CAP086

      ** Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      ** Validate Action Code by using the RTV module

     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      ** Processing depends upon Action Code

     C                   SELECT

      ** Processing for Enquire
     C                   WHEN      DDACTN = 'E'
     C                   EXSR      SetupLn

      ** Processing for Amends
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SetupLn
     C                   EXSR      ValidateAm
     C                   EXSR      ValidateTr
     C                   EXSR      ValExtSett

      ** Processing for Authorise or Release
     C                   WHEN      DDACTN = 'X' OR DDACTN = 'Q'
     C                   EXSR      SetupLn
     C                   EXSR      ValidateTr
     C                   EXSR      ValExtSett

     C                   ENDSL

     C     INVALID       TAG

      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011

     C     ReturnCode    IFNE      *BLANKS
     C                   Eval      Idx = Idx + 1
     C                   Eval      Ix = Idx
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEL0035'     MsgIDArr(Ix)
     C                   MOVE      'Y'           DDRTCD
     C                   ENDIF

      ** Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

      ** If action is for update, get the correct record information from file               BUG8145
      ** Only for TranInLERI part of screen formats                                          BUG8145
                                                                                             BUG8145
     C                   If        UpdateYN = 'Y'                                            BUG8145
     C                             and Idx = 0                                               BUG8145
     C                   Eval      DDLNRF_In = DDLNRF                                        BUG8145
     C                   Eval      DDACTN_In = 'E'                                           BUG8145
      *                                                                                       246576
      ** Disable call to LELERIR                                                              246576
     C                   If        'a' = 'b'                                                  246576
     C                   CALL      'LELERIR'                                                 BUG8145
     C                   PARM                    @AuthComp         1                         BUG8145
     C                   PARM                    @FwdBck           1                         BUG8145
     C                   PARM                    DDLNRF_In         6                         BUG8145
     C                   PARM                    DDACTN_In         1                         BUG8145
     C                   PARM                    Buffer                                      BUG8145
     C                   PARM                    @FldNameArr                                 BUG8145
     C                   PARM                    @MsgIDArr                                   BUG8145
     C                   PARM                    @MsgDtaArr                                  BUG8145
     C                   PARM                    @MsgFArray                                  BUG8145
     C                   PARM                    APIRetC           1                         BUG8145
     C                   PARM                    @ACTRV                                     AR702532
                                                                                             BUG8145
     C**********         MOVEL     TranInLERI    Buffer                               BUG8145 246576
     C                   EVAL      Buffer = TranInLERI + TranInLERI2 +                        246576
     C                                      TranInLERI3 +                                     246576
     C**********                            ##RECS + ##PAYS +                        246576 AR702532
     C                                      @ACTRV + ##RECS + ##PAYS +                      AR702532
     C                                      InfData + ExtData                                 246576
     C                   Endif                                                                246576
     C                   Else                                                                BUG8145
      ** Remerge buffer with all relevant data structures

     C                   EVAL      Buffer = TranInLERI + TranInLERI2 +
     C                                      TranInLERI3 +
     C**********                            ##RECS + ##PAYS + ExtData                         CAP086
     C**********                            ##RECS + ##PAYS +                        CAP086 AR702532
     C                                      @ACTRV + ##RECS + ##PAYS +                      AR702532
     C                                      InfData + ExtData                                 CAP086
     C                   EndIf                                                               BUG8145

     C                   MOVE      '1'           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              Transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

      ** Validate action code versus transaction IDs supplied
      ** The Transaction in file format from the LE database is retrieved
      ** as well.

     C                   RESET                   ReturnCode

     C                   CALLB     'LELERIRTV'

      ** INPUTS
      ** Return code
     C                   PARM      *BLANK        ReturnCode

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp          6

      ** Response mode
     C**********         PARM                    APRESPMODE        1                         BUG5809
     C                   PARM      'S'           APRESPMODE        1                         BUG5809

      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Customer Loans Number
     C                   PARM                    DDACTN            1
     C                   PARM                    APFOTranID       20
     C                   PARM                    DDLNRF

      ** Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1

      ** OUTPUTS
      ** (Current) Customer loan CL in file format
      ** (Current) Customer loan CK in file format
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK

      ** OK - Action code
      ** OK - Loan Number
     C                   PARM                    DDActnOK          1
     C                   PARM                    DDLnrfOK          1

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Set screen OK fields to 'Y' if action code and loan number is valid

     C     DDActnOK      IFEQ      'Y'
     C     DDLnrfOK      ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF

      ** Retain Loan UTN (PC Ref) from Loan's Details and display onscreen                    CLE106
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      DDLUTN = LPCRF                                             CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetupLn  - Set up fields that are needed                     *
      *                                                               *
      *****************************************************************
     C     SetupLn       BEGSR

      ** Put the complete (pre-existing) Transaction into the Valid
      ** file record

     C**********         MOVE      CrLnFilFmtCL  ValidLoanL                                   CAS011
     C                   MOVEL     CrLnFilFmtCL  ValidLoanL                                   CAS011
     C                   MOVE      CrLnFilFmtCK  ValidLoanK

     C                   EXSR      LELERICVT

      ** Copy original details from TranInLERI to CrRoScnFmt
      ** because it was overwritten by the CVT module

     C                   MOVE      DDACTN        @DDACTN
     C                   MOVEL     DDLNRF        @DDLNRF
     C                   MOVEL     DDCUST        @DDCUST

      ** If Enquiry or Authorise, move all CVT fields

     C     DDACTN        IFEQ      'E'
     C*****DDACTN        OREQ      'X'                                                        CLE106
     C                   EVAL      TranInLERI  = CrRoScnFmt
     C                   EVAL      TranInLERI2 = NwRoScnFmt2
     C                   ENDIF

      ** If Amend
      ** If the special instructions from TranInLERI (RLSPIX) is
      **   equal to blanks, get the value from file.

     C     DDACTN        IFEQ      'A'

     C     RLSPIX        IFEQ      *BLANKS
     C     TranInLERI2   ANDEQ     *BLANKS
     C                   MOVEL     @DDSPI1       DDSPI1
     C                   MOVEL     @DDSPI2       DDSPI2
     C                   MOVEL     @DDSPI3       DDSPI3
     C                   ENDIF

     C                   EVAL      CrRoScnFmt  = TranInLERI                     from Screen
     C                   EVAL      TranInLERI2 = NwRoScnFmt2                    from CVT module
     C                   ENDIF

      ** Check if Extended Settlements, Funding details and Mutli ccy
      ** Rollovers are required

     C                   EXSR      @CHKLOAN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LELERICVT - Convert File format to screen format             *
      *                                                               *
      *****************************************************************
     C     LELERICVT     BEGSR

     C                   RESET                   ReturnCode
     C                   CALLB     'LELERICVT'

      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode

      ** Loan in file format CL
      ** Loan in file format CK
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK

      ** Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579

      ** OUTPUTS
      ** Loan in screen format
      ** Rollover Work Fields
     C                   PARM                    NwRoScnFmt
     C                   PARM                    NwRoScnFmt2

      ** Update 'Current' Loan with Loan in Screen Format
     C                   MOVEL     NwRoScnFmt    CrRoScnFmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAm - Routine to check whether the fields amended     *
      *               are amendable.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateAm    BEGSR

      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

      ** AMEND CHECKING

     C                   RESET                   ReturnCode

     C                   CALLB     'LELERIAMD'
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode

      ** Incoming Rollover Instructions Details :
      ** (Current) Rollover Instr in Screen Format :
     C                   PARM                    TranInLERI
     C                   PARM                    CrRoScnFmt

      ** (Current) Loan in file format:
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK

      ** OUTPUTS
      ** Error Indicators
     C                   PARM                    LERI_OK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr

      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx

      ** Amendments OK
     C                   PARM                    AmendOk           1

      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr - Routine to validate the main transaction        *
      *               details                                         *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR

     C                   CALLB     'LELERIVAL'
      ** INPUTS
      ** Response mode
     C                   PARM                    ARRESPMODE

      ** Rollover Instructions Details
     C                   PARM                    TranInLERI
                                                                                              CAP086
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ARFOTRANID

      ** Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR702532
      ** Action Code (Reject transaction)                                                   AR702532
      *                                                                                     AR702532
     C                   PARM                    @ACTRV                                     AR702532

      ** OUTPUTS
      ** Rollover Instructions Details OK inds
     C                   PARM                    LERI_OK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid Customer Loans CL layout (DS) from/to caller
      ** Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK

      ** Multi-currency allowed by Loan facility
      ** New Facility xrate required for CLE023                                              BUG2579
      ** Funding Details required
     C                   PARM                    @MULTI            1
     C                   PARM                    @FCXRATE                                    BUG2579
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827

      ** Repayment Exist
     C                   PARM                    @WERLN
     C                   PARM                    @WLNNO

      ** Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
     C                   PARM                    WINCY
     C                   PARM                    WPSET
     C                   PARM                    WRLDT1            1
     C                   PARM                    WNCCY1            1
     C                   PARM                    MULTIC
     C                   PARM                    WSett             1

      ** Current Loan
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK

      ** Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM      *blank        @@CTU             1

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValExtSett - Validate Settlement Details                     *
      *                                                               *
      *****************************************************************
     C     ValExtSett    BEGSR

     C                   EVAL      FLREXR = *Zeros                                            CLE031
     C                   EVAL      FLPEXR = *Zeros                                            CLE031
     C                   EVAL      FLREXI = *Blanks                                           CLE031
     C                   EVAL      FLPEXI = *Blanks                                           CLE031
     C                   MOVE      DDACTN        WDDACTN           1                        MD041649
     C     DDACTN        IFEQ      'X'                                                      MD041649
     C                   MOVE      'A'           DDACTN                                     MD041649
     C                   ENDIF                                                              MD041649

      ***Validate*settlement*details*if*Discount*Loan******************                     BUG10456
      ***or*a*multi-currency*rollover**********************************                     BUG10456
      ** Validate settlement details unconditionally                                        BUG10456

     C*****WDisc         IFEQ      'Y'                                                      BUG10456
     C*****DDNCCY        ORNE      *BLANKS                                                  BUG10456
     C*****DDNCCYB       ORNE      *BLANKS                                                  BUG10456
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
     C                   MOVE      WDDACTN       DDACTN                                     MD041649
     C**********         ENDIF                                                              BUG10456

      ** Settlement details should not be filled up when the
      ** new currency field is not entered

     C     DDWPSET       IFEQ      'Y'
     C     DDMULTI       ANDEQ     'Y'
     C     DDLNCAT       ANDNE     'DISC'
     C     DDNCCYB       ANDEQ     *BLANKS
     C     DDNCCY        ANDEQ     *BLANKS
     C     DDACTN        ANDEQ     'A'

     C     DDPSTM        IFNE      '00'
     C     DDPSTM        ANDNE     '  '
     C     DDRSTM        ORNE      '00'
     C     DDRSTM        ANDNE     '  '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      Ix = Idx
     C                   MOVEL     'DDNCCYB'     FldNameArr(Ix)
     C                   MOVEL     'LEV0175'     MsgIdArr(Ix)
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDRSTA = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DftSettmts - Default Settlement Details                      *
      *               This subroutine was copied from SCRN@S in       *
      *               module LELERISIN                                *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR

      ** Determine parameters for settlement details input

     C                   EXSR      DETP@S

      ** Fill Our Pay branch and Our Receive branch if blank

     C     DDPSCY        IFEQ      *BLANKS                                                    244446
     C     DDRSCY        OREQ      *BLANKS                                                    244446
     C                   MOVEL     LCCY          ##PCCY                                       244446
     C                   MOVEL     LCCY          ##RCCY                                       244446
     C                   ENDIF                                                                244446
                                                                                              244446
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLRSTM        IFEQ      05
     C     KRLBR         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ENDIF
     C                   ENDIF

     C     LPTYP         IFEQ      67
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLPSTM        IFEQ      05
     C     KRLSB         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ENDIF
     C                   ENDIF

      ** If Rollover date is to be removed,
      ** or multi-currency details are to be removed
      ** settlement details must be removed also.

     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATR                         new RLDT
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'

      ** Remove Receive Settlements Intructions

     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     63
     C     LPTYP         ANDNE     65
     C                   Z-ADD     *ZERO         FLRSTM
     C                   MOVE      *BLANKS       FLRONS
     C                   MOVE      *BLANKS       FLREC
     C                   MOVEL     *BLANKS       FLROBR
     C                   MOVEL     *BLANKS       FLRSCY
      *                                                                                       CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   MOVE      *BLANKS       FLREXI                                       CLE031
     C                   ENDIF

      ** Remove Pay Settlements Intructions

     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     67
     C                   Z-ADD     *ZERO         FLPSTM
     C                   MOVE      *BLANKS       FLPONS
     C                   MOVE      *BLANKS       FLPAY
     C                   MOVEL     *BLANKS       FLPOBR
     C                   MOVEL     *BLANKS       FLCVMR
     C                   MOVEL     *BLANKS       FLPSCY
     C                   MOVEL     *BLANKS       FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   MOVE      *BLANKS       FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF

     C     ##PREC        IFEQ      'Y'
     C     ##PPAY        ANDEQ     'Y'
      ** action must be A when ccy details are to be removed to allow
      ** same Settlement Screen processing as if normal amendment
     C     WNCCY1        ANDNE     '*'
     C     WRLDT1        ANDNE     '*'
     C                   MOVE      'E'           WWACTN
     C                   ENDIF

      ** Rollover date or multi ccy details not removed
     C                   ELSE

     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVE      'N'           ##PREC
     C                   ENDIF
     C     LPTYP         IFEQ      67
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Set up other payment settlement details
      ** For parts sold, pay out in old ccy, receive in new ccy
      ** For the rest, receive in old ccy, pay out in new ccy

     C     WPSET         IFEQ      'Y'

     C     DDNCCYB       IFNE      *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      DDNCCYB       WNCCY             3
     C                   ELSE
     C                   MOVE      DDNCCY        WNCCY
     C                   ENDIF

     C     WSOLD         IFEQ      'Y'
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY

     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF

     C                   ELSE
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##PCCY
     C                   MOVE      WNCCY         ##RCCY

     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
     C                   ENDIF

      ** Set up date of receipt and payment

     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C     CLRLDT        IFEQ      *ZEROS                                       new RLDT
     C                   Z-ADD     LRLDT         ##DATP                         current RLDT
     C                   Z-ADD     LRLDT         ##DATR                         current RLDT
     C                   ENDIF
     C     WRLDT1        IFNE      '*'
     C     DDRLDTB       ANDNE     *BLANKS
     C     DDRLDT        ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** If Payment or Receipt instructions already present (On invalid
      ** deal settlement instructions file) then bypass defaulting
      ** (default if both are blanks)

     C     ##PAYS        IFEQ      *BLANKS
     C     ##RECS        ANDEQ     *BLANKS

      ** Defaults settlement details for multi-ccy rollover

     C     FLPSTM        IFEQ      *ZERO
     C     FLRSTM        ANDEQ     *ZERO
     C     WPSET         ANDEQ     'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     DDACTN        ANDEQ     'A'

     C                   CALLB     'ZASETINDFT'

      ** INPUTS
      ** Calling program
     C                   PARM      'LEND'        ##CALP            4

      ** Payment currency
      ** Receive currency
     C                   PARM                    ##PCCY            3
     C                   PARM                    ##RCCY            3

      ** Customer shortname
      ** Transaction Type
      ** Federal Funds Ind.
     C                   PARM      DDCUST        ##CSNM           10
     C                   PARM      LLTYP         ##TTYP            2
     C                   PARM                    ##FFND            1

      ** Version of ISDA Rules govern
      ** Type of ISDA agreement
      ** Date of ISDA Agreement
      ** Version of ISDA Agreement
      ** Version of ISDA Agreement century
     C                   PARM                    BQISDA            4
     C                   PARM                    BQAGTY            6
     C                   PARM                    BQAGDT            6
     C                   PARM                    BQAGVV            2
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095

      ** OUTPUTS
      ** Payment instructions
      ** Receive instructions
      ** FRA/IRS instructions
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF

     C                   ENDIF

     C                   ENDIF

      ** If Payment or Receipt instructions already present (on invalid
      ** deal settlement instructions file) then bypass defaulting
      ** (default if both are blanks)

     C     ##PAYS        IFEQ      *blank
     C     ##RECS        ANDEQ     *blank
     C     WNCCY1        OREQ      '*'
     C     WRLDT1        OREQ      '*'

      ** Convert Settlement details from file to screen format

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
     C                   PARM                    ##RCCY                                      CSF011A
     C                   PARM                    ##PCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETP@S - Routine to apply default settlement instructions    *
      *           if none have been supplied                          *
      *           This subroutine was copied from LELERISIN           *
      *                                                               *
      *****************************************************************
     C     DETP@S        BEGSR

     C                   MOVE      DDACTN        WWACTN            1

     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'
     C     CLE030        ANDEQ     'Y'
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ELSE
     C     WRLDT1        IFEQ      '*'
     C     DDRLDTB       OREQ      *BLANKS
     C     DDRLDT        ANDEQ     *BLANKS
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY

      ** Discounted loans and parts purchased need receive settlements
      ** only, discounted parts sold needs pay settlements

     C                   ELSE
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ENDIF
     C     LPTYP         IFEQ      67
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      **  Set up date of receipt for amend.
      **  and date of payment

     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     CLRLDT        ##DATR                         new RLDT
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT
     C                   ENDIF

      ** Allow rec/pay settlement details for multi-ccy rollover

     C     MULTIC        IFEQ      *ON
     C     DDNCCY        ANDNE     *BLANKS
     C     MULTIC        OREQ      *ON
     C     DDNCCYB       ANDNE     *BLANKS
     C                   MOVE      'Y'           WPSET             1
     C                   MOVE      'Y'           DDWPSET
     C     DDACTN        IFEQ      'A'
     C     WRLDT1        ANDNE     '*'
     C                   Z-ADD     CLRLDT        ##DATP                         new RLDT

      ** When deleting just the multi-ccy details, for discounted loans
      ** still allow receive settlement input, for others protect both
      ** pay and receive settlements

     C     WNCCY1        IFEQ      '*'
     C     LPTYP         IFNE      63
     C     LPTYP         ANDNE     65
     C     LPTYP         ANDNE     67
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** If Payment or Receipt instructions already present
      ** THEN bypass defaulting

     C     ##PAYS        IFNE      *Blank
     C     ##RECS        ORNE      *Blank
     C                   GOTO      EDETP@S
     C                   END

      ** Get existing details from CLOANCK

     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'
     C     CLE030        ANDEQ     'Y'

     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
     C                   MOVEL     KRRST         FLRSTM
     C                   MOVEL     KRRON         FLRONS
     C                   MOVEL     CUKREC        FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF

     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      67
     C                   MOVEL     KRRST         FLPSTM
     C                   MOVEL     KRRON         FLPONS
     C                   MOVEL     CUKPAY        FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF

     C                   ENDIF

      ** Get receipt settlement from CLOANCK if not blank
      ** Else, get details from CLOANCL
      ** If all details in first screen has been '*'ed
      ** settlement details would be blanked out.

     C     DDACTN        IFEQ      'A'
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65

     C     KRRST         IFNE      *ZERO

      ** Set up Receive Instructions from CLOANCK (CrLnFilFmtCK)

     C                   MOVEL     KRRST         FLRSTM
     C                   MOVEL     KRRON         FLRONS
     C                   MOVEL     CUKREC        FLREC
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031

     C                   ELSE

      ** Set up Receive Instructions from CLOANCL (CrLnFilFmtCL)

     C                   MOVEL     LRSTM         FLRSTM
     C                   MOVEL     LRONS         FLRONS
     C                   MOVEL     CULREC        FLREC
     C                   MOVEL     LOMDB         FLROBR
     C                   MOVEL     LSCCY         FLRSCY
      *                                                                                       CLE031
     C                   Z-ADD     LREXR         FLREXR                                       CLE031
     C                   MOVE      LREXI         FLREXI                                       CLE031
     C                   MOVE      LSCCY         FLRSCY                                       CLE031
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** For multi-currency rollover, also allow for pay settle input
      ** Default coming from CLOANCK or CLOANCL

     C     DDACTN        IFEQ      'A'
     C     WPSET         ANDEQ     'Y'
     C     DDACTN        OREQ      'A'
     C     LPTYP         ANDEQ     67

     C     KRPST         IFNE      *ZERO

      ** Set up Pay Instructions from CLOANCK (CrLnFilFmtCK)

     C                   MOVEL     KRRST         FLPSTM
     C                   MOVEL     KRRON         FLPONS
     C                   MOVEL     CUKPAY        FLPAY
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031

     C                   ELSE

      ** Set up Pay Instructions from CLOANCL (CrLnFilFmtCL)

     C                   MOVEL     LPSTM         FLPSTM
     C                   MOVEL     LPONS         FLPONS
     C                   MOVEL     CULPAY        FLPAY
     C                   MOVEL     LOMDB         FLPOBR
     C                   MOVEL     LCVMR         FLCVMR
     C                   MOVEL     LSCCY         FLPSCY
     C                   MOVEL     LICCY         FLIC72
      *                                                                                       CLE031
     C                   Z-ADD     LREXR         FLPEXR                                       CLE031
     C                   MOVE      LREXI         FLPEXI                                       CLE031
     C                   MOVE      LSCCY         FLPSCY                                       CLE031
     C                   ENDIF

     C                   ENDIF

     C     EDETP@S       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSt - Routine to validate the settlemnt instructions  *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR

     C                   RESET                   ReturnCode

      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDRSTA = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      *                                                                                       CLE168
      ** Get Facility Customer, Facility Type, Facility Sequence                              CLE168
      *                                                                                       CLE168
      *                                                                                       CLE168
     C                   IF        DDLNRF <> *BLANKS AND CLE168 = 'Y'                         CLE168
     C     *LOCK         IN        LEFCLY                                                     CLE168
     C     DDLNRF        CHAIN     CLOAN                              89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      KFCUN = LO_FCUS                                            CLE168
     C                   MOVE      LO_FTYP       KFTYP                                        CLE168
     C                   MOVE      LO_FSEQ       KFSEQ                                        CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C     LEFCLT1       CHAIN     LEFCLTD0                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      A_XBKPT = C_FCBKPT                                         CLE168
     C                   ENDIF                                                                CLE168
     C                   EVAL      A_XCNUM = KFCUN                                            CLE168
     C                   EVAL      A_XFACT = KFTYP                                            CLE168
     C                   EVAL      A_XFCNO = KFSEQ                                            CLE168
     C                   OUT       LEFCLY                                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C                   CALLB     'ZASETINVAL'
      ** Return Code
     C                   PARM                    ReturnCode

      ** Following parameters are output to called module
      ** Calling function type
     C**********         PARM      'LEND'        ##CALP            4                        AR863960
     C                   PARM      'LERI'        ##CALP                                     AR863960

      ** Transaction Fields
      ** Payment currency (or Loan currency if only one currency on Loan)
      ** Receive currency (or Loan currency if only one currency on Loan)
     C                   PARM                    ##PCCY            3
     C                   PARM                    ##RCCY            3

      ** Customer (shortname or number)
      ** Loan type
     C                   PARM      DDCUST        ##CSNM           10
     C                   PARM      LLTYP         ##TTYP            2

      ** Federal Funds Ind.
      ** Booking Branch
     C                   PARM                    ##FFND            1
     C                   PARM                    ##BRCA            3

      ** Receipt Date
      ** Payment Date
     C                   PARM                    ##DATR            5 0
     C                   PARM                    ##DATP            5 0

      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS

      ** Action Code
     C                   PARM      DDACTN        ##ACTN            1

      ** Protect Payment Field
      ** Protect Receipt Field
     C                   PARM                    ##PPAY            1
     C                   PARM                    ##PREC            1

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
      ** Receive Instruction OK flag
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKPayInsDS
     C                   PARM                    OKRecInsDS
     C                   PARM                    OKFRAInsDS

      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF

      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1

      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3

      ** UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS

     C                   MOVEL     FLPSTM        K_CLRPST
     C                   MOVEL     FLPONS        K_CLRPON
     C                   MOVEL     FLPAY         CKPAY
     C                   MOVEL     FLPOBR        K_CLRLSB
     C                   MOVEL     FLCVMR        K_CLRCVM
     C                   MOVEL     FLPSCY        K_CLRPSC
     C                   MOVEL     FLIC72        K_CLRICY

      ** UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS

     C                   MOVEL     FLRSTM        K_CLRRST
     C                   MOVEL     FLRONS        K_CLRRON
     C                   MOVEL     FLREC         CKREC
     C                   MOVEL     FLROBR        K_CLRLBR
     C                   MOVEL     FLRSCY        K_CLRRSC
      *                                                                                       CLE031
     C                   Z-ADD     FLREXR        K_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        K_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        K_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        K_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        K_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        K_CLRPSC                                     CLE031

      ** Move work fields

     C                   Eval      DDPREC = ##PREC
     C                   Eval      DDPPAY = ##PPAY
      *                                                                                     MD039547
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM      'LERI'        ##CALP                                     MD039547
     C                   PARM                    ##PCCY                                     MD039547
     C                   PARM                    ##RCCY                                     MD039547
     C                   PARM      DDCUST        ##CSNM                                     MD039547
     C                   PARM                    ##BRCA                                     MD039547
     C                   PARM                    ##PAYS                                     MD039547
     C                   PARM                    ##RECS                                     MD039547
     C                   PARM      DDACTN        ##ACTN                                     MD039547
     C                   PARM                    ##PPAY                                     MD039547
     C                   PARM                    ##PREC                                     MD039547
     C                   PARM                    OKPayInsDS                                 MD039547
     C                   PARM                    OKRecInsDS                                 MD039547
     C                   PARM                    FldNameArr                                 MD039547
     C                   PARM                    MsgIDArr                                   MD039547
     C                   PARM                    Idx                                        MD039547
     C                   PARM                    WFldNamArr                                 MD039547
     C                   PARM                    WMsgIdArr                                  MD039547
     C                   PARM                    WMsgDtaArr                                 MD039547
     C                   PARM                    WIdx                                       MD039547


     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCUST                                        CSF011A
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
      *                                                               *
      *  WriteToDB - Write to database file                           *
      *                                                               *
      *****************************************************************
     C     WriteToDB     BEGSR

     C                   EXSR      SETUPVALID

     C                   EXSR      UpdateDB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SETUPVALID - Set up additional fields that are needed on the *
      *               Valid file record.                              *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR

      ** For Inserts and Amends, put the Settlement Instructions (input or
      **   defaulted) into the Valid file record.
      ** Two DSs (one Pay, one Receive) contain the Settlement Instructions
      **   in contiguous areas, which must be placed into the correct parts
      **   of the Valid file record

     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C                   MOVEL     FLPSTM        K_CLRPST
     C                   MOVEL     FLPONS        K_CLRPON
     C                   MOVEL     FLPAY         CKPAY
     C                   MOVE      FLPOBR        K_CLRLSB
     C                   MOVE      FLCVMR        K_CLRCVM
     C                   MOVE      FLPSCY        K_CLRPSC
     C                   MOVE      FLIC72        K_CLRICY

     C                   MOVEL     FLRSTM        K_CLRRST
     C                   MOVEL     FLRONS        K_CLRRON
     C                   MOVEL     FLREC         CKREC
     C                   MOVE      FLROBR        K_CLRLBR
     C                   MOVE      FLRSCY        K_CLRRSC
      *                                                                                       CLE031
     C                   Z-ADD     FLREXR        K_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        K_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        K_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        K_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        K_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        K_CLRPSC                                     CLE031
     C                   ENDIF

      ** For Delete & Authorise, put the complete (pre-existing) loan
      **   into the Valid file record

     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVEL     CrLnFilFmtCL  ValidLoanL
     C                   MOVEL     CrLnFilFmtCK  ValidLoanK
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

      ** Include Header fields that need to be o/p to the Valid file

     C                   EVAL      CLFRNT = APFOTranID
     C                   EVAL      CLREPA = APRprLocn

     C                   EVAL      K_CLRECI = CLRECI
     C                   EVAL      K_CLLNRF = CLLNRF
     C                   EVAL      K_CLORED = CLORED
     C                   EVAL      K_CLLCD  = CLLCD
     C                   EVAL      K_CLTNLU = CLTNLU
     C                   EVAL      K_CLAFRT = CLAFRT
     C                   EVAL      K_CLFRNT = APFOTranID
     C                   EVAL      K_CLREPA = APRprLocn

      ** Set Auto Authorise flag for transactions from Interface                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      CLAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATEDB - Update Database                                   *
      *                                                               *
      *****************************************************************
     C     UPDATEDB      BEGSR

      ** Update valid Loan: Loan Number

     C                   MOVEL     DDLNRF        CLLNRF

      ** Update valid Loan: Last change type

     C                   EVAL      CLCHTP = 'A'
     C                   EVAL      K_CLCHTP = DDACTN

      ** Loans Update

     C                   CALLB     'LELERIUPD'

      ** INPUTS
      ** Return code
      ** Action code
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    DDACTN

      ** Valid Loan record CL and CK
     C                   PARM                    ValidLOANL
     C                   PARM                    ValidLOANK

      ** Features
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005

      ** Called from CTU
     C                   PARM      *BLANKS       @@CTU             1

      ** If there were any errors in the Update functions, rollback any
      ** updates and end this program. Otherwise, Commit the updates

     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc

     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'
     C     WCMT01        ANDEQ     'N'
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR

     C                   ELSE

     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMT01        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF

     C                   ENDIF

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     ReturnCode    IFEQ      '*RECUPD'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      Ix = Idx
     C                   MOVEL     '*ANY'        FldNameArr(Ix)
     C                   MOVEL     'LEV9009'     MsgIdArr(Ix)
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  @CHKLOAN - Check if Extended Settlements, Funding details    *
      *             and Mutli ccy Rollovers are required.             *
      *                                                               *
      *****************************************************************
     C     @CHKLOAN      BEGSR

     C                   MOVE      'N'           @FUNDING
     C                   MOVE      'N'           @MULTI
     C                   MOVE      'N'           WSett
     C                   MOVE      'N'           WPSet
     C                   MOVE      'N'           @FCXRATE          1                         BUG2579

      **  Enable display of Funding Details if Analytical Accounting
      **  module is switched on and loan is directly funded.
      **  or enable display of Funding Details if Revenue Analysis
      **  is switched on.

     C     BGN0ST        IFEQ      'Y'
     C     LFPRC         ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'

     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C     LPTYP         OREQ      61
     C     LPTYP         OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @FUNDING
     C                   ENDIF

     C                   ENDIF

      ** Enable Extended Settlement Details for Discount Loan.
      ** and discounted parts purchased or sold

     C                   MOVE      *BLANKS       WDisc             1
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WDisc
     C                   ENDIF

     C                   MOVE      *BLANKS       WSOLD             1
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF

      **  Get facility details.

     C     WFCLT         CHAIN     LEFCLTL0                           85

      **  Enable New currency, New currency amount, Exchange rate,
      **  Exchange rate indicator, Next loan currency repayment
      **  amount will be displayed if Customer Lending Enhancement
      **  Syndications feature is switched on and if it is a
      **  Multi-currency rollover or if EMU Lending Multi currency
      **  rollover feauture is switched on and if loan currency is
      **  an 'In' currency

     C     CEU020        IFEQ      'Y'
     C                   MOVE      LCCY          @CURR             3
     C                   Z-ADD     61            DBASE
     C                   EXSR      SRCurrDet
     C                   ENDIF

     C     LMCRA         IFEQ      'Y'
     C     CEU020        IFEQ      'Y'
     C                   MOVE      A6INCY        WINCY             1
     C                   Z-ADD     A6TPSD        WTPSD             5 0
     C                   Z-ADD     A6SPRT        WASPRT           13 8
     C                   ENDIF
     C                   MOVE      'Y'           @MULTI

      **  Determine if multi-currency rollover
      **  can be processed.
      **  If Multi Ccy Rollovers, enable the Settlements Screen
     C                   EXSR      SRMCCY

     C     MULTIC        IFEQ      *ON
     C                   MOVEA     F_ALCY        ACCYA
     C     DDACTN        IFEQ      'A'
     C     KNCCY         ORNE      *BLANKS
     C     CEU020        IFEQ      'Y'
     C     KNCCY         ORNE      *BLANKS
     C                   MOVE      'Y'           WSett
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
                                                                                              BUG827
      ** Determine if New Forward Yield is required                                           BUG827
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C     LPTYP         ANDNE     70                                                         BUG827
     C     LPTYP         ANDNE     71                                                         BUG827
     C     LPTYP         ANDNE     72                                                         BUG827
     C                   MOVE      'Y'           @FYIELD           1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           @FYIELD                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if New Facility Exchange Rate is required                                 BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     F_MCCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'Y'           @FCXRATE                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           @FCXRATE                                    BUG2579
     C                   ENDIF                                                               BUG2579

      ** Determine Loan Category

     C                   MOVE      'OTHR'        DDLNCAT
     C     LPTYP         IFEQ      61
     C     LPTYP         OREQ      68
     C     LPTYP         OREQ      69
     C                   MOVE      'CALL'        DDLNCAT
     C                   ENDIF

     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C                   MOVE      'TERM'        DDLNCAT
     C                   ENDIF

     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'DISC'        DDLNCAT
     C                   ENDIF

     C     LPTYP         IFEQ      70
     C                   MOVE      'GUAR'        DDLNCAT
     C                   ENDIF

     C     LPTYP         IFEQ      71
     C     LPTYP         OREQ      72
     C                   MOVE      'RISK'        DDLNCAT
     C                   ENDIF

      ** Move to LELERI3PD work fields

     C                   MOVE      @FUNDING      DDFUNDD
     C                   MOVE      @MULTI        DDMULTI
     C                   MOVE      WSett         DDWPSET
     C                   MOVE      @FYIELD       DDWFYLD           1                          BUG827
     C                   MOVE      @FCXRATE      DDFCXRT                                     BUG2579

      ** Set screen OK fields to 'Y' if action code and loan number is valid

     C     DDActnOK      IFEQ      'Y'
     C     DDLnrfOK      ANDEQ     'Y'
     C                   MOVE      'Y'           DDScrOK
     C                   ELSE
     C                   MOVE      'N'           DDScrOK
     C                   ENDIF

      ** Move Payment/Receive Protect fields to LELERI3PD

     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      ##PREC        DDPREC
     C                   MOVE      ##PPAY        DDPPAY
                                                                                             BUG3405
      ** Move currency fields, these are used in LERI.xml API.                               BUG3405
                                                                                             BUG3405
     C                   MOVEL     DDCURR        DDCCYO                                      BUG3405
     C     DDNCCY        IFNE      *BLANKS                                                   BUG3405
     C                   MOVEL     DDNCCY        DDCCYO                                      BUG3405
     C                   ENDIF                                                               BUG3405
                                                                                             BUG3405
     C**********         MOVEL     DDCCYO        DDCCYN                              BUG3405 BUG3405
     C*****DDNCCYB       IFNE      *BLANKS                                           BUG3405 BUG3405
     C**********         MOVEL     DDNCCYB       DDCCYN                              BUG3405 BUG3405
     C**********         ENDIF                                                       BUG3405 BUG3405

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMCCY - Check if Mutli-currency rollover is allowed.        *
      *                                                               *
      *****************************************************************
     C     SRMCCY        BEGSR

     C                   MOVE      *OFF          MULTIC            1
     C                   MOVE      'N'           @WERLN

      **  Multi-currency rollover processing are allowed
      **  if there are no past due payments outstanding.
      **  and no future-dated loan amendments (except for repay sched)

      **  Access loan amendments file.

     C**********         Z-ADD     LLNRF         ALNRF                                        CLE148
     C                   MOVEL     LLNRF         ALNRF                                        CLE148
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0

      **  Check if past due exists.

     C                   MOVE      *ON           WLOGIC            1
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     LLNRF         ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO

      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed

     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     LLNRF
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C     CLE014        ANDEQ     'N'
     C                   MOVE      *OFF          WLOGIC

      ** If CEU020 is installed, future dated loan amendments will be
      ** allowed if amendment currency is equal to Euro ccy

     C     CEU020        IFEQ      'Y'
     C     A_CCY         ANDEQ     BKEURO
     C                   MOVE      *ON           WLOGIC
     C                   ENDIF

     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
     C                   ENDIF

      ** If parts sold, check if original loan has no past due
      ** payments or future dated loan amendments except for 'RE'.

     C**********         Z-ADD     LLNRF         WWLNRF            6 0                        CLE148
     C                   MOVEL     LLNRF         WWLNRF            6                          CLE148

     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C     LPTYP         OREQ      69
     C     LPTYP         OREQ      72

     C                   MOVE      LOLNO         ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85

     C     *IN85         DOWEQ     '0'
     C*****LOLNO         ANDEQ     A_LNRF                                                     CSD027
     C     ALNRF         ANDEQ     A_LNRF                                                     CSD027
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO

      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed

     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85

     C     *IN85         DOWEQ     '0'
     C*****A_LNRF        ANDEQ     LOLNO                                                      CSD027
     C     A_LNRF        ANDEQ     ALNRF                                                      CSD027
     C     @WERLN        ANDEQ     'N'

     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF

     C                   READ      LELOAML0                               85
     C                   ENDDO

     C                   ENDIF
     C                   MOVE      LOLNO         WOLNO

      ** Multi-ccy rollover allowed indicator of original loan must
      ** be 'Y'.

     C                   MOVE      'A'           WRCDT
     C                   MOVE      LOLNO         WLNRF
     C     WLOAN         CHAIN     CLOAN                              85
     C     *IN85         IFEQ      *OFF
     C     LO_MCRA       ANDEQ     'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      LO_LNRF       @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF

     C                   ELSE
     C**********         MOVE      LLNRF         WOLNO             6 0                        CLE148
     C                   MOVE      LLNRF         WOLNO             6                          CLE148
     C                   ENDIF

      ** Check if all the related parts sold has no past due payments
      ** or future dated loan amendments except for 'RE'.

     C*****WOLNO         SETLL     PSOLDFF                                                    CSD027
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C**********         EVAL      OLNONum = WOLNO                                     CSD027 CLE148
     C*****OLNOALpha     SETLL     PSOLDFF                                             CSD027 CLE148
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         SETLL     PSOLDFF                                                    CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148

     C     *IN85         DOWEQ     '0'
     C     @WERLN        ANDEQ     'N'

     C     P_LNRF        IFNE      WWLNRF
     C                   MOVE      P_LNRF        ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85

     C     *IN85         DOWEQ     '0'
     C     P_LNRF        ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN            1
     C                   MOVE      A_LNRF        @WLNNO            6
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO

      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed

     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85

     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     P_LNRF
     C     @WERLN        ANDEQ     'N'
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

      ** Multi-ccy rollover allowed indicator must be 'Y' for all of
      ** the related loan

     C     P_MCRA        IFEQ      'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      P_LNRF        @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
     C                   ENDDO

     C                   MOVE      WLOGIC        MULTIC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurrDet - Access Currency Details                          *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY

      ** DATABASE ERROR

     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     910           DBASE
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETCYCLE - Reset error information that is gradually       *
      *               updated during each run of this program         *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx


     C                   RESET                   FldNoArr

     C                   CLEAR                   CrRoScnFmt

     C                   MOVE      *ALL'Y'       LERI_OK

     C                   CLEAR                   ValidLoanL
     C                   CLEAR                   ValidLoanK

     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system
     C                   PARM                    HeadIn

      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003

      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    @ACTRV            1                        AR702532

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                AR820267

      ** Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LELERIM01

      ** Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'

      ** Key list for LELOAML0

     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0

      ** Key list for CLOAN

     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1

      ** Key list for LEFCLTL0

     C     WFCLT         KLIST
     C                   KFLD                    LFCUS
     C                   KFLD                    LFTYP
     C                   KFLD                    LFSEQ

      ** Access Bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      **  Retrieve general ledger details

     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     903           DBASE                          * DBERR 903*
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Determine if Lending Enhancements for BHF-London is active

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C                   ENDIF

      ** Check if EMU Lending Multi Currency Rollover - CEU020
      ** feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU020'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU020            1
     C                   ELSE
     C                   MOVE      'N'           CEU020
     C                   END

      ** Check if Customer Lending Enhancements - Authorisation
      ** feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C                   MOVE      'N'           CLE002
     C                   END

      ** Check if Customer Lending Enhancements - Backvaluations
      ** feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE003            1
     C                   ELSE
     C                   MOVE      'N'           CLE003
     C                   END

      ** Check if Customer Lending Enhancements - Others
      ** feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   END

      ** Check if BLI Lending Enhancements feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01465            1
     C                   ELSE
     C                   MOVE      'N'           S01465
     C                   END

      ** Check if Rollover rate fixing day enhancement - CLE011
      ** feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE011            1
     C                   ELSE
     C                   MOVE      'N'           CLE011
     C                   END

      ** Check if Release Authorisation enhancment feature is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE030'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE030            1
     C                   ELSE
     C                   MOVE      'N'           CLE030
     C                   END

      ** Access SAR details file to determine if CDE002 is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   Move      'N'           CDE002            1
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CDE002 = 'Y'
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   MOVE      'N'           CSC011            1
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE

      ** Database error

     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 911
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

      ** Determine if CSC022 is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANK
     C                   EVAL      CSC022 ='Y'
     C                   EVAL      WCMT01 ='N'

     C                   IN        SCCMTJOB

      ** Move data area to commitment array
     C                   IF        COMITNOM > 0
     C                   MOVEA     COMITJOB      ARRJBNAM

      ** Check if PSJOBNAME exist.
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17
     C                   IF        *IN17 = *ON
     C                   EVAL      WCMT01= 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   EVAL      CSC022 ='N'
     C                   EVAL      WCMT01 ='N'

      ** Record not found
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LELERIVU'
     C                   EVAL      DBKEY = 'CSC022'
     C                   EVAL      DBFILE ='SCSARDPD'
     C                   EVAL      DBASE  = 912
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if CLE023 is installed                                                    BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       @RTCD                                       BUG2579
     C                   PARM      '*VERIFY '    @OPTN                                       BUG2579
     C                   PARM      'CLE023'      @SARD                                       BUG2579
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2579
                                                                                             BUG2579
     C     @RTCD         IFEQ      *BLANKS                                                   BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ENDIF                                                               BUG2579
                                                                                              CLE106
      ** Determine if CLE106 is installed                                                     CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY '    @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *Blanks                                                    CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
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

     C                   EVAL      @RTCD = *BLANKS
                                                                                             BUG8145
      ** Access MIDAS modules details via access program                                     BUG8145
      ** (database error handling done in access program)                                    BUG8145
     C                   CALLB     'AOMMODR0'                                                BUG8145
     C                   PARM      '*DBERR '     @RTCD             7                         BUG8145
     C                   PARM      '*FIRST '     @OPTN             7                         BUG8145
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG8145
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'LELERIVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 1                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CLE168
      ** Access SAR details file                                                              CLE168
      *                                                                                       CLE168
     C                   CALLB     'AOSARDR0'                                                 CLE168
     C                   PARM      *BLANKS       @RTCD                                        CLE168
     C                   PARM      '*VERIFY'     @OPTN                                        CLE168
     C                   PARM      'CLE168'      @SARD                                        CLE168
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE168
                                                                                              CLE168
     C                   IF        @RTCD = *BLANK                                             CLE168
     C                   MOVEL     'Y'           CLE168            1                          CLE168
     C                   ELSE                                                                 CLE168
     C                   MOVEL     'N'           CLE168                                       CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C     LEFCLT1       KLIST                                                                CLE168
     C                   KFLD                    KFCUN             6                          CLE168
     C                   KFLD                    KFTYP             3                          CLE168
     C                   KFLD                    KFSEQ             2                          CLE168
      *                                                                                       CLE168
     C                   ENDSR
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
