     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Time Zone Code Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001105  Midas SD Time Zone Selection for Report            *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user to select on the data by year and DST    *
      *             code for the report.                              *
      *                                                               *
      *  Component of: SD001105P Midas SD Time Zone Report Program    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG19930           Date 14Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG19930 - After typing "?" the selection screen of time     *
      *             zone did not appear.                              *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD DST Code Report - Prompt
     FSD001105DFCF   E             WORKSTN
      *
      ** Midas SD Time Zone File by DST Code
     FSDTIZOL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Time Zone File by Time Zone Code
     FSDTIZOL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTIZOD0:@TIZOL3)
      *                                                                                     BUG19930
      ** Midas SD DST Code Retrieval File                                                   BUG19930
     FSDDSTCl1  IF   E           K DISK    INFSR(*PSSR)                                     BUG19930
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  10-12     Field Error - highlight screen fields              *
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
      * SRValTZCD     - Validate Time Zone Code                       *
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
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Daylight Saving Time Code
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
      *
      ** Externally described DS for Time Zone Code
     D SDTIZO        E DS                  EXTNAME(SDTIZOPD)
 
      ** Output DS
     D POutFlds        DS           100
     D  PLTZCD                 1     10A
     D  PLYEAR                11     14A
     D  PLDSCD                15     24A
 
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
      *                                                                                     BUG19930
      ** Entry Parameters for SD001006S                                                     BUG19930
     D PDscdR          S             10A                                                    BUG19930
     D PYearR          S              4A                                                    BUG19930
      ** Entry Parameters for AOTIZOR0                                                      BUG19930
     D TTZCDR          S             10A                                                    BUG19930
     D TYEAR           S              4A                                                    BUG19930
      *                                                                                     BUG19930
      ** Variable to determine the position of "?"                                          BUG19930
     D WPos            S              2S 0                                                  BUG19930
 
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
      ** If entries are all blanks default it to '*ALL'.
      *
     C                   IF        SLDSCD = *BLANKS AND SLYEAR = *BLANKS
     C                             AND SLTZCD = *BLANKS
     C                   EVAL      SLTZCD = All
     C                   EVAL      SLDSCD = All
     C                   EVAL      SLYEAR = All
     C                   EVAL      WScrn = 'P'
     C                   EXSR      SRProc
     C                   ENDIF
     C                   RETURN
 
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
     C                   CLEAR                   SLTZCD
     C                   CLEAR                   SLDSCD
     C                   CLEAR                   SLYEAR
      *
      ** Year is defaulted to *ALL
      *
     C                   EVAL      SLYEAR = All
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : SRValTZCD, SRValDSCD, SRValYear                  *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
      *
      ** Validate details entered.
      *
     C                   EXSR      SRValTZCD
     C                   EXSR      SRValDSCD
     C                   EXSR      SRValYear
      *
      ** If no errors, update output parameter field.
      *
     C**********         IF        *IN10 = *OFF                                             BUG19930
     C**********                   AND *IN11 = *OFF                                         BUG19930
     C**********                   AND *IN12 = *OFF                                         BUG19930
     C**********         EVAL      WScrn = 'U'                                              BUG19930
     C**********         ENDIF                                                              BUG19930
     C                   IF        *IN10 = *ON                                              BUG19930
     C                             OR *IN11 = *ON                                           BUG19930
     C                             OR *IN12 = *ON                                           BUG19930
     C                   EVAL      WScrn = 'P'                                              BUG19930
     C                   ENDIF                                                              BUG19930
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
     C                   EVAL      PLYEAR = SLYEAR
     C                   EVAL      PLDSCD = SLDSCD
     C                   EVAL      PLTZCD = SLTZCD
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
      *  Called by : SRValTZCD, SRValDSCD, SRValYear                  *
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
     C                   WRITE     SD001105D3
     C                   WRITE     SD001105D1
     C                   EXFMT     SD001105D0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000'        *IN(10)
      *                                                                                     BUG19930
      ** If no errors, update output parameter field.                                       BUG19930
      *                                                                                     BUG19930
     C                   IF        *IN10 = *OFF                                             BUG19930
     C                             AND *IN11 = *OFF                                         BUG19930
     C                             AND *IN12 = *OFF                                         BUG19930
     C                   EVAL      WScrn = 'U'                                              BUG19930
     C                   ENDIF                                                              BUG19930
 
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
     C                   IF        SLYEAR <> *BLANKS AND
     C                             SLYEAR <> '*ALL'
     C                   IF        %CHECK(Digits: %TRIM(SLYEAR)) <> 0
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SWF0002'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
      ** Must be from 1900 and 2100.
      *
     C                   MOVEL     SLYEAR        WYear#
     C                   IF        WYear# < 1900 or WYear# > 2100
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SWF0002'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
 
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
      *                                                                                     BUG19930
      ** Selection of DST Code                                                              BUG19930
      *                                                                                     BUG19930
     C                   EVAL      WPos = %SCAN('?':SLDSCD)                                 BUG19930
     C                   IF        WPos <> *ZEROS                                           BUG19930
     C                   CALL      'SD001006S'                                              BUG19930
     C                   PARM                    PrtCd                                      BUG19930
     C                   PARM                    PDscdR                                     BUG19930
     C                   PARM                    PYearR                                     BUG19930
      *                                                                                     BUG19930
     C                   EVAL      SLDSCD = PDscdR                                          BUG19930
     C                   EVAL      WScrn = 'P'                                              BUG19930
     C                   ENDIF                                                              BUG19930
      *
      ** Check if Daylight Saving Time Code is valid.
      *
     C                   IF        SLDSCD <> *BLANKS AND
     C                             %TRIM(SLDSCD) <> All
     C*****SLDSCD        CHAIN     SDTIZOL2                                                 BUG19930
     C     SLDSCD        CHAIN     SDDSTCL1                                                 BUG19930
      *
      ** Daylight Saving Time Code must be valid.
      *
     C**********         IF        NOT %FOUND(SDTIZOL2)                                     BUG19930
     C                   IF        NOT %FOUND(SDDSTCL1)                                     BUG19930
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'SWF0021'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTZCD -  Validate Time Zone Code                         *
      *                                                               *
      *  Called by : SRVal                                            *
      *                                                               *
      *  Calls     : SRSndM                                           *
      *                                                               *
      *****************************************************************
     C     SRValTZCD     BEGSR
      *                                                                                     BUG19930
      ** Selection of Time Zone Code                                                        BUG19930
      *                                                                                     BUG19930
     C                   EVAL      WPos = %SCAN('?':SLTZCD)                                 BUG19930
     C                   IF        WPos <> *ZEROS                                           BUG19930
     C                   EVAL      WScrn = 'P'                                              BUG19930
     C                   EVAL      TTZCDR = SLTZCD                                          BUG19930
     C                   EVAL      TYEAR = SLYEAR                                           BUG19930
     C                   CALL      'AOTIZOR0'                                               BUG19930
     C                   PARM      *BLANKS       PRtcd                                      BUG19930
     C                   PARM      '*KEY'        POptn                                      BUG19930
     C                   PARM                    TTZCDR                                     BUG19930
     C                   PARM                    TYEAR                                      BUG19930
     C                   PARM                    SDTIZO                                     BUG19930
      *                                                                                     BUG19930
     C                   IF        PRtcd  <> *BLANKS                                        BUG19930
     C                   EVAL      PMsgId = 'SWF0032'                                       BUG19930
     C                   EVAL      *IN12 = *ON                                              BUG19930
     C                   EXSR      SRSndM                                                   BUG19930
     C                   ELSE                                                               BUG19930
     C                   EVAL      SLTZCD = TTZCDR                                          BUG19930
     C                   ENDIF                                                              BUG19930
     C                   ENDIF                                                              BUG19930
      *
      ** Check if Time Zone Code is valid.
      *
     C                   IF        SLTZCD <> *BLANKS AND
     C                             %TRIM(SLTZCD) <> All
     C     SLTZCD        CHAIN     SDTIZOL3
      *
      ** Time Zone Code must be valid.
      *
     C                   IF        NOT %FOUND(SDTIZOL3)
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'SWF0032'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
      *
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
      *
     C                   EVAL      WScrn = 'P'
      *
     C                   EVAL      PMsgf = 'GBSDUSRMSG'
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PSUser
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      SPGM = '*'
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
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
(c) Finastra International Limited 2008
