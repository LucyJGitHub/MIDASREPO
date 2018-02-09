     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE MT101/MT103 Generation by Sweep Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102009 - RE MT101/MT103 Generation by Sweep Prompt         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error exist in dates                            *
      *    02         Error exist in From Date                        *
      *    03         Error exist in To Date                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRDATE - Date Validation                                      *
      * SRRTVTXT - Retrieve Text                                      *
      * SREND  - Terminate Program                                    *
      *                                                               *
      * *INZSR - Initialise                                           *
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
 
      ** MT101/MT103 Generation by Sweep Display File
     FRE102009DFCF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Array for month shortnames
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      **  Parameters for &RPARM - 100 long string passed to RCF
     D PRPARM          DS           100
     D  @@RPRM                 1     12
     D  WFMDAT                 1      6
     D  @FMDAT                 1      6  0
     D  @@FMYY                 1      2
     D  @@FMMM                 3      4
     D  @@FMDD                 5      6
     D  @TODAT                 7     12  0
     D  WTODAT                 7     12
     D  @@TOYY                 7      8
     D  @@TOMM                 9     10
     D  @@TODD                11     12
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for calling program ZA0340
     D PMsgId          S             10A
     D PMsgNm          S             10A
 
      ** Parameters for calling program ZAVDATE
     D PDayNum         S              5  0
     D ReturnCode      S             10A
 
      ** Parameters for program entry
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D PAct            S              1
     D PCmd            S              1
 
     D FMDayn          S              5  0
     D TODayn          S              5  0
     D @@FMDM          S              4A
     D @@TODM          S              4A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SREND
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      **  Display initial screen
 
     C                   WRITE     RE102009C0
     C                   EXFMT     RE102009F0
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRDATE, ZA0250                                         *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      *IN01 = *ON
 
      ** Do while not F3/F12 or error outstanding
 
     C                   DOW       *INKC = *OFF and *INKL = *OFF
     C                             and *IN01 = *ON
 
      ** Validate From and To Dates
 
     C                   EXSR      SRDATE
 
      ** If error exist, display initial screen
 
     C                   IF        *IN01 = *ON
     C                   WRITE     RE102009C0
     C                   EXFMT     RE102009F0
     C                   CALL      'ZA0250'
     C                   MOVEA     '000'         *IN(02)
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Validate From and To Dates                           *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZAVDATE, SRRtvTxt                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   EVAL      *IN01 = *OFF
     C                   RESET                   PMsgId
 
      **  Validation of FROM dates entered
 
     C                   IF        SFMDAT <> *BLANKS
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    SFMDAT
     C                   PARM                    BJDFIN
     C                   PARM                    PDayNum
 
     C                   Z-ADD     PDayNum       FMDayN
 
      **  If the return code is 'Error' then the input date is invalid or
      **  non-numeric.
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      PMsgId = 'RE75957'
     C                   EVAL      *IN01 = *ON
     C                   EVAL      *IN02 = *ON
     C                   EXSR      SRRtvTxt
     C                   ENDIF
     C                   ENDIF
 
      ** Validation of TO dates entered
 
     C                   IF        STODAT <> *BLANKS
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    STODAT
     C                   PARM                    BJDFIN
     C                   PARM                    PDayNum
 
     C                   Z-ADD     PDayNum       TODayN
 
      **  If the return code is 'Error' then the input date is invalid or
      **  non-numeric.
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      PMsgId = 'RE75957'
     C                   EVAL      *IN01 = *ON
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRRtvTxt
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SFMDAT <> *BLANKS and STODAT <> *BLANKS
     C                             and FMDayN > TODayN
     C                   EVAL      PMsgId = 'RE75958'
     C                   EVAL      *IN01 = *ON
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRRtvTxt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRTVTXT - Retrieve Text                                      *
      *                                                               *
      * Called by: SRDATE                                             *
      *                                                               *
      * Calls: ZA0340                                                 *
      *                                                               *
      *****************************************************************
     C     SRRTVTXT      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM      'REUSRMSG'    PMsgNm
     C                   PARM                    PMsgId
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Terminate Program                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREND         BEGSR
 
      **  If F3 was pressed send termination code of 'E' back to RCF
 
     C                   IF        *INKC = *ON
     C                   EVAL      PCmd = 'E'
     C                   ENDIF
 
      **  If F12 was pressed send termination code of 'F' back to RCF
 
     C                   IF        *INKL = *ON
     C                   EVAL      PCmd = 'F'
     C                   ENDIF
 
     C                   IF        *INKC = *OFF  and *INKL = *OFF
 
     C                   IF        SFMDAT <> *BLANKS
     C                   MOVE      SFMDAT        @@FMYY
     C                   EVAL      @@FMDM = SFMDAT
     C                   EVAL      @@FMDD = @@FMDM
     C                   MOVE      @@FMDM        @@FMMM
     C                   ENDIF
 
     C                   IF        STODAT <> *BLANKS
     C                   MOVE      STODAT        @@TOYY
     C                   EVAL      @@TODM = STODAT
     C                   EVAL      @@TODD = @@TODM
     C                   MOVE      @@TODM        @@TOMM
     C                   ENDIF
 
     C                   IF        SFMDAT = *BLANKS And
     C                             STODAT = *BLANKS
     C                   MOVE      *BLANKS       PRParm
     C                   MOVE      '*ALL  '      WFMDAT
     C                   MOVE      '*ALL  '      WTODAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       PRParm
 
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
     C                   RETURN
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PRParm
     C                   PARM                    PAct
     C                   PARM                    PCmd
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0PGM = '*'
     C                   TIME                    #0TIME
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R --- A B N O R M A L  E R R O R  C O N D I T I O N S
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
**  ZMNM - used to convert RUNDAT to DDMMYY format
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
