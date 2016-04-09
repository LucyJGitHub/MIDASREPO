     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD External Transaction system ID subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009812 - Midas SD External Transaction System ID Subfile   *
      *                                                               *
      *  Function:  This program display the records from the         *
      *             External Transaction System File                  *
      *                                                               *
      *  Called By: SDC009818 - MIDAS SD MiFID Subfile Menu Option    *
      *                         Controller                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    09 - Add                                                   *
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
      *  SRChkAut  - Validate Authorization Of User For The SubFile   *
      *              Option                                           *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRErrDta  - Output Error Message With Data                   *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec Initialisation Only Happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** External Transaction System ID File
     FSDEXTSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** External Transaction System ID Subfile
     FSD009812DFCF   E             WORKSTN
     F                                     SFILE(SD009812S0:RRN0 )
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
     D Indicators      DS                  BASED(Ind_Pointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  Add                   09     09
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
     D Ind_Pointer     S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D PExid           S              2A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectYN       S              1A
     D WSelectAM       S              1A
     D WSelectTF       S              1A
     D WError          S              1A   INZ('N')
     D WCtr            S              2  0
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
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenDESC        S              3P 0
     D PLenAMEN        S              3P 0
     D PLenTIMF        S              3P 0
     D PLenD0DESC      S              3P 0
     D PLenD0AMEN      S              3P 0
     D PLenD0TIMF      S              3P 0
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
      ** Variable Decleration
     D PRetCode        S              3A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WEid            S                   LIKE(D0EXIDS)
     D WDes            S                   LIKE(D0DESCS)
     D WAmn            S                   LIKE(D0AMENS)
     D WTmf            S                   LIKE(D0TIMFS)
      *
      ** Mode - Enquiry/Maintenance
     D PMode           S              1A
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
      ** Check if in Enquiry Mode
     C                   IF        PMode = 'E'
     C                   EVAL      *IN42 = *ON
     C                   ELSE
     C                   EVAL      *IN42 = *OFF
     C                   ENDIF
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Dsiplay the Screen Untill F12 or F3 Is Pressed
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
      ** COMMIT for SDEXTSL0 File
     C                   COMMIT
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PMode
      *
      ** Call The Access Object AOBANKR0
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** GET ZMUser To Access Default Branch
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
      *
      ** Populate WorkStation ID
     C                   EVAL      D0WOID = PsJobName
      *
      ** Populate User
     C                   EVAL      D0USRP = PsUser
      *
      ** Populate Midas Run Date
     C                   EVAl      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
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
      *
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *
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
      *
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
     C                   WRITE     SD009812F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD009812C1
      *
      ** Display the Subfile
     C                   EXFMT     SD009812C0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl, SRChkAut       *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and The Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        D0EXIDS = *BLANKS
     C                   EVAL      WEid = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0DESCS = *BLANKS
     C                   EVAL      WDes = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0AMENS = *BLANKS
     C                   EVAL      WAmn = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0TIMFS = *BLANKS
     C                   EVAL      WTmf = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
     C                   WHEN      Exit = *ON
     C                   LEAVESR
      *
      ** When F5 Is Pressed
     C                   WHEN      Refresh = *ON
      *
      ** Reset And Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
     C                   WHEN      Rollup = *ON
      *
      ** Load the Next Page
     C                   EXSR      SRLoadSfl
      *
      ** When F9 Is Pressed And Extrnal System ID And Description
      ** Filters Are Not Changed
      *
     C                   WHEN      (ADD = *ON) AND
     C                             (D0EXIDS = WEid) AND
     C                             (D0DESCS = WDes) AND
     C                             (D0AMENS = WAmn) AND
     C                             (D0TIMFS = WTmf)
      *
      ** Process the Function Keys And the Values Entered On the
      ** Screen
      *
     C                   EXSR      SRPrSfl
      *
      ** Check the Authority
     C                   IF        WIdx = 0
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Call the Input Screen
     C                   IF        WIdx = 0
     C                   CALL      'SD009813'
     C                   PARM      'I'           POpt
     C                   PARM      *BLANKS       PExid
     C                   PARM      *BLANKS       PRetCode
      *
      ** When F3 Is Pressed Go To Main Menu
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVESR
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** When External System ID and Description Filters Are Not
      ** Changed And Valid Options Are Entered On the Screen,
      ** Process the Subfile
      *
     C                   WHEN      (D0EXIDS = WEid) AND
     C                             (D0DESCS = WDes) AND
     C                             (D0AMENS = WAmn) AND
     C                             (D0TIMFS = WTmf) AND
     C                             (Add = *OFF)
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Clear the Programn Message Queue And the Fields
     C                   EXSR      SRReset
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
      ** When External System ID And Description Filters Are Entered
     C                   WHEN      (D0EXIDS <> *BLANKS) OR
     C                             (D0DESCS <> *BLANKS) OR
     C                             (D0AMENS <> *BLANKS) OR
     C                             (D0TIMFS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WEid = D0EXIDS
     C                   EVAL      WDes = D0DESCS
     C                   EVAL      WAmn = D0AMENS
     C                   EVAL      WTmf = D0TIMFS
      *
      ** Build the Subfile With the Selection Criteria(Filters)
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Process the Subfile
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Clear Program Queue
     C                   EXSR      SRReset
      *
      ** Load the Subfile
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
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
      *
     C     SRReset       BEGSR
      *
      ** Clear Program Queue And Message File
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WIdx = 0
      *
     C                   IF        Refresh = *ON
      *
      ** Reset Search Fields
     C                   EVAL      D0EXIDS = *BLANKS
     C                   EVAL      D0DESCS = *BLANKS
     C                   EVAL      D0AMENS = *BLANKS
     C                   EVAL      D0TIMFS = *BLANKS
     C                   EVAL      WEid = *BLANKS
     C                   EVAL      WDes = *BLANKS
     C                   EVAL      WAmn = *BLANKS
     C                   EVAL      WTmf = *BLANKS
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
      *
     C     SRClrSfl      BEGSR
      *
      ** Set Pointer To First Record Of Database
     C     *LOVAL        SETLL     SDEXTSL0
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD009812C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl,SRProcess                                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
     C                   EVAL      WSelectYN = 'Y'
     C                   EVAL      WSelectAM = 'Y'
     C                   EVAL      WSelectTF = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered External System ID
     C                   IF        (D0EXIDS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDEXTSL0)
     C     D0EXIDS       SETLL     SDEXTSL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDEXTSL0)
      *
      ** Read the External Transaction System ID file
     C                   READ      SDEXTSL0
      *
     C                   IF        %EOF(SDEXTSL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDEXTSL0)
     C                   EVAL      D0EXID = E9EXID
     C                   EVAL      D0DESC = E9DESC
     C                   EVAL      D0AMEN = E9AMEN
     C                   EVAL      D0TIMF = E9TIMF
      *
      ** External System ID Filter Is Not Blanks
     C                   IF        D0DESCS <> *BLANKS
     C                   EVAL      PLenDESC = %LEN(E9DESC)
     C                   EVAL      PLenD0DESC = %LEN(D0DESCS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    E9DESC
     C                   PARM                    PLenDESC
     C                   PARM                    PStart
     C                   PARM                    D0DESCS
     C                   PARM                    PLenD0DESC
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      E9EXID = *BLANKS
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Data Input Protection is not Blanks
     C                   IF        D0AMENS <> *BLANKS
      *
     C                   EVAL      PLenAMEN = %LEN(E9AMEN)
     C                   EVAL      PLenD0AMEN = %LEN(D0AMENS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    E9AMEN
     C                   PARM                    PLenAMEN
     C                   PARM                    PStart
     C                   PARM                    D0AMENS
     C                   PARM                    PLenD0AMEN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If not present,blank out screen field
      ** else show correspondig filtered record on screen
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectAM = 'N'
     C                   EVAL      D0AMEN = *BLANKS
     C                   ELSE
     C                   EVAL      WSelectAM = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Time Format is not Blanks
     C                   IF        D0TIMFS <> *BLANKS
      *
     C                   EVAL      PLenTIMF = %LEN(E9TIMF)
     C                   EVAL      PLenD0TIMF = %LEN(D0TIMFS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    E9TIMF
     C                   PARM                    PLenTIMF
     C                   PARM                    PStart
     C                   PARM                    D0TIMFS
     C                   PARM                    PLenD0TIMF
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If not present,blank out screen field
      ** else show correspondig filtered record on screen
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelectTF = 'N'
     C                   EVAL      D0TIMF = *BLANKS
     C                   ELSE
     C                   EVAL      WSelectTF = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectYN = 'Y' AND
     C                             WSelectAM = 'Y' AND
     C                             WSelectTF = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      ActnErr = *OFF
     C                   WRITE     SD009812S0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record For Switching On the SFLEND Indicator
     C                   READ      SDEXTSL0
     C                   IF        %EOF(SDEXTSL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDEXTSL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records Are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, Then Show 'No Data to Display' Message
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta, SRChkAut                                    *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      ** Check For Last Relative Record Number
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
     C                   EVAL      WError = 'N'
     C                   READC     SD009812S0
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WIdx = *ZEROS
      *
      ** Invalid Action Code
      ** In case of Maintenance Mode
      *
     C                   IF        (D0ACTN <> Amend) AND
     C                             (D0ACTN <> Enquire) AND
     C                             (D0ACTN <> Delete) AND
     C                             (D0ACTN <> *BLANKS) AND
     C                             (PMode = 'M')
     C                   EVAL      PMsgId = 'CSF9853'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
      ** Validation for Action code - E in case of Enquire mode
     C                   ELSEIF    (D0ACTN <> Enquire) AND
     C                             (D0ACTN <> *BLANKS) AND
     C                             (PMode = 'E')
      *
     C                   EVAL      PMsgId = 'SDA0005'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
      ** Check For User Authority
     C                   IF        WIdx = 0
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      *
      ** Amend/Delete not allowed if External System Id is 'TO'
     C                   IF        (D0ACTN = 'A' OR
     C                             D0ACTN = 'D') AND (D0EXID = 'TO')
     C                   EVAL      PMsgId  = 'USR8101'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      ActnErr = *ON
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Error In Check Authority
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      D0SFRN = RRN0
     C                   ELSE
     C                   EVAL      ActnErr = *OFF
     C                   ENDIF
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD009812S0
      *
     C                   READC     SD009812S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
      ** If Error, Stop Processing Further
     C                   IF        ((WError = 'Y')  OR
     C                             ((WError = 'N') AND
     C                             (D0EXIDS <> WEid OR
     C                             D0DESCS <> WDes OR
     C                             D0AMENS <> WAmn OR
     C                             D0TIMFS <> WTmf )) OR
     C                             Add = *ON)
     C                   LEAVESR
     C                   ENDIF
      *
      ** If No Error Call Maintenance Program
     C                   READC     SD009812S0
     C                   DOW       NOT %EOF
      *
      ** Call the Maintenance Program In Amend Mode
     C                   IF        D0ACTN <> *BLANKS
     C                   EVAL      POpt = D0ACTN
     C                   EVAL      PExid = D0EXID
      *
      ** Display Maintenance Screen
     C                   CALL      'SD009813'
     C                   PARM                    POpt
     C                   PARM                    PExid
     C                   PARM      *BLANKS       PRetCode
      *
      ** When F3 Is Pressed, Come Out Of the Screen
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      D0ACTN = *BLANKS
      *
     C                   UPDATE    SD009812S0
      *
     C                   ENDIF
     C                   READC     SD009812S0
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Validate Authorization Of User For The SubFile    *
      *             Option                                            *
      *                                                               *
      *  Called by: SRPrSfl, SRProcess                                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
      *
      ** Check Whether The User Is Authorized For The Selected
      ** Operation
      *
     C                   IF        BJSBRC <> *BLANKS
      *
      ** Single Branching
     C                   CALL      'ZVACTU'
     C                   PARM      POpt          D0ACTN
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      PMSGID = 'FXM0292'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx +1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Multi Branching
     C                   CALL      'ZVACTBU'
     C                   PARM      D0ACTN        POpt
     C                   PARM      PBrc          PZbr
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      PMsgId = 'CSF9008'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    PErr = 2
     C                   EVAL      PMsgId = 'USR4436'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
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
     C                   PARM      D0EXID        PMsgData
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
