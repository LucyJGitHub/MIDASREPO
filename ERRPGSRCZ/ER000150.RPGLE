     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas @24 KWG data extraction Report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000150 - Midas @24 KWG  data extraction Report             *
      *                                                               *
      *  Function : This program prints a list of the accounts that   *
      *             have been reported within a specific transmission *
      *             file.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER068             Date 25Feb14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24101           Date 27May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER068 - Upgrade CER047 to be compatible with BaFin 3.2.2    *
      *             (Recompile)                                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24101 - KWG Extract does not capture non-account holders  *
      *             (Recompile)                                       *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    31         (WPrtDetHdr)First cycle indicator - Print       *
      *               detailed header                                 *
      *    32         (WAccClosed)  Account closed - Print closure    *
      *               date                                            *
      *    33         (WPrtAddress) Type of person - Print date of    *
      *               birth or address                                *
      *    34         (WAccNotSubj) Account not subject to @24c       *
      *               anymore                                         *
      *                                                               *
      *    60         EOF of ERTINFL0                                 *
      *    61         EOF of ERACEXL2                                 *
      *    62         EOF of ERACEPL0                                 *
      *                                                               *
      *    71         (WNewPageHdr) Print File Overflow               *
      *                                                               *
      *    U7+U8      Database error occurs                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRDetail1 - Select accounts reported in file                 *
      *  SRDetail2 - Select authority holders for account             *
      *  SRWrite - Write record in printer file                       *
      *  *PSSR - Program exception error routine                      *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** ERTINFL0 - Midas @24 KWG file info by file number
      *
     FERTINFL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** ERACEXL2 - Midas @24 KWG account record by account number
      *
     FERACEXL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ** ERACEPL0 - Midas @24 KWG account record persons by account
      *
     FERACEPL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** ER000150P1 - Midas @24 KWG data extraction Report
      *
     FER000150P1O    E             PRINTER OFLIND(*IN71)
     F                                     INFDS(SPOOL1)
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
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database +
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D WVal01          C                   'TransFileFolder'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D                                     DTAARA(RUNDAT)
      *
      ** File Information Data Structure for ER000150P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Definition of indicators
      *
     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(IndicatorPtr)
      *
      ** 31 = Print detailed header
      *
     D  WPrtDetHdr            31     31
      *
      ** 32 = Print account closure date
      *
     D  WAccClosed            32     32
      *
      ** 33 = Print address instead of date of birth
      *
     D  WPrtAddress           33     33
      *
      ** 34 = Account not subject to @24c anymore
      *
     D  WAccNotSubj           34     34
      *
      ** 71 = New page
      *
     D  WNewPageHdr           71     71
      *
      ** Working DS to setup PParm
      *
     D PParm           DS           100
      *
      ** Select by File Number
      *
     D  WFromFNR               1      8  0
     D  WToFNR                 9     16  0
      *
      ** Select by date
      *
     D  WFromDate             17     24
     D  WToDate               25     32
      *
      ** Working DS for date conversion
      *
     D DSYMD           DS
     D  WYear1                 1      4  0
     D  WMth1                  5      6  0
     D  WDay1                  7      8  0
      *
     D DSDMY           DS
     D  WDay2                  1      2  0
     D  WMth2                  3      4  0
     D  WYear2                 5      8  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Parameters for the call of 'AOSVALR0'
      *
     D PRtCd           S              7A
     D POp01           S             20A
     D POp02           S             20A
     D POp03           S             20A
     D POp04           S             20A
     D POp05           S             20A
     D POp06           S             20A
     D POp07           S             20A
     D POp08           S             20A
     D POp09           S             20A
     D POp10           S             20A
      *
     D PVl01           S            200A
     D PVl02           S            200A
     D PVl03           S            200A
     D PVl04           S            200A
     D PVl05           S            200A
     D PVl06           S            200A
     D PVl07           S            200A
     D PVl08           S            200A
     D PVl09           S            200A
     D PVl10           S            200A
      *
     D POptn           S              7A
     D PRSeq           S              5A
     D PRLev           S              1A
     D PREnt           S              3A
     D PRAct           S              1A
     D PRCmd           S              1A
     D PSEnty          S              3A
     D PFile           S             10A
     D PSNum           S              6  0
     D PSErr           S              1A
     D WSeparLin       S               N
      *
      ** Print End of Report
      *
     D WEndOfRep       S               N
     D WRun            S              1A
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
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read file information file
      *
     C                   DOU       *IN60
     C                   READ      ERTINFD0                               60
     C                   IF        NOT(*IN60)
      *
      ** Record is in range?
      *
     C                   IF        (WFromFNR <> 0 OR
     C                              WToFNR <> 0) AND
     C                             (F10FNR < WFromFNR OR
     C                              F10FNR > WToFNR) OR
     C                             (WFromDate <> ' ' OR
     C                              WToDate <> ' ') AND
     C                             (F10DAT < WFromDate OR
     C                              F10DAT > WToDate)
     C                   ITER
     C                   ENDIF
      *
      ** Setup indicators for printing header of the report
      *
     C                   EVAL      WNewPageHdr = *ON
     C                   EVAL      WPrtDetHdr  = *ON
      *
      ** Setup detailed header information
      *
     C                   EVAL      R10FNR = F10FNR
     C                   EVAL      R10UTP = F10UTP
     C                   EVAL      R10PTH = %TRIM(%SUBST(PVL01:1:60)) +
     C                                      %TRIM(F10FNM)
     C                   EVAL      R10DAT = %SUBST(F10DAT:7:2) + '/' +
     C                                      %SUBST(F10DAT:5:2) + '/' +
     C                                      %SUBST(F10DAT:1:4)
     C                   EVAL      R10TIM = %SUBST(F10TIM:1:2) + ':' +
     C                                      %SUBST(F10TIM:3:2) + ':' +
     C                                      %SUBST(F10TIM:5:2)
     C                   EVAL      R10NRC = F10NRC
     C                   EVAL      R10SIZ = F10SIZ/1024
      *
      ** Read accounts report in file
      *
     C                   EXSR      SRDetail1
      *
      ** Print End of Report
      *
     C                   EVAL      WEndOfRep = *ON
     C                   EXSR      SRWrite
      *
      ** Read next file information
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail1 - Select accounts reported in file                 *
      *                                                               *
      *  Called By : MAIN Processing                                  *
      *                                                               *
      *  Calls : SRDetail2, SRWrite                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRDetail1     BEGSR
      *
      ** Read account record
      *
     C     F10FNR        SETLL     ERACEXL2
     C                   DOU       *IN61
     C     F10FNR        READE     ERACEXD0                               61
     C                   IF        NOT(*IN61)
      *
      ** Setup indicator for printing a Separator line
      *
     C                   EVAL      WSeparLin = *ON
      *
      ** Setup account information
      *
     C                   EVAL      R12DTP = F12DTP
     C                   EVAL      R12ACC = F12ACC
     C                   EVAL      R12CCY = F12CCY
     C                   EVAL      R12REF = F12REF
      *
     C                   MOVE      F12CDT        DSYMD
      *
     C                   Z-ADD     WYear1        WYear2
     C                   Z-ADD     WMth1         WMth2
     C                   Z-ADD     WDay1         WDay2
      *
     C                   MOVE      DSDMY         R12CDT
     C                   MOVE      F12VDT        DSYMD
      *
     C                   Z-ADD     WYear1        WYear2
     C                   Z-ADD     WMth1         WMth2
     C                   Z-ADD     WDay1         WDay2
      *
     C                   MOVE      DSDMY         R12VDT
     C                   MOVE      F12DDT        DSYMD
      *
     C                   Z-ADD     WYear1        WYear2
     C                   Z-ADD     WMth1         WMth2
     C                   Z-ADD     WDay1         WDay2
      *
     C                   MOVE      DSDMY         R12DDT
      *
      ** Set indicator for 'no suject', if appropriate
      *
     C                   IF        F12RCD = 'A'
     C                   EVAL      WAccNotSubj = *ON
     C                   ELSE
     C                   EVAL      WAccNotSubj = *OFF
     C                   ENDIF
      *
      ** Read authority holders if account not closed
      *
     C                   IF        R12DDT = 0
     C                   EVAL      WAccClosed = *OFF
     C                   EXSR      SrDetail2
      *
      ** Print account record if closed
      *
     C                   ELSE
     C                   EVAL      WAccClosed = *ON
     C                   EXSR      SrWrite
     C                   ENDIF
      *
      ** Read next account record
      *
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail2 - Select authority holders for account             *
      *                                                               *
      *  Called By : SRDetail1                                        *
      *                                                               *
      *  Calls : SRWrite                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDetail2     BEGSR
      *
      ** Read account person record
      *
     C     KV1310        SETLL     ERACEPL0
     C                   DOU       *IN62
     C     KV1310        READE     ERACEPD0                               62
     C                   IF        NOT(*IN62)
      *
      ** Setup account person information
      *
     C                   EVAL      R13PTP = F13PTP
     C                   EVAL      R13CUS = F13CUS
     C                   EVAL      R13NAM = F13SNM
      *
     C                   IF        F13FNM <> ' '
     C                   EVAL      R13NAM = %TRIM(R13NAM) + ', ' + F13FNM
     C                   ENDIF
      *
     C                   MOVE      F13BDT        DSYMD
      *
     C                   Z-ADD     WYear1        WYear2
     C                   Z-ADD     WMth1         WMth2
     C                   Z-ADD     WDay1         WDay2
      *
     C                   MOVE      DSDMY         R13BDT
      *
     C                   EVAL      R13STR = F13STR
     C                   EVAL      R13ZIP = F13ZIP
     C                   EVAL      R13TWN = F13TWN
     C                   EVAL      R13CTY = F13CTY
      *
      ** Set indicator for writing address
      *
     C                   IF        R13PTP = 'W'
     C                   EVAL      WPrtAddress = *ON
     C                   ELSE
     C                   EVAL      WPrtAddress = *OFF
     C                   ENDIF
      *
      ** Print account person record
      *
     C                   EXSR      SRWrite
      *
      ** Read next account person record
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record in printer file                       *
      *                                                               *
      *  Called By : MAIN Processing, SRDetail1, SRDetail2            *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
      ** Write header
      *
     C                   IF        WNewPageHdr = *ON
     C                   WRITE     ER000150R0
     C                   ENDIF
      *
      ** Print separator line
      *
     C                   IF        WSeparLin = *ON AND
     C                             WNewPageHdr = *OFF
     C                   WRITE     ER000150R1
     C                   ENDIF
      *
      ** Reset indicator for writing a Header
      *
     C                   EVAL      WNewPageHdr = *OFF
     C                   EVAL      WPrtDetHdr  = *OFF
      *
      ** Print End of Report
      *
     C                   IF        WEndOfRep = *ON
     C                   WRITE     ER000150R4
      *
      ** Print Detail
      *
     C                   ELSE
      *
     C                   IF        WSeparLin = *ON
     C                   WRITE     ER000150R2
     C                   ENDIF
      *
     C                   IF        WAccClosed = *OFF
     C                   WRITE     ER000150R3
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Reset indicator for writing a Separator line
      *
     C                   EVAL      WSeparLin = WNewPageHdr
      *
      ** Reset indicator for writing a End of Report
      *
     C                   EVAL      WEndOfRep = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : *PSSR                                                *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** *Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRSeq
     C                   PARM                    PRLev
     C                   PARM                    PREnt
     C                   PARM                    PParm
     C                   PARM                    PRact
     C                   PARM                    PRCmd
      *
      ** Retrieve information from RUNDAT data area
      *
     C                   IN        RUNDAT
      *
      ** Retrieve information from AOSVALR0
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      WVal01        POp01
     C                   PARM                    PVl01
     C                   PARM      *BLANKS       POp02
     C                   PARM                    PVl02
     C                   PARM      *BLANKS       POp03
     C                   PARM                    PVl03
     C                   PARM      *BLANKS       POp04
     C                   PARM                    PVl04
     C                   PARM      *BLANKS       POp05
     C                   PARM                    PVl05
     C                   PARM      *BLANKS       POp06
     C                   PARM                    PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM                    PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM                    PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM                    PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM                    PVl10
      *
     C                   IF        PRtCd  <> *BLANKS
      *
     C                   IF        PVl01 = '*NRF   '
     C                   EVAL      DBKEY = POp01
     C                   ENDIF
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000150'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get info from the SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY =POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       PSEnty
     C                   PARM      SFILE1        PFile
     C                   PARM      SFNUM1        PSNum
     C                   PARM      *BLANKS       PSErr
      *
     C                   IF        PSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Define Keylist
      *
     C     KV1310        KLIST
     C                   KFLD                    F12ACC
     C                   KFLD                    F12REF
     C                   KFLD                    F12VDT
     C                   KFLD                    F12VTM
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *  Called by : (**calling routines**)                               *
      *                                                                   *
      *  Calls : None                                                     *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
