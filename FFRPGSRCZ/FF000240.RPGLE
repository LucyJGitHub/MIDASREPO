     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Closing Trades Input')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000240 - Closing Trades Input                              *
      *                                                               *
      *  Component of: FFC000240 - Closing Trades Input               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAAA03             Date 28Apr04               *
      *                 CAAA02             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAAA03 - Webfacing Changes. (recompile)                      *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens. Recompile only.                 *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    07         INVITE enabled in DSPF                          *
      *    18         Display error line                              *
      *    19         Action code checking against user               *
      *    20         Error on Action Code                            *
      *    21         Error on Market                                 *
      *    71         General file-access indicator                   *
      *                                                               *
      *    KC         F3 - exit program                               *
      *    KI         Add/Change mode                                 *
      *                                                               *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVal1     - Validate initial screen input.                  *
      *  SRChkOpen  - Test if Market entered is open                  *
      *  SRNxtScrn  - Display Next Screen                             *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialization                                  *
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
 
      ** Maintenance screen
     FFF000240DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     IGNORE(FF000240F4)
     F                                     IGNORE(FF000240F5)
     F                                     IGNORE(FF000240F6)
 
      ** Market Control details
     FMKCTL     IF   E           K DISK    INFSR(*PSSR)
 
      ** Market Centres
     FMARKT     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
      *
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
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA
 
      **   Save Market
     D FFMRKT         UDS                  DTAARA
     D  MRKTFF                 1      2
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WCOvrTheCtr     C                   CONST('OVER THE COUNTER')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Error codes array, index 'E'
     D CMD             S             39    DIM(1) CTDATA PERRCD(1)
 
      ** First data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data structure for the first compile-time command
     D                 DS
     D PQCmd                   1     39
     D WAORD                   1      1
     D WMRKT                  13     14
     D WWAIT                  32     39
 
      ** Sharing of field values across all record formats.
      ** If possible, only use group of fields prefixed by 'WSc'.
     D                 DS
 
     D WScUser                 1     10
     D WScRunDate7            11     17
     D WScJob                 18     27
     D WScAction              28     28
     D WScMkt                 29     30
     D WScMktName             31     50
     D WScTransRef            51     56
     D WScCloseTrade          57     62
     D WScErrLine1            63    139
     D  WArErr                63    142
     D                                     DIM(20)
 
     D #1User                  1     10
     D #1MRDT                 11     17
     D #1Job                  18     27
     D #1ACTN                 28     28
     D #1MRKT                 29     30
     D #1ERCD1                63    139
 
     D #2User                  1     10
     D #2MRDT                 11     17
     D #2Job                  18     27
     D #2ACTN                 28     28
     D #2MKTN                 31     50
     D #2TNBR                 51     56
     D #2CLTR                 57     62
     D #2ERCD1                63    139
 
     D #3User                  1     10
     D #3MRDT                 11     17
     D #3Job                  18     27
     D #3ACTN                 28     28
     D #3MKTN                 31     50
     D #3TNBR                 51     56
     D #3ERCD1                63    139
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D P0Action        S              1A
     D P0Mkt           S              2A
     D P0MktName       S             20A
     D P0RunDateA      S              7A
     D P0RunDay        S              5P 0
     D P0DateFmt       S              1A
     D P0MultBrch      S              1A
     D P0BusiDate      S              5P 0
     D P0MktLocCcy     S              3A
     D P0MktLocCde     S              3A
 
      ** Parameter fields for standard Z* pgms
     D PZAction        S              1A
     D PZErrNum010     S              1P 0
 
      ** Parameter fields for standard Q* pgms
     D PQLen           S             15P 5
 
      ** Parameter fields for access programs
     D PRtnCde         S              7A
     D POption         S              7A
     D PChr006         S              6A
 
      ** Work fields
     D WEx             S              3P 0
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initail screen
     C                   MOVE      *BLANK        WScAction
     C                   MOVE      *BLANKS       WScMkt
     C                   MOVE      *BLANK        WScMktName
     C                   WRITE     FF000240F1
 
      **   Loop until valid entry or F3 taken
     C     *INKC         DOWEQ     *OFF
 
     C                   READ      FF000240F1                             71
 
      ** Reset indicators/fields
     C                   MOVE      *OFF          *IN18
     C                   MOVE      *OFF          *IN19
     C                   MOVE      *OFF          *IN20
     C                   MOVE      *OFF          *IN21
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
     C                   SELECT
      ** --------- **
      ** F3 - Exit **
      ** ----------**
     C                   WHEN      *INKC = *ON
     C                   MOVE      *BLANK        P0Action
      ** ------- **
      ** <Enter> **
      ** --------**
     C                   OTHER
 
      ** Validate Input
     C                   EXSR      SRVal1
 
     C     *IN18         IFEQ      *ON
     C                   WRITE     FF000240F1
     C                   ELSE
      ** If validation is ok, save market in *dtaara/FFMRKT.
      ** Do next screen and end program.
     C     *LOCK         IN        FFMRKT
     C                   MOVE      WScMkt        MRKTFF
     C                   OUT       FFMRKT
     C                   EXSR      SRNxtScrn
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
      ** Set up parameters unless F3 taken
     C     *INKC         IFEQ      *OFF
     C                   MOVE      WScAction     P0Action
     C                   MOVE      WScMkt        P0Mkt
     C                   MOVE      WScMktName    P0MktName
     C                   ELSE
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal1     -  Validate initial screen input.                 *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZVACTU, SRChkOpen                                 *
      *                                                               *
      *****************************************************************
     C     SRVal1        BEGSR
 
      ** -------------------- **
      ** Validate Action Code **
      ** -------------------- **
 
     C     WScAction     IFNE      'I'
     C     WScAction     ANDNE     'A'
     C     WScAction     ANDNE     'D'
     C     WScAction     ANDNE     'E'
     C                   ADD       1             WEx
     C                   MOVE      ' 001'        WArErr(WEx)
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN20
     C                   GOTO      ExVal1
     C                   ENDIF
 
      ** SPF Checking on action code when MBIN <> N
     C     AGMBIN        IFNE      'Y'
 
     C                   CALL      'ZVACTU'
     C                   PARM      WScAction     PZAction
     C                   PARM                    PZErrNum010
     C     PZErrNum010   IFNE      *ZERO
     C                   ADD       1             WEx
     C                   MOVE      ' 303'        WArErr(WEx)
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN19
     C                   MOVE      *ON           *IN20
     C                   GOTO      ExVal1
     C                   ENDIF
 
     C                   ENDIF
 
      ** ---------------------- **
      ** Validate Market Centre **
      ** ---------------------- **
 
     C     WScMkt        IFNE      *BLANKS
 
     C     WScMkt        CHAIN     MARKT                              71
      ** A live Market record must exist
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 011'        WArErr(WEx)
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN21
     C                   GOTO      ExVal1
     C                   ENDIF
 
      ** Continue, if validation ok
     C                   MOVE      MKLC          P0MktLocCcy
     C                   MOVE      MLOC          P0MktLocCde
     C                   EXSR      SRChkOpen
     C                   Z-ADD     BUSD          P0BusiDate
 
     C                   ENDIF
 
     C     ExVal1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOpen  - Set up and validation of Market.                *
      *                                                               *
      *  Called by: SrVal1                                            *
      *                                                               *
      *  Calls:     QCMDEXC, *PSSR                                    *
      *                                                               *
      *****************************************************************
     C     SRChkOpen     BEGSR
 
      ** Attempt to allocate Market data area
     C                   MOVE      CMD(1)        PQCmd
     C                   MOVE      'A'           WAORD
     C                   MOVE      WScMkt        WMRKT
     C                   CALL      'QCMDEXC'                            71
     C                   PARM                    PQCmd
     C                   PARM      39            PQLen
 
      ** Market not available for input
     C     *IN71         IFEQ      '1'
     C                   ADD       1             WEx
     C                   MOVE      ' 012'        WArErr(WEx)
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN21
     C                   GOTO      ExChkOpen
     C                   ENDIF
 
      ** Chain Market Centre control record to see if Market is open
     C     WScMkt        CHAIN     MKCTL                              71
 
      **   A live Market Control record must exist
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
      ** Deallocate market data area
     C                   MOVE      'D'           WAORD
     C                   MOVE      WScMkt        WMRKT
     C                   MOVE      *BLANK        WWAIT
     C                   CALL      'QCMDEXC'                            71
     C                   PARM                    PQCmd
     C                   PARM      39            PQLen
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'MKCTL'       DBFile
     C                   MOVEL     WScMkt        DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Mkt Centre Ind. must be 'I'
     C     MKCI          IFNE      'I'
     C                   MOVE      'D'           WAORD
     C                   MOVE      WScMkt        WMRKT
     C                   MOVE      *BLANK        WWAIT
     C                   CALL      'QCMDEXC'                            71
     C                   PARM                    PQCmd
     C                   PARM      39            PQLen
     C                   ADD       1             WEx
     C                   MOVE      ' 012'        WArErr(WEx)
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN21
     C                   ENDIF
 
     C     ExChkOpen     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNxtScrn  - Display Next Screen                             *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRNxtScrn     BEGSR
 
      ** Reset indicators/fields
     C                   MOVE      *OFF          *IN18
     C                   MOVE      *OFF          *IN19
     C                   MOVE      *OFF          *IN20
     C                   MOVE      *OFF          *IN21
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
      ** Output Market Name or O.T.C.
     C     WScMkt        IFNE      *BLANKS
     C                   MOVE      MKTN          WScMktName
     C                   ELSE
     C                   MOVEL     WCOvrTheCtr   WScMktName
     C                   ENDIF
 
      ** Trans Ref prompt
     C                   MOVE      *ON           *IN07
     C     WScAction     IFEQ      'I'
     C                   WRITE     FF000240F2
     C                   ELSE
     C                   WRITE     FF000240F3
     C                   ENDIF
     C                   MOVE      *OFF          *IN07
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
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
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P0Action
     C                   PARM                    P0Mkt
     C                   PARM                    P0MktName
     C                   PARM                    P0RunDateA
     C                   PARM                    P0RunDay
     C                   PARM                    P0DateFmt
     C                   PARM                    P0MultBrch
     C                   PARM                    P0BusiDate
     C                   PARM                    P0MktLocCcy
     C                   PARM                    P0MktLocCde
 
      ** Access data area--RUNDAT
     C                   IN        RUNDAT
 
      ** Reset LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       DBKey
     C                   Z-ADD     *ZEROS        DBASE
     C                   MOVEL     PSProcMod     DBPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJMRDT        P0RunDateA
     C                   Z-ADD     BJRDNB        P0RunDay
     C                   MOVEL     BJDFIN        P0DateFmt
     C                   MOVEL     AGMBIN        P0MultBrch
     C                   MOVEL     PSUser        WScUser
     C                   MOVEL     BJMRDT        WScRunDate7
     C                   MOVEL     PSJobName     WScJob
 
     C                   ENDSR
      *****************************************************************
**CTDATA CMD
XLCOBJ OBJ((XX *DTAARA *SHRRD)) WAIT(5)
