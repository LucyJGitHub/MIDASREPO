     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Correspondence Manager Control Data')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  SD9595 - Correspondence Manager Control Data                 *
      *                                                               *
      *  Function:  This module will define the control information   *
      *             for the Correspondence Manager.                   *
      *                                                               *
      *  Component of: SDC9595                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 244875             Date 08Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 14Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  244875 - Display file content and update correclty System    *
      *           Name.                                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01   - Error on IP address                                   *
      *  02   - Error on FTP user name                                *
      *  03   - Error on FTP password                                 *
      *  04   - Error on Print server directory                       *
      *  05   - Error on Export file size                             *
      *  06   - Error on Export file retention period                 *
      *  07   - Error on Local directory                              *
      *  08   - Error on PC Feedback Directory                        *
      *  09   - Error on Polling Frequency for Feedback job           *
      *  13   - Error on iSeries Directory for Feedback data          *
      *  11   - End of file                                           *
      *  12   - Incorrect character found in CHECK operation          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVALD  - Validate fields                                    *
      *  SRVPSIP - Validate IP address                                *
      *  SRVFUSR - Validate FTP user name                             *
      *  SRVFPWD - Validate FTP password                              *
      *  SRVPSDI - Validate Print server directory                    *
      *  SRVEXSZ - Validate Export file size                          *
      *  SRVRETP - Validate Export file retention period              *
      *  SRVLODI - Validate Local directory                           *
      *  SRMERGE - Merge message ids                                  *
      *  SRUPDAT - Update SDCORMPD                                    *
      *  SREXTRCT- Extract message information                        *
      *  SRCRDIR - Create Local Directory                             *
      *  SRERROR - Handles error messages                             *
      *                                                               *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
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
 
     FSDCORML0  UF A E           K DISK    INFSR(*PSSR)
     FSD9595DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D BlankChar       C                   ' '
     D ZeroChar        C                   '0'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDCORM        E DS                  EXTNAME(SDCORMPD)
     D XXCORM          DS          9999
     D YYCORM          DS          9999
     D ArrMsgIds       S              7    DIM(25)
     D PMsgIdArr       S              7    DIM(25)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PMidasSBS       S              2
     D PDirectory      S             75
     D PUser           S             20
     D PPassword       S             20
     D PRtnCode        S              7
     D POption         S              7
     D PMsgID          S              7
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D PMsgData        S            244
     D PText1          S            132
     D PText2          S            512
     D PRtnCode1       S             10
     D PDirName        S             75
     D PAlignOK        S              1
     D PCheck          S             16
     D PNoDec          S              1  0
     D PNoDig          S              2  0
     D ##MSBS          S              3                                                       244875
     D ##MFDD          S             12                                                       244875
 
     D WRun            S              1
     D WValid          S              1
     D WWrite          S              1
     D WChar1          S              1
     D WChar2          S              2
     D WChar3          S              3
     D WChar4          S              4
     D WChar5          S              5
     D WFTPStat        S              7    INZ(*BLANKS)
     D WPGNStat        S              7    INZ(*BLANKS)
     D WCtr            S              2S 0
     D WStart          S              1S 0
     D WLen            S              2S 0
     D WNumEXSZ        S              5S 0
     D WNumRETP        S              3S 0
     D WNumPFRQ        S              5S 0
     D Idx             S              2S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:             ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Access Correspondence Manager ICD File
 
     C                   READ      SDCORMD0                               11
 
      ** If no record found, ICD will be set-up for the first time.
      ** So, need to write a record instead of update.
 
     C                   IF        *IN11 = '1'
     C                   EVAL      WWrite = 'Y'
 
     C                   ELSE
 
      ** If record is read, unlock the record.
 
     C                   UNLOCK    SDCORML0                             90
 
      ** If error in unlocking the record, generate program dump.
 
     C                   IF        *IN90 = *ON
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDCORMPD'
     C                   EVAL      DBKEY = '*UNLOCK'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Keep a copy of the original ICD details.
 
     C                   EVAL      XXCORM = SDCORM
 
      ** Prepare ICD details for screen display.
 
     C                   EVAL      WWrite = 'N'
     C                   EVAL      #1PSIP = CMPSIP
     C                   EVAL      #1FUSR = CMFUSR
     C                   EVAL      #1FPWD = CMFPWD
     C                   EVAL      #1PSDI = CMPSDI
     C                   EVAL      #1FBDI = CMFBDI
     C                   EVAL      #1EXSZ = CMEXSZ
     C                   EVAL      #1RETP = CMRETP
     C                   EVAL      #1PFRQ = CMPFRQ
 
     C**********         EVAL      #1MSBS = '/' + PMidasSBS                                   244875
 
     C     BlankChar     CHECKR    CMLODI        WLen
      ** Length = 3 as '/XX' => only the root '/'  has been entered
      ** (XX is the Midas Subsystem)
     C                   IF        WLen = 3
     C                   EVAL      #1LODI = '/'
     C                   ELSE
     C                   EVAL      #1LODI = %SUBST(CMLODI:1:WLen-3)
     C                   ENDIF
     C                   EVAL      #1MSBS = %SUBST(CMLODI:WLen-2:3)                           244875
 
     C**********         EVAL      #1MFDD = '/' + PMidasSBS + '/FEEDBACK'                     244875
 
     C     BlankChar     CHECKR    CMLDFD        WLen
      ** Length = 12 as '/XX/FEEDBACK' => only the root '/'  has been
      ** (XX is the Midas Subsystem)
     C                   IF        WLen = 12
     C                   EVAL      #1LDFD = '/'
     C                   ELSE
     C                   EVAL      #1LDFD = %SUBST(CMLDFD:1:WLen-12)
     C                   ENDIF
     C                   EVAL      #1MFDD = %SUBST(CMLDFD:WLen-11:12)                       244875
 
     C                   ENDIF
 
      ** Display screen
 
     C                   DOW       *INKC = '0' AND WValid = 'N'
 
      ** If FTP job is running, protect fields to disable file update.
 
     C                   EXSR      SRCHKPGN
     C                   IF        WPGNStat = '*BUSY  '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2613'
     C                   EXSR      SRERROR
      ** Protect fields
     C                   MOVE      *ON           *IN93
     C                   ENDIF
 
      ** If FTP job is running, protect fields to disable file update.
 
     C                   EXSR      SRCHKFTP
     C                   IF        WFTPStat = '*BUSY  '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2591'
     C                   EXSR      SRERROR
      ** Protect fields
     C                   MOVE      *ON           *IN93
     C                   ENDIF
 
     C                   WRITE     SD9595F0
     C                   WRITE     SD9595F2
     C                   WRITE     SD9595C0
     C                   EXFMT     SD9595F1
 
     C                   CALL      'ZA0250'
     C                   EVAL      Idx = 0
     C                   RESET                   ArrMsgIds
     C                   MOVEA     '0000000000'  *IN(01)
     C                   MOVEA     '0'           *IN(13)
 
      ** If Enter is pressed, validate fields only if FTP job is
      ** is not currently running.
 
     C                   IF        (*INKC = *OFF) AND (WFTPStat = *BLANKS)
     C                             AND (WPGNStat = *BLANKS)
     C                   EXSR      SRVALD
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate fields                                     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRVPSIP, SRVFUSR, SRVFPWD, SRVPSDI, SRVEXSZ       *
      *             SRVRETP, SRVLODI, SRERROR, SRUPDAT, SRCRDIR       *
      *             SRVFBDI, SRVPFRQ, SRVLDFD                         *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
      ** Validate fields
 
      * IP Address
     C                   EXSR      SRVPSIP
 
      * FTP User
     C                   EXSR      SRVFUSR
 
      * FTP Password
     C                   EXSR      SRVFPWD
 
      * PC Download Directory
     C                   EXSR      SRVPSDI
 
      * PC Feedback Directory
     C                   EXSR      SRVFBDI
 
      * Export File Size
     C                   EXSR      SRVEXSZ
 
      * Export File Retention Period
     C                   EXSR      SRVRETP
 
      * Polling Freq. for Feedback Period
     C                   EXSR      SRVPFRQ
 
      * ISeries Directory for XML Output
     C                   EXSR      SRVLODI
 
      * ISeries Directory for Feedback Data
     C                   EXSR      SRVLDFD
 
      ** Retrieve message ids if error occurs.
 
     C                   IF        ArrMsgIds(1) <> *BLANKS
     C                   EXSR      SRERROR
 
      ** No errors. Update file and set up ICD.
 
     C                   ELSE
     C                   EVAL      WValid = 'Y'
 
      ** Read the ICD record for the 2nd time, this time to lock it
      ** for update.
 
     C     *LOVAL        SETLL     SDCORMD0
     C                   READ      SDCORMD0                             11
 
     C                   IF        WWRITE = 'N'
 
      ** If record has been deleted for some reason, send error message.
 
     C                   IF        *IN11 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2589'
     C                   EXSR      SRERROR
     C                   ENDIF
 
      ** If record successfully read, compare current details with the
      ** saved version. Do not allow update if details has changed since
      ** (i.e. from another workstation).
 
     C                   IF        *IN11 = *OFF
     C                   EVAL      YYCORM = SDCORM
 
     C                   IF        YYCORM <> XXCORM
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2590'
     C                   EXSR      SRERROR
 
     C                   ELSE
 
      ** Check Print Generator job is not submitted before update.
 
     C                   EXSR      SRCHKPGN
 
      ** Print Generator Job is now active. Suppress update and
      ** and send error message.
 
     C                   IF        WPGNStat = '*BUSY  '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2614'
     C                   EXSR      SRERROR
     C                   ENDIF
 
      ** Check FTP job is running before update (as it is possible that
      ** CGFTP is activated while CM ICD is being maintained).
 
     C                   EXSR      SRCHKFTP
 
      ** FTP Job is now active. Suppress update and send error message.
 
     C                   IF        WFTPStat = '*BUSY  '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2592'
     C                   EXSR      SRERROR
     C                   ENDIF
 
      ** FTP Job is still not active and Print Generator job are
      ** still not active. Allow update of ICD details.
 
     C                   IF        WFTPStat = *BLANKS
     C                             AND WPGNStat = *BLANKS
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** If in WRITE mode...
 
     C                   IF        WWRITE = 'Y'
 
      ** Check if a record (from 2nd read) is found (this means another
      ** user has already written a data in the file. If so, then send
      ** error message.
 
     C                   IF        (*IN11 = *OFF) AND SDCORM <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2593'
     C                   EXSR      SRERROR
 
      ** File is still empty so carry on writing data in file.
 
     C                   ELSE
     C                   EXSR      SRUPDAT
     C                   ENDIF
     C                   ENDIF
 
      ** Create Local Directory
 
     C                   EXSR      SRCRDIR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPSIP - Validate Print Server IP Address                   *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRVPSIP       BEGSR
 
      ** IP address must not be blanks
 
     C                   IF        #1PSIP = *BLANKS
     C                   EVAL      *IN01 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2586'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFUSR - Validate FTP user                                  *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3600, SRMERGE                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVFUSR       BEGSR
 
      ** Validate FTP user via module CG3600
 
     C                   CALLB     'CG3600'
     C                   PARM      #1FUSR        PUser
     C                   PARM      *BLANKS       PPassword
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3600 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN02 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFPWD - Validate FTP password                              *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3601, SRMERGE                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVFPWD       BEGSR
 
      ** Validate FTP password via module CG3601
 
     C                   CALLB     'CG3601'
     C                   PARM      #1FUSR        PUser
     C                   PARM      #1FPWD        PPassword
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3601 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN03 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPSDI - Validate Print Server Directory                    *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3609, SRMERGE                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVPSDI       BEGSR
 
      ** Print server directory must not be blanks
 
     C                   IF        #1PSDI = *BLANKS
     C                   EVAL      *IN04 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2568'
 
     C                   ELSE
     C                   SELECT
 
      ** Validate print server directory as UNIX type via CG3608
     C                   WHEN      %SCAN('/':#1PSDI) <> 0
     C                   CALLB     'CG3608'
     C                   PARM      #1PSDI        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3608 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN04 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
      ** Validate print server directory as WINDOWS type via CG3609
     C                   WHEN      %SCAN('\':#1PSDI) <> 0
     C                   CALLB     'CG3609'
     C                   PARM      #1PSDI        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3609 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN04 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   OTHER
      ** Only UNIX type or WINDOWS type paths can be entered
     C                   EVAL      *IN04 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2610'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFBDI - Validate PC Feedback Directory                     *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3608, CG3609, SRMERGE                           *
      *                                                               *
      *****************************************************************
 
     C     SRVFBDI       BEGSR
 
      ** PC Feedback directory must not be blanks
 
     C                   IF        #1FBDI = *BLANKS
     C                   EVAL      *IN08 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2616'
 
     C                   ELSE
     C                   SELECT
 
      ** Validate PC Feedback directory as UNIX type via CG3608
     C                   WHEN      %SCAN('/':#1FBDI) <> 0
     C                   CALLB     'CG3608'
     C                   PARM      #1FBDI        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3608 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN08 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
      ** Validate PC Feedback Directory as WINDOWS type via CG3609
     C                   WHEN      %SCAN('\':#1FBDI) <> 0
     C                   CALLB     'CG3609'
     C                   PARM      #1FBDI        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message IDs generated
      ** by CG3609 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN08 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   OTHER
      ** Only UNIX type or WINDOWS type paths can be entered
     C                   EVAL      *IN08 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2610'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEXSZ - Validate Export File Size                          *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRVEXSZ       BEGSR
 
     C                   EVAL      WNumEXSZ = 0
 
      ** If Export File Size is blank, default to 99999.
 
     C                   IF        #1EXSZ = *BLANKS
     C                   EVAL      #1EXSZ = '99999'
     C                   EVAL      WNumEXSZ = 99999
 
      ** File size must be numeric.
 
     C                   ELSE
     C                   EVAL      PCheck = #1EXSZ
     C                   EVAL      PNoDec = 0
     C                   EVAL      PNoDig = 5
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PAlignOK
     C                   PARM                    PCheck
     C                   PARM                    PNoDec
     C                   PARM                    PNoDig
 
     C                   IF        PAlignOK = 'N'
     C                   EVAL      *IN05 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2587'
 
      ** File size must be greater than zero.
 
     C                   ELSE
     C                   MOVE      PCheck        WNumEXSZ
 
     C                   IF        WNumEXSZ = 0
     C                   EVAL      #1EXSZ = '    0'
     C                   EVAL      *IN05 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2565'
 
      ** File size is valid; suppress leading zeroes.
 
     C                   ELSE
     C                   MOVE      WNumEXSZ      #1EXSZ
     C     ZeroChar      CHECK     #1EXSZ        WStart
 
     C                   SELECT
     C                   WHEN      WStart = 5
     C                   MOVE      #1EXSZ        WCHar1
     C                   MOVE (P)  WChar1        #1EXSZ
 
     C                   WHEN      WStart = 4
     C                   MOVE      #1EXSZ        WChar2
     C                   MOVE (P)  WChar2        #1EXSZ
 
     C                   WHEN      WStart = 3
     C                   MOVE      #1EXSZ        WChar3
     C                   MOVE (P)  WChar3        #1EXSZ
 
     C                   WHEN      WStart = 2
     C                   MOVE      #1EXSZ        WChar4
     C                   MOVE (P)  WChar4        #1EXSZ
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRETP - Validate Export File Retention Period              *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRVRETP       BEGSR
 
     C                   EVAL      WNumRETP = 0
 
      ** If Retention period is blank, default to 30.
 
     C                   IF        #1RETP = *BLANKS
     C                   EVAL      #1RETP = ' 30'
     C                   EVAL      WNumRETP = 30
 
      ** Retention period must be numeric.
 
     C                   ELSE
     C                   EVAL      PCheck = #1RETP
     C                   EVAL      PNoDec = 0
     C                   EVAL      PNoDig = 3
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PAlignOK
     C                   PARM                    PCheck
     C                   PARM                    PNoDec
     C                   PARM                    PNoDig
 
     C                   IF        PAlignOK = 'N'
     C                   EVAL      *IN06 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2566'
 
      ** Retention period must be greater than zero.
 
     C                   ELSE
     C                   MOVE      PCheck        WNumRETP
 
     C                   IF        WNumRETP = 0
     C                   EVAL      #1RETP = '  0'
     C                   EVAL      *IN06 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2567'
 
      ** Retention period is valid. Suppress any leading zeroes.
 
     C                   ELSE
     C                   MOVE      WNumRETP      #1RETP
     C     ZeroChar      CHECK     #1RETP        WStart
 
     C                   SELECT
     C                   WHEN      WStart = 3
     C                   MOVE      #1RETP        WChar1
     C                   MOVE (P)  WChar1        #1RETP
 
     C                   WHEN      WStart = 2
     C                   MOVE      #1RETP        WChar2
     C                   MOVE (P)  WChar2        #1RETP
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPFRQ - Validate Polling Frequency for Feedback Job        *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRVPFRQ       BEGSR
 
     C                   EVAL      WNumPFRQ = 0
 
      ** If Polling Frequency is blank, default to 60 seconds.
 
     C                   IF        #1PFRQ = *BLANKS
     C                   EVAL      #1PFRQ = '   60'
     C                   EVAL      WNumPFRQ = 60
 
      ** Polling Frequency must be numeric.
 
     C                   ELSE
     C                   EVAL      PCheck = #1PFRQ
     C                   EVAL      PNoDec = 0
     C                   EVAL      PNoDig = 3
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PAlignOK
     C                   PARM                    PCheck
     C                   PARM                    PNoDec
     C                   PARM                    PNoDig
 
     C                   IF        PAlignOK = 'N'
     C                   EVAL      *IN09 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2617'
 
      ** Polling Frequency must be greater than zero.
 
     C                   ELSE
     C                   MOVE      PCheck        WNumPFRQ
 
     C                   IF        WNumPFRQ = 0
     C                   EVAL      #1PFRQ = '    0'
     C                   EVAL      *IN09 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2618'
 
      ** Polling Frequency is valid. Suppress any leading zeroes.
 
     C                   ELSE
     C                   MOVE      WNumPFRQ      #1PFRQ
     C     ZeroChar      CHECK     #1PFRQ        WStart
 
     C                   SELECT
 
     C                   WHEN      WStart = 5
     C                   MOVE      #1PFRQ        WChar1
     C                   MOVE (P)  WChar1        #1PFRQ
 
     C                   WHEN      WStart = 4
     C                   MOVE      #1PFRQ        WChar2
     C                   MOVE (P)  WChar2        #1PFRQ
 
     C                   WHEN      WStart = 3
     C                   MOVE      #1PFRQ        WChar3
     C                   MOVE (P)  WChar3        #1PFRQ
 
     C                   WHEN      WStart = 2
     C                   MOVE      #1PFRQ        WChar4
     C                   MOVE (P)  WChar4        #1PFRQ
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLODI - Validate Local Directory                           *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3608, SRMERGE                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVLODI       BEGSR
 
      ** Local directory must not be blanks
 
     C                   IF        #1LODI = *BLANKS
     C                   EVAL      *IN07 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2569'
 
     C                   ELSE
 
      ** Validate local directory via CG3608
 
     C                   CALLB     'CG3608'
     C                   PARM      #1LODI        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3608 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN07 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLDFD - Validate iSeries Directory for Feedback Data       *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3608, SRMERGE                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVLDFD       BEGSR
 
      ** iSeries Feedback Directory must not be blanks.
 
     C                   IF        #1LDFD = *BLANKS
     C                   EVAL      *IN13 = '1'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = 'CGD2619'
 
     C                   ELSE
 
      ** Validate iSeries Feedback Directory via CG3608
 
     C                   CALLB     'CG3608'
     C                   PARM      #1LDFD        PDirectory
     C                   PARM      *BLANKS       PMsgIdArr
     C                   PARM      *BLANKS       PRtnCode
 
      ** If there are errors, add message ids generated
      ** by CG3608 to main array ArrMsgIds.
 
     C                   IF        PRtnCode = '*ERROR '
     C                   EVAL      *IN13 = '1'
     C                   EXSR      SRMERGE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMERGE - Merge error message ids generated by called program*
      *            with main array ArrMsgIds.                         *
      *                                                               *
      *  Called by: SRVFUSR, SRVFPWD, SRVPSDI, SRVLODI                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMERGE       BEGSR
 
     C                   EVAL      WCtr = 1
 
     C                   DOW       PMsgIdArr(WCtr) <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ArrMsgIds(Idx) = PMsgIdArr(WCtr)
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKFTP - Calls CGC3603 to check if FTP job is running.     *
      *             NOTE: This is important where the FTP job was     *
      *             ----  initiated while CM ICD screen is being      *
      *                   maintained by a user.                       *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CLP/CGC3603                                       *
      *                                                               *
      *****************************************************************
 
     C     SRCHKFTP      BEGSR
 
     C                   CALL      'CGC3603'
     C                   PARM                    WFTPStat
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRCHKPGN - Calls CG3614 to check if Print Generator job is   *
      *             running.                                          *
      *             NOTE: This is important where the Print Generator *
      *             ----  job initiated while CM ICD screen is being  *
      *                   maintained by a user.                       *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : RPG/CG3614                                        *
      *                                                               *
      *****************************************************************
 
     C     SRCHKPGN      BEGSR
 
     C                   CALLB     'CG3614'
     C                   PARM                    WPGNStat
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDAT - Updates SDCORMPD                                   *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : SREXTRCT                                          *
      *                                                               *
      *****************************************************************
 
     C     SRUPDAT       BEGSR
 
      ** Set values of file fields.
 
     C                   EVAL      CMPSIP = #1PSIP
     C                   EVAL      CMFUSR = #1FUSR
     C                   EVAL      CMFPWD = #1FPWD
     C                   EVAL      CMPSDI = #1PSDI
     C                   EVAL      CMFBDI = #1FBDI
     C                   EVAL      CMEXSZ = #1EXSZ
     C                   EVAL      CMRETP = #1RETP
     C                   EVAL      CMPFRQ = #1PFRQ
 
      ** If only root '/' is entered as iSeries XML Directory, do not
      ** concatenate with /Midas System prefix.
     C                   IF        #1LODI = '/'
     C                   EVAL      CMLODI = #1MSBS
     C                   ELSE
     C*****#1LODI        CAT (P)   #1MSBS:0      CMLODI                                       244875
     C     #1LODI        CAT (P)   ##MSBS:0      CMLODI                                       244875
     C                   ENDIF
 
      ** If only root '/' is entered as iSeries Feedback Directory,
      ** do not concatenate with /Midas System prefix + '/FEEDBACK'.
     C                   IF        #1LDFD = '/'
     C                   EVAL      CMLDFD = #1MFDD
     C                   ELSE
     C*****#1LDFD        CAT (P)   #1MFDD:0      CMLDFD                                       244875
     C     #1LDFD        CAT (P)   ##MFDD:0      CMLDFD                                       244875
     C                   ENDIF
 
      ** Update 'Element Name For Common Field' with 'OutputInformation'.
 
     C                   IF        CMELCF = *BLANKS
     C                   EVAL      PMsgID = 'CGD2578'
     C                   EXSR      SREXTRCT
     C                   EVAL      CMELCF = PText1
     C                   ENDIF
 
      ** Update 'Head of the Schema'.
 
     C                   IF        CMHDSC = *BLANKS
     C                   EVAL      PMsgID = 'CGD2588'
     C                   EXSR      SREXTRCT
     C                   EVAL      CMHDSC = PText1
     C                   ENDIF
 
      ** Update 'Style 1'.
 
     C                   IF        CMSTY1 = *BLANKS
     C                   EVAL      PMsgID = 'CGD2577'
     C                   EXSR      SREXTRCT
     C                   EVAL      CMSTY1 = PText1
     C                   ENDIF
 
      ** Code page used for stream file
 
     C                   IF        CMCPAG = *BLANKS
     C                   EVAL      PMsgID = 'CGD2611'
     C                   EXSR      SREXTRCT
     C                   EVAL      CMCPAG = PText1
     C                   ENDIF
 
      ** Update Maximum Print Wait Time for an Item
 
     C                   IF        CMPRTW = *BLANKS
     C                   EVAL      PMsgID = 'CGD2620'
     C                   EXSR      SREXTRCT
     C                   EVAL      CMPRTW = PText1
     C                   ENDIF
 
      ** UPDATE or WRITE record depending on value of indicator
 
     C                   IF        WWrite = 'N'
     C                   UPDATE    SDCORMD0
     C                   ELSE
     C                   WRITE     SDCORMD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREXTRCT - Extract message information                       *
      *                                                               *
      *  Called by: SRUPDAT                                           *
      *                                                               *
      *  Calls    : CGC0100                                           *
      *                                                               *
      *****************************************************************
 
     C     SREXTRCT      BEGSR
 
      ** Extract message information via CLP CGC0100.
 
     C                   CALL      'CGC0100'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgData
     C                   PARM      *BLANKS       PText1
     C                   PARM      *BLANKS       PText2
     C                   PARM      *BLANKS       PRtnCode
 
      ** Database error if message id does not exist.
 
     C                   IF        PRtnCode = '*NRF   '
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = PMsgFile
     C                   EVAL      DBKEY = PMsgID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCRDIR - Create local directory                             *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : CG3631                                            *
      *                                                               *
      *****************************************************************
 
     C     SRCRDIR       BEGSR
 
      ** Create iSeries Directory for XML Data
 
     C                   CALLB(E)  'CG3631'
     C                   PARM      *BLANKS       PRtnCode1
     C                   PARM      CMLODI        PDirName
 
      ** Database error if directory not created.
 
     C                   IF        PRtnCode1 = '*BLANKDIR ' OR
     C                             PRtnCode1 = '*SDCORERR ' OR
     C                             %ERROR
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'CG3631'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Create iSeries Directory for Feedback Data, if XML Data
      ** directory is successfully created.
 
     C                   CALLB(E)  'CG3631'
     C                   PARM      *BLANKS       PRtnCode1
     C                   PARM      CMLDFD        PDirName
 
      ** Database error if directory not created.
 
     C                   IF        PRtnCode1 = '*BLANKDIR ' OR
     C                             PRtnCode1 = '*SDCORERR ' OR
     C                             %ERROR
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'CG3631'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERROR - Handles error messages                             *
      *                                                               *
      *  Called by: SRVALD                                            *
      *                                                               *
      *  Calls    : AOCREPT                                           *
      *                                                               *
      *****************************************************************
 
     C     SRERROR       BEGSR
 
     C                   EVAL      WValid = 'N'
     C                   EVAL      WCtr = 1
 
     C                   DOW       ArrMsgIds(WCtr) <> *BLANKS
     C                   EVAL      PMsgID = ArrMsgIds(WCtr)
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0                                          *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtnCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0PGM = PSProcName
 
     C                   MOVEA     '0000000'     *IN(01)
     C                   EVAL      WValid = 'N'
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
     C     *LOCK         IN        SDSTAT
     C                   EVAL      PMidasSBS = LIBR
     C                   OUT       SDSTAT
 
     C                   EVAL      #1PSIP = *BLANKS
     C                   EVAL      #1FUSR = *BLANKS
     C                   EVAL      #1FPWD = *BLANKS
     C                   EVAL      #1PSDI = *BLANKS
     C                   EVAL      #1FBDI = *BLANKS
     C                   EVAL      #1EXSZ = *BLANKS
     C                   EVAL      #1RETP = *BLANKS
     C                   EVAL      #1PFRQ = *BLANKS
     C                   EVAL      #1LODI = *BLANKS
     C**********         EVAL      #1MSBS = '/' + PMidasSBS                                   244875
     C                   EVAL      ##MSBS = '/' + PMidasSBS                                   244875
     C                   EVAL      #1LDFD = *BLANKS
     C**********         EVAL      #1MFDD = '/' + PMidasSBS + '/FEEDBACK'                     244875
     C                   EVAL      ##MFDD = '/' + PMidasSBS + '/FEEDBACK'                     244875
 
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
      *  Calls    : DBERRCTL                                          *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
