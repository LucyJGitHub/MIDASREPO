     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global instrument codes selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  SD000013S - Midas GP Global Instrument Codes Selection       *
      *                                                               *
      *  Function:  This program allows a user to select an           *
      *             existing Global Instrument Code for use in        *
      *             another program.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG2072            Date 22Apr04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2072 - Don't allow deleted items to be selected.          *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPINSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GP Global Instruments by Global Instrument Code
 
     FSD000013S#CF   E             WORKSTN SFILE(SD000013S0:#0SFRN)
      ** Midas GP Global Instrument Codes Selection Display File
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S              7A
     D PGINS           S             10A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KGINS           S                   LIKE(INGINS)
 
      ** Working Variables
     D WGInsCnt        S              4P 0
     D WIRecCnt        S              4P 0
     D W0SFRN          S              4P 0
 
     D WIErrFlg        S              1A
     D WIDspFlg        S              1A
     D WIBldFlg        S              1A
 
     D WRun            S              1A
     D WRead           S              1A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRGInsMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGInsMain - Manages the Global Instrument Codes subfile.    *
      *                                                               *
      *****************************************************************
     C     SRGInsMain    BEGSR
 
     C                   EXSR      SRGInsInit
 
     C                   EXSR      SRGInsClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRGInsBld
 
     C                   EXSR      SRGInsDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   EXSR      SRGInsVal
 
     C                   IF        WIDspFlg = 'N' AND
     C                             WIBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PGINS = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGInsInit - Handles the initial Global Instrument Codes     *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRGInsInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WIDspFlg = 'N'
     C                   EVAL      WIBldFlg = 'N'
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     GPINSTL0
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGInsClr - Clears the Global Instrument Codes subfile.      *
      *                                                               *
      *****************************************************************
     C     SRGInsClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000013C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGInsBld - Builds the Global Instrument Codes subfile.      *
      *                                                               *
      *****************************************************************
     C     SRGInsBld     BEGSR
 
      ** Build the subfile only if necessary.
 
     C                   IF        WIDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WIBldFlg = 'Y'
 
     C                   EXSR      SRGInsClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WIBldFlg = 'N'
 
     C                   IF        #0KINS <> *BLANKS
     C                   EVAL      KGINS = #0KINS
     C     KGINS         SETLL     GPINSTL0
     C                   ELSE
     C     *LOVAL        SETLL     GPINSTL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WGInsCnt = *ZERO
 
      ** Select all Global Instrument Codes.
 
     C                   READ      GPINSTL0
 
     C                   DOW       NOT %EOF(GPINSTL0)
 
     C                   IF        INCHTP = 'D'                                              BUG2072
     C                   READ      GPINSTL0                                                  BUG2072
     C                   ITER                                                                BUG2072
     C                   ENDIF                                                               BUG2072
                                                                                             BUG2072
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0GINS = INGINS
     C                   EVAL      #0DESC = INDESC
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WGInsCnt = WGInsCnt + 1
     C                   WRITE     SD000013S0
 
      ** Leave the Global Instrument Codes selection if one subfile
      ** page has been filled.
 
     C                   IF        WGInsCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      GPINSTL0
 
     C                   IF        %EOF
     C                   LEAVE
     C                   ELSE
     C                   READP     GPINSTL0
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   READ      GPINSTL0
 
     C                   ENDDO
 
      ** No Details to Display.
 
     C                   IF        W0SFRN = *ZERO
     C                   EVAL      PMsgID = 'GPM0003'
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
      *  SRGInsDsp - Displays the Global Instrument Codes subfile.    *
      *                                                               *
      *****************************************************************
     C     SRGInsDsp     BEGSR
 
      ** Display the full Global Instrument Codes selection screen.
 
     C                   WRITE     SD000013F0
     C                   WRITE     SD000013C1
     C                   WRITE     SD000013F1
     C                   EXFMT     SD000013C0
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGInsVal - Validates the Global Instrument Codes subfile.   *
      *                                                               *
      *****************************************************************
     C     SRGInsVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WIDspFlg = 'N'
     C                   EVAL      WIBldFlg = 'N'
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WIRecCnt = *ZERO
 
     C                   READC     SD000013S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Instrument Action Code.
 
     C                   EXSR      SRVPActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000013S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000013S0
 
     C                   ENDDO
 
     C                   IF        WIErrFlg = 'Y'
     C                   EVAL      WIDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000013S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN = '1'
 
      ** At this point, a valid Instrument Code has been selected.
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PGINS = #0GINS
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000013S0
 
     C                   ENDDO
 
     C                   EVAL      WIBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPActCde - Validates the Instrument Action Code.           *
      *                                                               *
      *****************************************************************
     C     SRVPActCde    BEGSR
 
     C                   IF        #0ACTN <> *BLANKS
 
      ** Action Code must be '1' (Select).
 
     C                   IF        #0ACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'GPM0001'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   EVAL      WIRecCnt = WIRecCnt + 1
 
     C                   IF        WIRecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'GPM0002'
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
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    PRetCde
 
      ** Global Instrument Code
 
     C                   PARM                    PGINS
 
      ** End Parameter List
      ** ==================
 
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
 
      ** Set the system information display fields.
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C     *LOVAL        SETLL     GPINSTL0
     C                   READ      GPINSTL0
     C                   IF        NOT %EOF
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
