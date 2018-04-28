     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SF Global User Profiles Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SD000016S - Midas SF Global User Profiles Selection          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG2975 *CREATE    Date 28May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG2975 - Security Profile Facility changes for MidasPlus    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGZMUSERL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MUSERDDF:GZMUSERD0)
      ** Midas GZ Midas Users by User Profile
 
     FGZMUSERL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MUSERDDF:GZMUSERD1)
      ** Midas GZ Midas Users by Zone/User Profile
 
     FSD000016S#CF   E             WORKSTN SFILE(SD000016S0:#0SFRN)
      ** Midas SF Global User Profiles Selection Display File
 
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
 
      ** Local Data Area for Database Error Details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA PERRCD(1)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
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
     D PZone           S             10A
     D PGUSR           S             10A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** ZA0340 Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
     D KGUSR           S                   LIKE(USRP)
     D KZone           S                   LIKE(USZONE)
 
      ** Working Variables
     D WGUsrCnt        S              4P 0
     D WURecCnt        S              4P 0
     D W0SFRN          S              4P 0
 
     D WUErrFlg        S              1A
     D WUDspFlg        S              1A
     D WUBldFlg        S              1A
 
     D WRun            S              1A
     D WRead           S              1A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRGUsrMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUsrMain - Manages the Global User Profiles subfile.       *
      *                                                               *
      *****************************************************************
     C     SRGUsrMain    BEGSR
 
     C                   EXSR      SRGUsrInit
 
     C                   EXSR      SRGUsrClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRGUsrBld
 
     C                   EXSR      SRGUsrDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   EXSR      SRGUsrVal
 
     C                   IF        WUDspFlg = 'N' AND
     C                             WUBldFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PGUSR = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUsrInit - Handles the initial Global User Profiles        *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRGUsrInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C                   EVAL      WUErrFlg = 'N'
     C                   EVAL      WUDspFlg = 'N'
     C                   EVAL      WUBldFlg = 'N'
 
      ** Set the file pointer.
 
     C                   IF        PZone = *BLANKS
     C     *LOVAL        SETLL     GZMUSERL0
     C                   ELSE
     C     KZone         SETLL     GZMUSERL1
     C                   ENDIF
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUsrClr - Clears the Global User Profiles subfile.         *
      *                                                               *
      *****************************************************************
     C     SRGUsrClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000016C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUsrBld - Builds the Global User Profiles subfile.         *
      *                                                               *
      *****************************************************************
     C     SRGUsrBld     BEGSR
 
      ** Build the subfile only if necessary.
 
     C                   IF        WUDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WUBldFlg = 'Y'
 
     C                   EXSR      SRGUsrClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WUBldFlg = 'N'
 
     C                   IF        #0KUSR <> *BLANKS
 
     C                   EVAL      KGUSR = #0KUSR
 
     C                   IF        PZone = *BLANKS
     C     KGUSR         SETLL     GZMUSERL0
     C                   ELSE
     C     KMUSR         SETLL     GZMUSERL1
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PZone = *BLANKS
     C     *LOVAL        SETLL     GZMUSERL0
     C                   ELSE
     C     KZone         SETLL     GZMUSERL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WGUsrCnt = *ZERO
 
      ** Select Global User Profiles.
 
     C                   IF        PZone = *BLANKS
     C                   READ      GZMUSERL0
     C                   ELSE
     C     KZone         READE     GZMUSERL1
     C                   ENDIF
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0GUSR = USRP
     C                   EVAL      #0NAME = USER1
 
     C                   IF        PZone = *BLANKS
     C                   EVAL      #0ZONE = USZONE
     C                   ENDIF
 
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WGUsrCnt = WGUsrCnt + 1
     C                   WRITE     SD000016S0
 
      ** Leave the Global User Profiles selection if one subfile
      ** page has been filled.
 
     C                   IF        WGUsrCnt = 14
 
      ** Check first if there are more records available.
 
     C                   IF        PZone = *BLANKS
     C                   READ      GZMUSERL0
     C                   ELSE
     C     KZone         READE     GZMUSERL1
     C                   ENDIF
 
     C                   IF        %EOF
     C                   LEAVE
     C                   ELSE
 
     C                   IF        PZone = *BLANKS
     C                   READP     GZMUSERL0
     C                   ELSE
     C     KZone         READPE    GZMUSERL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PZone = *BLANKS
     C                   READ      GZMUSERL0
     C                   ELSE
     C     KZone         READE     GZMUSERL1
     C                   ENDIF
 
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
      *  SRGUsrDsp - Displays the Global User Profiles subfile.       *
      *                                                               *
      *****************************************************************
     C     SRGUsrDsp     BEGSR
 
      ** Display the full Global Product Codes selection screen.
 
     C                   WRITE     SD000016F0
     C                   WRITE     SD000016C1
     C                   WRITE     SD000016F1
     C                   EXFMT     SD000016C0
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUsrVal - Validates the Global User Profiles subfile.      *
      *                                                               *
      *****************************************************************
     C     SRGUsrVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WUErrFlg = 'N'
     C                   EVAL      WUDspFlg = 'N'
     C                   EVAL      WUBldFlg = 'N'
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WURecCnt = *ZERO
 
     C                   READC     SD000016S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Product Action Code.
 
     C                   EXSR      SRVUActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000016S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000016S0
 
     C                   ENDDO
 
     C                   IF        WUErrFlg = 'Y'
     C                   EVAL      WUDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000016S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN = '1'
 
      ** At this point, a valid Product Code has been selected.
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PGUSR = #0GUSR
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000016S0
 
     C                   ENDDO
 
     C                   EVAL      WUBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVUActCde - Validates the User Profile Action Code.         *
      *                                                               *
      *****************************************************************
     C     SRVUActCde    BEGSR
 
     C                   IF        #0ACTN <> *BLANKS
 
      ** Action Code must be '1' (Select).
 
     C                   IF        #0ACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WUErrFlg = 'Y'
     C                   EVAL      PMsgID = 'GPM0001'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   EVAL      WURecCnt = WURecCnt + 1
 
     C                   IF        WURecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WUErrFlg = 'Y'
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
 
      ** Zone
 
     C                   PARM                    PZone
 
      ** Global User Profile
 
     C                   PARM                    PGUSR
 
      ** End Parameter List
      ** ==================
 
      ** Midas GZ Midas Users Key List
 
     C     KMUSR         KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KGUSR
 
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
 
     C                   IF        PZone = *BLANKS
     C                   EVAL      *IN11 = *ON
     C     *LOVAL        SETLL     GZMUSERL0
     C                   READ      GZMUSERL0
     C                   ELSE
     C                   EVAL      KZone = PZone
     C     KZone         SETLL     GZMUSERL1
     C                   READ      GZMUSERL1
     C                   ENDIF
 
     C                   IF        NOT %EOF
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
