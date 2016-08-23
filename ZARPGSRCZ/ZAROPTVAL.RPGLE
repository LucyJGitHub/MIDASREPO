     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Repair option code validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAROPTVAL - REPAIR OPTION CODE VALIDATION                    *
      *                                                               *
      *  Function:  This screen function validates option codes       *
      *             input to the repair browse screens                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014  *CREATE    Date 29Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP014 - Repair function enhancements                        *
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
 
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
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
      *
      * Initialization
      *
     C                   EXSR      INIT
      *
      * Validate option code
      *
     C                   EXSR      VALID
      *
      * Do screen processing until option code is valid, or F3 or F12 taken
      *
     C     OPT_VALID     DOWNE     'Y'
     C     @INKC         ANDEQ     '0'
     C     @INKL         ANDEQ     '0'
     C                   EXSR      SCREEN
     C                   ENDDO
      *
      *  Close down program
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
      *
      *  Return
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *   SCREEN - Screen Processing                                 *
      *                                                              *
      ****************************************************************
     C     SCREEN        BEGSR
      *
     C                   TIME                    DDTIME
      *
      *** Output screen
      *
     C                   EXFMT     ZAROPTF1
     C                   MOVE      '0'           *IN(81)
      *
      ** If F3 pressed, set return code
      *
     C                   SELECT
     C     *INKC         WHENEQ    '1'
     C                   MOVE      '1'           @INKC
      *
      ** If F12 pressed, set return code
      *
     C     *INKL         WHENEQ    '1'
     C                   MOVE      '1'           @INKL
      *
      ** If not any of the above, validate the input option code.
      *
     C                   OTHER
 
     C                   EXSR      VALID
      *
     C                   ENDSL
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *   VALID  - Validate option code                              *
      *                                                              *
      ****************************************************************
     C     VALID         BEGSR
      *
      ** Initialize 'option valid' indicator
      *
     C                   MOVE      'Y'           OPT_VALID         1
      *
      **  Option can't be blank
      *
     C     DDOPT         IFEQ      ' '
     C                   MOVE      *ON           *IN81
     C                   MOVEL     *BLANK        DDERR
     C                   EVAL      DDERR  = (OptBlank + ' '
     C                                       + ValOpt)
     C                   MOVE      'N'           OPT_VALID
     C                   ELSE
      *
      **  Option must be a valid option for this function
      *
     C                   Z-ADD     1             @X
     C     DDOPT         LOOKUP    VOPT(@X)                               99    *
     C     *IN99         IFEQ      '0'
     C                   MOVE      *ON           *IN81
     C                   MOVEL     *BLANK        DDERR
     C                   EVAL      DDERR  = (OptInErr + ' '
     C                                       + ValOpt)
     C                   MOVE      'N'           OPT_VALID
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
      *                                                              *
      * INIT - Initial processing                                    *
      *                                                              *
      ****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVEL     *BLANK        RetCodeIn
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
      * Set up initial option code and front office ID
      * for output to the screen
      *
     C                   MOVE      DDOPT         DDIOPT
     C**********         MOVE      DDFOTRANID    DDFOID                                       CGL029
     C                   MOVEL     DDFOTRANID    DDFOID                                       CGL029
      *
      * Clear valid options & descriptions arrays
      *
     C                   CLEAR                   VOPT
     C                   CLEAR                   VODES
      *
      ** Load valid options for this user/program/branch
      *
     C                   Z-ADD     1             @X                2 0
     C                   Z-ADD     1             @Y                2 0
     C     @X            DOWLE     4
     C     AOPT(@X)      ANDNE     *BLANK
 
      ** If single branch environment
      **   Validate action codes for user
      ** Otherwise (if multi-branching)
      **   Check user authority to action/branch
 
     C                   Z-ADD     0             ERR
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   ELSE
     C                   EXSR      ACSSEM
     C                   ENDIF
 
     C     ERR           IFEQ      0
     C                   MOVEL     AOPT(@X)      VOPT(@Y)
     C                   MOVEL     AODES(@X)     VODES(@Y)
     C                   ADD       1             @Y
     C                   ENDIF
 
     C                   ADD       1             @X
 
     C                   ENDDO
      *
      ** Set fields on screen
      *
     C                   MOVEL     VOPT(1)       DDOPT1
     C                   MOVEL     VOPT(2)       DDOPT2
     C                   MOVEL     VOPT(3)       DDOPT3
     C                   MOVEL     VOPT(4)       DDOPT4
     C                   MOVEL     VODES(1)      ODS1MSG
     C                   MOVEL     VODES(2)      ODS2MSG
     C                   MOVEL     VODES(3)      ODS3MSG
     C                   MOVEL     VODES(4)      ODS4MSG
      *
      ** Store number of last option
      *
     C     @Y            SUB       1             @LOP              2 0
      *
      ** If user is authorized to no options report this fact
      *
     C     @LOP          IFEQ      *ZERO
     C                   Z-ADD     1             @LOP
     C                   MOVEL     OptNone1      VODES(1)
     C                   MOVE      OptNone2      VODES(1)
     C                   MOVEL     *BLANK        ValOpt           32
     C                   ELSE
      *
      ** Otherwise, list available options
      *
     C                   SELECT
     C     VOPT(4)       WHENNE    ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2) + ',' + VOPT(3)
     C                                     + ',' + VOPT(4))
     C     VOPT(3)       WHENNE    ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2) + ',' + VOPT(3))
     C     VOPT(2)       WHENNE    ' '
     C                   EVAL      ValOpt = (PossVal + VOPT(1) + ','
     C                                     + VOPT(2))
     C                   OTHER
     C                   EVAL      ValOpt = (PossVal + VOPT(1))
     C                   ENDSL
 
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING         *
      *                                                              *
      ****************************************************************
     C     ACSSES        BEGSR
      *
      ** Validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      AOPT(@X)      ZACTN             1
     C                   PARM      *ZERO         ERR               1 0
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING          *
      *                                                              *
      ****************************************************************
     C     ACSSEM        BEGSR
      *
      * If booking branch is not supplied use the user's default
      *
     C     BookBranch    IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   ELSE
     C                   MOVE      BookBranch    ZBR
     C                   END
      *
      ** Check that the branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      ZBR           @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** If it is a valid branch then check the user authority
      ** to the action/branch
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      AOPT(@X)      ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM      *ZERO         ERR               1 0
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
      *                                                              *
      * *INZSR Processing                                            *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
 
      * INPUTS
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Option code
      * Front Office ID
      * Booking Branch
     C                   PARM                    DDOPT             1
     C                   PARM                    DDFOTRANID       20
     C                   PARM                    BookBranch        3
 
      * ICD Single branch code
     C                   PARM                    BJSBRC            3
 
      * OUTPUTS
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      **  Run date in DDMMMYY
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      ** Initialize program name
      *
     C                   MOVEL     'ZAROPTVAL '  DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      *
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
(c) Misys International Banking Systems Ltd. 2001
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
