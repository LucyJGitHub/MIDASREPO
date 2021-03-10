     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR SIRS Support Log Setup Module')               *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSIRSLOG - Single Currency IRS Support Log Setup Module     *
      *                                                               *
      *  Function:  This module will convert fields of Single         *
      *             Currency IRS Details file into screen format      *
      *             to be used in writing records to the log file.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 BUG11456           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CIR008             Date 13Mar02               *
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A- CCR015: Display Order in Confirmation Pages         *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11456-Screen-definition file should be alpha              *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  BUG6472- Added a sign field to short term rate (Recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file (Recompile)                                    *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      * SRSETD - Set Settlement Instructions Input                    *
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
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

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

     D SIRSFilFmt    E DS                  EXTNAME(DEALSDG)
     D SIRSXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025

     D SIRSScnFmt    E DS                  EXTNAME(IRSIRSPD)

     D ORCDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(OR)

     D OIPDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(OI)

     D TRCDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(TR)

     D TIPDScnFmt    E DS                  EXTNAME(IRDTSCPD)
     D                                     PREFIX(TI)

     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)

     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)

     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)

     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)

     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)

     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)

     D SIRSExtDta    E DS                  EXTNAME(IRSSEXPD)
                                                                                              CAP043
      ** FRA/IRS Interface Non-Screen Data                                                    CAP043
     D InfData       E DS                  EXTNAME(IRRSIFPD)                                  CAP043
                                                                                              CAP043
      ** Last processing date (82nd PRDT) UR/UP/TR/TP                                         CAP043
     D PLastPRDT       DS                                                                     CAP043
     D WLastPRDT               1     12P 0 DIM(4)                                             CAP043

      ** External DS for SAR details                                                          CIR008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR008
     D   SCLCD       E                     EXTFLD(LCD)                                        CIR008
                                                                                              CIR008
      ** Short DS for Access programs                                                         CIR008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR008

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D TRANSDTL        S           5800A
     D PSTS            S             24A
     D PDealNumber     S              6A
     D PActCode        S              1A                                                      CIR008
     D PRTCD           S              7A                                                      CIR008
     D POPTN           S              7A                                                      CIR008
     D PSARD           S              6A                                                      CIR008
     D CIR008          S              1A                                                      CIR008

      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRPROC
     C
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SR/SRSETD - Set Settlement Instructions Input          *
      *                                                               *
      *****************************************************************

     C     SRPROC        BEGSR

     C                   EVAL      TRANSDTL = *Blanks
     C**********         EVAL      SACCD = CHTP                                               CIR008
     C                   EVAL      SACCD = PActCode                                           CIR008

     C                   EXSR      SRSETD

     C                   CALLB     'IRSIRSCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    SIRSFilFmt
     C                   PARM                    SIRSXFilFmt                                  CLE025
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    SIRSScnFmt
     C                   PARM                    PSTS

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*Error'
     C                   ELSE

     C                   CALLB     'IRIRCRTV'
     C                   PARM                    RetCodeOut
     C                   PARM      SDLNO         PDealNumber
     C                   PARM      *Zero         PLastPRDT                                    CAP043
     C                   PARM      *Blanks       ORCDScnFmt
     C                   PARM      *Blanks       OIPDScnFmt
     C                   PARM      *Blanks       TRCDScnFmt
     C                   PARM      *Blanks       TIPDScnFmt

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*Error'
     C                   ELSE

     C                   CALLB     'ZASETINCVT'
     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM                    FRIRFilFmt
     C                   PARM      *Blanks       PAYScnFmt
     C                   PARM      *Blanks       RECScnFmt
     C                   PARM      *Blanks       FRIRScnFmt
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A

     C                   EVAL      TRANSDTL = SIRSScnFmt + ORCDScnFmt
     C                                        + OIPDScnFmt
     C                                        + TRCDScnFmt
     C                                        + TIPDScnFmt
     C                                        + RECScnFmt
     C                                        + PAYScnFmt
     C                                        + FRIRScnFmt
     C                                        + InfData                                       CAP043
     C                                        + SIRSExtDta
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRSETD - Set Settlement Instructions Input                 *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSETD        BEGSR

      ** Move Payment Fields from SIRSFilFmt (DEALSDG) to
      ** PAYFilFmt (SDESFPPD)

     C                   EVAL      FLPSTM = PSTM
     C                   EVAL      FLPONS = PONS
     C                   EVAL      FLPIBN = PIBN
     C                   EVAL      FLPIBA = PIBA
     C                   EVAL      FLPOBN = POBN
     C                   EVAL      FLPOCN = POCN
     C                   EVAL      FLRCRN = RCRN
     C                   EVAL      FLRCRA = RCRA
     C                   EVAL      FLRVNO = RVNO
     C                   EVAL      FLAWBN = AWBN
     C                   EVAL      FLAWBA = AWBA
     C                   EVAL      FLBENN = BENN
     C                   EVAL      FLBENA = BENA
     C                   EVAL      FLDTP1 = DTP1
     C                   EVAL      FLDTP2 = DTP2
     C                   EVAL      FLDTP3 = DTP3
     C                   EVAL      FLDTP4 = DTP4
     C                   EVAL      FLDCHG = DCHG
     C                   EVAL      FLBTB1 = BTB1
     C                   EVAL      FLBTB2 = BTB2
     C                   EVAL      FLBTB3 = BTB3
     C                   EVAL      FLBTB4 = BTB4
     C                   EVAL      FLBTB5 = BTB5
     C                   EVAL      FLBTB6 = BTB6
     C                   EVAL      FLPOBR = POBR
     C                   EVAL      FLCVMR = CVMR
     C                   EVAL      FLPSCY = PSCY
     C                   EVAL      FLIC72 = IC72

      ** Move Receipt Fields from SIRSFilFmt (DEALSDG) to
      ** RECFilFmt (SDESFRPD)

     C                   EVAL      FLRSTM = RSTM
     C                   EVAL      FLRONS = RONS
     C                   EVAL      FLRIBN = RIBN
     C                   EVAL      FLRIBA = RIBA
     C                   EVAL      FLROBN = ROBN
     C                   EVAL      FLROCN = ROCN
     C                   EVAL      FLROBR = ROBR
     C                   EVAL      FLRSCY = RSCY

      ** Move extended FRA/IRS instruction fields from
      ** SIRSFilFmt (DEALSDG) to FRIRFilFmt (SDESFFPD)

     C                   EVAL      FLDSR1 = DSR1
     C                   EVAL      FLDSR2 = DSR2
     C                   EVAL      FLDSR3 = DSR3
     C                   EVAL      FLDSR4 = DSR4
     C                   EVAL      FLDSR5 = DSR5
     C                   EVAL      FLDSR6 = DSR6
     C                   EVAL      FLSSR1 = SSR1
     C                   EVAL      FLSSR2 = SSR2
     C                   EVAL      FLSSR3 = SSR3
     C                   EVAL      FLSSR4 = SSR4
     C                   EVAL      FLSSR5 = SSR5
     C                   EVAL      FLSSR6 = SSR6
     C                   EVAL      FLCND1 = CND1
     C                   EVAL      FLCND2 = CND2
     C                   EVAL      FLCND3 = CND3
     C                   EVAL      FLCND4 = CND4
     C                   EVAL      FLCND5 = CND5
     C                   EVAL      FLCND6 = CND6
     C                   EVAL      FLAGTY = AGTY
     C                   MOVEL     ISDA          FLISDA
     C                   MOVEL     AGDT          FLAGDT
     C                   MOVEL     AGVV          FLAGVV
     C                   MOVEL     AGVC          FLAGVC
                                                                                              CAP043
      ** Move FRA/IRS Interface Non-Screen Data to InfData                                    CAP043
                                                                                              CAP043
     C                   MOVEL     FIAUTH        AUTH                                         CAP043

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PActCode                                     CIR008
     C                   PARM                    SIRSFilFmt
     C                   PARM                    SIRSXFilFmt                                  CLE025
     C                   PARM                    PLastPRDT                                    CAP043
     C                   PARM                    RECScnFmt                                    CAP043
     C                   PARM                    PAYScnFmt                                    CAP043
     C                   PARM                    FRIRScnFmt                                   CAP043
     C                   PARM                    InfData                                      CAP043
     C                   PARM                    TRANSDTL

      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.

     C/COPY ZACPYSRC,DBFIELDS
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
     C                   EVAL      DBASE = 001                                                CIR008
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

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
