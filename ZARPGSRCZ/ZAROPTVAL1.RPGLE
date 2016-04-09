     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Repair option code validation for GL API')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAROPTVAL1 - Repair Option Code Validation for GL API only   *
      *                                                               *
      *  Function:  This screen function validates option codes       *
      *             input to the repair browse screens                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029   *CREATE   Date 01Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAROPTVDF CF   E             WORKSTN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
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
 
     D PossVal         C                   CONST('Possible values are: ')
     D OptNone1        C                   CONST('No Authority to any options ')
     D OptNone2        C                   CONST('- Press enter to exit      ')
     D OptBlank        C                   CONST('Option code must be input.')
     D OptInErr        C                   CONST('Invalid option code.')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Available options/descriptions
     D AOPT            S              1    DIM(4) CTDATA PERRCD(1)
     D AODES           S              7    DIM(4) CTDATA PERRCD(1)
 
      * Valid (for user) options/descriptions
     D VOPT            S              1    DIM(4)
     D VODES           S              7    DIM(4)
 
      * Parameter/Work Variables
     D PRtCd           S              7
     D POptn           S              7
     D PBrch           S              3
     D PActn           S              1
     D PFrntOfcID      S             40
     D WBrch           S              3
     D WErrC           S              1  0
     D Wx              S              2  0
     D Wy              S              2  0
     D WLOp            S              2  0
     D WOptVal         S              1
     D WBkBrch         S              3
     D BJSBRC          S              3
 
      * Function Keys
     D PInKC           S              1
     D PInKL           S              1
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  DATFMT                12     12
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Validate option code
 
     C                   EXSR      SrValid
 
      ** Do screen processing until option code is valid, or F3 or F12 taken
 
     C                   DOW       WOptVal <> 'Y' AND PInKC = '0' AND
     C                             PInKL = '0'
     C                   EXSR      SRScrnProc
     C                   ENDDO
 
      ** Close down program
 
     C                   IF        PInKC = '1'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRScrnProc - Screen Processing                              *
      *                                                              *
      ****************************************************************
     C     SRScrnProc    BEGSR
 
     C                   TIME                    DDTIME
 
      ** Output screen
 
     C                   EXFMT     ZAROPTF1
     C                   EVAL      *IN81 = *OFF
 
     C                   SELECT
 
      ** If F3 pressed, set return code
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      PInKC = '1'
 
      ** If F12 pressed, set return code
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      PInKL = '1'
 
      ** If not any of the above, validate the input option code.
 
     C                   OTHER
 
     C                   EXSR      SrValid
 
     C                   ENDSL
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SrValid - Validate Option Code                              *
      *                                                              *
      ****************************************************************
     C     SrValid       BEGSR
 
      ** Initialize 'option valid' indicator
 
     C                   MOVE      'Y'           WOptVal
 
      ** Option can not be blank
 
     C     DDOPT         IFEQ      ' '
     C                   MOVE      *ON           *IN81
     C                   MOVEL     *BLANK        DDERR
     C                   EVAL      DDERR  = (OptBlank + ' '
     C                                       + ValOpt)
     C                   EVAL      WOptVal = 'N'
     C                   ELSE
 
      ** Option must be a valid option for this function
 
     C                   Z-ADD     1             Wx
     C     DDOPT         LOOKUP    VOPT(Wx)                               99
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   MOVEL     *BLANK        DDERR
     C                   EVAL      DDERR  = (OptInErr + ' '
     C                                       + ValOpt)
     C                   EVAL      WOptVal = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
      *                                                              *
      *  SRInit - Initial Processing                                 *
      *                                                              *
      ****************************************************************
     C     SRInit        BEGSR
 
      ** Clear outputs
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      PInKC = '0'
     C                   EVAL      PInKL = '0'
 
      ** Set up initial option code and front office ID
      ** for output to the screen
 
     C                   MOVE      DDOPT         DDIOPT
     C                   MOVE      PFrntOfcID    DDFOID
 
      ** Clear valid options & descriptions arrays
 
     C                   CLEAR                   VOPT
     C                   CLEAR                   VODES
 
      ** Load valid options for this user/program/branch
 
     C                   Z-ADD     1             Wx
     C                   Z-ADD     1             Wy
 
     C                   DOW       Wx <= 4  AND AOPT(Wx) <> *BLANK
 
      ** If single branch environment, validate action codes for user
      ** Otherwise (if multi-branching), check user authority to action/branch
 
     C                   Z-ADD     0             WErrC
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRAccSecS
     C                   ELSE
     C                   EXSR      SRAccSecM
     C                   ENDIF
 
     C                   IF        WErrC = 0
     C                   MOVEL     AOPT(Wx)      VOPT(Wy)
     C                   MOVEL     AODES(Wx)     VODES(Wy)
     C                   ADD       1             Wy
     C                   ENDIF
 
     C                   ADD       1             Wx
 
     C                   ENDDO
 
      ** Set fields on screen
 
     C                   MOVEL     VOPT(1)       DDOPT1
     C                   MOVEL     VOPT(2)       DDOPT2
     C                   MOVEL     VOPT(3)       DDOPT3
     C                   MOVEL     VOPT(4)       DDOPT4
     C                   MOVEL     VODES(1)      ODS1MSG
     C                   MOVEL     VODES(2)      ODS2MSG
     C                   MOVEL     VODES(3)      ODS3MSG
     C                   MOVEL     VODES(4)      ODS4MSG
 
      ** Store number of last option
 
     C     Wy            SUB       1             WLOp
 
      ** If user is authorized to no options report this fact
 
     C                   IF        WLOp = *ZERO
     C                   Z-ADD     1             WLOp
     C                   MOVEL     OptNone1      VODES(1)
     C                   MOVE      OptNone2      VODES(1)
     C                   MOVEL     *BLANK        ValOpt           32
     C                   ELSE
 
      ** Otherwise, list available options
 
     C                   SELECT
     C                   WHEN      VOPT(4) <> ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2) + ',' + VOPT(3)
     C                                     + ',' + VOPT(4))
     C                   WHEN      VOPT(3) <> ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2) + ',' + VOPT(3))
     C                   WHEN      VOPT(2) <> ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2))
     C                   OTHER
     C                   EVAL      ValOpt = (PossVal + VOPT(1))
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRAccSecS - Access Security Checking for Single Branching   *
      *                                                              *
      ****************************************************************
     C     SRAccSecS     BEGSR
 
      ** Validate action codes for user
 
     C                   CALL      'ZVACTU'
     C                   PARM      AOPT(Wx)      PActn
     C                   PARM      *ZERO         WErrC
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRAccSecM - Access Security Checking for Multi-branching    *
      *                                                              *
      ****************************************************************
     C     SRAccSecM     BEGSR
 
      ** If booking branch is not supplied use the user's default
 
     C     WBkBrch       IFEQ      *BLANKS
     C                   MOVE      BRC           WBrch
     C                   ELSE
     C                   MOVE      WBkBrch       WBrch
     C                   END
 
      ** Check that the branch code exists on SDBRCHPD
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WBrch         PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      ** If it is a valid branch then check the user authority
      ** to the action/branch
 
     C                   IF        PRtCd = *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      AOPT(Wx)      PActn
     C                   PARM                    WBrch
     C                   PARM      *ZERO         WErrC
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
      *                                                              *
      *  *INZSR - Initial Subroutine                                 *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs:
      ** =======
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Option code
      ** Front Office ID
      ** Booking Branch
     C                   PARM                    DDOPT
     C                   PARM                    PFrntOfcID
     C                   PARM                    WBkBrch
 
      ** ICD Single branch code
     C                   PARM                    BJSBRC
 
      ** Outputs:
      ** ========
 
      ** Function Keys
     C                   PARM                    PInKC
     C                   PARM                    PInKL
 
      ** Get ZMUSER to access default branch.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      ** Run date in DDMMMYY
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
 
      ** Initialize program name
 
     C                   MOVEL     'ZAROPTVAL1'  DBPGM
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** AOPT
E
U
N
Q
** AODES
APA0200
APA0201
APA0202
APA0203
