     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD T Distribution Table Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000745 - Midas SD T Distribution Table Maintenance         *
      *                                                               *
      *  Function:  This module manages a table of critical T         *
      *             Values used in Regression calculations.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS007             Date 26Apr04               *
      *  Prev Amend No. CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS007 - Hedge Accounting Control                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDTDTBL1  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SD T Distribution Table by Area and Degrees of Freedom
 
     FSD000745DFCF   E             WORKSTN SFILE(SD000745S0:#0SFRN)
     F                                     SFILE(SD000745S1:#1SFRN)
     F                                     SFILE(SD000745S2:#2SFRN)
      ** Midas SD T Distribution Table Display File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
     D  F05                   05     05
     D  F09                   09     09
     D  F10                   10     10
     D  F12                   12     12
 
      ** Subfile Management Indicators
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAS007
      ** External DS for SC Switchable Features                                               CAS007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS007
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A                                                      CAS007
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
 
      ** SPValTDTDta() Data Parameter
     D PData           S              7A
 
      ** Key Fields
     D KDFRD           S                   LIKE(XXDFRD)
     D KAREA           S                   LIKE(XXAREA)
     D KSFRN           S              4P 0
 
      ** Working Variables
     D WAreaCnt        S              4P 0
     D WDFrdCnt        S              4P 0
     D W0SFRN          S              4P 0
     D W1SFRN          S              4P 0
     D W2SFRN          S              4P 0
     D WStr            S              7A
     D WCurArea        S                   LIKE(XXAREA)
     D WPrvArea        S                   LIKE(XXAREA)
     D WXAREA          S                   LIKE(XXAREA)
     D WItrFlg         S              1A
     D WAreaFlg        S              1A
 
     D WAErrFlg        S              1A
     D WADspFlg        S              1A
     D WABldFlg        S              1A
     D WDErrFlg        S              1A
     D WDDspFlg        S              1A
     D WDBldFlg        S              1A
     D WTErrFlg        S              1A
     D WTDspFlg        S              1A
     D WTBldFlg        S              1A
 
     D WRetVal         S              7A
     D WArea           S              6A
     D WDFrd           S              3A
     D WData           S              7A
     D WARAF           S              6A
     D WARAA           S              5A
     D WACTN           S              1A
     D WTVLA           S              6A
     D WTDTCnt         S              4P 0
     D WRecCnt         S              4P 0
     D WTDTBase        S              3S 0
     D WTDTSeq         S              3S 0
     D WCurDFrd        S                   LIKE(XXDFRD)
     D WRunDFrd        S              4S 0
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      ** T Distribution Table Data Validation Function
     D SPValTDTDta     PR             7A
     D  PData                         7A   VALUE
     D  PType                         5A   VALUE
     D  PMode                         4A   VALUE
 
      ** Number Validation Function
     D SPIsNumeric     PR             1A
     D  PStr                          7A   VALUE
 
      ** Midas Standard Number Formatting/Validation Program
     D ZALIGN          PR                  EXTPGM('ZALIGN')
     D  PZRtCd                        7A
     D  PZFld                        16A
     D  PZADec                        1P 0 CONST
     D  PZADig                        2P 0 CONST
     D  PZAFld                       16A
 
      ** Midas Standard Program/Message Queue Bridge
     D ZA0340          PR                  EXTPGM('ZA0340')
     D  PMsgFile                     10A   CONST
     D  PMsgID                       10A   CONST
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRAreaMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaMain - Manages the Area in the Upper Tail (Alpha)      *
      *               subfile.                                        *
      *                                                               *
      *****************************************************************
     C     SRAreaMain    BEGSR
 
     C                   EXSR      SRAreaInit
 
     C                   EXSR      SRAreaClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRAreaBld
 
     C                   EXSR      SRAreaDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRAreaRef
 
     C                   WHEN      F09 = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SRTDTMain
     C                   EXSR      SRAreaRef
 
     C                   OTHER
     C                   EXSR      SRAreaVal
 
     C                   IF        WADspFlg = 'N' AND
     C                             WABldFlg = 'N'
     C                   EXSR      SRAreaRef
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaInit - Handles the initial Area in the Upper Tail      *
      *               (Alpha) subfile processing.                     *
      *                                                               *
      *****************************************************************
     C     SRAreaInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WAErrFlg = 'N'
     C                   EVAL      WADspFlg = 'N'
     C                   EVAL      WABldFlg = 'N'
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDTDTBL1
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaClr - Clears the Area in the Upper Tail (Alpha)        *
      *              subfile.                                         *
      *                                                               *
      *****************************************************************
     C     SRAreaClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000745C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaBld - Builds the Area in the Upper Tail (Alpha)        *
      *              subfile.                                         *
      *                                                               *
      *****************************************************************
     C     SRAreaBld     BEGSR
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *OFF
 
      ** Build the subfile only if necessary.
 
     C                   IF        WADspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        #0KARA <> *BLANKS AND
     C                             WABldFlg = 'Y'
     C                   EXSR      SRAreaClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WABldFlg = 'N'
 
     C                   EVAL      PData = #0KARA
 
      ** Format the display file Area key.
 
     C                   EVALR     WArea = SPValTDTDta(PData :
     C                             '*AREA' : '*FMT')
     C                   EVAL      #0KARA = WArea
 
      ** Set the file pointer.
 
     C                   EVAL      WData = SPValTDTDta(PData :
     C                             '*AREA' : '*ALN')
     C                   MOVE      WData         KAREA
     C     KAREA         SETLL     SDTDTBL1
     C                   ENDIF
 
     C                   EVAL      WAreaCnt = *ZERO
 
      ** Select all unique Areas in the Upper Tail (Alpha).
 
     C                   DOW       NOT %EOF(SDTDTBL1)
 
     C                   EXSR      SRAreaSel
 
     C                   IF        WAreaFlg = 'Y'
 
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVALR     WArea = %CHAR(WXAREA)
     C                   EVALR     #0AREA = %XLATE(' ' : '0' : WArea)
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WAreaCnt = WAreaCnt + 1
     C                   WRITE     SD000745S0
 
      ** Leave the Area selection if one subfile page has been filled.
 
     C                   IF        WAreaCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      SDTDTBL1
 
     C                   IF        %EOF(SDTDTBL1)
     C                   LEAVE
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** No Details to Display.
 
     C                   IF        W0SFRN = *ZERO
     C                   EVAL      PMsgID = 'SDA0004'
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaDsp - Displays the Area in the Upper Tail (Alpha)      *
      *              subfile.                                         *
      *                                                               *
      *****************************************************************
     C     SRAreaDsp     BEGSR
 
      ** Display the full Area in the Upper Tail selection screen.
 
     C                   WRITE     SD000745F0
     C                   WRITE     SD000745C3
     C                   WRITE     SD000745F1
     C                   EXFMT     SD000745C0
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaSel - Selects unique Areas in the Upper Tail (Alpha).  *
      *                                                               *
      *****************************************************************
     C     SRAreaSel     BEGSR
 
      ** Initialise working variables.
 
     C                   EVAL      WPrvArea = *ZERO
     C                   EVAL      WCurArea = *ZERO
     C                   EVAL      WXAREA = *ZERO
     C                   EVAL      WItrFlg = 'N'
     C                   EVAL      WAreaFlg = 'N'
 
     C                   READ      SDTDTBL1
 
      ** Leave unconditionally on an immediate EOF condition.
 
     C                   IF        %EOF(SDTDTBL1)
     C                   LEAVESR
     C                   ENDIF
 
     C                   DOW       NOT %EOF(SDTDTBL1)
 
      ** Set the previous Area on the first iteration.
 
     C                   IF        WItrFlg = 'N'
     C                   EVAL      WPrvArea = XXAREA
     C                   EVAL      WItrFlg = 'Y'
     C                   ENDIF
 
     C                   EVAL      WCurArea = XXAREA
 
      ** Leave only if a new Area is found.
 
     C                   IF        WPrvArea <> WCurArea
     C                   EVAL      WXAREA = WPrvArea
     C                   EVAL      WAreaFlg = 'Y'
     C     WCurArea      SETLL     SDTDTBL1
     C                   LEAVESR
     C                   ENDIF
 
     C                   READ      SDTDTBL1
 
     C                   ENDDO
 
     C                   EVAL      WXAREA = WPrvArea
     C                   EVAL      WAreaFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaRef - Refreshes the Area in the Upper Tail (Alpha)     *
      *              subfile.                                         *
      *                                                               *
      *****************************************************************
     C     SRAreaRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRAreaClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WADspFlg = 'N'
     C                   EVAL      WAErrFlg = 'N'
     C                   EVAL      WABldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #0KARA = *BLANKS
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0AREA = *BLANKS
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      W0SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDTDTBL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAreaVal - Validates the Area in the Upper Tail (Alpha)     *
      *              subfile.                                         *
      *                                                               *
      *****************************************************************
     C     SRAreaVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WAErrFlg = 'N'
     C                   EVAL      WADspFlg = 'N'
     C                   EVAL      WABldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Validate the Area Key.
 
     C                   EXSR      SRVAKey
 
     C                   READC     SD000745S0
 
     C                   DOW       NOT %EOF
 
      ** Validate the Area Action Code.
 
     C                   EXSR      SRVAActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000745S0
 
     C                   ENDDO
 
     C                   IF        WAErrFlg = 'Y'
     C                   EVAL      WADspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read through the subfile selections.
 
     C                   READC     SD000745S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN <> *BLANK
     C                   EXSR      SRDFrdMain
     C                   EVAL      #0ACTN = *BLANK
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   IF        F03 = *ON OR
     C                             F12 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   READC     SD000745S0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAKey - Validates the Area SF Key.                         *
      *                                                               *
      *****************************************************************
     C     SRVAKey       BEGSR
 
     C                   EVAL      *IN21 = *OFF
 
     C                   IF        #0KARA <> *BLANKS
 
     C                   EVAL      PData = #0KARA
     C                   EVAL      WRetVal = SPValTDTDta(PData :
     C                             '*AREA' : '*FMT')
 
      ** Area in the Upper Tail is invalid.
 
     C                   IF        WRetVal = *BLANKS
     C                   EVAL      WAErrFlg = 'Y'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      PMsgID = 'SDA0008'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      WABldFlg = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAActCde - Validates the Area SF Action Code.              *
      *                                                               *
      *****************************************************************
     C     SRVAActCde    BEGSR
 
     C                   EVAL      *IN22 = *OFF
 
     C                   IF        #0ACTN <> *BLANKS
 
      ** Action Code must be 'E', 'A', or 'D'.
 
     C                   IF        #0ACTN <> 'E' AND
     C                             #0ACTN <> 'A' AND
     C                             #0ACTN <> 'D'
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WAErrFlg = 'Y'
     C                   EVAL      PMsgID = 'SDA0006'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdMain - Manages the Degree of Freedom subfile.          *
      *                                                               *
      *****************************************************************
     C     SRDFrdMain    BEGSR
 
     C                   EXSR      SRDFrdInit
 
     C                   EXSR      SRDFrdClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRDFrdBld
 
     C                   EXSR      SRDFrdDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRDFrdRef
 
     C                   WHEN      F09 = *ON
     C                   EXSR      SRTDTMain
 
     C                   WHEN      F10 = *ON
     C                   EXSR      SRACasDel
     C                   LEAVESR
 
     C                   WHEN      F12 = *ON
     C                   LEAVESR
 
     C                   OTHER
     C                   EXSR      SRDFrdVal
 
     C                   IF        WDDspFlg = 'N' AND
     C                             WDBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDTVal - Validates the Degree of Freedom SF T Values.      *
      *                                                               *
      *****************************************************************
     C     SRVDTVal      BEGSR
 
     C                   EVAL      *IN24 = *OFF
 
     C                   EVAL      WRetVal = SPValTDTDta(PData :
     C                             '*TVAL' : '*FMT')
 
      ** T Value is invalid.
 
     C                   IF        WRetVal = *BLANKS
     C                   EVAL      WDErrFlg = 'Y'
     C                   EVAL      *IN24 = *ON
     C                   EVAL      PMsgID = 'SDA0011'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdInit - Handles the initial Degree of Freedom subfile   *
      *               processing.                                     *
      *                                                               *
      *****************************************************************
     C     SRDFrdInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      WACTN = #0ACTN
 
     C                   EVAL      PData = #0AREA
     C                   EVALR     WARAF = SPValTDTDta(PData :
     C                             '*AREA' : '*FMT')
     C                   EVALR     WARAA = SPValTDTDta(PData :
     C                             '*AREA' : '*ALN')
     C                   EVAL      #1AREA = WARAF
     C                   EVAL      #1KDFR = *BLANKS
 
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WDErrFlg = 'N'
     C                   EVAL      WDDspFlg = 'N'
     C                   EVAL      WDBldFlg = 'N'
 
      ** Set the file pointer.
 
     C                   MOVE      WARAA         KAREA
     C     KAREA         SETLL     SDTDTBL1
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *OFF
 
     C                   SELECT
 
     C                   WHEN      WACTN = 'E'
 
      ** Protect the T Value field.
 
     C                   EVAL      *IN44 = *ON
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
     C                   WHEN      WACTN = 'A'
 
      ** Unprotect the T Value field.
 
     C                   EVAL      *IN44 = *OFF
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
     C                   WHEN      WACTN = 'D'
 
      ** Protect the T Value field.
 
     C                   EVAL      *IN44 = *ON
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *ON
     C                   EVAL      *IN87 = *ON
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdClr - Clears the Degree of Freedom subfile.            *
      *                                                               *
      *****************************************************************
     C     SRDFrdClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000745C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdBld - Builds the Degree of Freedom subfile.            *
      *                                                               *
      *****************************************************************
     C     SRDFrdBld     BEGSR
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      *IN83 = *OFF
 
      ** Set the screen footer.
 
     C                   SELECT
 
     C                   WHEN      WACTN = 'E'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
     C                   WHEN      WACTN = 'A'
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
     C                   WHEN      WACTN = 'D'
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *ON
     C                   EVAL      *IN87 = *ON
 
     C                   ENDSL
 
      ** Build the subfile only if necessary.
 
     C                   IF        WDDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        #1KDFR <> *BLANKS AND
     C                             WDBldFlg = 'Y'
     C                   EXSR      SRDFrdClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WDBldFlg = 'N'
     C                   EVALR     WDFrd = %TRIM(#1KDFR)
     C                   EVAL      #1KDFR = WDFrd
 
      ** Set the file pointer.
 
     C                   MOVE      WDFrd         KDFRD
     C     KTDTB         SETLL     SDTDTBL1
     C                   ENDIF
 
     C                   EVAL      WDFrdCnt = *ZERO
 
      ** Read all available Degrees of Freedom.
 
     C     KAREA         READE     SDTDTBL1
 
     C                   DOW       NOT %EOF(SDTDTBL1)
 
     C                   EVAL      *IN24 = *OFF
     C                   MOVE      XXDFRD        #1DFRD
     C                   EVALR     #1TVAL = %CHAR(XXTVAL)
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WDFrdCnt = WDFrdCnt + 1
     C                   WRITE     SD000745S1
 
      ** Leave the Degree of Freedom subfile if one subfile page
      ** has been filled.
 
     C                   IF        WDFrdCnt = 12
 
      ** Check first if there are more records available.
 
     C     KAREA         READE     SDTDTBL1
 
     C                   IF        %EOF(SDTDTBL1)
     C                   LEAVE
     C                   ELSE
     C     KAREA         READPE    SDTDTBL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C     KAREA         READE     SDTDTBL1
 
     C                   ENDDO
 
      ** No Details to Display.
 
     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'SDA0004'
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdDsp - Displays the Degree of Freedom subfile.          *
      *                                                               *
      *****************************************************************
     C     SRDFrdDsp     BEGSR
 
      ** Display the full Degree of Freedom selection screen.
 
     C                   WRITE     SD000745F0
     C                   WRITE     SD000745C3
     C                   WRITE     SD000745F1
     C                   EXFMT     SD000745C1
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdRef - Refreshes the Degree of Freedom subfile.         *
      *                                                               *
      *****************************************************************
     C     SRDFrdRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRDFrdClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WDDspFlg = 'N'
     C                   EVAL      WDErrFlg = 'N'
     C                   EVAL      WDBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #1KDFR = *BLANKS
     C                   EVAL      #1DFRD = *BLANKS
     C                   EVAL      #1TVAL = *BLANKS
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
 
      ** Set the file pointer.
 
     C     KAREA         SETLL     SDTDTBL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDFrdVal - Validates the Degree of Freedom subfile.         *
      *                                                               *
      *****************************************************************
     C     SRDFrdVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WDErrFlg = 'N'
     C                   EVAL      WDDspFlg = 'N'
     C                   EVAL      WDBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
 
      ** Validate the Degree of Freedom Key.
 
     C                   EXSR      SRVDKey
 
     C                   IF        WACTN <> 'E'
 
     C                   READC     SD000745S1
 
     C                   DOW       NOT %EOF
 
      ** Validate the T Value.
 
     C                   EVAL      PData = #1TVAL
     C                   EXSR      SRVDTVal
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000745S1
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        WDErrFlg = 'Y'
     C                   EVAL      WDDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Update the T Distribution Table.
 
     C                   IF        WACTN <> 'E'
 
     C                   READC     SD000745S1
 
     C                   DOW       NOT %EOF
 
     C                   EXSR      SRTDTUpd
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000745S1
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDKey - Validates the Degree of Freedom SF Key.            *
      *                                                               *
      *****************************************************************
     C     SRVDKey       BEGSR
 
     C                   EVAL      *IN23 = *OFF
 
     C                   IF        #1KDFR <> *BLANKS
 
     C                   EVAL      PData = #1KDFR
     C                   EVAL      WRetVal = SPValTDTDta(PData :
     C                             '*DFRD' : '*FMT')
 
      ** Degree of Freedom is invalid.
 
     C                   IF        WRetVal = *BLANKS
     C                   EVAL      WDErrFlg = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EVAL      PMsgID = 'SDA0010'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      WDBldFlg = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTUpd - Updates the T Distribution Table.                 *
      *                                                               *
      *****************************************************************
     C     SRTDTUpd      BEGSR
 
      ** Align the T Value involved.
 
     C                   EVAL      PData = #1TVAL
     C                   EVALR     WTVLA = SPValTDTDta(PData :
     C                             '*TVAL' : '*ALN')
 
     C                   MOVE      WARAA         KAREA
     C                   MOVE      #1DFRD        KDFRD
     C     KTDTB         CHAIN     SDTDTBL1
 
     C                   IF        %FOUND(SDTDTBL1)
     C                   MOVE      WTVLA         XXTVAL
     C                   EVAL      XXCHTP = 'A'
     C                   EVAL      XXLCD = BJRDNB
     C                   UPDATE    SDTDTBD0
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTDTBPD'
     C                   EVAL      DBKey = %CHAR(KAREA) + %CHAR(KDFRD)
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACasDel - Deletes an Area by cascadingly deleting all of   *
      *              its Degrees of Freedom.                          *
      *                                                               *
      *****************************************************************
     C     SRACasDel     BEGSR
 
     C     KAREA         SETLL     SDTDTBL1
     C     KAREA         READE     SDTDTBL1
 
     C                   DOW       NOT %EOF(SDTDTBL1)
     C                   DELETE    SDTDTBL1
     C     KAREA         READE     SDTDTBL1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTMain - Manages the T Distribution Table input SF.       *
      *                                                               *
      *****************************************************************
     C     SRTDTMain     BEGSR
 
     C                   EXSR      SRTDTInit
 
     C                   EXSR      SRTDTClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRTDTBld
 
     C                   EXSR      SRTDTDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRTDTRef
 
     C                   WHEN      F12 = *ON
     C                   LEAVESR
 
     C                   OTHER
     C                   EXSR      SRTDTVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTInit - Handles the initial T Distribution Table input   *
      *              SF processing.                                   *
      *                                                               *
      *****************************************************************
     C     SRTDTInit     BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W2SFRN = *ZERO
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *ON
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
      ** Unprotect the Area field if necessary.
 
     C                   IF        WACTN = 'I'
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      #2AREA = *BLANKS
     C                   ELSE
     C                   EVAL      *IN45 = *ON
     C                   EVAL      #2AREA = WARAF
     C                   ENDIF
 
      ** Set the Degree of Freedom base (starting) value.
 
     C                   EXSR      SRTDTBase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTBld - Builds the T Distribution Table input SF.         *
      *                                                               *
      *****************************************************************
     C     SRTDTBld      BEGSR
 
      ** Set the subfile screen name.
 
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *ON
 
      ** Set the screen footer.
 
     C                   EVAL      *IN84 = *ON
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
 
      ** Build the subfile only if necessary.
 
     C                   IF        (WTDspFlg = 'Y' OR WTDTSeq = 999) AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the input subfile.
 
     C                   EVAL      WTDTCnt = *ZERO
 
     C                   DOW       WTDTCnt < 12
 
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      WTDTSeq = WTDTSeq + 1
     C                   MOVE      WTDTSeq       #2DFRD
     C                   EVAL      #2TVAL = *BLANKS
     C                   EVAL      W2SFRN = W2SFRN + 1
     C                   EVAL      #2SFRN = W2SFRN
     C                   EVAL      WTDTCnt = WTDTCnt + 1
     C                   WRITE     SD000745S2
 
      ** Stop building the subfile once the maximum Degree of Freedom
      ** is reached.
 
     C                   IF        WTDTSeq = 999
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTVal - Validates the T Distribution Table input SF.      *
      *                                                               *
      *****************************************************************
     C     SRTDTVal      BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Initialise relevant variables.
 
     C                   EVAL      WRunDFrd = WTDTBase + 1
     C                   EVAL      WCurDFrd = *ZERO
 
      ** Validate the Area in the Upper Tail (Alpha).
 
     C                   IF        WACTN = 'I'
     C                   EXSR      SRVTArea
     C                   ENDIF
 
     C                   READC     SD000745S2
 
     C                   DOW       NOT %EOF
 
      ** Validate the T Value.
 
     C                   EVAL      PData = #2TVAL
     C                   EXSR      SRVTTVal
 
      ** Validate the sequence integrity.
 
     C                   IF        *IN26 = *OFF
     C                   EXSR      SRVTSeq
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000745S2
 
     C                   ENDDO
 
      ** Validate the record count.
 
     C                   IF        WTErrFlg <> 'Y'
 
      ** No Details to Write.
 
     C                   IF        WRunDFrd = (WTDTBase + 1)
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'SDA0005'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WTErrFlg = 'Y'
     C                   EVAL      WTDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Update the T Distribution Table.
 
     C                   READC     SD000745S2
 
     C                   DOW       NOT %EOF
 
     C                   EXSR      SRTDTWrt
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000745S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000745S2
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTArea - Validates the Area in the Upper Tail (Alpha).     *
      *                                                               *
      *****************************************************************
     C     SRVTArea      BEGSR
 
     C                   EVAL      *IN25 = *OFF
 
      ** Area in the Upper Tail must be entered.
 
     C                   IF        #2AREA = *BLANKS
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMsgID = 'SDA0007'
     C                   EXSR      SRSndErr
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      PData = #2AREA
     C                   EVALR     WRetVal = SPValTDTDta(PData :
     C                             '*AREA' : '*ALN')
 
      ** Area in the Upper Tail is invalid.
 
     C                   IF        WRetVal = *BLANKS
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMsgID = 'SDA0008'
     C                   EXSR      SRSndErr
     C                   LEAVESR
     C                   ENDIF
 
     C                   MOVE      WRetVal       KAREA
     C     KAREA         CHAIN     SDTDTBL1
 
      ** Area in the Upper Tail already exists.
 
     C                   IF        %FOUND(SDTDTBL1)
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      PMsgID = 'SDA0009'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTSeq - Validates the sequence integrity.                  *
      *                                                               *
      *****************************************************************
     C     SRVTSeq       BEGSR
 
     C                   IF        #2TVAL <> *BLANKS
 
     C                   MOVE      #2DFRD        WCurDFrd
 
      ** T Value must not skip sequences.
 
     C                   IF        WRunDFrd <> WCurDFrd
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      PMsgID = 'SDA0012'
     C                   EXSR      SRSndErr
     C                   EVAL      WRunDFrd = WCurDFrd
     C                   ENDIF
 
     C                   EVAL      WRunDFrd = WRunDFrd + 1
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTBase - Sets the T Distribution Table Degree of Freedom  *
      *              base (starting) value.                           *
      *                                                               *
      *****************************************************************
     C     SRTDTBase     BEGSR
 
     C                   IF        WACTN = 'A'
 
     C                   MOVE      WARAA         KAREA
     C                   EVAL      KDFRD = *HIVAL
     C     KTDTB         SETGT     SDTDTBL1
     C                   READP     SDTDTBL1
 
     C                   IF        NOT %EOF(SDTDTBL1)
     C                   EVAL      WTDTBase = XXDFRD
     C                   ELSE
     C                   EVAL      WTDTBase = *ZERO
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WTDTBase = *ZERO
     C                   ENDIF
 
     C                   EVAL      WTDTSeq = WTDTBase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTWrt - Writes new T Distribution Table records.          *
      *                                                               *
      *****************************************************************
     C     SRTDTWrt      BEGSR
 
      ** Align the Area in the Upper Tail (Alpha) and T Value fields.
 
     C                   EVAL      PData = #2AREA
     C                   EVALR     WARAA = SPValTDTDta(PData :
     C                             '*AREA' : '*ALN')
 
     C                   EVAL      PData = #2TVAL
     C                   EVALR     WTVLA = SPValTDTDta(PData :
     C                             '*TVAL' : '*ALN')
 
     C                   MOVE      WARAA         KAREA
     C                   MOVE      #2DFRD        KDFRD
     C     KTDTB         CHAIN     SDTDTBL1
 
     C                   IF        NOT %FOUND(SDTDTBL1)
     C                   MOVE      WARAA         XXAREA
     C                   MOVE      #2DFRD        XXDFRD
     C                   MOVE      WTVLA         XXTVAL
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
     C                   WRITE     SDTDTBD0
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTDTBPD'
     C                   EVAL      DBKey = %CHAR(KAREA) + %CHAR(KDFRD)
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTRef - Refreshes the T Distribution Table input SF.      *
      *                                                               *
      *****************************************************************
     C     SRTDTRef      BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRTDTClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #2DFRD = *BLANKS
     C                   EVAL      #2TVAL = *BLANKS
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      W2SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
      ** Set the Degree of Freedom base (starting) value.
 
     C                   EXSR      SRTDTBase
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTClr - Clears the T Distribution Table input SF.         *
      *                                                               *
      *****************************************************************
     C     SRTDTClr      BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000745C2
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTDTDsp - Displays the T Distribution Table input SF.       *
      *                                                               *
      *****************************************************************
     C     SRTDTDsp      BEGSR
 
      ** Display the full T Distribution Table input screen.
 
     C                   WRITE     SD000745F0
     C                   WRITE     SD000745C3
     C                   WRITE     SD000745F1
     C                   EXFMT     SD000745C2
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTTVal - Validates the T Distribution Table input SF       *
      *             T Values.                                         *
      *                                                               *
      *****************************************************************
     C     SRVTTVal      BEGSR
 
     C                   EVAL      *IN26 = *OFF
 
     C                   IF        PData <> *BLANKS
 
     C                   EVAL      WRetVal = SPValTDTDta(PData :
     C                             '*TVAL' : '*FMT')
 
      ** T Value is invalid.
 
     C                   IF        WRetVal = *BLANKS
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      PMsgID = 'SDA0011'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the Program Message       *
      *             Queue via ZA0340.                                 *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR
 
     C                   CALLP     ZA0340(PMsgFile : PMsgID)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Midas SD T Distribution Table Key List
 
     C     KTDTB         KLIST
     C                   KFLD                    KAREA
     C                   KFLD                    KDFRD
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS007
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   CALL      'AOSARDR0'                                                 CAS007
     C                   PARM      *BLANKS       PRTCD                                        CAS007
     C                   PARM      '*VERIFY'     POPTN                                        CAS007
     C                   PARM      'CAS007'      PSARD                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
      ** If CAS007 is not installed, exit from the program                                    CAS007
                                                                                              CAS007
     C                   IF        PRTCD = '*NRF   '                                          CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        PRTCD <> *BLANKS  AND                                      CAS007
     C                             PRTCD <> '*NRF   '                                         CAS007
     C                   EVAL      DBKEY = PSARD                                              CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE  =  4                                                CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
 
      ** Set the system information display fields.
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPValTDTDta - Validates and formats T Distribution Table     *
      *                Data.                                          *
      *                                                               *
      *****************************************************************
     P SPValTDTDta     B
     D SPValTDTDta     PI             7A
     D  PData                         7A   VALUE
     D  PType                         5A   VALUE
     D  PMode                         4A   VALUE
 
      ** ZALIGN Parameters
     D PZRtCd          S              7A
     D PZFld           S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PZAFld          S             16A
 
      ** Working Variables
     D WRetVal         S              7A
     D WData           S              7A
     D WDFrd           S                   LIKE(XXDFRD)
     D WArea           S                   LIKE(XXAREA)
     D WTValue         S                   LIKE(XXTVAL)
 
      ** Is the given T Distribution Data numeric?
 
     C                   IF        SPIsNumeric(PData) = 'Y'
 
      ** Begin Data Conversion
      ** =====================
 
      ** Set the numerical format depending upon the given Data Type.
 
     C                   SELECT
 
      ** Area in the Upper Tail (Alpha).
 
     C                   WHEN      PType = '*AREA'
     C                   EVAL      PZADec = 4
     C                   EVAL      PZADig = 1
 
      ** Critical T Value.
 
     C                   WHEN      PType = '*TVAL'
     C                   EVAL      PZADec = 3
     C                   EVAL      PZADig = 3
 
      ** Degree of Freedom.
 
     C                   WHEN      PType = '*DFRD'
     C                   EVAL      PZADec = *ZERO
     C                   EVAL      PZADig = 3
 
     C                   ENDSL
 
      ** Validate the T Distribution Table Data via ZALIGN.
 
     C                   EVAL      PZFld = PData
 
     C                   CALLP     ZALIGN(PZRtCd : PZFld :
     C                             PZADec : PZADig : PZAFld)
 
     C                   IF        PZRtCd = *BLANKS
 
      ** Set the Return Value depending upon the given Data Type.
 
     C                   SELECT
 
      ** Area in the Upper Tail (Alpha).
 
     C                   WHEN      PType = '*AREA'
     C                   MOVE      PZAFld        WArea
     C                   EVALR     WData = %CHAR(WArea)
 
      ** Critical T Value.
 
     C                   WHEN      PType = '*TVAL'
     C                   MOVE      PZAFld        WTValue
     C                   EVALR     WData = %CHAR(WTValue)
 
      ** Degree of Freedom.
 
     C                   WHEN      PType = '*DFRD'
     C                   MOVE      PZAFld        WDFrd
     C                   EVALR     WData = %CHAR(WDFrd)
 
     C                   ENDSL
 
      ** Set the Return Value depending upon the given Mode.
 
      ** Aligned Value.
 
     C                   IF        PMode = '*ALN'
     C                   EVALR     WRetVal = PZAFld
     C                   ENDIF
 
      ** Formatted Value.
 
     C                   IF        PMode = '*FMT'
     C                   EVALR     WRetVal = WData
     C                   ENDIF
 
     C                   ENDIF
 
      ** End Data Conversion
      ** ===================
 
     C                   ENDIF
 
     C                   RETURN    WRetVal
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPIsNumeric - Checks whether a given string value is         *
      *                numeric or not.                                *
      *                                                               *
      *****************************************************************
     P SPIsNumeric     B
     D SPIsNumeric     PI             1A
     D  PStr                          7A   VALUE
 
      ** Working Variables
     D WRetCde         S              1A   INZ('N')
     D WPos            S              2P 0
 
     C                   IF        PStr <> *BLANKS
 
     C                   EVAL      WPos = %CHECK('0123456789.' :
     C                             %TRIM(PStr))
 
     C                   IF        WPos = *ZERO
     C                   EVAL      WRetCde = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN    WRetCde
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2003
