     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Identification Type Selection')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000762S - Midas SD Identification Type Selection           *
      *                                                               *
      *  Function:  This program allows a user to select an           *
      *             existing Identification Type for use in another   *
      *             program.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR740749 *CREATE   Date 25Apr11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR740749 - Non Account Holder Maintenance Usability Issues   *
      *             (Child: AR740750)                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDIDTPL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Identification Types - Rtv Idx
 
     FSD000762S#CF   E             WORKSTN SFILE(SD000762S0:#0SFRN)
      ** Midas SD Identification Type Selection Display File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'
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
     D PIDTP           S              2A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KIDTP           S                   LIKE(IDIDTP)
 
      ** Working Variables
     D WIDTPCNT        S              4P 0
     D WPRecCnt        S              4P 0
     D W0SFRN          S              4P 0
 
     D WPErrFlg        S              1A
     D WPDspFlg        S              1A
     D WPBldFlg        S              1A
 
     D WRun            S              1A
     D WRead           S              1A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation    ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRIdTpMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpMain - Manages the Identification Type Subfile         *
      *                                                               *
      *****************************************************************
     C     SRIdTpMain    BEGSR
 
     C                   EXSR      SRIdTpInit
 
     C                   EXSR      SRIdTpClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRIdTpBld
 
     C                   EXSR      SRIdTpDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   EXSR      SRIdTpVal
 
     C                   IF        WPDspFlg = 'N' AND
     C                             WPBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PIDTP = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpInit - Handles the initial Identification Type         *
      *               subfile processing                              *
      *                                                               *
      *****************************************************************
     C     SRIdTpInit    BEGSR
 
      ** Initialise relevant variables
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags
 
     C                   EVAL      WPErrFlg = 'N'
     C                   EVAL      WPDspFlg = 'N'
     C                   EVAL      WPBldFlg = 'N'
 
      ** Set the file pointer
 
     C     *LOVAL        SETLL     SDIDTPL1
 
      ** Reset the subfile error indicator
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpClr - Clears the Identification Type subfile           *
      *                                                               *
      *****************************************************************
     C     SRIdTpClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000762C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpBld - Builds the Identification Type subfile           *
      *                                                               *
      *****************************************************************
     C     SRIdTpBld     BEGSR
 
      ** Build the subfile only if necessary
 
     C                   IF        WPDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key
 
     C                   IF        WPBldFlg = 'Y'
 
     C                   EXSR      SRIdTpClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WPBldFlg = 'N'
 
     C                   IF        #0KPRD <> *BLANKS
     C                   EVAL      KIDTP = #0KPRD
     C     KIDTP         SETLL     SDIDTPL1
     C                   ELSE
     C     *LOVAL        SETLL     SDIDTPL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WIDTPCNT = *ZERO
 
      ** Select all Identification Type
 
     C                   READ      SDIDTPL1
 
     C                   DOW       NOT %EOF(SDIDTPL1)
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0IDTP = IDIDTP
     C                   EVAL      #0NARR = IDNARR
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WIDTPCNT = WIDTPCNT + 1
     C                   WRITE     SD000762S0
 
      ** Leave the Identification Type selection if one subfile
      ** page has been filled
 
     C                   IF        WIDTPCNT = 14
 
      ** Check first if there are more records available
 
     C                   READ      SDIDTPL1
 
     C                   IF        %EOF
     C                   LEAVE
     C                   ELSE
     C                   READP     SDIDTPL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   READ      SDIDTPL1
 
     C                   ENDDO
 
      ** No Details to Display
 
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
      *  SRIdTpDsp - Displays the Identification Type Subfile         *
      *                                                               *
      *****************************************************************
     C     SRIdTpDsp     BEGSR
 
      ** Display the full Identification Type Selection screen
 
     C                   WRITE     SD000762F0
     C                   WRITE     SD000762C1
     C                   WRITE     SD000762F1
     C                   EXFMT     SD000762C0
 
      ** Clear all messages from the Program Message Queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpVal - Validates the Identification Type subfile        *
      *                                                               *
      *****************************************************************
     C     SRIdTpVal     BEGSR
 
      ** Initialise processing flags
 
     C                   EVAL      WPErrFlg = 'N'
     C                   EVAL      WPDspFlg = 'N'
     C                   EVAL      WPBldFlg = 'N'
 
      ** Reset the subfile error indicator
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WPRecCnt = *ZERO
 
     C                   READC     SD000762S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Action Code
 
     C                   EXSR      SRVPActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000762S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000762S0
 
     C                   ENDDO
 
     C                   IF        WPErrFlg = 'Y'
     C                   EVAL      WPDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection
 
     C                   READC     SD000762S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN = '1'
 
      ** At this point, a valid Identification Type has been selected
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PIDTP = #0IDTP
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000762S0
 
     C                   ENDDO
 
     C                   EVAL      WPBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPActCde - Validates the Action Code                       *
      *                                                               *
      *****************************************************************
     C     SRVPActCde    BEGSR
 
     C                   IF        #0ACTN <> *BLANKS
 
      ** Action Code must be '1' (Select)
 
     C                   IF        #0ACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WPErrFlg = 'Y'
     C                   EVAL      PMsgID = 'GPM0001'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected
 
     C                   EVAL      WPRecCnt = WPRecCnt + 1
 
     C                   IF        WPRecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WPErrFlg = 'Y'
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
      *             Queue via ZA0340                                  *
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
      *  *PSSR - Program Exception Subroutine                         *
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
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    PRetCde
 
      ** Identification Type
 
     C                   PARM                    PIDTP
 
      ** End Parameter List
      ** ==================
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Access Bank Details
 
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
 
      ** Set the system information display fields
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C     *LOVAL        SETLL     SDIDTPL1
     C                   READ      SDIDTPL1
     C                   IF        NOT %EOF
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2011
