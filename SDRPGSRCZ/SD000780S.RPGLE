     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Tax Basket Code Selection')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000780S - Midas SD Tax Basket Code Selection               *
      *                                                               *
      *  Function:  This program allows a user to select an           *
      *             existing Tax Code for use in another program.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR795958*CREATE    Date 29Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR740749 - main and secondary tax basket                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Tax basket details - retrieve
 
     FSD000780S#CF   E             WORKSTN SFILE(SD000780S0:#0SFRN)
      ** Midas SD Tax Basket Selection Display File
 
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
     D PCnTr           S                   LIKE(TBCRTT)
     D PTxBs           S                   LIKE(TBTXBS)
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KTxBs           S                   LIKE(TBTXBS)
 
      ** Working Variables
     D WTXBSCNT        S              4P 0
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
 
     C                   EXSR      SRTxBsMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxBsMain - Manages the Tax Basket Subfile                  *
      *                                                               *
      *****************************************************************
     C     SRTxBsMain    BEGSR
 
     C                   EXSR      SRTxBsInit
 
     C                   EXSR      SRTxBsClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRTxBsBld
 
     C                   EXSR      SRTxBsDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   EXSR      SRTxBsVal
 
     C                   IF        WPDspFlg = 'N' AND
     C                             WPBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PTxBs = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxBsInit - Handles the initial Tax Basket                  *
      *               subfile processing                              *
      *                                                               *
      *****************************************************************
     C     SRTxBsInit    BEGSR
 
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
 
     C     KSdTx1        SETLL     SDTXBSL1
 
      ** Reset the subfile error indicator
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxBsClr - Clears the Tax Basket subfile                    *
      *                                                               *
      *****************************************************************
     C     SRTxBsClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000780C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxBsBld - Builds the Tax Basket Code subfile               *
      *                                                               *
      *****************************************************************
     C     SRTxBsBld     BEGSR
 
      ** Build the subfile only if necessary
 
     C                   IF        WPDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key
 
     C                   IF        WPBldFlg = 'Y'
 
     C                   EXSR      SRTxBsClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WPBldFlg = 'N'
 
     C                   IF        #0KPRD <> *BLANKS
     C                   EVAL      KTxBs = #0KPRD
     C     KSdTx2        SETLL     SDTXBSL1
     C                   ELSE
     C     KSdTx1        SETLL     SDTXBSL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTXBSCNT = *ZERO
 
      ** Select all Tax Basket Code equal to Country of Tax
 
     C     KSdTx1        READE     SDTXBSL1
 
     C                   DOW       NOT %EOF(SDTXBSL1)
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0TXBS = TBTXBS
     C                   EVAL      #0NARR = TBNARR
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WTXBSCNT = WTXBSCNT + 1
     C                   WRITE     SD000780S0
 
      ** Leave the Tax Basket Code selection if one subfile
      ** page has been filled
 
     C                   IF        WTXBSCNT = 14
 
      ** Check first if there are more records available
 
     C     KSdTx1        READE     SDTXBSL1
 
     C                   IF        %EOF
     C                   LEAVE
     C                   ELSE
     C     KSdTx1        READPE    SDTXBSL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C     KSdTx1        READE     SDTXBSL1
 
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
      *  SRTxBsDsp - Displays the Tax Basket Subfile                  *
      *                                                               *
      *****************************************************************
     C     SRTxBsDsp     BEGSR
 
      ** Display the full Tax Basket Code Selection screen
 
     C                   WRITE     SD000780F0
     C                   WRITE     SD000780C1
     C                   WRITE     SD000780F1
     C                   EXFMT     SD000780C0
 
      ** Clear all messages from the Program Message Queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxBsVal - Validates the Tax Basket subfile                 *
      *                                                               *
      *****************************************************************
     C     SRTxBsVal     BEGSR
 
      ** Initialise processing flags
 
     C                   EVAL      WPErrFlg = 'N'
     C                   EVAL      WPDspFlg = 'N'
     C                   EVAL      WPBldFlg = 'N'
 
      ** Reset the subfile error indicator
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WPRecCnt = *ZERO
 
     C                   READC     SD000780S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Action Code
 
     C                   EXSR      SRVPActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000780S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000780S0
 
     C                   ENDDO
 
     C                   IF        WPErrFlg = 'Y'
     C                   EVAL      WPDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection
 
     C                   READC     SD000780S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN = '1'
 
      ** At this point, a valid Tax Basket has been selected
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PTxBs = #0TXBS
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000780S0
 
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
 
      ** Country of Tax
 
     C                   PARM                    PCnTr
 
      ** Tax Basket
 
     C                   PARM                    PTxBs
 
      ** End Parameter List
      ** ==================
 
      ** Key1 for SDTXBSL1 file
     C     KSdTx1        KLIST
     C                   KFLD                    PCnTr
 
      ** Key2 for SDTXBSL1 file
     C     KSdTx2        KLIST
     C                   KFLD                    PCnTr
     C                   KFLD                    KTxBs
 
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
 
     C     KSdTx1        SETLL     SDTXBSL1
     C     KSdTx1        READE     SDTXBSL1
     C                   IF        NOT %EOF
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2011
