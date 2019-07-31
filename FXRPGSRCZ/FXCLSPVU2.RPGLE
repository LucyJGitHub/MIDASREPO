     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Validate & Update Dtl')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCLSPVU2 - CLS Pay-in Schedule Validate and Update (Detail) *
      *                                                               *
      *  Function: This program validates CLS Pay-in Schedule Details *
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
      *                 BUG8433            Date 20Jul05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5671            Date 31Jan05               *
      *                 BUG5287            Date 26Jan05               *
      *                 BUG3018            Date 21Jan05               *
      *                 BUG683             Date 22Dec04               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG8433- Not to validate sequence no. if second pass         *
      *           (confirm complete) in FXCLSPRTV.                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG5671- Add Sequence number to detail record                *
      *  BUG5287- Stop overwrite of Profit Centre and Time Difference *
      *  BUG3018- Allow toggle of Pay or Receive on first detail      *
      *  BUG683 - Add PPayRcv to buffer                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFXCLSPSHL3UF   E           K DISK    COMMIT
     F                                     PREFIX(H3_)
 
     FFXCLSPSDL3IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D3_)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming transaction in screen format
     D TranInCLS2    E DS                  EXTNAME(FXCLSPDPD)
 
      ** Valid file layout - Header
     D ValidCLSP     E DS                  EXTNAME(FXVCLSPHPD)
     D                                     PREFIX(H_)
 
      ** Valid file layout - Detail
     D ValidCLS2     E DS                  EXTNAME(FXVCLSPDPD)
     D CLTDIF        E                     EXTFLD(CLSTIM)
 
      ** CLS Pay-in Schedule Header in file format
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSH)
     D                                     PREFIX(H_)
 
      ** CLS Pay-in Schedule Detail in file format
     D CLS2FilFmt    E DS                  EXTNAME(FXCLSPSD)
 
      ** Error indicator - Header
     D OKTrCLSP      E DS                  EXTNAME(FXECLSPHPD)
     D                                     PREFIX(H_)
 
      ** Error indicator - Detail (dummy)
     D OKTrCLS2      E DS                  EXTNAME(FXECLSPDPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Temporary Valid file layout - Detail
     D XValidCLS2    E DS                  EXTNAME(FXVCLSPDPD)
     D                                     PREFIX(Dx_)
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
 
      ** Extract Pay Receive Toggle                                                          BUG3018
     D PAYRECDS        DS           500                                                      BUG3018
      **PAYREC****************47*****47                                              BUG3018 BUG5671
     D  PAYREC                49     49                                                      BUG5671
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
     D PAction         S              1A
     D A6NBDP          S              1P 0
     D A7MPGT          S              1A
     D WLSPRF          S              4A                                                     BUG5287
     D WLSTMD          S              5A                                                     BUG5287
 
      ** Parameters for FXCLSPVAL
     D PPayRcv         S              1A
     D PVldCnf         S              1A
     D PSflAction      S              2A
     D PNoTime         S              1A
 
      ** Parameters for FXCLSPUPD
     D PHdrDtl         S              1A
     D PUpdOthr        S              1A
 
      ** Parameters for SFC000026
     D PUser           S             10A
 
      ** Work variables
     D WError          S              1A
     D WTotal          S             17P 0
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Fields (500A) to receive the incoming transaction
     D Trans500        S            500A
 
      ** Parameter for ZAGENTMSTM
     D Timestamp       S               Z
 
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
 
     C                   EVAL      TranInCLS2 = Trans500
 
     C                   EVAL      PAYRECDS   = Trans500                                     BUG3018
      ** Reset variables gradually updated
 
     C                   EXSR      SrResetCycle
 
      ** Validate the action code and retrieve the header
 
     C                   EXSR      SrValidateAc
 
      ** If error occurred, fail this input
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon action code
 
     C                   SELECT
     C                   WHEN      CLSACT = 'I'
     C                   EXSR      SrVALdetail
 
     C                   WHEN      CLSACT = 'D'
     C                   EXSR      SrRT2detail
     C                   EXSR      SrVALdetail
 
     C                   ENDSL
 
      ** If error occurred, fail this input
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Compute the Total Pay or Receive amount and
      ** validate against the nostro balance total
 
     C                   EXSR      SrCompute
 
      ** If error occurred, fail this input
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Convert the file format data structure to screen format
 
     C                   EXSR      SrCV2detail
 
      ** Write to database
 
     C     INVALID       TAG
 
     C                   IF        UpdateYN = 'Y' AND Idx = *ZERO
     C                   EXSR      SrUpdateDB
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL      Buffer = TranInCLS2
     C                             +PPayRcv                                                   BUG683
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValidateAc - Validate the action code                      *
      *****************************************************************
     C     SrValidateAc  BEGSR
 
      ** Only action codes 'I' and 'D' are allowed
 
     C                   IF        CLSACT <> 'I' AND CLSACT <> 'D'
     C                   EVAL      CLSACTOK = 'N'
     C                   EVAL      CLSCCYOK = 'N'
     C                   EVAL      CLSNSTOK = 'N'
     C                   EVAL      CLSVDTOK = 'N'
     C                   EVAL      CLSSEQOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CLSACT'
     C                   EVAL      MsgIdArr(Idx) = 'FXM3044'
     C                   ENDIF
 
      ** If error occurred, do not proceed
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      ESrValidateAc
     C                   ENDIF
 
      ** If a detail record is to be inserted or deleted, consider it
      ** as an amendment on the header record
 
     C                   IF        CLSACT = 'I' OR CLSACT = 'D'
     C                   EVAL      PAction = 'A'
     C                   ELSE
     C                   EVAL      PAction = 'E'
     C                   ENDIF
 
     C                   CALLB     'FXCLSPRTV'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       ModeOfOp
     C                   PARM      'S'           RespMode
     C                   PARM                    PAction
     C                   PARM                    CLSCCY
     C                   PARM                    CLSNST
     C                   PARM                    CLSVDT
     C                   PARM                    CLSSEQ
     ********************PARM      *BLANKS       CLSPRF                                      BUG5287
     ********************PARM      *BLANKS       CLSTMD                                      BUG5287
     C                   PARM      *BLANKS       WLSPRF                                      BUG5287
     C                   PARM      *BLANKS       WLSTMD                                      BUG5287
     C                   PARM                    H_CLAUTH                                     CAP086
     C                   PARM                    UpdateYN                                    BUG8433
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    CLSPFilFmt
     C                   PARM                    A6NBDP
     C                   PARM                    A7MPGT
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      ESrValidateAc
     C                   ENDIF
                                                                                             BUG3018
      ** Check for Toggle of Pay or Receive                                                  BUG3018
                                                                                             BUG3018
     C                   IF        CLSACT = 'I' AND PAYREC <> *BLANKS                        BUG3018
     C                   EVAL      PPayRcv = PAYREC                                          BUG3018
     C                   ELSE                                                                BUG3018
 
      ** Default to either Pay or Receive side
 
     C                   SELECT
     C                   WHEN      H_PYTOTP <> *ZERO
     C                   EVAL      PPayRcv = 'P'
 
     C                   WHEN      H_PYTOTR <> *ZERO
     C                   EVAL      PPayRcv = 'R'
 
     C                   OTHER
     C                   IF        H_PYNSBP > *ZERO
     C                   EVAL      PPayRcv = 'P'
     C                   ELSE
     C                   EVAL      PPayRcv = 'R'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF                                                               BUG3018
                                                                                             BUG3018
      ** If for Receive side and a detail record already exists,
      ** do not allow insertion of another record
 
     C                   IF        PPayRcv = 'R' AND CLSACT = 'I'
 
     C     KHdrFlds      SETLL     FXCLSPSDL3
     C                   DOU       *IN81 = *ON  OR
     C                             *IN81 = *OFF AND D3_PYRECI = 'D'
     C     KHdrFlds      READE     FXCLSPSDL3                             81
     C                   ENDDO
 
     C                   IF        *IN81 = *OFF AND D3_PYRECI = 'D'
     C                   EVAL      CLSACTOK = 'N'
     C                   EVAL      CLSCCYOK = 'N'
     C                   EVAL      CLSNSTOK = 'N'
     C                   EVAL      CLSVDTOK = 'N'
     C                   EVAL      CLSSEQOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CLSACT'
     C                   EVAL      MsgIdArr(Idx) = 'FXM3045'
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESrValidateAc ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRT2detail - Retreive the Detail record                     *
      *****************************************************************
     C     SrRT2detail   BEGSR
 
     C                   CALLB     'FXCLSPRT2'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'S'           RespMode
     C                   PARM                    CLSACT
     C                   PARM                    CLSCCY
     C                   PARM                    CLSNST
     C                   PARM                    CLSVDT
     C                   PARM                    CLSSEQ
     C                   PARM                    CLSTIM
      *******************PARM                    CLSAMT                                      BUG5671
     C                   PARM                    CLSDSQ                                      BUG5671
      ** Output parameters:
     C                   PARM                    CLS2FilFmt
     C                   PARM                    OKTrCLS2
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
     C     ESrRT2detail  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVALdetail - Validate the Detail record                     *
      *****************************************************************
     C     SrVALdetail   BEGSR
 
      ** If action is Insert, validate the time and amount
      ** Else, just map the fields
 
     C                   IF        CLSACT = 'I'
     C                   EVAL      PVldCnf = 'V'
     C                   ENDIF
 
     C                   IF        CLSACT = 'D'
     C                   EVAL      PVldCnf = 'M'
     C                   ENDIF
 
     C                   CALLB     'FXCLSPVAL'
      ** Input parameters:
     C                   PARM      'S'           RespMode
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM                    PVldCnf
     C                   PARM                    CLSPFilFmt
     C                   PARM                    CLSTIM
     C                   PARM                    CLSAMT
     C                   PARM                    CLSAMT
     C                   PARM      *BLANKS       PSflAction
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    OKTrCLS2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM                    PNoTime
 
     C                   IF        PPayRcv = 'R'
     C                   EVAL      CLAMT = H_CLTOTR
     C                   EVAL      CLDSEQ = PYDSEQ                                          BUG5671
     C                   ELSE
     C                   IF        CLSACT = 'D'
     C                   EVAL      CLLTIM = PYLTIM
     C                   EVAL      CLAMT = PYAMT
     C                   EVAL      CLDSEQ = PYDSEQ                                          BUG5671
     C                   ENDIF
     C                   ENDIF
 
      ** Further validate only if action is Insert
 
     C                   IF        CLSACT <> 'I'
     C                   GOTO      ESrVALdetail
     C                   ENDIF
 
     C                   EVAL      WError = 'N'
 
      ** If CLS time is blank, check if other detail (pay) records exist
 
     C                   IF        PPayRcv = 'P' AND PNoTime = 'Y'
 
     C     KHdrFlds      SETLL     FXCLSPSDL3
     C                   DOU       *IN81 = *ON  OR
     C                             *IN81 = *OFF AND D3_PYRECI = 'D'
     C     KHdrFlds      READE     FXCLSPSDL3                             81
     C                   ENDDO
 
      ** This should be the first payment on the schedule and
      ** Multiple pay-in generated by time on the nostro must be 'N'
 
     C                   IF        *IN81 = *OFF AND D3_PYRECI = 'D'
     C                   EVAL      WError = 'Y'
     C                   ELSE
     C                   IF        A7MPGT = 'Y'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WError = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CLSTIM'
     C                   EVAL      MsgIdArr(Idx) = 'FXM3041'
     C                   EVAL      CLSTIMOK = 'N'
     C                   EVAL      CLSAMTOK = 'N'
     C                   ENDIF
 
      ** Just make sure that CLS time is blank, for Receive side
 
     C                   IF        PPayRcv = 'R' AND CLSTIM <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'CLSTIM'
     C                   EVAL      MsgIdArr(Idx) = 'FXM3025'
     C                   EVAL      CLSTIMOK = 'N'
     C                   EVAL      CLSAMTOK = 'N'
     C                   ENDIF
                                                                                             BUG5671
      ** Set up detail sequence number - default to 01 if no records with same time CET      BUG5671
                                                                                             BUG5671
     C                   Z-ADD     1             CLDSEQ                                      BUG5671
      ** If receive, seq must be 01 and if time is blank on Pay, seq must be 01              BUG5671
     C                   IF        PPayRcv = 'P' AND PNoTime <> 'Y'                          BUG5671
                                                                                             BUG5671
     C     KDtlFlds      SETGT     FXCLSPSDL3                                                BUG5671
     C                   READP     FXCLSPSDL3                             90                 BUG5671
                                                                                             BUG5671
     C     *IN90         IFEQ      '0'                                                       BUG5671
     C     H_PYCCY       ANDEQ     D3_PYCCY                                                  BUG5671
     C     H_PYNOST      ANDEQ     D3_PYNOST                                                 BUG5671
     C     H_PYVALD      ANDEQ     D3_PYVDAT                                                 BUG5671
     C     H_PYSEQN      ANDEQ     D3_PYSEQN                                                 BUG5671
     C     CLSTIM        ANDEQ     D3_PYLTIM                                                 BUG5671
     C                   EVAL      CLDSEQ = D3_PYDSEQ + 1                                    BUG5671
     C                   ENDIF                                                               BUG5671
     C                   ENDIF                                                               BUG5671
                                                                                             BUG5671
 
     C     ESrVALdetail  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCompute - Compute the total pay or receive amount          *
      *****************************************************************
     C     SrCompute     BEGSR
 
     C                   EVAL      WTotal = *ZERO
 
     C     KHdrFlds      SETLL     FXCLSPSDL3
     C                   DOU       *IN81 = *ON
     C     KHdrFlds      READE     FXCLSPSDL3                             81
     C                   IF        *IN81 = *OFF AND D3_PYRECI = 'D'
     C                   ADD       D3_PYAMT      WTotal
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        CLSACT = 'I'
     C                   ADD       CLAMT         WTotal
     C                   ENDIF
 
     C                   IF        CLSACT = 'D'
     C                   SUB       CLAMT         WTotal
     C                   ENDIF
 
     C                   IF        PPayRcv = 'P'
     C                   EVAL      H_PYTOTP = WTotal
     C                   ELSE
     C                   EVAL      H_PYTOTR = WTotal
     C                   ENDIF
 
      ** Validate against the nostro balance total
 
     C                   CALLB     'FXCLSPVAL'
      ** Input parameters:
     C                   PARM      'S'           RespMode
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM      'C'           PVldCnf
     C                   PARM                    CLSPFilFmt
     C                   PARM                    CLSTIM
     C                   PARM                    CLSAMT
     C                   PARM                    CLSAMT
     C                   PARM      *BLANKS       PSflAction
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    OKTrCLS2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM                    PNoTime
 
     C     ESrCompute    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCV2detail - Convert data structure from File to Screen fmt *
      *****************************************************************
     C     SrCV2detail   BEGSR
 
     C                   IF        CLSACT = 'I'
     C                   MOVEL     ValidCLS2     CLS2FilFmt
     C                   ENDIF
 
     C                   CALLB     'FXCLSPCV2'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    CLS2FilFmt
      ** Output parameter:
     C                   PARM                    TranInCLS2
 
     C     ESrCV2detail  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrUpdateDB - Update the database                             *
      *****************************************************************
     C     SrUpdateDB    BEGSR
 
     C                   CALLB     'FXCLSPUPD'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    CLSACT
     C                   PARM                    PPayRcv
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM      'D'           PHdrDtl
     C                   PARM      'N'           PUpdOthr
 
      ** Update the header with the new amount
 
     C                   IF        @RtCd = *BLANKS
 
     C                   CLEAR                   XValidCLS2
     C                   EVAL      Dx_CLVDAT = *ZERO
     C                   EVAL      Dx_CLSEQN = *ZERO
     C                   EVAL      Dx_CLAMT = *ZERO
     C                   EVAL      Dx_CLDSEQ = *ZERO                                         BUG5671
 
     C                   CALLB     'FXCLSPUPD'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      'A'           PAction
     C                   PARM                    PPayRcv
     C                   PARM                    ValidCLSP
     C                   PARM                    XValidCLS2
     C                   PARM      'H'           PHdrDtl
     C                   PARM      'N'           PUpdOthr
 
      ** Reverse/insert shadow postings
 
     C                   IF        @RtCd = *BLANKS
 
     C                   IF        CLSACT = 'D'
     C                   EVAL      PAction = 'A'
     C                   ELSE
     C                   IF        CLAMT = WTotal
     C                   EVAL      PAction = CLSACT
     C                   ELSE
     C                   EVAL      PAction = 'A'
     C                   ENDIF
     C                   ENDIF
 
     C                   CALLB     'FXCLSPUPD'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    PAction
     C                   PARM                    PPayRcv
     C                   PARM                    ValidCLSP
     C                   PARM                    ValidCLS2
     C                   PARM      'S'           PHdrDtl
     C                   PARM      'N'           PUpdOthr
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise commit.
 
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*RECUPD'
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
 
     C                   IF        @RtCd = '*RECUPD'
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'FXM3036'
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
     C                   EVAL      H_CLVALD = *ZERO
     C                   EVAL      H_CLSEQN = *ZERO
     C                   EVAL      H_CLTOTP = *ZERO
     C                   EVAL      H_CLTOTR = *ZERO
     C                   EVAL      H_CLNSBP = *ZERO
     C                   EVAL      H_CLNSBR = *ZERO
     C                   CLEAR                   ValidCLS2
     C                   EVAL      CLVDAT = *ZERO
     C                   EVAL      CLSEQN = *ZERO
     C                   EVAL      CLAMT = *ZERO
     C                   EVAL      CLDSEQ = *ZERO                                            BUG5671
 
     C     ESrResetCycle ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGetUser - Get web browser user                             *
      *****************************************************************
     C     SrGetUser     BEGSR
 
     C                   CALL      'SFC000026'
     C                   PARM      *BLANKS       PUser
 
     C                   IF        PUser = *BLANKS
     C                   EVAL      PUser = PSUser
     C                   ENDIF
 
     C     ESrGetUser    ENDSR
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
 
     C                   CALL      'AOBANKR0'
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
 
      ** Key lists
 
     C     KHdrFlds      KLIST
     C                   KFLD                    H_PYCCY
     C                   KFLD                    H_PYNOST
     C                   KFLD                    H_PYVALD
     C                   KFLD                    H_PYSEQN
                                                                                             BUG5671
     C     KDtlFlds      KLIST                                                               BUG5671
     C                   KFLD                    H_PYCCY                                     BUG5671
     C                   KFLD                    H_PYNOST                                    BUG5671
     C                   KFLD                    H_PYVALD                                    BUG5671
     C                   KFLD                    H_PYSEQN                                    BUG5671
     C                   KFLD                    CLSTIM                                      BUG5671
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrTimestamp - Generate a timestamp                           *
      *****************************************************************
     C     SrTimestamp   BEGSR
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C     ESrTimestamp  ENDSR
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
