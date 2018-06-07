     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS High Value A/C Identification List')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000312 - Midas SD CRS High Value Account Identification    *
      *             List                                              *
      *                                                               *
      *  Function:  This program display the records from the CRS     *
      *             High Value Account Identification List File       *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    04 - Print                                                 *
      *    05 - Refresh                                               *
      *    12 - Previous                                              *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    36 - Subfile End                                           *
      *    40 - Print Key                                             *
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
      ** CRS High Value Account Identification List File
     F***SDCRHLL0  IF   E           K DISK    INFSR(*PSSR) USROPN
     FSDCRHLL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** CRS High Value Account Identification List
     FSD000312DFCF   E             WORKSTN
     F                                     SFILE(SD000312S0:RRN0 )
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
     D  Print                 04     04
     D  Refresh               05     05
     D  Previous              12     12
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
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
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectUT       S              1A
     D WSelectCC       S              1A
     D WSelectNC       S              1A
     D WSelectCT       S              1A
     D WSelectHI       S              1A
     D WSelectSR       S              1A
     D WSelectHA       S              1A
     D WCtr            S              2  0
     D PMode           S              1A
     D Mode            S              1A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(10)
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenUTIN        S              3P 0
     D PLenCCLC        S              3P 0
     D PLenNCLC        S              3P 0
     D PLenCUTP        S              3P 0
     D PLenHVIN        S              3P 0
     D PLenSUBJ        S              3P 0
     D PLenHVAM        S              3P 0
     D PLenD0UTIN      S              3P 0
     D PLenD0CCLC      S              3P 0
     D PLenD0NCLC      S              3P 0
     D PLenD0CUTP      S              3P 0
     D PLenD0HVIN      S              3P 0
     D PLenD0SUBJ      S              3P 0
     D PLenD0HVAM      S              3P 0
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
     D WRun            S              1A
     D WCus            S                   LIKE(DBCUST)
     D WRpn            S                   LIKE(DBRPNM)
     D WRpt            S                   LIKE(DBRPTN)
     D WHvi            S                   LIKE(DBHVIN)
     D WHam            S                   LIKE(DBHVAM)
     D WSbj            S                   LIKE(DBSUBJ)
     D PHGVI           S             18A
     D PHGVE           S             18A
     D PLVAM           S             18A
     D PHVCY           S              3A
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
      ** Display Print Key If Not In Update Mode
     C                   IF        PMode <> 'U'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F12 Is Pressed
     C                   DOW       (Previous = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PHGVI
     C                   PARM                    PHGVE
     C                   PARM                    PLVAM
     C                   PARM                    PHVCY
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
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Populate System values
     C                   EVAL      D0HGVI = PHGVI
     C                   EVAL      D0HGVE = PHGVE
     C                   EVAL      D0LVAM = PLVAM
     C                   EVAL      D0HVCY = PHVCY

      ** Trim leading spaces before the display

     C                   EVAL      D0HGVI = %TRIML(D0HGVI)
     C                   EVAL      D0HGVE = %TRIML(D0HGVE)
     C                   EVAL      D0LVAM = %TRIML(D0LVAM)
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
     C                   WRITE     SD000312F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000312C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000312C0
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
      *  Calls: SRReset, SRBldSfl, SRLoadSfl                          *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and The Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        DBCUST = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   ENDIF
      *
     C                   IF        DBRPNM = *BLANKS
     C                   EVAL      WRpn = *BLANKS
     C                   ENDIF
      *
     C                   IF        DBRPTN = *BLANKS
     C                   EVAL      WRpt = *BLANKS
     C                   ENDIF
      *
     C                   IF        DBHVIN = *BLANKS
     C                   EVAL      WHvi = *BLANKS
     C                   ENDIF
      *
     C                   IF        DBSUBJ = *BLANKS
     C                   EVAL      WSbj = *BLANKS
     C                   ENDIF
      *
     C                   IF        DBHVAM = *BLANKS
     C                   EVAL      WHam = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F12 Is Pressed
     C                   WHEN      Previous = *ON
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
     C                   WHEN      (Print = *ON) AND
     C                             (DBCUST = WCus) AND
     C                             (DBRPNM = WRpn) AND
     C                             (DBRPTN = WRpt) AND
     C                             (DBHVIN = WHvi) AND
     C                             (DBSUBJ = WSbj) AND
     C                             (DBHVAM = WHam)
      *
      ** Print
     C                   CALL      'SD000314'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'R'           Mode
     C                   PARM                    PHGVI
     C                   PARM                    PHGVE
     C                   PARM                    PLVAM
     C                   PARM                    PHVCY
      *
      ** Display a message that the print was successful
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PMsgId = 'USS0286'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
      *
      ** When Selection Filters Are Entered
     C                   WHEN      (DBCUST <> *BLANKS) OR
     C                             (DBRPNM <> *BLANKS) OR
     C                             (DBRPTN <> *BLANKS) OR
     C                             (DBHVIN <> *BLANKS) OR
     C                             (DBSUBJ <> *BLANKS) OR
     C                             (DBHVAM <> *BLANKS)
      *
     C                   EVAL      WCus = DBCUST
     C                   EVAL      WRpn = DBRPNM
     C                   EVAL      WRpt = DBRPTN
     C                   EVAL      WHvi = DBHVIN
     C                   EVAL      WSbj = DBSUBJ
     C                   EVAL      WHam = DBHVAM
      *
      ** Build the Subfile With the Selection Criteria (Filters)
     C                   EXSR      SRBldSfl
     C                   OTHER
      *
      ** Clear Program Queue
     C                   EXSR      SRReset
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
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
     C                   IF        Refresh = *ON
      *
      ** Reset Selection Fields
     C                   EVAL      DBCUST = *BLANKS
     C                   EVAL      DBRPNM = *BLANKS
     C                   EVAL      DBRPTN = *BLANKS
     C                   EVAL      DBHVIN = *BLANKS
     C                   EVAL      DBSUBJ = *BLANKS
     C                   EVAL      DBHVAM = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   EVAL      WHvi = *BLANKS
     C                   EVAL      WSbj = *BLANKS
     C                   EVAL      WHam = *BLANKS
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
     C     *LOVAL        SETLL     SDCRHLL0
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      NoData = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000312C0
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
     C                   EVAL      WSelectHI = 'Y'
     C                   EVAL      WSelectSR = 'Y'
     C                   EVAL      WSelectHA = 'Y'
      *
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Customer Number
     C                   IF        (DBCUST <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDCRHLL0)
     C     DBCUST        SETLL     SDCRHLL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDCRHLL0)
      *
      ** Read the CRS Customer Type & Classification List File
     C                   READ      SDCRHLL0
      *
     C                   IF        %EOF(SDCRHLL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDCRHLL0)
     C                   EVAL      D0CUST = HLCUST
     C                   EVAL      D0RPNM = HLRPNM
     C                   EVAL      D0RPTN = HLRPTN
     C                   EVAL      D0HVIN = HLHVIN
     C                   EVAL      D0SUBJ = HLSUBJ
     C                   EVAL      D0HVAM = HLHVAM
      *
      ** High Value Indicator Is Not Blanks
     C                   IF        DBHVIN <> *BLANKS
     C                   EVAL      PLenHVIN = %LEN(HLHVIN)
     C                   EVAL      PLenD0HVIN = %LEN(DBHVIN)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLHVIN
     C                   PARM                    PLenHVIN
     C                   PARM                    PStart
     C                   PARM                    DBHVIN
     C                   PARM                    PLenD0HVIN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectHI = 'N'
     C                   EVAL      D0HVIN = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectHI = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Subject to Reporting Is Not Blanks
     C                   IF        DBSUBJ <> *BLANKS
     C                   EVAL      PLenSUBJ = %LEN(HLSUBJ)
     C                   EVAL      PLenD0SUBJ = %LEN(DBSUBJ)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLSUBJ
     C                   PARM                    PLenSUBJ
     C                   PARM                    PStart
     C                   PARM                    DBSUBJ
     C                   PARM                    PLenD0SUBJ
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectSR = 'N'
     C                   EVAL      D0SUBJ = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectSR = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** High Value Amount Is Not Blanks
     C                   IF        DBHVAM <> *BLANKS
     C                   EVAL      PLenHVAM = %LEN(HLHVAM)
     C                   EVAL      PLenD0HVAM = %LEN(DBHVAM)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLHVAM
     C                   PARM                    PLenHVAM
     C                   PARM                    PStart
     C                   PARM                    DBHVAM
     C                   PARM                    PLenD0HVAM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectHA = 'N'
     C                   EVAL      D0HVAM = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectHA = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectHI = 'Y' AND
     C                             WSelectSR = 'Y' AND
     C                             WSelectHA = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   WRITE     SD000312S0
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
     C                   READ      SDCRHLL0
     C                   IF        %EOF(SDCRHLL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDCRHLL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      *
      ** Check If Records Are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
      *
      ** Display a message that the tool has been run successfully
     C                   IF        PMode = 'U'
     C                   EVAL      PMsgId = 'USS0269'
     C                   ELSE
     C                   EVAL      PMsgId = 'USS0283'
     C                   ENDIF
     C                   EXSR      SRErrDta
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
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRLoadSfl                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      D0CUST        PMsgData
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
