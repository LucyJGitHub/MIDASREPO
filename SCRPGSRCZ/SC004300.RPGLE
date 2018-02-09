     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Processing Day Closure Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004300 - Processing Day Closure Maintenance                *
      *                                                               *
      *  Function:  This module will facilitate the entry of the new  *
      *             processing date, to be used both for newly        *
      *             entered transactions in the 'support' system, as  *
      *             well as by the 'main' system at the end of the    *
      *             close of business when the database is            *
      *             initialised for the new processing day.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CSF002             Date 11Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSF002 - Global Processing.                                  *
      *           Processing done when Attention key is pressed is no *
      *           longer required in MidasPlus.                       *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20         Holiday indicator                               *
      *    21         Working days indicator                          *
      *    22         Error indicator for date input                  *
      *    23         Non-display of confirmation                     *
      *    24         Reverse image display of confirmation field     *
      *    25         Next working day indicator                      *
      *    26         Error in calling program                        *
      *    30         Reverse image display of date field             *
      *                                                               *
      *    U7, U8     Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR  - Initialise                                         *
      *  SRTSCR  - Set screen info and convert dates                  *
      *  SRDISP  - Screen Display processing                          *
      *  SRNEXT  - Computes next processing date for dtaara SC24X7    *
      *  SRVALD  - Validation of new date                             *
      *  SRCONV  - Convert Dates to two formats                       *
      *  SREROR  - Send error message                                 *
      *  *PSSR   - Error processing                                   *
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
 
     FSC004300DFCF   E             WORKSTN INFSR(*PSSR)
      ** Display file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D WQcmd           S            100    DIM(1) CTDATA PERRCD(1)
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D COBDTA        E DS                  EXTNAME(CBCOBIPD)
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
     D FMTDAT          DS             7
     D    DATZRO               1      1
     D WCommand        DS           100
     D  WCmd1                 15     22
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*AUS025***       S              1A                                                      CSF002
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6
     D PUSRP           S             10
     D WRUN            S              1
     D ACDE            S              1A
     D Pdayno          S              5  0                                      se
     D Pddate          S              6  0                                      se
     D Pddata          S              7                                         se
     D Pdrtn           S              1                                         se
     D Pddat8          S              8  0                                      se
     D PRdrtn          S              1
     D WZdate          S              6S 0
     D WFlag           S              1A
     D WSday           S              5S 0
     D PRqrdnb         S              5  0
     D WZDAYNO         S              5P 0
     D ZDAYNO          S              5S 0
     D PCMD            S            110
     D PCMDLEN         S             15  5
     D PMsgID          S              7A
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D ZCCY            S              3
     D ZDATFM          S              1
     D ZERR            S              1
     D PZDAYNO         S              5  0
     D PZCCY           S              3
     D PZIND           S              1
     D PZLOC           S              3
     D WValid          S              1
     D WValid2         S              1
     D WZdateNew       S              6
     D PProcDte        S              5P 0
     D PNxtProcDte     S              5P 0
     D PDayFwd         S              2P 0
     D PCurr           S              3A
     D PLoctn          S              3A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Allocate data area SC24X7
 
     C     *LOCK         IN        SC24X7
 
      ** Convert the two dates and set up screen information
 
     C                   EXSR      SRTSCR
 
      ** Setup attention key when pressed
 
     C                   EXSR      SRATNK
 
     C                   EVAL      WValid = 'Y'
 
     C                   DOU       WValid = 'N'
     C                   EXSR      SRDISP
 
     C                   IF        *INKL = '1'
     C                   EVAL      ACDE = 'C'
     C                   EVAL      WValid = 'N'
     C                   EVAL      *INLR = '1'
     C                   ELSE
     C                   EVAL      *IN24 = '0'
     C                   IF        (#0CNFM <> 'Y') AND (#0CNFM <> 'N')
     C                   EVAL      *IN24 = '1'
     C                   EVAL      PMsgId = 'SCC0015'
     C                   EVAL      WVAlid = 'N'
     C                   EXSR      SREROR
     C                   ENDIF
 
     C                   IF        (#0CNFM = 'Y')
     C                   IF        (WZDAYNO <> 0) AND
     C                             (*IN22 = '0')
     C                   EVAL      S1DATE = WZDAYNO
     C                   ELSE
     C                   EVAL      S1DATE = BJDNWD
     C                   ENDIF
 
      ** Setup Next processing date in dtaara SC24X7
 
     C                   EXSR      SRNEXT
 
     C                   OUT       SC24X7
     C                   EVAL      WValid = 'N'
     C                   EVAL      *INLR = '1'
     C                   ENDIF
 
     C                   IF        (#0CNFM = 'N')
     C                   EXSR      SRVALD
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (*INKL = '1')
     C                   EVAL      WValid = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: ZA0250, AOBANKR0                                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ACDE
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
 
      ** Obtain records from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If error found
 
     C                   IF        (PRtcd <> *BLANKS)
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 001
     C                   EVAL      DBfile = 'SDBANKPD'
     C                   EVAL      DBkey = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0RUNA = BJMRDT
 
     C                   CALL      'ZA0250'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EVAL      #0PGMQ = PSProcName
     C                   EVAL      #0CNFM = *Blanks
     C                   EVAL      *IN23 = '0'
     C                   EVAL      WValid = *Blanks
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      PsUser        PUSRP
     C     MUSER         PARM      MUSER         DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBKEY = PsUser
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         EVAL      AUS025 = 'N'                                               CSF002
      **********                                                                              CSF002
     C**********         IF        PCIU <> 'Y'                                                CSF002
     C**********                   AND PCIU <> 'E'                                            CSF002
     C**********         CALL      'AOSARDR0'                                                 CSF002
     C**********         PARM      *BLANKS       PRtCd                                        CSF002
     C**********         PARM      '*VERIFY'     POptn                                        CSF002
     C**********         PARM      'AUS025'      PSARD                                        CSF002
     C*****SCSARD        PARM      SCSARD        DSFDY                                        CSF002
      **********                                                                              CSF002
     C**********         IF        PRtCd <> *BLANKS                                           CSF002
     C**********                   AND PRtCd <> '*NRF'                                        CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 004                                                CSF002
     C**********         EVAL      DBFILE = 'SCSARDPD'                                        CSF002
     C**********         EVAL      DBKEY = 'AUS025'                                           CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         IF        PRTCD = *BLANKS                                            CSF002
     C**********         EVAL      AUS025 = 'Y'                                               CSF002
     C**********         ENDIF                                                                CSF002
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTSCR - Setup screen display and convert dates               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRCONV                                                 *
      *                                                               *
      *****************************************************************
     C     SRTSCR        BEGSR
 
      ** Convert the two dates in two formats (nnMMMnn and nn/nn/nn)
 
     C                   EVAL      Pdayno = BJRDNB
     C                   EXSR      SRCONV
     C                   EVAL      #0RDTE = Pddate
 
     C                   EVAL      Pddate = 0
     C                   EVAL      Pdayno = BJDNWD
     C                   EXSR      SRCONV
     C                   EVAL      #0NDTE = Pddate
 
      ** Set-up screen info and defaults
 
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EVAL      *IN23 = '1'
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      FMTDAT = BJMRDT
     C                   IF        (DATZRO = *BLANKS)
     C                   EVAL      DATZRO = '0'
     C                   ENDIF
     C     '('           CAT       FMTDAT        #0RDAY
     C     #0RDAY        CAT       ')':0         #0RDAY
     C                   CLEAR                   FMTDAT
     C                   EVAL      FMTDAT = Pddata
     C                   IF        (DATZRO = *BLANKS)
     C                   EVAL      DATZRO = '0'
     C                   ENDIF
     C     '('           CAT       FMTDAT        #0NDAY
     C     #0NDAY        CAT       ')':0         #0NDAY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRATNK - Setup attention key when pressed                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************
     C     SRATNK        BEGSR
 
      ** Check if session manager is present
 
     C**********         IF        AUS025 = 'Y'                                               CSF002
     C**********         CALL      'SCC004318'                          26                    CSF002
     C**********         IF        (*INU7 = *ON                                               CSF002
     C**********                   AND *INU8 = *ON)                                           CSF002
     C**********                   OR *IN26 = *ON                                             CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         EVAL      DBASE = 002                                                CSF002
     C**********         EVAL      DBFILE = 'SCC4318'                                         CSF002
     C**********         EVAL      DBKEY = '*CALL'                                            CSF002
     C**********         OUT       LDA                                                        CSF002
     C**********         EXSR      *PSSR                                                      CSF002
     C**********         ENDIF                                                                CSF002
      **********                                                                              CSF002
     C**********         ELSE                                                                 CSF002
      ****************************************************************                        CSF002
     C**********         EVAL      WCommand = WQcmd(1)                                        CSF002
     C**********         EVAL      WCmd1 = 'SFC0600'                                          CSF002
     C**********         EVAL      PCMD = WCommand                                            CSF002
     C**********         Z-ADD     32            PCMDLEN                                      CSF002
     C**********         CALL      'QCMDEXC'                                                  CSF002
     C**********         PARM                    PCMD                                         CSF002
     C**********         PARM                    PCMDLEN                                      CSF002
      **********                                                                              CSF002
     C**********         ENDIF                                                                CSF002
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISP - Screen Display Processing                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************
     C     SRDISP        BEGSR
 
     C                   WRITE     SC004300C0
     C                   EXFMT     SC004300F0
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNEXT - Computes next processing date for dtaara SC24X7     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: ZFWDT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRNEXT        BEGSR
 
      ** Call program to find next working day.
     C                   CLEAR                   PNxtProcDte
     C                   CALLB     'ZFWDT'
     C                   PARM      S1DATE        PProcDte
     C                   PARM      1             PDayFwd
     C                   PARM                    PNxtProcDte
     C                   PARM      BJLCCY        PCurr
     C                   PARM      *BLANKS       PLoctn
 
     C                   EVAL      S1NEXT = PNxtProcDte
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALD - Validation of New Date                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZDATE1, SRCONV, ZA0270, ZCHKH, SREROR, SRDISP          *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
      ** Get new date
 
     C                   EVAL      WValid2 = 'Y'
     C                   EVAL      WFLAG = ' '
     C                   EVAL      *IN30 = '0'
 
     C                   DOU       WValid2 = 'N'
     C                   EVAL      *IN23 = '0'
 
     C                   EXSR      SRDISP
 
     C                   IF        *INKL = '1'
     C                   EVAL      ACDE = 'C'
     C                   EVAL      WValid2 = 'N'
     C                   EVAL      *INLR = '1'
     C                   EVAL      *IN23 = '1'
     C                   EVAL      #0CNFM = ' '
     C                   ELSE
 
     C                   EVAL      *IN20 = '0'
     C                   EVAL      *IN21 = '0'
     C                   EVAL      *IN22 = '0'
     C                   EVAL      *IN25 = '0'
 
      ** Use SR ZDATE1 to convert date to day number form
 
     C                   EVAL      WZDAYNO = 0
     C                   EVAL      WZdate = #0DATE
     C                   MOVEL     WZdate        WZdateNew
     C                   EVAL      ZDATFM = BJDFIN
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    WZdateNew
     C                   PARM                    WZDAYNO
     C                   PARM                    ZDATFM
     C                   PARM                    ZERR
 
     C                   EVAL      ZDAYNO = WZDAYNO
 
     C                   IF        ZDAYNO = BJDNWD
     C                   EVAL      WValid2 = 'N'
     C                   EVAL      *IN25 = '1'
     C                   EVAL      *IN23 = '1'
     C                   EVAL      #0CNFM = ' '
     C                   ENDIF
 
     C                   IF        ZERR = 'Y'
     C                   EVAL      *IN30 = '1'
     C                   EVAL      PMsgId = 'SCC0007'
     C                   EXSR      SREROR
     C                   EVAL      *IN22 = '1'
     C                   ENDIF
 
 
      ** If date is valid, ensure that it is greater than last
      ** processing date
 
     C                   IF        ZDAYNO <= BJRDNB
     C                   EVAL      *IN30 = '1'
     C                   EVAL      PMsgId = 'SCC0008'
     C                   EXSR      SREROR
     C                   EVAL      *IN22 = '1'
     C                   ENDIF
 
     C                   IF        *IN22 = '0'
     C                   EVAL      WValid2 = 'N'
     C                   EVAL      *IN23 = '1'
     C                   EVAL      #0CNFM = ' '
     C                   ENDIF
 
      ** Check if date entered is holiday in local currency or if
      ** working days exist before date entered and previous rundate
 
     C                   IF        *IN22 = '0'
     C                   EVAL      ZCCY = BJLCCY
     C                   Z-ADD     ZDAYNO        PZDAYNO
     C                   EVAL      PZCCY = ZCCY
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDAYNO
     C                   PARM                    PZCCY
     C                   PARM      *BLANKS       PZLOC
     C                   PARM                    PZIND
 
     C                   IF        PZIND = 'H'
     C                   EVAL      *IN20 = '1'
     C                   EVAL      PMsgId = 'SCC0009'
     C                   EXSR      SREROR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WSday = ZDAYNO
     C                   EVAL      ZDAYNO = 0
     C                   EVAL      ZDAYNO = BJRDNB + 1
     C                   EVAL      PZDAYNO = ZDAYNO
 
      ** Check days in between run day + 1 and day entered to check
      ** if any working days exist in this period
 
     C                   IF        *IN25 = '0'
     C                   DOW       (*IN21 = '0') AND
     C                             (WSday <> ZDAYNO) AND
     C                             (*IN22 = '0')
 
     C                   IF        WSday > ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDAYNO
     C                   PARM                    PZCCY
     C                   PARM      *BLANKS       PZLOC
     C                   PARM                    PZIND
 
     C                   IF        PZIND = 'W'
     C                   EVAL      PMsgId = 'SCC0010'
     C                   EXSR      SREROR
     C                   EVAL      *IN21 = '1'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      ZDAYNO = ZDAYNO + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   EVAL      ZDAYNO = WSday
 
      ** If holiday in local currency, or working days exist, or a new
      ** date has been entered, request confirmation
 
     C                   IF        (*IN20 = '1') OR (*IN21 = '1')
     C                             OR (#0CNFM = ' ')
     C                   EVAL      *IN23 = '1'
 
      ** Reset confirmation flag
 
     C                   IF        #0CNFM <> 'Y'
     C                   EVAL      #0CNFM = ' '
     C                   ENDIF
 
      ** If a date has been entered, get Run day number for requested
      ** date
 
     C                   IF        *IN22 = '0'
     C                   CALL      'ZA0270'
     C                   PARM                    #0DATE
     C                   PARM                    BJDFIN
     C                   PARM                    PRdrtn
     C                   PARM                    PRqrdnb
 
      ** Format requested date
 
     C                   EVAL      Pdayno = PRqrdnb
     C                   EVAL      Pddate = #0DATE
     C                   EXSR      SRCONV
 
     C                   CLEAR                   FMTDAT
     C                   Z-ADD     #0DATE        #0NDTE
     C                   EVAL      FMTDAT = Pddata
     C                   IF        DATZRO = ' '
     C                   EVAL      DATZRO = '0'
     C                   ENDIF
     C     '('           CAT       FMTDAT        #0NDAY
     C     #0NDAY        CAT       ')':0         #0NDAY
     C                   ENDIF
     C                   ENDIF
 
      ** If holiday or working days exist prior to next day, get
      ** confirmation
 
     C                   IF        (*IN20 = '1') AND (WFlag <> 'Y')
     C                             OR (*IN21 = '1') AND (WFlag <> 'Y')
     C                   EVAL      #0CNFM = ' '
     C                   EVAL      WFlag = 'Y'
     C                   EVAL      WValid2 = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONV - Convert Dates to two formats                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0140                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCONV        BEGSR
 
     C                   CALL      'ZA0140'
     C                   PARM                    Pdayno
     C                   PARM                    BJDFIN
     C                   PARM                    Pddate
     C                   PARM                    Pddata
     C                   PARM                    Pdrtn
     C                   PARM                    Pddat8
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREROR - Send Error Message                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOCREPT                                                *
      *                                                               *
      *****************************************************************
 
     C     SREROR        BEGSR
 
     C                   CALLB     'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE IN FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** WQcmd
SETATNPGM PGM(        ) SET(*ON)
