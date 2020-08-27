     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment control and update')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEASGNCTU - Assignment Control                               *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             the assignments within a syndicate.               *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Recompiled over changed LEVASGNPD file.             *
      *           Recompiled over changed LEASGNPD format.            *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FLEIASGNPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPILSETPD O  A E             DISK    INFSR(*pssr)
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
 
      ** Assignment Details in screen format
     D ASGN          E DS                  EXTNAME(LEASGNPD)
 
      ** Assignment Details OK indicator
     D ASGN_OK       E DS                  EXTNAME(LEEASGNPD)
 
 
      ** Assignment Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)
     D**LepartREC             72    140                                                       CGL029
     D  LepartREC1            72     73                                                       CGL029
     D  LepartREC2            86    140                                                       CGL029
     D**LepartPAY            141    699                                                       CGL029
     D  LepartPAY1           141    142                                                       CGL029
     D  LepartPAY2           155    699                                                       CGL029
     D  LepartpdEXT          725    827                                                       CGL029
 
      ** New Assignment Details in file format
     D LEVASGNPD     E DS                  EXTNAME(LEVASGNPD)
     D**V_REC                 72    140                                                       CGL029
     D  VLREC1                72     73                                                       CGL029
     D  VLREC2                86    140                                                       CGL029
     D**V_PAY                141    699                                                       CGL029
     D  VLPAY1               141    142                                                       CGL029
     D  VLPAY2               155    699                                                       CGL029
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D**FLREC                  1     69                                                       CGL029
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D**FLPAY                  1    559                                                       CGL029
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
 
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
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Current Assignment Details in screen format
     D C_ASGN        E DS                  EXTNAME(LEASGNPD)
     D                                     PREFIX(C_)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LER1MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LER2MFPD)
 
      /SPACE 5
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      * Access primary facility
 
     C                   MOVE      R1CNUM        S#PMFC
     C                   MOVE      R1FACT        S#PMFT
     C                   MOVE      R1FCNO        S#PMFN
 
     C                   EXSR      ACSPFA
 
      *  If error in access of primary facility, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      * Inserts
      * =======
 
     C     S#ACTN        WHENEQ    'I'
 
     C                   EXSR      DftSettmts
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
      *  Amends
      *  ======
 
     C     S#ACTN        WHENEQ    'A'
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      ASGN                                   99
     C     *in99         ifeq      *on
     C                   EXSR      TDtDtaSubs
     C                   endif
     C                   endif
     C                   EXSR      SetupAmend
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
     C                   EXSR      ValdateAmd
 
      *  Reversals
      *  =========
 
     C     S#ACTN        WHENEQ    'R'
 
     C**********         MOVEL     LepartREC     F_REC                                        CGL029
     C                   MOVEL     LepartREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LepartREC2    FLREC2                                       CGL029
     C**********         MOVEL     LepartPAY     F_PAY                                        CGL029
     C                   MOVEL     LepartPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LepartPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
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
 
     C                   MOVEL     R1RPLC        RPLOC             1
      *
      ** Assgnment details
      *
     C                   CLEAR                   ASGN
     C                   MOVE      R1ACTN        S#ACTN
      *
     C                   MOVEL     R1MNUM        S#ASTS
     C                   MOVEL     R1INUM        S#ASFS
      *
     C                   MOVEL     R1JDTE        S#ADTE
     C                   MOVE      R1JDTE        ##YEAR            2
     C                   MOVE      ##YEAR        S#ADTE
      *
     C                   MOVE      R1SHTP        S#SHTP
     C     R1SHTP        IFEQ      'P'
     C                   MOVE      R1SHPC        S#SHAR
     C                   ELSE
     C                   MOVE      R1SHAM        S#SHAR
     C                   ENDIF
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      R1RSTM        FLRSTM
     C                   MOVE      R1RONS        FLRONS
     C                   MOVE      R1RIBN        FLRIBN
     C                   MOVE      R1RIBA        FLRIBA
     C                   MOVE      R1ROBN        FLROBN
     C                   MOVE      R1ROCN        FLROCN
     C                   MOVEL     R1RONS        FLROBR
     C                   MOVE      R1SCCY        FLRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      R1PSTM        FLPSTM
     C                   MOVE      R1PONS        FLPONS
     C                   MOVE      R1PIBN        FLPIBN
     C                   MOVE      R1PIBA        FLPIBA
     C                   MOVE      R1POBN        FLPOBN
     C                   MOVE      R1POCN        FLPOCN
     C                   MOVE      R1CVMR        FLCVMR
     C                   MOVE      R1RCRN        FLRCRN
     C                   MOVE      R1RCRA        FLRCRA
     C                   MOVE      R1RVNO        FLRVNO
     C                   MOVE      R1AWBN        FLAWBN
     C                   MOVE      R1AWBA        FLAWBA
     C                   MOVE      R1BENN        FLBENN
     C                   MOVE      R1BENA        FLBENA
     C     35            SUBST     R1DTP1:1      FLDTP1
     C     35            SUBST     R1DTP1:36     FLDTP2
     C     35            SUBST     R1DTP1:71     FLDTP3
     C     35            SUBST     R1DTP1:106    FLDTP4
     C                   MOVE      R1DCHG        FLDCHG
     C     35            SUBST     R1BTB1:1      FLBTB1
     C     35            SUBST     R1BTB1:36     FLBTB2
     C     35            SUBST     R1BTB1:71     FLBTB3
     C     35            SUBST     R1BTB1:106    FLBTB4
     C     35            SUBST     R1BTB1:141    FLBTB5
     C     35            SUBST     R1BTB1:176    FLBTB6
     C                   MOVEL     R1PONS        FLPOBR
     C                   MOVE      R1SCCY        FLPSCY
     C                   MOVE      R1ICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      R1REXR        ZFIELD           16                          CLE031
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
     C                   MOVE      R1PEXR        ZFIELD           16                          CLE031
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
     C                   MOVE      R1REXI        FLREXI                                       CLE031
     C                   MOVE      R1PEXI        FLPEXI                                       CLE031
     C                   MOVE      R1SCCY        FLRSCY                                       CLE031
     C                   MOVE      R1PSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Prime Facility                                         *
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
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
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
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEASGNRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      ' '           RESPMODE          1
 
      * Action and assigned to and assigned from customers
     C                   PARM                    S#ACTN
     C                   PARM                    S#ASTS
     C                   PARM                    S#ASFS
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
 
      * Prime facility branch
     C                   PARM                    FcbrBranch
 
      * Value date of change
     C                   PARM      *ZERO         In_VDTC           5 0
      *
      * OUTPUTS
 
      * Assignment Details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#ASTSok
     C                   PARM                    S#ASFSok
 
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
     C                   PARM      *zero         Idx
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   CALLB     'LEASGNVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Assignment Details in screen format
     C                   PARM                    ASGN
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    R1PCOB
     C                   PARM                    R1TNRF
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    ASGN_OK
      *
      * Assigned to customer number
     C                   PARM                    S#ASTN            6
      *
      * Assigned from customer number
     C                   PARM                    S#ASFN            6
      * Assigned to customer name/town
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10
      * Assigned from customer name/town
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx
 
      * Valid Assignment
     C                   PARM                    LEVASGNPD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
 
      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (S#ASTSOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
      *
      ** PAYMENT DATE & RECEIVE DATE = RUN DATE
      *
     C                   Z-ADD     BJRDNB        ##DATP
     C                   Z-ADD     BJRDNB        ##DATR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM      FccyFCCY      ##CCY             3
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      FccyFCCY      ##CCY             3
      ** Customer (shortname or number)
     C                   PARM      S#ASTN        ##CSNM           10
      ** Deal type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      ** Booking Branch
     C                   PARM      FcbrBranch    ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
      * Action Code
     C                   PARM      S#ACTN        ##ACTN            1
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
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      ** Extra Input
      ** Action Code used
     C                   PARM      S#ACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
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
 
     C                   CALLB     'LEASGNCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Assignment details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Assignment Details in screen format
     C                   PARM                    C_ASGN
 
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
 
     C                   CALLB     'LEASGNAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New assignment in Screen Format
     C                   PARM                    ASGN
      *
      * Current assignment in Screen Format
     C                   PARM                    C_ASGN
      *
      * Current assignment in File Format
     C                   PARM                    LEPARTPDFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    ASGN_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
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
     C                   PARM                    XREPN
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    XTMST
     C                   WRITE     LEIASGND0
     C                   WRITE     APILSETD0
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
 
     C                   MOVE      R1MSGT        R2MSGT
     C                   MOVE      R1TRUS        R2TRUS
     C                   MOVE      R1TRWS        R2TRWS
     C                   MOVE      R1TNRF        R2TNRF
     C                   MOVE      R1TRSN        R2TRSN
     C                   MOVE      R1ACTN        R2ACTN
     C                   MOVE      R1TRDS        R2TRDS
     C                   MOVE      R1TRTS        R2TRTS
     C                   MOVE      R1NRBA        R2NRBA
     C                   MOVEL     'E'           R2MSGS
     C                   MOVEL     ZAMSID        R2MSGI
     C                   MOVEL     ZAMSTX        R2MSTX
     C                   MOVE      R1CNUM        R2CNUM
     C                   MOVE      R1FACT        R2FACT
     C                   MOVE      R1FCNO        R2FCNO
     C                   MOVE      R1MNUM        R2MNUM
     C                   MOVE      R1INUM        R2INUM
 
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
 
     C     RetCodeOut    IFNE      *BLANK
 
     C                   ADD       1             Idx
 
     C                   ROLBK
 
     C                   ELSE
 
      ** Commit the database changes
 
     C                   COMMIT
 
      ** Set up the returned message format
 
     C                   MOVE      R1MSGT        R2MSGT
     C                   MOVE      R1TRUS        R2TRUS
     C                   MOVE      R1TRWS        R2TRWS
     C                   MOVE      R1TNRF        R2TNRF
     C                   MOVE      R1TRSN        R2TRSN
     C                   MOVE      R1ACTN        R2ACTN
     C                   MOVE      R1TRDS        R2TRDS
     C                   MOVE      R1TRTS        R2TRTS
     C                   MOVE      R1NRBA        R2NRBA
     C                   MOVE      R1CNUM        R2CNUM
     C                   MOVE      R1FACT        R2FACT
     C                   MOVE      R1FCNO        R2FCNO
     C                   MOVE      R1MNUM        R2MNUM
     C                   MOVE      R1INUM        R2INUM
 
     C                   ENDIF
 
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
 
     C                   IF            (S_Rec = *blank)
     C                             AND (S_Pay = *blank)
 
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LEND'        ##CALP            4
      *
      * Payment currency
     C                   PARM      FccyFCCY      ##PCCY            3
      *
      * Receive currency
     C                   PARM      FccyFCCY      ##RCCY            3
      *
      * Customer shortname
     C                   PARM      S#ASTN        ##CSNM           10
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
     C                   PARM      *BLANK        S_PAY
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        S_REC
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        S_FRI
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
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
 
      * For Amends, put the complete (pre-existing) deal into the Valid
      *  file record - fields in this will be updated during  processing
     C**********         MOVE      LEPARTPDFmt   LEVASGNPD                                    CGL029
     C                   MOVEL     LEPARTPDFmt   LEVASGNPD                                    CGL029
     C                   MOVE      LepartpdEXT   LEVASGNPD                                    CGL029
 
     C**********         EVAL      F_REC      = LepartREC + OSDB                              CGL029
     C                   EVAL      F_REC = LepartREC1 + RONS + LepartREC2 + OSDB              CGL029
     C                   EVAL      FLRSCY     = SCCY
     C**********         EVAL      F_PAY      = LepartPAY + OMDB + CVMR                       CGL029
     C                   EVAL      F_PAY = LepartPAY1 + PONS + LepartPAY2 + OMDB              CGL029
     C                                     + CVMR                                             CGL029
     C                   EVAL      FLPSCY     = SCCY
     C                   EVAL      FLIC72     = ICCY
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
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.
 
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
     C                   CALLB     'LEASGNCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Assignment details in file format
     C                   PARM                    LEPARTPDFmt
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Assignment Details in screen format
     C                   PARM                    C_ASGN
 
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
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      ASGN          IncDATA        2000
      * Current Data
     C                   PARM      C_ASGN        CurDATA        2000
 
     C                   MOVEL     IncDATA       ASGN
 
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
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEASGNUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN
 
      * Assignment Details in file format
     C                   PARM                    LEVASGNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    ASGN_OK
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
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   MOVE      XREPN         ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = XTMST
 
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
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
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
 
      ** Access API ICD via access program
      *  (database error handling done in access program)
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
                                                                                              CLE031
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
      *
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
     C                   MOVE      'D'           R2MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
