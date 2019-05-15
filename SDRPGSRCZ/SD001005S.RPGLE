     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Time Zone Selection Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001005S - Midas SD Time Zone Selection Screen              *
      *                                                               *
      *  Function:  This program display the records from the         *
      *             Time Zone.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG21289           Date 14Oct08               *
      *                 BUG19762           Date 03Jul08               *
      *                 BUG19523           Date 26Jun08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG21289 -  Various Timezone and DST errors. Applied fix     *
      *              21040                                            *
      *  BUG21040 -  Error on selection of delta time                 *
      *  BUG19762 - At system level, list view does not reflect the   *
      *             GMT Time  (Recompile)                             *
      *  BUG19523 - Various Error. (Recompile)                        *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    12 - Cancel                                                *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    33 - Error indicator                                       *
      *    36 - Subfile End                                           *
      *    80 - No Data To Display                                    *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRRecFilter - Filter subfile record(s)                       *
      *  SRErrDta  - Output Error Message With Data                   *
      *  SRSnms    - Error Meesage for No selection                   *
      *  *PSSR     - Error processing                                 *
      *  SRInit    - Initialise                                       *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** Time Zone File
     FSDTIZOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Time Zone Maintenance Display File
     FSD001005S#CF   E             WORKSTN
     F                                     SFILE(SD001005S0:RRN0 )
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Program, Shrot Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS For Indicators
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  Cancel                12     12
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
     D  ActnErr               33     33
     D  SflEnd                36     36
     D  NoData                80     80
     D  Rollup                98     98
      *
      ** Define A Data Structure To Access Default Branch
     D ZMUser          DS            17
     D  PBrc                  11     13A
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D PTZCode         S             10A
     D PTZYear         S              4A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectYN       S              1A
     D WError          S              1A   INZ('N')
     D WCtr            S              2S 0
     D Ddtmechar       S              4A                                                    BUG21040
      *
      ** Parameters For ZVACTBU/ZVACTU
     D PZbr            S              3A
     D PErr            S              1P 0
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(14)
     D Select          C                   CONST('1')
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenTabFld      S              3P 0
     D PLenScrFld      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
      *
      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
      ** Variable Declaration
     D PRetCode        S              3A
     D PTzlcd          S              1A
     D PZone           S             10A
     D PBrch           S              3A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCCod           S                   LIKE(H@TZCOD)
     D WCYear          S                   LIKE(H@TZYR)
      *
      ** Parameters for Y2SNMGC
     D PZAPgm          S             10A
     D PZAPgrl         S              5A
     D PZAMsid         S              7A
     D PZAMsgf         S             10A
     D PZAMsda         S            132A
     D PZAMstp         S              7A
      *
      ** +--------------------------------------+
      ** ¦ End Of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      **+--- Start of Main Processing --------------------------------+
      **|                                                             ¦
      **¦ Initial Processing Is Performed Automatically: The *INZSR   ¦
      **¦ Is Executed At Program Activation.                          ¦
      **¦                                                             ¦
      **+-------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Initialize
     C                   EXSR      SRInit
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Untill F12 or F3 Is Pressed
      *
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** Display And Process the Subfile
      *
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
      *
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Main Line Program                                 *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PTZCode
     C                   PARM                    PTZYear
      *
      ** Call The Access Object AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** GET ZMUser To Access Default Branch
      *
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PsUser
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
      *
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
      *
     C                   EVAL      SflMsgEnd = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
      *
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
      *
     C                   WRITE     SD001005F0
      *
      ** Write the Message Subfile Control Format
      *
     C                   WRITE     SD001005C1
      *
      ** Display the Subfile
      *
     C                   EXFMT     SD001005C0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl, SRChkAut       *
      *         SRsnms                                                *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
     C                   IF        H@TZCOD = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   ENDIF
      *
     C                   IF        H@TZYR = *BLANKS
     C                   EVAL      WCYear = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
      *
     C                   WHEN      Exit = *ON
      *
     C                   EXSR      SRSnms
     C                   MOVEL     'Y2U0016'     PRtcd
      *
     C                   LEAVESR
      *
      ** When F5 Is Pressed
      *
     C                   WHEN      Refresh = *ON
      *
      ** Reset and Build
      *
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
      *
     C                   WHEN      Rollup = *ON
      *
      ** Load the Next Page
      *
     C                   EXSR      SRLoadSfl
      *
     C                   WHEN      (H@TZCOD <> *Blanks) Or
     C                             (H@TZYR  <> *Blanks) Or
     C                             (H@SDES  <> *Blanks) Or
     C                             (H@GMT   <> *Blanks) Or
     C                             (H@GMTS  <> *Blanks) Or
     C                             (H@DSTC  <> *Blanks)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WCCod  = H@TZCOD
     C                   EVAL      WCYear = H@TZYR
      *
     C     *LOVAL        SETLL     SDTIZOL1
      *
      ** Build the Subfile With the Selection Criteria
      *
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Process the Subfile
      *
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRReset       BEGSR
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WIdx = 0
      *
     C                   IF        Refresh = *ON
      *
      ** Reset Search Fields
      *
     C                   EVAL      H@TZCOD = *Blanks
     C                   EVAL      H@TZYR  = *Blanks
     C                   EVAL      H@SDES  = *Blanks
     C                   EVALR     H@GMT   = *Blanks
     C                   EVAL      H@GMTS  = *Blanks
     C                   EVAL      H@DSTC  = *Blanks
 
     C                   EVAL      WCCod   = *Blanks
     C                   EVAL      WCYear  = *Blanks
      *
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear The SubFile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRClrSfl      BEGSR
      *
      ** Set Pointer To First Record Of Database
      *
     C     *LOVAL        SETLL     SDTIZOL1
      *
      ** Intialise Fields
      *
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0 = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0OPT = *BLANKS
     C                   EVALR     NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD001005C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess                               *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
      *
      ** Intialise Filter Flags - No Search Criteria
      *
     C                   EVAL      WSelectYN = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0 = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** If Position field - Time Zone Code is not blank,
      ** Set the Pointer To the Entered Time Zone Code
      *
     C                   IF        (H@TZCOD <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDTIZOL1)
     C     H@TZCOD       SETLL     SDTIZOL1
     C                   ENDIF
      *
      ** Reset Counter
      *
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
      *
     C                   DOW       WCtr < SflPag AND
     C                             Not %Eof(SDTIZOL1)
      *
      ** Read the Time Zone file
      *
     C                   READ      SDTIZOL1
      *
     C                   IF        %EOF(SDTIZOL1)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDTIZOL1)
     C                   EVAL      D@TZCOD  = TZTZCD
     C                   EVAL      D@TZYR   = TZYEAR
     C                   EVAL      D@STDES  = TZSDSC
     C                   MOVEL     TZGMT         D@DTIME
     C                   EVAL      D@GMTS   = TZGMTS
     C                   EVAL      D@DSTCD  = TZDSTC
      *
     C                   EXSR      SRRecFilter
      *
      ** Write the Selected Records
      *
     C                   IF        WSelectYN = 'Y'
     C                   EVAL      RRN0 = RRN0 + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      ActnErr = *OFF
     C                   WRITE     SD001005S0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record for Switching On the SFLEND Indicator
      *
     C                   IF        %EOF(SDTIZOL1)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records are Written Into Subfile
      *
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      ** Check For Last Relative Record Number
      *
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
      *
     C                   READC     SD001005S0
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WIdx = *ZEROS
      *
      ** Invalid Action Code
      *
     C                   IF        (D0OPT <> Select) AND
     C                             (D0OPT <> *BLANKS)
     C                   EVAL      PMsgId = 'USR9173'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   EVAL      ActnErr = *ON
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD001005S0
      *
     C                   ELSEIF    (D0OPT = Select)
      *
     C                   EVAL      ActnErr = *ON
     C                   EVAL      PTZCode = D@TZCOD
     C                   EVAL      PTZYear = D@TZYR
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   READC     SD001005S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecFilter - Filter Records based selection criteria        *
      *                                                               *
      *  Called by: SRLoadSfl                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRecFilter   Begsr
      *
      ** Year Filter Is Not Blanks
      *
     C                   IF        H@TZYR  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZYEAR)
     C                   EVAL      PLenScrFld = %LEN(H@TZYR)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZYEAR
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@TZYR
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Short Desc Filter Is Not Blanks
      *
     C                   IF        H@SDES  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZSDSC)
     C                   EVAL      PLenScrFld = %LEN(H@SDES)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZSDSC
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@SDES
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Delta Time Filter Is Not Blanks
      *
     C                   IF        H@GMT   <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(D@DTIME)
     C                   EVAL      PLenScrFld = %LEN(H@GMT)
     C                   Move      D@dtime       Ddtmechar                                  BUG21040
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C**********         PARM                    D@DTIME                                    BUG21040
     C                   Parm                    Ddtmechar                                  BUG21040
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@GMT
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** GMT Sign Filter Is Not Blanks
      *
     C                   IF        H@GMTS  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZGMTS)
     C                   EVAL      PLenScrFld = %LEN(H@GMTS)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZGMTS
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@GMTS
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** DST Code Filter Is Not Blanks
      *
     C                   IF        H@DSTC  <> *Blanks
     C                   EVAL      PLenTabFld = %LEN(TZDSTC)
     C                   EVAL      PLenScrFld = %LEN(H@DSTC)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    TZDSTC
     C                   PARM                    PLenTabFld
     C                   PARM                    PStart
     C                   PARM                    H@DSTC
     C                   PARM                    PLenScrFld
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRChkAut, SRPrSfl                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSnms - Send error message to program message Queue         *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSnms        BEGSR
      *
      ** Send message '*No value selected'
      *
     C                   MOVEL     'Y2U0016'     PZAMsid
     C                   MOVEL     'Y2USRMSG'    PZAMsgf
     C                   MOVEL     '*PRV '       PZAPgrl
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'SD001005S'   PZAPgm
     C                   PARM                    PZAPgrl
     C                   PARM                    PZAMsid
     C                   PARM                    PZAMsgf
     C                   PARM                    PZAMsda
     C                   PARM                    PZAMstp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      PZAPgm = *BLANKS
     C                   EVAL      PZAPgrl = *BLANKS
     C                   EVAL      PZAMsid = *BLANKS
     C                   EVAL      PZAMsgf = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANKS
      *
     C                   EVAL      Wrun = 'Y'
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
      *****************************************************************
      /EJECT
      *****************************************************************
