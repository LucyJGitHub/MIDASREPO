     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR File to Upload to MBI Maint/Enq')             *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001003 - Midas MR File to Upload to MBI File               *
      *             Maintenance/Enquiry                               *
      *                                                               *
      *  Function: This program is used to maintain the MBI File      *
      *            Upload table.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR828013 *CREATE   Date 30Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR828013 - Incremental database for MBI (CCR036)             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas MR File to Upload to MBI File
 
     FMRMBIFPD  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas MR File to Upload to MBI Display File
 
     FMR001003DFCF   E             WORKSTN SFILE(MR001003S1:#1SFRN)
 
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
 
      ** Bank Details Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Switchable Feature Data Structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Deal Subtype Data Structure
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** Short Access Object Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
 
     D PMode           S              1A
 
      ** ZDATE2 Parameters
 
     D ZDAYNO          S              5  0
     D ZMDFIN          S              1A
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** Access Object Parameters
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PTRTY           S              2A
     D PTRST           S              2A
     D PTRCL           S              4A
     D PSARD           S              6A
 
      ** Standard Utility Parameters
 
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
     D PMsgDta         S             45A
 
      ** Key Fields
 
     D KFIL            S                   LIKE(MRFNAM)
 
      ** Working Variables
 
     D WExtrCnt        S              4P 0
     D WiScrCnt        S              4P 0
     D W1SFRN          S              4P 0
     D W2SFRN          S              4P 0
     D WTErrFlg        S              1A
     D WTDspFlg        S              1A
     D WTBldFlg        S              1A
     D WIErrFlg        S              1A
     D WIDspFlg        S              1A
     D WIBldFlg        S              1A
     D WRead           S              1A
     D WDesc           S             30A
     D WFLAG           S              1A
     D WDL             S              1A
     D WDL2            S              1A
     D WLE             S              1A
     D WDLST           S              2A
     D CDL038          S              1A
     D CLE042          S              1A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRExtrMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrMain - Manages the MBI Extract File Maintenance        *
      *               Subfile                                         *
      *                                                               *
      *****************************************************************
     C     SRExtrMain    BEGSR
 
     C                   EXSR      SRExtrInit
 
     C                   EXSR      SRExtrClr
 
     C                   DOW       F03 = *OFF AND
     C                             F12 = *OFF
 
     C                   EXSR      SRExtrBld
 
     C                   EXSR      SRExtrDsp
 
     C                   IF        F03 = *OFF AND
     C                             F12 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRExtrRef
 
     C                   OTHER
 
     C                   IF        W1SFRN <> *ZERO
 
     C                   EXSR      SRExtrVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N' AND
     C                             WTErrFlg = 'N'
     C                   EXSR      SRExtrRef
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03    = *ON
     C                   EVAL      PRtcd  = '*EXIT'
     C                   ENDIF
     C                   IF        F12    = *ON
     C                   EVAL      PRtcd  = '*RETN'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrInit - Handles the initial MBI Extract File            *
      *               Table subfile processing.                       *
      *                                                               *
      *****************************************************************
     C     SRExtrInit    BEGSR
 
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
 
     C     *LOVAL        SETLL     MRMBIFPD
 
      ** Reset the subfile error indicators.
 
     C                   MOVEA     '00000'       *IN(22)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrRef - Refreshes the MBI Extract File Table             *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRExtrRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRExtrClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #1KFIL = *BLANKS
     C                   EVAL      #1KPRG = *BLANKS
     C                   EVAL      #1KDNL = *BLANKS
     C                   EVAL      #1KDIR = *BLANKS
     C                   EVAL      #1KMIR = *BLANKS
     C                   EVAL      #1KYIR = *BLANK
     C                   EVAL      #1FIL  = *BLANKS
     C                   EVAL      #1PRG  = *BLANKS
     C                   EVAL      #1DNL  = *BLANK
     C                   EVAL      #1DIR  = *BLANK
     C                   EVAL      #1MIR  = *BLANK
     C                   EVAL      #1YIR  = *BLANKS
     C                   EVAL      #1DEX  = *BLANKS
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   MOVEA     '00000'       *IN(22)
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN11 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     MRMBIFPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrClr - Clears the MBI Extract File Table Subfile        *
      *                                                               *
      *****************************************************************
     C     SRExtrClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     MR001003C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrBld - Builds the MBI Extract File Table subfile        *
      *                                                               *
      *****************************************************************
     C     SRExtrBld     BEGSR
 
     C                   IF        WTErrFlg = 'N'
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN11 = *OFF
 
      ** Build the subfile only if necessary.
 
     C                   IF        WTDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WTBldFlg = 'Y'
 
     C                   EXSR      SRExtrClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   MOVEA     '00000'       *IN(22)
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WTBldFlg = 'N'
 
     C                   IF        #1KFIL <> *BLANKS AND
     C                             #1KDNL <> *BLANKS AND
     C                             #1KPRG <> *BLANKS AND
     C                             #1KDIR <> *BLANKS AND
     C                             #1KMIR <> *BLANKS AND
     C                             #1KYIR <> *BLANKS
     C                   EVAL      KFIL  = #1KFIL
     C     KExtr         SETLL     MRMBIFPD
     C                   ELSE
     C     *LOVAL        SETLL     MRMBIFPD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WExtrCnt = *ZERO
 
      ** Select all MBI Extract File Table
 
     C                   EXSR      SRExtrRtv
 
     C                   DOW       NOT %EOF(MRMBIFPD)
 
     C                   MOVEA     '00000'       *IN(22)
     C                   EVAL      #1FIL  = MRFNAM
     C                   EVAL      #1DNL  = MRDWNL
     C                   EVAL      #1PRG  = MRXPGM
     C                   EVAL      #1DIR  = MRDIOR
     C                   EVAL      #1MIR  = MRMIOR
     C                   EVAL      #1YIR  = MRYIOR
 
     C                   EVAL      ZDAYNO = MREXDT
     C                   EVAL      ZMDFIN = BJDFIN
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZMDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   EVAL      #1DEX  = ZADATE
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WExtrCnt = WExtrCnt + 1
     C                   WRITE     MR001003S1
 
      ** Leave the MBI Extract File Table selection if one subfile
      ** page has been filled.
 
     C                   IF        WExtrCnt = 13
 
      ** Check first if there are more records available.
 
     C                   EXSR      SRExtrRtv
 
     C                   IF        %EOF(MRMBIFPD)
     C                   LEAVE
     C                   ELSE
     C                   READP     MRMBIFPD
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRExtrRtv
 
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'USR3969'
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrDsp - Displays the MBI Extract File Table subfile      *
      *                                                               *
      *****************************************************************
     C     SRExtrDsp     BEGSR
 
      ** Display the full Transaction Type Decision Table selection
      ** screen.
 
     C                   WRITE     MR001003F1
     C                   WRITE     MR001003C2
     C                   WRITE     MR001003F2
     C                   EXFMT     MR001003C1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrUpd - Updates the MBI Extract File Table subfile       *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRExtrUpd     BEGSR
 
     C                   EVAL      KFIL  = #1FIL
     C     KExtr         CHAIN     MRMBIFPD
 
     C                   IF        NOT %EOF(MRMBIFPD)
 
     C                   EVAL      MRFNAM = #1FIL
     C                   EVAL      MRDWNL = #1DNL
     C                   EVAL      MRXPGM = #1PRG
     C                   EVAL      MRDIOR = #1DIR
     C                   EVAL      MRMIOR = #1MIR
     C                   EVAL      MRYIOR = #1YIR
 
     C                   UPDATE    MRMBIFD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'MRMBIFPD'
     C                   EVAL      DBKey = KFIL
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrRtv - Validates the MBI Extract File Table subfile     *
      *                                                               *
      *****************************************************************
     C     SRExtrRtv     BEGSR
 
      ** Check if Position To/Filter is entered
 
     C                   DOU       WREAD   = 'Y' OR
     C                             %EOF(MRMBIFPD)
     C                   EVAL      WREAD   = 'Y'
     C                   READ      MRMBIFPD
 
     C                   IF        #1KFIL <> *BLANKS AND
     C                             #1KFIL <> MRFNAM
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KDNL <> *BLANKS AND
     C                             #1KDNL <> MRDWNL
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KPRG <> *BLANKS AND
     C                             #1KPRG <> MRXPGM
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KDIR <> *BLANKS AND
     C                             #1KDIR <> MRDIOR
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KMIR <> *BLANKS AND
     C                             #1KMIR <> MRMIOR
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KYIR <> *BLANKS AND
     C                             #1KYIR <> MRYIOR
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtrVal - Validates the MBI Extract File Table subfile     *
      *                                                               *
      *****************************************************************
     C     SRExtrVal     BEGSR
 
     C                   READC     MR001003S1
     C                   DOW       NOT %EOF
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   MOVEA     '00000'       *IN(22)
 
     C                   EXSR      SRVDWNL
     C                   EXSR      SRVXPGM
     C                   EXSR      SRVDIOR
     C                   EXSR      SRVMIOR
     C                   EXSR      SRVYIOR
 
     C                   IF        WTErrFlg = 'N'
     C                   EXSR      SRExtrUpd
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    MR001003S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     MR001003S1
     C                   ENDDO
 
     C                   EVAL      WTBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDWNL - Validates Download (Y/N) Flag                      *
      *                                                               *
      *****************************************************************
     C     SRVDWNL       BEGSR
 
     C                   IF        #1DNL <> 'Y' AND
     C                             #1DNL <> 'N'
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR3973'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVXPGM - Validates External Program Name                    *
      *                                                               *
      *****************************************************************
     C     SRVXPGM       BEGSR
 
     C                   IF        #1PRG <> *BLANKS
 
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR2119'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDIOR - Validates Daily Incremental/Refresh Field          *
      *                                                               *
      *****************************************************************
     C     SRVDIOR       BEGSR
 
     C                   IF        #1DIR <> 'R' AND
     C                             #1DIR <> 'I' AND
     C                             #1DIR <> 'N'
 
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'MMR0001'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMIOR - Validates Monthly Incremental/Refresh Field        *
      *                                                               *
      *****************************************************************
     C     SRVMIOR       BEGSR
 
     C                   IF        #1MIR <> 'R' AND
     C                             #1MIR <> 'I' AND
     C                             #1MIR <> 'N'
 
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'MMR0001'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVYIOR - Validates Yearly Incremental/Refresh Field         *
      *                                                               *
      *****************************************************************
     C     SRVYIOR       BEGSR
 
     C                   IF        #1YIR <> 'R' AND
     C                             #1YIR <> 'I' AND
     C                             #1YIR <> 'N'
 
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'MMR0001'
     C                   EXSR      SRSndErr
 
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
 
      ** Key Lists
 
     C     KExtr         KLIST
     C                   KFLD                    KFIL
 
      ** Set the program, module, and procedure names for DB error
      ** handling.
 
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
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CDL038 is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      CDL038 = 'N'
     C                   ELSE
     C                   EVAL      CDL038 = 'Y'
     C                   ENDIF
 
      ** Check if CLE042 is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      CLE042 = 'N'
     C                   ELSE
     C                   EVAL      CLE042 = 'Y'
     C                   ENDIF
 
     C                   IF        CDL038 = 'N'AND
     C                             CLE042 = 'N'
     C                   EVAL      *IN23 = *OFF
     C                   ELSEIF    CDL038 = 'Y' OR
     C                             CLE042 = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   ENDIF
 
      ** Set the system information display fields.
 
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #2PGMQ = PSProcMod
 
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
(c) Finastra International Limited 2011
