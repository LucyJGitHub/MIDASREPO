     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Identification Types Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000762 - Midas SD Identification Types Maintenance         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSW207             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Identification Types - Update Index
     FSDIDTPL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Identification Types - Retrieve Index
     FSDIDTPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIDTPD0:SDIDTPD1)
 
      ** Midas SD Standing Data Controls
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@AHREAU:SDFCTLD0)
 
      ** Midas SD Identification Types  Maintenance Display
     FSD000762DFCF   E             WORKSTN SFILE(SD000762S1:#1SFRN)
     F                                     SFILE(SD000762S2:#2SFRN)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PSProcName       *PROC
     D  PSPgmStat        *STATUS
     D  PSJobName            244    253
     D  PSUser               254    263
     D  PSProcPgm            334    343
     D  PSProcMod            344    353
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
     D  F05                   05     05
     D  F09                   09     09
     D  F12                   12     12
 
      ** Subfile Management Indicators
     D  ENQMODE               90     90
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Insert Screen Data Structure
     D ISCR            DS
     D  #2IDTP                 1      2
     D  #2NARR                 3     32
     D  #2SWCD                33     36                                                       CSW207
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Midas SD Midas modules Data Structure                                                CSW207
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSW207
                                                                                              CSW207
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PMode           S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Standard Utility Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KFLNM           S                   LIKE(AHFLNM)
 
      ** Working Variables
     D WNARRCnt        S              4P 0
     D WiScrCnt        S              4P 0
     D W1SFRN          S              4P 0
     D W2SFRN          S              4P 0
 
     D WACTN           S              1A
 
     D WTErrFlg        S              1A
     D WTDspFlg        S              1A
     D WTBldFlg        S              1A
     D WIErrFlg        S              1A
     D WIDspFlg        S              1A
     D WIBldFlg        S              1A
 
      ** QCLSCAN workfields
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQG3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WQCTTR          S                   LIKE(#1POS2)
     D WPostFlg        s              1    inz('N')
 
      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1                                                       CSW207
                                                                                              CSW207
      ** SWIFT 2009 Installed Flag                                                            CSW209
     D CSW209          S              1                                                       CSW209
                                                                                              CSW209
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EVAL      *IN23 = *ON                                                CSW207
     C                   EVAL      *IN34 = *ON                                                CSW207
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EVAL      *IN23 = *OFF                                               CSW207
     C                   EVAL      *IN34 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EXSR      SRIdTpMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpMain - Manages the Identificationt Types subfile       *
      *                                                               *
      *****************************************************************
     C     SRIdTpMain    BEGSR
 
      ** Do while F3 is not pressed
 
     C                   DOW       F03 = *OFF
 
      ** Build Identification Types subfile
 
     C                   EXSR      SRIdTpBld
 
      ** Display Identification Types subfile
 
     C                   EXSR      SRIdTpDsp
 
      ** If not F3 and not RollUp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
      ** Refresh screen
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRIdTpRef
 
      ** Go to Add Mode
 
     C                   WHEN      F09 = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SRiScrMain
     C                   EXSR      SRIdTpRef
 
     C                   OTHER
 
     C                   IF        W1SFRN <> *ZERO
 
      ** Validate Identification Types subfile
 
     C                   EXSR      SRIdTpVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N'
 
      ** Refresh Identification Types subfile
 
     C                   EXSR      SRIdTpRef
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpInit - Handles the initial Identification Types        *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRIdTpInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDIDTPL1
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF                                               CSW207
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpRef - Refreshes the Identification Types subfile.      *
      *                                                               *
      *****************************************************************
     C     SRIdTpRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRIdTpClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #1POS1 = *BLANKS
     C                   EVAL      #1POS2 = *BLANKS
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1IDTP = *BLANKS
     C                   EVAL      #1NARR = *BLANK
     C                   EVAL      #1SWCD = *BLANKS                                           CSW207
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF                                               CSW207
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDIDTPL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpClr - Clears the Identification Types  subfile.        *
      *                                                               *
      *****************************************************************
     C     SRIdTpClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000762C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpBld - Builds the Identification Types subfile          *
      *                                                               *
      *****************************************************************
     C     SRIdTpBld     BEGSR
 
     C                   EVAL      WPostFlg = 'N'
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
 
      ** Build the subfile only if necessary.
 
     C                   IF        WTDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WTBldFlg = 'Y'
 
     C                   EXSR      SRIdTpClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WTBldFlg = 'N'
 
     C                   IF        #1POS1 <> *BLANKS
     C     #1POS1        SETLL     SDIDTPL1
     C                   ELSE
     C     *LOVAL        SETLL     SDIDTPL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WNARRCnt = *ZERO
 
      ** Select all Identification Types
 
     C                   READ      SDIDTPL1
 
     C                   DOW       NOT %EOF(SDIDTPL1)
 
     C                   IF        IDCHTP <> 'D'
 
     C                   IF        #1POS1 = *BLANKS AND #1POS2 <> *BLANKS
     C                             AND WPostFlg = 'N'
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    IDNARR
     C                   PARM      20            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM      #1POS2        WQCTTR
     C                   PARM      20            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N = 1
 
      ** Clear subfile
 
     C                   EXSR      SRIdTpClr
 
     C                   EVAL      WPostFlg = 'Y'
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF                                               CSW207
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1IDTP = IDIDTP
     C                   EVAL      #1NARR = IDNARR
     C                   EVAL      #1SWCD = IDSWCD                                            CSW207
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WNARRCnt = WNARRCnt + 1
     C                   WRITE     SD000762S1
 
      ** Leave the Identification Types selection if one subfile
      ** page has been filled.
 
     C                   IF        WNARRCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      SDIDTPL1
 
     C                   IF        %EOF(SDIDTPL1)
     C                   LEAVE
     C                   ELSE
     C                   READP     SDIDTPL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDIDTPL1
 
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'USR4732'
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
      *  SRIdTpDsp - Displays the Identification Types subfile        *
      *                                                               *
      *****************************************************************
     C     SRIdTpDsp     BEGSR
 
      ** Display the full Identifications Types selection screen.
 
     C                   WRITE     SD000762F1
     C                   WRITE     SD000762C3
     C                   WRITE     SD000762F2
     C                   EXFMT     SD000762C1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpVal - Validates the Identification Types subfile       *
      *                                                               *
      *****************************************************************
     C     SRIdTpVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF                                               CSW207
 
     C                   READC     SD000762S1
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN24 = *OFF                                               CSW207
 
      ** Validate the Action Code.
 
     C                   EXSR      SRVActn
 
      ** Validate the Narratives
 
     C                   IF        #1ACTN <> 'D'                                              CSW207
     C                   EXSR      SRVNARR1
     C                   Endif                                                                CSW207
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000762S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000762S1
 
     C                   ENDDO
 
     C                   IF        WTErrFlg = 'Y'
     C                   EVAL      WTDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000762S1
 
     C                   DOW       NOT %EOF
 
     C                   IF        #1ACTN = 'D'
     C                   EVAL      WACTN = 'D'
     C                   ELSE
     C                   EVAL      WACTN = 'A'
     C                   ENDIF
 
     C                   EXSR      SRIdTpUpd
 
     C                   READC     SD000762S1
 
     C                   ENDDO
 
     C                   EVAL      WTBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIdTpUpd - Updates the Identification Types                 *
      *                                                               *
      *****************************************************************
     C     SRIdTpUpd     BEGSR
 
     C     #1IDTP        CHAIN     SDIDTPL0
 
     C                   IF        %FOUND(SDIDTPL0)
 
     C                   SELECT
     C                   WHEN      WACTN = 'A'
     C                   EVAL      IDCHTP = WACTN
     C                   EVAL      IDLCDT = BJRDNB
     C                   EVAL      IDIDTP = #1IDTP
     C                   EVAL      IDNARR = #1NARR
     C                   EVAL      IDSWCD = #1SWCD                                            CSW207
     C                   UPDATE    SDIDTPD0
     C                   WHEN      WACTN = 'D'
     C                   DELETE    SDIDTPD0
     C                   ENDSL
 
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDIDTPL0'
     C                   EVAL      DBKey = #1IDTP
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update Standing Data Controls.
 
     C                   EVAL      KFLNM = 'SDIDTPPD'
     C     KFLNM         CHAIN     SDFCTLL0
 
     C                   IF        %FOUND(SDFCTLL0)
 
     C                   SELECT
 
     C                   WHEN      WACTN = 'A'
     C                   EVAL      AHNOAM = AHNOAM + 1
 
     C                   WHEN      WACTN = 'D'
     C                   EVAL      AHNORC = AHNORC - 1
     C                   EVAL      AHNODL = AHNODL + 1
 
     C                   ENDSL
 
     C                   UPDATE    SDFCTLD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBKey = KFLNM
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVActn - Validates the Action Code.                         *
      *                                                               *
      *****************************************************************
     C     SRVActn       BEGSR
 
     C                   IF        #1ACTN <> *BLANKS
 
     C                   IF        #1ACTN <> 'D'
 
      ** Action Code must be 'D' (Delete).
 
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4723'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIdTp - Validates the Identification Types                 *
      *                                                               *
      *****************************************************************
     C     SRVIdTp       BEGSR
 
     C                   IF        #2NARR <> *BLANKS
 
     C                   IF        #2IDTP = *BLANKS
 
      ** Identification Types is mandatory if any of the other
      ** fields are input.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4750'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #2SWCD <> *BLANKS                                          CSW207
                                                                                              CSW207
     C                   IF        #2IDTP = *BLANKS                                           CSW207
                                                                                              CSW207
      ** Identification Types is mandatory if any of the other                                CSW207
      ** fields are input.                                                                    CSW207
                                                                                              CSW207
     C                   EVAL      *IN31 = *ON                                                CSW207
     C                   EVAL      WIErrFlg = 'Y'                                             CSW207
     C                   EVAL      PMsgID = 'USR9903'                                         CSW207
     C                   EXSR      SRSndErr                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNARR1 - Validates the Narratives (Screen 1)               *
      *                                                               *
      *****************************************************************
     C     SRVNARR1      BEGSR
 
     C                   IF        #1NARR = *BLANKS
 
      ** Narrative is mandatory
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4751'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** IBEI is not a valid Swift ID in SWIFT 2009                                           CSW209
     C                   IF        (CSW209 = 'Y') AND                                         CSW209
     C                             (#1SWCD <> 'ARNU' AND                                      CSW209
     C                             #1SWCD <> 'CCPT' AND                                       CSW209
     C                             #1SWCD <> 'CUST' AND                                       CSW209
     C                             #1SWCD <> 'DRLC' AND                                       CSW209
     C                             #1SWCD <> 'EMPL' AND                                       CSW209
     C                             #1SWCD <> 'NIDN' AND                                       CSW209
     C                             #1SWCD <> 'SOSE' AND                                       CSW209
     C                             #1SWCD <> 'TXID' AND                                       CSW209
     C                             #1SWCD <> *BLANKS) AND                                     CSW209
     C                             (CSW207 = 'Y' OR                                           CSW209
     C                             BGN4ST = 'Y')                                              CSW209
     C                   EVAL      *IN24 = *ON                                                CSW209
     C                   EVAL      WTErrFlg = 'Y'                                             CSW209
     C                   EVAL      PMsgID = 'USR9907'                                         CSW209
     C                   EXSR      SRSndErr                                                   CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   IF        (#1SWCD <> 'ARNU' AND #1SWCD <> 'CCPT' AND                 CSW207
     C                             #1SWCD <> 'CUST' AND #1SWCD <> 'DRLC' AND                  CSW207
     C                             #1SWCD <> 'EMPL' AND #1SWCD <> 'IBEI' AND                  CSW207
     C                             #1SWCD <> 'NIDN' AND #1SWCD <> 'SOSE' AND                  CSW207
     C                             #1SWCD <> 'TXID') AND (CSW207 = 'Y' OR                     CSW207
     C                             BGN4ST = 'Y')                                              CSW207
     C                   EVAL      *IN24 = *ON                                                CSW207
     C                   EVAL      WTErrFlg = 'Y'                                             CSW207
     C                   EVAL      PMsgID = 'USR9900'                                         CSW207
     C                   EXSR      SRSndErr                                                   CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW209
                                                                                              CSW207
     C                   IF        (#1SWCD <> *blanks and                                     CSW207
     C                             #1IDTP = *blanks) AND                                      CSW207
     C                             (CSW207 = 'Y' OR BGN4ST = 'Y')                             CSW207
                                                                                              CSW207
      ** SWIFT ID should be blanks                                                            CSW207
                                                                                              CSW207
     C                   EVAL      *IN22 = *ON                                                CSW207
     C                   EVAL      WTErrFlg = 'Y'                                             CSW207
     C                   EVAL      PMsgID = 'USR9903'                                         CSW207
     C                   EXSR      SRSndErr                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        #1NARR <> *blanks and
     C                             #1IDTP = *blanks
 
      ** Narrative should be blanks
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4752'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNARR2 - Validates Narrative (screen 2)                    *
      *                                                               *
      *****************************************************************
     C     SRVNARR2      BEGSR
 
     C                   IF        #2NARR = *BLANKS AND
     C                             #2IDTP <> *BLANKS
 
      ** Narrative is mandatory if IdentificationType is input
 
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4753'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** IBEI is not a valid Swift ID in SWIFT 2009                                           CSW209
     C                   IF        (CSW209 = 'Y') AND                                         CSW209
     C                             (#2SWCD <> 'ARNU' AND                                      CSW209
     C                             #2SWCD <> 'CCPT' AND                                       CSW209
     C                             #2SWCD <> 'CUST' AND                                       CSW209
     C                             #2SWCD <> 'DRLC' AND                                       CSW209
     C                             #2SWCD <> 'EMPL' AND                                       CSW209
     C                             #2SWCD <> 'NIDN' AND                                       CSW209
     C                             #2SWCD <> 'SOSE' AND                                       CSW209
     C                             #2SWCD <> 'TXID'  AND                                      CSW209
     C                             #2SWCD <> *BLANKS) AND                                     CSW209
     C                             (CSW207 = 'Y' OR                                           CSW209
     C                             BGN4ST = 'Y')                                              CSW209
     C                   EVAL      *IN34 = *ON                                                CSW209
     C                   EVAL      WIErrFlg = 'Y'                                             CSW209
     C                   EVAL      PMsgID = 'USR9907'                                         CSW209
     C                   EXSR      SRSndErr                                                   CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   IF        (#2SWCD <> 'ARNU' AND #2SWCD <> 'CCPT' AND                 CSW207
     C                             #2SWCD <> 'CUST' AND #2SWCD <> 'DRLC' AND                  CSW207
     C                             #2SWCD <> 'EMPL' AND #2SWCD <> 'IBEI' AND                  CSW207
     C                             #2SWCD <> 'NIDN' AND #2SWCD <> 'SOSE' AND                  CSW207
     C                             #2SWCD <> 'TXID') AND (CSW207 = 'Y' OR                     CSW207
     C                             BGN4ST = 'Y')                                              CSW207
     C                   EVAL      *IN34 = *ON                                                CSW207
     C                   EVAL      WIErrFlg = 'Y'                                             CSW207
     C                   EVAL      PMsgID = 'USR9900'                                         CSW207
     C                   EXSR      SRSndErr                                                   CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW209
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVKeys - Validates the key fields.                          *
      *                                                               *
      *****************************************************************
     C     SRVKeys       BEGSR
 
     C                   IF        #2IDTP <> *BLANKS
 
     C     #2IDTP        CHAIN     SDIDTPL1
 
     C                   IF        %FOUND(SDIDTPL1)
 
      ** Identification Type already exists
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4754'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrMain - Manages the insert screen subfile.              *
      *                                                               *
      *****************************************************************
     C     SRiScrMain    BEGSR
 
     C                   EXSR      SRiScrInit
 
     C                   EXSR      SRiScrClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRiScrBld
 
     C                   EXSR      SRiScrDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRiScrRef
 
     C                   WHEN      F12 = *ON
     C                   LEAVESR
 
     C                   OTHER
     C                   EXSR      SRiScrVal
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrInit - Handles the initial insert screen subfile       *
      *               processing.                                     *
      *                                                               *
      *****************************************************************
     C     SRiScrInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W2SFRN = *ZERO
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WIDspFlg = 'N'
     C                   EVAL      WIBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF                                               CSW207
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN11 = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrRef - Refreshes the insert screen subfile.             *
      *                                                               *
      *****************************************************************
     C     SRiScrRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRiScrClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WIDspFlg = 'N'
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WIBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #2IDTP = *BLANKS
     C                   EVAL      #2NARR = *BLANK
     C                   EVAL      #2SWCD = *BLANK                                            CSW207
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      W2SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF                                               CSW207
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrClr - Clears the insert screen subfile.                *
      *                                                               *
      *****************************************************************
     C     SRiScrClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000762C2
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrBld - Builds the insert screen subfile.                *
      *                                                               *
      *****************************************************************
     C     SRiScrBld     BEGSR
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN11 = *ON
 
      ** Build the subfile only if necessary.
 
     C                   IF        WIDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the input subfile.
 
     C                   IF        WIBldFlg = 'Y'
     C                   EXSR      SRiScrClr
     C                   EVAL      W2SFRN = *ZERO
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WIBldFlg = 'N'
     C                   ENDIF
 
     C                   EVAL      WiScrCnt = *ZERO
 
     C                   DOW       WiScrCnt < 14
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF                                               CSW207
     C                   EVAL      #2IDTP = *BLANKS
     C                   EVAL      #2NARR = *BLANK
     C                   EVAL      #2SWCD = *BLANK                                            CSW207
     C                   EVAL      W2SFRN = W2SFRN + 1
     C                   EVAL      #2SFRN = W2SFRN
     C                   EVAL      WiScrCnt = WiScrCnt + 1
     C                   WRITE     SD000762S2
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrDsp - Displays the insert screen subfile.              *
      *                                                               *
      *****************************************************************
     C     SRiScrDsp     BEGSR
 
      ** Display the full Identification Types input screen.
 
     C                   WRITE     SD000762F1
     C                   WRITE     SD000762C3
     C                   WRITE     SD000762F2
     C                   EXFMT     SD000762C2
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrVal - Validates the insert screen subfile.             *
      *                                                               *
      *****************************************************************
     C     SRiScrVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WIDspFlg = 'N'
     C                   EVAL      WIBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF                                               CSW207
 
     C                   READC     SD000762S2
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF                                               CSW207
 
     C                   IF        ISCR <> *BLANKS
 
      ** Validate the Country of Security Issue.
 
     C                   EXSR      SRVIdTp
 
      ** Validate the Identification Type
 
     C                   EXSR      SRVNARR2
 
      ** Validate the key fields.
 
     C                   EXSR      SRVKeys
 
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000762S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000762S2
 
     C                   ENDDO
 
     C                   IF        WIErrFlg = 'Y'
     C                   EVAL      WIDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Update the Identificatin Types file.
 
     C                   READC     SD000762S2
 
     C                   DOW       NOT %EOF
 
     C                   IF        ISCR <> *BLANKS
     C                   EXSR      SRiScrWrt
     C                   ENDIF
 
     C                   READC     SD000762S2
 
     C                   ENDDO
 
     C                   EVAL      WIBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrWrt - Writes new Identification Types                  *
      *                                                               *
      *****************************************************************
     C     SRiScrWrt     BEGSR
 
     C     #2IDTP        CHAIN     SDIDTPL0
 
     C                   IF        NOT %FOUND(SDIDTPL0)
     C                   EVAL      IDIDTP = #2IDTP
     C                   EVAL      IDNARR = #2NARR
     C                   EVAL      IDSWCD = #2SWCD                                            CSW207
     C                   EVAL      IDCHTP = 'I'
     C                   EVAL      IDLCDT = BJRDNB
     C                   WRITE     SDIDTPD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDIDTPL0'
     C                   EVAL      DBKey = #2IDTP
     C                   EVAL      DBase = 106
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update Standing Data Controls.
 
     C                   EVAL      KFLNM = 'SDIDTPPD'
     C     KFLNM         CHAIN     SDFCTLL0
 
     C                   IF        %FOUND(SDFCTLL0)
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   UPDATE    SDFCTLD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBKey = KFLNM
     C                   EVAL      DBase = 107
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the program message       *
      *             queue via ZA0340.                                 *
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
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
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
 
      ** Key Lists
 
 
      ** Set the program, module, and procedure names for DB error handling.
 
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if Private Banking is switched on:                                             CSW207
                                                                                              CSW207
     C                   CALL      'AOMMODR0'                                                 CSW207
     C                   PARM      '*DBERR'      PRtCd                                        CSW207
     C                   PARM      '*FIRST '     POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBase = 108                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if SWIFT 2009 is installed                                                     CSW209
                                                                                              CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRtCd                                        CSW209
                                                                                              CSW209
     C                   IF        PRtCd = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      ** Set the system information display fields.
 
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #3PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C                   IF        PMODE = 'E'
     C                   EVAL      ENQMODE = *ON
     C                   ENDIF
 
     C                   EXSR      SRIdTpInit
 
     C                   EXSR      SRIdTpClr
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
