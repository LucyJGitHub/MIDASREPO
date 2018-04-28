     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Date Schedule Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MM0091 - Date Schedule Maintenance                           *
      *                                                               *
      *  Function:  This program allows the user to enter a number    *
      *  (I/C)      of date schedule for rate change date and         *
      *             payment date. The program will return the first   *
      *             unprocessed date to the calling program.          *
      *                                                               *
      *  Called by: DL0170, MMLDNICHD, MMLDNIRPR, MMLDNISIN, MM0090   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL033  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL033 - Floating Rate CDs Issued                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    01         Subfile display                                 *
      *    02         Subfile Ctl display                             *
      *    03         Subfile Ctl End                                 *
      *    04         Subfile record                                  *
      *    05         Subfile rollup                                  *
      *    06         Subfile rolldown                                *
      *    10         Subfile Action Code                             *
      *    11         Subfile Ctl Action Code                         *
      *    12         Subfile Ctl Date                                *
      *    13         Subfile Ctl Holiday indicator                   *
      *    14         Subfile Ctl Copy Schedule                       *
      *    15         Subfile Date                                    *
      *    16 - 19    Unused screen - error indicators                *
      *    25         Enquiry/Authorise/Delete mode                   *
      *    29         Subfile - error messages                        *
      *    30         Subfile access indicator                        *
      *    88         General-purpose indicator                       *
      *    89         General-purpose file access indicator           *
      *    98         Date Format Indicator                           *
      *    U7         Database Error                                  *
      *    U8         Database Error                                  *
      *    LR         Exit program                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRDSP   -  Display Initial Screen                            *
      *  SRLoadSfl-  Fill Subfile Screen                              *
      *  SRRDWN  -  Process Rolldown Key                              *
      *  SRVALD  -  Process Insert and Amend                          *
      *  SRDelOne-  Process Single Delete                             *
      *  SRDelAll-  Delete All Records                                *
      *  SRVFLA  -  Validate Date formula                             *
      *  SRCFLW  -  Generate Cash Flow                                *
      *  SRGetCtlDte- Get the Control Date                            *
      *  SRSNMS  -  Send Message to Program Message Queue             *
      * *PSSR - Error processing                                      *
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
     FMM0091DF  CF   E             WORKSTN
     F                                     SFILE(MM0091S0:RRN)
     FDLFRSCL1  IF   E           K DISK
     FDLFRSCL0  UF A E           K DISK
     F                                     RENAME(DLFRSCD0:DLFRSCD3)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
     D  ##PGM            *PROC
     D  DDWSID               244    253
     D  DDUSER               254    263
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D                 DS
     D  SDATE                  1      7
     D  SWRK1                  1      1
     D  SWRK2                  2      2
     D  SDN1N2                 1      2
     D  SWRK3                  3      3
     D  SWRK4                  4      4
     D  SWRK5                  5      5
     D  SDN2                   4      5
     D  SWRK6                  6      6
     D  S456                   4      6
     D  SWRK7                  7      7
      *
      ** Input Fields
      *
     D                 DS
     D  INPUTF                 1     13
     D  DDACTN                 1      1
     D  DDSELD                 2      8
     D  DDCOHO                 9      9
     D  CAT                   10     11
     D                                     DIM(2) ASCEND
     D  DDCSRT                10     10
     D  DDCSPY                11     11
 
     D                 DS
     D WCHR003x                1      3
     D WNUM5P0x                1      3P 0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access program , short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details accessed via access program
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR details accessed via access program
 
     D PCHR3600        DS          3600
      ** Maximum of 600 elements of dates (6A)
 
     D PCHR600         DS           600
      ** Maximum of 600 elements of Confirmed Holiday indicator
 
     D PIDTES          DS          3600
      ** Maximum of 600 elements of dates (6A)
 
     D PICONF          DS           600
      ** Maximum of 600 elements of Confirmed Holiday indicator
 
     D OKDtes          DS           600
      ** Maximum of 600 elements of OK flags for the dates/hol. inds.
 
      ** Valid dates output (max 600) in daynumber format
     D  PValidDteOut   S           1800
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ZEROS           S              1    DIM(10)
     D NARR            S             35    DIM(2) CTDATA PERRCD(1)
     D LETT            S              1    DIM(7) CTDATA PERRCD(7)
      *
      ** Array to hold input dates. If input dates were passed by the
      ** calling program, then this array should be in sequence with the
      ** subfile.
      *
     D ARRDT1          DS                  OCCURS(600)
     D  ARDTE1                 1      6
     D  ARCHO1                 7      7
      ** Action code from the subfile
     D  ARDAY1                 8     10P 0
      *
      ** Temporary data structure
     D ARRDT9          DS                  OCCURS(600)
     D  ARDTE9                 1      6
     D  ARCHO9                 7      7
     D  ARDAY9                 8     10P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * Main Procedure                                                *
      *****************************************************************
      *
      ** Display Screen
      *
     C                   EXSR      SRDSP
      *
      ** Set up return code
      *
     C                   SELECT
     C     *INKC         WHENEQ    *ON
     C                   MOVE      'Y2U9999'     PRTCD
     C     *INKL         WHENEQ    *ON
     C                   MOVE      'USR0790'     PRTCD
     C                   OTHER
     C                   MOVE      *BLANKS       PRTCD
     C                   ENDSL
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      *                                                               *
      *  SRDSP  - Display Initial Screen                              *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : SRLoadSfl-  Fill Subfile                        *
      *               SRRDWN  -  Process Rolldown                     *
      *               SRDelOne-  Delete a Single Record               *
      *               SRDelAll-  Delete all records                   *
      *               SRVALD  -  Process Insert, Amend                *
      *                                                               *
      *****************************************************************
      *
     C     SRDSP         BEGSR
      *
      ** Do while NOT F3, F12
     C     *INKC         DOWEQ     *OFF
     C     *INKL         ANDEQ     *OFF
      *
      ** Fill up Subfile
     C     WRPR          IFEQ      'N'
     C                   EXSR      SRLoadSfl
     C                   ELSE
     C                   EXSR      SRLoadRPR
     C                   ENDIF
      *
      ** Display the Footer Record Format
     C                   WRITE     MM0091F0
      *
      ** Display the Error Message Subfile
     C                   WRITE     #MSGCTL
      *
      ** Display Subfile Control
     C                   WRITE     MM0091C0
     C                   READ      MM0091C0                               30
      *
      ** Clear message subfile and reset error indicator
     C                   CALL      'ZA0250'
     C                   MOVE      'N'           WERR
     C                   MOVEA     ZEROS         *IN(10)
      *
      ** Rolldown
     C     *IN06         IFEQ      *ON
     C     WRPR          ANDEQ     'N'
     C                   EXSR      SRRDWN
     C                   ENDIF
      *
      ** F10 to delete one record
     C     *INKJ         IFEQ      *ON
     C                   EXSR      SRDelOne
     C                   ENDIF
      *
      ** F16 to delete all records
     C     *INKQ         IFEQ      *ON
     C                   EXSR      SRDelAll
     C                   ENDIF
      *
      ** Subfile is not empty.
     C     *IN04         IFEQ      *OFF
     C                   READC     MM0091S0                               30
     C                   ENDIF
      *
      ** Transfer action code, deal number, conf. holiday etc.,
      ** to top of screen
     C     *IN04         IFEQ      *OFF
     C     *IN30         ANDEQ     *OFF
      *
     C                   MOVEL     DDACN1        DDACTN
     C                   MOVEL     DDPRDT        DDSELD
     C                   MOVEL     DDCOH1        DDCOHO
      *
      ** Enter pressed
     C                   ELSE
      *
     C     INPUTF        IFNE      *BLANKS
     C                   EXSR      SRVALD
     C                   ELSE
     C     *INKJ         IFEQ      *OFF
     C     *INKQ         ANDEQ     *OFF
     C     *IN05         ANDEQ     *OFF
     C     *IN06         ANDEQ     *OFF
     C     WERR          ANDEQ     'N'
     C     Idx           ANDEQ     0
     C     WRPR          IFEQ      'Y'
     C                   EXSR      SRWrtRPR
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Fill Subfile Screen                              *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : SRCNVD  -  Convert Detail Screen                *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSfl     BEGSR
      *
     C                   MOVEA     '001'         *IN(1)
     C                   MOVE      *ON           *IN04
     C                   Z-ADD     *ZERO         RRN
      *
      ** Clear Subfile
      *
     C                   WRITE     MM0091C0
      *
      ** Position pointer on file
      *
     C                   Z-ADD     PDLNO         KDLNO
     C                   MOVE      PRCIP         KRCIP
     C                   Z-ADD     0             KPRDT
      *
     C     KFRSC3        SETLL     DLFRSCD0
     C     KFRSC2        READE     DLFRSCD0                               89
      *
      ** Read until end of file
     C     *IN89         DOWEQ     *OFF
      *
     C                   ADD       1             RRN               4 0    04
     C                   EXSR      SRCNVD
     C                   WRITE     MM0091S0
      *
     C     KFRSC2        READE     DLFRSCD0                               89
      *
     C                   ENDDO
      *
      ** If subfile is empty, display only the subfile control
      ** else display both the subfile and the subfile control.
     C     *IN04         IFEQ      *ON
     C                   MOVEA     '01'          *IN(1)
     C                   ELSE
     C                   MOVEA     '11'          *IN(1)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRWrtSfl  - Output subfile records to physical file.         *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : none.                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRWrtRPR      BEGSR
      *
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C                   Z-ADD     PDLNO         HHDLNO
     C                   Z-ADD     ARDAY1        HHPRDT
     C                   MOVE      PRCIP         HHRCIP
     C                   MOVE      ARCHO1        HHCOHO
     C                   MOVE      *BLANK        HHDTPR
     C                   WRITE     DLFRSCD3
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRLoadRPR - Fill subfile with records from the Invalids file.*
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : SRCNVD  -  Convert Detail Screen                *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadRPR     BEGSR
      *
     C                   MOVEA     '0011'        *IN(1)
     C                   Z-ADD     *ZERO         RRN
      *
      ** Clear Subfile
     C                   WRITE     MM0091C0
      *
     C     WLASTN        IFLE      0
     C                   GOTO      TAGRPR
     C                   ENDIF
      *
     C                   MOVE      *BLANK        PCHR3600
     C                   MOVE      *BLANK        PCHR600
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C                   EVAL      Y=(Q*6)-5
     C     Q             OCCUR     ARRDT1
     C                   EVAL      %SUBST(PCHR3600:Y:6)=ARDTE1
     C                   EVAL      %SUBST(PCHR600:Q:1)=ARCHO1
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   MOVE      ' '           PRteChgIn
     C     PRCIP         IFEQ      'R'
     C                   MOVE      'Y'           PRteChgIn
     C                   ENDIF
      *
     C                   CALLB     'MMVMRCHG'
     C                   PARM                    RetCodeIn
     C                   PARM                    PCVDAT
     C                   PARM                    PCMDAT
     C                   PARM                    CTLDYN
     C                   PARM                    BJDFIN
     C                   PARM                    PACTN2
     C                   PARM                    PDLNO
     C                   PARM      0             PPrevDate         5 0
     C                   PARM                    PCCY
      ** Date Array (max 600) DDMMYY format
     C                   PARM                    PCHR3600
      ** Confirmed Holiday indicators (max 600)
     C                   PARM                    PCHR600
      ** Following parameters are returned to calling module
      ** IRC Dates OK flag
     C                   PARM                    OKDtes
      ** Error fields/message IDs (arrays)
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIDArr
      ** Array index (3P0)
     C                   PARM      0             Idx               3 0
      ** 'Y' if dates passed are Interest Rate Change schedule
     C                   PARM                    PRteChgIn         1
      ** Valid dates output (max 600)in daynumber format
     C                   PARM      *BLANKS       PValidDteOut
      *
      ** Move the equivalent MIDAS day number of each date screen input
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C                   EVAL      Y=(Q*3)-2
     C                   EVAL      WCHR003x=%SUBST(PValidDteOut:Y:3)
     C     Q             OCCUR     ARRDT1
     C     WCHR003x      IFEQ      *BLANKS
     C                   EVAL      ARDAY1=0
     C                   ELSE
     C                   EVAL      ARDAY1=WNUM5P0x
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
      *
      ** Load all records
     C                   MOVE      *BLANKS       DDDYWK
     C                   MOVE      *BLANKS       DDDTPR
      *
     C                   Z-ADD     0             X
     C                   Z-ADD     0             Y                 5 0
     C                   Z-ADD     1             Q
      *
     C     Q             DOWLE     WLASTN
      *
      ** If validation error, set on the reverse-image indicator and
      ** do additional error-processing routine.
     C                   MOVE      *OFF          *IN15
     C                   IF        %SUBST(OKDtes:Q:1)='N'
     C                   MOVE      *ON           *IN15
     C                   ADD       1             X
     C                   MOVEL     MsgIDArr(X)   ZAMSID
     C                   EXSR      SRSNMS
     C                   ENDIF
      *
      ** This multi-occurence ds is in parallel with the subfile
     C     Q             OCCUR     ARRDT1
     C                   ADD       1             RRN                      04
     C                   MOVE      ARCHO1        DDCOH1
     C                   MOVE      ARDTE1        DDPRDT
     C                   WRITE     MM0091S0
     C                   ADD       1             Q
      *
     C                   ENDDO
      *
     C     TAGRPR        TAG
      *
      ** If subfile is empty, display only the subfile control
      ** else display both the subfile and the subfile control.
     C     WLASTN        IFGT      0
     C                   MOVE      *ON           *IN01
     C                   ENDIF
     C                   MOVE      *ON           *IN02
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRRDWN - Process Rolldown Key                                *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      :                                                 *
      *                                                               *
     C*****************************************************************
      *                                                               *
     C     SRRDWN        BEGSR
      *
      ** Read previous 16 records to get key for start of previous page
      *
     C                   Z-ADD     *ZERO         RRN
     C     KFRSC3        SETGT     DLFRSCD0
     C     KFRSC2        READPE    DLFRSCD0                               89
      *
     C     *IN89         DOWEQ     *OFF
     C     RRN           ANDLT     #C
     C     KFRSC2        READPE    DLFRSCD0                               89
     C                   ADD       1             RRN
     C                   ENDDO
      *
     C     *IN89         IFEQ      *ON
     C                   Z-ADD     *ZERO         HHPRDT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRVALD - Process Insert and Amend                            *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : ZDATE1 -  Convert date to day number            *
      *               ZFWDT  -  Find number of working days forward   *
      *               ZALIGN -  Validate/right align numeric          *
      *               SRVFLA -  Validate Date formula                 *
      *               SRGetCtlDte- Get Control Date                   *
      *               SRCFLW -  Generate Cash Flow                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVALD        BEGSR
      *
      ** ------------------------ **
      ** Action Code = D (Delete)
      ** F10 must be taken
      ** ------------------------ **
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'DLM0140'     ZAMSID
     C                   EXSR      SRSNMS
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** ------------------------ **
      ** Action Code = I (Insert)
      ** ------------------------ **
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Date must be specified
     C     DDSELD        IFEQ      *BLANK
     C                   MOVEL     'DLM0141'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date must be a valid date
     C                   MOVEL     DDSELD        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZDATE             6 0
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        WPRDT             5 0
      *
     C     @RTCD         IFNE      *BLANKS
     C     WPRDT         OREQ      *ZERO
     C                   MOVEL     'DLM0142'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date cannot be less than value date or equal to
      ** value date for rate changes
     C     WPRDT         IFLT      PCVDAT
     C     WPRDT         OREQ      PCVDAT
     C     PRCIP         ANDEQ     'R'
     C                   MOVEL     'DLM0167'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date cannot be greater than maturity date or equal to
      ** maturity date for rate changes
     C     WPRDT         IFGT      PCMDAT
     C     WPRDT         OREQ      PCMDAT
     C     PRCIP         ANDEQ     'R'
     C                   MOVEL     'DLM0168'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date cannot be less than or equal to last 'processed' date
     C     WPRDT         IFLE      LPRDYN
     C                   MOVEL     'DLM0145'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date cannot be less than or equal to the next rate change date
     C     WPRDT         IFLE      CTLDYN
     C     PRCIP         ANDEQ     'R'
     C                   MOVEL     'DLM0135'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date cannot be less than or equal to the next int. pay date
     C     WPRDT         IFLE      CTLDYN
     C     PRCIP         ANDEQ     'P'
     C                   MOVEL     'DLM0136'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Check if date a holiday (Ind. 99 set on if it is)
     C                   MOVE      'N'           WHOL              1
      *
     C                   CALL      'ZFWDT'
     C                   PARM      WPRDT         ZDAYNO            5 0
     C                   PARM      0             ZNRDYS            2 0
     C                   PARM      0             ZDYNBR            5 0
     C                   PARM      PCCY          ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
      *
     C     WPRDT         IFNE      ZDYNBR
     C                   MOVE      'Y'           WHOL
      ** If date is not a holiday according to SDHOLPD,
      ** But is Saturday or Sunday, then treat it as a holiday
     C                   ELSE
     C     ZDAYNO        DIV       7             WRK153
     C                   MOVE      WRK153        WRK30
     C     WRK30         IFEQ      142
     C     WRK30         OREQ      285
     C                   MOVE      'Y'           WHOL
     C                   ENDIF
     C                   ENDIF
      *
      ** Confirmed holiday ind. must be 'Y' if date is a holiday, else *BLANK
     C     DDCOHO        IFNE      'Y'
     C     WHOL          ANDEQ     'Y'
     C     DDCOHO        ORNE      *BLANK
     C     WHOL          ANDEQ     'N'
     C                   MOVEL     'DLM0146'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN13
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** A record already exists for this date
     C     WRPR          IFEQ      'N'
      *
     C                   Z-ADD     WPRDT         KPRDT
     C     KFRSC3        CHAIN     DLFRSCD0                           89
     C     *IN89         IFEQ      *OFF
     C                   MOVEL     'DLM0150'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** No validation error for Insert, then add record
     C                   Z-ADD     PDLNO         HHDLNO
     C                   Z-ADD     WPRDT         HHPRDT
     C                   MOVE      PRCIP         HHRCIP
     C                   MOVEL     DDCOHO        HHCOHO
     C                   MOVE      *BLANK        HHDTPR
     C                   WRITE     DLFRSCD3
      *
     C                   ELSE
      *
     C                   MOVE      'N'           WRECF
     C                   MOVEL     DDSELD        WCHR006
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     WCHR006       IFEQ      ARDTE1
     C                   MOVE      'Y'           WRECF
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
     C     WRECF         IFEQ      'Y'
     C                   MOVEL     'DLM0150'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** No validation error for Insert, then add record
     C                   Z-ADD     1             CQ
     C     CQ            DOWLE     WLASTN
     C     CQ            OCCUR     ARRDT1
     C     WPRDT         IFLT      ARDAY1
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             CQ
     C                   ENDDO
      *
      ** Insert the new date with respect to the existing sorting
     C                   CLEAR                   ARRDT9
     C                   ADD       1             WLASTN
     C                   Z-ADD     1             Q
     C                   Z-ADD     1             Y
     C     Y             DOWLE     WLASTN
     C     Y             OCCUR     ARRDT9
     C     Y             IFEQ      CQ
      ** Move screen fields to array 9
     C                   MOVE      DDCOHO        ARCHO9
     C                   MOVEL     DDSELD        ARDTE9
     C                   Z-ADD     WPRDT         ARDAY9
     C                   ELSE
      ** Move fields from array 1 to array 9
     C     Q             OCCUR     ARRDT1
     C                   MOVE      ARCHO1        ARCHO9
     C                   MOVEL     ARDTE1        ARDTE9
     C                   Z-ADD     ARDAY1        ARDAY9
     C                   ADD       1             Q
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     Q             OCCUR     ARRDT9
     C                   MOVE      ARCHO9        ARCHO1
     C                   MOVEL     ARDTE9        ARDTE1
     C                   Z-ADD     ARDAY9        ARDAY1
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       INPUTF
     C                   GOTO      EPROIC
      *
     C                   ENDIF
      *
      ** ------------------------ **
      ** Action Code = A (Amend)
      ** ------------------------ **
      *
     C     DDACTN        IFEQ      'A'
      *
      ** Date must be specified
     C     DDSELD        IFEQ      *BLANK
     C                   MOVEL     'DLM0141'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date must be a valid date
     C                   MOVEL     DDSELD        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZDATE
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        WPRDT
      *
     C     @RTCD         IFNE      *BLANKS
     C     ZDAYNO        OREQ      *ZERO
     C                   MOVEL     'DLM0142'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Check if date a holiday (IND 99 set on if it is)
     C                   MOVE      'N'           WHOL
      *
     C                   CALL      'ZFWDT'
     C                   PARM      WPRDT         ZDAYNO
     C                   PARM      0             ZNRDYS
     C                   PARM      0             ZDYNBR            5 0
     C                   PARM      PCCY          ZCCY
     C                   PARM      *BLANKS       ZLOC
      *
     C     WPRDT         IFNE      ZDYNBR
     C                   MOVE      'Y'           WHOL
      ** If date is not a holiday according to SDHOLPD,
      ** But is Saturday or Sunday, then treat it as a holiday
     C                   ELSE
     C     WPRDT         DIV       7             WRK153
     C                   MOVE      WRK153        WRK30
     C     WRK30         IFEQ      142
     C     WRK30         OREQ      285
     C                   MOVE      'Y'           WHOL
     C                   ENDIF
     C                   ENDIF
      *
      ** Confirmed holiday ind. must be 'Y' if date is a holiday, else  *BLANK
     C     DDCOHO        IFNE      'Y'
     C     WHOL          ANDEQ     'Y'
     C     DDCOHO        ORNE      *BLANK
     C     WHOL          ANDEQ     'N'
     C                   MOVEL     'DLM0146'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN13
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** A record does not exist on the dates file
     C     WRPR          IFEQ      'N'
      *
     C                   Z-ADD     WPRDT         KPRDT
     C     KFRSC3        CHAIN     DLFRSCD3                           89
     C     *IN89         IFEQ      *ON
     C                   MOVEL     'DLM0158'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** If no validation error, then update
     C                   MOVEL     DDCOHO        HHCOHO
     C                   UPDATE    DLFRSCD3
      *
     C                   ELSE
      *
     C                   MOVE      'N'           WRECF
     C                   MOVEL     DDSELD        WCHR006
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     WCHR006       IFEQ      ARDTE1
     C                   MOVE      'Y'           WRECF
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
     C     WRECF         IFEQ      'N'
     C                   MOVEL     'DLM0158'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** If no validation error, then update the confirmed holiday ind.
     C                   MOVE      DDCOHO        ARCHO1
      *
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       INPUTF
     C                   GOTO      EPROIC
      *
     C                   ENDIF
      *
      ** ---------------------- **
      ** Action Code = C (Copy)
      ** ---------------------- **
      *
     C     DDACTN        IFEQ      'C'
      *
      ** Date must be blank
     C     DDSELD        IFNE      *BLANK
     C                   MOVEL     'DLM0169'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** At least 1 category must be selected with a 'Y'
     C     DDCSRT        IFEQ      *BLANK
     C     DDCSPY        ANDEQ     *BLANK
     C                   MOVEL     'DLM0170'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN14
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Only 1 category can be selected
     C     DDCSRT        IFNE      *BLANK
     C     DDCSPY        ANDNE     *BLANK
     C                   MOVEL     'DLM0171'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN14
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Set key for copy
     C                   SELECT
     C     DDCSRT        WHENEQ    'Y'
     C                   MOVEL     'R'           WRCIP             1
     C                   MOVEL     'P'           WRCIP2            1
     C     DDCSPY        WHENEQ    'Y'
     C                   MOVEL     'P'           WRCIP
     C                   MOVEL     'R'           WRCIP2
     C                   ENDSL
      *
      ** There are no records to copy
     C                   MOVEL     WRCIP         KRCIP
     C     KFRSC2        CHAIN     DLFRSCD0                           89
     C     *IN89         IFEQ      *ON
     C                   MOVEL     'DLM0172'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN11
     C                   MOVE      *ON           *IN14
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** No validation errors. Copy records EXcluding processed records.
     C                   MOVEL     WRCIP         KRCIP
     C     KFRSC2        SETLL     DLFRSCD0
     C     KFRSC2        READE     DLFRSCD0                               89
      *
     C     *IN89         DOWEQ     *OFF
      *
     C     HHDTPR        IFNE      'Y'
      *
     C     WRPR          IFEQ      'N'
      *
     C                   MOVE      WRCIP2        KRCIP
     C                   Z-ADD     HHPRDT        KPRDT
     C     KFRSC3        CHAIN     DLFRSCD3                           89
     C     *IN89         IFEQ      *ON
     C                   MOVE      KRCIP         HHRCIP
     C                   WRITE     DLFRSCD3
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     WRCIP         KRCIP
     C     KFRSC2        READE     DLFRSCD0                               89
      *
     C                   ENDDO
      *
     C                   MOVEL     *BLANKS       INPUTF
     C                   GOTO      EPROIC
      *
     C                   ENDIF
      *
      ** ------------------------------------ **
      ** Action Code = M, Q, X, Y (Frequency)
      ** ------------------------------------ **
      *
     C     DDACTN        IFEQ      'M'
     C     DDACTN        OREQ      'Q'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Y'
      *
      ** Formula must be specified
     C     DDSELD        IFEQ      *BLANK
     C                   MOVEL     'DLM0153'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Date must be a formula
     C                   MOVEL     DDSELD        SDATE
     C                   EXSR      SRVFLA
     C     WOKFLA        IFEQ      'N'
     C                   MOVEL     'DLM0154'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** Get control date - first non precessed date
     C                   EXSR      SRGetCtlDte
      *
      ** If no start date present, formula cannot be used
      *
     C     CTLDYN        IFEQ      *ZERO
     C                   MOVEL     'DLM0155'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   ENDIF
      *
      ** Generate CASH FLOW and exit
      *
     C     WERR          IFNE      'Y'
     C                   EXSR      SRCFLW
     C                   MOVEL     *BLANKS       INPUTF
     C                   ENDIF
     C                   GOTO      EPROIC
     C                   ENDIF
      *
      ** ---------------------------------------- **
      ** Action Code not = I, A, D, C, M, X, Q, Y
      ** ---------------------------------------- **
      *
      ** If a category is selected action code 'C' must be defined
      *
     C                   Z-ADD     1             X                 5 0
     C     *BLANK        LOOKUP    CAT(X)                             89
     C     *IN89         IFEQ      *ON
     C                   MOVEL     'DLM0174'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN11
     C                   ENDIF
      *
      ** If no category is selected, Action Code can only be IACD, MXQY
      *
     C     DDCSRT        IFEQ      *BLANK
     C     DDCSPY        ANDEQ     *BLANK
     C                   MOVEL     'DLM0175'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN11
     C                   ENDIF
      *
     C     EPROIC        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRDelOne- Process Single Delete                              *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : ZDATE1 - Convert date to day number             *
      *                                                               *
      *****************************************************************
      *
     C     SRDelOne      BEGSR
      *
      ** Action code must be 'D' to delete
     C     DDACTN        IFNE      'D'
     C                   MOVEL     'DLM0157'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN11
     C                   GOTO      EPRODL
     C                   ENDIF
      *
      ** Date must be specified
     C     DDSELD        IFEQ      *BLANK
     C     WRPR          ANDEQ     'N'
     C                   MOVEL     'DLM0141'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVE      *ON           *IN12
     C                   GOTO      EPRODL
     C                   ENDIF
      *
      ** Convert screen date to MIDAS day number
     C                   MOVEL     DDSELD        WCHR006           6
     C                   MOVE      WCHR006       ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZDATE
     C                   PARM                    BJDFIN
     C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        KPRDT
      *
      ** A record does not exist on the dates file
     C                   MOVE      'N'           WRECF             1
     C     KFRSC3        CHAIN     DLFRSCD3                           40
     C     *IN40         IFEQ      *OFF
     C                   MOVE      'Y'           WRECF
     C                   ELSE
     C     WRPR          IFEQ      'N'
     C                   MOVEL     'DLM0158'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPRODL
     C                   ENDIF
     C                   ENDIF
      *
      ** Additional verification if this pgm was called by the RPR.
      ** That is, scan the array as well.
     C     WRPR          IFEQ      'Y'
     C     WRECF         ANDEQ     'N'
      *
     C                   Z-ADD     1             CQ                5 0
     C     CQ            DOWLE     WLASTN
     C     CQ            OCCUR     ARRDT1
     C     WCHR006       IFEQ      ARDTE1
     C                   MOVE      'Y'           WRECF
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             CQ
     C                   ENDDO
      *
     C     WRECF         IFEQ      'N'
     C                   MOVEL     'DLM0158'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPRODL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** This record can't be deleted as its event has already been processed
     C     HHDTPR        IFEQ      'Y'
     C                   MOVEL     'DLM0159'     ZAMSID
     C                   EXSR      SRSNMS
     C                   MOVEA     '11'          *IN(11)
     C                   GOTO      EPRODL
     C                   ENDIF
      *
      ** Record deleted
     C     *IN40         IFEQ      *OFF
     C                   DELETE    DLFRSCD3
     C                   ENDIF
      *
      ** Delete record from the array
     C     WRPR          IFEQ      'Y'
     C     WRECF         ANDEQ     'Y'
      *
      ** Set up ARRDT9 with the records excluding the one for deletion
     C                   CLEAR                   ARRDT9
     C                   Z-ADD     1             Q
     C                   Z-ADD     1             Y
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     Y             OCCUR     ARRDT9
      ** Ignore the record that has been tagged with 'D' action
     C     Q             IFNE      CQ
     C                   MOVE      ARDTE1        ARDTE9
     C                   MOVE      ARCHO1        ARCHO9
     C                   Z-ADD     ARDAY1        ARDAY9
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
      *
      ** Copy records from ARRDT9 to ARRDT1
     C                   CLEAR                   ARRDT1
     C                   SUB       1             WLASTN
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     Q             OCCUR     ARRDT9
     C                   MOVE      ARDTE9        ARDTE1
     C                   MOVE      ARCHO9        ARCHO1
     C                   Z-ADD     ARDAY9        ARDAY1
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       INPUTF
      *
     C     EPRODL        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRDelAll - Delete All Records                                *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      :                                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
     C     SRDelAll      BEGSR
      *
      ** Delete all records on the dates file, except those processed
      *
     C     WRPR          IFEQ      'N'
      *
     C                   Z-ADD     *ZERO         KPRDT
     C     KFRSC3        SETLL     DLFRSCD3
     C     KFRSC2        READE     DLFRSCD3                               89
     C     *IN89         DOWEQ     *OFF
     C     HHDTPR        IFNE      'Y'
     C                   DELETE    DLFRSCD3
     C                   ENDIF
     C     KFRSC2        READE     DLFRSCD3                               89
     C                   ENDDO
      *
     C                   ELSE
      *
     C                   Z-ADD     0             WLASTN
     C                   CLEAR                   ARRDT1
      *
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       INPUTF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRCNVD - Convert file details to screen format               *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : ZDATE2 - Convert day number to date             *
      *               ZSEDIT - Edit numeric fields                    *
      *                                                               *
     C*****************************************************************
      *
     C     SRCNVD        BEGSR
      *
      ** Action code
      *
     C                   MOVEL     *BLANK        DDACN1
      *
      ** Convert date
      *
     C                   CALL      'ZDATE2'
     C                   PARM      HHPRDT        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZNUM6P
     C                   PARM      *BLANKS       ZDATE7
     C                   MOVE      ZNUM6P        DDPRDT
      *
      ** Day in week (Saturday and Sunday only)
      *
     C                   MOVEL     *BLANK        DDDYWK
     C     HHPRDT        DIV       7             WRK153           15 3
     C                   MOVE      WRK153        WRK30             3 0
     C     WRK30         IFEQ      142
     C                   MOVEL     'SAT'         DDDYWK
     C                   ENDIF
     C     WRK30         IFEQ      285
     C                   MOVEL     'SUN'         DDDYWK
     C                   ENDIF
      *
      ** Convert processed ind
      *
     C     HHDTPR        IFEQ      'Y'
     C                   MOVE      *ON           *IN10
     C                   MOVEL     'YES'         DDDTPR
     C                   ELSE
     C                   MOVE      *OFF          *IN10
     C                   MOVEL     *BLANK        DDDTPR
     C                   ENDIF
      *
      ** Other variables
      *
     C                   MOVE      HHCOHO        DDCOH1
     C   50              MOVE      *ON           *IN10
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRVFLA - Validate Date formula                               *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : ZDATE2 - Convert day number to a date           *
      *               ZSEDIT - Edit numeric fields                    *
      *                                                               *
      *****************************************************************
      *
     C     SRVFLA        BEGSR
      *
     C                   MOVE      'Y'           WOKFLA            1
      *
      ** ---------------------------- **
      ** Validate first two positions
      ** ---------------------------- **
      ** First two positions are mandatory
     C     SDN1N2        IFEQ      *BLANK
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
      ** Are positions 1&2 numeric?
     C                   MOVE      0             WRK3A             3
     C                   MOVEL     SDN1N2        WRK3A
     C                   TESTN                   WRK3A                88
      *
      ** If SDN1N2 is numeric
     C     *IN88         IFEQ      *ON
     C                   MOVE      SDN1N2        WRK2N             2 0
      *
      ** Number must be between 1 and 28, or be 31.
     C     WRK2N         IFGT      28
     C     SDN1N2        ANDNE     '31'
     C     WRK2N         ORLT      1
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
      ** If not numeric
     C                   ELSE
      *
      ** Position 1 to be numeric  1-4 incl
     C     SWRK1         IFLT      '1'
     C     SWRK1         ORGT      '4'
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
      ** 1ST character valid - check 2ND is in array of day in week co des
      *
     C     SWRK2         LOOKUP    LETT                                   88
     C     *IN88         IFEQ      *OFF
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** ------------------- **
      ** Validate position 3
      ** ------------------- **
      *
      ** If position 1/2 is 31, pos 3 must be blank, or 4,5,6 have ent ry
      ** If position 1 and 2 are not '31' pos.3 must be '+' or '-'
      *
     C     SDN1N2        IFEQ      '31'
     C     SWRK3         ANDNE     *BLANK
     C     S456          ANDEQ     *BLANK
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
     C     SDN1N2        IFNE      '31'
     C     SWRK3         ANDNE     '+'
     C     SWRK3         ANDNE     '-'
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
     C     SDN1N2        IFEQ      '31'
     C     SWRK3         ANDNE     '+'
     C     SWRK3         ANDNE     '-'
     C     SWRK3         ANDNE     ' '
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
      ** -------------------------- **
      ** Validate positions 4 and 5
      ** -------------------------- **
      *
      ** If entered must be numeric, between 1 and 28 inclusive
     C     SDN2          IFNE      *BLANK
      *
     C                   MOVE      0             WRK3A
     C                   MOVEL     SDN2          WRK3A
     C                   TESTN                   WRK3A                88
      *
      ** Not valid numeric
     C     *IN88         IFEQ      *OFF
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ELSE
      ** Valid number, check range
     C                   MOVE      SDN2          WRK2N
     C     WRK2N         IFLT      1
     C     WRK2N         ORGT      28
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** ------------------- **
      ** Validate position 6
      ** ------------------- **
      *
      ** If positions 4 and 5 are entered pos 6 must be A,B or C
      *
     C     SDN2          IFNE      *BLANK
     C     SWRK6         ANDNE     'A'
     C     SWRK6         ANDNE     'B'
     C     SWRK6         ANDNE     'C'
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
      *
      ** ------------------- **
      ** Validate position 7
      ** ------------------- **
      *
      ** If position 6 is 'A' then pos 7 must be '+' or'-'
      ** otherwise it must be blank.
     C     SWRK6         IFEQ      'A'
     C     SWRK7         IFNE      '+'
     C     SWRK7         ANDNE     '-'
     C                   MOVE      'N'           WOKFLA
     C                   GOTO      XTVDAT
     C                   ENDIF
     C                   ELSE
     C     SWRK7         IFNE      ' '
     C                   MOVE      'N'           WOKFLA
     C                   ENDIF
     C                   ENDIF
      *
     C     XTVDAT        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRCFLW - Generate Cash Flow                                  *
      *                                                               *
      *  Called by  : MAIN   - Main Processing Routine                *
      *                                                               *
      *  Calls      : FFDATE - Convert FF Date Formula                *
      *               ZSEDIT - Edit numeric fields                    *
      *                                                               *
      *****************************************************************
      *
     C     SRCFLW        BEGSR
      *
     C                   MOVEL     DDSELD        FFDATC            7
     C                   MOVEL     PCCY          FFCCY1            3
     C                   MOVEL     *BLANK        FFCCY2            3
     C                   MOVE      *BLANK        FFCCY3            3
     C                   Z-ADD     CTLDYN        WPRDT
      *
      ** Reformat control date to DDMMYY or MMDDYY
     C                   CALL      'ZDATE2'
     C                   PARM      CTLDYN        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZNUM6P
     C                   PARM      *BLANKS       ZDATE7
     C                   MOVE(P)   ZNUM6P        WCHR006
     C     BJDFIN        IFEQ      'D'
     C     2             SUBST     WCHR006:3     WCHR002           2
     C                   ELSE
     C     2             SUBST     WCHR006:1     WCHR002
     C                   ENDIF
     C                   MOVE      WCHR002       MTHN
     C     2             SUBST     WCHR006:5     WCHR002
     C                   MOVE      WCHR002       YRNO
      *
      ** Calculate next settlement date using FFDATE
      *
     C     WPRDT         DOWLT     PCMDAT
      *
     C                   Z-ADD     YRNO          FFYR
     C                   Z-ADD     MTHN          FFMTH
     C                   MOVE      *BLANKS       FFLOC
      *
      ** Bypass call to FFDATE if Bus. Day Conventions Enhancement on.
      *
     C     CIR005        IFEQ      'Y'
      *
      ** This processing is equivalent to the FFDATE processing but
      ** handles a maximum of 10 currencies.
     C                   MOVEL     PCCY          FFPCCY           30
     C                   CALL      'DLZIRF'
     C                   PARM                    FFDATC
     C                   PARM                    FFMTH
     C                   PARM                    FFYR
     C                   PARM                    FFPCCY
     C                   PARM                    FFLOC
     C                   PARM                    BJDFIN
     C                   PARM                    WADJWD            5 0
     C                   PARM                    PBSDAY            5 0
      *
     C     WPRDT         IFGE      WADJWD
     C                   MOVE      PBSDAY        WPRDT
     C                   ELSE
     C                   MOVE      WADJWD        WPRDT
     C                   ENDIF
      *
     C                   ELSE
 
     C                   CALLB     'FFDATE'
      ** Return code (10A, returned to caller)
     C                   PARM                    RetCde10         10
      ** Working day (5,0P)
     C                   PARM                    FFDAY             5 0
      ** Parameters received from caller
      ** -------------------------------
      ** Date formula (7A)
     C                   PARM                    FFDATC            7
      ** Month of required date (2,0P)
     C                   PARM                    FFMTH             2 0
      ** Year of required date (2,0P)
     C                   PARM                    FFYR              2 0
      ** Market currency (3A)
     C                   PARM      PCCY          FFCCY1            3
      ** Market location (3A)
     C                   PARM                    FFLOC             3
      ** Instrument currency (3A)
     C                   PARM                    FFCCY2            3
      ** Other currency (3A)
     C                   PARM                    FFCCY3            3
      ** Date format indicator (1A)
     C                   PARM                    BJDFIN
      *
     C                   MOVE      FFDAY         WPRDT
      *
     C                   ENDIF
      *
     C     WPRDT         IFLT      PCMDAT
     C     WPRDT         ANDGE     CTLDYN
      *
     C     WRPR          IFEQ      'N'
      *
     C                   Z-ADD     PDLNO         KDLNO
     C                   MOVE      PRCIP         KRCIP
     C                   Z-ADD     WPRDT         KPRDT
     C     KFRSC3        CHAIN     DLFRSCD3                           89
     C     *IN89         IFEQ      *ON
     C                   Z-ADD     PDLNO         HHDLNO
     C                   Z-ADD     WPRDT         HHPRDT
     C                   MOVE      PRCIP         HHRCIP
     C                   MOVEL     *BLANK        HHCOHO
     C                   MOVEL     *BLANK        HHDTPR
     C                   WRITE     DLFRSCD3
     C                   ENDIF
      *
     C                   ELSE
      *
      ** 1. Find the location where the new element should be inserted.
     C                   Z-ADD     1             CQ
     C     CQ            DOWLE     WLASTN
     C     CQ            OCCUR     ARRDT1
     C     WPRDT         IFLT      ARDAY1
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             CQ
     C                   ENDDO
      ** 2. Insert the new element.
     C                   CLEAR                   ARRDT9
     C                   ADD       1             WLASTN
     C                   Z-ADD     1             Q
     C                   Z-ADD     1             Y
     C     Y             DOWLE     WLASTN
     C     Y             OCCUR     ARRDT9
     C     Y             IFEQ      CQ
      ** Move screen fields to array 9
     C                   CALL      'ZDATE2'
     C                   PARM      WPRDT         ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZNUM6P
     C                   PARM      *BLANKS       ZDATE7
     C                   MOVE      ZNUM6P        ARDTE9
     C                   MOVE      *BLANK        ARCHO9
     C                   Z-ADD     WPRDT         ARDAY9
     C                   ELSE
      ** Move fields from array 1 to temporary array 9
     C     Q             OCCUR     ARRDT1
     C                   MOVE      ARCHO1        ARCHO9
     C                   MOVEL     ARDTE1        ARDTE9
     C                   Z-ADD     ARDAY1        ARDAY9
     C                   ADD       1             Q
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      ** Move fields from temporary array 9 to array 1
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
     C     Q             OCCUR     ARRDT1
     C     Q             OCCUR     ARRDT9
     C                   MOVE      ARCHO9        ARCHO1
     C                   MOVEL     ARDTE9        ARDTE1
     C                   Z-ADD     ARDAY9        ARDAY1
     C                   ADD       1             Q
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update year/month according to frequency
      *
     C     DDACTN        IFEQ      'M'
     C                   ADD       1             MTHN              2 0
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'Q'
     C                   ADD       3             MTHN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'X'
     C                   ADD       6             MTHN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'Y'
     C                   ADD       1             YRNO              2 0
     C                   ENDIF
      *
      ** If past end of year
      *
     C     MTHN          IFGT      12
     C                   ADD       1             YRNO
     C                   SUB       12            MTHN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRGetCtlDte - Get the Control Date                           *
      *                                                               *
      *  Called by  : SRVALD - Validation routine                     *
      *                                                               *
      *  Calls      : ZDATE2 - Convert day number to a date           *
      *                                                               *
      *****************************************************************
      *
     C     SRGetCtlDte   BEGSR
      *
      ** Get the control date - the first non processed date
      ** (Exclude proccesed ind = lower case Y)
      *
     C                   Z-ADD     *ZERO         KPRDT
     C                   Z-ADD     *ZERO         CTLDYN            5 0
      *
     C     KFRSC3        SETLL     DLFRSCD0
     C     KFRSC2        READE     DLFRSCD0                               89
      *
     C     *IN89         DOWEQ     *OFF
     C     CTLDYN        ANDEQ     *ZERO
     C     HHDTPR        IFNE      'Y'
     C                   Z-ADD     HHPRDT        CTLDYN
     C                   ENDIF
     C     KFRSC2        READE     DLFRSCD0                               89
     C                   ENDDO
      *
     C     PCTDAT        IFGT      CTLDYN
     C                   Z-ADD     PCTDAT        CTLDYN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRSNMS - Send Message to Program Message Queue               *
      *                                                               *
      *  Called by  : All subroutines sending messages to screen      *
      *                                                               *
      *  Calls      :  -                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRSNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANKS
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
      ** Send message to program's message queue
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   MOVE      'Y'           WERR              1
      *
     C                   ENDSR
      *
      *****************************************************************
 
      **********************************************************************
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
      *
     C                   PARM                    PDLNO             6 0
     C                   PARM                    PDTYP             2
     C                   PARM                    PRCIP             1
     C                   PARM                    PCTDAT            5 0
     C                   PARM                    PCVDAT            5 0
     C                   PARM                    PCMDAT            5 0
     C                   PARM                    PCCY              3
     C                   PARM                    PACTN2            1
     C                   PARM                    PIDTES
     C                   PARM                    PICONF
     C                   PARM                    PRTCD             7
      *
     C     *LIKE         DEFINE    HHDLNO        KDLNO
     C     *LIKE         DEFINE    HHPRDT        KPRDT
     C     *LIKE         DEFINE    HHRCIP        KRCIP
      *
     C     KFRSC3        KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KRCIP
     C                   KFLD                    KPRDT
      *
     C     KFRSC2        KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KRCIP
 
     C                   MOVE      '0'           ZEROS
     C                   Z-ADD     10            #C                2 0
     C                   MOVE      'N'           WOKFL             1
     C                   CLEAR                   ARRDT1
      *
      ** If input dates is non-blank, then this program was called
      ** by the API Repair function.
     C                   MOVE      'N'           WRPR              1
     C     PIDTES        IFNE      *BLANKS
     C                   MOVE      'Y'           WRPR
     C                   ENDIF
      *
      ** Initialise database error fields
     C     *LOCK         IN        LDA
     C                   Z-ADD     *ZERO         DBASE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVEL     'MM0091  '    DBPGM
     C                   OUT       LDA
      *
     C                   MOVEL     'DRSMM '      ZAMSGF
      *
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BJMRDT        DDRUNA
      *
      ** Check system date format, DDMMYY or MMDDYY.
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C                   ENDIF
      *
      ** Check if switchable feature CIR005 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR005            1
     C                   ELSE
     C                   MOVE      'N'           CIR005
     C                   ENDIF
      *
      ** Set screen variable from passed parameter
     C                   MOVE      PDLNO         DDDLNO
      *
     C                   CALL      'ZDATE2'
     C                   PARM      PCVDAT        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZNUM6P            6 0
     C                   PARM      *BLANKS       ZDATE7            7
     C                   MOVE      ZNUM6P        DDCVDT
      *
     C                   CALL      'ZDATE2'
     C                   PARM      PCMDAT        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZNUM6P
     C                   PARM      *BLANKS       ZDATE7
     C                   MOVE      ZNUM6P        DDCMDT
      *
      ** Protect screen if action performed is enquiry, authorise
      ** or delete.
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN25
     C     PACTN2        IFEQ      'E'
     C     PACTN2        OREQ      'X'
     C     PACTN2        OREQ      'D'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN25
     C                   ENDIF
      *
      ** Set title
     C     PRCIP         IFEQ      'R'
     C                   MOVEL     NARR(1)       DDTITL
     C                   ELSE
     C                   MOVEL     NARR(2)       DDTITL
     C                   ENDIF
      *
      ** Determine last date processed (ie last rate change/int payment date)
     C                   Z-ADD     PDLNO         KDLNO
     C                   MOVE      PRCIP         KRCIP
     C                   Z-ADD     *ZERO         KPRDT
     C                   Z-ADD     *ZERO         LPRDYN            5 0
      *
     C     KFRSC3        SETLL     DLFRSCD0
     C     KFRSC2        READE     DLFRSCD0                               89
     C     *IN89         DOWEQ     *OFF
     C     HHDTPR        ANDEQ     'Y'
     C                   Z-ADD     HHPRDT        LPRDYN
     C     KFRSC2        READE     DLFRSCD0                               89
     C                   ENDDO
      *
     C     PIDTES        IFNE      *BLANKS
 
      ** Determine the index of the last element.
     C                   Z-ADD     0             WLASTN            5 0
     C                   Z-ADD     3595          Q                 5 0
     C     Q             DOWGT     0
     C                   IF        %SUBST(PIDTES:Q:6)<>*BLANK
     C     Q             DIV       6             WLASTN
     C                   ADD       1             WLASTN
     C                   LEAVE
     C                   ENDIF
     C                   SUB       6             Q
     C                   ENDDO
 
      ** Move the input dates to the multi-occurrence DS. Once set,
      ** use the DS instead of the *entry input dates.
     C                   CLEAR                   ARRDT1
     C                   Z-ADD     1             Q
     C     Q             DOWLE     WLASTN
      ** This multi-occurrence ds is in parallel with the subfile
     C                   EVAL      Y=(Q*6)-5
     C     Q             OCCUR     ARRDT1
     C     1             SUBST     PICONF:Q      ARCHO1
     C     6             SUBST     PIDTES:Y      ARDTE1
     C                   ADD       1             Q
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EXSR      SRGetCtlDte
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
** NARR - Titles
Interest Rate Change Schedule
Interest Payment Schedule
** LETT - Letters for days to validate date formulas
MUWTFSX
