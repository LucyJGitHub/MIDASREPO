     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Tax Calculation Method Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000761 - Midas SD Tax Calculation Method Maintenance       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDTXCML0  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SD Tax Calculation Methods - Update Index
 
     FSDTXCML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTXCMD0:SDTXCMD1)
      ** Midas SD Tax Calculation Methods - Retrieve Index
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@AHREAU:SDFCTLD0)
      ** Midas SD Standing Data Controls
 
     FSD000761DFCF   E             WORKSTN SFILE(SD000761S1:#1SFRN)
     F                                     SFILE(SD000761S2:#2SFRN)
      ** Midas SD Tax Calculation Method Maintenance Display
 
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
     D  #2CSIS                 1      2
     D  #2CTRT                 3      4
     D  #2TXCM                 5      5
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Country Details Data Structure
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PMode           S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCtry           S              2A
 
      ** Standard Utility Parameters
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KCSIs           S                   LIKE(TCCSIS)
     D KCtrT           S                   LIKE(TCCTRT)
     D KFLNM           S                   LIKE(AHFLNM)
 
      ** Working Variables
     D WTxcmCnt        S              4P 0
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
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRTxcmMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmMain - Manages the Tax Calculation Methods subfile.    *
      *                                                               *
      *****************************************************************
     C     SRTxcmMain    BEGSR
 
     C                   EXSR      SRTxcmInit
 
     C                   EXSR      SRTxcmClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRTxcmBld
 
     C                   EXSR      SRTxcmDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRTxcmRef
 
     C                   WHEN      F09 = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SRiScrMain
     C                   EXSR      SRTxcmRef
 
     C                   OTHER
 
     C                   IF        W1SFRN <> *ZERO
     C                   EXSR      SRTxcmVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N'
     C                   EXSR      SRTxcmRef
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
      *  SRTxcmInit - Handles the initial Tax Calculation Methods     *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRTxcmInit    BEGSR
 
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
 
     C     *LOVAL        SETLL     SDTXCML1
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmRef - Refreshes the Tax Calculation Methods subfile.   *
      *                                                               *
      *****************************************************************
     C     SRTxcmRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRTxcmClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #1KCSI = *BLANKS
     C                   EVAL      #1KCTT = *BLANKS
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1CSIS = *BLANKS
     C                   EVAL      #1CTRT = *BLANKS
     C                   EVAL      #1TXCM = *BLANK
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDTXCML1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmClr - Clears the Tax Calculation Methods subfile.      *
      *                                                               *
      *****************************************************************
     C     SRTxcmClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000761C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmBld - Builds the Tax Calculation Methods subfile.      *
      *                                                               *
      *****************************************************************
     C     SRTxcmBld     BEGSR
 
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
 
     C                   EXSR      SRTxcmClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WTBldFlg = 'N'
 
     C                   IF        #1KCSI <> *BLANKS OR
     C                             #1KCTT <> *BLANKS
     C                   EVAL      KCSIS = #1KCSI
     C                   EVAL      KCTRT = #1KCTT
     C     KTxcm         SETLL     SDTXCML1
     C                   ELSE
     C     *LOVAL        SETLL     SDTXCML1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTxcmCnt = *ZERO
 
      ** Select all Tax Calculation Methods.
 
     C                   READ      SDTXCML1
 
     C                   DOW       NOT %EOF(SDTXCML1)
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1CSIS = TCCSIS
     C                   EVAL      #1CTRT = TCCTRT
     C                   EVAL      #1TXCM = %CHAR(TCTXCM)
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WTxcmCnt = WTxcmCnt + 1
     C                   WRITE     SD000761S1
 
      ** Leave the Tax Calculation Methods selection if one subfile
      ** page has been filled.
 
     C                   IF        WTxcmCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      SDTXCML1
 
     C                   IF        %EOF(SDTXCML1)
     C                   LEAVE
     C                   ELSE
     C                   READP     SDTXCML1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   READ      SDTXCML1
 
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
      *  SRTxcmDsp - Displays the Tax Calculation Methods subfile.    *
      *                                                               *
      *****************************************************************
     C     SRTxcmDsp     BEGSR
 
      ** Display the full Tax Calculation Methods selection screen.
 
     C                   WRITE     SD000761F1
     C                   WRITE     SD000761C3
     C                   WRITE     SD000761F2
     C                   EXFMT     SD000761C1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmVal - Validates the Tax Calculation Methods subfile.   *
      *                                                               *
      *****************************************************************
     C     SRTxcmVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
     C                   READC     SD000761S1
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Validate the Action Code.
 
     C                   EXSR      SRVActn
 
      ** Validate the Tax Calculation Method.
 
     C                   EXSR      SRVTxcm1
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000761S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000761S1
 
     C                   ENDDO
 
     C                   IF        WTErrFlg = 'Y'
     C                   EVAL      WTDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000761S1
 
     C                   DOW       NOT %EOF
 
     C                   IF        #1ACTN = 'D'
     C                   EVAL      WACTN = 'D'
     C                   ELSE
     C                   EVAL      WACTN = 'A'
     C                   ENDIF
 
     C                   EXSR      SRTxcmUpd
 
     C                   READC     SD000761S1
 
     C                   ENDDO
 
     C                   EVAL      WTBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxcmUpd - Updates the Tax Calculation Methods file.        *
      *                                                               *
      *****************************************************************
     C     SRTxcmUpd     BEGSR
 
     C                   EVAL      KCSIs = #1CSIS
     C                   EVAL      KCtrT = #1CTRT
     C     KTxcm         CHAIN     SDTXCML0
 
     C                   IF        %FOUND(SDTXCML0)
 
     C                   IF        WACTN = 'A'
     C                   EVAL      TCCSIS = #1CSIS
     C                   EVAL      TCCTRT = #1CTRT
     C                   MOVE      #1TXCM        TCTXCM
     C                   ENDIF
 
     C                   EVAL      TCCHTP = WACTN
     C                   EVAL      TCLCDT = BJRDNB
 
     C                   UPDATE    SDTXCMD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTXCMPD'
     C                   EVAL      DBKey = KCSIs + KCtrT
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update Standing Data Controls.
 
     C                   EVAL      KFLNM = 'SDTXCMPD'
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
      *  SRVCSIs - Validates the Country of Security Issue.           *
      *                                                               *
      *****************************************************************
     C     SRVCSIs       BEGSR
 
     C                   IF        (#2CTRT <> *BLANKS OR #2TXCM <> *BLANKS)
 
     C                   IF        #2CSIS = *BLANKS
 
      ** Country of Security Issue is mandatory if any of the other
      ** fields are input.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4724'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #2CSIS <> *BLANKS
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #2CSIS        PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#2CSIS) <> *ZERO
     C                   EVAL      #2CSIS = A4CNCD
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PRtCd = '*NRF   '
 
      ** Country of Security Issue must be a valid Country Code.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4725'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRtCd = '*NOSEL '
     C                   EVAL      #2CSIS = *BLANKS
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBKey = PCtry
     C                   EVAL      DBase = 104
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCtrT - Validates the Country of Tax.                      *
      *                                                               *
      *****************************************************************
     C     SRVCtrT       BEGSR
 
     C                   IF        #2CTRT = *BLANKS AND
     C                             #2CSIS <> *BLANKS
 
      ** Country of Tax is mandatory if Country of Security Issue is input.
 
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4726'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #2CTRT <> *BLANKS
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #2CTRT        PCtry
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#2CTRT) <> *ZERO
     C                   EVAL      #2CTRT = A4CNCD
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PRtCd = '*NRF   '
 
      ** Country of Tax must be a valid Country Code.
 
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4727'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRtCd = '*NOSEL '
     C                   EVAL      #2CTRT = *BLANKS
 
     C                   IF        #2CSIS <> *BLANKS
 
      ** Country of Tax is mandatory if Country of Security Issue is input.
 
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4726'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCTRYPD'
     C                   EVAL      DBKey = PCtry
     C                   EVAL      DBase = 105
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTxcm1 - Validates the Tax Calculation Method (screen 1).  *
      *                                                               *
      *****************************************************************
     C     SRVTxcm1      BEGSR
 
     C                   IF        #1TXCM = *BLANKS
 
      ** Tax Calculation Method is mandatory.
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4728'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1TXCM <> '1' AND
     C                             #1TXCM <> '2' AND
     C                             #1TXCM <> '3' AND
     C                             #1TXCM <> '4'
 
      ** Tax Calculation Method must be '1', '2', '3', or '4'.
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4729'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTxcm2 - Validates the Tax Calculation Method (screen 2).  *
      *                                                               *
      *****************************************************************
     C     SRVTxcm2      BEGSR
 
     C                   IF        #2TXCM = *BLANKS AND
     C                             #2CTRT <> *BLANKS
 
      ** Tax Calculation Method is mandatory if Country of Tax is input.
 
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4730'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #2TXCM <> *BLANK AND
     C                             #2TXCM <> '1' AND
     C                             #2TXCM <> '2' AND
     C                             #2TXCM <> '3' AND
     C                             #2TXCM <> '4'
 
      ** Tax Calculation Method must be '1', '2', '3', or '4'.
 
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4729'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVKeys - Validates the key fields.                          *
      *                                                               *
      *****************************************************************
     C     SRVKeys       BEGSR
 
     C                   IF        #2CSIS <> *BLANKS AND
     C                             #2CTRT <> *BLANKS
 
     C                   EVAL      KCSIs = #2CSIS
     C                   EVAL      KCtrT = #2CTRT
     C     KTxcm         CHAIN     SDTXCML1
 
     C                   IF        %FOUND(SDTXCML1)
 
      ** Country of Security Issue/Country of Tax pair already exists.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR4731'
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
     C                   EVAL      #2CSIS = *BLANKS
     C                   EVAL      #2CTRT = *BLANKS
     C                   EVAL      #2TXCM = *BLANK
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      W2SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
 
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
     C                   WRITE     SD000761C2
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
     C                   EVAL      #2CSIS = *BLANKS
     C                   EVAL      #2CTRT = *BLANKS
     C                   EVAL      #2TXCM = *BLANK
     C                   EVAL      W2SFRN = W2SFRN + 1
     C                   EVAL      #2SFRN = W2SFRN
     C                   EVAL      WiScrCnt = WiScrCnt + 1
     C                   WRITE     SD000761S2
 
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
 
      ** Display the full Tax Calculation Methods input screen.
 
     C                   WRITE     SD000761F1
     C                   WRITE     SD000761C3
     C                   WRITE     SD000761F2
     C                   EXFMT     SD000761C2
 
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
 
     C                   READC     SD000761S2
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
 
     C                   IF        ISCR <> *BLANKS
 
      ** Validate the Country of Security Issue.
 
     C                   EXSR      SRVCSIs
 
      ** Validate the Country of Tax.
 
     C                   EXSR      SRVCtrT
 
      ** Validate the Tax Calculation Method.
 
     C                   EXSR      SRVTxcm2
 
      ** Validate the key fields.
 
     C                   EXSR      SRVKeys
 
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000761S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000761S2
 
     C                   ENDDO
 
     C                   IF        WIErrFlg = 'Y'
     C                   EVAL      WIDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Update the Tax Calculation Methods file.
 
     C                   READC     SD000761S2
 
     C                   DOW       NOT %EOF
 
     C                   IF        ISCR <> *BLANKS
     C                   EXSR      SRiScrWrt
     C                   ENDIF
 
     C                   READC     SD000761S2
 
     C                   ENDDO
 
     C                   EVAL      WIBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrWrt - Writes new Tax Calculation Methods.              *
      *                                                               *
      *****************************************************************
     C     SRiScrWrt     BEGSR
 
     C                   EVAL      KCSIs = #2CSIS
     C                   EVAL      KCtrT = #2CTRT
     C     KTxcm         CHAIN     SDTXCML0
 
     C                   IF        NOT %FOUND(SDTXCML0)
     C                   EVAL      TCCSIS = #2CSIS
     C                   EVAL      TCCTRT = #2CTRT
     C                   MOVE      #2TXCM        TCTXCM
     C                   EVAL      TCCHTP = 'I'
     C                   EVAL      TCLCDT = BJRDNB
     C                   WRITE     SDTXCMD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTXCMPD'
     C                   EVAL      DBKey = KCSIs + KCtrT
     C                   EVAL      DBase = 106
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update Standing Data Controls.
 
     C                   EVAL      KFLNM = 'SDTXCMPD'
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
 
     C     KTxcm         KLIST
     C                   KFLD                    KCSIs
     C                   KFLD                    KCtrT
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
