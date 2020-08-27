     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignments Retrieve a record')               *
      *****************************************************************
      *                                                               *
      *  Midas - Lending module                                       *
      *                                                               *
      *  LEASGNR   - LE Assignments retrieve a record                 *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084  *CREATE    Date 20Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **********************************************************************
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
 
     D CrLnScnFmt    E DS                  EXTNAME(LEASGNPD)
      * Deal in screen format
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D CrLnFilFmt    E DS                  EXTNAME(LEPARTPD)
      ** Current Assignment Details in file format
     D  ASGNRecIns            72    140
     D  ASGNPayIns           141    699
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
      * Receive settlement instructions in file format
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
      * Pay settlement instructions in file format
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *** External DS for customer details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *** External DS for bank details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Second DS for access programs, short data structure
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
 
     D Trnn_In         DS
      ** DS of all key fields read from LEPARTL2
     D  DDBRCA_IN              1      3
     D**DDCNUM_IN              4      9  0                                                    CSD027
     D  DDCNUM_IN              4      9A                                                      CSD027
     D  DDFACT_IN             10     12  0
     D  DDFCNO_IN             13     14  0
     D**DDMNUM_IN             15     20  0                                                    CSD027
     D**DDINUM_IN             21     26  0                                                    CSD027
     D  DDMNUM_IN             15     20A                                                      CSD027
     D  DDINUM_IN             21     26A                                                      CSD027
     D  DDVDTC_IN             27     29P 0
 
      ** Data structure for additional Assignment Screen details
     D ASGNScnFmtAdd   DS            17
     D  S#FAMT                 1     14
     D  S#FCCY                15     17
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
      /EJECT
      **********************************************************************
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   CrLnFilFmt
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
     C                   EXSR      LEASGNRED
      *
      * Use newly retrieved next or last record for the rest of the processing.
     C                   MOVEL     @TRRED        Trnn_In
      * Six numeric customer number to 10 A screen field.
     C                   MOVEL     DDMNUM_IN     DDMNUM
     C                   MOVEL     DDINUM_IN     DDINUM
      *
     C                   MOVEL     DDCNUM_IN     DDCNUM
     C                   MOVEL     DDFACT_IN     DDFACT
     C                   MOVEL     DDFCNO_IN     DDFCNO
     C                   MOVEL     DDBRCA_IN     DDBRCA
      *
     C                   Z-ADD     DDVDTC_IN     VDTCNUM
     C                   MOVEL     VDTCNUM       DDVDTC
      *
     C                   ELSE
      *
     C                   MOVEL     DDCNUM        DDCNUM_IN
     C                   MOVEL     DDFACT        DDFACT_IN
     C                   MOVEL     DDFCNO        DDFCNO_IN
      *
      ** In case 10A is a shortname, convert back to a 6,0 customer number.
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDMNUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#ASTSok
     C                   ADD       1             Ix
     C                   MOVEL     'DDMNUM '     FldNameArr(Ix)
     C                   MOVEL     'LEP0032'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     BBCUST        DDMNUM_IN
     C                   ENDIF
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDINUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           S#ASFSok
     C                   ADD       1             Ix
     C                   MOVEL     'DDINUM '     FldNameArr(Ix)
     C                   MOVEL     'LEP0032'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
     C                   MOVEL     BBCUST        DDINUM_IN
     C                   ENDIF
      *
     C                   MOVEL     DDBRCA        DDBRCA_IN
     C                   MOVE      DDVDTC        VDTCNUM           5 0
     C                   Z-ADD     VDTCNUM       DDVDTC_IN
      *
     C                   MOVEL     Trnn_In       @TRRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @TRRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     DDACTN        S#ACTN
     C                   MOVEL     DDMNUM        S#ASTS
     C                   MOVEL     DDINUM        S#ASFS
     C                   MOVEL     DDCNUM        S#PMFC
     C                   MOVEL     DDFACT        S#PMFT
     C                   MOVEL     DDFCNO        S#PMFN
     C                   MOVEL     DDBRCA        S#BRCA
     C                   MOVEL     DDBRCA        FcbrBranch
     C                   MOVEL     DDVDTC        S#VDTC
      *
      * In_VDTC is in Midas day number format.
     C                   CallB     'ZDATE1'
     C                   Parm      DDVDTC        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-Add     DaynoOut      In_VDTC
 
     C                   EXSR      LEASGNRTV
      *
      * Access primary facility
     C     Ix            IFEQ      0
     C                   EXSR      ACSPFA
     C                   ENDIF
      *
      * Convert to screeen format
     C     Ix            IFEQ      0
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CCY           @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     CCY           DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      CCY           FccyFCCY
     C                   Z-ADD     A6NBDP        FccyNBDP
      *
     C                   EXSR      LEASGNCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCNUM     ' FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = CrLnScnFmt
     C                                           + ASGNScnFmtAdd
     C                                           + ##RECS  + ##PAYS
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
     C                   PARM                    DDMNUM           10
     C                   PARM                    DDINUM           10
     C                   PARM                    DDVDTC            6
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
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LEASGNM01
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
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
                                                                                              CLE031
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEASGNRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'LEASGNRED'
      *
      * Input parameters :
      * Return code
     C                   PARM                    RetCodeIn
      * Action code
     C                   PARM                    DDACTN            1
      * Transaction reference
     C                   PARM                    DDBRCA
     C                   PARM                    DDCNUM
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDMNUM
     C                   PARM                    DDINUM
     C                   PARM                    DDVDTC
      * Read forwards
     C                   PARM                    @RDFWD            1
      * Read backwards
     C                   PARM                    @RDBCK            1
      * Output Parameters :
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
      * Transaction read
     C                   PARM      *BLANK        @TRRED           29
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEASGNRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'LEASGNRTV'
      *
      * INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1
 
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#ASTS           10
     C                   PARM                    S#ASFS           10
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
 
      * Prime facility branch
     C                   PARM                    FcbrBranch        3
 
      * Value date of change
     C                   PARM                    In_VDTC           5 0
      *
      * OUTPUTS
      * Assignment Details in file format
     C                   PARM                    CrLnFilFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#ASTSok          1
     C                   PARM                    S#ASFSok          1
 
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
 
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     LEASGNCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'LEASGNCVT'
      *
      * INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Assignment details in file format
     C                   PARM                    CrLnFilFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      * Assignment Details in screen format
     C                   PARM                    CrLnScnFmt
 
      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
 
      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up payment instructions from deal
     C                   MOVEL     ASGNPayIns    FLPAY
     C                   MOVEL     OMDB          FLPOBR
     C                   MOVEL     CVMR          FLCVMR
     C                   MOVEL     SCCY          FLPSCY
     C                   MOVEL     ICCY          FLIC72
      *
      * Set up receive instructions from deal
     C                   MOVEL     ASGNRecIns    FLREC
     C                   MOVEL     OSDB          FLROBR
     C                   MOVEL     SCCY          FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
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
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ACSPFA - Access Primary Facility                              *
      *                                                               *
      *****************************************************************
 
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002500'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
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
 
     C                   MOVE      FccyFCCY      S#FCCY
 
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2003
