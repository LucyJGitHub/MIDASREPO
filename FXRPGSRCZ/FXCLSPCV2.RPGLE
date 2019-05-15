     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CLS Pay-in Schedule Convert - Detail')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCLSPCV2 - FX CLS Pay-in Schedule Conversion:               *
      *              File to Screen Format (Detail)                   *
      *                                                               *
      *  Function:  This module converts a CLS Pay-in Schedule Detail *
      *             record from File format to Screen format.         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG5671            Date 31Jan05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG5671- Add Sequence number to detail record                *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
 
      ** Pay-In schedule in file format - Detail
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSD)
 
      ** Pay-In schedule in screen format - Detail
     D CurTrCLSP     E DS                  EXTNAME(FXCLSPDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for AOBRCHR0
     D PBranch         S              3A
 
      ** Parameters for ZDATE2
     D PZDayNo         S              5P 0
     D PZDateN         S              6P 0
     D PZADate         S              7A
 
      ** Parameters for ZA0921
     D PZAmount        S             15P 0
     D PZDecPl         S              1P 0
     D PZDecSep        S              1A
     D PZAmtP          S             16A
     D PZAmtD          S             17A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** Set Output screen fields
 
     C                   EXSR      SETFLD
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Get the currency decimal places of CLS ccy
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      PYCCY         PBranch
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = PBranch
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise output fields
 
     C                   EVAL      ActionCode = CLSACT
     C                   EVAL      CurTrCLSP = *BLANKS
     C                   EVAL      CLSACT = ActionCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set Output Screen Fields
      *****************************************************************
     C     SETFLD        BEGSR
 
      ** CLS Currency
 
     C                   EVAL      CLSCCY = PYCCY
 
      ** CLS Nostro
 
     C                   EVAL      CLSNST = PYNOST
 
      ** CLS Value Date
 
     C                   MOVE      PYVDAT        PZDayNo
     C                   EXSR      SrCvtDate
     C                   MOVE      PZDateN       CLSVDT
 
      ** CLS Sequence number
 
     C                   MOVE      PYSEQN        CLSSEQ
 
      ** CLS Profit Centre
 
     C                   EVAL      CLSPRF = PYPRFC
 
      ** CLS Time (CET)
 
     C                   EVAL      CLSTIM = PYLTIM
 
      ** CLS Amount
 
     C                   IF        PYAMT = *ZERO
     C                   EVAL      CLSAMT = *BLANKS
     C                   ELSE
     C                   Z-ADD     PYAMT         PZAmount
     C                   EXSR      SrFmtAmt
     C                   EVAL      CLSAMT = PZAmtD
     C                   ENDIF
 
      ** CLS Time difference
 
     C                   EVAL      CLSTMD = PYTIMD
 
      ** Generated Flag
     C                   EVAL      CLSGNT = PYGENT
                                                                                             BUG5671
      ** CLS Detail Sequence                                                                 BUG5671
                                                                                             BUG5671
     C                   MOVE      PYDSEQ        CLSDSQ                                      BUG5671
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCvtDate - Convert Day number to DDMMYY (OR MMDDYY)         *
      *****************************************************************
     C     SrCvtDate     BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         PZDateN
     C                   PARM      *BLanks       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFmtAmt - Format Amount for Display                         *
      *****************************************************************
     C     SrFmtAmt      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    PZAmount
     C                   PARM      A6NBDP        PZDecPl
     C                   PARM      BNDCSP        PZDecSep
     C                   PARM      *BLANK        PZAmtP
     C                   PARM      *BLANK        PZAmtD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input parameters:
 
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Pay-in Schedule in file format - Detail
     C                   PARM                    CLSPFilFmt
 
      ** Output parameters:
 
      ** Pay-in Schedule in screen format - Detail
     C                   PARM                    CurTrCLSP
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'FXCLSPCV2'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
