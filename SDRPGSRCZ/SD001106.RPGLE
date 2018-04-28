     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD DST Code Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001106  SD Daylight Saving Time Code Report Prompt         *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user to select on the data by year and DST    *
      *             code for the report.                              *
      *                                                               *
      *  Component of: SD001106P SD Daylight Saving Time Code Report  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG19929           Date 11Jul08               *
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG19929 - After typing "?" the selection screen of DST      *
      *             codes did not appear.                             *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD DST Code Report - Prompt
     FSD001106DFCF   E             WORKSTN
 
      ** Midas SD DST Code Retrieval file
     FSDDSTCL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  10-11     Field Error - highlight screen fields              *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit        - Initialise Variables                          *
      * SRProc        - Process Inputs                                *
      * SRVal         - Validate Details                              *
      * SRUpdate      - Update Ouput Parameter Fields                 *
      * SRSndM        - Send Message to Screen                        *
      * SRValYear     - Validate Year                                 *
      * SRValDSCD     - Validate DST Code                             *
      * *INZSR        - Program Initialisation                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
      *
      ** Numeric values
     D Digits          C                   Const('0123456789')
      *
     D All             C                   CONST('*ALL')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for Daylight Saving Time Code
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Output DS
     D POutFlds        DS           100
     D  PYEAR                  1      4A
     D  PDSCD                  5     10A
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D WScrn           S              1A
 
     D WYear#          S              4S 0
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
      ** Parameters for module AODSTCR0
     D PDstC           S             10A
     D PDstY           S              4A
     D PRtCd           S              7A
     D POptn           S              7A
 
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
      *                                                                                     BUG19929
      ** Entry Parameters                                                                   BUG19929
     D PDscdR          S             10A                                                    BUG19929
     D PYearR          S              4A                                                    BUG19929
                                                                                            BUG19929
      ** Variable to determine the position of "?"                                          BUG19929
     D WPos            S              2S 0                                                  BUG19929
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise.
      *
     C                   EXSR      SRInit
      *
      ** Process inputs.
      *
     C                   EXSR      SRProc
      *
      ** If entries are both blanks then default it to '*ALL'.
      *
     C                   IF        SDSCD = *BLANKS AND SYEAR = *BLANKS
     C                   EVAL      SDSCD = All
     C                   EVAL      SYEAR = All
     C                   EVAL      WScrn = 'P'
     C                   EXSR      SRProc
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : SRDisp, SRVal, SRUpdate                          *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
      *
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
      *
      ** Do while SCREEN : Read details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
     C                   ENDIF
     C                   ENDDO
      *
      ** Do file update.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C                   CLEAR                   POutFlds
     C                   CLEAR                   SDSCD
     C                   CLEAR                   SYEAR
      *
      ** Year is defaulted to *ALL
      *
     C                   EVAL      SYEAR = All
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : SRValDSCD, SRValYear                             *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
      *
      ** Validate details entered.
      *
     C                   EXSR      SRValDSCD
     C                   EXSR      SRValYear
      *
      ** If no errors, update output parameter field.
      *
     C                   IF        ((*IN10 = *OFF) AND (*IN11 = *OFF))
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update output parameter fields                    *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C                   EVAL      PYEAR = SYEAR
     C                   EVAL      PDSCD = SDSCD
      *
     C                   EVAL      WScrn = 'E'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *  Called by : SRValDSCD, SRValYear                             *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
      *
      ** Call screen message handler.
      *
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    D0TIME
     C                   WRITE     SD001106D3
     C                   WRITE     SD001106D1
     C                   EXFMT     SD001106D0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000'        *IN(10)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValYear - Validate Year                                    *
      *                                                               *
      *  Called by : SRVal                                            *
      *                                                               *
      *  Calls     : SRSndM                                           *
      *                                                               *
      *****************************************************************
     C     SRValYear     BEGSR
      *
      ** Must be numeric.
      *
     C                   IF        SYEAR <> *BLANKS AND
     C                             SYEAR <> '*ALL'
     C                   IF        %CHECK(Digits: %TRIM(SYEAR)) <> 0
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SWF0002'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** Must be from 1900 and 2100.
      *
     C                   MOVEL     SYEAR         WYEAR#
     C                   IF        WYear# < 1900 or WYear# > 2100
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SWF0002'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDSCD -  Validate DST Code                               *
      *                                                               *
      *  Called by : SRVal                                            *
      *                                                               *
      *  Calls     : SRSndM                                           *
      *                                                               *
      *****************************************************************
     C     SRValDSCD     BEGSR
      *
      ** Check if Daylight Saving Time Code is valid.
      *
     C                   EVAL      WPos = %SCAN('?':SDSCD)                                  BUG19929
     C                   DOW       WPos <> *ZEROS                                           BUG19929
     C                   CALL      'SD001006S'                                              BUG19929
     C                   PARM                    PrtCd                                      BUG19929
     C                   PARM                    PDscdR                                     BUG19929
     C                   PARM                    PYearR                                     BUG19929
      *                                                                                     BUG19929
     C                   EVAL      SDSCD = PDscdR                                           BUG19929
     C                   EVAL      SYEAR = PYearR                                           BUG19929
     C                   WRITE     SD001106D3                                               BUG19929
     C                   WRITE     SD001106D1                                               BUG19929
     C                   EXFMT     SD001106D0                                               BUG19929
     C                   EVAL      WPos = %SCAN('?':SDSCD)                                  BUG19929
     C                   ENDDO                                                              BUG19929
      *                                                                                     BUG19929
     C                   IF        SDSCD <> *BLANKS AND
     C                             %TRIM(SDSCD) <> All
     C     SDSCD         CHAIN     SDDSTCL1
      *
      ** Daylight Saving Time Code must be valid.
      *
     C                   IF        NOT %FOUND(SDDSTCL1)
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'SWF0021'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *  Called by : Start of the program                             *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAct
     C                   PARM                    PCmd
      *
      ** Call The Access Object AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C                   EVAL      WScrn = 'P'
      *
     C                   EVAL      PMsgf = 'GBSDUSRMSG'
      *
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PSUser
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      SPGM = '*'
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
