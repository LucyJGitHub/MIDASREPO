     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant retrieve a record')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFPRTR - LE Funding participant retrieve a record           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084  *CREATE    Date 15Apr03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D FPRTScnFmt    E DS                  EXTNAME(LEFPRTPD)
      * Fundiing participant in screen format
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D FPRTFilFmt    E DS                  EXTNAME(LEVFCLMPD)
     D  FPREC                455    523
     D  FPPAY                524   1082
      ** Fundiing participant in file format
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
      * Receive settlement instructions in file format
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
      * Pay settlement instructions in file format
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Data structure for additional Funding Participant Screen details
     D FPRTScnFmtAdd   DS            76
     D  S#ANUM                 1      6
     D  S#CRNM                 7     26
     D  S#BRCA                27     29
     D  S#FAMT                30     43
     D  S#FCCY                44     46
     D  S#PRNM                47     66
     D  S#PRTN                67     76
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDPMFC_IN         6
     C                   PARM                    DDPMFT_IN         3
     C                   PARM                    DDPMFN_IN         2
     C                   PARM                    DDCNUM_IN        10
     C                   PARM                    DDFACT_IN         3
     C                   PARM                    DDFCNO_IN         2
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
     D/COPY WNCPYSRC,LEFPRTVM01
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD             7                          CLE031
     C                   PARM      '*VERIFY'     POPTN             7                          CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
      * Set action code to enquire, unless authorising
     C                   CLEAR                   FPRTFilFmt
 
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
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
     C                   EXSR      LEFPRTRED
     C                   ELSE
     C                   MOVEL     DDPMFC_IN     @PMFC
     C                   MOVEL     DDPMFT_IN     @PMFT
     C                   MOVEL     DDPMFN_IN     @PMFN
     C                   MOVEL     DDCNUM_IN     @CNUM
     C                   MOVEL     DDFACT_IN     @FACT
     C                   MOVEL     DDFCNO_IN     @FCNO
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Funding participant read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @PMFC <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @PMFC         DDPMFC
     C                   MOVEL     @PMFT         DDPMFT
     C                   MOVEL     @PMFN         DDPMFN
     C                   MOVEL     @CNUM         DDCNUM
     C                   MOVEL     @FACT         DDFACT
     C                   MOVEL     @FCNO         DDFCNO
     C                   EXSR      LEFPRTRTV
      *
      * Access primary facility
     C     Idx           IFEQ      0
     C                   EXSR      ACSPFA
     C                   ENDIF
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      LEFPRTCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'S#PMFC'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = FPRTScnFmt
     C                                           + FPRTScnFmtAdd
     C                                           + ##RECS  + ##PAYS
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     LEFPRTRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'LEFPRTRED'
      *
      * Inputs
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Funding participant reference:
     C                   PARM                    DDPMFC            6
     C                   PARM                    DDPMFT            3
     C                   PARM                    DDPMFN            2
     C                   PARM                    DDCNUM           10
      *
      * Front Office Transaction ID
     C                   PARM                    DDFRNT           20
      *
      * Read Forwards
     C                   PARM                    @RDFWD            1
      *
      * Read Backwards
     C                   PARM                    @RDBCK            1
      *
      * Outputs
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Funding participant read:
      * Customer, facility
     C                   PARM                    @PMFC             6
     C                   PARM                    @PMFT             3
     C                   PARM                    @PMFN             2
     C                   PARM                    @CNUM             6
     C                   PARM                    @FACT             3
     C                   PARM                    @FCNO             2
 
     C                   ENDSR
      **********************************************************************
     C     LEFPRTRTV     BEGSR
 
     C                   RESET                   RetCodeIn
      *
     C                   CALLB     'LEFPRTRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      * Action, Customer, Facility Type and Facility number
     C                   PARM                    DDACTN
     C                   PARM                    DDCNUM
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
 
      * Primary facility customer, type & number
     C                   PARM                    DDPMFC
     C                   PARM                    DDPMFT
     C                   PARM                    DDPMFN
 
      * Outputs
      *
      * Funding participant in file format
     C                   PARM                    FPRTFilFmt
 
      * Action, customer, facility type and facility number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
 
      * Customer number
     C                   PARM                    S#CNUM            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      **********************************************************************
     C     LEFPRTCVT     BEGSR
 
     C                   RESET                   RetCodeIn
      *
     C                   CALLB     'LEFPRTCVT'
      * Inputs
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Funding participant in file format
     C                   PARM                    FPRTFilFmt
      *
      * Output parameters
      *
      * Funding participant in screen format
     C                   PARM                    FPRTScnFmt
 
      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
 
      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up payment instructions from Funding participant
     C                   MOVEL     FPPAY         FLPAY
     C                   MOVEL     FPOSDB        FLPOBR
     C                   MOVEL     FPSCCY        FLPSCY
      *
      * Set up receive instructions from Funding participant
     C                   MOVEL     FPREC         FLREC
     C                   MOVEL     FPOSDB        FLROBR
     C                   MOVEL     FPSCCY        FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FPREXR        FLREXR                                       CLE031
     C                   Z-ADD     FPPEXR        FLPEXR                                       CLE031
     C                   MOVE      FPREXI        FLREXI                                       CLE031
     C                   MOVE      FPPEXI        FLPEXI                                       CLE031
     C                   MOVE      FPSCCY        FLRSCY                                       CLE031
     C                   MOVE      FPPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    ##PAYF
      *
      ** File receipt settlement instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS settlement instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        ##FRIS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Access Primary Facility                                       *
      *****************************************************************
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002510'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE
 
      * Primary facility customer, type & number
     C                   PARM                    DDPMFC
     C                   PARM                    DDPMFT
     C                   PARM                    DDPMFN
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      * Populate primary facility fields
 
     C                   MOVE      FcbrBranch    S#BRCA
     C                   MOVE      FccyFCCY      S#FCCY
 
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
