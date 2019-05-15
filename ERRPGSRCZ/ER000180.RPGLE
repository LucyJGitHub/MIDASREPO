     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Transaction Type Decision Table Maint/Enq')   *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000180 - Midas ER Transaction Type Decision Table          *
      *             Maintenance/Enquiry                               *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26779           Date 27Nov09               *
      *                 BUG25883           Date 03Sep09               *
      *                 BUG25878           Date 03Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change Request on GSART Table                     *
      *  BUG25883 - Business Sub-class validation                     *
      *  BUG25878 - German Features Link Testing fix                  *
      *           - Error in message file/ID used                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FERDETTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas ER Transaction Type Decision Table - Update Index
 
     FERDETTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ERDETTD0:ERDETTD1)
      ** Midas ER Transaction Type Decision Table - Retrieve Index
 
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FD Deal type/subtype file
 
     FSDDLSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Deal sub-types retrieval
 
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Loan types/sub-types retrieval
 
     FER000180DFCF   E             WORKSTN SFILE(ER000180S1:#1SFRN)
     F                                     SFILE(ER000180S2:#2SFRN)
      ** Midas ER Transaction Type Decision Table Display
 
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
     D  #2MMOD                 1      2
     D  #2TRTY                 3      4
     D  #2TRST                 5      6
     D  #2TRCL                 7     10
     D  #2GRI                 11     11
     D  #2BUCL                12     13
     D  #2BUSU                14     15
     D  #2BUTY                16     17                                                     BUG26779
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Transaction Type Data Structure
     D ERDETT        E DS                  EXTNAME(ERDETTPD)
 
      ** Switchable Feature Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Deal Subtype Data Structure
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** Transaction Class Data Structure
     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)
 
      ** Loan Type/Subtype/Class Data Structure
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** Business Classification Class Data Structure
     D SDBUCL        E DS                  EXTNAME(SDBUCLPD)
 
      ** Business Classification Sub-Class Data Structure
     D SDBUSU        E DS                  EXTNAME(SDBUSUPD)
                                                                                            BUG26779
      ** Business Classification Type Structure                                             BUG26779
                                                                                            BUG26779
     D SDBUTY        E DS                  EXTNAME(SDBUTYPD)                                BUG26779
 
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
     D PTRTY           S              2A
     D PTRST           S              2A
     D PTRCL           S              4A
     D PBUCL           S              2A
     D PBUSU           S              2A
     D PBUTY           S              2A                                                    BUG26779
     D PSARD           S              6A
 
      ** Standard Utility Parameters
     D*PMsgFile*       S             10A   INZ('GBSTUSRMSG')                                BUG25878
     D PMsgFile        S             10A   INZ('STUSRMSG')                                  BUG25878
     D PMsgID          S             10A
     D PMsgDta         S             45A
 
      ** Key Fields
     D KMMOD           S                   LIKE(N4MMOD)
     D KTRTY           S                   LIKE(N4TRTY)
     D KTRST           S                   LIKE(N4TRST)
     D KTRCL           S                   LIKE(N4TRCL)
 
      ** Working Variables
     D WTxnTCnt        S              4P 0
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
 
     C                   EXSR      SRTxnTMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTMain - Manages the Transaction Type Decision Table     *
      *               Subfile                                         *
      *                                                               *
      *****************************************************************
     C     SRTxnTMain    BEGSR
 
     C                   EXSR      SRTxnTInit
 
     C                   EXSR      SRTxnTClr
 
     C                   DOW       F03 = *OFF AND
     C                             F12 = *OFF
 
     C                   EXSR      SRTxnTBld
 
     C                   EXSR      SRTxnTDsp
 
     C                   IF        F03 = *OFF AND
     C                             F12 = *OFF AND                                           BUG25878
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRTxnTRef
 
     C                   WHEN      F09 = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SRiScrMain
     C                   EVAL      F12 = *OFF
     C                   IF        WIDspFlg = 'N' AND
     C                             WIBldFlg = 'N'
     C                   EXSR      SRiScrRef
     C                   ENDIF
 
     C                   OTHER
 
     C                   IF        W1SFRN <> *ZERO
 
     C                   EXSR      SRTxnTVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N' AND
     C                             WTErrFlg = 'N'
     C                   EXSR      SRTxnTRef
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
      *  SRTxnTInit - Handles the initial Transaction Type Decision   *
      *               Table subfile processing.                       *
      *                                                               *
      *****************************************************************
     C     SRTxnTInit    BEGSR
 
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
 
     C     *LOVAL        SETLL     ERDETTL1
 
      ** Reset the subfile error indicators.
 
     C                   MOVEA     '00'          *IN(21)
     C                   MOVEA     '00'          *IN(24)
     C                   EVAL      *IN26 = '0'                                              BUG26779
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTRef - Refreshes the Transaction Type Decision Table    *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRTxnTClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      #1KMOD = *BLANKS
     C                   EVAL      #1KTYP = *BLANKS
     C                   EVAL      #1KSTP = *BLANKS
     C                   EVAL      #1KCLS = *BLANKS
     C                   EVAL      #1KDES = *BLANKS
     C                   EVAL      #1KGRI = *BLANK
     C                   EVAL      #1KBUC = *BLANKS
     C                   EVAL      #1KBUS = *BLANKS
     C                   EVAL      #1KBCT = *BLANKS                                         BUG26779
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1MMOD = *BLANKS
     C                   EVAL      #1TRTY = *BLANKS
     C                   EVAL      #1TRST = *BLANK
     C                   EVAL      #1TRCL = *BLANK
     C                   EVAL      #1GRI  = *BLANK
     C                   EVAL      #1BUCL = *BLANKS
     C                   EVAL      #1BUSU = *BLANKS
     C                   EVAL      #1BUTY = *BLANKS                                         BUG26779
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C                   MOVEA     '00'          *IN(21)
     C                   MOVEA     '00'          *IN(24)
     C                   EVAL      *IN26 = '0'                                              BUG26779
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN11 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     ERDETTL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTClr - Clears the Transaction Type Decision Table       *
      *              Subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     ER000180C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTBld - Builds the Transaction Type Decision Table       *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTBld     BEGSR
 
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
 
     C                   EXSR      SRTxnTClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   MOVEA     '00'          *IN(21)
     C                   MOVEA     '00'          *IN(24)
     C                   EVAL      *IN26  = '0'                                             BUG26779
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WTBldFlg = 'N'
 
     C                   IF        #1KMOD <> *BLANKS AND
     C                             #1KTYP <> *BLANKS AND
     C                             #1KSTP <> *BLANKS AND
     C                             #1KCLS <> *BLANKS
     C                   EVAL      KMMOD = #1KMOD
     C                   EVAL      KTRTY = #1KTYP
     C                   EVAL      KTRST = #1KSTP
     C                   EVAL      KTRCL = #1KCLS
     C     KTxNT         SETLL     ERDETTL1
     C                   ELSE
     C     *LOVAL        SETLL     ERDETTL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WTxnTCnt = *ZERO
 
      ** Select all Transaction Type Decision Table
 
     C                   EXSR      SRTxnTRtv
 
     C                   DOW       NOT %EOF(ERDETTL1)
 
     C                   MOVEA     '00'          *IN(21)
     C                   MOVEA     '00'          *IN(24)
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1MMOD = N4MMOD
     C                   EVAL      #1TRTY = N4TRTY
     C                   EVAL      #1TRST = N4TRST
     C                   EVAL      #1TRCL = N4TRCL
      *
      ** Retrieve Description
     C                   IF        #1MMOD = 'FX' OR
     C                             #1MMOD = 'MM'
      *
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #1TRST        PTRST
     C     SDDLST        PARM      SDDLST        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDDLSTPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ASDSTN        #1DESC
     C                   ENDIF
      *
     C                   ELSEIF    #1MMOD = 'LE'
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #1TRTY        PTRTY
     C                   PARM      #1TRST        PTRST
     C                   PARM      #1TRCL        PTRCL
     C     SDLOAN        PARM      SDLOAN        DSFDY
     C
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDLOANPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      AYLNTD        #1DESC
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EVAL      #1GRI  = N4GRI
     C                   EVAL      #1BUCL = N4BUCL
     C                   MOVE      N4BUSU        #1BUSU
     C                   EVAL      #1BUTY = N4BUTY                                          BUG26779
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WTxnTCnt = WTxnTCnt + 1
     C                   WRITE     ER000180S1
 
      ** Leave the Transaction Type Decision Table selection if one subfile
      ** page has been filled.
 
     C                   IF        WTxnTCnt = 14
 
      ** Check first if there are more records available.
 
     C                   EXSR      SRTxnTRtv
 
     C                   IF        %EOF(ERDETTL1)
     C                   LEAVE
     C                   ELSE
     C                   READP     ERDETTL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRTxnTRtv
 
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'ERL0020'
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
      *  SRTxnTDsp - Displays the Transaction Type Decision Table     *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTDsp     BEGSR
 
      ** Display the full Transaction Type Decision Table selection screen.
 
     C                   WRITE     ER000180F1
     C                   WRITE     ER000180C3
     C                   WRITE     ER000180F2
     C                   EXFMT     ER000180C1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTUpd - Updates the Transaction Type Decision Table      *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTUpd     BEGSR
 
     C                   EVAL      KMMOD = #1MMOD
     C                   EVAL      KTRTY = #1TRTY
     C                   EVAL      KTRST = #1TRST
     C                   EVAL      KTRCL = #1TRCL
     C     KTxnT         CHAIN     ERDETTL0
 
     C                   IF        NOT %EOF(ERDETTL0)
 
     C                   EVAL      N4GRI  = #1GRI
     C                   EVAL      N4BUCL = #1BUCL
     C                   MOVE      #1BUSU        N4BUSU
     C                   EVAL      N4BUTY = #1BUTY                                          BUG26779
 
     C                   EVAL      N4TYLC = WACTN
     C                   EVAL      N4LCD  = BJRDNB
 
     C                   UPDATE    ERDETTD1
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ERDETTPD'
     C                   EVAL      DBKey = KMMOD+KTRTY+KTRST+KTRCL
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTRtv - Validates the Transaction Type Decision Table    *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTRtv     BEGSR
 
      ** Check if Position To/Filter is entered
 
     C                   DOU       WREAD   = 'Y' OR
     C                             %EOF(ERDETTL1)
     C                   EVAL      WREAD   = 'Y'
     C                   READ      ERDETTL1
     C                   IF        #1KMOD <> *BLANKS AND
     C                             #1KMOD <> N4MMOD
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KTYP <> *BLANKS AND
     C                             #1KTYP <> N4TRTY
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KSTP <> *BLANKS AND
     C                             #1KSTP <> N4TRST
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KCLS <> *BLANKS AND
     C                             #1KCLS <> N4TRCL
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KGRI <> *BLANKS AND
     C                             #1KGRI <> N4GRI
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KBUC <> *BLANKS AND
     C                             #1KBUC <> N4BUCL
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KBUS <> *BLANKS AND
     C                             #1KBUS <> %CHAR(N4BUSU)
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KBCT <> *BLANKS AND                                    BUG26779
     C                             %SCAN(%TRIM(#1KBCT):N4BUTY) = 0                          BUG26779
     C                   EVAL      WREAD   = 'N'                                            BUG26779
     C                   ENDIF                                                              BUG26779
 
     C                   IF        #1KDES <> *BLANKS
     C                   MOVEL     #1KDES        WDesc
     C                   EVAL      KTRTY = N4TRTY
     C                   EVAL      KTRST = N4TRST
     C                   EVAL      KTRCL = N4TRCL
     C                   SELECT
     C                   WHEN      N4MMOD = 'FX' OR
     C                             N4MMOD = 'MM'
     C     KTRST         CHAIN     SDDLSTL1
     C                   IF        %FOUND(SDDLSTL1)
 
     C                   IF        WDesc <> ASDSTN
     C                   EVAL      WREAD = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   WHEN      N4MMOD = 'LE'
     C     KDTST         CHAIN     SDLOANL1
     C                   IF        %FOUND(SDLOANL1)
 
     C                   IF        WDesc <> AYLNTD
     C                   EVAL      WREAD = 'N'
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
      *  SRTxnTVal - Validates the Transaction Type Decision Table    *
      *              subfile                                          *
      *                                                               *
      *****************************************************************
     C     SRTxnTVal     BEGSR
 
     C                   READC     ER000180S1
     C                   DOW       NOT %EOF
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   MOVEA     '00'          *IN(21)
     C                   MOVEA     '00'          *IN(24)
     C                   EVAL      *IN26  = '0'                                             BUG26779
 
     C                   IF        #1ACTN = 'D'
     C                   EVAL      WACTN = 'D'
     C                   ELSE
     C                   EVAL      WACTN = 'A'
     C                   ENDIF
 
     C                   EXSR      SRVActn
     C                   IF        #1ACTN <> 'D'
     C                   EXSR      SRVGRI
     C                   EXSR      SRVBUCL
     C                   EXSR      SRVBUSU
     C                   EXSR      SRVBUTY                                                  BUG26779
 
     C                   IF        WTErrFlg = 'N'
     C                   EXSR      SRTxnTUpd
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    ER000180S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     ER000180S1
     C                   ENDDO
 
     C                   EVAL      WTBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTxnTDel - Deletes the Transaction Type Decision Table      *
      *              Record                                           *
      *                                                               *
      *****************************************************************
     C     SRTxnTDel     BEGSR
 
     C                   EVAL      KMMOD = #1MMOD
     C                   EVAL      KTRTY = #1TRTY
     C                   EVAL      KTRST = #1TRST
     C                   EVAL      KTRCL = #1TRCL
     C     KTxnT         CHAIN     ERDETTL0
 
     C                   IF        %FOUND(ERDETTL0)
     C     KTxnT         DELETE    ERDETTD1
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
 
     C                   IF        #1ACTN <> *BLANK
 
     C                   IF        #1ACTN <> 'D'
 
      ** Action Code must be 'D' (Delete).
 
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C**********         EVAL      PMsgFile = 'GBSDUSRMSG'                                  BUG25878
     C**********         EVAL      PMsgID = 'USR4723'                                       BUG25878
     C                   EVAL      PMsgID = 'ERC0001'                                       BUG25878
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
     C                   EXSR      SRTxnTDel
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMMOD - Validates the Module                               *
      *                                                               *
      *****************************************************************
     C     SRVMMOD       BEGSR
 
     C                   IF        #2MMOD <> 'FX' AND
     C                             #2MMOD <> 'MM' AND
     C                             #2MMOD <> 'LE'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0024'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTRTP - Validates the Transaction Type/Subtype/Class       *
      *                                                               *
      *****************************************************************
     C     SRVTRTP       BEGSR
 
     C                   EVAL      KTRTY = #2TRTY
     C                   EVAL      KTRST = #2TRST
 
     C                   SELECT
 
     C                   WHEN      #2MMOD = 'FX'
 
     C                   IF        #2TRTY = 'FP' OR
     C                             #2TRTY =  'FS' OR
     C                             #2TRTY =  'CX' OR
     C                             #2TRTY =  'PI' OR
     C                             #2TRTY =  'SI' OR
     C                             #2TRTY =  'OP' OR
     C                             #2TRTY =  'OT' OR
     C                             #2TRTY =  'SW'
 
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      #2TRST        PTRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0026'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #2TRST = '?'
     C                   EVAL      #2TRST = ASDSTC
     C                   EVAL      KTRST = ASDSTC
     C                   ENDIF
 
     C                   IF        CDL038 = 'Y'
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      #2TRCL        PTRCL
     C     SDTCLS        PARM      SDTCLS        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0029'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      KTRCL = TCCLAS
     C                   EVAL      #2TRCL = TCCLAS
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KTRCL = *BLANKS
     C                   ENDIF
 
     C                   IF        *IN34 = *OFF
     C     KDTST         CHAIN     FDDTSTL0
     C                   IF        NOT %FOUND(FDDTSTL0)
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0027'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #2TRTY = DTPE11
     C                   EVAL      #2TRST = DLST11
     C                   IF        CDL038 = 'Y'
     C                   EVAL      #2TRCL = CLAS11
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0025'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   WHEN      #2MMOD = 'MM'
 
     C                   IF        #2TRTY = 'IP' OR
     C                             #2TRTY =  'IT' OR
     C                             #2TRTY =  'TD' OR
     C                             #2TRTY =  'TI' OR
     C                             #2TRTY =  'CI' OR
     C                             #2TRTY =  'CD' OR
     C                             #2TRTY =  'CL'
 
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      #2TRST        PTRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0026'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #2TRST = '?'
     C                   EVAL      #2TRST = ASDSTC
     C                   EVAL      KTRST = ASDSTC
     C                   ENDIF
 
     C                   IF        CDL038 = 'Y'
     C                   CALL      'AOTCLSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      #2TRCL        PTRCL
     C     SDTCLS        PARM      SDTCLS        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0029'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      KTRCL = TCCLAS
     C                   EVAL      #2TRCL = TCCLAS
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      KTRCL = *BLANKS
     C                   ENDIF
 
     C                   IF        *IN34 = *OFF
     C     KDTST         CHAIN     FDDTSTL0
     C                   IF        NOT %FOUND(FDDTSTL0)
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0027'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #2TRTY = DTPE11
     C                   EVAL      #2TRST = DLST11
     C                   IF        CDL038 = 'Y'
     C                   EVAL      #2TRCL = CLAS11
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0025'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   WHEN      #2MMOD = 'LE'
 
     C                   IF        CLE042 = 'Y'
     C                   EVAL      PTRCL = #2TRCL
     C                   ELSE
     C                   EVAL      PTRCL = *BLANKS
     C                   ENDIF
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      #2TRTY        PTRTY
     C                   PARM      #2TRST        PTRST
     C                   PARM                    PTRCL
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0028'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #2TRTY = AYLNTY
     C                   EVAL      #2TRST = AYLNST
     C                   IF        CLE042 = 'Y'
     C                   EVAL      #2TRCL = AYLNCL
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVTRCL - Validates the Transaction Class                    *
      *                                                               *
      *****************************************************************
     C     SRVTRCL       BEGSR
 
     C                   IF        (#2MMOD = 'FX' OR
     C                             #2MMOD = 'MM') AND
     C                             CDL038 = 'N' AND
     C                             #2TRCL <> *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0029'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   IF        #2MMOD = 'LE' AND
     C                             CLE042 = 'N' AND
     C                             #2TRCL <> *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0029'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVGRI  - Validates the Extract to GRI flag                  *
      *                                                               *
      *****************************************************************
     C     SRVGRI        BEGSR
 
     C                   IF        WACTN = 'I'
 
     C                   IF        #2GRI <> *BLANKS
     C                   IF        #2GRI <> 'Y' AND
     C                             #2GRI <> 'N'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0016'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #2GRI  = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        #1GRI <> *BLANKS                                         BUG25878
     C                   IF        #1GRI <> 'Y' AND
     C                             #1GRI <> 'N'
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0016'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ELSE                                                               BUG25878
     C                   EVAL      #1GRI  = 'Y'                                             BUG25878
     C                   ENDIF
     C                   ENDIF                                                              BUG25878
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUCL - Validates the Business Classification Class        *
      *                                                               *
      *****************************************************************
     C     SRVBUCL       BEGSR
 
     C                   IF        WACTN = 'I'
 
     C                   IF        #2GRI  = 'Y' OR
     C                             #2GRI  = 'N'
     C                   IF        #2BUCL = *BLANKS AND
     C                             #2GRI  = 'Y'
 
      ** Business Classification class is required.
 
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0017'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #2BUCL <> *BLANKS
 
     C                   CALL      'AOBUCLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #2BUCL        PBUCL
     C     SDBUCL        PARM      SDBUCL        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#2BUCL) <> *ZERO
     C                   EVAL      #2BUCL = N8BUCL
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0018'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        #1GRI  = 'Y' OR
     C                             #1GRI  = 'N'
     C                   IF        #1BUCL = *BLANKS AND
     C                             #1GRI  = 'Y'
 
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0017'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #1BUCL <> *BLANKS
 
     C                   CALL      'AOBUCLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #1BUCL        PBUCL
     C     SDBUCL        PARM      SDBUCL        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#1BUCL) <> *ZERO
     C                   EVAL      #1BUCL   = N8BUCL
     C                   EVAL      WTDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0018'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUSU - Validates the Business Classification Sub-Class    *
      *                                                               *
      *****************************************************************
     C     SRVBUSU       BEGSR
 
     C                   IF        WACTN = 'I'
 
     C                   IF        #2GRI  = 'Y' OR
     C                             #2GRI  = 'N'
     C                   IF        #2BUSU = *BLANKS AND
     C                             #2GRI  = 'Y'
 
      ** Business Classification sub class is required.
 
     C                   EVAL      *IN37 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0019'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #2BUSU <> *BLANKS
 
     C                   MOVE      #2BUSU        PBUSU
     C                   CALL      'AOBUSUR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PBUSU
     C     SDBUSU        PARM      SDBUSU        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C**********         IF        #2BUCL = 'DV'                                            BUG25883
     C**********                   AND #2BUSU <> '00'                                       BUG25883
     C**********                   AND #2BUSU <> '01'                                       BUG25883
      **********                                                                            BUG25883
     C**********         EVAL      *IN37    = *ON                                           BUG25883
     C**********         EVAL      WIErrFlg = 'Y'                                           BUG25883
     C**********         EVAL      PMsgID   = 'ERC0031'                                     BUG25883
     C**********         EVAL      PMsgDta  = #2BUCL                                        BUG25883
     C**********         EXSR      SRSndErr1                                                BUG25883
      **********                                                                            BUG25883
     C**********         ELSE                                                               BUG25883
 
     C                   IF        %SCAN('?':#2BUSU) <> *ZERO
     C                   MOVE      N9BUSU        #2BUSU
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C**********         ENDIF                                                              BUG25883
 
     C                   ELSE
 
     C                   EVAL      *IN37 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0020'
     C                   EXSR      SRSndErr
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        #1GRI  = 'Y' OR
     C                             #1GRI  = 'N'
     C                   IF        #1BUSU = *BLANKS AND
     C                             #1GRI  = 'Y'
 
      ** Business Classification sub class is required.
 
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0019'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   IF        #1BUSU <> *BLANKS
 
     C                   MOVE      #1BUSU        PBUSU
     C                   CALL      'AOBUSUR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PBUSU
     C     SDBUSU        PARM      SDBUSU        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C**********         IF        #1BUCL = 'DV'                                            BUG25883
     C**********                   AND #1BUSU <> '00'                                       BUG25883
     C**********                   AND #1BUSU <> '01'                                       BUG25883
      **********                                                                            BUG25883
     C**********         EVAL      *IN25    = *ON                                           BUG25883
     C**********         EVAL      WTErrFlg = 'Y'                                           BUG25883
     C**********         EVAL      PMsgID   = 'ERC0031'                                     BUG25883
     C**********         EVAL      PMsgDta  = #1BUCL                                        BUG25883
     C**********         EXSR      SRSndErr1                                                BUG25883
      **********                                                                            BUG25883
     C**********         ELSE                                                               BUG25883
 
     C                   IF        %SCAN('?':#1BUSU) <> *ZERO
     C                   MOVE      N9BUSU        #1BUSU
     C                   EVAL      WTDspFlg = 'Y'
     C                   ENDIF
 
     C**********         ENDIF                                                              BUG25883
 
     C                   ELSE
 
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0020'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     BUG26779
      /EJECT                                                                                BUG26779
      *****************************************************************                     BUG26779
      *                                                               *                     BUG26779
      *  SRVBUTY - Validates the Business Classification Type         *                     BUG26779
      *                                                               *                     BUG26779
      *****************************************************************                     BUG26779
     C     SRVBUTY       BEGSR                                                              BUG26779
                                                                                            BUG26779
     C                   IF        WACTN = 'I'                                              BUG26779
                                                                                            BUG26779
     C                   IF        #2GRI  = 'Y' OR                                          BUG26779
     C                             #2GRI  = 'N'                                             BUG26779
     C                   IF        #2BUTY = *BLANKS AND                                     BUG26779
     C                             #2GRI  = 'Y'                                             BUG26779
                                                                                            BUG26779
      ** Business Classification sub class is required.                                     BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN38 = *ON                                              BUG26779
     C                   EVAL      WIErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0033'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
     C                   IF        #2BUTY <> *BLANKS                                        BUG26779
                                                                                            BUG26779
     C                   MOVE      #2BUTY        PBUTY                                      BUG26779
     C                   CALL      'AOBUTYR0'                                               BUG26779
     C                   PARM      *BLANKS       PRTCD                                      BUG26779
     C                   PARM      '*KEY'        POPTN                                      BUG26779
     C                   PARM                    PBUTY                                      BUG26779
     C     SDBUTY        PARM      SDBUTY        DSFDY                                      BUG26779
                                                                                            BUG26779
     C                   IF        PRtCd = *BLANKS                                          BUG26779
                                                                                            BUG26779
     C                   IF        %SCAN('?':#2BUTY) <> *ZERO                               BUG26779
     C                   EVAL      #2BUTY   = N0BUTY                                        BUG26779
     C                   EVAL      WIDspFlg = 'Y'                                           BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN38 = *ON                                              BUG26779
     C                   EVAL      WIErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0034'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
                                                                                            BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
                                                                                            BUG26779
     C                   IF        #1GRI  = 'Y' OR                                          BUG26779
     C                             #1GRI  = 'N'                                             BUG26779
     C                   IF        #1BUTY = *BLANKS AND                                     BUG26779
     C                             #1GRI  = 'Y'                                             BUG26779
                                                                                            BUG26779
      ** Business Classification sub class is required.                                     BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN26 = *ON                                              BUG26779
     C                   EVAL      WTErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0033'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
     C                   IF        #1BUTY <> *BLANKS                                        BUG26779
                                                                                            BUG26779
     C                   MOVE      #1BUTY        PBUTY                                      BUG26779
     C                   CALL      'AOBUTYR0'                                               BUG26779
     C                   PARM      *BLANKS       PRTCD                                      BUG26779
     C                   PARM      '*KEY'        POPTN                                      BUG26779
     C                   PARM                    PBUTY                                      BUG26779
     C     SDBUTY        PARM      SDBUTY        DSFDY                                      BUG26779
                                                                                            BUG26779
     C                   IF        PRtCd = *BLANKS                                          BUG26779
                                                                                            BUG26779
     C                   IF        %SCAN('?':#1BUTY) <> *ZERO                               BUG26779
     C                   EVAL      #1BUTY   = N0BUTY                                        BUG26779
     C                   EVAL      WTDspFlg = 'Y'                                           BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN26 = *ON                                              BUG26779
     C                   EVAL      WTErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0034'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDSR                                                              BUG26779
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVKeys - Validates the key fields.                          *
      *                                                               *
      *****************************************************************
     C     SRVKeys       BEGSR
 
     C                   IF        #2MMOD <> *BLANKS AND
     C                             #2TRTY <> *BLANKS AND
     C                             #2TRST <> *BLANKS
 
     C                   EVAL      KMMOD = #2MMOD
     C                   EVAL      KTRTY = #2TRTY
     C                   EVAL      KTRST = #2TRST
     C                   EVAL      KTRCL = #2TRCL
     C     KTxnT         CHAIN     ERDETTL1
 
     C                   IF        %FOUND(ERDETTL1)
 
      ** Transaction Type already exists.
 
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ER00506'
     C                   EXSR      SRSndErr
     C                   ELSE
      *
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #2TRST        PTRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   EVAL      #2DESC = ASDSTN
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
     C                   EVAL      WIErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'Y'
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
 
     C**********         MOVEA     '0000000'     *IN(31)                                    BUG26779
     C                   MOVEA     '00000000'    *IN(31)                                    BUG26779
 
      ** Set the subfile screen name and screen footer.
 
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
     C                   EVAL      #2MMOD = *BLANKS
     C                   EVAL      #2TRTY = *BLANKS
     C                   EVAL      #2TRST = *BLANKS
     C                   EVAL      #2TRCL = *BLANKS
     C                   EVAL      #2GRI  = *BLANK
     C                   EVAL      #2DESC = *BLANK
     C                   EVAL      #2BUCL = *BLANKS
     C                   EVAL      #2BUSU = *ZEROS
     C                   EVAL      #2BUTY = *BLANKS                                         BUG26779
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      W2SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C**********         MOVEA     '0000000'     *IN(31)                                    BUG26779
     C                   MOVEA     '00000000'    *IN(31)                                    BUG26779
 
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
     C                   WRITE     ER000180C2
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
 
     C                   DOW       WiScrCnt < 14 AND
     C                             WIErrFlg = 'N'
 
     C**********         MOVEA     '0000000'     *IN(31)                                    BUG26779
     C                   MOVEA     '00000000'    *IN(31)                                    BUG26779
     C                   EVAL      #2MMOD = *BLANKS
     C                   EVAL      #2TRTY = *BLANKS
     C                   EVAL      #2TRST = *BLANKS
     C                   EVAL      #2TRCL = *BLANKS
     C                   EVAL      #2GRI  = *BLANK
     C                   EVAL      #2DESC = *BLANK
     C                   EVAL      #2BUCL = *BLANKS
     C                   EVAL      #2BUSU = *BLANKS
     C                   EVAL      #2BUTY = *BLANKS                                         BUG26779
     C                   EVAL      W2SFRN = W2SFRN + 1
     C                   EVAL      #2SFRN = W2SFRN
     C                   EVAL      WiScrCnt = WiScrCnt + 1
     C                   WRITE     ER000180S2
 
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
 
      ** Display the full Transaction Type Decision Table input screen.
 
     C                   WRITE     ER000180F1
     C                   WRITE     ER000180C3
     C                   WRITE     ER000180F2
     C                   EXFMT     ER000180C2
 
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
 
     C**********         MOVEA     '0000000'     *IN(31)                                    BUG26779
     C                   MOVEA     '00000000'    *IN(31)                                    BUG26779
 
     C                   READC     ER000180S2
 
     C                   DOW       NOT %EOF
 
     C**********         MOVEA     '0000000'     *IN(31)                                    BUG26779
     C                   MOVEA     '00000000'    *IN(31)                                    BUG26779
 
     C                   IF        ISCR <> *BLANKS
 
      ** Validate the Module
 
     C                   EXSR      SRVMMOD
 
      ** Validate the Transaction Type/Subtype/Class
 
     C                   EXSR      SRVTRTP
 
      ** Validate the key fields.
 
     C                   EXSR      SRVKeys
 
      ** Validate the Transaction Class
 
     C                   EXSR      SRVTRCL
 
      ** Validate the Extract to GRI flag
 
     C                   EXSR      SRVGRI
 
      ** Validate the Business Classification Code
 
     C                   EXSR      SRVBUCL
 
      ** Validate the Business Classification Sub-Class
 
     C                   EXSR      SRVBUSU
                                                                                            BUG26779
      ** Validate the Business Classification Type                                          BUG26779
                                                                                            BUG26779
     C                   EXSR      SRVBUTY                                                  BUG26779
 
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    ER000180S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     ER000180S2
 
     C                   ENDDO
 
     C                   IF        WIErrFlg = 'Y'
     C                   EVAL      WIDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        WIDspFlg <> 'Y'
 
      ** Update the Transaction Type Decision Table file.
 
     C                   READC     ER000180S2
 
     C                   DOW       NOT %EOF
 
     C                   IF        ISCR <> *BLANKS
     C                   EXSR      SRiScrWrt
     C                   ENDIF
 
     C                   READC     ER000180S2
 
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        WIErrFlg = 'N'
     C                   EVAL      WIBldFlg = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrWrt - Writes new Transaction Type Decision Table       *
      *              record                                           *
      *                                                               *
      *****************************************************************
     C     SRiScrWrt     BEGSR
 
     C                   EVAL      KMMOD = #2MMOD
     C                   EVAL      KTRTY = #2TRTY
     C                   EVAL      KTRST = #2TRST
     C                   EVAL      KTRCL = #2TRCL
     C     KTxnT         CHAIN     ERDETTL0
 
     C                   IF        NOT %FOUND(ERDETTL0)
     C                   EVAL      N4MMOD = #2MMOD
     C                   EVAL      N4TRTY = #2TRTY
     C                   EVAL      N4TRST = #2TRST
     C                   EVAL      N4TRCL = #2TRCL
     C                   EVAL      N4GRI  = #2GRI
     C                   EVAL      N4BUCL = #2BUCL
     C                   MOVE      #2BUSU        N4BUSU
     C                   EVAL      N4BUTY = #2BUTY                                          BUG26779
     C                   EVAL      N4TYLC = 'I'
     C                   EVAL      N4LCD  = BJRDNB
     C                   WRITE     ERDETTD1
     C                   ELSE
 
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0030'
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
      *  SRSndErr1 - Sends error messages to the program message      *
      *              queue via ZA0350 (with message data)             *
      *                                                               *
      *****************************************************************
     C     SRSndErr1     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
     C                   PARM                    PMsgDta
 
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
 
     C     KTxnT         KLIST
     C                   KFLD                    KMMOD
     C                   KFLD                    KTRTY
     C                   KFLD                    KTRST
     C                   KFLD                    KTRCL
 
     C     KDTST         KLIST
     C                   KFLD                    KTRTY
     C                   KFLD                    KTRST
     C                   KFLD                    KTRCL
 
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
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if CDL038 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      CDL038 = 'N'
     C                   ELSE
     C                   EVAL      CDL038 = 'Y'
     C                   ENDIF
      *
      ** Check if CLE042 is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
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
(c) Finastra International Limited 2009
