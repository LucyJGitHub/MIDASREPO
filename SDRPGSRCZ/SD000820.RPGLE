     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Local Tax Office Maintenance')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000820 - Midas SD Local Tax Office Maintenance             *
      *                                                               *
      *  Function:  This program Maintains Branch Local Tax Office    *
      *             information.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24807           Date 08Jul09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24807 - Missing function in CER048                        *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         SFLDSP Indicator                                *
      *    33         Branch in error                                 *
      *    34         Local Tax Offcie shouldn't be blank             *
      *    35         Registration No shouldn't be blank              *
      *    79         Action Non-Display                              *
      *    84         SFLNXTCHG Indicator                             *
      *    85         SFLINZ Indicator                                *
      *    88         Protect branch Indicator                        *
      *    89         Footer change Indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInitSet - Initial setup to display a Subfile.              *
      *  SRLoadSFL - Loading a Subfile.                               *
      *  SRProcess - Subfile data processing.                         *
      *  SRValid - Valdiity Check of data eneterd on Subfile.         *
      *  SRFile -  WRITE,UPDATE & Delete record in SDLTOFPD.          *
      *  SRBranch - Branch validity check routine by 'AOBRCHR0'.      *
      *  SRSndMsg - Error mesage routine.                            *
      *  SRClrMsg - Clearing the message.                             *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD - Local Tax Office Enquiry/Maintenance
      *
     FSD000820DFCF   E             WORKSTN
     F                                     SFILE(SD000820S0:SRRN)
     F                                     INFSR(*PSSR)
      *
      ** Midas SD - Local Tax Office File: Update Index
      *
     FSDLTOFL0  UF A E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      ** Data Area giving Installation Control Details
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally described DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Branch details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
     D WError          S              1A
     D WErrf           S              1A
     D WMode           S              1A
     D WSet            S              1A
     D SRRN            S              5P 0
      *
      ** Parameter for AOBRCHR0
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PBrch           S              3A
      *
      ** Parameter for ZVACTU/ZVACTBU
      *
     D PActnCd         S              1A
     D PError          S              1P 0
     D PBranch         S              3A
      *
      ** Parameter for Z2SNMGC/Y2CLMSC
      *
     D ZApgmq          S             10A
     D ZApgrl          S              5A
     D ZAmsid          S              7A
     D ZAmsgf          S             10A
     D ZAmsda          S            132A
     D ZAmstp          S              7A
      *
      ** An Array to Check the duplicate entries for Branch
      *
     D BrchAr          S              3A   DIM(500)
     D Idx             S              3P 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
     C                   EXSR      SRInitSet
     C                   EXSR      SRLoadSFL
      *
      ** Loop While EXIT not taken from screen
      *
     C                   DOW       *IN03 = *OFF
      *
      ** Display Screen
      *
     C                   WRITE     SD000820C1
     C                   WRITE     SD000820F0
     C                   EXFMT     SD000820C0
      *
      ** Clear Program Messages
      *
     C                   EXSR      SRClrMsg
      *
      ** Process Function Keys
      *
      ** Refresh
      *
     C                   IF        *IN05 = *ON
     C                   EXSR      SRInitSet
      *
     C                   IF        WMode = 'A'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
      *
     C                   EXSR      SRLoadSFL
     C                   ENDIF
      *
      ** Mode
      *
     C                   IF        *IN09 = *ON
      *
     C                   IF        WMode = 'C'
     C                   EVAL      WMode = 'A'
     C                   EXSR      SRInitSet
     C                   EVAL      *IN85 = *ON
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN89 = *ON
     C                   EVAL      Idx = 1
     C                   EXSR      SRLoadSFL
      *
     C                   ELSEIF    WMode = 'A'
     C                   EVAL      WMode = 'C'
     C                   EVAL      *IN85 = *OFF
     C                   EXSR      SRInitSet
     C                   EXSR      SRLoadSFL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Process Screen Input
      *
     C                   IF        *IN03 = *OFF AND
     C                             *IN05 = *OFF AND
     C                             *IN09 = *OFF
     C                   EVAL      WError = *BLANKS
     C                   EVAL      *IN33  = *OFF
     C                   EVAL      BrchAr = *ALL' '
     C                   EXSR      SRProcess
      *
     C                   IF        WError = *BLANKS
     C                   EXSR      SRFile
     C                   EXSR      SRInitSet
     C                   IF        DDCLOC > 1
     C                   EVAL      DDSFRC = DDCLOC
     C                   ELSE
     C                   EVAL      DDSFRC = 1
     C                   ENDIF
      *
     C                   IF        WMode = 'A'
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRLoadSFL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitSet - Setting up the Initial values                    *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRInitSet     BEGSR
      *
      ** Setting initial values.
      *
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
      *
     C                   IF        WMode = 'C'
      *
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN88 = *ON
      *
     C                   ELSE
      *
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      *IN88 = *OFF
      *
     C                   ENDIF
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      WError = *BLANKS
     C                   EVAL      SRRN = *ZEROS
     C                   EVAL      DDSFRC = 1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSFL - Initialise and Load Subfile Page                 *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SRSndMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSFL     BEGSR
      *
      ** Clear Subfile
      *
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000820C0
     C                   EVAL      *IN80 = *OFF
      *
     C                   EVAL      *IN84 = *OFF
      *
      ** Load Subfile If Change Mode
      *
     C                   IF        WMode = 'C'
      *
     C     *LOVAL        SETLL     SDLTOFL0
     C                   READ      SDLTOFL0
      *
     C                   IF        %EOF(SDLTOFL0)
     C                   EVAL      *IN25 = *ON
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDLTOFL0)
     C                   EVAL      SRRN = SRRN + 1
     C                   EVAL      D1ACTN = *BLANKS
     C                   EVAL      D1BRCH = LTBRCH
     C                   EVAL      D1LTNM = LTOFNM
     C                   EVAL      D1LTRG = LTOFRN
     C                   EVAL      D1BAKN = LTBAKR
     C                   WRITE     SD000820S0
     C                   READ      SDLTOFL0
     C                   ENDDO
      *
      ** If File is Empty, Send Message 'No Data to Display'
      *
     C                   IF        SRRN  = *ZEROS AND
     C                             WMode = 'C'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      ZAmsid = 'Y2U0008'
     C                   EVAL      ZAmsgf = 'Y2USRMSG'
     C                   EXSR      SRSndMsg
      *
     C                   ELSE
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to Process Screen Details             *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SRValid                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
     C                   READC     SD000820S0
     C                   DOW       NOT %EOF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN84 = *ON
      *
     C                   IF        WMode = 'A'
     C                   EXSR      SRValid
     C                   ENDIF
      *
     C                   IF        WMode = 'C'
     C                   IF        D1ACTN <> 'D'
     C                   EXSR      SRValid
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    SD000820S0
     C                   EVAL      *IN84 = *OFF
     C                   READC     SD000820S0
     C                   EVAL      DDSFRC = SRRN
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Subroutine to Vatidate Screen Details              *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRSndMsg, SRBranch                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValid       BEGSR
      *
     C                   EVAL      WErrf = *BLANKS
      *
     C                   IF        WMode = 'A'
      *
     C                   IF        D1BRCH = *BLANKS  AND
     C                             D1LTRG = *BLANKS  AND
     C                             D1LTNM = *BLANKS  AND
     C                             D1BAKN = *BLANKS
      *
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      WError = ' '
     C                   EVAL      WErrf = ' '
      *
     C                   LEAVESR
      *
     C                   ELSEIF    D1BRCH = *BLANKS  AND
     C                             (D1LTRG <> *BLANKS  OR
     C                             D1LTNM <> *BLANKS)
      *
      ** Send Error Message "Branch Code must be entered"
      *
     C                   EVAL      ZAmsid = 'USR3653'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrf = 'Y'
      *
     C                   ELSE
      *
      ** Validate Screen Branch Code
      *
     C                   EVAL      PBrch = D1BRCH
     C                   EXSR      SRBranch
      *
     C                   IF        PRtCd <> *BLANKS
      *
      ** Send Error Message "Branch Code Entered is Invalid"
      *
     C                   EVAL      ZAmsid = 'USR3651'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrf = 'Y'
      *
     C                   ELSE
      *
      ** Branch code has already been Entered.
      *
     C                   IF        %LOOKUP(D1BRCH:BrchAr) <> 0
      *
     C                   EVAL      ZAmsid = 'USR8023'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EVAL      ZAmsda = D1BRCH
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33  = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrf = 'Y'
      *
     C                   ELSE
      *
     C                   EVAL      BrchAr(Idx) = D1BRCH
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      *IN33 = *OFF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Action Code on Branch for Single/Multi-Branch
      *
     C                   IF        WMode = 'A'
      *
     C                   EVAL      PActnCd = 'I'
      *
     C                   ELSEIF    WMode = 'C' AND
     C                             D1ACTN = *BLANKS
     C                   EVAL      PActnCd = 'A'
      *
     C                   ELSEIF    WMode = 'C' AND
     C                             D1ACTN <> *BLANKS
     C                   EVAL      PActnCd = D1ACTN
      *
     C                   ENDIF
      *
     C                   IF        BJSBRC <> *BLANKS
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    PActnCd
     C                   PARM      *ZEROS        PError
      *
     C                   ELSE
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    PActnCd
     C                   PARM      D1BRCH        PBranch
     C                   PARM      *ZEROS        PError
      *
     C                   ENDIF
      *
     C                   IF        PError <> *ZEROS AND WErrf = *BLANKS
      *
      ** Send Error Message "User is not authorised to this
      ** Action Code for this Branch/Menu Item"
      *
     C                   EVAL      ZAmsid = 'USR8638'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrf = 'Y'
      *
     C                   ELSE
      *
     C                   ENDIF
      *
     C                   IF        WMode = 'A'
     C     D1BRCH        CHAIN     SDLTOFL0
      *
     C                   IF        %FOUND(SDLTOFL0)
      *
      ** Send Error Message, "Branch Local Tax Office Details
      ** already exists in File"
      *
     C                   EVAL      ZAmsid = 'USR8020'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrf = 'Y'
      *
     C                   ELSE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WErrf = *BLANKS
     C                   EVAL      *IN33 = *OFF
     C                   ENDIF
      *
      ** Validate Local Tax Office Name
      *
     C                   IF        D1LTNM = *BLANKS
      *
      ** Send Error Message, "Local Tax Office Name can not be Blanks"
      *
     C                   EVAL      ZAmsid = 'USR8021'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = 'Y'
      *
     C                   ELSE
      *
     C                   EVAL      *IN34 = *OFF
      *
     C                   ENDIF
      *
      ** Validate Local Tax Office Registration Number
      *
     C                   IF        D1LTRG = *BLANKS
      *
      ** Send Error Message,"Local Tax Office Registration Number
      ** can not be Blanks"
      *
     C                   EVAL      ZAmsid = 'USR8022'
     C                   EVAL      ZAmsgf = 'SDUSRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = 'Y'
      *
     C                   ELSE
      *
     C                   EVAL      *IN35 = *OFF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFile - Subroutine to Write/Update File                     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRFile        BEGSR
      *
     C                   EVAL      WSet = 'N'
      *
     C                   READC     SD000820S0
     C                   DOW       NOT %EOF
      *
     C                   IF        WMode = 'C' AND
     C                             D1ACTN = 'D'
     C     D1BRCH        CHAIN     SDLTOFL0
     C                   DELETE    SDLTOFL0
      *
      ** Subfile Cursor location needs to changed if last
      ** record getting deleted.
      *
     C                   IF        DDCLOC > 1
     C                   EVAL      DDCLOC = DDCLOC - 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        D1BRCH <> *BLANKS
      *
     C                   IF        WMode = 'C' AND
     C                             D1ACTN = *BLANKS
     C     D1BRCH        CHAIN     SDLTOFL0
     C                   EVAL      LTOFNM = D1LTNM
     C                   EVAL      LTOFRN = D1LTRG
     C                   EVAL      LTBAKR = D1BAKN
     C                   EVAL      LTLCD = BJRDNB                                           BUG24807
     C                   EVAL      LTCHTP = 'A'                                             BUG24807
     C                   UPDATE    SDLTOFD0
      *
     C                   ENDIF
      *
     C                   IF        WMode = 'A'
      *
     C                   EVAL      LTBRCH = D1BRCH
     C                   EVAL      LTOFNM = D1LTNM
     C                   EVAL      LTOFRN = D1LTRG
     C                   EVAL      LTBAKR = D1BAKN
     C                   EVAL      LTLCD = BJRDNB                                           BUG24807
     C                   EVAL      LTCHTP = 'I'                                             BUG24807
     C                   WRITE     SDLTOFD0
     C                   EVAL      DDCLOC = 1
     C                   EVAL      *IN85 = *OFF
      *
     C                   ENDIF
      *
     C                   EVAL      WSet = 'Y'
      *
     C                   ENDIF
      *
     C                   READC     SD000820S0
     C                   ENDDO
      *
     C                   IF        SRRN > 0 AND WSet = 'Y'
      *
     C                   EVAL      WMode = 'C'
      *
     C                   ELSE
      *
     C                   EVAL      WMode = 'A'
     C                   EVAL      WSet = 'N'
     C                   EVAL      SRRN = *ZEROS
     C                   EVAL      *IN85 = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch -  Subroutine to Access Branch Details              *
      *                                                               *
      *  Called by: SRValid                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRBranch      BEGSR
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D1BRCH        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
      *
     C                   MOVEL     A8BRCD        D1BRCH
     C                   CLEAR                   SDBRCH
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send Message to program's message Queue           *
      *                                                               *
      *  Called by: SRLoadSFL, SRValid                                *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
      *
     C                   IF        ZApgmq = *BLANKS
     C                   EVAL      ZApgmq = PSProcName
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZApgmq
     C                   PARM      *BLANKS       ZApgrl
     C                   PARM                    ZAmsid
     C                   PARM                    ZAmsgf
     C                   PARM                    ZAmsda
     C                   PARM      *BLANKS       ZAmstp
      *
     C                   EVAL      ZAmsid = *BLANKS
     C                   EVAL      ZAmsda = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMsg - Clear Message from program's message Queue        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrMsg      BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZApgmq
     C                   PARM      '*SAME'       ZApgrl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
     C                   EVAL      DBPGM = 'SD000820'
     C                   EVAL      DBMOD = PSProcMod
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Populate Screen Header Fields
      *
     C                   EVAL      DDJOB = PSJObName
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDTME = %XLATE('.' : ':'
     C                                      : %CHAR(%TIME()))
     C                   EVAL      WMode = 'C'
     C                   EVAL      DDMRDT = BJMRDT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
