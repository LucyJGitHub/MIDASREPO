000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Security diary events input')                 *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDESIN - Security Diary Events Input Program              *
001100200529      *                                                               *
001200200529      *  Function: This module will be the input module for the       *
001300200529      *            screen-input function for Security Diary Events    *
001400200529      *            maintenance.                                       *
001500200529      *                                                               *
001600200529      *  Component of: SESEDESIN                                      *
001700200529      *                                                               *
001800200529      *  (c) Finastra International Limited 2001                      *
001900200529      *                                                               *
002000200604      *  Last Amend No. 260191A            Date 22May20               *
002100200529      *  Prev Amend No. MD046248           Date 27Oct17               *
002200200529      *                 260331             Date 31Mar16               *
002300200529      *                 CRE073             Date 06Dec10               *
002400200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002500200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002600200529      * Midas Plus 1.4 Base ------------------------------------------*
002700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002800200529      *                 CSD027             Date 09Dec05               *
002900200529      *                 CSE075             Date 17Nov05               *
003000200529      *                 CGL031             Date 05Jul04               *
003100200529      *                 CSE065             Date 08Nov04               *
003200200529      *                 CSE071             Date 19Jul05               *
003300200529      *                 CSE072             Date 05Apr05               *
003400200529      *                 BUG2064            Date 29May04               *
003500200529      *                 BUG2604            Date 18May04               *
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
005200200529      *  260191 - System should not allow deletion of a security diary*
005300200529      *           event if atleast one live position exists for the   *
005400200529      *           event. This validation is only valid if the diary   *
005500200529      *           event being deleted is still live record. Applied   *
005600200529      *           fix 255857.                                         *
005700200529      *  MD046248 - Finastra Rebranding                               *
005800200529      *  260331 - Incorrect posting created due to a deleted diary    *
005900200529      *           event. Applied fix 255857.                          *
006000200529      *         - Applied for MD-37742.                               *
006100200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
006200200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
006300200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
006400200529      *           (Recompile)                                         *
006500200529      *  CGL031 - Taxation of Savings Income                          *
006600200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
006700200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
006800200529      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
006900200529      *  BUG2064 - Initialization of CSC022.                          *
007000200529      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
007100200529      *  CAS006 - Hedge Accounting Phase B                            *
007200200529      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
007300200529      *  CSC011 - 24x7 Midas Availability                             *
007400200529      *  CSD006 - Recompiled over changed SECTYD.                     *
007500200529      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
007600200529      *           modular structure to use as APIs.                   *
007700200529      *                                                               *
007800200529      *****************************************************************
007900200529      *                                                               *
008000200529      *  Use of indicators.                                           *
008100200529      *                                                               *
008200200529      *    99         Use for LOOKUP command                          *
008300200529      *                                                               *
008400200529      *****************************************************************
008500200529      *                                                               *
008600200529      *  S U B R O U T I N E  I N D E X                               *
008700200529      *                                                               *
008800200529      *  SRScrnI - Process initial screen                             *
008900200529      *  SRValI - Validate input to initial screen                    *
009000200529      *  SRScrnP - Process main screen                                *
009100200529      *  SRDefault - Process defaulting of default fields             *
009200200529      *  SRValP - Validate input to main screen                       *
009300200529      *  SRScrnW - Process Window screen                              *
009400200529      *  SRScrnF - Process confirmation screen                        *
009500200529      *  SRUpdate - Process file update                               *
009600200529      *  SRBldBrw - Build browse subfile record                       *
009700200529      *  SRRdNBrw - Read next browse subfile record                   *
009800200529      *  SRRtvSEDE - Retrieve security diary events details.          *
009900200529      *  SRCvtSEDE - Converts security diary events details from      *
010000200529      *              file to screen format.                           *
010100200529      *  SRRoll - Roll backward or forward through the security       *
010200200529      *           diary events details.                               *
010300200529      *  SRSavKey - Save key fields to a temporary variable.          *
010400200529      *  SRRstKey - Restore key fields.                               *
010500200529      *  SRSetupKey - Setup keys for pointer or selection.            *
010600200529      *  SRClearScn - Clear screen data structures                    *
010700200529      *  SREndP - Set program to end                                  *
010800200529      *  SRSndM - Send error message to screen                        *
010900200529      *  SRResetErr - Reset error fields                              *
011000200529      *  *PSSR - Error processing                                     *
011100200529      *  *INZSR - Initialise                                          *
011200200529      *                                                               *
011300200529      *    The *INZSR subroutine will only get called automatically   *
011400200529      *    on entry to the module the first time it is run            *
011500200529      *    (unless you end the program with LR on).  Similarly        *
011600200529      *    D-spec initialisation only happens the first time.  Use    *
011700200529      *    RESET for subsequent passes.                               *
011800200529      *                                                               *
011900200529      *****************************************************************
012000200529      *
012100200529      ** +--------------------------------------+
012200200529      ** ¦ F-specs                              ¦
012300200529      ** ¦ =======                              ¦
012400200529      ** +--------------------------------------+
012500200529      *
012600200529      ** Midas module flag - details
012700200529     FMMODF     IF   E             DISK    INFSR(*PSSR)
012800200529      *                                                                                      260191A
012900200529      ** Position Settlement by Security                                                     260191A
013000200529      *                                                                                      260191A
013100200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)                                      260191A
013200200529     F                                     PREFIX(F3)                                        260191A
013300200529      *
013400200529      ** Hook to enable non-core files to be included
013500200529      /COPY WNCPYSRC,SESEDE001
013600200529      *
013700200529      *****************************************************************
013800200529      /EJECT
013900200529      *****************************************************************
014000200529      *
014100200529      ** +--------------------------------------+
014200200529      ** ¦ Automatically included D-specs       ¦
014300200529      ** ¦ ==============================       ¦
014400200529      ** +--------------------------------------+
014500200529      *
014600200529      ** Standard D-specs
014700200529      ** ================
014800200529      **
014900200529      ** The following /COPY line includes the LDA layout,
015000200529      ** the copyright array definition,
015100200529      ** and the following named constants:
015200200529      **    True       logical = *on (for indcator processing)
015300200529      **    False      logical = *off (for indicator processing)
015400200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
015500200529      **                                    handler)
015600200529      ** and the following variables:
015700200529      **    RunBefore  1A (for the PSSR)
015800200529      *
015900200529      /COPY ZACPYSRC,STD_D_SPEC
016000200529      *
016100200529      ** Program Status Data Structure
016200200529      ** =============================
016300200529      ** The following /COPY line includes all the defined fields in the
016400200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
016500200529      *
016600200529      /COPY ZACPYSRC,PSDS
016700200529      *
016800200529      ** The following /COPY line includes the definitions for error and
016900200529      ** warning message arrays.
017000200529      *
017100200529      /COPY ZACPYSRC,ERR_ARRAYS
017200200529      *
017300200529      ** The following /COPY line includes the definitions of data
017400200529      ** structure used to pass data to window program
017500200529      *
017600200529      /COPY QWINDSRC,SESEDEDTA
017700200529      *
017800200529      ** +--------------------------------------+
017900200529      ** ¦ End of automatically included D-specs¦
018000200529      ** ¦ =====================================¦
018100200529      ** +--------------------------------------+
018200200529      *
018300200529      *****************************************************************
018400200529      /EJECT
018500200529      *****************************************************************
018600200529      *
018700200529      ** +--------------------------------------+
018800200529      ** ¦ Manually included D-specs            ¦
018900200529      ** ¦ =========================            ¦
019000200529      ** +--------------------------------------+
019100200529      *
019200200529      ** +--------------------------------------+
019300200529      ** ¦ Named constants                      ¦
019400200529      ** ¦ ===============                      ¦
019500200529      ** +--------------------------------------+
019600200529      *
019700200529      ** +--------------------------------------+
019800200529      ** ¦ Arrays and Data Structures           ¦
019900200529      ** ¦ ==========================           ¦
020000200529      ** +--------------------------------------+
020100200529                                                                                             BUG2604
020200200529      * Array to hold Commitment Job Names                                                   BUG2604
020300200529     D CmtJobNArr      S             10A   DIM(10)                                           BUG2604
020400200529      *
020500200529      ** SE Diary events screen details retrieved from file
020600200529      ** - screen format
020700200529     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
020800200529     D                                     PREFIX(O)
020900200529      *
021000200529      ** SE Diary events screen details from incoming transaction
021100200529      ** - screen format
021200200529     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
021300200529      *
021400200529      ** SE Diary events screen error indicators
021500200529     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
021600200529      *
021700200529      ** SE Diary events for file update - file format
021800200529     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
021900200529     D NwDeFilFmt1             1    231                                                       CSE065
022000200529      *
022100200529      ** SE Diary events retrieved from file - file format
022200200529     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
022300200529     D                                     PREFIX(O)
022400200529     D CrDeFilFmt1             1    231                                                       CSE065
022500200529      *
022600200529      ** Externally described DS for security details
022700200529     D PSectyd       E DS                  EXTNAME(SECTYD)
022800200529     D                                     PREFIX(D1)
022900200529      *
023000200529      ** Externally described DS for SAR details
023100200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
023200200529     D SLCD          E                     EXTFLD(LCD)
023300200529      *
023400200529      ** Externally described DS for bank details
023500200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
023600200529      *
023700200529      ** Externally described DS for Midas modules details
023800200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
023900200529      *
024000200529      ** Externally described DS for securities trading ICD details
024100200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
024200200529      *
024300200529      ** DS for access programs - short data structure
024400200529     D DSFDY         E DS                  EXTNAME(DSFDY)
024500200529      *
024600200529      ** DS for access objects - long data structure
024700200529     D DSSDY         E DS                  EXTNAME(DSSDY)
024800200529                                                                                              CSC011
024900200529      ** Data structure for data area SC24X7                                                  CSC011
025000200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
025100200529                                                                                              CSC011
025200200529      ** Data structure for data area SDSTAT                                                  CSC011
025300200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
025400200529      *
025500200529      ** Data structure for key fields
025600200529     D KeyLists        DS
025700200529     D  WDSDSN                 1     10A
025800200529     D  WDSDED                11     16A
025900200529     D  WDSDET                17     18A
026000200529      *
026100200529      ** Data structure for ZMUSER details
026200200529     D ZMUSER          DS            17
026300200529     D  PUSRID                 1     10A
026400200529     D  PDBRN                 11     13A
026500200529     D  PDPPT                 14     16A
026600200529      *
026700200529      ** Commitment Control Data Area                                                        BUG2604
026800200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2604
026900200529     D  wComitJob              4    103                                                      BUG2604
027000200529                                                                                             BUG2604
027100200529      ** +--------------------------------------+
027200200529      ** ¦ Declared variables                   ¦
027300200529      ** ¦ ==================                   ¦
027400200529      ** +--------------------------------------+
027500200529      *
027600200529      ** Response mode, passed as a constant parameter to the VAL module
027700200529      ** This is always 'S' for synchronous.
027800200529     D PRespMode       S              1A   INZ('S')
027900200529      *
028000200529      ** Mode = '*FRONT' (front office transaction interface)
028100200529      ** Mode = '      ' (not front office transaction interface)
028200200529      ** Mode = '*RPR  ' (repair function)
028300200529      ** Mode = '*SIN  ' (screen input function)
028400200529     D PMode           S              6A   INZ('*SIN  ')
028500200529      *
028600200529      ** Work array for warning message Ids
028700200529     D WPrvWarnAr      S                   Dim(ArrayMax)
028800200529     D                                     Like(WMsgIDArr)
028900200529      *
029000200529      ** Index for arrays of error message ids, etc.
029100200529     D Ex              S              3P 0
029200200529     D IDx             S              3P 0
029300200529      *
029400200529      ** Index for arrays of warning error message ids, etc.
029500200529     D WIDx            S              3P 0
029600200529      *
029700200529      ** Function keys to activate
029800200529     D PEINKE          S              1A
029900200529     D PEINKG          S              1A
030000200529     D PEINKH          S              1A
030100200529     D PEINKJ          S              1A
030200200529     D PEINKL          S              1A
030300200529     D PEINKP          S              1A
030400200529      *
030500200529      ** Function keys activated
030600200529     D PINKC           S              1A
030700200529     D PINKE           S              1A
030800200529     D PINKG           S              1A
030900200529     D PINKH           S              1A
031000200529     D PINKJ           S              1A
031100200529     D PINKL           S              1A
031200200529     D PINKP           S              1A
031300200529      *
031400200529      ** Work variables
031500200529     D WReDisplay      S              1A
031600200529     D WOACTN          S              1A
031700200529     D WDDACTN         S              1A
031800200529     D WDDSDSN         S             10A
031900200529     D WDDSDED         S              6A
032000200529     D WDDSDET         S              2A
032100200529     D WScrn           S              1A
032200200529     D WRdNBrw         S              1A
032300200529     D WProcOnce       S              1A
032400200529     D WiX             S              3P 0
032500200529      *
032600200529      ** Work parameters
032700200529     D PReDsp          S              1A
032800200529     D CSE010          S              1A
032900200529     D S01509          S              1A
033000200529     D S01510          S              1A
033100200529     D CSE031          S              1A                                                      CSE031
033200200529     D CAS006          S              1A                                                      CAS006
033300200529     D CSE072          S              1A                                                      CSE072
033400200529     D CSE065          S              1A                                                      CSE065
033500200529     D CGL031          S              1A                                                      CGL031
033600200529     D PPROT           S              1A
033700200529     D PEDtFld         S              1A
033800200529     D PResetFld       S              1A
033900200529     D PAmendOk        S              1A
034000200529     D POpSel          S              1A
034100200529     D PRdBck          S              1A
034200200529     D PRdFwd          S              1A
034300200529     D PBdSfl          S              1A
034400200529     D PRdSfl          S              1A
034500200529     D PSDETSel        S              2A
034600200529     D PPayCcy         S              3A
034700200529     D PEvtDno         S              5P 0
034800200529     D PSDEDSel        S              6A
034900200529     D PSARD           S              6A
035000200529     D PRtcd           S              7A
035100200529     D POptn           S              7A
035200200529     D PErrMS          S              7A
035300200529     D PSDSNSel        S             10A
035400200529     D PFRNT           S             20A
035500200529      *
035600200529      ** Output screen fields
035700200529     D DDCUCR          S             12A
035800200529     D DDSEXR          S             14A
035900200529     D DDMATY          S              8A                                                      CSE065
036000200529      *
036100200529      ** Parameters for WN0010
036200200529     D PWPgm           S             10A   INZ('SESEDESIN')
036300200529     D PWKey           S              2A
036400200529     D PWAction        S              1A
036500200529     D PWRtn           S              7A
036600200529     D PWSpare         S            256A
036700200529                                                                                              CSC011
036800200529      ** Define variables for CSC011                                                          CSC011
036900200529     D CSC011          S              1A                                                      CSC011
037000200529                                                                                              CSC011
037100200529      ** Work field for Date to be passed to RTV module                                       CSC011
037200200529     D PDate           S                   LIKE(BJRDNB)                                       CSC011
037300200529      *
037400200529      ** Work variables forBUG2604                                                           BUG2604
037500200529     DBUG2604          S              1A   INZ('N')                                          BUG2604
037600200529     D wCommitSkip     S              1A   INZ('N')                                          BUG2604
037700200529     D CSC022          S              1A                                                     BUG2064
037800200529                                                                                             BUG2604
037900200529      ** +--------------------------------------+
038000200529      ** ¦ End of D-specs                       ¦
038100200529      ** ¦ ==============                       ¦
038200200529      ** +--------------------------------------+
038300200529      *
038400200529      /COPY WNCPYSRC,SESEDE002
038500200529      *****************************************************************
038600200529      /EJECT
038700200529      *****************************************************************
038800200529      *
038900200529      ** +--- Start of Main processing -------------------------------+
039000200529      ** ¦                                                            ¦
039100200529      ** ¦ Initial processing is performed automatically.             ¦
039200200529      ** ¦ *INZSR is executed at program activation.                  ¦
039300200529      ** ¦                                                            ¦
039400200529      ** +------------------------------------------------------------+
039500200529      *
039600200529      *****************************************************************
039700200529      * MAIN PROCEDURE                                                *
039800200529      *****************************************************************
039900200529      *
040000200529      /COPY WNCPYSRC,SESEDE003
040100200529      *
040200200529      ** Read next browse subfile record.
040300200529      *
040400200529     C                   IF        WScrn = 'R'
040500200529     C                   EXSR      SRRdnBrw
040600200529     C                   ENDIF
040700200529      *
040800200529      /COPY WNCPYSRC,SESEDE004
040900200529      *
041000200529      ** Do While screen - Initial details only.
041100200529      *
041200200529     C                   DOW       WScrn = 'I'
041300200529     C                   EXSR      SRScrnI
041400200529     C                   ENDDO
041500200529      *
041600200529      /COPY WNCPYSRC,SESEDE005
041700200529      *
041800200529      ** Do While screen - Main screen details.
041900200529      *
042000200529     C                   DOW       WScrn = 'P'
042100200529     C                   EXSR      SRScrnP
042200200529     C                   ENDDO
042300200529      *
042400200529      /COPY WNCPYSRC,SESEDE006
042500200529      *
042600200529      ** Process window screen.
042700200529      *
042800200529     C                   IF        WScrn = 'W'
042900200529     C                   EXSR      SRScrnW
043000200529     C                   ENDIF
043100200529      *
043200200529      /COPY WNCPYSRC,SESEDE007
043300200529      *
043400200529      ** Process confirmation.
043500200529      *
043600200529     C                   IF        WScrn = 'F'
043700200529     C                   EXSR      SRScrnF
043800200529     C                   ENDIF
043900200529      *
044000200529      /COPY WNCPYSRC,SESEDE008
044100200529      *
044200200529      ** Process file update.
044300200529      *
044400200529     C                   IF        WScrn = 'U'
044500200529     C                   EXSR      SRUpdate
044600200529     C                   ENDIF
044700200529      *
044800200529      /COPY WNCPYSRC,SESEDE009
044900200529      *
045000200529      ** Terminate program.
045100200529      *
045200200529     C                   IF        WScrn = 'E'
045300200529     C                   EVAL      *INLR = *ON
045400200529     C                   ENDIF
045500200529      *
045600200529      *****************************************************************
045700200529      /EJECT
045800200529      *****************************************************************
045900200529      *
046000200529      ** Hook to enable non-core subroutines to be included
046100200529      /COPY WNCPYSRC,SESEDE010
046200200529
046300200529      /EJECT
046400200529      *****************************************************************
046500200529      *                                                               *
046600200529      *  SRScrnI - Process initial screen                             *
046700200529      *                                                               *
046800200529      *****************************************************************
046900200529     C     SRScrnI       BEGSR
047000200529      *
047100200529      ** If windows processing is on, clear any possible updates
047200200529      ** in window function.
047300200529      *
047400200529     C                   IF        BGWDPR = 'Y'
047500200529     C                   If        (CSC022 = 'N')                                            BUG2604
047600200529     C                   ROLBK
047700200529     C                   Else                                                                BUG2604
047800200529     C                   If        wCommitSkip = 'N'                                         BUG2604
047900200529     C                   ROLBK                                                               BUG2604
048000200529     C                   Else                                                                BUG2604
048100200529     C                   Seton                                        U7U8                   BUG2604
048200200529     C                   Endif                                                               BUG2604
048300200529     C                   Endif                                                               BUG2604
048400200529     C                   ENDIF
048500200529      *
048600200529      ** Enable all fields on initial screen as well as all function keys.
048700200529      *
048800200529     C                   EVAL      PEINKE  = 'Y'
048900200529     C                   EVAL      PEINKG  = 'Y'
049000200529     C                   EVAL      PEINKH  = 'Y'
049100200529     C                   EVAL      PEINKP  = 'Y'
049200200529     C                   EVAL      PEINKL  = 'Y'
049300200529      *
049400200529      ** Display initial screen.
049500200529      *
049600200529     C                   CALLB     'SESEDEIDP'
049700200529      *                             =========
049800200529      ** INPUT
049900200529      ** =====
050000200529      *
050100200529      ** Return code
050200200529     C                   PARM      *BLANKS       RetCodeOut
050300200529      *
050400200529      ** Action code
050500200529      ** Security shortname
050600200529      ** Event date
050700200529      ** Event type
050800200529     C                   PARM                    DDACTN
050900200529     C                   PARM                    DDSDSN
051000200529     C                   PARM                    DDSDED
051100200529     C                   PARM                    DDSDET
051200200529      *
051300200529      ** Enable function keys
051400200529      ** KE = command key 05 = Refresh
051500200529      ** KG = command key 07 = Read Previous
051600200529      ** KH = command key 08 = Read Next
051700200529      ** KL = command key 12 = Cancel
051800200529      ** KP = command key 15 = Browse
051900200529     C                   PARM                    PEINKE
052000200529     C                   PARM                    PEINKG
052100200529     C                   PARM                    PEINKH
052200200529     C                   PARM                    PEINKL
052300200529     C                   PARM                    PEINKP
052400200529      *
052500200529      ** OK field error indicators
052600200529      ** Action code
052700200529      ** Security shortname
052800200529      ** Event date
052900200529      ** Event type
053000200529     C                   PARM                    OKACTN
053100200529     C                   PARM                    OKSDSN
053200200529     C                   PARM                    OKSDED
053300200529     C                   PARM                    OKSDET
053400200529      *
053500200529      ** Error fields/message IDs/message data (arrays) from/to caller
053600200529     C                   PARM                    FldNameArr
053700200529     C                   PARM                    MsgIdArr
053800200529     C                   PARM                    MsgDtaArr
053900200529      *
054000200529      ** Warning fields/message Ids/message data (arrays) from/to
054100200529      ** caller
054200200529     C                   PARM                    WFldNamArr
054300200529     C                   PARM                    WMsgIdArr
054400200529     C                   PARM                    WMsgDtaArr
054500200529      *
054600200529      ** STANDING DATA
054700200529      ** =============
054800200529      *
054900200529      ** SDBANK - System runday
055000200529     C                   PARM                    BJMRDT
055100200529      *
055200200529      ** OUTPUT
055300200529      ** ======
055400200529      *
055500200529      ** Function keys enabled
055600200529      ** KC = command key 03 = Exit
055700200529      ** KE = command key 05 = Refresh
055800200529      ** KG = command key 07 = Read Previous
055900200529      ** KH = command key 08 = Read Next
056000200529      ** KL = command key 12 = Cancel
056100200529      ** KP = command key 15 = Browse
056200200529     C                   PARM                    PINKC
056300200529     C                   PARM                    PINKE
056400200529     C                   PARM                    PINKG
056500200529     C                   PARM                    PINKH
056600200529     C                   PARM                    PINKL
056700200529     C                   PARM                    PINKP
056800200529      *
056900200529      ** Save warning message ids array of this screen.
057000200529      *
057100200529     C                   MOVEA     WMsgIDArr     WPrvWarnAr
057200200529      *
057300200529      ** Reset error fields.
057400200529      *
057500200529     C                   EXSR      SRResetErr
057600200529
057700200529     C                   SELECT
057800200529      *
057900200529      ** F3 - end program.
058000200529     C                   WHEN      PINKC = *ON
058100200529     C                   EXSR      SREndP
058200200529      *
058300200529      ** F5 - refresh initial screen details.
058400200529     C                   WHEN      PINKE = *ON
058500200529     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
058600200529      *
058700200529      ** F7 - roll backwards.
058800200529     C                   WHEN      PINKG = *ON
058900200529     C                   EXSR      SRRoll
059000200529      *
059100200529      ** F8 - roll forwards.
059200200529     C                   WHEN      PINKH = *ON
059300200529     C                   EXSR      SRRoll
059400200529      *
059500200529      ** F12 - cancel on initial screen.
059600200529     C                   WHEN      PINKL = *ON
059700200529      *
059800200529      ** Display initial screen with blank fields.
059900200529      ** Reset read next browse subfile record indicator.
060000200529     C                   EXSR      SRClearScn
060100200529     C                   EVAL      WRdNBrw = *BLANK
060200200529     C                   EVAL      WScrn   = 'I'
060300200529      *
060400200529      ** F15 - build browse.
060500200529     C                   WHEN      PINKP = *ON
060600200529     C                   EXSR      SRSetupKey
060700200529     C                   EXSR      SRBldBrw
060800200529      *
060900200529      ** Enter key was pressed.  Validate input to initial screen.
061000200529     C                   OTHER
061100200529
061200200529     C                   EXSR      SRValI
061300200529
061400200529     C                   ENDSL
061500200529
061600200529     C     ESRScrnI      ENDSR
061700200529      *
061800200529      *****************************************************************
061900200529      /EJECT
062000200529      *****************************************************************
062100200529      *                                                               *
062200200529      *  SRValI - Validate input to initial screen                    *
062300200529      *                                                               *
062400200529      *****************************************************************
062500200529     C     SRValI        BEGSR
062600200529      *
062700200529      ** Validate key fields and retrieve security diary events details.
062800200529      *
062900200529     C                   EXSR      SRRtvSEDE
063000200529      *
063100200529     C                   EVAL      WReDisplay = *BLANK
063200200529      *
063300200529      ** If no errors occurred during validation of key fields, check
063400200529      ** if there are warnings which have not been displayed yet.
063500200529      *
063600200529     C                   IF        IDx = *ZERO
063700200529
063800200529     C                   Z-ADD     1             WiX
063900200529
064000200529     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK
064100200529
064200200529     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
064300200529     C                   EVAL      WReDisplay = 'Y'
064400200529     C                   ELSE
064500200529     C                   EVAL      WiX = WiX + 1
064600200529     C                   ENDIF
064700200529
064800200529     C                   ENDDO
064900200529
065000200529     C                   IF        WReDisplay <> 'Y'
065100200529     C                   EXSR      SRResetErr
065200200529     C                   ENDIF
065300200529
065400200529     C                   ENDIF
065500200529      *
065600200529      ** Errors occurred during retrieval of security diary events
065700200529      ** details, and/or in the validation of initial key fields.
065800200529      *
065900200529     C                   IF        IDx <> *ZERO OR WReDisplay = 'Y'
066000200529     C                             OR PReDsp = 'Y'
066100200529     C                   GOTO      ESRValI
066200200529     C                   ENDIF
066300200529      *
066400200529      ** Move the security diary events details from the master
066500200529      ** database file into the update file record.  If no record
066600200529      ** has been retrieved (happens on insert mode), fields contain
066700200529      ** initial values.
066800200529      *
066900200529     C**********         EVAL      NwDEFilFmt = CrDEFilFmt
067000200529     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
067100200529      *                                                                                       CSE065
067200200529     C                   IF        CSE065 = 'Y'                                               CSE065
067300200529     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
067400200529     C                   ELSE                                                                 CSE065
067500200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
067600200529     C                   ENDIF                                                                CSE065
067700200529      *
067800200529      ** If action code is not insert, convert security diary events
067900200529      ** details on main screen.
068000200529      *
068100200529     C                   IF        DDACTN <> 'I'
068200200529     C                   EXSR      SRCvtSEDE
068300200529     C                   ENDIF
068400200529      *
068500200529      ** Initialise work variable for defaulting.
068600200529      *
068700200529     C                   EVAL      WProcOnce = *BLANK
068800200529      *
068900200529      ** Display the main screen.
069000200529      *
069100200529     C                   EVAL      WScrn  = 'P'
069200200529
069300200529     C     ESRValI       ENDSR
069400200529      *
069500200529      *****************************************************************
069600200529      /EJECT
069700200529      *****************************************************************
069800200529      *                                                               *
069900200529      *  SRScrnP - Process main screen                                *
070000200529      *                                                               *
070100200529      *****************************************************************
070200200529     C     SRScrnP       BEGSR
070300200529      *
070400200529      ** Windows processing is on.
070500200529      *
070600200529     C                   IF        BGWDPR = 'Y'
070700200529      *
070800200529      ** If Action code and Security shortname, diary event date
070900200529      ** and event type have changed, clear any possible updates
071000200529      ** in window function.
071100200529      *
071200200529     C                   IF        DDACTN <> WDDACTN OR
071300200529     C                             DDSDSN <> WDDSDSN OR
071400200529     C                             DDSDED <> WDDSDED OR
071500200529     C                             DDSDET <> WDDSDET
071600200529     C                   If        (CSC022 = 'N')                                            BUG2604
071700200529     C                   ROLBK
071800200529     C                   Else                                                                BUG2604
071900200529     C                   If        wCommitSkip = 'N'                                         BUG2604
072000200529     C                   ROLBK                                                               BUG2604
072100200529     C                   Else                                                                BUG2604
072200200529     C                   Seton                                        U7U8                   BUG2604
072300200529     C                   Endif                                                               BUG2604
072400200529     C                   Endif                                                               BUG2604
072500200529     C                   ENDIF
072600200529      *
072700200529      ** Save Action code and Security shortname, event date and
072800200529      ** event type.
072900200529     C                   MOVEL     DDACTN        WDDACTN
073000200529     C                   MOVEL     DDSDSN        WDDSDSN
073100200529     C                   MOVEL     DDSDED        WDDSDED
073200200529     C                   MOVEL     DDSDET        WDDSDET
073300200529
073400200529     C                   ENDIF
073500200529      *
073600200529      ** Enable all fields on the main screen as well as all function keys.
073700200529      *
073800200529     C                   EVAL      PEINKG  = 'Y'
073900200529     C                   EVAL      PEINKH  = 'Y'
074000200529     C                   EVAL      PEINKP  = 'Y'
074100200529     C                   EVAL      PEINKL  = 'Y'
074200200529      *
074300200529      ** Allow details to be amended on Insert or Amend mode.
074400200529      *
074500200529     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
074600200529     C                   EVAL      PEdtFld = 'Y'
074700200529     C                   EVAL      PEINKE  = 'Y'
074800200529     C                   ELSE
074900200529     C                   EVAL      PEdtFld = 'N'
075000200529     C                   EVAL      PEINKE  = 'N'
075100200529     C                   ENDIF
075200200529      *
075300200529      ** If action made is Delete and no error found when retrieving
075400200529      ** details, allow deletion of record.
075500200529      *
075600200529     C                   IF        DDACTN = 'D' AND IDx = *ZERO
075700200529     C                   EVAL      PEINKJ  = 'Y'
075800200529     C                   ELSE
075900200529     C                   EVAL      PEINKJ  = 'N'
076000200529     C                   ENDIF
076100200529      *
076200200529      ** Process default fields for the next screen.
076300200529      *
076400200529     C                   EXSR      SRDefault
076500200529      *
076600200529      ** Display maintenance screen.
076700200529      *
076800200529     C                   CALLB     'SESEDE1DP'
076900200529      *                             =========
077000200529      ** INPUT
077100200529      ** =====
077200200529      *
077300200529      ** Return code
077400200529     C                   PARM      *BLANKS       RetCodeOut
077500200529      *
077600200529      ** SE Diary events screen details from incoming transaction
077700200529      ** - screen format
077800200529     C                   PARM                    NwDE1ScnFmt
077900200529      *
078000200529      ** SE Diary events retrieved from file - file format
078100200529     C                   PARM                    CrDEFilFmt
078200200529                                                                                              CAS006
078300200529      ** Externally described DS for Security details                                         CAS006
078400200529     C                   PARM                    PSectyd                                      CAS006
078500200529      *
078600200529      ** Cumulative coupon rate
078700200529     C                   PARM                    DDCUCR
078800200529      *
078900200529      ** Current exchange rate
079000200529     C                   PARM                    DDSEXR
079100200529                                                                                              CSE065
079200200529      ** Maturity Date                                                                        CSE065
079300200529     C                   PARM                    DDMATY                                       CSE065
079400200529      *
079500200529      ** Processing type from PF/INVTPD
079600200529     C                   PARM                    PPROT
079700200529      *
079800200529      ** Enable detail fields indicator
079900200529     C                   PARM                    PEDtFld
080000200529      *
080100200529      ** Enable function keys
080200200529      ** KE = command key 05 = Refresh
080300200529      ** KG = command key 07 = Read Previous
080400200529      ** KH = command key 08 = Read Next
080500200529      ** KJ = command key 10 = Delete
080600200529      ** KL = command key 12 = Cancel
080700200529      ** KP = command key 15 = Browse
080800200529     C                   PARM                    PEINKE
080900200529     C                   PARM                    PEINKG
081000200529     C                   PARM                    PEINKH
081100200529     C                   PARM                    PEINKJ
081200200529     C                   PARM                    PEINKL
081300200529     C                   PARM                    PEINKP
081400200529      *
081500200529      ** SE Diary events screen error indicators
081600200529     C                   PARM                    SEESEDE
081700200529      *
081800200529      ** Error fields/message IDs/message data (arrays) from/to caller
081900200529     C                   PARM                    FldNameArr
082000200529     C                   PARM                    MsgIdArr
082100200529     C                   PARM                    MsgDtaArr
082200200529      *
082300200529      ** Warning fields/message Ids/message data (arrays) from/to
082400200529      ** caller
082500200529     C                   PARM                    WFldNamArr
082600200529     C                   PARM                    WMsgIdArr
082700200529     C                   PARM                    WMsgDtaArr
082800200529      *
082900200529      ** Write screen with no read indicator
083000200529     C                   PARM      'N'           WriteOnly
083100200529      *
083200200529      ** STANDING DATA
083300200529      ** =============
083400200529      *
083500200529      ** SDBANK - System runday
083600200529     C                   PARM                    BJMRDT
083700200529      *
083800200529      ** MMODF - Strategic risk management indicator
083900200529     C                   PARM                    RMFL
084000200529      *
084100200529      ** SWITCHABLE FEATURES
084200200529      ** ===================
084300200529      *
084400200529      ** Value currency to be currency of issuer payments
084500200529     C                   PARM                    S01509
084600200529      *
084700200529      ** Dividend payments
084800200529     C                   PARM                    S01510
084900200529                                                                                              CAS006
085000200529      ** Hedge Accounting Phase B                                                             CAS006
085100200529     C                   PARM                    CAS006                                       CAS006
085200200529                                                                                              CSE065
085300200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
085400200529     C                   PARM                    CSE065                                       CSE065
085500200529                                                                                              CSE065
085600200529                                                                                              CGL031
085700200529      ** Taxation on Savings Income                                                           CGL031
085800200529                                                                                              CGL031
085900200529     C                   PARM                    CGL031                                       CGL031
086000200529      *
086100200529      ** OUTPUT
086200200529      ** ======
086300200529      *
086400200529      ** Function keys enabled
086500200529      ** KC = command key 03 = Exit
086600200529      ** KE = command key 05 = Refresh
086700200529      ** KG = command key 07 = Read Previous
086800200529      ** KH = command key 08 = Read Next
086900200529      ** KJ = command key 10 = Delete
087000200529      ** KL = command key 12 = Cancel
087100200529      ** KP = command key 15 = Browse
087200200529     C                   PARM                    PINKC
087300200529     C                   PARM                    PINKE
087400200529     C                   PARM                    PINKG
087500200529     C                   PARM                    PINKH
087600200529     C                   PARM                    PINKJ
087700200529     C                   PARM                    PINKL
087800200529     C                   PARM                    PINKP
087900200529      *
088000200529      ** Save warning message ids array of this screen.
088100200529      *
088200200529     C                   MOVEA     WMsgIDArr     WPrvWarnAr
088300200529      *
088400200529      ** Reset error fields.
088500200529      *
088600200529     C                   EXSR      SRResetErr
088700200529
088800200529     C                   SELECT
088900200529      *
089000200529      ** F3 - end program.
089100200529     C                   WHEN      PINKC = *ON
089200200529     C                   EXSR      SREndP
089300200529      *
089400200529      ** F5 - refresh main screen details.
089500200529     C                   WHEN      PINKE = *ON
089600200529     C                   EXSR      SRSavKey
089700200529     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
089800200529     C                   EXSR      SRRstKey
089900200529     C                   EVAL      WProcOnce = *BLANK
090000200529      *
090100200529      ** F7 - roll backwards.
090200200529     C                   WHEN      PINKG = *ON
090300200529     C                   EXSR      SRRoll
090400200529      *
090500200529      ** F8 - roll forwards.
090600200529     C                   WHEN      PINKH = *ON
090700200529     C                   EXSR      SRRoll
090800200529      *
090900200529      ** F10 - delete record.
091000200529     C                   WHEN      PINKJ = *ON
091100200529     C                   EVAL      WScrn = 'U'
091200200529      *
091300200529      ** F12 - cancel on main screen.
091400200529     C                   WHEN      PINKL = *ON
091500200529      *
091600200529      ** Display initial screen with blank fields.
091700200529      ** Reset read next browse subfile record indicator.
091800200529     C                   EXSR      SRClearScn
091900200529     C                   EVAL      WRdNBrw = *BLANK
092000200529     C                   EVAL      WScrn   = 'I'
092100200529      *
092200200529      ** F15 - build browse.
092300200529     C                   WHEN      PINKP = *ON
092400200529     C                   EXSR      SRBldBrw
092500200529      *
092600200529      ** Enter key was pressed.
092700200529     C                   OTHER
092800200529      *
092900200529      ** Action is Amend or Insert - Validate input to main screen.
093000200529     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
093100200529     C                   EXSR      SRValP
093200200529     C                   GOTO      ESRScrnP
093300200529     C                   ENDIF
093400200529      *
093500200529      ** Action is Enquire
093600200529      ** - Display window screen if window processing is on.
093700200529      ** - Read next browse subfile record if pending option
093800200529      **   still exist.  Otherwise, display initial screen with
093900200529      **   blank screen fields.
094000200529     C                   IF        DDACTN = 'E'
094100200529
094200200529     C                   IF        BGWDPR = 'Y'
094300200529     C                   EVAL      WScrn = 'W'
094400200529     C                   GOTO      ESRScrnP
094500200529     C                   ENDIF
094600200529
094700200529     C                   IF        WRdNBrw = 'Y'
094800200529     C                   EVAL      WScrn = 'R'
094900200529     C                   ELSE
095000200529     C                   EXSR      SRClearScn
095100200529     C                   EVAL      WScrn = 'I'
095200200529     C                   ENDIF
095300200529
095400200529     C                   ENDIF
095500200529
095600200529     C                   ENDSL
095700200529
095800200529     C     ESRScrnP      ENDSR
095900200529      *
096000200529      *****************************************************************
096100200529      /EJECT
096200200529      *****************************************************************
096300200529      *                                                               *
096400200529      *  SRDefault - Process defaulting of default fields             *
096500200529      *                                                               *
096600200529      *****************************************************************
096700200529     C     SRDefault     BEGSR
096800200529
096900200529     C     WProcOnce     IFEQ      *BLANK
097000200529
097100200529     C                   CALLB     'SESEDE1DT'
097200200529      *                             =========
097300200529      ** INPUT
097400200529      ** =====
097500200529      *
097600200529      ** Return code
097700200529     C                   PARM      *BLANKS       RetCodeOut
097800200529      *
097900200529      ** SE Diary events retrieved from file - file format
098000200529     C                   PARM                    CrDEFilFmt
098100200529      *
098200200529      ** Externally described DS for Security details
098300200529     C                   PARM                    PSectyd
098400200529      *
098500200529      ** Event date (Day number)
098600200529     C                   PARM                    PEvtDno
098700200529      *
098800200529      ** STANDING DATA
098900200529      ** =============
099000200529      *
099100200529      ** SDBANK - Date format indicator
099200200529     C                   PARM                    BJDFIN
099300200529      *
099400200529      ** MMODF  - Strategic risk management indicator
099500200529     C                   PARM                    RMFL
099600200529      *
099700200529      ** SWITCHABLE FEATURES
099800200529      ** ===================
099900200529      *
100000200529      ** Dividend payments
100100200529     C                   PARM                    S01510
100200200529      *
100300200529      ** Value currency to be currency of issuer payments
100400200529     C                   PARM                    S01509
100500200529                                                                                              CSE065
100600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
100700200529     C                   PARM                    CSE065                                       CSE065
100800200529                                                                                              CSE065
100900200529                                                                                              CGL031
101000200529      ** Taxation on Savings Income                                                           CGL031
101100200529                                                                                              CGL031
101200200529     C                   PARM                    CGL031                                       CGL031
101300200529      *
101400200529      ** OUTPUT
101500200529      ** ======
101600200529      *
101700200529      ** SE Diary events screen details from incoming transaction
101800200529      ** - screen format
101900200529     C                   PARM                    NwDE1ScnFmt
102000200529      *
102100200529      ** Pay currency
102200200529     C                   PARM                    PPayCcy
102300200529      *
102400200529      ** Cumulative coupon rate
102500200529     C                   PARM                    DDCUCR
102600200529      *
102700200529      ** Current exchange rate
102800200529     C                   PARM                    DDSEXR
102900200529                                                                                              CSE065
103000200529      ** Maturity Date                                                                        CSE065
103100200529     C                   PARM                    DDMATY                                       CSE065
103200200529
103300200529     C                   ENDIF
103400200529      *
103500200529      ** Set default variable to 'Y' to bypass defaulting the
103600200529      ** second time around.
103700200529      *
103800200529     C                   EVAL      WProcOnce = 'Y'
103900200529
104000200529     C                   ENDSR
104100200529      *
104200200529      *****************************************************************
104300200529      /EJECT
104400200529      *****************************************************************
104500200529      *                                                               *
104600200529      *  SRValP - Validate input to main screen                       *
104700200529      *                                                               *
104800200529      *****************************************************************
104900200529     C     SRValP        BEGSR
105000200529      *
105100200529      ** Validate whether non-amendable fields have been amended.
105200200529      *
105300200529     C                   CALLB     'SESEDE1MD'
105400200529      *                             =========
105500200529      ** INPUT
105600200529      ** =====
105700200529      *
105800200529      ** Return code
105900200529     C                   PARM      *BLANKS       RetCodeOut
106000200529      *
106100200529      ** SE Diary events screen details from incoming transaction
106200200529      ** - screen format
106300200529     C                   PARM                    NwDE1ScnFmt
106400200529      *
106500200529      ** SE Diary events screen details retrieved from file
106600200529      ** - screen format
106700200529     C                   PARM                    CrDE1ScnFmt
106800200529      *
106900200529      ** SE Diary events retrieved from file - file format
107000200529     C                   PARM                    CrDEFilFmt
107100200529      *
107200200529      ** Reset of fields in error required (Y/N)
107300200529     C                   PARM      'Y'           PResetFld
107400200529      *
107500200529      ** Pay currency
107600200529     C                   PARM                    PPayCcy
107700200529      *
107800200529      ** STANDING DATA
107900200529      ** =============
108000200529      *
108100200529      ** MMODF - Strategic risk management indicator
108200200529     C                   PARM                    RMFL
108300200529      *
108400200529      ** SWITCHABLE FEATURES
108500200529      ** ===================
108600200529      *
108700200529      ** Value currency to be currency of issuer payments
108800200529     C                   PARM                    S01509
108900200529      *
109000200529      ** Dividend payments
109100200529     C                   PARM                    S01510
109200200529                                                                                              CAS006
109300200529      ** Hedge Accounting Phase B                                                             CAS006
109400200529     C                   PARM                    CAS006                                       CAS006
109500200529      *
109600200529      ** OUTPUT
109700200529      ** ======
109800200529      *
109900200529      ** Error fields/message Ids/message data (arrays) from/to caller
110000200529     C                   PARM                    FldNameArr
110100200529     C                   PARM                    MsgIdArr
110200200529     C                   PARM                    MsgDtaArr
110300200529      *
110400200529      ** Array index (3P0) from/to caller
110500200529     C                   PARM                    IDx
110600200529      *
110700200529      ** SE Diary events screen error indicators
110800200529     C                   PARM                    SEESEDE
110900200529      *
111000200529      ** OK Amendments field
111100200529     C                   PARM                    PAmendOK
111200200529      *
111300200529      ** Validate entries made on the screen.
111400200529      *
111500200529     C                   CALLB     'SESEDE1VL'
111600200529      *                             =========
111700200529      ** INPUT
111800200529      ** =====
111900200529      *
112000200529      ** Return code
112100200529     C                   PARM      *BLANKS       RetCodeOut
112200200529      *
112300200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
112400200529      ** Mode = '      ' (Not Front Office Transaction Interface)
112500200529      ** Mode = '*RPR  ' (Repair function)
112600200529      ** Mode = '*SIN  ' (Screen input function)
112700200529     C                   PARM                    PMode
112800200529      *
112900200529      ** Response mode
113000200529     C                   PARM                    PRespMode
113100200529      *
113200200529      ** SE Diary Events screen details from incoming
113300200529      ** transaction - screen format
113400200529     C                   PARM                    NwDE1ScnFmt
113500200529      *
113600200529      ** Security Diary Events retrieved from file - file format
113700200529     C                   PARM                    CrDEFilFmt
113800200529      *
113900200529      ** Externally described DS for Security details
114000200529     C                   PARM                    PSectyd
114100200529      *
114200200529      ** Processing type from PF/INVTPD
114300200529     C                   PARM                    PPROT
114400200529      *
114500200529      ** Event date (Day number)
114600200529     C                   PARM                    PEvtDno
114700200529      *
114800200529      ** STANDING DATA
114900200529      ** =============
115000200529      *
115100200529      ** SDBANK - Date format indicator
115200200529     C                   PARM                    BJDFIN
115300200529                                                                                              CSE065
115400200529      ** SDBANK - Run day number                                                              CSE065
115500200529     C                   PARM                    BJRDNB                                       CSE065
115600200529      *
115700200529      ** MMODF - Strategic risk management indicator
115800200529     C                   PARM                    RMFL
115900200529      *
116000200529      ** SWITCHABLE FEATURES
116100200529      ** ===================
116200200529      *
116300200529      ** SE Transactions Enhancement
116400200529     C                   PARM                    CSE010
116500200529      *
116600200529      ** Value CCY to be CCY of Issuer Payment
116700200529     C                   PARM                    S01509
116800200529      *
116900200529      ** Dividend Payments Base on EX-Date
117000200529     C                   PARM                    S01510
117100200529                                                                                              CAS006
117200200529      ** Hedge Accounting Phase B                                                             CAS006
117300200529     C                   PARM                    CAS006                                       CAS006
117400200529                                                                                              CSE072
117500200529      ** Brazilian C Bonds                                                                    CSE072
117600200529     C                   PARM                    CSE072                                       CSE072
117700200529                                                                                              CSE065
117800200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
117900200529     C                   PARM                    CSE065                                       CSE065
118000200529                                                                                              CGL031
118100200529      ** Taxation on Savings Income                                                           CGL031
118200200529                                                                                              CGL031
118300200529     C                   PARM                    CGL031                                       CGL031
118400200529      *
118500200529      ** OUTPUT
118600200529      ** ======
118700200529      *
118800200529      ** Error fields/message IDs/message data (arrays) from/to caller
118900200529     C                   PARM                    FldNameArr
119000200529     C                   PARM                    MsgIdArr
119100200529     C                   PARM                    MsgDtaArr
119200200529      *
119300200529      ** Array index (3P0) from/to caller
119400200529     C                   PARM                    IDx
119500200529      *
119600200529      ** Warning flds/message IDs/message data (arrays) from/to caller
119700200529     C                   PARM                    WFldNamArr
119800200529     C                   PARM                    WMsgIdArr
119900200529     C                   PARM                    WMsgDtaArr
120000200529      *
120100200529      ** Array index (3P0) from/to caller
120200200529     C                   PARM                    WIDx
120300200529      *
120400200529      ** SE Diary Events screen error indicators
120500200529     C                   PARM                    SEESEDE
120600200529      *
120700200529      ** SE Diary Events for file update - file format
120800200529     C                   PARM                    NwDEFilFmt
120900200529      *
121000200529      ** Redisplay screen
121100200529     C                   PARM      *BLANK        PReDsp
121200200529
121300200529     C                   EVAL      WReDisplay = *BLANK
121400200529      *
121500200529      ** If no errors occurred during validation of main screen
121600200529      ** fields, check if there are warnings which have not been
121700200529      ** displayed yet.
121800200529      *
121900200529     C                   IF        IDx = *ZERO
122000200529
122100200529     C                   Z-ADD     1             WiX
122200200529
122300200529     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK
122400200529
122500200529     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
122600200529     C                   EVAL      WReDisplay = 'Y'
122700200529     C                   ELSE
122800200529     C                   EVAL      WiX = WiX + 1
122900200529     C                   ENDIF
123000200529
123100200529     C                   ENDDO
123200200529
123300200529     C                   IF        WReDisplay <> 'Y'
123400200529     C                   EXSR      SRResetErr
123500200529     C                   ENDIF
123600200529
123700200529     C                   ENDIF
123800200529      *
123900200529      ** Redisplay main screen if there are errors or if there
124000200529      ** are warnings which have not been displayed yet.
124100200529      *
124200200529     C                   IF        IDx <> *ZERO OR WReDisplay = 'Y' OR
124300200529     C                             PReDsp = 'Y'
124400200529     C                   GOTO      ESRValP
124500200529     C                   ENDIF
124600200529      *
124700200529      ** If windows processing is installed, process window.
124800200529      ** Otherwise process confirmation.
124900200529      *
125000200529     C                   IF        BGWDPR = 'Y'
125100200529     C                   EVAL      WScrn = 'W'
125200200529     C                   ELSE
125300200529     C                   EVAL      WScrn = 'F'
125400200529     C                   ENDIF
125500200529
125600200529     C     ESRValP       ENDSR
125700200529      *
125800200529      *****************************************************************
125900200529      /EJECT
126000200529      *****************************************************************
126100200529      *                                                               *
126200200529      *  SRScrnW - Process Window screen                              *
126300200529      *                                                               *
126400200529      *****************************************************************
126500200529     C     SRScrnW       BEGSR
126600200529      *
126700200529      ** Display window screen.
126800200529      *
126900200529     C                   CALLB     'SESEDE1DP'
127000200529      *                             =========
127100200529      ** INPUT
127200200529      ** =====
127300200529      *
127400200529      ** Return code
127500200529     C                   PARM      *BLANKS       RetCodeOut
127600200529      *
127700200529      ** SE Diary events screen details from incoming transaction
127800200529      ** - screen format
127900200529     C                   PARM                    NwDE1ScnFmt
128000200529      *
128100200529      ** SE Diary events retrieved from file - file format
128200200529     C                   PARM                    CrDEFilFmt
128300200529                                                                                              CAS006
128400200529      ** Externally described DS for Security details                                         CAS006
128500200529     C                   PARM                    PSectyd                                      CAS006
128600200529      *
128700200529      ** Cumulative coupon rate
128800200529     C                   PARM                    DDCUCR
128900200529      *
129000200529      ** Current exchange rate
129100200529     C                   PARM                    DDSEXR
129200200529                                                                                              CSE065
129300200529      ** Maturity Date                                                                        CSE065
129400200529     C                   PARM                    DDMATY                                       CSE065
129500200529      *
129600200529      ** Processing type from PF/INVTPD
129700200529     C                   PARM                    PPROT
129800200529      *
129900200529      ** Enable detail fields indicator
130000200529     C                   PARM                    PEDtFld
130100200529      *
130200200529      ** Enable function keys
130300200529      ** KE = command key 05 = Refresh
130400200529      ** KG = command key 07 = Read Previous
130500200529      ** KH = command key 08 = Read Next
130600200529      ** KJ = command key 10 = Delete
130700200529      ** KL = command key 12 = Cancel
130800200529      ** KP = command key 15 = Browse
130900200529     C                   PARM                    PEINKE
131000200529     C                   PARM                    PEINKG
131100200529     C                   PARM                    PEINKH
131200200529     C                   PARM                    PEINKJ
131300200529     C                   PARM                    PEINKL
131400200529     C                   PARM                    PEINKP
131500200529      *
131600200529      ** SE Diary events screen error indicators
131700200529     C                   PARM                    SEESEDE
131800200529      *
131900200529      ** Error fields/message IDs/message data (arrays) from/to caller
132000200529     C                   PARM                    FldNameArr
132100200529     C                   PARM                    MsgIdArr
132200200529     C                   PARM                    MsgDtaArr
132300200529      *
132400200529      ** Warning fields/message Ids/message data (arrays) from/to
132500200529      ** caller
132600200529     C                   PARM                    WFldNamArr
132700200529     C                   PARM                    WMsgIdArr
132800200529     C                   PARM                    WMsgDtaArr
132900200529      *
133000200529      ** Write screen with no read indicator
133100200529     C                   PARM      'Y'           WriteOnly
133200200529      *
133300200529      ** STANDING DATA
133400200529      ** =============
133500200529      *
133600200529      ** SDBANK - System runday
133700200529     C                   PARM                    BJMRDT
133800200529      *
133900200529      ** MMODF - Strategic risk management indicator
134000200529     C                   PARM                    RMFL
134100200529      *
134200200529      ** SWITCHABLE FEATURES
134300200529      ** ===================
134400200529      *
134500200529      ** Value currency to be currency of issuer payments
134600200529     C                   PARM                    S01509
134700200529      *
134800200529      ** Dividend payments
134900200529     C                   PARM                    S01510
135000200529                                                                                              CAS006
135100200529      ** Hedge Accounting Phase B                                                             CAS006
135200200529     C                   PARM                    CAS006                                       CAS006
135300200529                                                                                              CSE065
135400200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
135500200529     C                   PARM                    CSE065                                       CSE065
135600200529                                                                                              CGL031
135700200529      ** Taxation on Savings Income                                                           CGL031
135800200529                                                                                              CGL031
135900200529     C                   PARM                    CGL031                                       CGL031
136000200529      *
136100200529      ** OUTPUT
136200200529      ** ======
136300200529      *
136400200529      ** Function keys enabled
136500200529      ** KC = command key 03 = Exit
136600200529      ** KE = command key 05 = Refresh
136700200529      ** KG = command key 07 = Read Previous
136800200529      ** KH = command key 08 = Read Next
136900200529      ** KJ = command key 10 = Delete
137000200529      ** KL = command key 12 = Cancel
137100200529      ** KP = command key 15 = Browse
137200200529     C                   PARM                    PINKC
137300200529     C                   PARM                    PINKE
137400200529     C                   PARM                    PINKG
137500200529     C                   PARM                    PINKH
137600200529     C                   PARM                    PINKJ
137700200529     C                   PARM                    PINKL
137800200529     C                   PARM                    PINKP
137900200529      *
138000200529      /COPY WNCPYSRC,SESEDEMV1
138100200529      *
138200200529      ** Call window manager.
138300200529      *
138400200529     C                   CALL      'WN0010'
138500200529     C                   PARM      'SESEDESIN'   PWPgm
138600200529     C                   PARM                    PWKey
138700200529     C                   PARM      DDACTN        PWAction
138800200529     C                   PARM                    Data
138900200529     C                   PARM      *BLANKS       PWRtn
139000200529     C                   PARM                    PWSpare
139100200529
139200200529     C                   SELECT
139300200529      *
139400200529      ** F3 - end program.
139500200529     C                   WHEN      PWRtn = 'Y2U9999'
139600200529     C                   EXSR      SREndP
139700200529      *
139800200529      ** F12 - cancel.  Display initial screen.
139900200529     C                   WHEN      PWRtn = 'USR0790'
140000200529     C                   EVAL      WScrn = 'P'
140100200529      *
140200200529      ** Enter key was pressed.
140300200529     C                   OTHER
140400200529      *
140500200529      ** Action is Amend or Insert - proceed to confirmation screen.
140600200529     C                   IF        DDACTN  = 'I' OR DDACTN = 'A'
140700200529     C                   EVAL      WScrn = 'F'
140800200529     C                   ELSE
140900200529      *
141000200529      ** Action is Enquire
141100200529      ** Read next browse subfile record if pending option
141200200529      ** still exist.  Otherwise, display initial screen with
141300200529      ** blank screen fields.
141400200529     C                   IF        WRdNBrw = 'Y'
141500200529     C                   EVAL      WScrn = 'R'
141600200529     C                   ELSE
141700200529     C                   EXSR      SRClearScn
141800200529     C                   EVAL      WScrn = 'I'
141900200529     C                   ENDIF
142000200529
142100200529     C                   ENDIF
142200200529
142300200529     C                   ENDSL
142400200529
142500200529     C     ESRScrnW      ENDSR
142600200529      *
142700200529      *****************************************************************
142800200529      /EJECT
142900200529      *****************************************************************
143000200529      *                                                               *
143100200529      *  SRScrnF - Process confirmation screen                        *
143200200529      *                                                               *
143300200529      *****************************************************************
143400200529     C     SRScrnF       BEGSR
143500200529      *
143600200529      ** Reset error fields, specifically arrays for warning messages.
143700200529      *
143800200529     C                   EXSR      SRResetErr
143900200529      *
144000200529      ** Entries are valid or only warnings exist.  Output message
144100200529      ** "Press ENTER to apply transaction to database or F12 to change.".
144200200529      *
144300200529     C                   EVAL      WFldNamArr(1) = '*ANY'
144400200529     C                   EVAL      WMsgIdArr(1) = 'MMM1031'
144500200529      *
144600200529      ** Display confirmation screen.
144700200529      *
144800200529     C                   CALLB     'SESEDE1DP'
144900200529      *                             =========
145000200529      ** INPUT
145100200529      ** =====
145200200529      *
145300200529      ** Return code
145400200529     C                   PARM      *BLANKS       RetCodeOut
145500200529      *
145600200529      ** SE Diary events screen details from incoming transaction
145700200529      ** - screen format
145800200529     C                   PARM                    NwDE1ScnFmt
145900200529      *
146000200529      ** SE Diary events retrieved from file - file format
146100200529     C                   PARM                    CrDEFilFmt
146200200529                                                                                              CAS006
146300200529      ** Externally described DS for Security details                                         CAS006
146400200529     C                   PARM                    PSectyd                                      CAS006
146500200529      *
146600200529      ** Cumulative coupon rate
146700200529     C                   PARM                    DDCUCR
146800200529      *
146900200529      ** Current exchange rate
147000200529     C                   PARM                    DDSEXR
147100200529                                                                                              CSE065
147200200529      ** Maturity Date                                                                        CSE065
147300200529     C                   PARM                    DDMATY                                       CSE065
147400200529      *
147500200529      ** Processing type from PF/INVTPD
147600200529     C                   PARM                    PPROT
147700200529      *
147800200529      ** Enable detail fields indicator
147900200529     C                   PARM      'N'           PEDtFld
148000200529      *
148100200529      ** Enable function keys
148200200529      ** KE = command key 05 = Refresh
148300200529      ** KG = command key 07 = Read Previous
148400200529      ** KH = command key 08 = Read Next
148500200529      ** KJ = command key 10 = Delete
148600200529      ** KL = command key 12 = Cancel
148700200529      ** KP = command key 15 = Browse
148800200529     C                   PARM      'N'           PEINKE
148900200529     C                   PARM      'N'           PEINKG
149000200529     C                   PARM      'N'           PEINKH
149100200529     C                   PARM      'N'           PEINKJ
149200200529     C                   PARM      'Y'           PEINKL
149300200529     C                   PARM      'N'           PEINKP
149400200529      *
149500200529      ** SE Diary events screen error indicators
149600200529     C                   PARM                    SEESEDE
149700200529      *
149800200529      ** Error fields/message IDs/message data (arrays) from/to caller
149900200529     C                   PARM                    FldNameArr
150000200529     C                   PARM                    MsgIdArr
150100200529     C                   PARM                    MsgDtaArr
150200200529      *
150300200529      ** Warning fields/message Ids/message data (arrays) from/to
150400200529      ** caller
150500200529     C                   PARM                    WFldNamArr
150600200529     C                   PARM                    WMsgIdArr
150700200529     C                   PARM                    WMsgDtaArr
150800200529      *
150900200529      ** Write screen with no read indicator
151000200529     C                   PARM      'N'           WriteOnly
151100200529      *
151200200529      ** STANDING DATA
151300200529      ** =============
151400200529      *
151500200529      ** SDBANK - System runday
151600200529     C                   PARM                    BJMRDT
151700200529      *
151800200529      ** MMODF - Strategic risk management indicator
151900200529     C                   PARM                    RMFL
152000200529      *
152100200529      ** SWITCHABLE FEATURES
152200200529      ** ===================
152300200529      *
152400200529      ** Value currency to be currency of issuer payments
152500200529     C                   PARM                    S01509
152600200529      *
152700200529      ** Dividend payments
152800200529     C                   PARM                    S01510
152900200529                                                                                              CAS006
153000200529      ** Hedge Accounting Phase B                                                             CAS006
153100200529     C                   PARM                    CAS006                                       CAS006
153200200529                                                                                              CSE065
153300200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
153400200529     C                   PARM                    CSE065                                       CSE065
153500200529                                                                                              CGL031
153600200529      ** Taxation on Savings Income                                                           CGL031
153700200529                                                                                              CGL031
153800200529     C                   PARM                    CGL031                                       CGL031
153900200529      *
154000200529      ** OUTPUT
154100200529      ** ======
154200200529      *
154300200529      ** Function keys enabled
154400200529      ** KC = command key 03 = Exit
154500200529      ** KE = command key 05 = Refresh
154600200529      ** KG = command key 07 = Read Previous
154700200529      ** KH = command key 08 = Read Next
154800200529      ** KJ = command key 10 = Delete
154900200529      ** KL = command key 12 = Cancel
155000200529      ** KP = command key 15 = Browse
155100200529     C                   PARM                    PINKC
155200200529     C                   PARM                    PINKE
155300200529     C                   PARM                    PINKG
155400200529     C                   PARM                    PINKH
155500200529     C                   PARM                    PINKJ
155600200529     C                   PARM                    PINKL
155700200529     C                   PARM                    PINKP
155800200529      *
155900200529      ** Reset error fields.
156000200529      *
156100200529     C                   EXSR      SRResetErr
156200200529
156300200529     C                   SELECT
156400200529      *
156500200529      ** F3 - end program.
156600200529     C                   WHEN      PINKC = *ON
156700200529     C                   EXSR      SREndP
156800200529      *
156900200529      ** F12 - cancel.
157000200529     C                   WHEN      PINKL = *ON
157100200529     C                   EVAL      WScrn  = 'P'
157200200529      *
157300200529      ** Enter key was pressed.  Update record.
157400200529     C                   OTHER
157500200529
157600200529     C                   EVAL      WScrn = 'U'
157700200529     C                   ENDSL
157800200529
157900200529     C     ESRScrnF      ENDSR
158000200529      *
158100200529      *****************************************************************
158200200529      /EJECT
158300200529      *****************************************************************
158400200529      *                                                               *
158500200529      *  SRUpdate - Process file update                               *
158600200529      *                                                               *
158700200529      *****************************************************************
158800200529     C     SRUpdate      BEGSR
158900200529      *
159000200529      ** Action is delete - Update record id to 'C'.
159100200529      *
159200200529     C                   IF        DDACTN = 'D'
159300200529     C
159400200529      *                                                                                       260331
159500200529      ** If Record Id is 'D', reset SDDT to zero                                              260331
159600200529      *                                                                                       260331
159700200529     C                   IF        S2RECI = 'D'                                               260331
159800200529     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                             260331
159900200529     C                               OR S2SDET = 'PP'                                         260331
160000200529     C                   Z-ADD     0             S2SDDT                                       260331
160100200529     C                   ENDIF                                                                260331
160200200529      *                                                                                      260191A
160300200529     C                   ELSE                                                                260191A
160400200529     C                   IF        S2RECI = 'M'                                              260191A
160500200529     C                   MOVE      'N'           NOTALL            1                         260191A
160600200529     C     S2SDSN        SETLL     POSETDF                                                   260191A
160700200529     C     S2SDSN        READE     POSETDF                                02                 260191A
160800200529     C                   DOW       NOT *IN02                                                 260191A
160900200529      *                                                                                      260191A
161000200529     C     S2SDET        IFEQ      'MP'                                                      260191A
161100200529     C     S2SDET        OREQ      'DV'                                                      260191A
161200200529     C     S01512        ANDNE     'Y'                                                       260191A
161300200529     C                   Z-ADD     S2SDPD        WWPDUD            5 0                       260191A
161400200529     C                   ELSE                                                                260191A
161500200529     C                   Z-ADD     S2SDED        WWPDUD                                      260191A
161600200529     C                   ENDIF                                                               260191A
161700200529      *                                                                                      260191A
161800200529     C                   IF        S2SDET = F3PEVT and WWPDUD = F3PDUD                       260191A
161900200529     C                             AND F3RECI = 'M'                                          260191A
162000200529     C                   MOVE      'Y'           NOTALL                                      260191A
162100200529     C                   ENDIF                                                               260191A
162200200529      *                                                                                      260191A
162300200529     C     S2SDSN        READE     POSETDF                                02                 260191A
162400200529     C                   ENDDO                                                               260191A
162500200529      *                                                                                      260191A
162600200529     C                   IF        NOTALL = 'N'                                              260191A
162700200529     C                   Z-ADD     0             S2SDDT                                      260191A
162800200529     C                   ENDIF                                                               260191A
162900200529     C                   ENDIF                                                               260191A
163000200529      *                                                                                      260191A
163100200529     C                   ENDIF                                                                260331
163200200529      *                                                                                       260331
163300200529     C                   EVAL      S2RECI = 'C'
163400200529     C                   ENDIF
163500200529      *
163600200529      ** Action is insert.
163700200529     C                   IF        DDACTN = 'I'
163800200529     C                   EVAL      S2RECI = 'D'
163900200529     C                   EVAL      S2SDSN = DDSDSN
164000200529     C                   EVAL      S2SDED = PEvtDno
164100200529     C                   EVAL      S2SDET = DDSDET
164200200529     C                   EVAL      S2NMCY = D1NMCY
164300200529     C                   ENDIF
164400200529      *
164500200529      ** Setup last change type according to action done.
164600200529      *
164700200529     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
164800200529     C                             DDACTN = 'D'
164900200529     C                   EVAL      S2CHTP = DDACTN
165000200529     C                   ENDIF
165100200529      *
165200200529      ** Update file.
165300200529     C                   CALLB     'SESEDEUPD'
165400200529      *                             =========
165500200529      ** INPUT
165600200529      ** =====
165700200529      *
165800200529      ** Return code
165900200529     C                   PARM      *BLANKS       RetCodeOut
166000200529      *
166100200529      ** SE Diary events for file update - file format
166200200529     C                   PARM                    NwDEFilFmt
166300200529      *
166400200529      ** STANDING DATA
166500200529      ** =============
166600200529      *
166700200529      ** SDBANK - Single branch code
166800200529     C                   PARM                    BJSBRC
166900200529      *
167000200529      ** SDBANK - Run day number
167100200529     C                   PARM                    BJRDNB
167200200529      *
167300200529      ** SDBANK - Date format indicator
167400200529     C                   PARM                    BJDFIN
167500200529      *
167600200529      ** SDSTRD - Back value period
167700200529     C                   PARM                    BVBVP
167800200529      *
167900200529      ** ZMUSER - Default branch
168000200529     C                   PARM                    PDBRN
168100200529      *
168200200529      ** SWITCHABLE FEATURES
168300200529      ** ===================
168400200529      *
168500200529      ** SE Transaction enhancement
168600200529     C                   PARM                    CSE010
168700200529      *
168800200529      ** Value currency to be currency of issuer payments
168900200529     C                   PARM                    S01509
169000200529      *                                                                                       CSE031
169100200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
169200200529     C                   PARM                    CSE031                                       CSE031
169300200529                                                                                              CSE065
169400200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
169500200529     C                   PARM                    CSE065                                       CSE065
169600200529      *
169700200529      ** If errors occurred on update, rollback uncommitted file
169800200529      ** changes.
169900200529      *
170000200529     C                   IF        RetCodeOut <> *BLANKS AND
170100200529     C                             RetCodeOut <> '*RECUPD'
170200200529
170300200529     C                   If        (CSC022 = 'N')                                            BUG2604
170400200529     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
170500200529     C                   ROLBK
170600200529     C                   EndIf                                                               BUG2604
170700200529     C                   EXSR      *PSSR
170800200529
170900200529     C                   ELSE
171000200529
171100200529     C                   IF        RetCodeOut = '*RECUPD'
171200200529     C                   If        (CSC022 = 'N')                                            BUG2604
171300200529     C                   ROLBK
171400200529     C                   Else                                                                BUG2604
171500200529     C                   If        wCommitSkip = 'N'                                         BUG2604
171600200529     C                   ROLBK                                                               BUG2604
171700200529     C                   Else                                                                BUG2604
171800200529     C                   Seton                                        U7U8                   BUG2604
171900200529     C                   Endif                                                               BUG2604
172000200529     C                   Endif                                                               BUG2604
172100200529     C                   ELSE
172200200529     C                   If        (CSC022 = 'N')                                            BUG2604
172300200529     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
172400200529     C                   COMMIT
172500200529     C                   EndIf                                                               BUG2604
172600200529     C                   ENDIF
172700200529
172800200529     C                   ENDIF
172900200529      *
173000200529      ** If update not done due to record being updated by another
173100200529      ** workstation, display message "The last transaction was not
173200200529      ** applied to the database." to the next screen.
173300200529      *
173400200529     C                   IF        RetCodeOut = '*RECUPD'
173500200529     C                   Z-ADD     1             IDx
173600200529     C                   Eval      FldNameArr(IDx) = '*ANY'
173700200529     C                   Eval      MsgIdArr(IDx) = 'APM1000'
173800200529     C                   ENDIF
173900200529      *
174000200529      ** Read next browse subfile record.
174100200529      *
174200200529     C                   IF        WRdNBrw = 'Y'
174300200529     C                   EVAL      WScrn = 'R'
174400200529     C                   GOTO      ESRUpdate
174500200529     C                   ENDIF
174600200529      *
174700200529      ** Display initial screen with blank screen fields.
174800200529      *
174900200529     C                   EXSR      SRClearScn
175000200529     C                   EVAL      WScrn = 'I'
175100200529
175200200529     C     ESRUpdate     ENDSR
175300200529      *
175400200529      *****************************************************************
175500200529      /EJECT
175600200529      *****************************************************************
175700200529      *                                                               *
175800200529      *  SRBldBrw - Build browse subfile record                       *
175900200529      *                                                               *
176000200529      *****************************************************************
176100200529     C     SRBldBrw      BEGSR
176200200529      *
176300200529      ** Reset Read Next Browse Subfile Record indicator.
176400200529      *
176500200529     C                   EVAL      WRdNBrw = *BLANK
176600200529      *
176700200529      ** Display browse screen.
176800200529      *
176900200529     C                   CALLB     'SESEDEBRW'
177000200529      *                             =========
177100200529      ** INPUT
177200200529      ** =====
177300200529      *
177400200529      ** Return code
177500200529     C                   PARM      *BLANKS       RetCodeOut
177600200529      *
177700200529      ** Key fields (file pointer)
177800200529     C                   PARM                    KeyLists
177900200529      *
178000200529      ** Build subfile
178100200529     C                   PARM      'Y'           PBdSfl
178200200529      *
178300200529      ** Read subfile record
178400200529     C                   PARM      *BLANK        PRdSfl
178500200529      *
178600200529      ** STANDING DATA
178700200529      ** =============
178800200529      *
178900200529      ** SDBANK - Date format indicator
179000200529     C                   PARM                    BJDFIN
179100200529      *
179200200529      ** SDBANK - System runday
179300200529     C                   PARM                    BJMRDT
179400200529      *
179500200529      ** SDBANK - Single branch code
179600200529     C                   PARM                    BJSBRC
179700200529      *
179800200529      ** ZMUSER - Default user branch
179900200529     C                   PARM                    PDBRN
180000200529      *
180100200529      ** OUTPUT
180200200529      ** ======
180300200529      *
180400200529      ** Error message
180500200529     C                   PARM                    PErrMs
180600200529      *
180700200529      ** Option selected
180800200529     C                   PARM                    POpSel
180900200529      *
181000200529      ** Key fields selected
181100200529      **  Security shortname
181200200529      **  Event date
181300200529      **  Event type
181400200529     C                   PARM                    PSDSNSel
181500200529     C                   PARM                    PSDEDSel
181600200529     C                   PARM                    PSDETSel
181700200529      *
181800200529      ** Function keys enabled
181900200529      ** KC = Command key 03 = Exit
182000200529      ** KL = Command key 12 = Cancel
182100200529     C                   PARM                    PINKC
182200200529     C                   PARM                    PINKL
182300200529
182400200529     C                   SELECT
182500200529      *
182600200529      ** F3 - End program.
182700200529     C                   WHEN      PINKC = *ON
182800200529     C                   EXSR      SREndP
182900200529      *
183000200529      ** Error message returned from browse.
183100200529     C                   WHEN      PErrMs <> *BLANKS
183200200529     C                   EXSR      SRSndM
183300200529      *
183400200529      ** F12 - Cancel. Go back to initial screen.
183500200529     C                   WHEN      PINKL = *ON
183600200529      *
183700200529      ** Redisplay Initial screen with blank screen fields.
183800200529     C                   EXSR      SRClearScn
183900200529     C                   EVAL      WScrn = 'I'
184000200529      *
184100200529      ** Enter - read selected subfile records.
184200200529     C                   OTHER
184300200529
184400200529     C                   EVAL      WRdNBrw = 'Y'
184500200529     C                   EVAL      WScrn   = 'R'
184600200529
184700200529     C                   ENDSL
184800200529
184900200529     C     ESRBldBrw     ENDSR
185000200529      *
185100200529      *****************************************************************
185200200529      /EJECT
185300200529      *****************************************************************
185400200529      *                                                               *
185500200529      *  SRRdNBrw - Read next browse subfile record                   *
185600200529      *                                                               *
185700200529      *****************************************************************
185800200529     C     SRRdNBrw      BEGSR
185900200529      *
186000200529      ** Display browse screen.
186100200529      *
186200200529     C                   CALLB     'SESEDEBRW'
186300200529      *                             =========
186400200529      ** INPUT
186500200529      ** =====
186600200529      *
186700200529      ** Return code
186800200529     C                   PARM      *BLANKS       RetCodeOut
186900200529      *
187000200529      ** Key fields (file pointer)
187100200529     C                   PARM      *BLANKS       KeyLists
187200200529      *
187300200529      ** Build subfile
187400200529     C                   PARM      *BLANK        PBdSfl
187500200529      *
187600200529      ** Read subfile record
187700200529     C                   PARM      'Y'           PRdSfl
187800200529      *
187900200529      ** STANDING DATA
188000200529      ** =============
188100200529      *
188200200529      ** SDBANK - Date format indicator
188300200529     C                   PARM                    BJDFIN
188400200529      *
188500200529      ** SDBANK - System runday
188600200529     C                   PARM                    BJMRDT
188700200529      *
188800200529      ** SDBANK - Single branch code
188900200529     C                   PARM                    BJSBRC
189000200529      *
189100200529      ** ZMUSER - Default user branch
189200200529     C                   PARM                    PDBRN
189300200529      *
189400200529      ** OUTPUT
189500200529      ** ======
189600200529      *
189700200529      ** Error message
189800200529     C                   PARM                    PErrMs
189900200529      *
190000200529      ** Option selected
190100200529     C                   PARM                    POpSel
190200200529      *
190300200529      ** Key fields selected
190400200529      ** Security shortname
190500200529      ** Event date
190600200529      ** Event type
190700200529     C                   PARM                    PSDSNSel
190800200529     C                   PARM                    PSDEDSel
190900200529     C                   PARM                    PSDETSel
191000200529      *
191100200529      ** Function keys enabled
191200200529      ** KC = Command key 03 = Exit
191300200529      ** KL = Command key 12 = Cancel
191400200529     C                   PARM                    PINKC
191500200529     C                   PARM                    PINKL
191600200529      *
191700200529      ** If no security diary events detail selected from subfile,
191800200529      ** reset read next browse subfile record indicator and then
191900200529      ** display initial screen with blank key fields.
192000200529      *
192100200529     C                   IF        POpSel = *BLANK
192200200529     C                   EXSR      SRClearScn
192300200529     C                   EVAL      WRdNBrw = *BLANK
192400200529     C                   EVAL      WScrn   = 'I'
192500200529     C                   GOTO      ESRRdNBrw
192600200529     C                   ENDIF
192700200529      *
192800200529      ** Update action code with option selected.
192900200529      *
193000200529     C                   EVAL      DDACTN = POPSEL
193100200529      *
193200200529      ** Default action to enquiry if not valid.
193300200529      ** Valid entries are A(Amend), D(Delete) and E(Enquire).
193400200529      *
193500200529     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
193600200529     C                             DDACTN <> 'D'
193700200529     C                   EVAL      DDACTN = 'E'
193800200529     C                   ENDIF
193900200529      *
194000200529      ** Retrieve security diary events details.
194100200529      *
194200200529     C                   EVAL      DDSDSN = PSDSNSel
194300200529     C                   EVAL      DDSDED = PSDEDSel
194400200529     C                   EVAL      DDSDET = PSDETSel
194500200529
194600200529     C                   EXSR      SRRtvSEDE
194700200529      *
194800200529      ** If warning or error occurred in the retrieval of security
194900200529      ** diary events details, display messages on the initial screen.
195000200529      *
195100200529     C                   IF        WIDx <> *ZERO OR IDx = 1 OR IDx > 1 AND
195200200529     C                             MsgIdArr(1) <> 'APM1000'
195300200529     C                   EVAL      WScrn = 'I'
195400200529     C                   GOTO      ESRRdNBrw
195500200529     C                   ENDIF
195600200529      *
195700200529      ** Move the security diary events details from the master
195800200529      ** database file into the update file record.
195900200529      *
196000200529     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
196100200529     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
196200200529      *                                                                                       CSE065
196300200529     C                   IF        CSE065 = 'Y'                                               CSE065
196400200529     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
196500200529     C                   ELSE                                                                 CSE065
196600200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
196700200529     C                   ENDIF                                                                CSE065
196800200529      *
196900200529      ** Put security diary events details on the screen.
197000200529      *
197100200529     C                   EXSR      SRCvtSEDE
197200200529      *
197300200529      ** Initialise work variable for defaulting.
197400200529      *
197500200529     C                   EVAL      WProcOnce = *BLANK
197600200529      *
197700200529      ** Display the main screen.
197800200529      *
197900200529     C                   EVAL      WScrn  = 'P'
198000200529
198100200529     C     ESRRdNBrw     ENDSR
198200200529      *
198300200529      *****************************************************************
198400200529      /EJECT
198500200529      *****************************************************************
198600200529      *                                                               *
198700200529      *  SRRtvSEDE - Retrieve security diary events details.          *
198800200529      *                                                               *
198900200529      *****************************************************************
199000200529     C     SRRtvSEDE     BEGSR
199100200529
199200200529                                                                                              CSC011
199300200529      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
199400200529      ** and current system is support system.                                                CSC011
199500200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
199600200529     C                   EVAL      PDate = S1DATE                                             CSC011
199700200529     C                   ELSE                                                                 CSC011
199800200529     C                   EVAL      PDate = BJRDNB                                             CSC011
199900200529     C                   ENDIF                                                                CSC011
200000200529                                                                                              CSC011
200100200529     C                   CALLB     'SESEDERTV'
200200200529      *                             =========
200300200529      ** INPUT
200400200529      ** =====
200500200529      *
200600200529      ** Retun code
200700200529     C                   PARM      *BLANKS       RetCodeOut
200800200529      *
200900200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
201000200529      ** Mode = '      ' (Not Front Office Transaction Interface)
201100200529      ** Mode = '*RPR  ' (Repair function)
201200200529      ** Mode = '*SIN  ' (Screen input function)
201300200529     C                   PARM                    PMode
201400200529      *
201500200529      ** Response mode
201600200529     C                   PARM                    PRespMode
201700200529      *
201800200529      ** Action code
201900200529     C                   PARM                    DDACTN
202000200529      *
202100200529      ** Front office transaction Id
202200200529     C                   PARM      *BLANK        PFRNT
202300200529      *
202400200529      ** Security shortname
202500200529     C                   PARM                    DDSDSN
202600200529      *
202700200529      ** Event date
202800200529     C                   PARM                    DDSDED
202900200529      *
203000200529      ** Event type
203100200529     C                   PARM                    DDSDET
203200200529      *
203300200529      ** STANDING DATA
203400200529      ** =============
203500200529      *
203600200529      ** SDBANK - Single branch code
203700200529     C                   PARM                    BJSBRC
203800200529      *
203900200529      ***SDBANK*- Run day number                                                              CSC011
204000200529     C**********         PARM                    BJRDNB                                       CSC011
204100200529      ** Processing Date                                                                      CSC011
204200200529     C                   PARM                    PDate                                        CSC011
204300200529      *
204400200529      ** SDBANK - Date format indicator
204500200529     C                   PARM                    BJDFIN
204600200529      *
204700200529      ** SDSTRD - Back value period
204800200529     C                   PARM                    BVBVP
204900200529      *
205000200529      ** ZMUSER - Default branch
205100200529     C                   PARM                    PDBRN
205200200529      *
205300200529      ** SWITCHABLE FEATURES
205400200529      ** ===================
205500200529      *
205600200529      ** SE transaction enhancement
205700200529     C                   PARM                    CSE010
205800200529      *
205900200529      ** Value currency to be currency of issuer payments
206000200529     C                   PARM                    S01509
206100200529      *                                                                                       CSE031
206200200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
206300200529     C                   PARM                    CSE031                                       CSE031
206400200529                                                                                              CSE065
206500200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
206600200529     C                   PARM                    CSE065                                       CSE065
206700200529      *
206800200529      ** OUTPUT
206900200529      ** ======
207000200529      *
207100200529      ** Error fields/message IDs/message data (arrays) from/to caller
207200200529     C                   PARM                    FldNameArr
207300200529     C                   PARM                    MsgIdArr
207400200529     C                   PARM                    MsgDtaArr
207500200529      *
207600200529      ** Array index (3P0) from/to caller
207700200529     C                   PARM                    IDx
207800200529      *
207900200529      ** Warning fields/message IDs/message data (arrays) from/to caller
208000200529     C                   PARM                    WFldNamArr
208100200529     C                   PARM                    WMsgIDArr
208200200529     C                   PARM                    WMsgDtaArr
208300200529      *
208400200529      ** Array index (3P0) from/to caller
208500200529     C                   PARM                    WIDx
208600200529      *
208700200529      ** OK Action code
208800200529     C                   PARM                    OKACTN
208900200529      *
209000200529      ** OK Security shortname
209100200529     C                   PARM                    OKSDSN
209200200529      *
209300200529      ** OK Event date
209400200529     C                   PARM                    OKSDED
209500200529      *
209600200529      ** OK Event type
209700200529     C                   PARM                    OKSDET
209800200529      *
209900200529      ** Security Diary Events retrieved from file - file format
210000200529     C                   PARM                    CrDEFilFmt
210100200529      *
210200200529      ** Externally described DS for Security details
210300200529     C                   PARM                    PSectyd
210400200529      *
210500200529      ** Processing type from PF/INVTPD
210600200529     C                   PARM                    PPROT
210700200529      *
210800200529      ** Event date (Day number)
210900200529     C                   PARM                    PEvtDno
211000200529      *
211100200529      ** Redisplay screen
211200200529     C
211300200529     C                   PARM      *BLANK        PReDsp
211400200529
211500200529     C                   ENDSR
211600200529      *
211700200529      *****************************************************************
211800200529      /EJECT
211900200529      *****************************************************************
212000200529      *                                                               *
212100200529      *  SRCvtSEDE - Converts security diary events details from      *
212200200529      *              file to screen format.                           *
212300200529      *                                                               *
212400200529      *****************************************************************
212500200529     C     SRCvtSEDE     BEGSR
212600200529
212700200529     C                   CALLB     'SESEDECVT'
212800200529      *                             =========
212900200529      ** INPUT
213000200529      ** =====
213100200529      *
213200200529      ** Retun code
213300200529     C                   PARM      *BLANKS       RetCodeOut
213400200529      *
213500200529      ** SE Diary events retrieved from file - file format
213600200529     C                   PARM                    CrDEFilFmt
213700200529      *
213800200529      ** Externally described DS for Security details
213900200529     C                   PARM                    PSectyd
214000200529      *
214100200529      ** Processing type from PF/INVTPD
214200200529     C                   PARM                    PPROT
214300200529      *
214400200529      ** Action code
214500200529     C                   PARM                    DDACTN
214600200529      *
214700200529      ** STANDING DATA
214800200529      ** =============
214900200529      *
215000200529      ** SDBANK - Date format indicator
215100200529     C                   PARM                    BJDFIN
215200200529      *
215300200529      ** MMODF - Strategic risk management indicator
215400200529     C                   PARM                    RMFL
215500200529      *
215600200529      ** SWITCHABLE FEATURES
215700200529      ** ===================
215800200529      *
215900200529      ** Value currency to be currency of issuer payments
216000200529     C                   PARM                    S01509
216100200529      *
216200200529      ** Dividend payments
216300200529     C                   PARM                    S01510
216400200529                                                                                              CAS006
216500200529      ** Hedge Accounting Phase B                                                             CAS006
216600200529     C                   PARM                    CAS006                                       CAS006
216700200529                                                                                              CSE065
216800200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
216900200529     C                   PARM                    CSE065                                       CSE065
217000200529                                                                                              CGL031
217100200529      ** Taxation on Savings Income                                                           CGL031
217200200529                                                                                              CGL031
217300200529     C                   PARM                    CGL031                                       CGL031
217400200529      *
217500200529      ** OUTPUT
217600200529      ** ======
217700200529      *
217800200529      ** SE Diary events screen details from incoming transaction
217900200529      ** - screen format
218000200529     C                   PARM                    CrDE1ScnFmt
218100200529
218200200529     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
218300200529
218400200529     C                   ENDSR
218500200529      *
218600200529      *****************************************************************
218700200529      /EJECT
218800200529      *****************************************************************
218900200529      *                                                               *
219000200529      *  SRRoll - Roll backward or forward through the security       *
219100200529      *           diary events details.                               *
219200200529      *                                                               *
219300200529      *****************************************************************
219400200529     C     SRRoll        BEGSR
219500200529      *
219600200529      ** Reset/clear previous error/warning messages for every new record.
219700200529      *
219800200529     C                   EXSR      SRResetErr
219900200529      *
220000200529      ** Read next or previous record in the security diary events file
220100200529      ** according to function key pressed (F7=INKG or F8=INKH).
220200200529      *
220300200529     C                   IF        PINKG = *ON
220400200529     C                   EVAL      PRdBck = 'Y'
220500200529     C                   EVAL      PRdFwd = *BLANK
220600200529     C                   ELSE
220700200529     C                   EVAL      PRdBck = *BLANK
220800200529     C                   EVAL      PRdFwd = 'Y'
220900200529     C                   ENDIF
221000200529
221100200529     C                   CALLB     'SESEDERED'
221200200529      *                             =========
221300200529      ** INPUT
221400200529      ** =====
221500200529      *
221600200529      ** Return code
221700200529     C                   PARM      *BLANKS       RetCodeOut
221800200529      *
221900200529      ** Security shortname
222000200529      ** Event date
222100200529      ** Event type
222200200529     C                   PARM                    DDSDSN
222300200529     C                   PARM                    DDSDED
222400200529     C                   PARM                    DDSDET
222500200529      *
222600200529      ** Read backwards
222700200529     C                   PARM                    PRdBck
222800200529      *
222900200529      ** Read forwards
223000200529     C                   PARM                    PRdFwd
223100200529      *
223200200529      ** STANDING DATA
223300200529      ** =============
223400200529      *
223500200529      ** SDBANK - Single branch
223600200529     C                   PARM                    BJSBRC
223700200529      *
223800200529      ** SDBANK - Date format indicator
223900200529     C                   PARM                    BJDFIN
224000200529      *
224100200529      ** ZMUSER - Default branch
224200200529     C                   PARM                    PDBRN
224300200529      *
224400200529      ** OUTPUT
224500200529      ** ======
224600200529      *
224700200529      ** Error message
224800200529     C                   PARM                    PErrMs
224900200529      *
225000200529      ** Security shortname
225100200529      ** Event date
225200200529      ** Event type
225300200529     C                   PARM                    PSDSNSel
225400200529     C                   PARM                    PSDEDSel
225500200529     C                   PARM                    PSDETSel
225600200529      *
225700200529      ** If error message returned from read, send it to screen.
225800200529      *
225900200529     C                   IF        PErrMs <> *BLANKS
226000200529     C                   EXSR      SRSndM
226100200529     C                   GOTO      ESRRoll
226200200529     C                   ENDIF
226300200529      *
226400200529      ** Default Action to Enquiry if entry is invalid.  Valid
226500200529      ** entries are A(Amend), D(Delete) and E(Enquire).
226600200529      *
226700200529     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
226800200529     C                             DDACTN <> 'D'
226900200529     C                   EVAL      DDACTN = 'E'
227000200529     C                   ENDIF
227100200529      *
227200200529      ** Retrieve security diary events details.
227300200529      *
227400200529     C                   EVAL      DDSDSN = PSDSNSel
227500200529     C                   EVAL      DDSDED = PSDEDSel
227600200529     C                   EVAL      DDSDET = PSDETSel
227700200529
227800200529     C                   EXSR      SRRtvSEDE
227900200529      *
228000200529      ** If warning or error occurred in the retrieval of security
228100200529      ** diary events details, display messages on the initial screen.
228200200529      *
228300200529     C                   IF        WIDx <> *ZERO OR IDx <> *ZERO
228400200529     C                   EVAL      WScrn = 'I'
228500200529     C                   GOTO      ESRRoll
228600200529     C                   ENDIF
228700200529      *
228800200529      ** Move the security diary events details from the master
228900200529      ** database file into the update file record.
229000200529      *
229100200529     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
229200200529     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
229300200529      *                                                                                       CSE065
229400200529     C                   IF        CSE065 = 'Y'                                               CSE065
229500200529     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
229600200529     C                   ELSE                                                                 CSE065
229700200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
229800200529     C                   ENDIF                                                                CSE065
229900200529      *
230000200529      ** Put security diary events details on the screen.
230100200529      *
230200200529     C                   EXSR      SRCvtSEDE
230300200529      *
230400200529      ** Initialise work variable for defaulting.
230500200529      *
230600200529     C                   EVAL      WProcOnce = *BLANK
230700200529      *
230800200529      ** Display the main screen.
230900200529      *
231000200529     C                   EVAL      WScrn = 'P'
231100200529
231200200529     C     ESRRoll       ENDSR
231300200529      *
231400200529      *****************************************************************
231500200529      /EJECT
231600200529      *****************************************************************
231700200529      *                                                               *
231800200529      *  SRSavKey - Save key fields to a temporary variable.          *
231900200529      *                                                               *
232000200529      *****************************************************************
232100200529     C     SRSavKey      BEGSR
232200200529
232300200529     C                   EVAL      WOACTN = DDACTN
232400200529     C                   EVAL      WDSDSN = DDSDSN
232500200529     C                   EVAL      WDSDED = DDSDED
232600200529     C                   EVAL      WDSDET = DDSDET
232700200529
232800200529     C                   ENDSR
232900200529      *
233000200529      *****************************************************************
233100200529      /EJECT
233200200529      *****************************************************************
233300200529      *                                                               *
233400200529      *  SRRstKey - Restore key fields.                               *
233500200529      *                                                               *
233600200529      *****************************************************************
233700200529     C     SRRstKey      BEGSR
233800200529
233900200529     C                   EVAL      DDACTN = WOACTN
234000200529     C                   EVAL      DDSDSN = WDSDSN
234100200529     C                   EVAL      DDSDED = WDSDED
234200200529     C                   EVAL      DDSDET = WDSDET
234300200529      *
234400200529      ** Initialise keylists for use in browse module.
234500200529     C                   CLEAR                   KeyLists
234600200529
234700200529     C                   ENDSR
234800200529      *
234900200529      *****************************************************************
235000200529      /EJECT
235100200529      *****************************************************************
235200200529      *                                                               *
235300200529      *  SRSetupKey - Setup keys for pointer or selection.            *
235400200529      *                                                               *
235500200529      *****************************************************************
235600200529     C     SRSetupKey    BEGSR
235700200529
235800200529     C                   EVAL      WDSDSN = DDSDSN
235900200529     C                   EVAL      WDSDED = DDSDED
236000200529     C                   EVAL      WDSDET = DDSDET
236100200529
236200200529     C                   ENDSR
236300200529      *
236400200529      *****************************************************************
236500200529      /EJECT
236600200529      *****************************************************************
236700200529      *                                                               *
236800200529      *  SRClearScn - Clear screen data structures                    *
236900200529      *                                                               *
237000200529      *****************************************************************
237100200529     C     SRClearScn    BEGSR
237200200529      *
237300200529      ** Clear screen data structures for new processing.
237400200529      *
237500200529     C                   CLEAR                   CrDE1ScnFmt
237600200529     C                   CLEAR                   NwDE1ScnFmt
237700200529
237800200529     C                   ENDSR
237900200529      *
238000200529      *****************************************************************
238100200529      /EJECT
238200200529      *****************************************************************
238300200529      *                                                               *
238400200529      *  SREndP - Set program to end                                  *
238500200529      *                                                               *
238600200529      *****************************************************************
238700200529     C     SREndP        BEGSR
238800200529      *
238900200529      ** Issue rollback to clear any possible updates in lower
239000200529      ** level programs.
239100200529      *
239200200529     C                   If        (CSC022 = 'N')                                            BUG2604
239300200529     C                   ROLBK
239400200529     C                   Else                                                                BUG2604
239500200529     C                   If        wCommitSkip = 'N'                                         BUG2604
239600200529     C                   ROLBK                                                               BUG2604
239700200529     C                   Else                                                                BUG2604
239800200529     C                   Seton                                        U7U8                   BUG2604
239900200529     C                   Endif                                                               BUG2604
240000200529     C                   Endif                                                               BUG2604
240100200529      *
240200200529      ** Set processing to end program.
240300200529      *
240400200529     C                   EVAL      WScrn = 'E'
240500200529
240600200529     C                   ENDSR
240700200529      *
240800200529      *****************************************************************
240900200529      /EJECT
241000200529      *****************************************************************
241100200529      *                                                               *
241200200529      *  SRSndM - Send error message to screen                        *
241300200529      *                                                               *
241400200529      *****************************************************************
241500200529     C     SRSndM        BEGSR
241600200529      *
241700200529      ** If single branching, user cannot browse file.
241800200529      *
241900200529     C                   IF        PErrMs = 'FXM0292'
242000200529     C                   EVAL      OKACTN = 'N'
242100200529     C                   ENDIF
242200200529      *
242300200529      ** Date format is invalid, user cannot browse file.
242400200529      *
242500200529     C                   IF        PErrMs = 'SEA0398'
242600200529     C                   EVAL      OKSDED = 'N'
242700200529     C                   ENDIF
242800200529      *
242900200529      ** Add error message to array passed to screen.
243000200529      *
243100200529     C                   Z-ADD     1             Ex
243200200529     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
243300200529     C                   EVAL      FldNameArr(Ex) = '*ANY'
243400200529     C                   EVAL      MsgIdArr(Ex) = PErrMs
243500200529
243600200529     C                   ENDSR
243700200529      *
243800200529      *****************************************************************
243900200529      /EJECT
244000200529      *****************************************************************
244100200529      *                                                               *
244200200529      *  SRResetErr - Reset error fields                              *
244300200529      *                                                               *
244400200529      *****************************************************************
244500200529     C     SRResetErr    BEGSR
244600200529      *
244700200529      ** Reset error fields.
244800200529      *
244900200529     C                   CLEAR                   FldNameArr
245000200529     C                   CLEAR                   MsgIDArr
245100200529     C                   CLEAR                   MsgDtaArr
245200200529     C                   CLEAR                   IDx
245300200529
245400200529     C                   CLEAR                   WFldNamArr
245500200529     C                   CLEAR                   WMsgIdArr
245600200529     C                   CLEAR                   WMsgDtaArr
245700200529     C                   CLEAR                   WIDx
245800200529      *
245900200529      ** Initialise screen fields error indicators.
246000200529      *
246100200529     C                   EVAL      SEESEDE = *ALL'Y'
246200200529
246300200529     C                   ENDSR
246400200529      *
246500200529      *****************************************************************
246600200529      /EJECT
246700200529      *****************************************************************
246800200529      *                                                               *
246900200529      *  *INZSR - Program Initialisation                              *
247000200529      *         - This subroutine runs automatically for program      *
247100200529      *           initialisation.                                     *
247200200529      *                                                               *
247300200529      *****************************************************************
247400200529     C     *INZSR        BEGSR
247500200529      *
247600200529      ** Access bank details.
247700200529      *
247800200529     C                   CALLB     'AOBANKR0'
247900200529     C                   PARM      *BLANKS       PRtcd
248000200529     C                   PARM      '*FIRST '     POptn
248100200529     C     SDBANK        PARM      SDBANK        DSFDY
248200200529      *
248300200529      ** Database error
248400200529     C                   IF        PRtcd <> *BLANKS
248500200529     C     *LOCK         IN        LDA
248600200529     C                   EVAL      DBKey = POptn
248700200529     C                   EVAL      DBFile= 'SDBANKPD'
248800200529     C                   EVAL      DBase = 001
248900200529     C                   OUT       LDA
249000200529     C                   EXSR      *PSSR
249100200529     C                   ENDIF
249200200529      *
249300200529      ** Access securities trading ICD details.
249400200529      *
249500200529     C                   CALLB     'AOSTRDR0'
249600200529     C                   PARM      '*DBERR '     PRtcd
249700200529     C                   PARM      '*FIRST '     POptn
249800200529     C     SDSTRD        PARM      SDSTRD        DSSDY
249900200529      *
250000200529      ** Database error
250100200529     C                   IF        PRtcd <> *BLANKS
250200200529     C     *LOCK         IN        LDA
250300200529     C                   EVAL      DBKey = POptn
250400200529     C                   EVAL      DBFile= 'SDSTRDPD'
250500200529     C                   EVAL      DBase = 002
250600200529     C                   OUT       LDA
250700200529     C                   EXSR      *PSSR
250800200529     C                   ENDIF
250900200529      *
251000200529      ** Access Midas modules details.
251100200529      *
251200200529     C                   CALLB     'AOMMODR0'
251300200529     C                   PARM      *BLANKS       PRtCd
251400200529     C                   PARM      '*FIRST '     POptn
251500200529     C     SDMMOD        PARM      SDMMOD        DSFDY
251600200529      *
251700200529      ** Database error.
251800200529     C                   IF        PRtcd <> *BLANKS
251900200529     C     *LOCK         IN        LDA
252000200529     C                   EVAL      DBKey = POptn
252100200529     C                   EVAL      DBFile= 'SDMMODPD'
252200200529     C                   EVAL      DBase = 003
252300200529     C                   OUT       LDA
252400200529     C                   EXSR      *PSSR
252500200529     C                   ENDIF
252600200529      *
252700200529      ** Access SAR file to determine if 'SE Transaction enhancement'
252800200529      ** is installed.
252900200529      *
253000200529     C                   CALLB     'AOSARDR0'
253100200529     C                   PARM      *BLANKS       PRtcd
253200200529     C                   PARM      '*VERIFY'     POptn
253300200529     C                   PARM      'CSE010'      PSarD
253400200529     C     SCSARD        PARM      SCSARD        DSFDY
253500200529      *
253600200529      ** An NRF (No Record Found) return code is valid.
253700200529      ** Issue database error only for error return codes.
253800200529     C                   IF        PRtcd <> *BLANKS AND
253900200529     C                             PRtcd <> '*NRF   '
254000200529     C     *LOCK         IN        LDA
254100200529     C                   EVAL      DBKey = 'CSE010'
254200200529     C                   EVAL      DBFile= 'SCSARDPD'
254300200529     C                   EVAL      DBase = 004
254400200529     C                   OUT       LDA
254500200529     C                   EXSR      *PSSR
254600200529     C                   ENDIF
254700200529
254800200529     C                   IF        PRtcd = *BLANKS
254900200529     C                   MOVEL     'Y'           CSE010
255000200529     C                   ELSE
255100200529     C                   MOVEL     'N'           CSE010
255200200529     C                   ENDIF
255300200529      *
255400200529      ** Access SAR file to determine if 'Value currency to be
255500200529      ** currency of the issuer payment' is installed.
255600200529      *
255700200529     C                   CALLB     'AOSARDR0'
255800200529     C                   PARM      *BLANKS       PRtcd
255900200529     C                   PARM      '*VERIFY'     POptn
256000200529     C                   PARM      'S01509'      PSarD
256100200529     C     SCSARD        PARM      SCSARD        DSFDY
256200200529      *
256300200529      ** An NRF (No Record Found) return code is valid.
256400200529      ** Issue database error only for error return codes.
256500200529     C                   IF        PRtcd <> *BLANKS AND
256600200529     C                             PRtcd <> '*NRF   '
256700200529     C     *LOCK         IN        LDA
256800200529     C                   EVAL      DBKey = 'S01509'
256900200529     C                   EVAL      DBFile= 'SCSARDPD'
257000200529     C                   EVAL      DBase = 005
257100200529     C                   OUT       LDA
257200200529     C                   EXSR      *PSSR
257300200529     C                   ENDIF
257400200529
257500200529     C                   IF        PRtcd = *BLANKS
257600200529     C                   MOVEL     'Y'           S01509
257700200529     C                   ELSE
257800200529     C                   MOVEL     'N'           S01509
257900200529     C                   ENDIF
258000200529      *
258100200529      ** Access SAR file to determine if 'Dividend Payments'
258200200529      ** is installed.
258300200529      *
258400200529     C                   CALLB     'AOSARDR0'
258500200529     C                   PARM      *BLANKS       PRtcd
258600200529     C                   PARM      '*VERIFY'     POptn
258700200529     C                   PARM      'S01510'      PSarD
258800200529     C     SCSARD        PARM      SCSARD        DSFDY
258900200529      *
259000200529      ** An NRF (No Record Found) return code is valid.
259100200529      ** Issue database error only for error return codes.
259200200529     C                   IF        PRtcd <> *BLANKS AND
259300200529     C                             PRtcd <> '*NRF   '
259400200529     C     *LOCK         IN        LDA
259500200529     C                   EVAL      DBKey = 'S01510'
259600200529     C                   EVAL      DBFile= 'SCSARDPD'
259700200529     C                   EVAL      DBase = 006
259800200529     C                   OUT       LDA
259900200529     C                   EXSR      *PSSR
260000200529     C                   ENDIF
260100200529
260200200529     C                   IF        PRtcd = *BLANKS
260300200529     C                   MOVEL     'Y'           S01510
260400200529     C                   ELSE
260500200529     C                   MOVEL     'N'           S01510
260600200529     C                   ENDIF
260700200529                                                                                              CSC011
260800200529      ** Determine if CSC011 is installed                                                     CSC011
260900200529                                                                                              CSC011
261000200529     C                   CALLB     'AOSARDR0'                                                 CSC011
261100200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
261200200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
261300200529     C                   PARM      'CSC011'      PSARD                                        CSC011
261400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
261500200529                                                                                              CSC011
261600200529      ** An NRF (No Record Found) return code is valid.                                       CSC011
261700200529      ** Issue database error only for error return codes.                                    CSC011
261800200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
261900200529     C     *LOCK         IN        LDA                                                        CSC011
262000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
262100200529     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
262200200529     C                   EVAL      DBASE = 7                                                  CSC011
262300200529     C                   OUT       LDA                                                        CSC011
262400200529     C                   EXSR      *PSSR                                                      CSC011
262500200529     C                   ENDIF                                                                CSC011
262600200529                                                                                              CSC011
262700200529     C                   IF        PRTCD = *BLANKS                                            CSC011
262800200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
262900200529     C                   IN        SC24X7                                                     CSC011
263000200529     C                   IN        SDSTAT                                                     CSC011
263100200529     C                   ELSE                                                                 CSC011
263200200529     C                   EVAL      CSC011 = 'N'                                               CSC011
263300200529     C                   ENDIF                                                                CSC011
263400200529      *                                                                                       CSE031
263500200529      ** Access SAR file to determine if 'Coupon Fixing for                                   CSE031
263600200529      ** Floating Rate Note' is installed.                                                    CSE031
263700200529      *                                                                                       CSE031
263800200529     C                   CALLB     'AOSARDR0'                                                 CSE031
263900200529     C                   PARM      *BLANKS       PRtcd                                        CSE031
264000200529     C                   PARM      '*VERIFY'     POptn                                        CSE031
264100200529     C                   PARM      'CSE031'      PSarD                                        CSE031
264200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
264300200529      *                                                                                       CSE031
264400200529      ** An NRF (No Record Found) return code is valid.                                       CSE031
264500200529      ** Issue database error only for error return codes.                                    CSE031
264600200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
264700200529     C                             PRtcd <> '*NRF   '                                         CSE031
264800200529     C     *LOCK         IN        LDA                                                        CSE031
264900200529     C                   EVAL      DBKey = 'CSE031'                                           CSE031
265000200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE031
265100200529     C                   EVAL      DBase = 8                                                  CSE031
265200200529     C                   OUT       LDA                                                        CSE031
265300200529     C                   EXSR      *PSSR                                                      CSE031
265400200529     C                   ENDIF                                                                CSE031
265500200529                                                                                              CSE031
265600200529     C                   IF        PRtcd = *BLANKS                                            CSE031
265700200529     C                   MOVEL     'Y'           CSE031                                       CSE031
265800200529     C                   ELSE                                                                 CSE031
265900200529     C                   MOVEL     'N'           CSE031                                       CSE031
266000200529     C                   ENDIF                                                                CSE031
266100200529                                                                                              CAS006
266200200529      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
266300200529      ** Phase B(CAS006)' is installed.                                                       CAS006
266400200529                                                                                              CAS006
266500200529     C                   CALLB     'AOSARDR0'                                                 CAS006
266600200529     C                   PARM      *BLANKS       PRtcd                                        CAS006
266700200529     C                   PARM      '*VERIFY'     POptn                                        CAS006
266800200529     C                   PARM      'CAS006'      PSarD                                        CAS006
266900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
267000200529                                                                                              CAS006
267100200529      ** An NRF (No Record Found) return code is valid.                                       CAS006
267200200529      ** Issue database error only for error return codes.                                    CAS006
267300200529     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
267400200529     C                             PRtcd <> '*NRF   '                                         CAS006
267500200529     C     *LOCK         IN        LDA                                                        CAS006
267600200529     C                   EVAL      DBKey = 'CAS006'                                           CAS006
267700200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
267800200529     C                   EVAL      DBase = 009                                                CAS006
267900200529     C                   OUT       LDA                                                        CAS006
268000200529     C                   EXSR      *PSSR                                                      CAS006
268100200529     C                   ENDIF                                                                CAS006
268200200529                                                                                              CAS006
268300200529     C                   IF        PRtcd = *BLANKS                                            CAS006
268400200529     C                   MOVEL     'Y'           CAS006                                       CAS006
268500200529     C                   ELSE                                                                 CAS006
268600200529     C                   MOVEL     'N'           CAS006                                       CAS006
268700200529     C                   ENDIF                                                                CAS006
268800200529                                                                                              CSE065
268900200529      ** Access SAR file to determine if CSE065 is installed                                  CSE065
269000200529                                                                                              CSE065
269100200529     C                   CALL      'AOSARDR0'                                                 CSE065
269200200529     C                   PARM      *BLANKS       PRtcd                                        CSE065
269300200529     C                   PARM      '*VERIFY'     POptn                                        CSE065
269400200529     C                   PARM      'CSE065'      PSarD                                        CSE065
269500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
269600200529                                                                                              CSE065
269700200529      ** An NRF (No Record Found) return code is valid.                                       CSE065
269800200529      ** Issue database error only for error return codes.                                    CSE065
269900200529                                                                                              CSE065
270000200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
270100200529     C                             PRtcd <> '*NRF   '                                         CSE065
270200200529     C     *LOCK         IN        LDA                                                        CSE065
270300200529     C                   EVAL      DBKey = 'CSE065'                                           CSE065
270400200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
270500200529     C                   EVAL      DBase = 010                                                CSE065
270600200529     C                   OUT       LDA                                                        CSE065
270700200529     C                   EXSR      *PSSR                                                      CSE065
270800200529     C                   ENDIF                                                                CSE065
270900200529                                                                                              CSE065
271000200529     C                   IF        PRtcd = *BLANKS                                            CSE065
271100200529     C                   MOVEL     'Y'           CSE065                                       CSE065
271200200529     C                   ELSE                                                                 CSE065
271300200529     C                   MOVEL     'N'           CSE065                                       CSE065
271400200529     C                   ENDIF                                                                CSE065
271500200529                                                                                              CGL031
271600200529      ** Access SAR file to determine if 'Taxation on Savings                                 CGL031
271700200529      ** Income is installed.                                                                 CGL031
271800200529                                                                                              CGL031
271900200529     C                   CALLB     'AOSARDR0'                                                 CGL031
272000200529     C                   PARM      *BLANKS       PRtcd                                        CGL031
272100200529     C                   PARM      '*VERIFY'     POptn                                        CGL031
272200200529     C                   PARM      'CGL031'      PSarD                                        CGL031
272300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
272400200529                                                                                              CGL031
272500200529                                                                                              CGL031
272600200529      ** An NRF (No Record Found) return code is valid.                                       CGL031
272700200529      ** Issue database error only for error return codes.                                    CGL031
272800200529                                                                                              CGL031
272900200529     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
273000200529     C                             PRtcd <> '*NRF   '                                         CGL031
273100200529     C     *LOCK         IN        LDA                                                        CGL031
273200200529     C                   EVAL      DBKey = 'CGL031'                                           CGL031
273300200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CGL031
273400200529     C                   EVAL      DBase = 010                                                CGL031
273500200529     C                   OUT       LDA                                                        CGL031
273600200529     C                   EXSR      *PSSR                                                      CGL031
273700200529     C                   ENDIF                                                                CGL031
273800200529                                                                                              CGL031
273900200529     C                   IF        PRtcd = *BLANKS                                            CGL031
274000200529     C                   MOVEL     'Y'           CGL031                                       CGL031
274100200529     C                   ELSE                                                                 CGL031
274200200529     C                   MOVEL     'N'           CGL031                                       CGL031
274300200529     C                   ENDIF                                                                CGL031
274400200529      *                                                                                      260191A
274500200529      ** Check if S01512 is installed                                                        260191A
274600200529      *                                                                                      260191A
274700200529     C                   CallB     'AOSARDR0'                                                260191A
274800200529     C                   Parm      *BLANKS       PRTCD             7                         260191A
274900200529     C                   Parm      '*VERIFY'     POPTN             7                         260191A
275000200529     C                   Parm      'S01512'      PSARD             6                         260191A
275100200529     C     SCSARD        Parm      SCSARD        DSFDY                                       260191A
275200200529      *                                                                                      260191A
275300200529      ** An NRF (No Record Found) return code is valid.                                      260191A
275400200529      ** Issue database error only for error return codes.                                   260191A
275500200529      *                                                                                      260191A
275600200529     C                   IF        PRtcd <> *BLANKS AND                                      260191A
275700200529     C                             PRtcd <> '*NRF   '                                        260191A
275800200529     C     *LOCK         IN        LDA                                                       260191A
275900200529     C                   EVAL      DBKey = 'S01512'                                          260191A
276000200529     C                   EVAL      DBFile= 'SCSARDPD'                                        260191A
276100200529     C                   EVAL      DBase = 011                                               260191A
276200200529     C                   OUT       LDA                                                       260191A
276300200529     C                   EXSR      *PSSR                                                     260191A
276400200529     C                   ENDIF                                                               260191A
276500200529      *                                                                                      260191A
276600200529     C                   IF        PRTCD = *BLANKS                                           260191A
276700200529     C                   MOVE      'Y'           S01512            1                         260191A
276800200529     C                   ELSE                                                                260191A
276900200529     C                   MOVE      'N'           S01512                                      260191A
277000200529     C                   ENDIF                                                               260191A
277100200529      *
277200200529      *
277300200529      ** Retrieve ZMUSER details.
277400200529      *
277500200529     C     *DTAARA       DEFINE                  ZMUSER
277600200529     C                   IN        ZMUSER
277700200529      *
277800200529      ** Access MMODF to determine if Strategic Risk Man. Ind is on
277900200529      *
278000200529     C                   READ      MMODF                                  01
278100200529
278200200529     C                   EVAL      WScrn = 'I'
278300200529      *
278400200529      ** Access SAR details file to determine if Commitment Control                          BUG2604
278500200529      ** Changes is switched on.                                                             BUG2604
278600200529      *                                                                                      BUG2604
278700200529     C                   CallB     'AOSARDR0'                                                BUG2604
278800200529     C                   Parm      *BLANKS       PRTCD                                       BUG2604
278900200529     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
279000200529     C                   Parm      'CSC022'      PSARD                                       BUG2604
279100200529     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
279200200529                                                                                             BUG2604
279300200529     C                   If        PRTCD = *BLANKS                                           BUG2604
279400200529      *                                                                                      BUG2604
279500200529     C                   Eval      CSC022 = 'Y'                                              BUG2604
279600200529     C                   In        SCCMTJOB                                                  BUG2604
279700200529     C                   If        ComitNum > 0                                              BUG2604
279800200529      *                                                                                      BUG2604
279900200529      ** Check if Current Job exists in the Commitment Job Names                             BUG2604
280000200529      ** Data Area.                                                                          BUG2604
280100200529      *                                                                                      BUG2604
280200200529     C                   MoveA     wComitJob     CmtJobNArr                                  BUG2604
280300200529     C     PSJOBNAME     LookUp    CmtJobNArr                             20                 BUG2604
280400200529     C                   If        *IN20                                                     BUG2604
280500200529     C                   Eval      wCommitSkip = 'Y'                                         BUG2604
280600200529     C                   EndIf                                                               BUG2604
280700200529     C                   EndIf                                                               BUG2604
280800200529      *                                                                                      BUG2604
280900200529     C                   Else                                                                BUG2604
281000200529      *                                                                                      BUG2604
281100200529      ** Database error                                                                      BUG2604
281200200529      *                                                                                      BUG2604
281300200529     C                   If        PRTCD <> '*NRF'                                           BUG2604
281400200529     C     *LOCK         In        LDA                                                       BUG2604
281500200529     C                   Eval      DBKey = 'CSC022'                                          BUG2604
281600200529     C                   Eval      DBPgm = 'SESEDECTL'                                       BUG2604
281700200529     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2604
281800200529     C                   Eval      DBase = 10                                                BUG2604
281900200529     C                   Out       LDA                                                       BUG2604
282000200529     C                   ExSr      *PSSR                                                     BUG2604
282100200529     C                   EndIf                                                               BUG2604
282200200529      *                                                                                      BUG2604
282300200529     C                   EndIf                                                               BUG2604
282400200529      *                                                                                      BUG2604
282500200529                                                                                              CSE072
282600200529      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
282700200529      ** (CSE027)' is installed.                                                              CSE072
282800200529                                                                                              CSE072
282900200529     C                   CALLB     'AOSARDR0'                                                 CSE072
283000200529     C                   PARM      *BLANKS       PRtcd                                        CSE072
283100200529     C                   PARM      '*VERIFY'     POptn                                        CSE072
283200200529     C                   PARM      'CSE072'      PSarD                                        CSE072
283300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
283400200529                                                                                              CSE072
283500200529      ** An NRF (No Record Found) return code is valid.                                       CSE072
283600200529      ** Issue database error only for error return codes.                                    CSE072
283700200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
283800200529     C                             PRtcd <> '*NRF   '                                         CSE072
283900200529     C     *LOCK         IN        LDA                                                        CSE072
284000200529     C                   EVAL      DBKey = 'CSE072'                                           CSE072
284100200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
284200200529     C                   EVAL      DBase = 009                                                CSE072
284300200529     C                   OUT       LDA                                                        CSE072
284400200529     C                   EXSR      *PSSR                                                      CSE072
284500200529     C                   ENDIF                                                                CSE072
284600200529                                                                                              CSE072
284700200529     C                   IF        PRtcd = *BLANKS                                            CSE072
284800200529     C                   MOVEL     'Y'           CSE072                                       CSE072
284900200529     C                   ELSE                                                                 CSE072
285000200529     C                   MOVEL     'N'           CSE072                                       CSE072
285100200529     C                   ENDIF                                                                CSE072
285200200529      ** Program, module and procedure names for database error processing
285300200529      ** =================================================================
285400200529      ** The following /COPY sets these values.
285500200529      /COPY ZACPYSRC,DBFIELDS
285600200529      *
285700200529      ** Hook to enable non-core initial processing to be included
285800200529      /COPY WNCPYSRC,SESEDE011
285900200529
286000200529     C                   ENDSR
286100200529      *
286200200529      *****************************************************************
286300200529      /EJECT
286400200529      *****************************************************************
286500200529      *
286600200529      ** The following /COPY contains the standard program status
286700200529      ** subroutine, including a bound call to the DBERRCTL module.
286800200529      /COPY ZACPYSRC,PSSR_ILE
286900200529      *
287000200529      *****************************************************************
287100200529      /EJECT
287200200529      *****************************************************************
287300200529      *
287400200529**  CPY@
287500200529(c) Finastra International Limited 2001
