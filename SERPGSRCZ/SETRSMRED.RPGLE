     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements details read')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMRED - Trade Settlements Details Read                   *
      *                                                               *
      *  Function: This module reads forwards and backwards           *
      *            through the Trade Settlements Details File.        *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAP182  *CREATE    Date 05Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChkAut   - Check for user authority if not multi-branching *
      *  SrValKey   - Validate Event Date                             *
      *  SrReadFwd  - Read forwards through the Trade Settlement      *
      *               details file                                    *
      *  SrReadBck  - Read backwards through the Trade Settlement     *
      *               details file                                    *
      *  SrZDate1   - Validate and convert date to day number         *
      *  SrZDate2   - Convert Midas Date into DDMMYY or MMDDYY        *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Trade Settlement details file.
     FSETLEL12  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Indicator array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             10     10
     D  StrOfFile             10     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Parameters for ZVACTU/ZVACTBU
     D PActn           S              1A
     D PBrc            S              3A
     D PError          S              1P 0
      *
      ** Entry parameters
     D DDTRDR          S              6A
     D DDMVDT          S              6A
     D DDFSET          S              1A
     D DDREVE          S              1A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D PErrMs          S              7A
     D PTRADSel        S              6A
     D PMVDTSel        S              6A
     D PFSETSel        S              1A
     D PREVESel        S              1A
     D PSEQNSel        S              3  0
      *
      ** Work Variables
     D WSDED           S              5P 0
      *
      ** Parameter list for ZDATE1
     D PDateAIn        S              6A
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZDATE2
     D PDateNIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialisation.
      *
      ** Key list
     C     KeyTD         KLIST
     C                   KFLD                    KMVDT             5 0
     C                   KFLD                    DDTRDR
     C                   KFLD                    SSQN
      *
     C                   Eval      PTRADSel = *BLANKS
     C                   Eval      PMVDTSel = *BLANKS
     C                   Eval      PFSETSel = *BLANKS
     C                   Eval      PREVESel = *BLANKS
     C                   Z-Add     *Zeros        PSEQNSel
     C                   Eval      PErrMs   = *BLANKS
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   If        BJSBRC <> *BLANKS
     C                   Exsr      SrChkAut
     C                   EndIf
      *
      ** Validate event date (for pointer).
     C                   Exsr      SrValKey
      *
      ** Read forwards.
     C                   If        PRdFwd = 'Y'
     C                   Exsr      SrReadFwd
     C                   Else
      *
      ** Read backwards.
     C                   If        PRdBck = 'Y'
     C                   Exsr      SrReadBck
     C                   EndIf
 
     C                   EndIf
      *
      ** Return.
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
 
     C     SrChkAut      BEGSR
 
     C                   Call      'ZVACTU'
     C                   Parm      'E'           PActn
     C                   Parm      *ZERO         PError
      *
      ** Return error message.
      *
     C     PError        Ifeq      1
     C                   Eval      PErrMs = 'FXM0292'
     C                   RETURN
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValKey - Validate Event Date                               *
      *                                                               *
      *****************************************************************
 
     C     SrValKey      BEGSR
      *
      ** Access ZDATE1 to validate and convert date to midas day number.
      *
     C                   If        DDMVDT <> *BLANKS
      *
     C                   If        DDMVDT <> '999999'
      *
     C                   Movel     DDMVDT        PDateAIn
     C                   Exsr      SrZDate1
     C                   If        PErrorFlag = 'Y'
     C                   Eval      PErrMs = 'USR2031'
     C                   RETURN
     C                   Else
     C                   Z-Add     PDaynoOut     KMVDT
     C                   EndIf
      *
     C                   Else
     C                   Z-Add     99999         KMVDT
     C                   EndIf
      *
     C                   Else
     C                   Z-Add     *ZERO         KMVDT
     C                   EndIf
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadFwd - Read forwards through the Trade Settlement       *
      *              details file                                     *
      *                                                               *
      *****************************************************************
 
     C     SrReadFwd     BEGSR
      *
      ** Position to current record on file.
      *
     C     KeyTD         SETGT     SETLEL12
      *
      ** Read until end of file or a valid record is found.
      *
     C                   DOU       EndOfFile = True OR PError = *ZERO
 
     C                   READ      SETLEL12                               10
      *
      ** If not end of file.
     C                   If        EndOfFile = False
      *
      ** If multi-branching, check if authorized to look at security
      ** (based on default branch).  If invalid, continue searching
      ** for until a valid record is read.
     C                   If        BJSBRC = *BLANKS
     C                   Call      'ZVACTBU'
     C                   Parm      'E'           PActn
     C                   Parm      PDBRN         PBrc
     C                   Parm      *ZERO         PError
     C                   EndIf
 
     C                   EndIf
 
     C                   EndDo
      *
      ** If end of file was encountered, report this fact.
     C                   If        EndOfFile = True
 
     C                   If        DDTRDR = *Blanks And DDMVDT = *Blanks
     C                             And DDFSET = *Blanks And DDREVE = *Blanks
     C                   Eval      PErrMs = 'MMM1006'
     C                   Else
     C                   Eval      PErrMs = 'MMM1002'
     C                   EndIf
      *
      ** Else, return the Trade Settlement Details read.
      *
     C                   Else
      *
      ** Trade Reference
     C                   Eval      PTRADSel = STDR
      *
      ** Full Settlement
     C                   Eval      PFSETSel = SFSI
      *
      ** Reversal
     C                   Eval      PREVESel = SRIN
      *
      ** If Movement day  number is 99999, set date to '999999'.
      ** Otherwise, convert event day number to event date format.
     C                   If        SEDE = 99999
     C                   Eval      PMVDTSel = *ALL'9'
     C                   Else
 
     C                   Z-Add     SEDE          PDateNIn
     C                   Exsr      SrZDate2
     C                   Movel     PDateOut      PMVDTSel
     C                   EndIf
      *
      ** Sequence Number
     C                   Z-Add     SSQN          PSEQNSel
      *
     C                   EndIf
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReadBck - Read backwards through the Security Trade        *
      *              Settlement Details File                          *
      *                                                               *
      *****************************************************************
 
     C     SrReadBck     BEGSR
      *
      ** Position to current record on file.
      *
     C     KeyTD         SETLL     SETLEL12
      *
      ** Read until start of file or a valid record is found.
      *
     C                   DOU       StrOfFile = True OR PError = *ZERO
 
     C                   READP     SETLEL12                               10
      *
      ** Record found.
     C                   If        StrOfFile = False
      *
      ** If multi-branching, check if authorized to look at Trade
      ** Settlement details (based on default branch). If invalid, continue
      ** searching for until a valid record is read.
      *
     C     BJSBRC        Ifeq      *BLANKS
     C                   Call      'ZVACTBU'
     C                   Parm      'E'           PActn
     C                   Parm      PDBRN         PBrc
     C                   Parm      *ZERO         PError
     C                   EndIf
 
     C                   EndIf
 
     C                   EndDo
      *
      ** If start of file was encountered, report this fact.
     C                   If        StrOfFile = True
     C                   Eval      PErrMs = 'MMM1003'
      *
      ** Else, return the Trade Settlement Details read.
     C                   Else
      *
      ** Trade Reference
     C                   Eval      PTRADSel = STDR
      *
      ** Full Settlement
     C                   Eval      PFSETSel = SFSI
      *
      ** Reversal
     C                   Eval      PREVESel = SRIN
      *
      ** If event day number is 99999, set event date to '999999'.
      ** Otherwise, convert event day number to event date format.
     C                   If        SEDE = 99999
     C                   Eval      PMVDTSel = *ALL'9'
     C                   Else
     C                   Z-Add     SEDE          PDateNIn
     C                   Exsr      SrZDate2
     C                   Movel     PDateOut      PMVDTSel
     C                   EndIf
      *
      ** Sequence Number
     C                   Z-Add     SSQN          PSEQNSel
      *
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR
 
     C                   CallB     'ZDATE1'
     C                   Parm                    PDateAIn
     C                   Parm      *ZERO         PDaynoOut
     C                   Parm                    BJDFIN
     C                   Parm      *Blanks       PErrorFlag
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CallB     'ZDATE2'
     C                   Parm                    PDateNIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *Blanks       PADateOut
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
      *
      ** Read backwards
     C                   PARM                    PRdBck
      *
      ** Read forwards
     C                   PARM                    PRdFwd
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      **  Trade Reference Number
      **  Movement Date
      **  Full Settlement
      **  Reversal
      **  Sequence Number
     C                   PARM                    PTRADSel
     C                   PARM                    PMVDTSel
     C                   PARM                    PFSETSel
     C                   PARM                    PREVESel
     C                   PARM                    PSEQNSel
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
