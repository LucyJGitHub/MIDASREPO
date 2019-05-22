     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Validate & Update Hdr')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCLSPVU - CLS Pay-in Schedule Validate and Update (Header)  *
      *                                                               *
      *  Function: This program validates CLS Pay-in Schedule Header  *
      *            for input into the Midas database.                 *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG8433            Date 20Jul05               *
      *                 BUG8270            Date 26Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 BG6558             Date 10Apr05               *
      *                 BUG5671            Date 31Jan05               *
      *                 BUG683             Date 22Dec04               *
      *                 BUG1801            Date 13Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CSC023             Date 28Jan04               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8433- Not to validate sequence no. if second pass         *
      *           (confirm complete) in FXCLSPRTV.                    *
      *  BUG8270 - TD1417 - CLSP:Incorrect error message for          *
      *            duplicate CLSP in EL System.                       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BG6558 - Unable to put in CLS schedules in HBOS mimic, as    *
      *           profit centre is blank                              *
      *  BUG5671- Add Sequence number to detail record                *
      *  BUG683 - Add PPayRcv to buffer                               *
      *  BUG1801- Correct command length for CSC023                   *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     FPRONO     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(PRONOHHF)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
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
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
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
 
     D Command1        C                   CONST('SBMJOB CMD(CALL PGM(DLC6316) +
     D                                           PARM(''')
 
     D*Command2*       C                   CONST(''')) JOB(DLC6316) +                         CSC023
     D**********                                 JOBQ(MBKGQ) JOBD(MBATCH) +                   CSC023
     D**********                                 USER(*JOBD)')                                CSC023
     D Command2        C                   CONST(''')) JOB(DLC6316) +                         CSC023
     D                                           JOBQ(MBKGQ) JOBD(MBATCH) +                   CSC023
     D                                           USER(*JOBD) OUTQ(*JOBD)')                    CSC023
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming transaction in screen format
     D TranInCLSP    E DS                  EXTNAME(FXCLSPHPD)
 
      ** JE Non-screen Interface Data file format                                             CAP086
     D PInfData      E DS                  EXTNAME(FXCLIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      ** Valid file layout - Header
     D ValidCLSP     E DS                  EXTNAME(FXVCLSPHPD)
 
      ** Valid file layout - Detail (dummy)
     D ValidCLS2     E DS                  EXTNAME(FXVCLSPDPD)
     D                                     PREFIX(D_)
 
      ** CLS Pay-in Schedule Header in file format
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSH)
 
      ** Error indicator - Header
     D OKTrCLSP      E DS                  EXTNAME(FXECLSPHPD)
 
      ** Error indicator - Detail (dummy)
     D OKTrCLS2      E DS                  EXTNAME(FXECLSPDPD)
     D                                     PREFIX(D_)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure used to divide projected nostro balances field
      ** into subfields representing daily balances
     D PNB             DS
     D  @PB                    1     40P 0
     D                                     DIM(5)
                                                                                              CSC022
      ** External DS for SAR Details                                                          CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
      ** Data structure used to separate dates received from LF/PRONO
      ** into separate fields
     D PND             DS
     D  @PD                    1     15P 0
     D                                     DIM(5)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D APIRetc         S              1A
 
      ** Parameters for FXCLSPRTV
     D ModeOfOp        S              6A
     D RespMode        S              1A
     D A6NBDP          S              1P 0
     D A7MPGT          S              1A
 
      ** Parameters for FXCLSPVAL
     D PPayRcv         S              1A
     D PVldCnf         S              1A
     D PCLSTime        S              4A
     D PCLSAmt         S             18A
     D PRcvAmt         S             18A
     D PNoTime         S              1A
     D PSflAction      S              2A
 
      ** Parameters for FXCLSPUPD
     D PHdrDtl         S              1A
     D PUpdOthr        S              1A
 
      ** Parameters for QCMDEXC
      *Cmd*************S             89A                                                     BUG1801
     D Cmd             S            101A                                                     BUG1801
     D CmdLength       S             15P 5
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Fields (500A) to receive the incoming transaction
     D Trans500        S            500A
 
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D PInfData500     S            500A                                                      CAP086
                                                                                              CAP086
      ** Work variables
     D KeyCcyD         S              3A
     D KeyNosN         S              2S 0
     D WCLNBL          S             15P 0
     D********** WConfirmOnly    S              1A                                            BG6558
     D WDate6A         S              6A
     D WDayNbr         S              5P 0
     D X               S              3P 0
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
                                                                                              CAP086
      ** Auto Authorisation flag                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      TranInCLSP = Trans500
     C                   EVAL      PInfData = PInfData500                                     CAP086
                                                                                              BG6558
     ****Check*if*the*call*to*this*program*is*just*for*confirmation**                         BG6558
     ****(before*writing*to*the*file)********************************                         BG6558
     *********                                                                                BG6558
     C********           IF        CLSACT='I' AND CLSCCY<>*BLANKS AND                         BG6558
     C********                     CLSNST<>*BLANKS AND CLSVDT<>*BLANKS                        BG6558
     C********                     AND CLSSEQ<>*BLANKS AND                                    BG6558
     C********                     CLSPRF<>*BLANKS AND CLSTMD<>*BLANKS                        BG6558
     C********           EVAL      WConfirmOnly = 'Y'                                         BG6558
     C********           ELSE                                                                 BG6558
     C********           EVAL      WConfirmOnly = 'N'                                         BG6558
     C********           ENDIF                                                                BG6558
 
      ** Reset variables gradually updated
 
     C                   EXSR      SrResetCycle
 
      ** Validate the key fields and retrieve the record
 
     C                   EXSR      SrValidateAc
 
      ** If error in validation of action code, fail this input
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Convert the file format data structure to screen format
 
     C                   EXSR      SrSetupAmd
 
      ** Map the file format data structure onto the Valids file format
 
     C                   EXSR      SrValidateTr
 
      ** Write to database
 
     C     INVALID       TAG
 
     C                   IF        UpdateYN = 'Y' AND Idx = *ZERO
     C                   EXSR      SrUpdateDB
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL      Buffer = TranInCLSP
     C**********                   +PPayRcv                                            BUG683 CAP086
     C                             +PPayRcv +PInfData                                         CAP086
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValidateAc - Validate Action Code and Retrieve             *
      *****************************************************************
     C     SrValidateAc  BEGSR
 
     ****If*this*program*was*only*called*for*confirmation,*do*not*call                        BG6558
     ****the*RTV*module*to*validate*the*header*fields.*Simply*map*them                        BG6558
     ****to*the*File*format*data*structure.***************************                        BG6558
     *********                                                                                BG6558
     C********           IF        WConfirmOnly = 'Y'                                         BG6558
     *********                                                                                BG6558
     C********           CLEAR                   CLSPFilFmt                                   BG6558
     C********           EVAL      PYCCY = CLSCCY                                             BG6558
     C********           EVAL      PYNOST = CLSNST                                            BG6558
     C********           CALLB     'ZAVDATE'                                                  BG6558
     C********           PARM      *BLANKS       RetCodeOut                                   BG6558
     C********           PARM      CLSVDT        WDate6A                                      BG6558
     C********           PARM                    BJDFIN                                       BG6558
     C********           PARM                    WDayNbr                                      BG6558
     C********           EVAL      PYVALD = WDayNbr                                           BG6558
     C********           MOVE      CLSSEQ        PYSEQN                                       BG6558
     C********           MOVE      CLSPRF        PYPRFC                                       BG6558
     C********           MOVEL     CLSTMD        PYTIMD                                       BG6558
     C********           EVAL      PYTOTP = *ZERO                                             BG6558
     C********           EVAL      PYTOTR = *ZERO                                             BG6558
     *********                                                                                BG6558
     C********           EVAL      KeyCcyD = CLSCCY                                           BG6558
     C********           MOVE      CLSNST        KeyNosN                                      BG6558
     C*****KeyProno      CHAIN     PRONOPNF                           81                      BG6558
     *********                                                                                BG6558
     C********           IF        NOT *IN81 AND RECI = 'D'                                   BG6558
     C********           EVAL      X = 1                                                      BG6558
     C********           IF        WDayNbr >= BJRDNB                                          BG6558
     C*****WDayNbr       LOOKUP    @PD(X)                                 82                  BG6558
     C********           ELSE                                                                 BG6558
     C********           EVAL      *IN82 = *ON                                                BG6558
     C********           ENDIF                                                                BG6558
     C********           IF        NOT *IN82                                                  BG6558
     C********           IF        WDayNbr < @PD(5)                                           BG6558
     C********           EVAL      X = 5                                                      BG6558
     C********           DOW       X > 1 AND @PD(X) > WDayNbr                                 BG6558
     C********           SUB       1             X                                            BG6558
     C********           ENDDO                                                                BG6558
     C********           MOVE      @PB(X)        WCLNBL                                       BG6558
     C********           IF        WCLNBL < *ZERO                                             BG6558
     C********           Z-SUB     WCLNBL        WCLNBL                                       BG6558
     C********           ENDIF                                                                BG6558
     C********           ENDIF                                                                BG6558
     C********           ELSE                                                                 BG6558
     C********           IF        WDayNbr < BJRDNB                                           BG6558
     C********           EVAL      X = 1                                                      BG6558
     C********           ENDIF                                                                BG6558
     C********           MOVE      @PB(X)        WCLNBL                                       BG6558
     C********           IF        WCLNBL < *ZERO                                             BG6558
     C********           Z-SUB     WCLNBL        WCLNBL                                       BG6558
     C********           ENDIF                                                                BG6558
     C********           ENDIF                                                                BG6558
     C********           ENDIF                                                                BG6558
     *********                                                                                BG6558
     C********           IF        @PB(X) < *ZERO                                             BG6558
     C********           Z-ADD     WCLNBL        PYNSBP                                       BG6558
     C********           Z-ADD     *ZERO         PYNSBR                                       BG6558
     C********           ELSE                                                                 BG6558
     C********           Z-ADD     WCLNBL        PYNSBR                                       BG6558
     C********           Z-ADD     *ZERO         PYNSBP                                       BG6558
     C********           ENDIF                                                                BG6558
     *********                                                                                BG6558
     C********           ENDIF                                                                BG6558
 
     C********           IF        WConfirmOnly = 'N'                                         BG6558
      *                                                                                       BG6558
      * If Insert, and sequence has been generated, clear it down again                       BG6558
      * (it will get regenerated)                                                             BG6558
     C                   If        CLSACT = 'I' and CLSSEQ <> '   '                           BG6558
     C                             AND CLAUTH <> 'Y'                                         BUG8270
     C                   Clear                   CLSSEQ                                       BG6558
     C                   EndIf                                                                BG6558
      ** Validate and retrieve the CLS Header record
 
     C                   CALLB     'FXCLSPRTV'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       ModeOfOp
     C                   PARM      'S'           RespMode
     C                   PARM                    CLSACT
     C                   PARM                    CLSCCY
     C                   PARM                    CLSNST
     C                   PARM                    CLSVDT
     C                   PARM                    CLSSEQ
     C                   PARM                    CLSPRF
     C                   PARM                    CLSTMD
     C                   PARM                    CLAUTH                                       CAP086
     C                   PARM                    UpdateYN                                    BUG8433
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx
     C                   PARM                    CLSPFilFmt
     C                   PARM                    A6NBDP
     C                   PARM                    A7MPGT
 
     C********           ENDIF                                                                BG6558
 
      ** The key fields are not amendable
 
     C                   IF        CLSACT = 'A'
     C                   EVAL      CLSACTOK = 'N'
     C                   EVAL      CLSCCYOK = 'N'
     C                   EVAL      CLSNSTOK = 'N'
     C                   EVAL      CLSVDTOK = 'N'
     C                   EVAL      CLSSEQOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CLSACT'
     C                   EVAL      MsgIdArr(Idx) = 'FDM0221'
     C                   ENDIF
 
      ** Default to either Pay or Receive side
 
     C                   IF        Idx = *ZERO
     C                   IF        PYNSBP > *ZERO
     C                   MOVE      'P'           PPayRcv
     C                   ELSE
     C                   MOVE      'R'           PPayRcv
     C                   ENDIF
     C                   ENDIF
 
     C     ESrValidateAc ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValidateTr - Map data into the Valids file format.         *
      *                 The validation was already done in RTV.       *
      *****************************************************************
     C     SrValidateTr  BEGSR
 
     C                   CALLB     'FXCLSPVAL'
      ** Input parameters:
     C                   PARM      'S'           RespMode
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM      'M'           PVldCnf
     C                   PARM                    CLSPFilFmt
     C                   PARM      *BLANKS       PCLSTime
     C                   PARM      *BLANKS       PCLSAmt
     C                   PARM      *BLANKS       PRcvAmt
     C                   PARM                    PSflAction
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    OKTrCLS2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM                    PNoTime
 
     C     ESrValidateTr ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSetupAmd - Convert data structure from File to Screen fmt  *
      *****************************************************************
     C     SrSetupAmd    BEGSR
 
     C                   CALLB     'FXCLSPCVT'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    CLSPFilFmt
      ** Output parameter:
     C                   PARM                    TranInCLSP
 
     C     ESrSetupAmd   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpdateDB - Update the database                             *
      *****************************************************************
     C     SrUpdateDB    BEGSR
 
     C                   CLEAR                   ValidCLS2
     C                   EVAL      D_CLVDAT = *ZERO
     C                   EVAL      D_CLSEQN = *ZERO
     C                   EVAL      D_CLAMT = *ZERO
     C                   EVAL      D_CLDSEQ = *ZERO                                          BUG5671
 
     C                   CALLB     'FXCLSPUPD'
      ** Output parameter:
     C                   PARM      *BLANKS       @RtCd
      ** Input parameters:
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM      'H'           PHdrDtl
     C                   PARM      'N'           PUpdOthr
 
      ** If action is Delete, reverse shadow postings
 
     C                   IF        RetCodeOut = *BLANKS AND CLSACT = 'D'
     C                             AND (CLTOTP > *ZERO OR CLTOTR > *ZERO)
     C                   CALLB     'FXCLSPUPD'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM      'S'           PHdrDtl
     C                   PARM      'N'           PUpdOthr
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise commit.
 
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
     C                   EVAL      APIRetc = '0'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation, send message to screen
 
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'FXM3036'
     C                   ENDIF
 
      ** If action is Authorise, submit background job for pay/receives
 
     C                   IF        CLSACT = 'X' AND RetCodeOut = *BLANKS
     C                   EVAL      Cmd = Command1 + A7MPGT + Command2
     C*******************EVAL      CmdLength = 89                                            BUG1801
     C                   EVAL      CmdLength = 101                                           BUG1801
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd
     C                   PARM                    CmdLength
     C                   ENDIF
 
     C     ESrUpdateDB   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrResetCycle - Reset error information that is gradually     *
      *                 updated during each run of this program       *
      *****************************************************************
     C     SrResetCycle  BEGSR
 
     C                   RESET                   Idx
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
 
     C                   RESET                   WIdx
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
 
     C                   MOVE      *ALL'Y'       OKTrCLSP
     C                   MOVE      *ALL'Y'       OKTrCLS2
 
     C                   CLEAR                   Buffer
 
      ** Numeric fields have to be zeroised explicitly
 
     C                   CLEAR                   ValidCLSP
     C                   EVAL      CLVALD = *ZERO
     C                   EVAL      CLSEQN = *ZERO
     C                   EVAL      CLTOTP = *ZERO
     C                   EVAL      CLTOTR = *ZERO
     C                   EVAL      CLNSBP = *ZERO
     C                   EVAL      CLNSBR = *ZERO
     C                   CLEAR                   ValidCLS2
     C                   EVAL      D_CLVDAT = *ZERO
     C                   EVAL      D_CLSEQN = *ZERO
     C                   EVAL      D_CLAMT = *ZERO
 
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      CLAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C     ESrResetCycle ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
      ** Transaction information in a single large field from source system
     C                   PARM                    Trans500
                                                                                              CAP086
      ** Non-screen interface data file format                                                CAP086
     C                   PARM                    PInfData500                                  CAP086
                                                                                              CAP086
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FXCLSPM01
 
      ** Access bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRtCd                                        CSC022
     C                   PARM      '*VERIFY'     POptn                                        CSC022
     C                   PARM      'CSC022'      PSard                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 001                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSard                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> *BLANKS AND                                       CAP086
     C                             PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'FXCLSPVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 2                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
 
      ** Define key list
 
     C     KeyProno      KLIST
     C                   KFLD                    KeyCcyD
     C                   KFLD                    KeyNosN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
