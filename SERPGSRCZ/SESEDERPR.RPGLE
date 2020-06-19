000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Invalid security diary events repair')        *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDERPR - Invalid Security Diary Events Repair             *
001100200529      *                                                               *
001200200529      *  Function: This module allows invalid security diary event    *
001300200529      *            details to be 'repaired' and applied to the Midas  *
001400200529      *            database.                                          *
001500200529      *                                                               *
001600200529      *  Component of: SESEDERPR                                      *
001700200529      *                                                               *
001800200529      *  (c) Finastra International Limited 2001                      *
001900200529      *                                                               *
002000200604      *  Last Amend No. 260191A            Date 22May20               *
002100200529      *  Prev Amend No. MD046248           Date 27Oct17               *
002200200529      *                 CRE073             Date 06Dec10               *
002300200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002400200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002500200529      * Midas Plus 1.4 Base ------------------------------------------*
002600200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002700200529      *                 CSD027             Date 09Dec05               *
002800200529      *                 CSE075             Date 17Nov05               *
002900200529      *                 CGL031             Date 05Jul04               *
003000200529      *                 CSE065             Date 06Dec04               *
003100200529      *                 CSE071             Date 19Jul05               *
003200200529      *                 CSE072             Date 05Apr05               *
003300200529      *                 BUG2064            Date 29May04               *
003400200529      *                 BUG2604            Date 18May04               *
003500200529      *                 222373             Date 23Oct03               *
003600200529      *                 CAS006             Date 21Jan03               *
003700200529      * Midas Release 4.01 -------------------------------------------*
003800200529      *                 CSE031             Date 09Nov01               *
003900200529      *                 CSC011             Date 18Sep01               *
004000200529      * Midas Release 4 --------------- Base -------------------------*
004100200529      * Midas DBA 3.05 -----------------------------------------------*
004200200529      *                 CSD006             Date 11Oct00               *
004300200529      *                 CAP140  *CREATE    Date 17Oct00               *
004400200529      *                                                               *
004500200529      *---------------------------------------------------------------*
004600200529      *                                                               *
004700200529      *  260191A- System should not allow deletion of LIVE/MATURED    *
004800200529      *           security diary event if ALL generated position      *
004900200529      *           settlements are still unsettled/live records.       *
005000200529      *           Hence, system will not generate reversal position   *
005100200529      *           settlements.                                        *
005200200529      *  MD046248 - Finastra Rebranding                               *
005300200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005400200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
005500200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
005600200529      *           (Recompile)                                         *
005700200529      *  CGL031 - Taxation of Savings Income                          *
005800200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
005900200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
006000200529      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
006100200529      *  BUG2064 - Initialization of CSC022.                          *
006200200529      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
006300200529      *  222373 - Parameter Mismatch                                  *
006400200529      *  CAS006 - Hedge Accounting Phase B                            *
006500200529      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
006600200529      *  CSC011 - 24x7 Midas Availability                             *
006700200529      *  CSD006 - Recompiled over changed SECTYD.                     *
006800200529      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
006900200529      *           modular structure to use as APIs.                   *
007000200529      *                                                               *
007100200529      *****************************************************************
007200200529      *                                                               *
007300200529      *  Use of indicators.                                           *
007400200529      *                                                               *
007500200529      *    98         Use for LOOKUP command                          *
007600200529      *    99         Use for chaining to file                        *
007700200529      *                                                               *
007800200529      *****************************************************************
007900200529      *                                                               *
008000200529      *  S U B R O U T I N E  I N D E X                               *
008100200529      *                                                               *
008200200529      *  SRScrnB - Browse invalid security diary events details       *
008300200529      *  SRRdnBrw - Read Next Browse Subfile Record                   *
008400200529      *  SRScrnD - Process Detail Screen                              *
008500200529      *  SRDefScnD - Default fields in detail screen                  *
008600200529      *  SRValD - Validate input to detail screen.                    *
008700200529      *  SRScrnW - Process Window Screen                              *
008800200529      *  SRScrnF - Process Confirmation Screen                        *
008900200529      *  SRUpdate - Update Files                                      *
009000200529      *  SRRtvSEDE - Retrieve security diary events details.          *
009100200529      *  SRCvtSEDE - Converts security diary events details from      *
009200200529      *              file to screen format.                           *
009300200529      *  SRDtaSubs - Data Substitution                                *
009400200529      *  SRSndMD - Send error message to detail screen                *
009500200529      *  SREndP - Set Program to End                                  *
009600200529      *  SRResetErr - Reset Error Fields                              *
009700200529      *  *PSSR - Error processing                                     *
009800200529      *  *INZSR - Initialise                                          *
009900200529      *                                                               *
010000200529      *    The *INZSR subroutine will only get called automatically   *
010100200529      *    on entry to the module the first time it is run            *
010200200529      *    (unless you end the program with LR on).  Similarly        *
010300200529      *    D-spec initialisation only happens the first time.  Use    *
010400200529      *    RESET for subsequent passes.                               *
010500200529      *                                                               *
010600200529      *****************************************************************
010700200529      *
010800200529      ** +--------------------------------------+
010900200529      ** ¦ F-specs                              ¦
011000200529      ** ¦ =======                              ¦
011100200529      ** +--------------------------------------+
011200200529      *
011300200529      ** Transaction Errors file keyed on Front Office Transaction Id,
011400200529      ** Timestamp and Transaction Field Identifier
011500200529     FZATRNERRL1IF   E           K DISK    INFSR(*PSSR)
011600200529      *
011700200529      ** Midas module flag - details
011800200529     FMMODF     IF   E             DISK    INFSR(*PSSR)
011900200529      *
012000200529      ** Invalid Security Diary Events by Timestamp and Fromt Office Id
012100200529      ** - for record retrieval
012200200529     FSEISEDEL0 IF   E           K DISK    INFSR(*PSSR)
012300200529     F                                     RENAME(SEISEDED0:SEISEDEX0)
012400200529      *
012500200529      ** Invalid Security Diary Events by Timestamp and Fromt Office Id
012600200529      ** - for record update
012700200529     FSEISEDEL1 UF   E           K DISK    INFSR(*PSSR)
012800200529     F                                     COMMIT
012900200529                                                                                              CSC011
013000200529      ** API invalid log file                                                                 CSC011
013100200529     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
013200200529     F                                     COMMIT                                             CSC011
013300200529      *                                                                                      260191A
013400200529      ** Position Settlement by Security                                                     260191A
013500200529      *                                                                                      260191A
013600200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)                                      260191A
013700200529     F                                     PREFIX(F3)                                        260191A
013800200529      *
013900200529      ** Hook to enable non-core files to be included
014000200529      /COPY WNCPYSRC,SESEDER001
014100200529      *
014200200529      *****************************************************************
014300200529      /EJECT
014400200529      *****************************************************************
014500200529      *
014600200529      ** +--------------------------------------+
014700200529      ** ¦ Automatically included D-specs       ¦
014800200529      ** ¦ ==============================       ¦
014900200529      ** +--------------------------------------+
015000200529      *
015100200529      ** Standard D-specs
015200200529      ** ================
015300200529      **
015400200529      ** The following /COPY line includes the LDA layout,
015500200529      ** the copyright array definition,
015600200529      ** and the following named constants:
015700200529      **    True       logical = *on (for indicator processing)
015800200529      **    False      logical = *off (for indicator processing)
015900200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016000200529      **                                    handler)
016100200529      ** and the following variables:
016200200529      **    RunBefore  1A (for the PSSR)
016300200529      *
016400200529      /COPY ZACPYSRC,STD_D_SPEC
016500200529      *
016600200529      ** Program Status Data Structure
016700200529      ** =============================
016800200529      ** The following /COPY line includes all the defined fields in the
016900200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
017000200529      *
017100200529      /COPY ZACPYSRC,PSDS
017200200529      *
017300200529      ** The following /COPY line includes all the definitions of the
017400200529      ** appended error arrays, including the named constant giving the size
017500200529      ** of the arrays.
017600200529      *
017700200529      /COPY ZACPYSRC,ERR_ARRAYS
017800200529      *
017900200529      ** +--------------------------------------+
018000200529      ** ¦ End of automatically included D-specs¦
018100200529      ** ¦ =====================================¦
018200200529      ** +--------------------------------------+
018300200529      *
018400200529      *****************************************************************
018500200529      /EJECT
018600200529      *****************************************************************
018700200529      *
018800200529      ** +--------------------------------------+
018900200529      ** ¦ Manually included D-specs            ¦
019000200529      ** ¦ =========================            ¦
019100200529      ** +--------------------------------------+
019200200529      *
019300200529      ** +--------------------------------------+
019400200529      ** ¦ Named constants                      ¦
019500200529      ** ¦ ===============                      ¦
019600200529      ** +--------------------------------------+
019700200529      *
019800200529      ** +--------------------------------------+
019900200529      ** ¦ Arrays and Data Structures           ¦
020000200529      ** ¦ ==========================           ¦
020100200529      ** +--------------------------------------+
020200200529                                                                                             BUG2604
020300200529     D WCmtJobArr      S             10A   DIM(10)                                           BUG2604
020400200529      ** Array for commitment job names                                                      BUG2604
020500200529      *
020600200529     D WEI             S              1    DIM(60)
020700200529      *
020800200529      ** Work array for warning message Ids
020900200529     D WPrvWarnAr      S                   Dim(ArrayMax)
021000200529     D                                     Like(WMsgIDArr)
021100200529      *
021200200529      ** Backup arrays for error messages on 1st screen
021300200529     D FldNameAr1      S                   Dim(ArrayMax)
021400200529     D                                     Like (FldNameArr)
021500200529     D MsgIdAr1        S                   Dim(ArrayMax)
021600200529     D                                     Like (MsgIdArr)
021700200529     D MsgDtaAr1       S                   Dim(ArrayMax)
021800200529     D                                     Like (MsgDtaArr)
021900200529      *
022000200529      ** SE Diary events screen details from incoming transaction
022100200529      ** - screen format
022200200529     D NwDe1ScnFmt   E DS                  EXTNAME(SESEDEPD)
022300200529      *
022400200529      ** SE Diary events for file update - file format
022500200529     D NwDeFilFmt    E DS                  EXTNAME(SEVSEDEPD)
022600200529     D NwDeFilFmt1             1    231                                                       CSE065
022700200529      *
022800200529      ** SE Diary events screen details retrieved from file
022900200529      ** - screen format
023000200529     D CrDe1ScnFmt   E DS                  EXTNAME(SESEDEPD)
023100200529     D                                     PREFIX(O)
023200200529      *
023300200529      ** SE Diary events retrieved from file - file format
023400200529     D CrDeFilFmt    E DS                  EXTNAME(SEDEVD)
023500200529     D CrDeFilFmt1             1    231                                                       CSE065
023600200529      *
023700200529      ** Externally described DS for security details
023800200529     D PSectyd       E DS                  EXTNAME(SECTYD)
023900200529     D                                     PREFIX(D1)
024000200529      *
024100200529      ** SE Diary events screen error indicators
024200200529     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
024300200529      *
024400200529      ** SE Diary Events extra data
024500200529     D PExtData      E DS                  EXTNAME(SESDEXPD)
024600200529      *
024700200529      ** Externally described DS for Bank details
024800200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
024900200529      *
025000200529      ** Externally described DS for Midas Modules details
025100200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
025200200529      *
025300200529      ** Externally described DS for securities trading ICD details
025400200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
025500200529      *
025600200529      ** Externally described DS for API ICD details
025700200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
025800200529      *
025900200529      ** Externally described DS for SAR details
026000200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
026100200529     D SLCD          E                     EXTFLD(LCD)
026200200529      *
026300200529      ** DS for Access Objects - short data structure
026400200529     D DSFDY         E DS                  EXTNAME(DSFDY)
026500200529      *
026600200529      ** DS for Access Objects - long data structure
026700200529     D DSSDY         E DS                  EXTNAME(DSSDY)
026800200529      *
026900200529      ** Backup data structures for screen details
027000200529     D NwDe1ScnFmx   E DS                  EXTNAME(SESEDEPD)
027100200529     D                                     PREFIX(B)
027200200529      *
027300200529      ** Backup data structures for screen error indicators
027400200529     D SEESEDEx      E DS                  EXTNAME(SEESEDEPD)
027500200529     D                                     PREFIX(B)
027600200529                                                                                              CSC011
027700200529      ** Data structure for data area SC24X7                                                  CSC011
027800200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
027900200529                                                                                              CSC011
028000200529      ** Data structure for data area SDSTAT                                                  CSC011
028100200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
028200200529      *
028300200529      ** DS for ZMUSER details
028400200529     D ZMUSER          DS            17
028500200529     D  PUSRID                 1     10
028600200529     D  PDBRN                 11     13
028700200529      *
028800200529     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2604
028900200529     D  ComitJob               4    103                                                      BUG2604
029000200529      ** Midas SC Jobs handling commitment control data area                                 BUG2604
029100200529      *                                                                                      BUG2604
029200200529      ** +--------------------------------------+
029300200529      ** ¦ Declared variables                   ¦
029400200529      ** ¦ ==================                   ¦
029500200529      ** +--------------------------------------+
029600200529      *
029700200529      ** Index for arrays of error messages
029800200529     D IDx             S              3P 0
029900200529      *
030000200529      ** Index for arrays of warning messages
030100200529     D WIDx            S              3P 0
030200200529      *
030300200529      ** Backup index for error messages on 1st screen
030400200529     D ID1             S              3P 0
030500200529      *
030600200529      ** Work index
030700200529     D Ex              S              3P 0
030800200529     D Fx              S              3P 0
030900200529     D WIx             S              3P 0
031000200529      *
031100200529      ** Mode of Operation
031200200529     D PMode           S              6A   INZ('*RPR  ')
031300200529      *
031400200529      ** Response Mode, passed as a constant parameter to the VAL module
031500200529      ** This is always 'S' for Synchronous.
031600200529     D PResponse       S              1A   INZ('S')
031700200529      *
031800200529      ** Fields for getting the starting field number from file
031900200529      ** (parameters to ZAGETFLDNO, plus the offset to the requested field)
032000200529     D PFormat         S             10A   INZ('SESEDEPD')
032100200529     D PField1         S             10A   INZ('DDACTN')
032200200529     D PFieldNo        S              5P 0
032300200529     D WFldOffset1     S              5P 0
032400200529      *
032500200529      ** Parameter fields
032600200529     D PFOTrID         S             20A
032700200529     D PBdSfl          S              1A
032800200529     D PRdSfl          S              1A
032900200529     D PRDNB           S              1A
033000200529     D PEdtFld         S              1A
033100200529     D PErrUp          S              1A
033200200529     D PErrMs          S              7A
033300200529     D POpSel          S              1A
033400200529     D PAcSel          S              1A
033500200529     D PSdsnSel        S             10A
033600200529     D PSdedSel        S              6A
033700200529     D PSdetSel        S              2A
033800200529     D PPayCcy         S              3A
033900200529     D PEvtDno         S              5P 0
034000200529     D PFOTranSel      S             20A
034100200529     D PTmeStpSel      S             26Z
034200200529     D PAmendOk        S              1A
034300200529     D PResetFld       S              1A
034400200529     D PReDsp          S              1A
034500200529     D PPROT           S              1A
034600200529      *
034700200529      ** Parameters for WN0010
034800200529     D PWPGM           S             10A   INZ('SESEDERPR')
034900200529     D PWKEY           S              2A
035000200529     D PWACTION        S              1A
035100200529     D PWRTN           S              7A
035200200529     D PWSPARE         S            256A
035300200529      *
035400200529      ** Incoming and Current data
035500200529     D PIncData        S           2000A
035600200529     D PCurData        S           2000A
035700200529      *
035800200529      ** Parameters for AOSARDR0
035900200529     D PRTCD           S              7A
036000200529     D POPTN           S              7A
036100200529     D PSARD           S              6A
036200200529      *
036300200529      ** Work variables
036400200529     D WProcOnce       S              1A
036500200529     D WScrn           S              1A
036600200529     D WDDSDSN         S             10A
036700200529     D WDDSDED         S              6A
036800200529     D WDDSDET         S              2A
036900200529     D WSUBSE1         S              1A
037000200529     D WRedisplay      S              1A
037100200529      *
037200200529      ** Output screen fields
037300200529     D DDCUCR          S             12A
037400200529     D DDSEXR          S             14A
037500200529      *
037600200529     D KABFIELDID      S                   LIKE(ABFIELDID)
037700200529      *
037800200529      ** Function keys
037900200529     D PEINKE          S              1A
038000200529     D PEINKG          S              1A
038100200529     D PEINKH          S              1A
038200200529     D PEINKJ          S              1A
038300200529     D PEINKL          S              1A
038400200529     D PEINKP          S              1A
038500200529     D PINKC           S              1A
038600200529     D PINKE           S              1A
038700200529     D PINKG           S              1A
038800200529     D PINKH           S              1A
038900200529     D PINKJ           S              1A
039000200529     D PINKL           S              1A
039100200529     D PINKP           S              1A
039200200529      *
039300200529      ** SAR fields
039400200529     D CSE010          S              1A
039500200529     D S01509          S              1A
039600200529     D S01510          S              1A
039700200529     D CAS006          S              1A                                                      CAS006
039800200529     D CSE031          S              1A                                                      CSE031
039900200529     D CSC011          S              1A                                                      CSC011
040000200529     D CSC022          S              1A                                                     BUG2064
040100200529     D CSE072          S              1A                                                      CSE072
040200200529     D CSE065          S              1A                                                      CSE065
040300200529     D CGL031          S              1A                                                      CGL031
040400200529                                                                                              CSC011
040500200529      ** Work field for Message type                                                          CSC011
040600200529     D WMTYP           S                   LIKE(APMTYP)                                       CSC011
040700200529                                                                                              CSC011
040800200529      ** Work field for Date to be passed to RTV module                                       CSC011
040900200529     D PDate           S                   LIKE(BJRDNB)                                       CSC011
041000200529      *
041100200529     DBUG2604          S              1A                                                     BUG2604
041200200529                                                                                             BUG2604
041300200529     D WCommitSkip     S              1A                                                     BUG2604
041400200529      ** Commitment Skip Field                                                               BUG2604
041500200529                                                                                             BUG2604
041600200529      ** +--------------------------------------+
041700200529      ** ¦ /COPYs                               ¦
041800200529      ** ¦ ======                               ¦
041900200529      ** +--------------------------------------+
042000200529      *
042100200529      /COPY QWINDSRC,SESEDEDTA
042200200529      *
042300200529      ** +----------------------------------------+
042400200529      ** ¦ Hook for non-core D-specs (all types)  ¦
042500200529      ** ¦ also any I-specs (if necessary)        ¦
042600200529      ** ¦ =====================================  ¦
042700200529      ** +----------------------------------------+
042800200529      *
042900200529      /COPY WNCPYSRC,SESEDER002
043000200529      *
043100200529      ** +--------------------------------------+
043200200529      ** ¦ End of D-specs                       ¦
043300200529      ** ¦ ==============                       ¦
043400200529      ** +--------------------------------------+
043500200529      *
043600200529      *****************************************************************
043700200529      /EJECT
043800200529      *****************************************************************
043900200529      *
044000200529      ** +--- Start of Main processing -------------------------------+
044100200529      ** ¦                                                            ¦
044200200529      ** ¦ Initial processing is performed automatically.             ¦
044300200529      ** ¦ *INZSR is executed at program activation.                  ¦
044400200529      ** ¦                                                            ¦
044500200529      ** +------------------------------------------------------------+
044600200529      *
044700200529      *****************************************************************
044800200529      * MAIN PROCEDURE                                                *
044900200529      *****************************************************************
045000200529      *
045100200529      /COPY WNCPYSRC,SESEDER003
045200200529      *
045300200529      ** Browse Invalid security diary events details.
045400200529      *
045500200529     C                   IF        WScrn = 'B'
045600200529     C                   EXSR      SRScrnB
045700200529     C                   ENDIF
045800200529      *
045900200529      /COPY WNCPYSRC,SESEDER004
046000200529      *
046100200529      ** Read Next Browse Subfile record.
046200200529      *
046300200529     C                   IF        WScrn = 'R'
046400200529     C                   EXSR      SRRdNBrw
046500200529     C                   ENDIF
046600200529      *
046700200529      /COPY WNCPYSRC,SESEDER005
046800200529      *
046900200529      ** DO WHILE: Process 1st screen.
047000200529      *
047100200529     C                   DOW       WScrn = 'D'
047200200529     C                   EXSR      SRScrnD
047300200529     C                   ENDDO
047400200529      *
047500200529      /COPY WNCPYSRC,SESEDER006
047600200529      *
047700200529      ** Process Window screen.
047800200529      *
047900200529     C                   IF        WScrn = 'W'
048000200529     C                   EXSR      SRScrnW
048100200529     C                   ENDIF
048200200529      *
048300200529      /COPY WNCPYSRC,SESEDER007
048400200529      *
048500200529      ** Process Confirmation screen.
048600200529      *
048700200529     C                   IF        WScrn = 'F'
048800200529     C                   EXSR      SRScrnF
048900200529     C                   ENDIF
049000200529      *
049100200529      /COPY WNCPYSRC,SESEDER008
049200200529      *
049300200529      ** Update files.
049400200529      *
049500200529     C                   IF        WScrn = 'U'
049600200529     C                   EXSR      SRUpdate
049700200529     C                   ENDIF
049800200529      *
049900200529      /COPY WNCPYSRC,SESEDER009
050000200529      *
050100200529      ** Terminate program.
050200200529      *
050300200529     C                   IF        WScrn = 'T'
050400200529     C                   MOVE      *ON           *INLR
050500200529     C                   ENDIF
050600200529      *
050700200529      *****************************************************************
050800200529      /EJECT
050900200529      *****************************************************************
051000200529      *
051100200529      ** Hook to enable non-core subroutines to be included
051200200529      *
051300200529      /COPY WNCPYSRC,SESEDER010
051400200529      *
051500200529      *****************************************************************
051600200529      /EJECT
051700200529      *****************************************************************
051800200529      *                                                               *
051900200529      *  SRScrnB - Browse invalid security diary events details       *
052000200529      *                                                               *
052100200529      *****************************************************************
052200200529     C     SRScrnB       BEGSR
052300200529      *
052400200529      ** Reset Read Next Browse Subfile Record indicator.
052500200529     C                   MOVE      *BLANK        PRDNB
052600200529      *
052700200529      ** Browse invalid security diary events details.
052800200529     C                   CALLB     'SESEDERPB'
052900200529      *                             =========
053000200529      ** INPUT
053100200529      ** =====
053200200529      *
053300200529      ** Return Code
053400200529     C                   PARM      *BLANKS       RetCodeOut
053500200529      *
053600200529      ** Build Subfile
053700200529     C                   PARM      'Y'           PBdSfl
053800200529      *
053900200529      ** Read Subfile Record
054000200529     C                   PARM      *BLANK        PRdSfl
054100200529      *
054200200529      ** Error in update of previous transaction
054300200529     C                   PARM                    PErrUp
054400200529      *
054500200529      ** STANDING DATA
054600200529      ** =============
054700200529      *
054800200529      ** SDBANK - System Runday
054900200529     C                   PARM                    BJMRDT
055000200529      *
055100200529      ** SDBANK - Single Branch Code
055200200529     C                   PARM                    BJSBRC
055300200529      *
055400200529      ** OUTPUT
055500200529      ** ======
055600200529      *
055700200529      ** Error Message
055800200529     C                   PARM                    PErrMs
055900200529      *
056000200529      ** Option Selected
056100200529     C                   PARM                    POpSel
056200200529      *
056300200529      ** Action Selected
056400200529     C                   PARM                    PAcSel
056500200529      *
056600200529      ** Security Shortname Selected
056700200529     C                   PARM                    PSdsnSel
056800200529      *
056900200529      ** Event Date Selected
057000200529     C                   PARM                    PSdedSel
057100200529      *
057200200529      ** Event Type Selected
057300200529     C                   PARM                    PSdetSel
057400200529      *
057500200529      ** Front Office Transaction Id Selected
057600200529     C                   PARM                    PFOTranSel
057700200529      *
057800200529      ** Timestamp of Transaction Selected
057900200529     C                   PARM                    PTmeStpSel
058000200529      *
058100200529      ** Function Key Enabled - F3
058200200529     C                   PARM      '0'           PINKC
058300200529                                                                                              CSC011
058400200529      ** Enhancement CSC011                                                                   CSC011
058500200529     C                   PARM                    CSC011                                       CSC011
058600200529      *
058700200529      ** Reset Update Status of Previous Transaction flag.
058800200529      *
058900200529     C                   EVAL      PERRUP = *BLANK
059000200529      *
059100200529      ** If error occurred, set on external job switch U6.
059200200529      *
059300200529     C                   IF        PErrMs <> *BLANKS
059400200529     C                   MOVE      *ON           *INU6
059500200529     C                   ENDIF
059600200529      *
059700200529      ** Terminate program if F3 was taken in Browse screen or
059800200529      ** if error occurred.  Otherwise, read selected Browse
059900200529      ** Subfile record.
060000200529     C                   IF        PINKC = *ON OR
060100200529     C                             PErrMs <> *BLANKS
060200200529     C                   EXSR      SREndP
060300200529     C                   ELSE
060400200529     C                   EVAL      PRDNB = 'Y'
060500200529     C                   EVAL      WScrn = 'R'
060600200529     C                   ENDIF
060700200529
060800200529     C                   ENDSR
060900200529      *****************************************************************
061000200529      /EJECT
061100200529      *****************************************************************
061200200529      *                                                               *
061300200529      *  SRRdnBrw - Read Next Browse Subfile Record                   *
061400200529      *                                                               *
061500200529      *****************************************************************
061600200529     C     SRRdNBrw      BEGSR
061700200529      *
061800200529      ** Read Next Browse Subfile record.
061900200529     C                   CALLB     'SESEDERPB'
062000200529      *                             =========
062100200529      ** INPUT
062200200529      ** =====
062300200529      *
062400200529      ** Return Code
062500200529     C                   PARM      *BLANKS       RetCodeOut
062600200529      *
062700200529      ** Build Subfile
062800200529     C                   PARM      *BLANK        PBdSfl
062900200529      *
063000200529      ** Read Subfile Record
063100200529     C                   PARM      'Y'           PRdSfl
063200200529      *
063300200529      ** Error in update of previous transaction
063400200529     C                   PARM                    PErrUp
063500200529      *
063600200529      ** STANDING DATA
063700200529      ** =============
063800200529      *
063900200529      ** SDBANK - System Runday
064000200529     C                   PARM                    BJMRDT
064100200529      *
064200200529      ** SDBANK - Single Branch Code
064300200529     C                   PARM                    BJSBRC
064400200529      *
064500200529      ** OUTPUT
064600200529      ** ======
064700200529      *
064800200529      ** Error Message
064900200529     C                   PARM                    PErrMs
065000200529      *
065100200529      ** Option Selected
065200200529     C                   PARM                    POpSel
065300200529      *
065400200529      ** Action Selected
065500200529     C                   PARM                    PAcSel
065600200529      *
065700200529      ** Security Shortname Selected
065800200529     C                   PARM                    PSdsnSel
065900200529      *
066000200529      ** Event Date Selected
066100200529     C                   PARM                    PSdedSel
066200200529      *
066300200529      ** Event Type Selected
066400200529     C                   PARM                    PSdetSel
066500200529      *
066600200529      ** Front Office Transaction Id Selected
066700200529     C                   PARM                    PFOTranSel
066800200529      *
066900200529      ** Timestamp of Transaction Selected
067000200529     C                   PARM                    PTmeStpSel
067100200529      *
067200200529      ** Function Key Enabled - F3
067300200529     C                   PARM      '0'           PINKC
067400200529                                                                                              CSC011
067500200529      ** Enhancement CSC011                                                                   CSC011
067600200529     C                   PARM                    CSC011                                       CSC011
067700200529      *
067800200529      ** Terminate program if F3 was taken within Invalid
067900200529      ** Transaction Deletion function.
068000200529     C                   IF        PINKC = *ON
068100200529     C                   EXSR      SREndP
068200200529     C                   GOTO      ERdNBrw
068300200529     C                   ENDIF
068400200529      *
068500200529      ** Display Browse screen if no invalid diary event read from subfile.
068600200529     C                   IF        POpSel = *BLANK
068700200529     C                   EVAL      WScrn = 'B'
068800200529     C                   GOTO      ERdNBrw
068900200529     C                   ENDIF
069000200529      *
069100200529      ** Clear security diary events details in screen format
069200200529      ** from incoming transaction.
069300200529      *
069400200529     C                   CLEAR                   NwDe1ScnFmt
069500200529      *
069600200529      ** Clear security diary events details in screen format
069700200529      ** retrieved from file.
069800200529      *
069900200529     C                   CLEAR                   CrDe1ScnFmt
070000200529      *
070100200529      ** Validate action code, security shortname, event date and
070200200529      ** event type and retrieve security diary events details.
070300200529      *
070400200529     C                   EVAL      DDACTN = PAcSel
070500200529     C                   EVAL      DDSDSN = PSdsnSel
070600200529     C                   EVAL      DDSDED = PSdedSel
070700200529     C                   EVAL      DDSDET = PSdetSel
070800200529     C                   EVAL      PFOTrID = PFOTranSel
070900200529      *
071000200529      ** If Insert, set Retrieve Mode to '*FRONT' (Access using Front Office
071100200529      ** Id).  Otherwise, if not Insert and Midas security shortname, diary
071200200529      ** event date and diary event type is present, set Retrieve Mode to
071300200529      ** blank(Access using security shortname, event date and event type).
071400200529     C                   IF        DDACTN = 'I'
071500200529
071600200529     C                   EVAL      PMode = '*FRONT'
071700200529
071800200529     C                   ELSE
071900200529
072000200529     C                   IF        DDSDSN = *BLANK AND
072100200529     C                             DDSDED = *BLANK AND
072200200529     C                             DDSDET = *BLANK
072300200529     C                   EVAL      PMode = '*FRONT'
072400200529     C                   ELSE
072500200529     C                   EVAL      PMode = *BLANKS
072600200529     C                   ENDIF
072700200529
072800200529     C                   ENDIF
072900200529
073000200529     C                   EXSR      SRRtvSEDE
073100200529      *
073200200529      ** For the rest of the processing, set Mode of Operation
073300200529      ** to '*RPR  ' for the other modules to process the
073400200529      ** transaction as coming from the repair function.
073500200529     C                   EVAL      PMode = '*RPR  '
073600200529      *
073700200529      ** Move security diary events details retrieved from the master
073800200529      ** database file into the update file record.  If no record has
073900200529      ** been retrieved (like in Insert), fields contain intial values.
074000200529     C**********         EVAL      NwDeFilFmt = CrDeFilFmt                                    CSE065
074100200529     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
074200200529      *                                                                                       CSE065
074300200529     C                   IF        CSE065 = 'Y'                                               CSE065
074400200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
074500200529     C                   ELSE                                                                 CSE065
074600200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
074700200529     C                   ENDIF                                                                CSE065
074800200529      *
074900200529      ** If original security diary events details were retrieved,
075000200529      ** convert security diary events details from file to screen
075100200529      ** format.
075200200529     C                   IF        DDACTN <> 'I' AND
075300200529     C                             RECI <> *BLANK
075400200529
075500200529     C                   EXSR      SRCvtSEDE
075600200529      *
075700200529      ** Save security shortname, event date and event type retrieved from file
075800200529     C                   EVAL      WDDSDSN = DDSDSN
075900200529     C                   EVAL      WDDSDED = DDSDED
076000200529     C                   EVAL      WDDSDET = DDSDET
076100200529      *
076200200529     C                   ENDIF
076300200529      *
076400200529      ** Access invalid security diary events details file with Timestamp and
076500200529      ** Front Office Transaction Id.
076600200529     C     ZATRNKX0      CHAIN     SEISEDEL0                          99
076700200529      *
076800200529      ** If original security diary events details were retrieved,
076900200529      ** restore the security shortname, event date and event
077000200529      ** type retrieved from file.
077100200529      *
077200200529     C                   IF        DDACTN <> 'I' AND
077300200529     C                             RECI <> *BLANK
077400200529     C                   EVAL      DDSDSN = WDDSDSN
077500200529     C                   EVAL      DDSDED = WDDSDED
077600200529     C                   EVAL      DDSDET = WDDSDET
077700200529     C                   ENDIF
077800200529      *
077900200529      ** If Action is Enquire or Delete, overwrite details from
078000200529      ** invalid security diary events details file with the details
078100200529      ** retrieved from the master database file.
078200200529     C                   IF        DDACTN = 'E' AND RECI <> *BLANK OR
078300200529     C                             DDACTN = 'D' AND RECI <> *BLANK
078400200529     C                   MOVE      CrDe1ScnFmt   NwDe1ScnFmt
078500200529     C                   ENDIF
078600200529      *
078700200529      ** Action is amend and original security diary events details
078800200529      ** were retrieved.
078900200529      *
079000200529     C                   IF        DDACTN = 'A' AND RECI <> *BLANK
079100200529      *
079200200529      ** Check for the existence of the replacement character; if this is
079300200529      ** used, only the changed data has been sent, and all occurrences of
079400200529      ** the replacement character must be replaced with the corresponding
079500200529      ** character from the original transaction.
079600200529     C                   IF        GHSUBS <> *BLANK
079700200529
079800200529     C     GHSUBS        SCAN      NwDE1ScnFmt                            99
079900200529     C                   IF        *IN99 = *ON
080000200529     C                   MOVE      'Y'           WSUBSE1
080100200529     C                   ELSE
080200200529     C                   MOVE      'N'           WSUBSE1
080300200529     C                   ENDIF
080400200529      *
080500200529      ** Substitution character is present in the incoming transaction.
080600200529     C                   IF        WSUBSE1 = 'Y'
080700200529      *
080800200529      ** Do data substitution.
080900200529     C                   EXSR      SRDtaSubs
081000200529
081100200529     C                   ENDIF
081200200529
081300200529     C                   ENDIF
081400200529
081500200529     C                   ENDIF
081600200529      *
081700200529      ** If errors exist for action code , security shortname, event date
081800200529      ** or event type, blank out Action Code so input cannot proceed.
081900200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N'
082000200529     C                             OR OKSDED = 'N' OR OKSDET = 'N'
082100200529     C                   EVAL      DDACTN = *BLANK
082200200529     C                   ENDIF
082300200529      *
082400200529      ** Save screen details.
082500200529     C                   EVAL      NwDE1ScnFmx = NwDE1ScnFmt
082600200529      *
082700200529      ** Send the security diary events details validation error messages
082800200529      ** to detail screen.
082900200529     C                   EXSR      SRSndMD
083000200529      *
083100200529      ** Initialise work variable for defaulting.
083200200529      *
083300200529     C                   EVAL      WProcOnce = *BLANK
083400200529      *
083500200529      ** Display detail screen.
083600200529     C                   EVAL      WScrn = 'D'
083700200529
083800200529     C     ERdNBrw       ENDSR
083900200529      *****************************************************************
084000200529      /EJECT
084100200529      *****************************************************************
084200200529      *                                                               *
084300200529      *  SRScrnD - Process Detail Screen                              *
084400200529      *                                                               *
084500200529      *****************************************************************
084600200529     C     SRScrnD       BEGSR
084700200529      *
084800200529      ** If Action Code is Insert or Amend and Option selected is 'U',
084900200529      ** enable Detail fields on screen (all fields on detail screen
085000200529      ** except Initial screen fields: Action Code, Security Shortname,
085100200529      ** Event Date and Event Type).  Also, enable F5=Refresh.
085200200529     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
085300200529     C                             DDACTN = 'A' AND POpSel = 'U'
085400200529     C                   EVAL      PEdtFld = 'Y'
085500200529     C                   EVAL      PEINKE = 'Y'
085600200529     C                   ELSE
085700200529     C                   EVAL      PEdtFld = 'N'
085800200529     C                   EVAL      PEINKE = 'N'
085900200529     C                   ENDIF
086000200529      *
086100200529      ** If Action is Delete and Option selected is 'U',
086200200529      ** enable F10=Delete.
086300200529     C                   IF        DDACTN = 'D' AND POpSel = 'U'
086400200529     C                   EVAL      PEINKJ = 'Y'
086500200529     C                   ELSE
086600200529     C                   EVAL      PEINKJ = 'N'
086700200529     C                   ENDIF
086800200529      *
086900200529      ** Process defaulting of detail screen details before going to detail screen.
087000200529      *
087100200529     C                   EXSR      SRDefScnD
087200200529      *
087300200529      ** Display detail screen.
087400200529     C                   CALLB     'SESEDE1DP'
087500200529      *                             =========
087600200529      *
087700200529      ** INPUT
087800200529      ** =====
087900200529      *
088000200529      ** Return Code
088100200529     C                   PARM      *BLANKS       RetCodeOut
088200200529      *
088300200529      ** SE Diary events screen details from incoming transaction
088400200529      ** - screen format
088500200529     C                   PARM                    NwDE1ScnFmt
088600200529      *
088700200529      ** SE Diary events retrieved from file - file format
088800200529     C                   PARM                    CrDEFilFmt
088900200529                                                                                              CAS006
089000200529      ** Externally described DS for Security details                                         CAS006
089100200529     C                   PARM                    PSectyd                                      CAS006
089200200529      *
089300200529      ** Cumulative coupon rate
089400200529     C                   PARM                    DDCUCR
089500200529      *
089600200529      ** Current exchange rate
089700200529     C                   PARM                    DDSEXR
089800200529      *
089900200529      ** Processing type from PF/INVTPD
090000200529     C                   PARM                    PPROT
090100200529      *
090200200529      ** Enable detail fields indicator
090300200529     C                   PARM                    PEDtFld
090400200529      *
090500200529      ** Enable Function Keys
090600200529      ** KE = Command Key 05 = Refresh
090700200529      ** KG = Command Key 07 = Read Previous
090800200529      ** KH = Command Key 08 = Read Next
090900200529      ** KJ = Command Key 10 = Delete
091000200529      ** KL = Command Key 12 = Cancel
091100200529      ** KP = Command Key 15 = Browse
091200200529     C                   PARM                    PEINKE
091300200529     C                   PARM      'N'           PEINKG
091400200529     C                   PARM      'N'           PEINKH
091500200529     C                   PARM                    PEINKJ
091600200529     C                   PARM      'Y'           PEINKL
091700200529     C                   PARM      'N'           PEINKP
091800200529      *
091900200529      ** Security Diary Event 1st screen error indicators
092000200529     C                   PARM                    SEESEDE
092100200529      *
092200200529      ** Error fields/message IDs/message data (arrays) from/to caller
092300200529     C                   PARM                    FldNameArr
092400200529     C                   PARM                    MsgIdArr
092500200529     C                   PARM                    MsgDtaArr
092600200529      *
092700200529      ** Warning fields/message Ids/message data (arrays) from/to
092800200529      ** caller
092900200529     C                   PARM                    WFldNamArr
093000200529     C                   PARM                    WMsgIdArr
093100200529     C                   PARM                    WMsgDtaArr
093200200529      *
093300200529      ** Write Screen with No Read Indicator
093400200529     C                   PARM      'N'           WriteOnly
093500200529      *
093600200529      ** STANDING DATA
093700200529      ** =============
093800200529      *
093900200529      ** SDBANK - System run date
094000200529     C                   PARM                    BJMRDT
094100200529      *
094200200529      ** MMODF - Strategic risk management indicator
094300200529     C                   PARM                    RMFL
094400200529      *
094500200529      ** SWITCHABLE FEATURES
094600200529      ** ===================
094700200529      *
094800200529      ** Value currency to be currency of issuer payments
094900200529     C                   PARM                    S01509
095000200529      *
095100200529      ** Dividend payments
095200200529     C                   PARM                    S01510
095300200529                                                                                              CAS006
095400200529      ** Hedge Accounting Phase B                                                             CAS006
095500200529     C                   PARM                    CAS006                                       CAS006
095600200529                                                                                              CSE065
095700200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
095800200529     C                   PARM                    CSE065                                       CSE065
095900200529                                                                                              CSE065
096000200529                                                                                              CGL031
096100200529      ** Taxation on Savings Income                                                           CGL031
096200200529                                                                                              CGL031
096300200529     C                   PARM                    CGL031                                       CGL031
096400200529      *
096500200529      ** OUTPUT
096600200529      ** ======
096700200529      *
096800200529      ** Function Keys Enabled
096900200529      ** KC = Command Key 03 = Exit
097000200529      ** KE = Command Key 05 = Refresh
097100200529      ** KG = Command Key 07 = Read Previous
097200200529      ** KH = Command Key 08 = Read Next
097300200529      ** KJ = Command Key 10 = Delete
097400200529      ** KL = Command Key 12 = Cancel
097500200529      ** KP = Command Key 15 = Browse
097600200529     C                   PARM      '0'           PINKC
097700200529     C                   PARM      '0'           PINKE
097800200529     C                   PARM      '0'           PINKG
097900200529     C                   PARM      '0'           PINKH
098000200529     C                   PARM      '0'           PINKJ
098100200529     C                   PARM      '0'           PINKL
098200200529     C                   PARM      '0'           PINKP
098300200529      *
098400200529      ** Save Warning Message Ids array of detail screen.
098500200529     C                   MOVEA     WMsgIDArr     WPrvWarnAr
098600200529      *
098700200529      ** Reset error fields.
098800200529     C                   EXSR      SRResetErr
098900200529      *
099000200529     C                   SELECT
099100200529      *
099200200529      ** F3 - end program.
099300200529     C                   WHEN      PINKC = *ON
099400200529     C                   EXSR      SREndP
099500200529      *
099600200529      ** F5 - refresh detail screen.
099700200529     C                   WHEN      PINKE = *ON
099800200529     C                   EVAL      NwDE1ScnFmt  = NwDE1ScnFmx
099900200529     C                   EVAL      SEESEDE = SEESEDEx
100000200529     C                   EVAL      FldNameArr = FldNameAr1
100100200529     C                   EVAL      MsgIdArr = MsgIdAr1
100200200529     C                   EVAL      MsgDtaArr = MsgDtaAr1
100300200529     C                   EVAL      IDx = ID1
100400200529      *
100500200529      ** F10 - delete record.  Proceed to update of files.
100600200529     C                   WHEN      PINKJ = *ON
100700200529     C                   EVAL      WScrn = 'U'
100800200529      *
100900200529      ** F12 - cancel.  Read Next Subfile record or display
101000200529      ** Browse screen.
101100200529     C                   WHEN      PINKL = *ON
101200200529
101300200529     C                   IF        PRDNB = 'Y'
101400200529     C                   EVAL      WScrn = 'R'
101500200529     C                   ELSE
101600200529     C                   EVAL      WScrn = 'B'
101700200529     C                   ENDIF
101800200529      *
101900200529      ** If Windows processing is on, clear any possible updates
102000200529      ** in Window function.
102100200529     C                   IF        BGWDPR = 'Y'
102200200529     C                   If        (CSC022 <> 'Y')                                           BUG2604
102300200529     C                   ROLBK
102400200529     C                   Else                                                                BUG2604
102500200529     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
102600200529     C                   ROLBK                                                               BUG2604
102700200529     C                   Else                                                                BUG2604
102800200529     C                   Seton                                        U7U8                   BUG2604
102900200529     C                   Endif                                                               BUG2604
103000200529     C                   Endif                                                               BUG2604
103100200529     C                   ENDIF
103200200529      *
103300200529      ** Enter key was pressed.
103400200529     C                   OTHER
103500200529      *
103600200529      ** If Action is Insert or Amend and Option selected is 'U',
103700200529      ** validate input to 1st screen.
103800200529     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
103900200529     C                             DDACTN = 'A' AND POpSel = 'U'
104000200529     C                   EXSR      SRValD
104100200529     C                   GOTO      EScrnD
104200200529     C                   ENDIF
104300200529      *
104400200529      ** If Windows processing is on and errors do not exist
104500200529      ** on detail screen, perform window processing.
104600200529      *
104700200529     C                   IF        BGWDPR = 'Y' AND
104800200529     C                             ID1 = 0
104900200529     C                   EVAL      WScrn = 'W'
105000200529     C                   GOTO      EScrnD
105100200529     C                   ENDIF
105200200529      *
105300200529      ** If errors exist on detail screen, read next subfile
105400200529      ** record or display browse screen instead.
105500200529      *
105600200529     C                   IF        PRDNB = 'Y'
105700200529     C                   EVAL      WScrn = 'R'
105800200529     C                   ELSE
105900200529     C                   EVAL      WScrn = 'B'
106000200529     C                   ENDIF
106100200529
106200200529     C                   ENDSL
106300200529
106400200529     C     EScrnD        ENDSR
106500200529      *****************************************************************
106600200529      /EJECT
106700200529      *****************************************************************
106800200529      *                                                               *
106900200529      *  SRDefScnD - Default fields in detail screen                  *
107000200529      *                                                               *
107100200529      *****************************************************************
107200200529     C     SRDefScnD     BEGSR
107300200529
107400200529     C     WProcOnce     IFEQ      *BLANK
107500200529
107600200529     C                   CALLB     'SESEDE1DT'
107700200529      *                             =========
107800200529      *
107900200529      ** INPUT
108000200529      ** =====
108100200529      *
108200200529      ** Return code
108300200529     C                   PARM      *BLANKS       RetCodeOut
108400200529      *
108500200529      ** SE Diary events retrieved from file - file format
108600200529     C                   PARM                    CrDEFilFmt
108700200529      *
108800200529      ** Externally described DS for security details
108900200529     C                   PARM                    PSectyd
109000200529      *
109100200529      ** Event date (Day number)
109200200529     C                   PARM                    PEvtDno
109300200529      *
109400200529      ** STANDING DATA
109500200529      ** =============
109600200529      *
109700200529      ** SDBANK - Date format indicator
109800200529     C                   PARM                    BJDFIN
109900200529      *
110000200529      ** MMODF  - Strategic risk management indicator
110100200529     C                   PARM                    RMFL
110200200529      *
110300200529      ** SWITCHABLE FEATURES
110400200529      ** ===================
110500200529      *
110600200529      ** Dividend payments
110700200529     C                   PARM                    S01510
110800200529      *
110900200529      ** Value currency to be currency of issuer payments
111000200529     C                   PARM                    S01509
111100200529                                                                                              CSE065
111200200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
111300200529     C                   PARM                    CSE065                                       CSE065
111400200529                                                                                              CSE065
111500200529      *                                                                                       CGL031
111600200529      ** Taxation of Savings Income                                                           CGL031
111700200529     C                   PARM                    CGL031                                       CGL031
111800200529      *
111900200529      ** OUTPUT
112000200529      ** ======
112100200529      *
112200200529      ** SE Diary events screen details from incoming transaction
112300200529      ** - screen format
112400200529     C                   PARM                    NwDE1ScnFmt
112500200529      *
112600200529      ** Pay currency
112700200529     C                   PARM                    PPayCcy
112800200529      *
112900200529      ** Cumulative coupon rate
113000200529     C                   PARM                    DDCUCR
113100200529      *
113200200529      ** Current exchange rate
113300200529     C                   PARM                    DDSEXR
113400200529
113500200529     C                   ENDIF
113600200529      *
113700200529      ** Set default variable to 'Y' to bypass defaulting the
113800200529      ** second time around.
113900200529      *
114000200529     C                   EVAL      WProcOnce = 'Y'
114100200529
114200200529     C                   ENDSR
114300200529      *****************************************************************
114400200529      /EJECT
114500200529      *****************************************************************
114600200529      *                                                               *
114700200529      *  SRValD - Validate input to detail screen.                    *
114800200529      *                                                               *
114900200529      *****************************************************************
115000200529     C     SRValD        BEGSR
115100200529      *
115200200529      ** Validate whether non-amendable fields have been amended.
115300200529      *
115400200529     C                   CALLB     'SESEDE1MD'
115500200529      *                             =========
115600200529      ** INPUT
115700200529      ** =====
115800200529      *
115900200529      ** Return Code
116000200529     C                   PARM      *BLANKS       RetCodeOut
116100200529      *
116200200529      ** SE Diary events screen details from incoming transaction
116300200529      ** - screen format
116400200529     C                   PARM                    NwDE1ScnFmt
116500200529      *
116600200529      ** SE Diary events screen details retrieved from file
116700200529      ** - screen format
116800200529     C                   PARM                    CrDE1ScnFmt
116900200529      *
117000200529      ** SE Diary events retrieved from file - file format
117100200529     C                   PARM                    CrDEFilFmt
117200200529      *
117300200529      ** Reset of Fields in error required (Y/N)
117400200529     C                   PARM      'Y'           PResetFld
117500200529      *
117600200529      ** Pay currency
117700200529     C                   PARM                    PPayCcy
117800200529      *
117900200529      ** STANDING DATA
118000200529      ** =============
118100200529      *
118200200529      ** MMODF - Strategic risk management indicator
118300200529     C                   PARM                    RMFL
118400200529      *
118500200529      ** SWITCHABLE FEATURES
118600200529      ** ===================
118700200529      *
118800200529      ** Value currency to be currency of issuer payments
118900200529     C                   PARM                    S01509
119000200529      *
119100200529      ** Dividend payments
119200200529     C                   PARM                    S01510
119300200529                                                                                              CAS006
119400200529      ** Hedge Accounting Phase B                                                             CAS006
119500200529     C                   PARM                    CAS006                                       CAS006
119600200529      *
119700200529      ** OUTPUT
119800200529      ** ======
119900200529      *
120000200529      ** Error fields/message IDs/message data (arrays) from/to caller
120100200529     C                   PARM                    FldNameArr
120200200529     C                   PARM                    MsgIdArr
120300200529     C                   PARM                    MsgDtaArr
120400200529      *
120500200529      ** Array index (3P0) from/to caller
120600200529     C                   PARM                    IDx
120700200529      *
120800200529      ** SE Diary events screen error indicators
120900200529     C                   PARM                    SEESEDE
121000200529      *
121100200529      ** OK Amendments field
121200200529     C                   PARM                    PAmendOK
121300200529      *
121400200529      ** Validate entries made on the screen.
121500200529      *
121600200529     C                   CALLB     'SESEDE1VL'
121700200529      *                             =========
121800200529      ** INPUT
121900200529      ** =====
122000200529      *
122100200529      ** Return code
122200200529     C                   PARM      *BLANKS       RetCodeOut
122300200529      *
122400200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
122500200529      ** Mode = '      ' (Not Front Office Transaction Interface)
122600200529      ** Mode = '*RPR  ' (Repair Function)
122700200529      ** Mode = '*SIN  ' (Screen Input Function)
122800200529     C                   PARM                    PMode
122900200529      *
123000200529      ** Response Mode
123100200529     C                   PARM                    PResponse
123200200529      *
123300200529      ** SE Diary Events screen details from incoming
123400200529      ** transaction - screen format
123500200529     C                   PARM                    NwDE1ScnFmt
123600200529      *
123700200529      ** Security Diary Events retrieved from file - file format
123800200529     C                   PARM                    CrDEFilFmt
123900200529      *
124000200529      ** Externally described DS for security details
124100200529     C                   PARM                    PSectyd
124200200529      *
124300200529      ** Processing type from PF/INVTPD
124400200529     C                   PARM                    PPROT
124500200529      *
124600200529      ** Event date (Day number)
124700200529     C                   PARM                    PEvtDno
124800200529      *
124900200529      ** STANDING DATA
125000200529      ** =============
125100200529      *
125200200529      ** SDBANK - Date format indicator
125300200529     C                   PARM                    BJDFIN
125400200529      *
125500200529      ** MMODF - Strategic risk management indicator
125600200529     C                   PARM                    RMFL
125700200529      *
125800200529      ** SWITCHABLE FEATURES
125900200529      ** ===================
126000200529      *
126100200529      ** SE Transactions Enhancement
126200200529     C                   PARM                    CSE010
126300200529      *
126400200529      ** Value CCY to be CCY of Issuer Payment
126500200529     C                   PARM                    S01509
126600200529      *
126700200529      ** Dividend Payments Base on EX-Date
126800200529     C                   PARM                    S01510
126900200529                                                                                              CAS006
127000200529      ** Hedge Accounting Phase B                                                             CAS006
127100200529     C                   PARM                    CAS006                                       CAS006
127200200529                                                                                              CSE072
127300200529      ** Brazilian C Bonds                                                                    CSE072
127400200529     C                   PARM                    CSE072                                       CSE072
127500200529                                                                                              CSE065
127600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
127700200529     C                   PARM                    CSE065                                       CSE065
127800200529                                                                                              CGL031
127900200529      ** Taxation on Savings Income                                                           CGL031
128000200529                                                                                              CGL031
128100200529     C                   PARM                    CGL031                                       CGL031
128200200529      *
128300200529      ** OUTPUT
128400200529      ** ======
128500200529      *
128600200529      ** Error fields/message IDs/message data (arrays) from/to caller
128700200529     C                   PARM                    FldNameArr
128800200529     C                   PARM                    MsgIdArr
128900200529     C                   PARM                    MsgDtaArr
129000200529      *
129100200529      ** Array index (3P0) from/to caller
129200200529     C                   PARM                    Idx
129300200529      *
129400200529      ** Warning flds/message IDs/message data (arrays) from/to caller
129500200529     C                   PARM                    WFldNamArr
129600200529     C                   PARM                    WMsgIdArr
129700200529     C                   PARM                    WMsgDtaArr
129800200529      *
129900200529      ** Array index (3P0) from/to caller
130000200529     C                   PARM                    WIdx
130100200529      *
130200200529      ** SE Diary Events screen error indicators
130300200529     C                   PARM                    SEESEDE
130400200529      *
130500200529      ** SE Diary Events for file update - file format
130600200529     C                   PARM                    NwDEFilFmt
130700200529      *
130800200529      ** Redisplay screen
130900200529     C                   PARM      *BLANK        PReDsp
131000200529
131100200529     C                   EVAL      WRedisplay = *BLANK
131200200529      *
131300200529      ** If no errors occurred during validation of fields on detail
131400200529      ** screen, check if there are warnings which have not been
131500200529      ** displayed yet.
131600200529     C                   IF        IDx = 0
131700200529      *
131800200529     C                   Z-ADD     1             WIx
131900200529      *
132000200529     C                   DOW       WiX <= WIDx AND WRedisplay = *BLANK
132100200529
132200200529     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
132300200529     C                   EVAL      WRedisplay = 'Y'
132400200529     C                   ELSE
132500200529     C                   EVAL      WIx =WIx + 1
132600200529     C                   ENDIF
132700200529
132800200529     C                   ENDDO
132900200529
133000200529     C                   IF        WRedisplay <> 'Y'
133100200529     C                   EXSR      SRResetErr
133200200529     C                   ENDIF
133300200529      *
133400200529     C                   ENDIF
133500200529      *
133600200529      ** Redisplay detail screen if there are errors or if there
133700200529      ** are warnings which have not been displayed yet.
133800200529      *
133900200529     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
134000200529     C                             PReDsp = 'Y'
134100200529     C                   GOTO      EValD
134200200529     C                   ENDIF
134300200529      *
134400200529      ** If Windows processing is on, display Window screen.
134500200529     C                   IF        BGWDPR = 'Y'
134600200529     C                   EVAL      WScrn = 'W'
134700200529     C                   ELSE
134800200529     C                   EVAL      WScrn = 'F'
134900200529     C                   ENDIF
135000200529
135100200529     C     EValD         ENDSR
135200200529      *****************************************************************
135300200529      /EJECT
135400200529      *****************************************************************
135500200529      *                                                               *
135600200529      *  SRScrnW - Process Window Screen                              *
135700200529      *                                                               *
135800200529      *****************************************************************
135900200529     C     SRScrnW       BEGSR
136000200529      *
136100200529      ** Write out screen to remove error messages.
136200200529      *
136300200529     C                   CALLB     'SESEDE1DP'
136400200529      *                             =========
136500200529      ** INPUT
136600200529      ** =====
136700200529      *
136800200529      ** Return Code
136900200529     C                   PARM      *BLANKS       RetCodeOut
137000200529      *
137100200529      ** SE Diary events screen details from incoming transaction
137200200529      ** - screen format
137300200529     C                   PARM                    NwDE1ScnFmt
137400200529      *
137500200529      ** SE Diary events retrieved from file - file format
137600200529     C                   PARM                    CrDEFilFmt
137700200529                                                                                              CAS006
137800200529      ** Externally described DS for Security details                                         CAS006
137900200529     C                   PARM                    PSectyd                                      CAS006
138000200529      *
138100200529      ** Cumulative coupon rate
138200200529     C                   PARM                    DDCUCR
138300200529      *
138400200529      ** Current exchange rate
138500200529     C                   PARM                    DDSEXR
138600200529      *
138700200529      ** Processing type from PF/INVTPD
138800200529     C                   PARM                    PPROT
138900200529      *
139000200529      ** Enable Detail Fields Indicator
139100200529      ** Enable Key Fields Indicator
139200200529     C                   PARM                    PEDtFld
139300200529      *
139400200529      ** Enable Function Keys
139500200529      ** KE = Command Key 05 = Refresh
139600200529      ** KG = Command Key 07 = Read Previous
139700200529      ** KH = Command Key 08 = Read Next
139800200529      ** KJ = Command Key 10 = Delete
139900200529      ** KJ = Command Key 12 = Cancel
140000200529      ** KP = Command Key 15 = Browse
140100200529     C                   PARM                    PEINKE
140200200529     C                   PARM                    PEINKG
140300200529     C                   PARM                    PEINKH
140400200529     C                   PARM                    PEINKJ
140500200529     C                   PARM                    PEINKL
140600200529     C                   PARM                    PEINKP
140700200529      *
140800200529      ** SE Diary events screen error indicators
140900200529     C                   PARM                    SEESEDE
141000200529      *
141100200529      ** Error fields/message IDs/message data (arrays) from/to caller
141200200529     C                   PARM                    FldNameArr
141300200529     C                   PARM                    MsgIdArr
141400200529     C                   PARM                    MsgDtaArr
141500200529      *
141600200529      ** Warning fields/message Ids/message data (arrays) from/to
141700200529      ** caller
141800200529     C                   PARM                    WFldNamArr
141900200529     C                   PARM                    WMsgIdArr
142000200529     C                   PARM                    WMsgDtaArr
142100200529      *
142200200529      ** Write Screen with No Read Indicator
142300200529     C                   PARM      'Y'           WriteOnly
142400200529      *
142500200529      ** STANDING DATA
142600200529      ** =============
142700200529      *
142800200529      ** SDBANK - System run date
142900200529     C                   PARM                    BJMRDT
143000200529      *
143100200529      ** MMODF - Strategic risk management indicator
143200200529     C                   PARM                    RMFL
143300200529      *
143400200529      ** SWITCHABLE FEATURES
143500200529      ** ===================
143600200529      *
143700200529      ** Value currency to be currency of issuer payments
143800200529     C                   PARM                    S01509
143900200529      *
144000200529      ** Dividend payments
144100200529     C                   PARM                    S01510
144200200529                                                                                              CAS006
144300200529      ** Hedge Accounting Phase B                                                             CAS006
144400200529     C                   PARM                    CAS006                                       CAS006
144500200529                                                                                              CSE065
144600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
144700200529     C                   PARM                    CSE065                                       CSE065
144800200529                                                                                              CGL031
144900200529      ** Taxation on Savings Income                                                           CGL031
145000200529                                                                                              CGL031
145100200529     C                   PARM                    CGL031                                       CGL031
145200200529      *
145300200529      ** OUTPUT
145400200529      ** ======
145500200529      *
145600200529      ** Function Keys Enabled
145700200529      ** KC = Command Key 03 = Exit
145800200529      ** KE = Command Key 05 = Refresh
145900200529      ** KG = Command Key 07 = Read Previous
146000200529      ** KH = Command Key 08 = Read Next
146100200529      ** KJ = Command Key 10 = Delete
146200200529      ** KL = Command Key 12 = Cancel
146300200529      ** KP = Command Key 15 = Browse
146400200529     C                   PARM      '0'           PINKC
146500200529     C                   PARM      '0'           PINKE
146600200529     C                   PARM      '0'           PINKG
146700200529     C                   PARM      '0'           PINKH
146800200529     C                   PARM      '0'           PINKJ
146900200529     C                   PARM      '0'           PINKL
147000200529     C                   PARM      '0'           PINKP
147100200529      *
147200200529      /COPY WNCPYSRC,SESEDEMV1
147300200529      *
147400200529      ** Call Window Manager.
147500200529     C                   CALL      'WN0010'
147600200529     C                   PARM      'SESEDERPR'   PWPGM
147700200529     C                   PARM      *BLANKS       PWKEY
147800200529     C                   PARM      DDACTN        PWACTION
147900200529     C                   PARM                    DATA
148000200529     C                   PARM      *BLANKS       PWRTN
148100200529     C                   PARM                    PWSPARE
148200200529
148300200529     C                   SELECT
148400200529      *
148500200529      ** F3 - end program.
148600200529     C                   WHEN      PWRTN = 'Y2U9999'
148700200529     C                   EXSR      SREndP
148800200529      *
148900200529      ** F12 - cancel.  Display detail screen.
149000200529     C                   WHEN      PWRTN = 'USR0790'
149100200529     C                   EVAL      WScrn = 'D'
149200200529      *
149300200529      ** Enter key was pressed.
149400200529     C                   OTHER
149500200529      *
149600200529      ** Action is Amend or Insert - proceed to confirmation screen.
149700200529     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
149800200529     C                             DDACTN = 'A' AND POpSel = 'U'
149900200529     C                   EVAL      WScrn = 'F'
150000200529     C                   ELSE
150100200529      *
150200200529      ** Read next browse subfile record if pending option still exist.
150300200529      ** Otherwise, display browse screen
150400200529     C                   IF        PRDNB = 'Y'
150500200529     C                   EVAL      WScrn = 'R'
150600200529     C                   ELSE
150700200529     C                   EVAL      WScrn = 'B'
150800200529     C                   ENDIF
150900200529
151000200529     C                   ENDIF
151100200529
151200200529     C                   ENDSL
151300200529
151400200529     C                   ENDSR
151500200529      *****************************************************************
151600200529      /EJECT
151700200529      *****************************************************************
151800200529      *                                                               *
151900200529      *  SRScrnF - Process Confirmation Screen                        *
152000200529      *                                                               *
152100200529      *****************************************************************
152200200529     C     SRScrnF       BEGSR
152300200529      *
152400200529      ** Reset error fields, specifically arrays for warning messages.
152500200529     C                   EXSR      SRResetErr
152600200529      *
152700200529      ** Entries are valid or only warnings exist.  Output message
152800200529      ** "Press ENTER to apply transaction to database or F12 to change.".
152900200529      *
153000200529     C                   EVAL      WFldNamArr(1) = '*ANY'
153100200529     C                   EVAL      WMsgIdArr(1) = 'SEA0302'
153200200529      *
153300200529      ** Display Confirmation screen.
153400200529     C                   CALLB     'SESEDE1DP'
153500200529      *                             =========
153600200529      ** INPUT
153700200529      ** =====
153800200529      *
153900200529      ** Return Code
154000200529     C                   PARM      *BLANKS       RetCodeOut
154100200529      *
154200200529      ** SE Diary events screen details from incoming transaction
154300200529      ** - screen format
154400200529     C                   PARM                    NwDE1ScnFmt
154500200529      *
154600200529      ** SE Diary events retrieved from file - file format
154700200529     C                   PARM                    CrDEFilFmt
154800200529                                                                                              CAS006
154900200529      ** Externally described DS for Security details                                         CAS006
155000200529     C                   PARM                    PSectyd                                      CAS006
155100200529      *
155200200529      ** Cumulative coupon rate
155300200529     C                   PARM                    DDCUCR
155400200529      *
155500200529      ** Current exchange rate
155600200529     C                   PARM                    DDSEXR
155700200529      *
155800200529      ** Processing type from PF/INVTPD
155900200529     C                   PARM                    PPROT
156000200529      *
156100200529      ** Enable Detail Fields Indicator
156200200529     C                   PARM      'N'           PEDtFld
156300200529      *
156400200529      ** Enable Function Keys
156500200529      ** KE = Command Key 05 = Refresh
156600200529      ** KG = Command Key 07 = Read Previous
156700200529      ** KH = Command Key 08 = Read Next
156800200529      ** KJ = Command Key 10 = Delete
156900200529      ** KL = Command Key 12 = Cancel
157000200529      ** KP = Command Key 15 = Browse
157100200529     C                   PARM      'N'           PEINKE
157200200529     C                   PARM      'N'           PEINKG
157300200529     C                   PARM      'N'           PEINKH
157400200529     C                   PARM      'N'           PEINKJ
157500200529     C                   PARM      'Y'           PEINKL
157600200529     C                   PARM      'N'           PEINKP
157700200529      *
157800200529      ** SE Diary events screen error indicators
157900200529     C                   PARM                    SEESEDE
158000200529      *
158100200529      ** Error fields/message IDs/message data (arrays) from/to caller
158200200529     C                   PARM                    FldNameArr
158300200529     C                   PARM                    MsgIdArr
158400200529     C                   PARM                    MsgDtaArr
158500200529      *
158600200529      ** Warning fields/message Ids/message data (arrays) from/to
158700200529      ** caller
158800200529     C                   PARM                    WFldNamArr
158900200529     C                   PARM                    WMsgIdArr
159000200529     C                   PARM                    WMsgDtaArr
159100200529      *
159200200529      ** Write Screen with No Read Indicator
159300200529     C                   PARM      'N'           WriteOnly
159400200529      *
159500200529      ** STANDING DATA
159600200529      ** =============
159700200529      *
159800200529      ** SDBANK - System run date
159900200529     C                   PARM                    BJMRDT
160000200529      *
160100200529      ** MMODF - Strategic risk management indicator
160200200529     C                   PARM                    RMFL
160300200529      *
160400200529      ** SWITCHABLE FEATURES
160500200529      ** ===================
160600200529      *
160700200529      ** Value currency to be currency of issuer payments
160800200529     C                   PARM                    S01509
160900200529      *
161000200529      ** Dividend payments
161100200529     C                   PARM                    S01510
161200200529                                                                                              CAS006
161300200529      ** Hedge Accounting Phase B                                                             CAS006
161400200529     C                   PARM                    CAS006                                       CAS006
161500200529                                                                                              CSE065
161600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
161700200529     C                   PARM                    CSE065                                       CSE065
161800200529                                                                                              CGL031
161900200529      ** Taxation on Savings Income                                                           CGL031
162000200529                                                                                              CGL031
162100200529     C                   PARM                    CGL031                                       CGL031
162200200529      *
162300200529      ** OUTPUT
162400200529      ** ======
162500200529      *
162600200529      ** Function Keys Enabled
162700200529      ** KC = Command Key 03 = Exit
162800200529      ** KE = Command Key 05 = Refresh
162900200529      ** KG = Command Key 07 = Read Previous
163000200529      ** KH = Command Key 08 = Read Next
163100200529      ** KJ = Command Key 10 = Delete
163200200529      ** KL = Command Key 12 = Cancel
163300200529      ** KP = Command Key 15 = Browse
163400200529     C                   PARM      '0'           PINKC
163500200529     C                   PARM      '0'           PINKE
163600200529     C                   PARM      '0'           PINKG
163700200529     C                   PARM      '0'           PINKH
163800200529     C                   PARM      '0'           PINKJ
163900200529     C                   PARM      '0'           PINKL
164000200529     C                   PARM      '0'           PINKP
164100200529      *
164200200529      ** Save warning message ids array of this screen.
164300200529      *
164400200529     C                   MOVEA     WMsgIDArr     WPrvWarnAr
164500200529      *
164600200529      ** Reset error fields.
164700200529     C                   EXSR      SRResetErr
164800200529      *
164900200529     C                   SELECT
165000200529      *
165100200529      ** F3 - end program.
165200200529     C                   WHEN      PINKC = *ON
165300200529     C                   EXSR      SREndP
165400200529      *
165500200529      ** F12 - cancel.  Display 1st screen.
165600200529     C                   WHEN      PINKL = *ON
165700200529     C                   EVAL      WScrn  = 'D'
165800200529      *
165900200529      ** Enter key was pressed.  Update files.
166000200529     C                   OTHER
166100200529     C                   EVAL      WScrn = 'U'
166200200529
166300200529     C                   ENDSL
166400200529
166500200529     C                   ENDSR
166600200529      *****************************************************************
166700200529      /EJECT
166800200529      *****************************************************************
166900200529      *                                                               *
167000200529      *  SRUpdate - Update Files                                      *
167100200529      *                                                               *
167200200529      *****************************************************************
167300200529     C     SRUpdate      BEGSR
167400200529      *
167500200529      ** Action is delete - Update record id to 'C'.
167600200529      *
167700200529     C                   IF        DDACTN = 'D'
167800200529      *                                                                                      260191A
167900200529      ** If Record Id is 'D', reset SDDT to zero                                             260191A
168000200529      *                                                                                      260191A
168100200529     C                   IF        S2RECI = 'D'                                              260191A
168200200529     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                            260191A
168300200529     C                               OR S2SDET = 'PP'                                        260191A
168400200529     C                   Z-ADD     0             S2SDDT                                      260191A
168500200529     C                   ENDIF                                                               260191A
168600200529      *                                                                                      260191A
168700200529     C                   ELSE                                                                260191A
168800200529     C                   IF        S2RECI = 'M'                                              260191A
168900200529     C                   MOVE      'N'           NOTALL            1                         260191A
169000200529     C     S2SDSN        SETLL     POSETDF                                                   260191A
169100200529     C     S2SDSN        READE     POSETDF                                02                 260191A
169200200529     C                   DOW       NOT *IN02                                                 260191A
169300200529      *                                                                                      260191A
169400200529     C     S2SDET        IFEQ      'MP'                                                      260191A
169500200529     C     S2SDET        OREQ      'DV'                                                      260191A
169600200529     C     S01512        ANDNE     'Y'                                                       260191A
169700200529     C                   Z-ADD     S2SDPD        WWPDUD            5 0                       260191A
169800200529     C                   ELSE                                                                260191A
169900200529     C                   Z-ADD     S2SDED        WWPDUD                                      260191A
170000200529     C                   ENDIF                                                               260191A
170100200529      *                                                                                      260191A
170200200529     C                   IF        S2SDET = F3PEVT and WWPDUD = F3PDUD                       260191A
170300200529     C                             AND F3RECI = 'M'                                          260191A
170400200529     C                   MOVE      'Y'           NOTALL                                      260191A
170500200529     C                   ENDIF                                                               260191A
170600200529      *                                                                                      260191A
170700200529     C     S2SDSN        READE     POSETDF                                02                 260191A
170800200529     C                   ENDDO                                                               260191A
170900200529      *                                                                                      260191A
171000200529     C                   IF        NOTALL = 'N'                                              260191A
171100200529     C                   Z-ADD     0             S2SDDT                                      260191A
171200200529     C                   ENDIF                                                               260191A
171300200529     C                   ENDIF                                                               260191A
171400200529      *                                                                                      260191A
171500200529     C                   ENDIF                                                               260191A
171600200529      *                                                                                      260191A
171700200529      *                                                                                      260191A
171800200529     C                   EVAL      S2RECI = 'C'
171900200529     C                   ENDIF
172000200529      *
172100200529      ** Action is insert.
172200200529     C                   IF        DDACTN = 'I'
172300200529     C                   EVAL      S2RECI = 'D'
172400200529     C                   EVAL      S2SDSN = DDSDSN
172500200529     C                   EVAL      S2SDED = PEvtDno
172600200529     C                   EVAL      S2SDET = DDSDET
172700200529     C                   EVAL      S2NMCY = D1NMCY
172800200529     C                   ENDIF
172900200529      *
173000200529      ** Setup last change type according to action done.
173100200529      *
173200200529     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
173300200529     C                             DDACTN = 'D'
173400200529     C                   EVAL      S2CHTP = DDACTN
173500200529     C                   ENDIF
173600200529      *
173700200529      ** Front Office Id.
173800200529     C                   EVAL      S2FRNT = PFOTranSel
173900200529      *
174000200529      ** Update files.
174100200529     C                   CALLB     'SESEDEUPD'
174200200529      *                             =========
174300200529      ** INPUT
174400200529      ** =====
174500200529      *
174600200529      ** Return Code
174700200529     C                   PARM      *BLANKS       RetCodeOut
174800200529      *
174900200529      ** SE Diary events for file update - file format
175000200529     C                   PARM                    NwDEFilFmt
175100200529      *
175200200529      ** STANDING DATA
175300200529      ** =============
175400200529      *
175500200529      ** SDBANK - Single Branch Code
175600200529     C                   PARM                    BJSBRC
175700200529      *
175800200529      ** SDBANK - Midas Run Day Number
175900200529     C                   PARM                    BJRDNB
176000200529      *
176100200529      ** SDBANK - Date Format Indicator
176200200529     C                   PARM                    BJDFIN
176300200529      *
176400200529      ** SDSTRD - Back value period
176500200529     C                   PARM                    BVBVP
176600200529      *
176700200529      ** ZMUSER - Default Branch
176800200529     C                   PARM                    PDBRN
176900200529      *
177000200529      ** SWITCHABLE FEATURES
177100200529      ** ===================
177200200529      *
177300200529      ** SE Transaction enhancement
177400200529     C                   PARM                    CSE010
177500200529      *
177600200529      ** Value currency to be currency of issuer payments
177700200529     C                   PARM                    S01509
177800200529      *                                                                                       CSE031
177900200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
178000200529     C                   PARM                    CSE031                                       CSE031
178100200529      *
178200200529      ** If errors occurred on update, rollback uncommitted file
178300200529      ** changes.
178400200529      *
178500200529     C                   IF        RetCodeOut <> *BLANKS AND
178600200529     C                             RetCodeOut <> '*RECUPD'
178700200529     C                   ROLBK
178800200529     C                   EXSR      *PSSR
178900200529     C                   ELSE
179000200529     C                   IF        RetCodeOut = '*RECUPD'
179100200529     C                   If        (CSC022 <> 'Y')                                           BUG2604
179200200529     C                   ROLBK
179300200529     C                   Else                                                                BUG2604
179400200529     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
179500200529     C                   ROLBK                                                               BUG2604
179600200529     C                   Else                                                                BUG2604
179700200529     C                   Seton                                        U7U8                   BUG2604
179800200529     C                   Endif                                                               BUG2604
179900200529     C                   Endif                                                               BUG2604
180000200529     C                   ENDIF
180100200529     C     ZATRNKD0      CHAIN     SEISEDEL1                          99
180200200529     C                   IF        *IN99 = *OFF
180300200529     C                   DELETE    SEISEDEL1
180400200529     C                   ENDIF
180500200529                                                                                              CSC011
180600200529      ** Also delete corresponding record in API standard log file                            CSC011
180700200529      ** if CSC011 is present and user is still in support system.                            CSC011
180800200529                                                                                              CSC011
180900200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
181000200529     C                   EVAL      WMTYP = 'SESEDE'                                           CSC011
181100200529     C     KAPILOG       CHAIN     APILOGL0                           71                      CSC011
181200200529                                                                                              CSC011
181300200529      ** If record found                                                                      CSC011
181400200529     C     *IN71         IFEQ      '0'                                                        CSC011
181500200529     C                   DELETE    APILOGD0                                                   CSC011
181600200529     C                   ENDIF                                                                CSC011
181700200529     C                   ENDIF                                                                CSC011
181800200529                                                                                              CSC011
181900200529     C                   If        (CSC022 <> 'Y')                                           BUG2604
182000200529     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2604
182100200529     C                   COMMIT
182200200529     C                   EndIf                                                               BUG2604
182300200529     C                   ENDIF
182400200529      *
182500200529      ** If update not done due to record being updated by another
182600200529      ** workstation, display message "The last transaction was not
182700200529      ** applied to the database." to the next screen.
182800200529     C                   IF        RetCodeOut = '*RECUPD'
182900200529     C                   EVAL      PERRUP = 'Y'
183000200529     C                   ELSE
183100200529     C                   EVAL      PERRUP = 'N'
183200200529     C                   ENDIF
183300200529      *
183400200529      ** Read Next Subfile record or display Browse screen.
183500200529     C                   IF        PRDNB = 'Y'
183600200529     C                   EVAL      WScrn = 'R'
183700200529     C                   ELSE
183800200529     C                   EVAL      WScrn = 'B'
183900200529     C                   ENDIF
184000200529
184100200529     C                   ENDSR
184200200529      *****************************************************************
184300200529      /EJECT
184400200529      *****************************************************************
184500200529      *                                                               *
184600200529      *  SRRtvSEDE - Retrieve security diary events details.          *
184700200529      *                                                               *
184800200529      *****************************************************************
184900200529     C     SRRtvSEDE     BEGSR
185000200529
185100200529                                                                                              CSC011
185200200529      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
185300200529      ** and current system is support system.                                                CSC011
185400200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
185500200529     C                   EVAL      PDate = S1DATE                                             CSC011
185600200529     C                   ELSE                                                                 CSC011
185700200529     C                   EVAL      PDate = BJRDNB                                             CSC011
185800200529     C                   ENDIF                                                                CSC011
185900200529                                                                                              CSC011
186000200529     C                   CALLB     'SESEDERTV'
186100200529      *                             =========
186200200529      ** INPUT
186300200529      ** =====
186400200529      *
186500200529     C                   PARM      *BLANKS       RetCodeOut
186600200529      *
186700200529      ** Mode = '*FRONT' (Front office transaction interface)
186800200529      ** Mode = '      ' (Not front office transaction interface)
186900200529      ** Mode = '*RPR  ' (Repair function)
187000200529      ** Mode = '*SIN  ' (Screen input function)
187100200529     C                   PARM                    PMode
187200200529      *
187300200529      ** Response mode
187400200529     C                   PARM                    PResponse
187500200529      *
187600200529      ** Action code
187700200529     C                   PARM                    DDACTN
187800200529      *
187900200529      ** Front office transaction Id
188000200529     C                   PARM                    PFOTrID
188100200529      *
188200200529      ** Security shortname
188300200529     C                   PARM                    DDSDSN
188400200529      *
188500200529      ** Event Date
188600200529     C                   PARM                    DDSDED
188700200529      *
188800200529      ** Event Type
188900200529     C                   PARM                    DDSDET
189000200529      *
189100200529      ** STANDING DATA
189200200529      ** =============
189300200529      *
189400200529      ** SDBANK - single branch code
189500200529     C                   PARM                    BJSBRC
189600200529      *
189700200529      ***SDBANK*- Run day number                                                              CSC011
189800200529     C**********         PARM                    BJRDNB                                       CSC011
189900200529      ** Processing Date                                                                      CSC011
190000200529     C                   PARM                    PDate                                        CSC011
190100200529      *
190200200529      ** SDBANK - Date format indicator
190300200529     C                   PARM                    BJDFIN
190400200529      *
190500200529      ** SDSTRD - Back value period
190600200529     C                   PARM                    BVBVP
190700200529      *
190800200529      ** ZMUSER - default branch
190900200529     C                   PARM                    PDBRN
191000200529      *
191100200529      ** SWITCHABLE FEATURES
191200200529      ** ===================
191300200529      *
191400200529      ** SE transaction enhancement
191500200529     C                   PARM                    CSE010
191600200529      *
191700200529      ** Value currency to be currency of issuer payments
191800200529     C                   PARM                    S01509
191900200529      *                                                                                       CSE031
192000200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
192100200529     C                   PARM                    CSE031                                       CSE031
192200200529                                                                                              CSE065
192300200529      ** Cost Yield Amortisation on Mortgage Backed Assets                                    CSE065
192400200529     C                   PARM                    CSE065                                       CSE065
192500200529      *
192600200529      ** OUTPUT
192700200529      ** ======
192800200529      *
192900200529      ** Error fields/message IDs/message data (arrays) from/to caller
193000200529     C                   PARM      *BLANKS       FldNameArr
193100200529     C                   PARM      *BLANKS       MsgIdArr
193200200529     C                   PARM      *BLANKS       MsgDtaArr
193300200529      *
193400200529      ** Array index (3P0) from/to caller
193500200529     C                   PARM      0             IdX
193600200529      *
193700200529      ** Warning fields/message IDs/message data (arrays) from/to caller
193800200529     C                   PARM                    WFldNamArr
193900200529     C                   PARM                    WMsgIDArr
194000200529     C                   PARM                    WMsgDtaArr
194100200529      *
194200200529      ** Array index (3P0) from/to caller
194300200529     C                   PARM                    WIDx
194400200529      *
194500200529      ** OK action code
194600200529     C                   PARM      'Y'           OKACTN
194700200529      *
194800200529      ** OK Security shortname
194900200529     C                   PARM      'Y'           OKSDSN
195000200529      *
195100200529      ** OK Event date
195200200529     C                   PARM      'Y'           OKSDED
195300200529      *
195400200529      ** OK Event type
195500200529     C                   PARM      'Y'           OKSDET
195600200529      *
195700200529      ** Security Diary Events retrieved from file - file format
195800200529     C                   PARM                    CrDEFilFmt
195900200529      *
196000200529      ** Externally described DS for security details
196100200529     C                   PARM      *BLANKS       PSectyd
196200200529      *
196300200529      ** Processing type from PF/INVTPD
196400200529     C                   PARM      *BLANKS       PPROT
196500200529      *
196600200529      ** Event date (Day number)
196700200529     C                   PARM      *ZEROS        PEvtDno
196800200529      *                                                                                       222373
196900200529      ** Redisplay screen                                                                     222373
197000200529     C                   PARM                    PReDsp                                       222373
197100200529
197200200529     C                   ENDSR
197300200529      *****************************************************************
197400200529      /EJECT
197500200529      *****************************************************************
197600200529      *                                                               *
197700200529      *  SRCvtSEDE - Converts security diary events details from      *
197800200529      *              file to screen format.                           *
197900200529      *                                                               *
198000200529      *****************************************************************
198100200529     C     SRCvtSEDE     BEGSR
198200200529
198300200529     C                   CALLB     'SESEDECVT'
198400200529      *                             =========
198500200529      *
198600200529      ** INPUT
198700200529      ** =====
198800200529      *
198900200529      ** Return code
199000200529     C                   PARM      *BLANKS       RetCodeOut
199100200529      *
199200200529      ** SE Diary events retrieved from file - file format
199300200529     C                   PARM                    CrDEFilFmt
199400200529      *
199500200529      ** Externally described DS for security details
199600200529     C                   PARM                    PSectyd
199700200529      *
199800200529      ** Processing type from PF/INVTPD
199900200529     C                   PARM                    PPROT
200000200529      *
200100200529      ** Action Code
200200200529     C                   PARM                    DDACTN
200300200529      *
200400200529      ** STANDING DATA
200500200529      ** =============
200600200529      *
200700200529      ** SDBANK - Date format indicator
200800200529     C                   PARM                    BJDFIN
200900200529      *
201000200529      ** MMODF - Strategic risk management indicator
201100200529     C                   PARM                    RMFL
201200200529      *
201300200529      ** SWITCHABLE FEATURES
201400200529      ** ===================
201500200529      *
201600200529      ** Value currency to be currency of issuer payments
201700200529     C                   PARM                    S01509
201800200529      *
201900200529      ** Dividend payments
202000200529     C                   PARM                    S01510
202100200529                                                                                              CAS006
202200200529      ** Hedge Accounting Phase B                                                             CAS006
202300200529     C                   PARM                    CAS006                                       CAS006
202400200529                                                                                              CSE065
202500200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
202600200529     C                   PARM                    CSE065                                       CSE065
202700200529                                                                                              CGL031
202800200529      ** Taxation on Savings Income                                                           CGL031
202900200529                                                                                              CGL031
203000200529     C                   PARM                    CGL031                                       CGL031
203100200529      *
203200200529      ** OUTPUT
203300200529      ** ======
203400200529      *
203500200529      ** SE Diary events screen details from incoming transaction
203600200529      ** - screen format
203700200529     C                   PARM                    CrDE1ScnFmt
203800200529
203900200529     C                   ENDSR
204000200529      *****************************************************************
204100200529      /EJECT
204200200529      *****************************************************************
204300200529      *                                                               *
204400200529      *  SRDtaSubs - Data Substitution                                *
204500200529      *                                                               *
204600200529      *****************************************************************
204700200529     C     SRDtaSubs     BEGSR
204800200529      *
204900200529      ** Substitute the data for the various parts of the transaction.
205000200529     C                   IF        WSUBSE1 = 'Y'
205100200529
205200200529     C                   CLEAR                   PIncData
205300200529     C                   CLEAR                   PCurData
205400200529
205500200529     C                   CALLB     'APDTASUBS'
205600200529      *                             =========
205700200529      ** Return Code
205800200529     C                   PARM      *BLANKS       RetCodeOut
205900200529      *
206000200529      ** Substitution Character
206100200529     C                   PARM                    GHSUBS
206200200529      *
206300200529      ** Incoming Data
206400200529     C                   PARM      NwDE1ScnFmt   PIncData
206500200529      *
206600200529      ** Current Data
206700200529     C                   PARM      CrDE1ScnFmt   PCurData
206800200529
206900200529     C                   MOVEL     PIncData      NwDE1ScnFmt
207000200529
207100200529     C                   ENDIF
207200200529
207300200529     C                   ENDSR
207400200529      *****************************************************************
207500200529      /EJECT
207600200529      *****************************************************************
207700200529      *                                                               *
207800200529      *  SRSndMD - Send error message to detail screen                *
207900200529      *                                                               *
208000200529      *****************************************************************
208100200529     C     SRSndMD       BEGSR
208200200529      *
208300200529      ** Reset array index.
208400200529     C                   EVAL      Ex = 0
208500200529      *
208600200529      ** If error occurred in updating last transaction,
208700200529      ** display error message on the screen (first message).
208800200529      *
208900200529     C                   IF        PERRUP = 'Y'
209000200529     C                   ADD       1             Ex
209100200529     C                   MOVEL     '*ANY'        FldNameArr(Ex)
209200200529     C                   MOVEL     'APM1000'     MsgIdArr(Ex)
209300200529     C                   MOVE      'N'           PERRUP
209400200529     C                   ENDIF
209500200529      *
209600200529      ** If there are fundamental errors in this transaction, identify
209700200529      ** this fact.
209800200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N'
209900200529     C                             OR OKSDED = 'N' OR OKSDET = 'N'
210000200529     C                   EVAL      Ex = Ex + 1
210100200529     C                   MOVE      '*ANY'        FldNameArr(Ex)
210200200529     C                   MOVE      'APM0110'     MsgIdArr(Ex)
210300200529     C                   ENDIF
210400200529      *
210500200529      ** Initialise work array for error indicators.
210600200529     C                   MOVEA     SEESEDE       WEI
210700200529      *
210800200529      ** Read security diary event details validation error messages for
210900200529      ** 1st screen.
211000200529     C                   EVAL      KABFIELDID = 0
211100200529
211200200529     C     ZATRNKD1      SETLL     ZATRNERRD0
211300200529     C     ZATRNKD0      READE     ZATRNERRD0                             99
211400200529      *
211500200529      ** Add error message read for 1st screen to array and set
211600200529      ** OK flag for field to 'N'.
211700200529     C                   DOW       *IN99 = *OFF AND
211800200529     C                             ABFIELDID > WFldOffSet1
211900200529
212000200529     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
212100200529      *
212200200529      ** If message already present in array, disregard it
212300200529      ** to avoid duplicate messages from being displayed.
212400200529     C                   IF        *IN98 <> *ON
212500200529     C                   ADD       1             Ex
212600200529     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
212700200529     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
212800200529     C                   ENDIF
212900200529
213000200529     C                   Z-ADD     ABFIELDID     Fx
213100200529     C                   SUB       WFldOffset1   Fx
213200200529
213300200529     C                   IF        Fx < 1 OR Fx > 60
213400200529     C                   Z-ADD     1             Fx
213500200529     C                   ENDIF
213600200529
213700200529     C                   MOVE      'N'           WEI(Fx)
213800200529     C     ZATRNKD0      READE     ZATRNERRD0                             99
213900200529
214000200529     C                   ENDDO
214100200529      *
214200200529      ** Update error indicators using work array.
214300200529     C                   MOVEA     WEI           SEESEDE
214400200529      *
214500200529      ** Save error indicators and messages on 1st screen.
214600200529     C                   MOVE      SEESEDE       SEESEDEx
214700200529     C                   MOVEA     FldNameArr    FldNameAr1
214800200529     C                   MOVEA     MsgIdArr      MsgIdAr1
214900200529     C                   MOVEA     MsgDtaArr     MsgDtaAr1
215000200529     C                   EVAL      ID1 = Ex
215100200529
215200200529     C                   ENDSR
215300200529      *****************************************************************
215400200529      /EJECT
215500200529      *****************************************************************
215600200529      *                                                               *
215700200529      *  SREndP - Set Program to End                                  *
215800200529      *                                                               *
215900200529      *****************************************************************
216000200529     C     SREndP        BEGSR
216100200529      *
216200200529      ** Rollback uncommitted file changes.
216300200529      *
216400200529     C                   If        (CSC022 <> 'Y')                                           BUG2604
216500200529     C                   ROLBK
216600200529     C                   Else                                                                BUG2604
216700200529     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
216800200529     C                   ROLBK                                                               BUG2604
216900200529     C                   Else                                                                BUG2604
217000200529     C                   Seton                                        U7U8                   BUG2604
217100200529     C                   Endif                                                               BUG2604
217200200529     C                   Endif                                                               BUG2604
217300200529
217400200529     C                   EVAL      WScrn = 'T'
217500200529
217600200529     C                   ENDSR
217700200529      *****************************************************************
217800200529      /EJECT
217900200529      *****************************************************************
218000200529      *                                                               *
218100200529      *  SRResetErr - Reset Error Fields                              *
218200200529      *                                                               *
218300200529      *****************************************************************
218400200529     C     SRResetErr    BEGSR
218500200529      *
218600200529      ** Reset error fields.
218700200529      *
218800200529     C                   CLEAR                   FldNameArr
218900200529     C                   CLEAR                   MsgIdArr
219000200529     C                   CLEAR                   MsgDtaArr
219100200529     C                   CLEAR                   IDx
219200200529
219300200529     C                   CLEAR                   WFldNamArr
219400200529     C                   CLEAR                   WMsgIdArr
219500200529     C                   CLEAR                   WMsgDtaArr
219600200529     C                   CLEAR                   WIDx
219700200529      *
219800200529      ** Initialise screen fields error indicators.
219900200529      *
220000200529     C                   EVAL      SEESEDE = *ALL'Y'
220100200529
220200200529     C                   ENDSR
220300200529      *****************************************************************
220400200529      /EJECT
220500200529      *****************************************************************
220600200529      *                                                               *
220700200529      *  *INZSR - Program Initialisation                              *
220800200529      *         - This subroutine runs automatically for program      *
220900200529      *           initialisation.                                     *
221000200529      *                                                               *
221100200529      *****************************************************************
221200200529     C     *INZSR        BEGSR
221300200529      *
221400200529      ** Access Bank details.
221500200529      *
221600200529     C                   CALLB     'AOBANKR0'
221700200529     C                   PARM      *BLANKS       PRTCD
221800200529     C                   PARM      '*FIRST '     POPTN
221900200529     C     SDBANK        PARM      SDBANK        DSFDY
222000200529      *
222100200529      ** Database error.
222200200529     C     PRTCD         IFNE      *BLANKS
222300200529     C                   EVAL      DBKey = POPTN
222400200529     C                   EVAL      DBFile = 'SDBANKPD'
222500200529     C                   EVAL      DBase = 001
222600200529     C                   EXSR      *PSSR
222700200529     C                   ENDIF
222800200529      *
222900200529      ** Access securities trading ICD details.
223000200529      *
223100200529     C                   CALLB     'AOSTRDR0'
223200200529     C                   PARM      '*DBERR '     PRtcd
223300200529     C                   PARM      '*FIRST '     POptn
223400200529     C     SDSTRD        PARM      SDSTRD        DSSDY
223500200529      *
223600200529      ** Database error
223700200529     C                   IF        PRtcd <> *BLANKS
223800200529     C                   EVAL      DBKey = POptn
223900200529     C                   EVAL      DBFile= 'SDSTRDPD'
224000200529     C                   EVAL      DBase = 002
224100200529     C                   EXSR      *PSSR
224200200529     C                   ENDIF
224300200529      *
224400200529      ** Access Midas Modules details.
224500200529      *
224600200529     C                   CALLB     'AOMMODR0'
224700200529     C                   PARM      *BLANKS       PRTCD
224800200529     C                   PARM      '*FIRST '     POPTN
224900200529     C     SDMMOD        PARM      SDMMOD        DSFDY
225000200529      *
225100200529      ** Database error.
225200200529     C     PRTCD         IFNE      *BLANKS
225300200529     C                   EVAL      DBKey = POPTN
225400200529     C                   EVAL      DBFile = 'SDMMODPD'
225500200529     C                   EVAL      DBase = 003
225600200529     C                   EXSR      *PSSR
225700200529     C                   ENDIF
225800200529      *
225900200529      ** Access API ICD details.
226000200529     C                   CALLB     'AOAPIR0'
226100200529     C                   PARM      *BLANKS       PRTCD
226200200529     C                   PARM      '*FIRST '     POPTN
226300200529     C     SDAPI         PARM      SDAPI         DSFDY
226400200529      *
226500200529      ** Database error.
226600200529     C     PRTCD         IFNE      *BLANKS
226700200529     C                   EVAL      DBKey = POPTN
226800200529     C                   EVAL      DBFile = 'SDAPIPD'
226900200529     C                   EVAL      DBase = 004
227000200529     C                   EXSR      *PSSR
227100200529     C                   ENDIF
227200200529      *
227300200529      ** Access SAR file to determine if "SE Transaction enhancement"
227400200529      ** is installed.
227500200529      *
227600200529     C                   CALLB     'AOSARDR0'
227700200529     C                   PARM      *BLANKS       PRtcd
227800200529     C                   PARM      '*VERIFY'     POptn
227900200529     C                   PARM      'CSE010'      PSarD
228000200529     C     SCSARD        PARM      SCSARD        DSFDY
228100200529      *
228200200529      ** An NRF (No Record Found) return code is valid.
228300200529      ** Issue database error only for error return codes.
228400200529     C                   IF        PRtcd <> *BLANKS AND
228500200529     C                             PRtcd <> '*NRF   '
228600200529     C     *LOCK         IN        LDA
228700200529     C                   EVAL      DBKey = 'CSE010'
228800200529     C                   EVAL      DBFile= 'SCSARDPD'
228900200529     C                   EVAL      DBase = 005
229000200529     C                   OUT       LDA
229100200529     C                   EXSR      *PSSR
229200200529     C                   ENDIF
229300200529
229400200529     C                   IF        PRtcd = *BLANKS
229500200529     C                   MOVEL     'Y'           CSE010
229600200529     C                   ELSE
229700200529     C                   MOVEL     'N'           CSE010
229800200529     C                   ENDIF
229900200529      *
230000200529      ** Access SAR file to determine if "Value currency to be
230100200529      ** currency of the issuer payment" is installed.
230200200529      *
230300200529     C                   CALLB     'AOSARDR0'
230400200529     C                   PARM      *BLANKS       PRtcd
230500200529     C                   PARM      '*VERIFY'     POptn
230600200529     C                   PARM      'S01509'      PSarD
230700200529     C     SCSARD        PARM      SCSARD        DSFDY
230800200529      *
230900200529      ** An NRF (No Record Found) return code is valid.
231000200529      ** Issue database error only for error return codes.
231100200529     C                   IF        PRtcd <> *BLANKS AND
231200200529     C                             PRtcd <> '*NRF   '
231300200529     C     *LOCK         IN        LDA
231400200529     C                   EVAL      DBKey = 'S01509'
231500200529     C                   EVAL      DBFile= 'SCSARDPD'
231600200529     C                   EVAL      DBase = 006
231700200529     C                   OUT       LDA
231800200529     C                   EXSR      *PSSR
231900200529     C                   ENDIF
232000200529
232100200529     C                   IF        PRtcd = *BLANKS
232200200529     C                   MOVEL     'Y'           S01509
232300200529     C                   ELSE
232400200529     C                   MOVEL     'N'           S01509
232500200529     C                   ENDIF
232600200529      *
232700200529      ** Access SAR file to determine if "Dividend Payments"
232800200529      ** is installed.
232900200529      *
233000200529     C                   CALLB     'AOSARDR0'
233100200529     C                   PARM      *BLANKS       PRtcd
233200200529     C                   PARM      '*VERIFY'     POptn
233300200529     C                   PARM      'S01510'      PSarD
233400200529     C     SCSARD        PARM      SCSARD        DSFDY
233500200529      *
233600200529      ** An NRF (No Record Found) return code is valid.
233700200529      ** Issue database error only for error return codes.
233800200529     C                   IF        PRtcd <> *BLANKS AND
233900200529     C                             PRtcd <> '*NRF   '
234000200529     C     *LOCK         IN        LDA
234100200529     C                   EVAL      DBKey = 'S01510'
234200200529     C                   EVAL      DBFile= 'SCSARDPD'
234300200529     C                   EVAL      DBase = 007
234400200529     C                   OUT       LDA
234500200529     C                   EXSR      *PSSR
234600200529     C                   ENDIF
234700200529
234800200529     C                   IF        PRtcd = *BLANKS
234900200529     C                   MOVEL     'Y'           S01510
235000200529     C                   ELSE
235100200529     C                   MOVEL     'N'           S01510
235200200529     C                   ENDIF
235300200529                                                                                              CSC011
235400200529      ** Determine if CSC011 is installed                                                     CSC011
235500200529                                                                                              CSC011
235600200529     C                   CALLB     'AOSARDR0'                                                 CSC011
235700200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
235800200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
235900200529     C                   PARM      'CSC011'      PSARD                                        CSC011
236000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
236100200529                                                                                              CSC011
236200200529      ** An NRF (No Record Found) return code is valid.                                       CSC011
236300200529      ** Issue database error only for error return codes.                                    CSC011
236400200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
236500200529     C     *LOCK         IN        LDA                                                        CSC011
236600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
236700200529     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
236800200529     C                   EVAL      DBASE = 8                                                  CSC011
236900200529     C                   OUT       LDA                                                        CSC011
237000200529     C                   EXSR      *PSSR                                                      CSC011
237100200529     C                   ENDIF                                                                CSC011
237200200529                                                                                              CSC011
237300200529     C                   IF        PRTCD = *BLANKS                                            CSC011
237400200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
237500200529     C                   OPEN      APILOGL0                                                   CSC011
237600200529     C                   IN        SC24X7                                                     CSC011
237700200529     C                   IN        SDSTAT                                                     CSC011
237800200529     C                   ELSE                                                                 CSC011
237900200529     C                   EVAL      CSC011 = 'N'                                               CSC011
238000200529     C                   ENDIF                                                                CSC011
238100200529      *                                                                                       CSE031
238200200529      ** Access SAR file to determine if "Coupon Fixing for                                   CSE031
238300200529      ** Floating Rate Notes" is installed.                                                   CSE031
238400200529      *                                                                                       CSE031
238500200529     C                   CALLB     'AOSARDR0'                                                 CSE031
238600200529     C                   PARM      *BLANKS       PRtcd                                        CSE031
238700200529     C                   PARM      '*VERIFY'     POptn                                        CSE031
238800200529     C                   PARM      'CSE031'      PSarD                                        CSE031
238900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
239000200529      *                                                                                       CSE031
239100200529      ** An NRF (No Record Found) return code is valid.                                       CSE031
239200200529      ** Issue database error only for error return codes.                                    CSE031
239300200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
239400200529     C                             PRtcd <> '*NRF   '                                         CSE031
239500200529     C     *LOCK         IN        LDA                                                        CSE031
239600200529     C                   EVAL      DBKey = 'CSE031'                                           CSE031
239700200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE031
239800200529     C                   EVAL      DBase = 9                                                  CSE031
239900200529     C                   OUT       LDA                                                        CSE031
240000200529     C                   EXSR      *PSSR                                                      CSE031
240100200529     C                   ENDIF                                                                CSE031
240200200529                                                                                              CSE031
240300200529     C                   IF        PRtcd = *BLANKS                                            CSE031
240400200529     C                   MOVEL     'Y'           CSE031                                       CSE031
240500200529     C                   ELSE                                                                 CSE031
240600200529     C                   MOVEL     'N'           CSE031                                       CSE031
240700200529     C                   ENDIF                                                                CSE031
240800200529                                                                                              CAS006
240900200529      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
241000200529      ** Phase B(CAS006)' is installed.                                                       CAS006
241100200529                                                                                              CAS006
241200200529     C                   CALLB     'AOSARDR0'                                                 CAS006
241300200529     C                   PARM      *BLANKS       PRtcd                                        CAS006
241400200529     C                   PARM      '*VERIFY'     POptn                                        CAS006
241500200529     C                   PARM      'CAS006'      PSarD                                        CAS006
241600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
241700200529                                                                                              CAS006
241800200529      ** An NRF (No Record Found) return code is valid.                                       CAS006
241900200529      ** Issue database error only for error return codes.                                    CAS006
242000200529     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
242100200529     C                             PRtcd <> '*NRF   '                                         CAS006
242200200529     C     *LOCK         IN        LDA                                                        CAS006
242300200529     C                   EVAL      DBKey = 'CAS006'                                           CAS006
242400200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
242500200529     C                   EVAL      DBase = 010                                                CAS006
242600200529     C                   OUT       LDA                                                        CAS006
242700200529     C                   EXSR      *PSSR                                                      CAS006
242800200529     C                   ENDIF                                                                CAS006
242900200529                                                                                              CAS006
243000200529     C                   IF        PRtcd = *BLANKS                                            CAS006
243100200529     C                   MOVEL     'Y'           CAS006                                       CAS006
243200200529     C                   ELSE                                                                 CAS006
243300200529     C                   MOVEL     'N'           CAS006                                       CAS006
243400200529     C                   ENDIF                                                                CAS006
243500200529                                                                                              CSE065
243600200529      ** Access SAR file to determine if CSE065 is installed                                  CSE065
243700200529                                                                                              CSE065
243800200529     C                   CALL      'AOSARDR0'                                                 CSE065
243900200529     C                   PARM      *BLANKS       PRtcd                                        CSE065
244000200529     C                   PARM      '*VERIFY'     POptn                                        CSE065
244100200529     C                   PARM      'CSE065'      PSarD                                        CSE065
244200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
244300200529                                                                                              CSE065
244400200529      ** An NRF (No Record Found) return code is valid.                                       CSE065
244500200529      ** Issue database error only for error return codes.                                    CSE065
244600200529                                                                                              CSE065
244700200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
244800200529     C                             PRtcd <> '*NRF   '                                         CSE065
244900200529     C     *LOCK         IN        LDA                                                        CSE065
245000200529     C                   EVAL      DBKey = 'CSE065'                                           CSE065
245100200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
245200200529     C                   EVAL      DBase = 012                                                CSE065
245300200529     C                   OUT       LDA                                                        CSE065
245400200529     C                   EXSR      *PSSR                                                      CSE065
245500200529     C                   ENDIF                                                                CSE065
245600200529                                                                                              CSE065
245700200529     C                   IF        PRtcd = *BLANKS                                            CSE065
245800200529     C                   MOVEL     'Y'           CSE065                                       CSE065
245900200529     C                   ELSE                                                                 CSE065
246000200529     C                   MOVEL     'N'           CSE065                                       CSE065
246100200529     C                   ENDIF                                                                CSE065
246200200529                                                                                              CSE072
246300200529      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
246400200529      ** (CSE072)' is installed.                                                              CSE072
246500200529                                                                                              CSE072
246600200529     C                   CALLB     'AOSARDR0'                                                 CSE072
246700200529     C                   PARM      *BLANKS       PRtcd                                        CSE072
246800200529     C                   PARM      '*VERIFY'     POptn                                        CSE072
246900200529     C                   PARM      'CSE072'      PSarD                                        CSE072
247000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
247100200529                                                                                              CSE072
247200200529      ** An NRF (No Record Found) return code is valid.                                       CSE072
247300200529      ** Issue database error only for error return codes.                                    CSE072
247400200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
247500200529     C                             PRtcd <> '*NRF   '                                         CSE027
247600200529     C     *LOCK         IN        LDA                                                        CSE072
247700200529     C                   EVAL      DBKey = 'CSE072'                                           CSE072
247800200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
247900200529     C                   EVAL      DBase = 009                                                CSE072
248000200529     C                   OUT       LDA                                                        CSE072
248100200529     C                   EXSR      *PSSR                                                      CSE072
248200200529     C                   ENDIF                                                                CSE072
248300200529                                                                                              CSE072
248400200529     C                   IF        PRtcd = *BLANKS                                            CSE072
248500200529     C                   MOVEL     'Y'           CSE072                                       CSE072
248600200529     C                   ELSE                                                                 CSE072
248700200529     C                   MOVEL     'N'           CSE072                                       CSE072
248800200529     C                   ENDIF                                                                CSE072
248900200529                                                                                              CGL031
249000200529      ** Access SAR file to determine if 'Taxation on Savings                                 CGL031
249100200529      ** Income is installed.                                                                 CGL031
249200200529                                                                                              CGL031
249300200529     C                   CALLB     'AOSARDR0'                                                 CGL031
249400200529     C                   PARM      *BLANKS       PRtcd                                        CGL031
249500200529     C                   PARM      '*VERIFY'     POptn                                        CGL031
249600200529     C                   PARM      'CGL031'      PSarD                                        CGL031
249700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
249800200529                                                                                              CGL031
249900200529      ** An NRF (No Record Found) return code is valid.                                       CGL031
250000200529      ** Issue database error only for error return codes.                                    CGL031
250100200529                                                                                              CGL031
250200200529     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
250300200529     C                             PRtcd <> '*NRF   '                                         CGL031
250400200529     C     *LOCK         IN        LDA                                                        CGL031
250500200529     C                   EVAL      DBKey = 'CGL031'                                           CGL031
250600200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CGL031
250700200529     C                   EVAL      DBase = 011                                                CGL031
250800200529     C                   OUT       LDA                                                        CGL031
250900200529     C                   EXSR      *PSSR                                                      CGL031
251000200529     C                   ENDIF                                                                CGL031
251100200529                                                                                              CGL031
251200200529     C                   IF        PRtcd = *BLANKS                                            CGL031
251300200529     C                   MOVEL     'Y'           CGL031                                       CGL031
251400200529     C                   ELSE                                                                 CGL031
251500200529     C                   MOVEL     'N'           CGL031                                       CGL031
251600200529     C                   ENDIF                                                                CGL031
251700200529      *                                                                                      260191A
251800200529      ** Check if S01512 is installed                                                        260191A
251900200529      *                                                                                      260191A
252000200529     C                   CallB     'AOSARDR0'                                                260191A
252100200529     C                   Parm      *BLANKS       PRTCD             7                         260191A
252200200529     C                   Parm      '*VERIFY'     POPTN             7                         260191A
252300200529     C                   Parm      'S01512'      PSARD             6                         260191A
252400200529     C     SCSARD        Parm      SCSARD        DSFDY                                       260191A
252500200529      *                                                                                      260191A
252600200529      ** An NRF (No Record Found) return code is valid.                                      260191A
252700200529      ** Issue database error only for error return codes.                                   260191A
252800200529      *                                                                                      260191A
252900200529     C                   IF        PRtcd <> *BLANKS AND                                      260191A
253000200529     C                             PRtcd <> '*NRF   '                                        260191A
253100200529     C     *LOCK         IN        LDA                                                       260191A
253200200529     C                   EVAL      DBKey = 'S01512'                                          260191A
253300200529     C                   EVAL      DBFile= 'SCSARDPD'                                        260191A
253400200529     C                   EVAL      DBase = 013                                               260191A
253500200529     C                   OUT       LDA                                                       260191A
253600200529     C                   EXSR      *PSSR                                                     260191A
253700200529     C                   ENDIF                                                               260191A
253800200529      *                                                                                      260191A
253900200529     C                   IF        PRTCD = *BLANKS                                           260191A
254000200529     C                   MOVE      'Y'           S01512            1                         260191A
254100200529     C                   ELSE                                                                260191A
254200200529     C                   MOVE      'N'           S01512                                      260191A
254300200529     C                   ENDIF                                                               260191A
254400200529      *
254500200529      ** Retrieve ZMUSER details.
254600200529      *
254700200529     C     *DTAARA       DEFINE                  ZMUSER
254800200529     C                   IN        ZMUSER
254900200529      *
255000200529      ** Access MMODF to determine if Strategic Risk Man. Ind is on
255100200529      *
255200200529     C                   READ      MMODF                                  01
255300200529      *
255400200529      ** Get the field number for the first field in 1st screen.
255500200529      ** Subtract one from it to give the value to subtract from each
255600200529      ** field's number.
255700200529     C                   CALLB     'ZACGTFLDNO'
255800200529     C                   PARM      *BLANKS       RetCodeOut
255900200529     C                   PARM                    PFormat
256000200529     C                   PARM                    PField1
256100200529     C                   PARM                    PFieldNo
256200200529
256300200529     C                   IF        RetCodeOut = *BLANKS
256400200529     C                   EVAL      WFldOffset1 = PFieldNo - 1
256500200529      *
256600200529      ** If there was an error, default the offset to 13.
256700200529     C                   ELSE
256800200529     C                   EVAL      WFldOffset1 = 13
256900200529     C                   ENDIF
257000200529      *
257100200529      ** Define Key Lists.
257200200529     C     ZATRNKD0      KLIST
257300200529     C                   KFLD                    PFOTranSel
257400200529     C                   KFLD                    PTmeStpSel
257500200529
257600200529     C     ZATRNKD1      KLIST
257700200529     C                   KFLD                    PFOTranSel
257800200529     C                   KFLD                    PTmeStpSel
257900200529     C                   KFLD                    KABFIELDID
258000200529
258100200529     C     ZATRNKX0      KLIST
258200200529     C                   KFLD                    PTmeStpSel
258300200529     C                   KFLD                    PFOTranSel
258400200529                                                                                              CSC011
258500200529      ** Key List for access to API standard log file                                         CSC011
258600200529     C     KAPILOG       KLIST                                                                CSC011
258700200529     C                   KFLD                    WMTYP                                        CSC011
258800200529     C                   KFLD                    PFOTranSel                                   CSC011
258900200529     C                   KFLD                    PTmeStpSel                                   CSC011
259000200529                                                                                              CSC011
259100200529      *
259200200529      ** Initialise error fields.
259300200529     C                   EXSR      SRResetErr
259400200529      *
259500200529      ** Display Browse screen.
259600200529     C                   MOVE      'B'           WScrn
259700200529      *
259800200529      ** Access Switchable Features File, forBUG2604                                         BUG2604
259900200529      *                                                                                      BUG2604
260000200529     C                   Eval      CSC022 = 'N'                                              BUG2604
260100200529     C                   CallB     'AOSARDR0'                                                BUG2604
260200200529     C                   Parm      *BLANKS       PRTCD                                       BUG2604
260300200529     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
260400200529     C                   Parm      'CSC022'      PSARD                                       BUG2604
260500200529     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
260600200529      *                                                                                      BUG2604
260700200529     C                   If        PRTCD = *Blanks                                           BUG2604
260800200529     C                   Eval      CSC022 = 'Y'                                              BUG2604
260900200529     C                   Eval      WCommitSkip = 'N'                                         BUG2604
261000200529      *                                                                                      BUG2604
261100200529     C                   In        SCCMTJOB                                                  BUG2604
261200200529     C                   If        ComitNum > 0                                              BUG2604
261300200529     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2604
261400200529      *                                                                                      BUG2604
261500200529     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2604
261600200529     C                   If        *IN87 = *ON                                               BUG2604
261700200529     C                   Eval      WCommitSkip = 'Y'                                         BUG2604
261800200529     C                   EndIf                                                               BUG2604
261900200529     C                   EndIf                                                               BUG2604
262000200529      *                                                                                      BUG2604
262100200529     C                   Else                                                                BUG2604
262200200529      *                                                                                      BUG2604
262300200529      ** If return code <> *NRF, call program exception error routine                        BUG2604
262400200529      *                                                                                      BUG2604
262500200529     C                   If        PRTCD <> '*NRF'                                           BUG2604
262600200529     C     *LOCK         IN        LDA                                                       BUG2604
262700200529     C                   EVAL      DBKEY = 'CSC022'                                          BUG2604
262800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2604
262900200529     C                   EVAL      DBASE = 11                                                BUG2604
263000200529     C                   OUT       LDA                                                       BUG2604
263100200529     C                   Exsr      *PSSR                                                     BUG2604
263200200529     C                   EndIf                                                               BUG2604
263300200529     C                   EndIf                                                               BUG2604
263400200529      *                                                                                      BUG2604
263500200529      ** Program, module and procedure names for dbase error processing
263600200529      ** ==============================================================
263700200529      ** The following /COPY sets these values.
263800200529      *
263900200529      /COPY ZACPYSRC,DBFIELDS
264000200529      *
264100200529      ** Hook to enable non-core initial processing to be included
264200200529      *
264300200529      /COPY WNCPYSRC,SESEDER011
264400200529      *
264500200529     C                   ENDSR
264600200529      *****************************************************************
264700200529      /EJECT
264800200529      *****************************************************************
264900200529      *
265000200529      ** The following /COPY contains the standard program status
265100200529      ** subroutine, including a bound call to the DBERRCTL module.
265200200529      *
265300200529      /COPY ZACPYSRC,PSSR_ILE
265400200529      *
265500200529      *****************************************************************
265600200529      /EJECT
265700200529      *****************************************************************
265800200529      *
265900200529**  CPY@
266000200529(c) Finastra International Limited 2001
