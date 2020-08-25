     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors support log setup')       *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFLOG - IR Caps/Collars/Floors Support Log Setup Module  *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             Caps/Collars/Floors Details file into screen      *
      *             format to be used in writing records to the       *
      *             log file.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5707            Date 28Jan05               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 217684             Date 12May03               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5707 - Parameter mismatch in IRCACFVAL and IRCACFCVT      *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *  SRSETD - Set Settlement Instructions Input                   *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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

      ** Midas IR Valid Caps/Collars/Floors
     D CACFFilFmt    E DS                  EXTNAME(IRVCACFPD)

      ** Midas IR Caps/Collars/Floors Format Definition File
     D CACFScnFmt    E DS                  EXTNAME(IRCACFPD)

      ** Midas IR Caps/Collars/Floors Interface Data Format Definition File
     D CACFInfDta    E DS                  EXTNAME(IRRPIFPD)

      ** Midas IR Caps/Collars/Floors Extra Data Layout File
     D CACFExtDta    E DS                  EXTNAME(IRCPEXPD)

      ** Midas SD File Extended Settlement Instruction - Pay
     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)

      ** Midas SD Screen Extended Settlement Instruction - Pay
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)

      ** Midas SD File Extended Settlement Instruction - Receive
     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)

      ** Midas SD Screen Extended Settlement Instruction - Receive
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)

      ** Midas SD File Extended Settlement Instruction - FRA/IRS
     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)

      ** Midas SD Screen Extended Settlement Instruction - FRA/IRS
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Short DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Switchable features
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A                                                      CIR008

      ** Parameters for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A

      ** Other variable used
     D PActCode        S              1A                                                      CIR008
     D PDealStat       S             24A
     D TRANSDTL        S           5800A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Convert file fields into screen format

     C                   EXSR      SRPROC

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRSETD, IRCACFCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR

     C                   EVAL      TRANSDTL = *BLANKS
     C**********         EVAL      #0ACCD = CHTP                                              CIR008
     C                   EVAL      #0ACCD = PActCode                                          CIR008

     C                   EXSR      SRSETD

     C                   CALLB     'IRCACFCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    PActCode
     C                   PARM                    CACFFilFmt
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    CACFScnFmt
     C                   PARM                    PDealStat
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE

     C                   CALLB     'ZASETINCVT'
     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM      *BLANKS       FRIRFilFmt
     C                   PARM      *BLANKS       PAYScnFmt
     C                   PARM      *BLANKS       RECScnFmt
     C                   PARM      *BLANKS       FRIRScnFmt
     C                   PARM      #0CUCY        InRCCY                                      CSF011A
     C                   PARM      #0CUCY        InPCCY                                      CSF011A

     C                   EVAL      TRANSDTL = CACFScnFmt + RECScnFmt +
     C                                        PAYScnFmt + FRIRScnFmt +
     C                                        CACFInfDta + CACFExtDta

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETD - Set Settlement Instructions Input                   *
      *                                                               *
      *  Called by: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRSETD        BEGSR

      ** Payment Fields

     C                   EVAL      FLPSTM = RPPSTM
     C                   EVAL      FLPONS = RPPONS
     C                   EVAL      FLPIBN = RPPIBN
     C                   EVAL      FLPIBA = RPPIBA
     C                   EVAL      FLPOBN = RPPOBN
     C                   EVAL      FLPOCN = RPPOCN
     C                   EVAL      FLRCRN = RPRCRN
     C                   EVAL      FLRCRA = RPRCRA
     C                   EVAL      FLRVNO = RPRVNO
     C                   EVAL      FLAWBN = RPAWBN
     C                   EVAL      FLAWBA = RPAWBA
     C                   EVAL      FLBENN = RPBENN
     C                   EVAL      FLBENA = RPBENA
     C                   EVAL      FLDTP1 = RPDTP1
     C                   EVAL      FLDTP2 = RPDTP2
     C                   EVAL      FLDTP3 = RPDTP3
     C                   EVAL      FLDTP4 = RPDTP4
     C                   EVAL      FLDCHG = RPDCHG
     C                   EVAL      FLBTB1 = RPBTB1
     C                   EVAL      FLBTB2 = RPBTB2
     C                   EVAL      FLBTB3 = RPBTB3
     C                   EVAL      FLBTB4 = RPBTB4
     C                   EVAL      FLBTB5 = RPBTB5
     C                   EVAL      FLBTB6 = RPBTB6
     C                   EVAL      FLPOBR = RPBRCA
     C                   EVAL      FLCVMR = RPCVMR
     C                   EVAL      FLPSCY = RPPSCY
     C                   EVAL      FLIC72 = RPIC72

      ** Receipt Fields

     C                   EVAL      FLRSTM = RPRSTM
     C                   EVAL      FLRONS = RPRONS
     C                   EVAL      FLRIBN = RPRIBN
     C                   EVAL      FLRIBA = RPRIBA
     C                   EVAL      FLROBN = RPROBN
     C                   EVAL      FLROCN = RPROCN
     C                   EVAL      FLROBR = RPROBR
     C                   EVAL      FLRSCY = RPRSCY
                                                                                              CAP043
      ** Move FRA/IRS Interface Non-Screen Data to InfData                                    CAP043
                                                                                              CAP043
     C                   MOVEL     RPAUTH        AUTH                                         CAP043

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PActCode                                     CIR008
     C                   PARM                    CACFFilFmt
     C                   PARM                    RECScnFmt                                    CAP043
     C                   PARM                    PAYScnFmt                                    CAP043
     C                   PARM                    FRIRScnFmt                                   CAP043
     C                   PARM                    CACFInfDta                                   CAP043
     C                   PARM                    TRANSDTL

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Module details

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Dealing details

     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if FRA/IRS Business Day Convention is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = 'CIR005'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CIR005 = 'Y'
     C                   ELSE
     C                   EVAL      CIR005 = 'N'
     C                   ENDIF

      ** Check if Amortisation of Caps, Collars, Floors and
      ** Individual Compounding Swaps is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = 'CIR006'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
                                                                                              CIR008
      **  Check if FRA/IRS Deals Authorisation is installed                                   CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRTCD                                        CIR008
     C                   PARM      '*VERIFY'     POPTN                                        CIR008
     C                   PARM      'CIR008'      PSARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRTCD <> *BLANKS AND                                       CIR008
     C                             PRTCD <> '*NRF   '                                         CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 006                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRTCD = *BLANKS                                            CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
