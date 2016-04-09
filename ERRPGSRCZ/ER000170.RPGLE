     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Acct Code Decision Table Maint/Enquiry')      *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000170 - Midas ER Account Code Decision Table              *
      *             Maintenance/Enquiry                               *
      *                                                               *
      *  Function:  This program is used to maintain or enquire       *
      *             the account code decision table.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26779           Date 27Nov09               *
      *                 BUG26636           Date 03Nov09               *
      *                 BUG25878           Date 03Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change Request on GSART Table                     *
      *  BUG26636 - The inserted account code is missing after        *
      *             logging out.                                      *
      *  BUG25878 - German Features Link Testing fix (Recompile)      *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Account Codes
 
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ER Account Code Decision Table (Update)
 
     FERDEACL0  UF A E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG26636
 
      ** Midas ER Account Code Decision Table (Retrieval)
 
     FERDEACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ERDEACD0:ERDEACD1)
 
      ** Midas ER Bundesbank Decision Table Selection Display file
 
     FER000170DFCF   E             WORKSTN SFILE(ER000170S1:#1SFRN)
     F                                     SFILE(ER000170S2:#2SFRN)
 
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
     D  #2ACOD                 1     10
     D  #2EXTY                11     11
     D  #2BUCL                12     13
     D  #2BUSU                14     15
     D  #2BUTY                16     17                                                     BUG26779
 
      ** Bank Details Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Business Classification Class Structure
 
     D SDBUCL        E DS                  EXTNAME(SDBUCLPD)
 
      ** Business Classification Sub-Class Structure
 
     D SDBUSU        E DS                  EXTNAME(SDBUSUPD)
                                                                                            BUG26779
      ** Business Classification Type Structure                                             BUG26779
                                                                                            BUG26779
     D SDBUTY        E DS                  EXTNAME(SDBUTYPD)                                BUG26779
 
      ** Account Code Structure
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Short Access Object Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
 
     D I#Rtcd          S              7A
     D I#Mode          S              1A
 
      ** Access Object Parameters
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PCtry           S              2A
     D PKey            S              2A
     D PAccd           S             10A
 
      ** Standard Utility Parameters
 
     D PMsgFile        S             10A   INZ('STUSRMSG')
     D PMsgID          S             10A
 
      ** Key Fields
 
     D KACOD           S                   LIKE(N3ACOD)
 
      ** Working Variables
 
     D WADecCnt        S              4P 0
     D WiScrCnt        S              4P 0
     D W1SFRN          S              4P 0
     D W2SFRN          S              4P 0
     D WREAD           S              1A
     D WBUSU           S              2A
 
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
 
     C                   EXSR      SRADecMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecMain - Manages the Acct Decision Table subfile.        *
      *                                                               *
      *****************************************************************
     C     SRADecMain    BEGSR
 
     C                   EXSR      SRADecInit
 
     C                   EXSR      SRADecClr
 
     C                   DOW       F03 = *OFF AND
     C                             F12 = *OFF
 
     C                   EXSR      SRADecBld
 
     C                   EXSR      SRADecDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF
 
     C                   SELECT
 
     C                   WHEN      F05 = *ON
     C                   EXSR      SRADecRef
 
     C                   WHEN      F09 = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SRiScrMain
     C                   EVAL      F12 = *OFF
     C                   EXSR      SRADecRef
 
     C                   OTHER
 
     C                   IF        W1SFRN <> *ZERO
     C                   EXSR      SRADecVal
 
     C                   IF        WTDspFlg = 'N' AND
     C                             WTBldFlg = 'N'
     C                   EXSR      SRADecRef
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03    = *ON
     C                   EVAL      I#Rtcd = '*EXIT'
     C                   ENDIF
     C                   IF        F12    = *ON
     C                   EVAL      I#Rtcd = '*RETN'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecInit - Handles the initial Account Code Decision Table *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRADecInit    BEGSR
 
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
 
     C     *LOVAL        SETLL     ERDEACL1
 
      ** Reset the subfile error indicators.
 
     C**********         MOVEA     '0000'        *IN(21)                                    BUG26779
     C                   MOVEA     '00000'       *IN(21)                                    BUG26779
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecRef - Refreshes the Acct Code Decision table subfile.  *
      *                                                               *
      *****************************************************************
     C     SRADecRef     BEGSR
 
      ** Clear the subfile.
 
     C                   EXSR      SRADecClr
 
      ** Initialise relevant variables.
 
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
     C                   EVAL      #1KACD = *BLANKS
     C                   EVAL      #1KNAR = *BLANKS
     C                   EVAL      #1KTYP = *BLANKS
     C                   EVAL      #1KEXT = *BLANKS
     C                   EVAL      #1KBCL = *BLANKS
     C                   EVAL      #1KBSC = *BLANKS
     C                   EVAL      #1KBCT = *BLANKS                                         BUG26779
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1ACOD = *BLANKS
     C                   EVAL      #1NARA = *BLANKS
     C                   EVAL      #1TYPE = *BLANKS
     C                   EVAL      #1EXTY = *BLANKS
     C                   EVAL      #1BUCL = *BLANKS
     C                   EVAL      #1BUSU = *BLANKS
     C                   EVAL      #1BUTY = *BLANKS                                         BUG26779
 
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      W1SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C**********         MOVEA     '0000'        *IN(21)                                    BUG26779
     C                   MOVEA     '00000'       *IN(21)                                    BUG26779
 
      ** Set the subfile screen name and screen footer.
 
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     ERDEACL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecClr - Clears the Acct Code Decision table subfile.     *
      *                                                               *
      *****************************************************************
     C     SRADecClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     ER000170C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecBld - Builds the Acct Code Decision table subfile.     *
      *                                                               *
      *****************************************************************
     C     SRADecBld     BEGSR
 
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
 
     C                   EXSR      SRADecClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WTBldFlg = 'N'
 
      ** Position to
 
     C                   IF        #1KACD <> *BLANKS
     C                   EVAL      KACOD = %TRIM(#1KACD)
     C     KACOD         SETLL     ERDEACL1
     C                   ELSE
     C     *LOVAL        SETLL     ERDEACL1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WADecCnt = *ZERO
 
      ** Select all Acct Code Decision Table
 
      ** Read Account Decision Table
 
     C                   EXSR      SRADecRd
 
     C                   DOW       NOT %EOF(ERDEACL1)
 
     C**********         MOVEA     '0000'        *IN(21)                                    BUG26779
     C                   MOVEA     '00000'       *IN(21)                                    BUG26779
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1ACOD = N3ACOD
     C     N3ACOD        CHAIN     SDACODL1
     C                   IF        %FOUND()
     C                   EVAL      #1NARA = A5ACCN
     C                   EVAL      #1TYPE = A5ACTY
     C                   ELSE
     C                   EVAL      #1NARA = *BLANKS
     C                   EVAL      #1TYPE = *BLANKS
     C                   ENDIF
     C                   EVAL      #1EXTY = N3GRI
     C                   EVAL      #1BUCL = N3BUCL
     C                   MOVE      N3BUSU        #1BUSU
     C                   EVAL      #1BUTY = N3BUTY                                          BUG26779
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WADecCnt = WADecCnt + 1
     C                   WRITE     ER000170S1
 
      ** Leave the Acct Code Decision Table selection if one subfile
      ** page has been filled.
 
     C                   IF        WADecCnt = 13
 
      ** Check first if there are more records available.
 
     C                   EXSR      SRADecRD
 
     C                   IF        %EOF(ERDEACL1)
     C                   LEAVE
     C                   ELSE
     C                   READP     ERDEACL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRADecRD
 
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'ERL0020'
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
      *  SRADecRd - Read Acct Code Decision table subfile.            *
      *                                                               *
      *****************************************************************
     C     SRADecRd      BEGSR
 
      ** Check if Position To/Filter is entered
 
     C                   DOU       WREAD   = 'Y' OR
     C                             %EOF(ERDEACL1)
     C                   EVAL      WREAD   = 'Y'
     C                   READ      ERDEACL1
     C                   IF        #1KNAR <> *BLANKS
     C     N3ACOD        CHAIN     SDACODL1
     C                   IF        %SCAN(%TRIM(#1KNAR):A5ACCN) = 0
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   IF        #1KTYP <> *BLANKS
     C     N3ACOD        CHAIN     SDACODL1
     C                   IF        #1KTYP <> A5ACTY
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   IF        #1KEXT <> *BLANKS AND
     C                             #1KEXT <> N3GRI
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KBCL <> *BLANKS AND
     C                             %SCAN(%TRIM(#1KBCL):N3BUCL) = 0
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   IF        #1KBSC <> *BLANKS
     C                   MOVE      N3BUSU        WBUSU
     C                   IF        %SCAN(%TRIM(#1KBSC):WBUSU) = 0
     C                   EVAL      WREAD   = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   IF        #1KBCT <> *BLANKS AND                                    BUG26779
     C                             %SCAN(%TRIM(#1KBCT):N3BUTY) = 0                          BUG26779
     C                   EVAL      WREAD   = 'N'                                            BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecDsp - Displays the Acct Code Decision table subfile.   *
      *                                                               *
      *****************************************************************
     C     SRADecDsp     BEGSR
 
      ** Display the full Acct Code Decision table selection screen.
 
     C                   WRITE     ER000170F1
     C                   WRITE     ER000170C3
     C                   WRITE     ER000170F2
     C                   EXFMT     ER000170C1
 
      ** Clear messages from the program message queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecVal - Validates the Acct Code Decision table subfile.  *
      *                                                               *
      *****************************************************************
     C     SRADecVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WTErrFlg = 'N'
     C                   EVAL      WTDspFlg = 'N'
     C                   EVAL      WTBldFlg = 'N'
 
      ** Reset the subfile error indicators.
 
     C**********         MOVEA     '0000'        *IN(21)                                    BUG26779
     C                   MOVEA     '00000'       *IN(21)                                    BUG26779
 
     C                   READC     ER000170S1
 
     C                   DOW       NOT %EOF
 
     C**********         MOVEA     '0000'        *IN(21)                                    BUG26779
     C                   MOVEA     '00000'       *IN(21)                                    BUG26779
 
      ** Validate the Action Code.
 
     C                   EXSR      SRVActn
 
     C                   IF        #1ACTN <> 'D'
 
      ** Validate Extract to GRI field.
 
     C                   EXSR      SRVGRI1
 
      ** Validate Business Classification Class.
 
     C                   EXSR      SRVBUCL1
 
      ** Validate Business Classification sub Class.
 
     C                   EXSR      SRVBUSU1
                                                                                            BUG26779
      ** Validate Business Classification Type.                                             BUG26779
                                                                                            BUG26779
     C                   EXSR      SRVBUTY1                                                 BUG26779
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    ER000170S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     ER000170S1
 
     C                   ENDDO
 
     C                   IF        WTErrFlg = 'Y'
     C                   EVAL      WTDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     ER000170S1
 
     C                   DOW       NOT %EOF
 
     C                   IF        #1ACTN = 'D'
     C                   EVAL      WACTN = 'D'
     C                   ELSE
     C                   EVAL      WACTN = 'A'
     C                   ENDIF
 
     C                   EXSR      SRADecUpd
 
     C                   READC     ER000170S1
 
     C                   ENDDO
 
     C                   EVAL      WTBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADecUpd - Updates the Acct Code Decision table file.       *
      *                                                               *
      *****************************************************************
     C     SRADecUpd     BEGSR
 
     C                   EVAL      KACOD = #1ACOD
     C     KACOD         CHAIN     ERDEACL0
 
     C                   IF        %FOUND(ERDEACL0)
 
     C                   IF        WACTN  = 'A'
 
     C                   EVAL      N3GRI  = #1EXTY
     C                   EVAL      N3BUCL = #1BUCL
     C                   MOVE      #1BUSU        N3BUSU
     C                   EVAL      N3BUTY = #1BUTY                                          BUG26779
 
     C                   EVAL      N3TYLC = WACTN
     C                   EVAL      N3LCD  = BJRDNB
 
     C                   UPDATE    ERDEACD0
     C                   ELSE
 
      ** Delete record
 
     C                   DELETE    ERDEACD0
     C                   ENDIF
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ERDEACPD'
     C                   EVAL      DBKey = KACOD
     C                   EVAL      DBase = 102
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
     C                   EVAL      PMsgID = 'ERC0001'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVGRI1 - Validates Extract to GRI.                          *
      *                                                               *
      *****************************************************************
     C     SRVGRI1       BEGSR
 
     C                   IF        #1EXTY <> *BLANKS
 
     C                   IF        #1EXTY <> 'Y' AND
     C                             #1EXTY <> 'N'
 
      ** Extract to GRI field must be 'Y' or 'N'.
 
     C                   EVAL      *IN22 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0016'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      #1EXTY = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUCL1 - Validates Business Classification Class.          *
      *                                                               *
      *****************************************************************
     C     SRVBUCL1      BEGSR
 
     C                   IF        #1EXTY = 'Y' OR
     C                             #1EXTY = 'N'
     C                   IF        #1BUCL = *BLANKS AND
     C                             #1EXTY = 'Y'
 
      ** Business Classification class is required.
 
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0017'
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
     C                   IF        #1BUCL <> *BLANKS
 
     C                   CALL      'AOBUCLR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #1BUCL        PKey
     C     SDBUCL        PARM      SDBUCL        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#1BUCL) <> *ZERO
     C                   EVAL      #1BUCL = N8BUCL
     C                   EVAL      WTDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Business Classification class is invalid.
 
     C                   EVAL      *IN23 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0018'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUSU1 - Validates Business Classification Sub-Class.      *
      *                                                               *
      *****************************************************************
     C     SRVBUSU1      BEGSR
 
     C                   IF        #1EXTY = 'Y' OR
     C                             #1EXTY = 'N'
     C                   IF        #1BUSU = *BLANKS AND
     C                             #1EXTY = 'Y'
 
      ** Business Classification sub class is required.
 
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0019'
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
     C                   IF        #1BUSU <> *BLANKS
 
     C                   CALL      'AOBUSUR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #1BUSU        PKey
     C     SDBUSU        PARM      SDBUSU        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#1BUSU) <> *ZERO
     C                   MOVE      N9BUSU        #1BUSU
     C                   EVAL      WTDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Business Classification class is invalid.
 
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WTErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0020'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     BUG26779
      /EJECT                                                                                BUG26779
      *****************************************************************                     BUG26779
      *                                                               *                     BUG26779
      *  SRVBUTY1 - Validates Business Classification Type.           *                     BUG26779
      *                                                               *                     BUG26779
      *****************************************************************                     BUG26779
     C     SRVBUTY1      BEGSR                                                              BUG26779
                                                                                            BUG26779
     C                   IF        #1EXTY = 'Y' OR                                          BUG26779
     C                             #1EXTY = 'N'                                             BUG26779
     C                   IF        #1BUTY = *BLANKS AND                                     BUG26779
     C                             #1EXTY = 'Y'                                             BUG26779
                                                                                            BUG26779
      ** Business Classification sub class is required.                                     BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN25 = *ON                                              BUG26779
     C                   EVAL      WTErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0033'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
                                                                                            BUG26779
     C                   IF        #1BUTY <> *BLANKS                                        BUG26779
                                                                                            BUG26779
     C                   CALL      'AOBUTYR0'                                               BUG26779
     C                   PARM      *BLANKS       PRtCd                                      BUG26779
     C                   PARM      '*KEY   '     POptn                                      BUG26779
     C                   PARM      #1BUTY        PKey                                       BUG26779
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
      ** Business Classification class is invalid.                                          BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN25 = *ON                                              BUG26779
     C                   EVAL      WTErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0034'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDSR                                                              BUG26779
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVACOD - Validates Extract to GRI. (Add Mode)               *
      *                                                               *
      *****************************************************************
     C     SRVACOD       BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #2ACOD        PAccd
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C                   IF        PRtCd  = *BLANKS AND
     C                             A5TOIN = 'N'
 
     C                   IF        %SCAN('?':#2ACOD) <> *ZERO
     C                   EVAL      #2ACOD   = A5ACCD
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
     C     A5ACCD        SETLL     ERDEACL0
     C                   IF        %EQUAL()
 
      ** Account Code already exists on Decision Table.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERB3004'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   EVAL      #2NARA   = A5ACCN
     C                   EVAL      #2TYPE   = A5ACTY
     C                   ENDIF
 
     C                   ELSE
 
      ** Account Code is not valid.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERB3003'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVGRI2 - Validates Extract to GRI. (Add Mode)               *
      *                                                               *
      *****************************************************************
     C     SRVGRI2       BEGSR
 
     C                   IF        #2EXTY <> *BLANKS
 
     C                   IF        #2EXTY <> 'Y' AND
     C                             #2EXTY <> 'N'
 
      ** Extract to GRI field must be 'Y' or 'N'.
 
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0016'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #2EXTY = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUCL2 - Validates Business Classification Class (Add Mode)*
      *                                                               *
      *****************************************************************
     C     SRVBUCL2      BEGSR
 
     C                   IF        #2EXTY = 'Y' OR
     C                             #2EXTY = 'N'
     C                   IF        #2BUCL = *BLANKS AND
     C                             #2EXTY = 'Y'
 
      ** Business Classification class is required.
 
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0017'
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
     C                   IF        #2BUCL <> *BLANKS
 
     C                   CALL      'AOBUCLR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #2BUCL        PKey
     C     SDBUCL        PARM      SDBUCL        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#2BUCL) <> *ZERO
     C                   EVAL      #2BUCL = N8BUCL
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Business Classification class is invalid.
 
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0018'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBUSU2 - Validates Business Classification Sub-Class.      *
      *             (Add Mode)                                        *
      *                                                               *
      *****************************************************************
     C     SRVBUSU2      BEGSR
 
     C                   IF        #2EXTY = 'Y' OR
     C                             #2EXTY = 'N'
     C                   IF        #2BUSU = *BLANKS AND
     C                             #2EXTY = 'Y'
 
      ** Business Classification sub class is required.
 
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0019'
     C                   EXSR      SRSndErr
 
     C                   ELSE
 
     C                   IF        #2BUSU <> *BLANKS
 
     C                   CALL      'AOBUSUR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #2BUSU        PKey
     C     SDBUSU        PARM      SDBUSU        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        %SCAN('?':#2BUSU) <> *ZERO
     C                   MOVE      N9BUSU        #2BUSU
     C                   EVAL      WIDspFlg = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Business Classification class is invalid.
 
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WIErrFlg = 'Y'
     C                   EVAL      PMsgID = 'ERC0020'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     BUG26779
      /EJECT                                                                                BUG26779
      *****************************************************************                     BUG26779
      *                                                               *                     BUG26779
      *  SRVBUTY2 - Validates Business Classification Type.           *                     BUG26779
      *             (Add Mode)                                        *                     BUG26779
      *                                                               *                     BUG26779
      *****************************************************************                     BUG26779
     C     SRVBUTY2      BEGSR                                                              BUG26779
                                                                                            BUG26779
     C                   IF        #2EXTY = 'Y' OR                                          BUG26779
     C                             #2EXTY = 'N'                                             BUG26779
     C                   IF        #2BUTY = *BLANKS AND                                     BUG26779
     C                             #2EXTY = 'Y'                                             BUG26779
                                                                                            BUG26779
      ** Business Classification sub class is required.                                     BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN35 = *ON                                              BUG26779
     C                   EVAL      WIErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0033'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
                                                                                            BUG26779
     C                   ELSE                                                               BUG26779
                                                                                            BUG26779
     C                   IF        #2BUTY <> *BLANKS                                        BUG26779
                                                                                            BUG26779
     C                   CALL      'AOBUTYR0'                                               BUG26779
     C                   PARM      *BLANKS       PRtCd                                      BUG26779
     C                   PARM      '*KEY   '     POptn                                      BUG26779
     C                   PARM      #2BUTY        PKey                                       BUG26779
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
      ** Business Classification class is invalid.                                          BUG26779
                                                                                            BUG26779
     C                   EVAL      *IN35 = *ON                                              BUG26779
     C                   EVAL      WIErrFlg = 'Y'                                           BUG26779
     C                   EVAL      PMsgID = 'ERC0034'                                       BUG26779
     C                   EXSR      SRSndErr                                                 BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
     C                   ENDIF                                                              BUG26779
                                                                                            BUG26779
     C                   ENDSR                                                              BUG26779
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
 
     C**********         MOVEA     '0000'        *IN(31)                                    BUG26779
     C                   MOVEA     '00000'       *IN(31)                                    BUG26779
 
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
     C                   EVAL      #2ACOD = *BLANKS
     C                   EVAL      #2EXTY = *BLANKS
     C                   EVAL      #2BUCL = *BLANKS
     C                   EVAL      #2BUSU = *BLANKS
     C                   EVAL      #2BUTY = *BLANKS                                         BUG26779
     C                   EVAL      #2SFRN = *ZERO
     C                   EVAL      W2SFRN = *ZERO
 
      ** Reset the subfile error indicators.
 
     C**********         MOVEA     '0000'        *IN(31)                                    BUG26779
     C                   MOVEA     '00000'       *IN(31)                                    BUG26779
 
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
     C                   WRITE     ER000170C2
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
 
     C                   DOW       WiScrCnt < 13
 
     C**********         MOVEA     '0000'        *IN(31)                                    BUG26779
     C                   MOVEA     '00000'       *IN(31)                                    BUG26779
     C                   EVAL      #2ACOD = *BLANKS
     C                   EVAL      #2NARA = *BLANKS
     C                   EVAL      #2TYPE = *BLANKS
     C                   EVAL      #2EXTY = *BLANKS
     C                   EVAL      #2BUCL = *BLANKS
     C                   EVAL      #2BUSU = *BLANKS
     C                   EVAL      #2BUTY = *BLANKS                                         BUG26779
     C                   EVAL      W2SFRN = W2SFRN + 1
     C                   EVAL      #2SFRN = W2SFRN
     C                   EVAL      WiScrCnt = WiScrCnt + 1
     C                   WRITE     ER000170S2
 
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
 
      ** Display the full Acct Code Decision Table input screen.
 
     C                   WRITE     ER000170F1
     C                   WRITE     ER000170C3
     C                   WRITE     ER000170F2
     C                   EXFMT     ER000170C2
 
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
 
     C**********         MOVEA     '0000'        *IN(31)                                    BUG26779
     C                   MOVEA     '00000'       *IN(31)                                    BUG26779
 
     C                   READC     ER000170S2
 
     C                   DOW       NOT %EOF
 
     C**********         MOVEA     '0000'        *IN(31)                                    BUG26779
     C                   MOVEA     '00000'       *IN(31)                                    BUG26779
 
     C                   IF        ISCR <> *BLANKS
 
      ** Validate Account Code.
 
     C                   EXSR      SRVACOD
 
      ** Validate Extract to GRI field.
 
     C                   EXSR      SRVGRI2
 
      ** Validate Business Classification Class.
 
     C                   EXSR      SRVBUCL2
 
      ** Validate Business Classification sub Class
 
     C                   EXSR      SRVBUSU2
                                                                                            BUG26779
      ** Validate Business Classification Type                                              BUG26779
                                                                                            BUG26779
     C                   EXSR      SRVBUTY2                                                 BUG26779
 
     C                   ENDIF
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    ER000170S2
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     ER000170S2
 
     C                   ENDDO
 
     C                   IF        WIErrFlg = 'Y'
     C                   EVAL      WIDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        WIDspFlg <> 'Y'
 
      ** Update the Acct Code Decision Table file.
 
     C                   READC     ER000170S2
 
     C                   DOW       NOT %EOF
 
     C                   IF        ISCR <> *BLANKS
     C                   EXSR      SRiScrWrt
     C                   ENDIF
 
     C                   READC     ER000170S2
 
     C                   ENDDO
 
     C                   EXSR      SRiScrRef
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRiScrWrt - Writes new Acct Code Decision Table.             *
      *                                                               *
      *****************************************************************
     C     SRiScrWrt     BEGSR
 
     C                   EVAL      KACOD = #2ACOD
     C     KACOD         CHAIN     ERDEACL0
 
     C                   IF        NOT %FOUND(ERDEACL0)
     C                   EVAL      N3ACOD = #2ACOD
     C                   EVAL      N3GRI  = #2EXTY
     C                   EVAL      N3BUCL = #2BUCL
     C                   MOVE      #2BUSU        N3BUSU
     C                   EVAL      N3BUTY = #2BUTY                                          BUG26779
     C                   EVAL      N3TYLC = 'I'
     C                   EVAL      N3LCD  = BJRDNB
     C                   WRITE     ERDEACD0
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ERDEACPD'
     C                   EVAL      DBKey = KACOD
     C                   EVAL      DBase = 106
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
     C                   PARM                    I#Rtcd
     C                   PARM                    I#Mode
 
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
 
     C                   EVAL      #3PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C                   IF        I#Mode  = 'E'
     C                   EVAL      ENQMODE = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2009
