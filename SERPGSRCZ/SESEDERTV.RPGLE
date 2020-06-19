000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Sec diary events retrieve + actn/key val')    *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDERTV - Security Diary Events Retrieve and Action Code / *
001100200529      *              Key Validation                                   *
001200200529      *                                                               *
001300200529      *  Function: This module retrieves security diary events        *
001400200529      *            details from the database. As it does, it vali-    *
001500200529      *            dates the action code and key fields.              *
001600200529      *                                                               *
001700200529      *  Component of: SESEDESIN                                      *
001800200529      *                SESEDECTL                                      *
001900200529      *                SESEDERPR                                      *
002000200529      *                SESEDEUPC                                      *
002100200529      *                                                               *
002200200529      *  (c) Finastra International Limited 2001                      *
002300200529      *                                                               *
002400200604      *  Last Amend No. 260191A            Date 22May20               *
002500200604      *  Prev Amend No. 260191             Date 22May20               *
002600200604      *                 MD046248           Date 27Oct17               *
002700200529      *                 MD038918           Date 31May16               *
002800200529      *                 260331             Date 31Mar16               *
002900200529      *                 MD000091           Date 17May13               *
003000200529      *                 CRE073             Date 06Dec10               *
003100200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003200200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003300200529      * Midas Plus 1.4 Base ------------------------------------------*
003400200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003500200529      *                 CSD027             Date 09Dec05               *
003600200529      *                 CGL031             Date 05Jul04               *
003700200529      *                 CSE075             Date 17Nov05               *
003800200529      *                 CSE065             Date 08Nov04               *
003900200529      *                 CSE071             Date 19Jul05               *
004000200529      *                 CAS006             Date 21Jan03               *
004100200529      * Midas Release 4.01.03 ----------------------------------------*
004200200529      *                 210122             Date 07Jan03               *
004300200529      * Midas Release 4.01 -------------------------------------------*
004400200529      *                 CSE031             Date 09Nov01               *
004500200529      * Midas Release 4 --------------- Base -------------------------*
004600200529      * Midas DBA 3.05 -----------------------------------------------*
004700200529      *                 CSD006             Date 11Oct00               *
004800200529      *                 CAP140  *CREATE    Date 17Oct00               *
004900200529      *                                                               *
005000200529      *---------------------------------------------------------------*
005100200529      *                                                               *
005200200529      *  260191A- System should not allow deletion of LIVE/MATURED    *
005300200529      *           security diary event if ALL generated position      *
005400200529      *           settlements are still unsettled/live records.       *
005500200529      *           Hence, system will not generate reversal position   *
005600200529      *           settlements.                                        *
005700200529      *  260191 - System should not allow deletion of a security diary*
005800200529      *           event if atleast one live position exists for the   *
005900200529      *           event. This validation is only valid if the diary   *
006000200529      *           event being deleted is still live record. Applied   *
006100200529      *           fix 247625.                                         *
006200200529      *  259978 - System does not allow to do Event type "Conversions"*
006300200529      *           in Security diary Input function.                   *
006400200529      *  MD046248 - Finastra Rebranding                               *
006500200529      *  MD038918 - Rate reset in Bank Fusion. Allow insertion of IR  *
006600200529      *             event for an FRN security with event date equal   *
006700200529      *             to the coupon array or the adjusted coupon date.  *
006800200529      *  260331 - Incorrect posting created due to a deleted diary    *
006900200529      *           event. Applied fix 255857.                          *
007000200529      *         - Applied for MD-37742.                               *
007100200529      *  MD000091 - Event Codes Substitution                          *
007200200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
007300200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
007400200529      *  CGL031 - Taxation of Savings Income (Recompile)              *
007500200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
007600200529      *           (Recompile)                                         *
007700200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
007800200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
007900200529      *  CAS006 - Hedge Accounting Phase B                            *
008000200529      *  210122 - Not possible to insert dividend position settle-    *
008100200529      *           ments and dividend diary events for securities      *
008200200529      *           with processing type '7'.                           *
008300200529      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
008400200529      *  CSD006 - Recompiled over changed SECTYD.                     *
008500200529      *  CAP140 - Conversion of SE Security Diary Event inpyts into   *
008600200529      *           modular structure to use as APIs.                   *
008700200529      *                                                               *
008800200529      *****************************************************************
008900200529      *                                                               *
009000200529      *  Use of indicators.                                           *
009100200529      *                                                               *
009200200529      *    70-72      Use for chaining to file                        *
009300200529      *                                                               *
009400200529      *****************************************************************
009500200529      *                                                               *
009600200529      *  S U B R O U T I N E  I N D E X                               *
009700200529      *                                                               *
009800200529      *  SRInit - Routine to initialise fields                        *
009900200529      *  SRValFrnt - Routine to validate Front Office Transaction     *
010000200529      *              Interface                                        *
010100200529      *  SRValAct - Routine to validate Action Code and Key fields    *
010200200529      *  SRValIns - Routine to validate Action Code 'I'               *
010300200529      *  SRValAmd - Routine to validate Action Code 'A'               *
010400200529      *  SRValDel - Routine to validate Action Code 'D'               *
010500200529      *  SRValEnq - Routine to validate Action Code 'E'               *
010600200529      *  SRAcsSec - Access Security Checking                          *
010700200529      *  SREvtDate - Extra validation for Event Date                  *
010800200529      *  SREvtDate - Extra validation for Event Type                  *
010900200529      *  SRNchDay - Check if Next Change Day is allowed to differ     *
011000200529      *             to Event Day                                      *
011100200529      *  SRZDate1 - Validate and convert date to day number           *
011200200529      *  SRZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
011300200529      *  SRZChkH - Check if date is a holiday in specified currency   *
011400200529      *  *PSSR - Error processing                                     *
011500200529      *  *INZSR - Initialise                                          *
011600200529      *                                                               *
011700200529      *    The *INZSR subroutine will only get called automatically   *
011800200529      *    on entry to the module the first time it is run            *
011900200529      *    (unless you end the program with LR on).  Similarly        *
012000200529      *    D-spec initialisation only happens the first time.  Use    *
012100200529      *    RESET for subsequent passes.                               *
012200200529      *                                                               *
012300200529      *****************************************************************
012400200529      *
012500200529      ** +--------------------------------------+
012600200529      ** ¦ F-specs                              ¦
012700200529      ** ¦ =======                              ¦
012800200529      ** +--------------------------------------+
012900200529      *
013000200529      ** Security Diary Events
013100200529     FSEDEV     IF   E           K DISK    INFSR(*PSSR)
013200200529      *
013300200529      ** Security Diary Events by Front Office Id
013400200529     FSEDEVL2   IF   E           K DISK    INFSR(*PSSR)
013500200529     F                                     RENAME(SEDEVDF:SEDEVD4)
013600200529      *
013700200529      ** Securities by security shortname
013800200529     FSECTY     IF   E           K DISK    INFSR(*PSSR)
013900200529     F                                     PREFIX(F1)
014000200529      *
014100200529      ** Trades by security shortname
014200200529     FTRADSE    IF   E           K DISK    INFSR(*PSSR)
014300200529     F                                     PREFIX(F2)
014400200529      *
014500200529      ** Position Settlement by Security
014600200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)
014700200529     F                                     PREFIX(F3)
014800200529      *
014900200529      *****************************************************************
015000200529      /EJECT
015100200529      *****************************************************************
015200200529      *
015300200529      ** +--------------------------------------+
015400200529      ** ¦ Automatically included D-specs       ¦
015500200529      ** ¦ ==============================       ¦
015600200529      ** +--------------------------------------+
015700200529      *
015800200529      ** Standard D-specs
015900200529      ** ================
016000200529      **
016100200529      ** The following /COPY line includes the LDA layout,
016200200529      ** the copyright array definition,
016300200529      ** and the following named constants:
016400200529      **    True       logical = *on (for indicator processing)
016500200529      **    False      logical = *off (for indicator processing)
016600200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016700200529      **                                    handler)
016800200529      ** and the following variables:
016900200529      **    RunBefore  1A (for the PSSR)
017000200529      *
017100200529      /COPY ZACPYSRC,STD_D_SPEC
017200200529      *
017300200529      ** Program Status Data Structure
017400200529      ** =============================
017500200529      ** The following /COPY line includes all the defined fields in the
017600200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
017700200529      *
017800200529      /COPY ZACPYSRC,PSDS
017900200529      *
018000200529      ** The following /COPY line includes the definitions for error and
018100200529      ** warning message arrays.
018200200529      *
018300200529      /COPY ZACPYSRC,ERR_ARRAYS
018400200529      *
018500200529      ** +--------------------------------------+
018600200529      ** ¦ End of automatically included D-specs¦
018700200529      ** ¦ =====================================¦
018800200529      ** +--------------------------------------+
018900200529      *
019000200529      *****************************************************************
019100200529      /EJECT
019200200529      *****************************************************************
019300200529      *
019400200529      ** +--------------------------------------+
019500200529      ** ¦ Manually included D-specs            ¦
019600200529      ** ¦ =========================            ¦
019700200529      ** +--------------------------------------+
019800200529      *
019900200529      ** +--------------------------------------+
020000200529      ** ¦ Named constants                      ¦
020100200529      ** ¦ ===============                      ¦
020200200529      ** +--------------------------------------+
020300200529      *
020400200529      ** +--------------------------------------+
020500200529      ** ¦ Arrays and Data Structures           ¦
020600200529      ** ¦ ==========================           ¦
020700200529      ** +--------------------------------------+
020800200529      *
020900200529      ** Security diary events retrieved from file - file format
021000200529     D SEDEFmt       E DS                  EXTNAME(SEDEVD)
021100200529      *
021200200529      ** Security diary events retrieved from file - file format
021300200529      ** This DS will be passed to the calling module.
021400200529     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
021500200529     D                                     PREFIX(CR)
021600200529      *
021700200529      ** Investment types details
021800200529     D PInvtpd       E DS                  EXTNAME(INVTPD)
021900200529     D                                     PREFIX(D1)
022000200529      *
022100200529      ** Security Details
022200200529     D PSectyd       E DS                  EXTNAME(SECTYD)
022300200529     D                                     PREFIX(F1)
022400200529      *
022500200529      ** DS for Access Objects - long data structure
022600200529     D DSSDY         E DS                  EXTNAME(DSSDY)
022700200529      *
022800200529      ** DS for Access Objects - short data structure
022900200529     D DSFDY         E DS                  EXTNAME(DSFDY)
023000200529      *
023100200529      ** Indicator Array
023200200529     D Indicators      DS                  BASED(IndicatorP)
023300200529     D  RecNotFnd             70     70
023400200529     D  FrntNotFnd            71     71
023500200529     D  EndOfFile             72     72
023600200529      *
023700200529      ** Coupon Rate Days array
023800200529     D WCD             S              4  0 DIM(12)
023900200529      *
024000200529      ** Coupon Rate Ind. array
024100200529     D WCR             S              1    DIM(12)
024200200529      *
024300200529     D WDat            S              6  0 DIM(12)
024400200529     D TABMTH          S              2  0 DIM(12) CTDATA PERRCD(12)
024500200529     D TABDAY          S              2  0 DIM(12) ALT(TABMTH)
024600200529      *
024700200529      ** +--------------------------------------+
024800200529      ** ¦ Declared variables                   ¦
024900200529      ** ¦ ==================                   ¦
025000200529      ** +--------------------------------------+
025100200529      *
025200200529      ** Index for arrays of error message ids etc.
025300200529     D IDx             S              3P 0
025400200529      *
025500200529      ** Index for arrays of warning error message ids, etc.
025600200529     D WIDx            S              3P 0
025700200529      *
025800200529      ** Pointer for the indicator Array
025900200529     D IndicatorP      S               *   INZ(%Addr(*IN))
026000200529      *
026100200529      ** Entry parameter list definition
026200200529     D PMode           S              6A
026300200529     D PResponse       S              1A
026400200529     D DDACTN          S              1A
026500200529     D FOTRID          S             20A
026600200529     D DDSDSN          S             10A
026700200529     D DDSDED          S              6A
026800200529     D DDSDET          S              2A
026900200529     D BJSBRC          S              3A
027000200529     D BJRDNB          S              5P 0
027100200529     D BJDFIN          S              1A
027200200529     D BVBVP           S              3P 0
027300200529     D PDBRN           S              3A
027400200529     D CSE010          S              1A
027500200529     D S01509          S              1A
027600200529     D OKACTN          S              1A
027700200529     D OKSDSN          S              1A
027800200529     D OKSDED          S              1A
027900200529     D OKSDET          S              1A
028000200529      *
028100200529      ** Parameter list for validation of action code
028200200529     D PActn           S              1A
028300200529     D PError          S              1P 0
028400200529     D PBrc            S              3A
028500200529      *
028600200529     D PRtCd           S              7A
028700200529     D POptn           S              7A
028800200529      *
028900200529      ** Parameters for ZDATE1
029000200529     D PADateIn        S              6A
029100200529     D PDayNoOut       S              5P 0
029200200529     D PErrorFlag      S              1A
029300200529      *
029400200529      ** Parameter list for ZDATE2
029500200529     D PDateIn         S              5P 0
029600200529     D PDateOut        S              6P 0
029700200529     D PADateOut       S              7A
029800200529      *
029900200529      ** Parameters for ZCHKH
030000200529     D PZDayNoIn       S              5P 0
030100200529     D PZCcy           S              3A
030200200529     D PZLoc           S              3A
030300200529     D PZHolInd        S              1A
030400200529      *
030500200529      ** Work fields
030600200529     D WEvtDNo         S              5P 0
030700200529     D WEvtDat         S              6P 0
030800200529     D Wk2N            S              2P 0
030900200529     D Wk4N            S              4P 0
031000200529     D WBKVP           S              5P 0
031100200529     D WNum4           S              4P 0
031200200529     D WZDay           S              2P 0
031300200529     D WZMth           S              2P 0
031400200529     D WZYear          S              2P 0
031500200529     D WEDay           S              2P 0
031600200529     D WEMth           S              2P 0
031700200529     D WEYear          S              2P 0
031800200529     D WEOMDay         S              2P 0
031900200529     D WMYr            S              2P 0
032000200529     D WMYrC           S              3P 0
032100200529     D WIYr            S              2P 0
032200200529     D WIYrC           S              3P 0
032300200529     D WIx             S              2P 0
032400200529     D Work5N          S              5P 0
032500200529     D Work2N          S              2P 0
032600200529     D Work1N          S              1P 0
032700200529      *
032800200529      ** Work fields for parameter
032900200529     D PReDsp          S              1A
033000200529     D PSDSN           S             10A
033100200529     D WESC            S              1A
033200200529     D PPROT           S              1A
033300200529     D WSEDE           S                   LIKE(SEDEFMT)
033400200529     D PEvtDno         S                   LIKE(WEvtDNo)
033500200529     D PCpd            S                   LIKE(PDayNoOut)                                  MD038918
033600200529                                                                                              CSE065
033700200529     D CSE065          S              1A                                                      CSE065
033800200529      **                                                                                    MD000091
033900200529     D BChar           DS                                                                   MD000091
034000200529     D   BLen                  1      2B 0                                                  MD000091
034100200529     D   LenStr                1      2                                                     MD000091
034200200529                                                                                            MD000091
034300200529      *
034400200529      ** +--------------------------------------+
034500200529      ** ¦ End of D-specs                       ¦
034600200529      ** ¦ ==============                       ¦
034700200529      ** +--------------------------------------+
034800200529      *
034900200529      *****************************************************************
035000200529      /EJECT
035100200529      *****************************************************************
035200200529      *
035300200529      ** +--- Start of Main processing -------------------------------+
035400200529      ** ¦                                                            ¦
035500200529      ** ¦ Initial processing is performed automatically.             ¦
035600200529      ** ¦ *INZSR is executed at program activation.                  ¦
035700200529      ** ¦                                                            ¦
035800200529      ** +------------------------------------------------------------+
035900200529      *
036000200529      *****************************************************************
036100200529      * MAIN PROCEDURE                                                *
036200200529      *****************************************************************
036300200529      *
036400200529      ** Initialise.
036500200529      *
036600200529     C                   EXSR      SRInit
036700200529      *
036800200529      ** If the mode is 'Front Office Transaction Interface',
036900200529      ** do (extra) validation for Front Office Transaction Interface.
037000200529      *
037100200529     C                   IF        PMode = '*FRONT'
037200200529     C                   EXSR      SRValFrnt
037300200529      *
037400200529      ** No further validation if errors occurred.
037500200529      *
037600200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
037700200529     C                             OKSDED = 'N' OR OKSDET = 'N'
037800200529     C                   RETURN
037900200529     C                   ENDIF
038000200529
038100200529     C                   ENDIF
038200200529      *
038300200529      ** Validate action code and key fields.
038400200529      *
038500200529     C                   EXSR      SRValAct
038600200529      *
038700200529      ** No further validation if errors occurred.
038800200529      *
038900200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
039000200529     C                             OKSDED = 'N' OR OKSDET = 'N'
039100200529     C                   RETURN
039200200529     C                   ENDIF
039300200529
039400200529     C                   SELECT
039500200529      *
039600200529      ** Additional validation for Insert.
039700200529      *
039800200529     C                   WHEN      DDACTN = 'I'
039900200529     C                   EXSR      SRValIns
040000200529      *
040100200529      ** Additional validation for Amend.
040200200529      *
040300200529     C                   WHEN      DDACTN = 'A'
040400200529     C                   EXSR      SRValAmd
040500200529      *
040600200529      ** Additional validation for Delete.
040700200529      *
040800200529     C                   WHEN      DDACTN = 'D'
040900200529     C                   EXSR      SRValDel
041000200529      *
041100200529      ** Additional validation for Enquire.
041200200529      *
041300200529     C                   WHEN      DDACTN = 'E'
041400200529     C                   EXSR      SRValEnq
041500200529
041600200529     C                   ENDSL
041700200529      *
041800200529      ** No further validation if errors occurred.
041900200529      *
042000200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
042100200529     C                             OKSDED = 'N' OR OKSDET = 'N'
042200200529     C                   RETURN
042300200529     C                   ENDIF
042400200529      *
042500200529      ** Do some extra validation for event date and event type.
042600200529      *
042700200529     C                   EXSR      SrEvtDate
042800200529     C                   EXSR      SrEvtType
042900200529      *
043000200529      ** No further validation if errors occurred.
043100200529      *
043200200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
043300200529     C                             OKSDED = 'N' OR OKSDET = 'N'
043400200529     C                   RETURN
043500200529     C                   ENDIF
043600200529      *
043700200529      ** If Action is not Insert, move file values to outout
043800200529      ** parameter if action code and key fields are valid.
043900200529      *
044000200529     C     DDACTN        IFNE      'I'
044100200529     C                   EVAL      CrDEFilFmt = SEDEFmt
044200200529     C                   ENDIF
044300200529      *
044400200529      ** Access security checking.
044500200529      *
044600200529     C                   IF        PResponse = 'S'
044700200529     C                   EXSR      SRAcsSec
044800200529     C                   ENDIF
044900200529      *
045000200529      ** Return.
045100200529      *
045200200529     C                   RETURN
045300200529
045400200529      *****************************************************************
045500200529      /EJECT
045600200529      *****************************************************************
045700200529      *                                                               *
045800200529      *  SRInit - Routine to initialise fields                        *
045900200529      *                                                               *
046000200529      *****************************************************************
046100200529     C     SRInit        BEGSR
046200200529      *
046300200529      ** Initialise output fields.
046400200529      *
046500200529     C                   CLEAR                   CrDEFilFmt
046600200529     C                   Z-ADD     0             CrSDED
046700200529     C                   Z-ADD     0             CrSDVA
046800200529     C                   Z-ADD     0             CrSRPT
046900200529     C                   Z-ADD     0             CrSDTR
047000200529     C                   Z-ADD     0             CrSDPD
047100200529     C                   Z-ADD     0             CrSDNC
047200200529     C                   Z-ADD     0             CrSDPP
047300200529     C                   Z-ADD     0             CrSDPC
047400200529     C                   Z-ADD     0             CrSDTA
047500200529     C                   Z-ADD     0             CrSDTP
047600200529     C                   Z-ADD     0             CrSDRP
047700200529     C                   Z-ADD     0             CrSDCE
047800200529     C                   Z-ADD     0             CrSDAD
047900200529     C                   Z-ADD     0             CrSDDT
048000200529     C                   Z-ADD     0             CrLCD
048100200529     C                   Z-ADD     0             CrTNLU
048200200529     C                   Z-ADD     0             CrSDCP
048300200529     C                   Z-ADD     0             CrSDXD
048400200529     C                   Z-ADD     0             CrSCRS                                       CAS006
048500200529     C                   Z-ADD     0             CrSLQP                                       CAS006
048600200529     C                   Z-ADD     0             CrSDNN                                       CAS006
048700200529
048800200529     C                   CLEAR                   SEDEFmt
048900200529     C                   Z-ADD     0             SDED
049000200529     C                   Z-ADD     0             SDVA
049100200529     C                   Z-ADD     0             SRPT
049200200529     C                   Z-ADD     0             SDTR
049300200529     C                   Z-ADD     0             SDPD
049400200529     C                   Z-ADD     0             SDNC
049500200529     C                   Z-ADD     0             SDPP
049600200529     C                   Z-ADD     0             SDPC
049700200529     C                   Z-ADD     0             SDTA
049800200529     C                   Z-ADD     0             SDTP
049900200529     C                   Z-ADD     0             SDRP
050000200529     C                   Z-ADD     0             SDCE
050100200529     C                   Z-ADD     0             SDAD
050200200529     C                   Z-ADD     0             SDDT
050300200529     C                   Z-ADD     0             LCD
050400200529     C                   Z-ADD     0             TNLU
050500200529     C                   Z-ADD     0             SDCP
050600200529     C                   Z-ADD     0             SDXD
050700200529     C                   Z-ADD     0             SCRS                                         CAS006
050800200529     C                   Z-ADD     0             SLQP                                         CAS006
050900200529     C                   Z-ADD     0             SDNN                                         CAS006
051000200529
051100200529     C                   CLEAR                   PSectyd
051200200529     C                   Z-ADD     0             F1NMDP
051300200529     C                   Z-ADD     0             F1SIDY
051400200529     C                   Z-ADD     0             F1SLCA
051500200529     C**********         Z-ADD     0             F1ISSR                                       CSD027
051600200529     C                   EVAL      F1ISSR = *BLANKS                                           CSD027
051700200529     C                   Z-ADD     0             F1SDNM
051800200529     C                   Z-ADD     0             F1IDIV
051900200529     C                   Z-ADD     0             F1CD01
052000200529     C                   Z-ADD     0             F1CD02
052100200529     C                   Z-ADD     0             F1CD03
052200200529     C                   Z-ADD     0             F1CD04
052300200529     C                   Z-ADD     0             F1CD05
052400200529     C                   Z-ADD     0             F1CD06
052500200529     C                   Z-ADD     0             F1CD07
052600200529     C                   Z-ADD     0             F1CD08
052700200529     C                   Z-ADD     0             F1CD09
052800200529     C                   Z-ADD     0             F1CD10
052900200529     C                   Z-ADD     0             F1CD11
053000200529     C                   Z-ADD     0             F1CD12
053100200529     C                   Z-ADD     0             F1NEXD
053200200529     C                   Z-ADD     0             F1LCPN
053300200529     C                   Z-ADD     0             F1CPNR
053400200529     C                   Z-ADD     0             F1BASC
053500200529     C                   Z-ADD     0             F1BASS
053600200529     C                   Z-ADD     0             F1MCPN
053700200529     C                   Z-ADD     0             F1MATY
053800200529     C**********         Z-ADD     0             F1RSKC                                       CSD027
053900200529     C                   EVAL      F1RSKC = *BLANKS                                           CSD027
054000200529     C                   Z-ADD     0             F1IADJ
054100200529     C                   Z-ADD     0             F1ITLD
054200200529     C                   Z-ADD     0             F1FCPN
054300200529     C                   Z-ADD     0             F1NCHD
054400200529     C                   Z-ADD     0             F1SINP
054500200529     C                   Z-ADD     0             F1SFPP
054600200529     C                   Z-ADD     0             F1ISSD
054700200529     C                   Z-ADD     0             F1ISSP
054800200529     C**********         Z-ADD     0             F1LMGR                                       CSD027
054900200529     C                   EVAL      F1LMGR = *BLANKS                                           CSD027
055000200529     C                   Z-ADD     0             F1ISSA
055100200529     C                   Z-ADD     0             F1TOTU
055200200529     C                   Z-ADD     0             F1ALRQ
055300200529     C                   Z-ADD     0             F1ALRC
055400200529     C                   Z-ADD     0             F1MGFD
055500200529     C                   Z-ADD     0             F1MGRC
055600200529     C                   Z-ADD     0             F1UNFD
055700200529     C                   Z-ADD     0             F1UNFR
055800200529     C                   Z-ADD     0             F1DCOM
055900200529     C                   Z-ADD     0             F1MKPR
056000200529     C                   Z-ADD     0             F1ORED
056100200529     C                   Z-ADD     0             F1NDVD
056200200529     C                   Z-ADD     0             F1SEXR
056300200529     C                   Z-ADD     0             F1LPRU
056400200529     C                   Z-ADD     0             F1CPDP
056500200529     C                   Z-ADD     0             F1TPHD
056600200529     C                   Z-ADD     0             F1SCPP
056700200529     C                   Z-ADD     0             F1SCPD
056800200529     C                   Z-ADD     0             F1LCD
056900200529     C                   Z-ADD     0             F1TNLU
057000200529     C                   Z-ADD     0             F1CMFQ
057100200529     C                   Z-ADD     0             F1CFCT
057200200529     C                   Z-ADD     0             F1SRBK
057300200529     C**********         Z-ADD     0             F1PPAG                                       CSD027
057400200529     C**********         Z-ADD     0             F1GUAR                                       CSD027
057500200529     C                   EVAL      F1PPAG = *BLANKS                                           CSD027
057600200529     C                   EVAL      F1GUAR = *BLANKS                                           CSD027
057700200529     C                   Z-ADD     0             F1WEIC
057800200529
057900200529     C                   CLEAR                   PInvtpd
058000200529     C**********         Z-ADD     0             D1SDC1                                       CSD027
058100200529     C**********         Z-ADD     0             D1SDC2                                       CSD027
058200200529     C**********         Z-ADD     0             D1SDC3                                       CSD027
058300200529     C                   EVAL      D1SDC1 = *BLANKS                                           CSD027
058400200529     C                   EVAL      D1SDC2 = *BLANKS                                           CSD027
058500200529     C                   EVAL      D1SDC3 = *BLANKS                                           CSD027
058600200529     C                   Z-ADD     0             D1CMGN
058700200529     C                   Z-ADD     0             D1EXPC
058800200529     C                   Z-ADD     0             D1DTRD
058900200529     C                   Z-ADD     0             D1LCD
059000200529     C                   Z-ADD     0             D1TNLU
059100200529     C                   Z-ADD     0             D1DCMF
059200200529     C                   Z-ADD     0             D1PRTO
059300200529
059400200529
059500200529     C                   MOVEL     'Y'           OKACTN
059600200529     C                   MOVEL     'Y'           OKSDSN
059700200529     C                   MOVEL     'Y'           OKSDED
059800200529     C                   MOVEL     'Y'           OKSDET
059900200529      *
060000200529      ** Initialise work variables.
060100200529      *
060200200529     C                   Z-ADD     0             WEvtDNo
060300200529     C                   Z-ADD     0             WEvtDat
060400200529
060500200529     C                   ENDSR
060600200529      *****************************************************************
060700200529      /EJECT
060800200529      *****************************************************************
060900200529      *                                                               *
061000200529      *  SRValFrnt - Routine to validate Front Office Transaction     *
061100200529      *              Interface                                        *
061200200529      *                                                               *
061300200529      *****************************************************************
061400200529
061500200529     C     SRValFrnt     BEGSR
061600200529      *
061700200529      ** Error if action code is not I(Insert), A(Amend), D(Delete) or
061800200529      ** E(Enquire).
061900200529      *
062000200529     C                   IF        DDACTN <> 'I' AND DDACTN <> 'A' AND
062100200529     C                             DDACTN <> 'D' AND DDACTN <> 'E'
062200200529     C                   MOVEL     'N'           OKACTN
062300200529     C                   ADD       1             IDx
062400200529     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
062500200529     C                   EVAL      MsgIdArr(IDx) = 'SEA0303'
062600200529     C                   ENDIF
062700200529      *
062800200529      ** Error if Front Office Transaction Id is blank.
062900200529      *
063000200529     C                   IF        FOTRID = *BLANKS
063100200529     C                   MOVE      'N'           OKACTN
063200200529     C                   ADD       1             IDx
063300200529     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
063400200529     C                   EVAL      MsgIdArr(IDx) = 'APM0201'
063500200529     C                   ENDIF
063600200529      *
063700200529      ** No further validation if errors occurred.
063800200529      *
063900200529     C                   IF        OKACTN = 'N'
064000200529     C                   GOTO      EValFrnt
064100200529     C                   ENDIF
064200200529      *
064300200529      ** Access security diary events details file using Front Office
064400200529      ** Transaction Id.
064500200529      *
064600200529     C     FOTRID        CHAIN     SEDEVL2                            71
064700200529      *
064800200529     C                   IF        DDACTN = 'I'
064900200529      *
065000200529      ** Front Office Transaction Id can't be present already.
065100200529      *
065200200529     C                   IF        FrntNotFnd = False
065300200529     C                   MOVE      'N'           OKACTN
065400200529     C                   ADD       1             IDx
065500200529     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
065600200529     C                   EVAL      MsgIdArr(IDx) = 'APM0102'
065700200529     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
065800200529     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
065900200529     C                   EVAL      MsgDtaArr(IDX) = LenStr +%TRIM(FOTRID)                   MD000091
066000200529     C                   ENDIF
066100200529      *
066200200529     C                   ELSE
066300200529      *
066400200529      ** If not insert, Front Office Transaction Id must be present.
066500200529      *
066600200529     C                   IF        FrntNotFnd = True
066700200529     C                   MOVE      'N'           OKACTN
066800200529     C                   ADD       1             IDx
066900200529     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
067000200529     C                   EVAL      MsgIdArr(IDx) = 'APM0103'
067100200529     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
067200200529     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
067300200529     C                   EVAL      MsgDtaArr(IDX) = LenStr +%TRIM(FOTRID)                   MD000091
067400200529     C                   GOTO      EValFrnt
067500200529     C                   ENDIF
067600200529      *
067700200529      ** If not insert, update security diary events key fields.
067800200529      *
067900200529     C                   MOVEL     SDSN          DDSDSN
068000200529     C                   MOVEL     SDET          DDSDET
068100200529
068200200529     C                   IF        SDED = 99999
068300200529     C                   MOVE      '999999'      DDSDED
068400200529     C                   ELSE
068500200529     C                   Z-ADD     SDED          PDateIn
068600200529     C                   EXSR      SrZDATE2
068700200529     C                   MOVE      PDateOut      DDSDED
068800200529     C                   ENDIF
068900200529
069000200529     C                   ENDIF
069100200529
069200200529     C     EValFrnt      ENDSR
069300200529
069400200529      *****************************************************************
069500200529      /EJECT
069600200529      *****************************************************************
069700200529      *                                                               *
069800200529      *  SRValAct - Routine to validate Action Code and Key fields    *
069900200529      *                                                               *
070000200529      *****************************************************************
070100200529
070200200529     C     SRValAct      BEGSR
070300200529      *
070400200529      ** Error if action code is not I(Insert), A(Amend), D(Delete)
070500200529      ** or E(Enquire).
070600200529      *
070700200529     C                   IF        DDACTN <> 'I' AND DDACTN <> 'A' AND
070800200529     C                             DDACTN <> 'D' AND DDACTN <> 'E'
070900200529     C                   MOVE      'N'           OKACTN
071000200529     C                   ADD       1             Idx
071100200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
071200200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0228'
071300200529     C                   GOTO      EValAct
071400200529     C                   ENDIF
071500200529      *
071600200529      ** Check Security Shortname and call Securities Selection.
071700200529      *
071800200529     C     '?'           SCAN      DDSDSN                                 01
071900200529
072000200529     C                   IF        CSE010 = 'Y' AND
072100200529     C                             PMODE <> '*FRONT' AND *IN01
072200200529     C                   CALL      'SE0043'
072300200529     C                   PARM                    PACTN
072400200529     C                   PARM      '?'           PSDSN
072500200529     C                   IF        PSDSN <> *BLANKS
072600200529     C                   EVAL      DDSDSN = PSDSN
072700200529     C                   ELSE
072800200529     C                   EVAL      DDSDSN = *BLANKS
072900200529     C                   ENDIF
073000200529     C                   EVAL      PReDsp = 'Y'
073100200529     C                   ENDIF
073200200529      *
073300200529      ** If the security shortname is blank, it is an error.
073400200529      *
073500200529     C                   IF        DDSDSN = *BLANKS
073600200529     C                   MOVE      'N'           OKSDSN
073700200529     C                   ADD       1             Idx
073800200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
073900200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0399'
074000200529     C                   ELSE
074100200529      *
074200200529      ** Security shortname must not be a reserved word.
074300200529      *
074400200529     C                   IF        DDSDSN = 'ALL'
074500200529     C                   MOVE      'N'           OKSDSN
074600200529     C                   ADD       1             Idx
074700200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
074800200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0231'
074900200529     C                   ENDIF
075000200529      *
075100200529      ** Retrieve security shortname details inorder to check investment
075200200529      ** type details. Check that the security shortname exists. If
075300200529      ** Insert, security must be an active security.
075400200529      *
075500200529     C     DDSDSN        CHAIN     SECTY                              70
075600200529     C                   IF        RecNotFnd = True OR
075700200529     C                             (DDACTN = 'I' AND F1RECI <> 'D')
075800200529     C                   MOVE      'N'           OKSDSN
075900200529     C                   ADD       1             Idx
076000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
076100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0444'
076200200529     C                   ENDIF
076300200529
076400200529     C                   ENDIF
076500200529      *
076600200529      ** Validate event date. If the event date is blank, it is an
076700200529      ** error.
076800200529      *
076900200529     C                   IF        DDSDED = *BLANKS
077000200529     C                   MOVE      'N'           OKSDED
077100200529     C                   ADD       1             Idx
077200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
077300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0442'
077400200529     C                   ELSE
077500200529      *
077600200529      ** Convert event date into day number for key.
077700200529      *
077800200529     C                   IF        DDSDED <> *ALL'9'
077900200529
078000200529     C                   TESTN                   DDSDED               01
078100200529
078200200529     C                   IF        *IN01 = *OFF
078300200529     C                   MOVE      'N'           OKSDED
078400200529     C                   ADD       1             IDx
078500200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
078600200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0315'
078700200529     C                   ELSE
078800200529
078900200529     C                   EVAL      PADateIn = DDSDED
079000200529     C                   EXSR      SrZDATE1
079100200529     C                   IF        PErrorFlag = 'Y'
079200200529     C                   MOVE      'N'           OKSDED
079300200529     C                   ADD       1             Idx
079400200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
079500200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0315'
079600200529     C                   ELSE
079700200529     C                   Z-ADD     PDayNoOut     WEvtDNo
079800200529     C                   ENDIF
079900200529     C                   ENDIF
080000200529      *
080100200529      ** Event date equal to '999999'.
080200200529     C                   ELSE
080300200529     C                   Z-ADD     99999         WEvtDNo
080400200529     C                   ENDIF
080500200529
080600200529     C                   ENDIF
080700200529      *
080800200529      ** Validate event type. If the event type is blank, it is
080900200529      ** an error.
081000200529      *
081100200529     C                   IF        DDSDET = *BLANKS
081200200529     C                   MOVE      'N'           OKSDET
081300200529     C                   ADD       1             Idx
081400200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
081500200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0443'
081600200529     C                   GOTO      EValAct
081700200529     C                   ENDIF
081800200529      *
081900200529      ** Event type - check for allowable entries.
082000200529      *
082100200529     C                   IF        DDSDET <> 'DV' AND DDSDET <> 'PP'
082200200529     C                             AND DDSDET <> 'MP' AND DDSDET <> 'IR'
082300200529     C                             AND DDSDET <> 'XR' AND DDSDET <> 'RC'
082400200529     C                             AND DDSDET <> 'RP' AND DDSDET <> 'CV'
082500200529     C                             AND DDSDET <> 'BI' AND DDSDET <> 'RI'
082600200529     C                             AND DDSDET <> 'CR' AND DDSDET <> 'OC'
082700200529     C                             AND DDSDET <> 'AL' OR (DDSDET = 'AL'                       CSE065
082800200529     C                             AND CSE065 <> 'Y')                                         CSE065
082900200529     C                   MOVE      'N'           OKSDET
083000200529     C                   ADD       1             Idx
083100200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
083200200529     C                   IF        CSE065 <> 'Y'                                              CSE065
083300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0320'
083400200529      *                                                                                       CSE065
083500200529      ** If CSE065 is on, send this error message instead: "The Event Type                    CSE065
083600200529      ** must be DV, PP, MP, IR, XR, RC, RP, CV, BI, RI, CR, OC or AL.                        CSE065
083700200529     C                   ELSE                                                                 CSE065
083800200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0567'                                  CSE065
083900200529     C                   ENDIF                                                                CSE065
084000200529     C                   ENDIF
084100200529
084200200529     C     EValAct       ENDSR
084300200529      *****************************************************************
084400200529      /EJECT
084500200529      *****************************************************************
084600200529      *                                                               *
084700200529      *  SRValIns - Routine to validate Action Code 'I'               *
084800200529      *                                                               *
084900200529      *****************************************************************
085000200529
085100200529     C     SRValIns      BEGSR
085200200529      *
085300200529      ** An active Diary Events with a duplicate key must not already
085400200529      ** exist.
085500200529      *
085600200529     C     KSEDEV        CHAIN     SEDEV                              70
085700200529     C                   IF        RecNotFnd = False and RECI <> 'C'
085800200529     C                   MOVE      'N'           OKSDSN
085900200529     C                   ADD       1             Idx
086000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
086100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0316'
086200200529     C                   ENDIF
086300200529
086400200529     C                   ENDSR
086500200529
086600200529      *****************************************************************
086700200529      /EJECT
086800200529      *****************************************************************
086900200529      *                                                               *
087000200529      *  SRValAmd - Routine to validate Action Code 'A'               *
087100200529      *                                                               *
087200200529      *****************************************************************
087300200529
087400200529     C     SRValAmd      BEGSR
087500200529      *
087600200529      ** Diary Events must exist as live on file
087700200529      *
087800200529     C     KSEDEV        CHAIN     SEDEV                              70
087900200529     C                   IF        RecNotFnd = True OR RECI <> 'D'
088000200529     C                   MOVE      'N'           OKSDSN
088100200529     C                   ADD       1             Idx
088200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
088300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
088400200529     C                   ENDIF
088500200529
088600200529     C                   ENDSR
088700200529
088800200529      *****************************************************************
088900200529      /EJECT
089000200529      *****************************************************************
089100200529      *                                                               *
089200200529      *  SRValDel - Routine to validate Action Code 'D'               *
089300200529      *                                                               *
089400200529      *****************************************************************
089500200529
089600200529     C     SRValDel      BEGSR
089700200529      *
089800200529      ** Diary Events must exist as live on file
089900200529      *
090000200529     C     KSEDEV        CHAIN     SEDEV                              70
090100200529     C                   IF        RecNotFnd = True OR
090200200529     C                             (RECI <> 'D' AND RECI <> 'M')
090300200529     C                   MOVE      'N'           OKSDSN
090400200529     C                   ADD       1             Idx
090500200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
090600200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
090700200529     C                   GOTO      EValDel
090800200529     C                   ENDIF
090900200529      *                                                                                      260191A
091000200529      ** Use temporary variables to determine if all position settlements                    260191A
091100200529      ** are settled or not.                                                                 260191A
091200200529      *                                                                                      260191A
091300200529     C                   MOVE      'N'           NOTALL            1                         260191A
091400200529     C                   MOVE      'N'           LIVREC            1                         260191A
091500200529      *
091600200529      ** If there are any live position settlements for this security
091700200529      ** event, output message to screen, and prevent deletion.
091800200529      *
091900200529     C     SDSN          SETLL     POSETDF
092000200529     C     SDSN          READE     POSETDF                                02
092100200529     C                   DOW       NOT *IN02
092200200529
092300200529      *                                                                                       260331
092400200529     C     SDET          IFEQ      'MP'                                                       260331
092500200529     C     SDET          OREQ      'DV'                                                       260331
092600200529     C     S01512        ANDNE     'Y'                                                        260331
092700200529     C                   Z-ADD     SDPD          WWPDUD            5 0                        260331
092800200529     C                   ELSE                                                                 260331
092900200529     C                   Z-ADD     SDED          WWPDUD                                       260331
093000200529     C                   ENDIF                                                                260331
093100200529      *                                                                                       260331
093200200529     C**********         IF        F3RECI= 'D' AND SDED = F3PDUD                              260331
093300200529     C**********                   AND SDET = F3PEVT                                          260331
093400200529     C**********         IF        F3RECI = 'D' AND WWPDUD = F3PDUD                   260191 260191A
093500200529     C**********                   AND SDET = F3PEVT AND RECI = 'D'                   260191 260191A
093600200529      *                                                                                      260191A
093700200529      ** System should not allow deletion of Live/Matured security                           260191A
093800200529      ** diary event if generated position settlements are still                             260191A
093900200529      ** live/unsettled.                                                                     260191A
094000200529      *                                                                                      260191A
094100200529     C                   IF        WWPDUD = F3PDUD AND SDET = F3PEVT                         260191A
094200200529     C                   IF        F3RECI = 'M'                                              260191A
094300200529     C                   EVAL      NOTALL = 'Y'                                              260191A
094400200529     C                   ELSEIF    F3RECI = 'D'                                              260191A
094500200529     C                   EVAL      LIVREC = 'Y'                                              260191A
094600200529     C                   ENDIF                                                               260191A
094700200529     C                   ENDIF                                                               260191A
094800200529     C     SDSN          READE     POSETDF                                02                 260191A
094900200529     C                   ENDDO                                                               260191A
095000200529      *                                                                                      260191A
095100200529     C                   IF        NOTALL = 'N' and LIVREC = 'Y'                             260191A
095200200529     C                   MOVE      'N'           OKSDSN
095300200529     C                   ADD       1             Idx
095400200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
095500200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0357'
095600200529     C**********         LEAVE                                                               260191A
095700200529     C                   ENDIF
095800200529     C*****SDSN*         READE     POSETDF                                02                 260191A
095900200529     C**********         ENDDO                                                               260191A
096000200529
096100200529     C     EValDel       ENDSR
096200200529
096300200529      *****************************************************************
096400200529      /EJECT
096500200529      *****************************************************************
096600200529      *                                                               *
096700200529      *  SRValEnq - Routine to validate Action Code 'E'               *
096800200529      *                                                               *
096900200529      *****************************************************************
097000200529
097100200529     C     SRValEnq      BEGSR
097200200529      *
097300200529      ** Diary Events must exist on file
097400200529      *
097500200529     C     KSEDEV        CHAIN     SEDEV                              70
097600200529     C                   IF        RecNotFnd = True
097700200529     C                   MOVE      'N'           OKSDSN
097800200529     C                   ADD       1             Idx
097900200529     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
098000200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
098100200529     C                   ENDIF
098200200529
098300200529     C                   ENDSR
098400200529
098500200529      *****************************************************************
098600200529      /EJECT
098700200529      *****************************************************************
098800200529      *                                                               *
098900200529      *  SREvtDate - Extra validation for Event Date                  *
099000200529      *                                                               *
099100200529      *****************************************************************
099200200529
099300200529     C     SREvtDate     BEGSR
099400200529      *
099500200529      ** If Date is Backvalued, check that it does not go past the
099600200529      ** Backvalue Period specified on SE ICD.
099700200529      *
099800200529     C     BJRDNB        SUB       BVBVP         WBKVP
099900200529     C                   IF        WEvtDNo < WBKVP
100000200529     C                   MOVE      'N'           OKSDED
100100200529     C                   ADD       1             Idx
100200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
100300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0331'
100400200529     C                   ENDIF
100500200529      *
100600200529      ** Check that date is not after date of maturity.
100700200529      *
100800200529     C                   IF        WEvtDNo > F1MATY AND F1MATY <> *ZERO
100900200529     C                   MOVE      'N'           OKSDED
101000200529     C                   ADD       1             Idx
101100200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
101200200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0332'
101300200529     C                   ELSE
101400200529      *
101500200529      ** Check event date not holiday in value currency (nominal is
101600200529      ** blank). Send warning error.
101700200529      *
101800200529     C                   IF        DDACTN = 'I'
101900200529     C                   IF        F1VLCY <> *BLANKS
102000200529     C                   EVAL      PZCcy = F1VLCY
102100200529     C                   ELSE
102200200529     C                   EVAL      PZCcy = F1NMCY
102300200529     C                   ENDIF
102400200529
102500200529     C                   Z-ADD     WEvtDNo       PZDayNoIn
102600200529     C                   EVAL      PZLoc = *BLANKS
102700200529     C                   EXSR      SrZChkH
102800200529
102900200529     C                   IF        PZHolInd = 'H'
103000200529     C                   MOVE      'W'           OKSDED
103100200529     C                   ADD       1             WIdx
103200200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
103300200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0317'
103400200529     C                   ENDIF
103500200529     C                   ENDIF
103600200529      *                                                                                       CSE031
103700200529      ** Allow Amendment of an Event type 'IR' which has been actioned                        CSE031
103800200529      *                                                                                       CSE031
103900200529     C     CSE031        IFEQ      'Y'                                                        CSE031
104000200529     C     DDSDET        ANDNE     'IR'                                                       CSE031
104100200529     C     CSE031        ORNE      'Y'                                                        CSE031
104200200529      *
104300200529      ** Check event date not already actioned.
104400200529      *
104500200529     C                   IF        DDACTN = 'A' AND WEvtDNo < BJRDNB
104600200529     C                             AND SDAD <> *ZEROS
104700200529     C                   MOVE      'N'           OKSDED
104800200529     C                   ADD       1             Idx
104900200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
105000200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0319'
105100200529     C                   ENDIF
105200200529      *                                                                                       CSE031
105300200529     C                   ENDIF                                                                CSE031
105400200529      *
105500200529      ** If type 'IR', check event date matches a rate change date on
105600200529      ** security detail record - not if a Rate change frequency has been
105700200529      ** entered.
105800200529      *
105900200529     C                   IF        DDSDET = 'IR' AND
106000200529     C                             F1RCFQ = *BLANKS
106100200529
106200200529     C                   Z-ADD     *ZEROS        WDat
106300200529     C                   Z-ADD     1             WIx
106400200529
106500200529     C                   Z-ADD     F1CD01        WCD(1)
106600200529     C                   Z-ADD     F1CD02        WCD(2)
106700200529     C                   Z-ADD     F1CD03        WCD(3)
106800200529     C                   Z-ADD     F1CD04        WCD(4)
106900200529     C                   Z-ADD     F1CD05        WCD(5)
107000200529     C                   Z-ADD     F1CD06        WCD(6)
107100200529     C                   Z-ADD     F1CD07        WCD(7)
107200200529     C                   Z-ADD     F1CD08        WCD(8)
107300200529     C                   Z-ADD     F1CD09        WCD(9)
107400200529     C                   Z-ADD     F1CD10        WCD(10)
107500200529     C                   Z-ADD     F1CD11        WCD(11)
107600200529     C                   Z-ADD     F1CD12        WCD(12)
107700200529     C                   EVAL      WCR(01) = F1CR01
107800200529     C                   EVAL      WCR(02) = F1CR02
107900200529     C                   EVAL      WCR(03) = F1CR03
108000200529     C                   EVAL      WCR(04) = F1CR04
108100200529     C                   EVAL      WCR(05) = F1CR05
108200200529     C                   EVAL      WCR(06) = F1CR06
108300200529     C                   EVAL      WCR(07) = F1CR07
108400200529     C                   EVAL      WCR(08) = F1CR08
108500200529     C                   EVAL      WCR(09) = F1CR09
108600200529     C                   EVAL      WCR(10) = F1CR10
108700200529     C                   EVAL      WCR(11) = F1CR11
108800200529     C                   EVAL      WCR(12) = F1CR12
108900200529
109000200529     C                   DO        12            WIx
109100200529     C     WCD(WIx)      IFNE      *ZEROS
109200200529     C                   IF        BJDFIN = 'M'
109300200529     C                   MOVE      WCD(WIx)      WDat(WIx)
109400200529     C                   ELSE
109500200529     C                   MOVEL     WCD(Wix)      Wk2N
109600200529     C                   MOVE      Wk2N          Wk4N
109700200529     C                   MOVE      WCD(WIx)      Wk2N
109800200529     C                   MOVEL     Wk2N          Wk4N
109900200529     C                   MOVE      Wk4N          WDat(WIx)
110000200529     C                   ENDIF
110100200529     C                   ENDIF
110200200529     C                   ENDDO
110300200529      *
110400200529      ** Find the year for the event.
110500200529      *
110600200529     C                   Z-ADD     WEvtDNo       PDateIn
110700200529     C                   EXSR      SrZDATE2
110800200529     C                   MOVE      PDateOut      WIYr
110900200529      *
111000200529      ** Fetch Maturity date year.
111100200529      *
111200200529     C                   Z-ADD     F1MATY        PDateIn
111300200529     C                   EXSR      SrZDATE2
111400200529     C                   MOVE      PDateOut      WMYr
111500200529      *
111600200529      ** Assemble Event date into compatible format and take date
111700200529      ** format M into consideration.
111800200529      *
111900200529     C                   MOVE      DDSDED        Wk2N
112000200529     C                   MOVEL     Wk2N          WEvtDat
112100200529     C     BJDFIN        IFEQ      'M'
112200200529     C                   MOVEL     DDSDED        Wk4N
112300200529     C                   ELSE
112400200529     C                   MOVE      DDSDED        Wk4N
112500200529     C                   MOVEL     DDSDED        Wk2N
112600200529     C                   MOVE      Wk2N          Wk4N
112700200529     C                   ENDIF
112800200529     C                   MOVE      Wk4N          WEvtDat
112900200529      *
113000200529      ** Only Compare Event date against the change date within the
113100200529      ** the event year.
113200200529      *
113300200529     C                   IF        WMYr < 72
113400200529     C     WMYr          ADD       100           WMYrC
113500200529     C                   ELSE
113600200529     C                   Z-ADD     WMYr          WMYrC
113700200529     C                   ENDIF
113800200529
113900200529     C                   IF        WIYr < 72
114000200529     C     WIYr          ADD       100           WIYrC
114100200529     C                   ELSE
114200200529     C                   Z-ADD     WIYr          WIYrC
114300200529     C                   ENDIF
114400200529
114500200529     C                   EVAL      WESC = 'N'
114600200529     C                   DOW       WIYrC <= WMYrC AND WESC = 'N'
114700200529     C                   Z-ADD     1             WIx
114800200529     C                   MOVE      *OFF          *IN34
114900200529
115000200529     C                   DO        12            WIx
115100200529     C                   IF        WDat(WIx) <> *ZEROS
115200200529     C                   MOVEL     WIYr          WDat(WIx)
115300200529
115400200529     C                   IF        WEvtDat = WDat(WIx)
115500200529     C                   IF        WCR(WIx) = 'R' OR WCR(WIx) = 'C'
115600200529     C                   IF        F1RCFQ = *BLANKS
115700200529     C                   MOVE      *ON           *IN34
115800200529     C                   ENDIF
115900200529     C                   ENDIF
116000200529     C                   EVAL      WESC = 'Y'
116100200529     C                   LEAVE
116200200529     C                   ENDIF
116300200529      *                                                                                     MD038918
116400200529      ** If coupon date is to be adjusted, event date equal to the                          MD038918
116500200529      ** adjusted coupon date will also be accepted.                                        MD038918
116600200529      *                                                                                     MD038918
116700200529     C                   IF        NOT *IN34                                                MD038918
116800200529     C                   MOVE      WDat(WIx)     Wk2N                                       MD038918
116900200529     C                   MOVEL     WDat(WIx)     Wk4N                                       MD038918
117000200529     C                   MOVEL     Wk2N          Wk4N                                       MD038918
117100200529     C                   MOVEL     WDat(WIx)     Wk2N                                       MD038918
117200200529     C                   MOVEL     Wk4N          PADateIn                                   MD038918
117300200529     C                   MOVE      Wk2N          PADateIn                                   MD038918
117400200529     C                   EXSR      SRZDate1                                                 MD038918
117500200529     C                   Z-ADD     PDayNoOut     PCpd                                       MD038918
117600200529     C     F1BCNV        IFNE      ' '                                                      MD038918
117700200529     C     F1BCNV        ANDNE     'N'                                                      MD038918
117800200529     C     F1BCNV        IFEQ      'C'                                                      MD038918
117900200529     C                   MOVE      'N'           NCI               1                        MD038918
118000200529     C                   ELSE                                                               MD038918
118100200529     C                   MOVE      'L'           NCI               1                        MD038918
118200200529     C                   ENDIF                                                              MD038918
118300200529     C                   Z-ADD     F1LCPN        WLCPN             5 0                      MD038918
118400200529     C                   Z-ADD     0             F1LCPN                                     MD038918
118500200529     C                   CALL      'SE0045'                                                 MD038918
118600200529     C                   PARM                    F1SITP                                     MD038918
118700200529     C                   PARM                    PCpd                                       MD038918
118800200529     C                   PARM                    F1ITLD                                     MD038918
118900200529     C                   PARM                    F1FCPN                                     MD038918
119000200529     C                   PARM                    WCD                                        MD038918
119100200529     C                   PARM                    WCR                                        MD038918
119200200529     C                   PARM                    F1NMCY                                     MD038918
119300200529     C                   PARM                    PCpd                                       MD038918
119400200529     C                   PARM                    NCI                                        MD038918
119500200529     C                   PARM                    F1BCNV                                     MD038918
119600200529     C                   PARM                    F1MATY                                     MD038918
119700200529     C                   PARM                    F1LCPN                                     MD038918
119800200529     C                   PARM      *BLANKS       HCY1              3                        MD038918
119900200529     C                   PARM      *BLANKS       HCY2              3                        MD038918
120000200529     C                   PARM      *BLANKS       HCY3              3                        MD038918
120100200529     C                   PARM      *BLANKS       HCY4              3                        MD038918
120200200529     C                   PARM      *BLANKS       HCY5              3                        MD038918
120300200529     C                   PARM      *BLANKS       HCY6              3                        MD038918
120400200529     C                   PARM      *BLANKS       HCY7              3                        MD038918
120500200529     C                   PARM      *BLANKS       HCY8              3                        MD038918
120600200529     C                   PARM      *BLANKS       HCY9              3                        MD038918
120700200529     C                   Z-ADD     WLCPN         F1LCPN                                     MD038918
120800200529     C                   ENDIF                                                              MD038918
120900200529     C     WEvtDNo       IFEQ      PCpd                                                     MD038918
121000200529     C                   MOVE      *ON           *IN34                                      MD038918
121100200529     C                   EVAL      WESC = 'Y'                                               MD038918
121200200529     C                   LEAVE                                                              MD038918
121300200529     C                   ENDIF                                                              MD038918
121400200529     C                   ENDIF                                                              MD038918
121500200529                                                                                            MD038918
121600200529
121700200529     C                   ENDIF
121800200529     C                   ENDDO
121900200529
122000200529     C                   IF        WESC = 'Y'
122100200529     C                   ITER
122200200529     C                   ENDIF
122300200529
122400200529     C                   IF        WIYr = 99
122500200529     C                   Z-ADD     0             WIYr
122600200529     C                   ADD       1             WIYrC
122700200529     C                   ELSE
122800200529     C                   ADD       1             WIYr
122900200529     C                   ADD       1             WIYrC
123000200529     C                   ENDIF
123100200529
123200200529     C                   ENDDO
123300200529
123400200529     C                   IF        NOT *IN34
123500200529     C                   MOVE      'N'           OKSDED
123600200529     C                   ADD       1             Idx
123700200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
123800200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0333'
123900200529     C                   ENDIF
124000200529
124100200529     C                   ENDIF
124200200529
124300200529     C                   ENDIF
124400200529      *
124500200529      ** If Event type 'IR', validate Input and Amend modes.
124600200529      *
124700200529     C                   IF        DDSDET = 'IR'
124800200529
124900200529     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
125000200529     C                             AND WEvtDNo < BJRDNB
125100200529      *
125200200529      ** Check no Trades input on this security that have value date
125300200529      ** greater than or equal to the event date.
125400200529      *
125500200529     C     DDSDSN        SETLL     TRADSDF
125600200529     C     DDSDSN        READE     TRADSDF                                01
125700200529      *
125800200529     C                   DOW       *IN01 = *OFF AND OKSDED = 'Y'
125900200529     C                   IF        F2TDVD >= WEvtDNo
126000200529     C                   MOVE      'W'           OKSDED
126100200529     C                   ADD       1             WIdx
126200200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
126300200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0334'
126400200529     C                   ELSE
126500200529     C     DDSDSN        READE     TRADSDF                                01
126600200529     C                   ENDIF
126700200529     C                   ENDDO
126800200529      *
126900200529      ** Check this event not before last 'IR' event.
127000200529      *
127100200529     C                   EVAL      WSEDE = SEDEFmt
127200200529     C     DDSDSN        SETGT     SEDEVDF
127300200529     C                   READP     SEDEVDF                                01
127400200529      *
127500200529     C                   DOW       NOT *IN01
127600200529      *
127700200529      ** Check record is not a cancelled record.
127800200529     C                   IF        RECI <> 'C'
127900200529      *
128000200529      ** Check same Security.
128100200529     C                   IF        DDSDSN = SDSN
128200200529      *
128300200529      ** Check same Event type.
128400200529     C                   IF        SDET = 'IR'
128500200529     C                   IF        WEvtDNo < SDED
128600200529     C                   MOVE      'W'           OKSDED
128700200529     C                   ADD       1             WIdx
128800200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
128900200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0335'
129000200529     C                   ENDIF
129100200529     C                   LEAVE
129200200529     C                   ENDIF
129300200529      *
129400200529      ** Exit loop if securities are not the same.
129500200529     C                   ELSE
129600200529     C                   LEAVE
129700200529     C                   ENDIF
129800200529      *
129900200529     C                   ENDIF
130000200529      *
130100200529     C                   READP     SEDEVDF                                01
130200200529     C                   ENDDO
130300200529
130400200529     C                   EVAL      SEDEFmt = WSEDE
130500200529
130600200529     C                   ENDIF
130700200529      *
130800200529      ** If Rate change frequency is 'W', Check if date not equal to or a
130900200529      ** multiple of 7 days after Next change date (or multiple of 7
131000200529      ** days before NCD if date < run date).
131100200529      *
131200200529     C                   IF        F1RCFQ = 'W' AND WEvtDNo <> F1NCHD
131300200529      *
131400200529     C                   IF        WEvtDNo > BJRDNB
131500200529      *
131600200529     C                   IF        WEvtDNo < F1NCHD
131700200529     C                   MOVE      'W'           OKSDED
131800200529     C                   ADD       1             WIdx
131900200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
132000200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0336'
132100200529     C                   ENDIF
132200200529
132300200529     C     WEvtDNo       SUB       F1NCHD        Work5N
132400200529     C     Work5N        DIV       7             Work5N
132500200529     C                   MVR                     Work1N               01
132600200529     C*
132700200529     C                   IF        *IN01
132800200529     C                   MOVE      'N'           OKSDED
132900200529     C                   ADD       1             Idx
133000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
133100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0337'
133200200529     C                   ENDIF
133300200529
133400200529     C                   ELSE
133500200529
133600200529     C                   IF        WEvtDNo > F1NCHD
133700200529     C                   MOVE      'W'           OKSDED
133800200529     C                   ADD       1             WIdx
133900200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
134000200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0336'
134100200529     C                   ENDIF
134200200529      *
134300200529     C     WEvtDNo       SUB       F1NCHD        Work5N
134400200529     C     Work5N        DIV       7             Work5N
134500200529     C                   MVR                     Work1N               01
134600200529
134700200529     C                   IF        *IN01
134800200529     C                   MOVE      'N'           OKSDED
134900200529     C                   ADD       1             Idx
135000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
135100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0337'
135200200529     C                   ENDIF
135300200529
135400200529     C                   ENDIF
135500200529     C                   ENDIF
135600200529      *
135700200529      ** If Rate change frequency is 'F', Check if date not equal to or a
135800200529      ** multiple of 14 days after Next change date
135900200529      *
136000200529     C                   IF        F1RCFQ = 'F' AND WEvtDNo <> F1NCHD
136100200529      *
136200200529     C                   IF        WEvtDNo > BJRDNB
136300200529      *
136400200529     C                   IF        WEvtDNo < F1NCHD
136500200529     C                   MOVE      'W'           OKSDED
136600200529     C                   ADD       1             WIdx
136700200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
136800200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0338'
136900200529     C                   ENDIF
137000200529      *
137100200529     C     WEvtDNo       SUB       F1NCHD        Work5N
137200200529     C     Work5N        DIV       14            Work5N
137300200529     C                   MVR                     Work2N               01
137400200529
137500200529     C                   IF        *IN01
137600200529     C                   MOVE      'N'           OKSDED
137700200529     C                   ADD       1             Idx
137800200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
137900200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0339'
138000200529     C                   ENDIF
138100200529
138200200529     C                   ELSE
138300200529
138400200529     C                   IF        WEvtDNo > F1NCHD
138500200529     C                   MOVE      'W'           OKSDED
138600200529     C                   ADD       1             WIdx
138700200529     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
138800200529     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0338'
138900200529     C                   ENDIF
139000200529
139100200529     C     WEvtDNo       SUB       F1NCHD        Work5N
139200200529     C     Work5N        DIV       14            Work5N
139300200529     C                   MVR                     Work2N               01
139400200529
139500200529     C                   IF        *IN01
139600200529     C                   MOVE      'N'           OKSDED
139700200529     C                   ADD       1             Idx
139800200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
139900200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0339'
140000200529     C                   ENDIF
140100200529
140200200529     C                   ENDIF
140300200529
140400200529     C                   ENDIF
140500200529      *
140600200529      ** If Rate change frequency is 'M', Check if date is not the same day
140700200529      ** of the month as the Next change date.
140800200529      *
140900200529     C                   IF        F1RCFQ = 'M' AND WEvtDNo <> F1NCHD
141000200529
141100200529     C                   Z-ADD     WEvtDNo       PDateIn
141200200529     C                   EXSR      SrZDATE2
141300200529     C                   MOVE      PDateOut      WEYear
141400200529     C                   MOVEL     PDateOut      WNum4
141500200529     C                   IF        BJDFIN = 'M'
141600200529     C                   MOVEL     PDateOut      WEMth
141700200529     C                   MOVE      WNum4         WEDay
141800200529     C                   ELSE
141900200529     C                   MOVEL     PDateOut      WEDay
142000200529     C                   MOVE      WNum4         WEMth
142100200529     C                   ENDIF
142200200529
142300200529     C                   Z-ADD     F1NCHD        PDateIn
142400200529     C                   EXSR      SrZDATE2
142500200529     C                   MOVE      PDateOut      WZYear
142600200529     C                   MOVEL     PDateOut      WNum4
142700200529     C                   IF        BJDFIN = 'M'
142800200529     C                   MOVEL     PDateOut      WZMth
142900200529     C                   MOVE      WNum4         WZDay
143000200529     C                   ELSE
143100200529     C                   MOVEL     PDateOut      WZDay
143200200529     C                   MOVE      WNum4         WZMth
143300200529     C                   ENDIF
143400200529      *
143500200529      ** Check if Event Day is allowed to differ from the Next
143600200529      ** Change Day.
143700200529      *
143800200529     C                   EXSR      SRNchDay
143900200529
144000200529     C                   ENDIF
144100200529     C                   ENDIF
144200200529      *
144300200529      ** If Event type 'PP', validate Input and Amend modes.
144400200529      *
144500200529     C                   IF        DDSDET = 'PP' AND WEvtDNo < BJRDNB
144600200529     C                             AND (DDACTN = 'I' OR DDACTN = 'A')
144700200529      *
144800200529      ** Check no Trades input on this security that have value date
144900200529      ** greater than or equal to the event date.
145000200529      *
145100200529     C     DDSDSN        SETLL     TRADSDF
145200200529     C     DDSDSN        READE     TRADSDF                                01
145300200529      *
145400200529     C                   DOW       NOT *IN01 AND OKSDED = 'Y'
145500200529      *
145600200529     C                   IF        F2TDVD >= WEvtDNo
145700200529     C                   MOVE      'N'           OKSDED
145800200529     C                   ADD       1             Idx
145900200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
146000200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0341'
146100200529     C                   ELSE
146200200529     C     DDSDSN        READE     TRADSDF                                01
146300200529     C                   ENDIF
146400200529      *
146500200529     C                   ENDDO
146600200529      *
146700200529      ** Check this event not before last 'PP' event.
146800200529      *
146900200529     C                   EVAL      WSEDE = SEDEFmt
147000200529     C     DDSDSN        SETGT     SEDEVDF
147100200529     C                   READP     SEDEVDF                                01
147200200529      *
147300200529     C                   DOW       NOT *IN01
147400200529      *
147500200529      ** Check record is not a cancelled record.
147600200529     C                   IF        RECI <> 'C'
147700200529      *
147800200529      ** Check same security.
147900200529     C                   IF        DDSDSN = SDSN
148000200529      *
148100200529      ** Check same event type.
148200200529     C                   IF        SDET = 'PP'
148300200529     C                   IF        WEvtDNo < SDED
148400200529     C                   MOVE      'N'           OKSDED
148500200529     C                   ADD       1             Idx
148600200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
148700200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0342'
148800200529     C                   ENDIF
148900200529     C                   LEAVE
149000200529     C                   ENDIF
149100200529      *
149200200529      ** Exit loop if security are not the same.
149300200529     C                   ELSE
149400200529     C                   LEAVE
149500200529     C                   ENDIF
149600200529      *
149700200529     C                   ENDIF
149800200529      *
149900200529     C                   READP     SEDEVDF                                01
150000200529     C                   ENDDO
150100200529
150200200529     C                   EVAL      SEDEFmt = WSEDE
150300200529
150400200529     C                   ENDIF
150500200529      *
150600200529      ** Event date cannot be before run date for following codes.
150700200529      *
150800200529     C                   IF        DDSDET = 'RC' OR DDSDET = 'RP'
150900200529     C                             OR DDSDET = 'CV' OR DDSDET = 'BI'
151000200529     C                             OR DDSDET = 'RI' OR DDSDET = 'CR'
151100200529     C                             OR DDSDET = 'OC'
151200200529
151300200529     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
151400200529     C                             AND WEvtDNo < BJRDNB
151500200529     C                   MOVE      'N'           OKSDED
151600200529     C                   ADD       1             Idx
151700200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
151800200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0330'
151900200529     C                   ENDIF
152000200529     C                   ENDIF
152100200529
152200200529     C                   ENDSR
152300200529
152400200529      *****************************************************************
152500200529      /EJECT
152600200529      *****************************************************************
152700200529      *                                                               *
152800200529      *  SRNchDay - Check if Next Change Day is allowed to differ     *
152900200529      *             to Event Day                                      *
153000200529      *                                                               *
153100200529      *****************************************************************
153200200529     C     SRNchDay      BEGSR
153300200529      *
153400200529      ** The Event Day is only allowed to differ from the Next Change
153500200529      ** Day for one of two reasons:-
153600200529      ** 1 - The day prior to the Event Day is a holiday or
153700200529      ** 2 - The two days are the last days of their respective months.
153800200529      *
153900200529     C                   IF        WEDay <> WZDay
154000200529      *
154100200529      ** Check if day prior to the Event Day is a holiday.
154200200529      *
154300200529     C     WEvtDNo       SUB       1             PZDayNoIn
154400200529     C                   IF        F1VLCY <> *BLANKS
154500200529     C                   EVAL      PZCcy = F1VLCY
154600200529     C                   ELSE
154700200529     C                   EVAL      PZCcy = F1NMCY
154800200529     C                   ENDIF
154900200529
155000200529     C                   EVAL      PZLoc = *BLANKS
155100200529     C                   EXSR      SrZChkH
155200200529      *
155300200529      ** If it wasn't a holiday, check to see if the two days are at the
155400200529      **  ends of their months.
155500200529     C                   IF        PZHolInd <> 'H'
155600200529
155700200529     C     WZMth         LOOKUP    TABMTH        TABDAY                   01
155800200529
155900200529     C     WZDay         IFNE      TABDAY
156000200529     C                   MOVE      'N'           OKSDED
156100200529     C                   ADD       1             Idx
156200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
156300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0340'
156400200529     C                   ELSE
156500200529
156600200529     C     WEMth         LOOKUP    TABMTH        TABDAY                   01
156700200529     C                   Z-ADD     TABDAY        WEOMDay
156800200529
156900200529     C                   IF        WEMth = 2
157000200529     C     WEYear        DIV       4             Work2N
157100200529     C                   MVR                     Work1N                   01
157200200529     C                   IF        *IN01
157300200529     C                   ADD       1             WEOMDay
157400200529     C                   ENDIF
157500200529     C                   ENDIF
157600200529
157700200529     C                   IF        WEDay <> WEOMDay
157800200529     C                   MOVE      'N'           OKSDED
157900200529     C                   ADD       1             Idx
158000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
158100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0340'
158200200529     C                   ENDIF
158300200529
158400200529     C                   ENDIF
158500200529
158600200529     C                   ENDIF
158700200529     C                   ENDIF
158800200529
158900200529     C                   ENDSR
159000200529
159100200529      *****************************************************************
159200200529      /EJECT
159300200529      *****************************************************************
159400200529      *                                                               *
159500200529      *  SREvtType - Routine to further validate event type.          *
159600200529      *                                                               *
159700200529      *****************************************************************
159800200529
159900200529     C     SREvtType     BEGSR
160000200529      *
160100200529      ** Access investment type details via access object.
160200200529      *
160300200529     C                   CALL      'AOINVTR0'
160400200529     C                   PARM      *BLANKS       PRtcd
160500200529     C                   PARM      '*KEY   '     POptn
160600200529     C                   PARM                    F1SITP
160700200529     C                   PARM                    F1NMCY
160800200529     C     PInvtpd       PARM      PInvtpd       DSFDY
160900200529      *
161000200529     C                   IF        PRtcd <> *BLANKS
161100200529     C                   CLEAR                   PInvtpd
161200200529     C                   ENDIF
161300200529      *
161400200529      ** If entry 'DV', check Investment type is a share (D1PROT '4').
161500200529      *
161600200529     C                   IF        DDSDET = 'DV' AND D1PROT <> '4'
161700200529     C                             AND D1PROT <> '7'                                    210122
161800200529     C                   MOVE      'N'           OKSDET
161900200529     C                   ADD       1             Idx
162000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
162100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0321'
162200200529     C                   ENDIF
162300200529      *
162400200529      ** Entry 'PP' but Security is not partly-paid.
162500200529      *
162600200529     C                   IF        DDSDET = 'PP' AND F1PPDI <> 'Y'
162700200529     C                   MOVE      'N'           OKSDET
162800200529     C                   ADD       1             Idx
162900200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
163000200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0322'
163100200529     C                   ENDIF
163200200529      *
163300200529      ** Entry 'PP' but Security is not complete.
163400200529      *
163500200529     C                   IF        DDSDET = 'PP' AND F1INCS <> 'C'
163600200529     C                   MOVE      'N'           OKSDET
163700200529     C                   ADD       1             Idx
163800200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
163900200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0329'
164000200529     C                   ENDIF
164100200529      *
164200200529      ** If entry 'MP', check Investment type is Mortgage backed
164300200529      ** Mortgage backed (D1PROT '8').
164400200529      *
164500200529     C                   IF        DDSDET = 'MP' AND D1PROT <> '8'
164600200529     C                   MOVE      'N'           OKSDET
164700200529     C                   ADD       1             Idx
164800200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
164900200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0323'
165000200529     C                   ENDIF
165100200529      *
165200200529      ** If entry 'IR', check Investment type is either a Floating Rate
165300200529      ** Note (D1PROT '3'), a Yen Bond (D1PROT '5') or a Mortgage Backed
165400200529      ** Security (D1PROT '8').
165500200529      *
165600200529     C                   IF        DDSDET = 'IR' AND D1PROT <> '3'
165700200529     C                             AND D1PROT <> '5' AND D1PROT <> '8'
165800200529     C                   MOVE      'N'           OKSDET
165900200529     C                   ADD       1             Idx
166000200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
166100200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0324'
166200200529     C                   ENDIF
166300200529      *
166400200529      ** If entry 'XR', check for Multi-currency or Value currency.
166500200529      *
166600200529     C                   IF        DDSDET = 'XR' AND F1MLTI <> 'Y'
166700200529     C                             AND S01509 = 'N'
166800200529     C                   IF        F1VLCY = *BLANKS OR F1VLCY = F1NMCY
166900200529     C                   MOVE      'N'           OKSDET
167000200529     C                   ADD       1             Idx
167100200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
167200200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0325'
167300200529     C                   ENDIF
167400200529     C                   ENDIF
167500200529      *
167600200529      ** If entry 'RC', check for Early Repayment indicator.
167700200529      *
167800200529     C                   IF        DDSDET = 'RC' AND F1ERPY <> 'Y'
167900200529     C                             AND WEvtDNo <> F1MATY
168000200529     C                   MOVE      'N'           OKSDET
168100200529     C                   ADD       1             Idx
168200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
168300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0326'
168400200529     C                   ENDIF
168500200529      *
168600200529      ** If entry 'RP', check for Early Repayment indicator.
168700200529      *
168800200529     C                   IF        DDSDET = 'RP' AND F1ERPY <> 'Y'
168900200529     C                             AND WEvtDNo <> F1MATY
169000200529     C                   MOVE      'N'           OKSDET
169100200529     C                   ADD       1             Idx
169200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
169300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0327'
169400200529     C                   ENDIF
169500200529      *
169600200529      ** If entry 'CV', check for Convertible indicator.
169700200529      *
169800200529     C**********         IF        DDSDET = 'CV' AND D1CNVI <> 'Y'                            259978
169900200529     C                   IF        DDSDET = 'CV' AND F1SCVI <> 'Y'                            259978
170000200529     C                   MOVE      'N'           OKSDET
170100200529     C                   ADD       1             Idx
170200200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
170300200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0328'
170400200529     C                   ENDIF
170500200529                                                                                              CSE065
170600200529      ** If CSE065 is installed and entry is 'AL',                                            CSE065
170700200529      ** validate processing type.                                                            CSE065
170800200529                                                                                              CSE065
170900200529     C                   IF        DDSDET = 'AL' AND D1PROT <> '1' AND                        CSE065
171000200529     C                             D1PROT <> '3' AND D1PROT <> '5' AND                        CSE065
171100200529     C                             D1PROT <> '6' AND D1PROT <> '8' AND                        CSE065
171200200529     C                             D1PROT <> '9' AND CSE065 = 'Y'                             CSE065
171300200529     C                   MOVE      'N'           OKSDET                                       CSE065
171400200529     C                   ADD       1             Idx                                          CSE065
171500200529     C                   EVAL      FldNameArr(Idx) = 'DDSDET'                                 CSE065
171600200529     C                   EVAL      MsgIdArr(Idx) = 'SEA0560'                                  CSE065
171700200529     C                   ENDIF                                                                CSE065
171800200529
171900200529     C                   ENDSR
172000200529
172100200529      *****************************************************************
172200200529      /EJECT
172300200529      *****************************************************************
172400200529      *                                                               *
172500200529      *  SRZDate1 - Validate and convert date to day number           *
172600200529      *                                                               *
172700200529      *****************************************************************
172800200529     C     SRZDate1      BEGSR
172900200529
173000200529     C                   CALLB     'ZDATE1'
173100200529     C                   PARM                    PADateIn
173200200529     C                   PARM      *ZERO         PDaynoOut
173300200529     C                   PARM                    BJDFIN
173400200529     C                   PARM      *BLANK        PErrorFlag
173500200529
173600200529     C                   ENDSR
173700200529
173800200529      *****************************************************************
173900200529      /EJECT
174000200529      *****************************************************************
174100200529      *                                                               *
174200200529      *  SRAcsSec - Access Security Checking                          *
174300200529      *                                                               *
174400200529      *****************************************************************
174500200529
174600200529     C     SRAcsSec      BEGSR
174700200529      *
174800200529      ** If not multi-branching, check authority to only action code.
174900200529      *
175000200529     C                   IF        BJSBRC <> *BLANK
175100200529
175200200529     C                   CALL      'ZVACTU'
175300200529     C                   PARM      DDACTN        PActn
175400200529     C                   PARM                    PError
175500200529     C                   IF        PError <> *ZERO
175600200529     C                   MOVE      'N'           OKACTN
175700200529     C                   ADD       1             Idx
175800200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
175900200529     C                   MOVEL     'SEA0304'     MsgIdArr(Idx)
176000200529     C                   ENDIF
176100200529
176200200529     C                   ELSE
176300200529      *
176400200529      ** If multi-branching, check authority to user's default branch.
176500200529      *
176600200529     C                   CALL      'ZVACTBU'
176700200529     C                   PARM      DDACTN        PActn
176800200529     C                   PARM      PDBRN         PBrc
176900200529     C                   PARM                    PError
177000200529
177100200529     C                   IF        PError = 1
177200200529     C                   MOVE      'N'           OKACTN
177300200529     C                   ADD       1             Idx
177400200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
177500200529     C                   MOVEL     'SEA0305'     MsgIdArr(Idx)
177600200529     C                   ENDIF
177700200529
177800200529     C                   IF        PError = 2
177900200529     C                   MOVE      'N'           OKACTN
178000200529     C                   ADD       1             Idx
178100200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
178200200529     C                   MOVEL     'SEA0306'     MsgIdArr(Idx)
178300200529     C                   ENDIF
178400200529
178500200529     C                   ENDIF
178600200529
178700200529     C                   ENDSR
178800200529
178900200529      *****************************************************************
179000200529      /EJECT
179100200529      *****************************************************************
179200200529      *                                                               *
179300200529      *  SRZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
179400200529      *                                                               *
179500200529      *****************************************************************
179600200529     C     SRZDate2      BEGSR
179700200529
179800200529     C                   CALLB     'ZDATE2'
179900200529     C                   PARM                    PDateIn
180000200529     C                   PARM                    BJDFIN
180100200529     C                   PARM      *ZERO         PDateOut
180200200529     C                   PARM      *BLANKS       PADateOut
180300200529
180400200529     C                   ENDSR
180500200529      *****************************************************************
180600200529      /EJECT
180700200529      *****************************************************************
180800200529      *                                                               *
180900200529      *  SRZChkH - Check if date is a holiday in specified currency   *
181000200529      *                                                               *
181100200529      *****************************************************************
181200200529     C     SRZChkH       BEGSR
181300200529
181400200529     C                   CALLB     'ZCHKH'
181500200529     C                   PARM                    PZDayNoIn
181600200529     C                   PARM                    PZCcy
181700200529     C                   PARM                    PZLoc
181800200529     C                   PARM      *BLANK        PZHolInd
181900200529
182000200529     C                   ENDSR
182100200529      *****************************************************************
182200200529      /EJECT
182300200529      *****************************************************************
182400200529      *                                                               *
182500200529      *  *INZSR - Program Initialisation                              *
182600200529      *         - This subroutine runs automatically for program      *
182700200529      *           initialisation.                                     *
182800200529      *                                                               *
182900200529      *****************************************************************
183000200529
183100200529     C     *INZSR        BEGSR
183200200529
183300200529     C     *ENTRY        PLIST
183400200529      *
183500200529      ** INPUT
183600200529      ** =====
183700200529      *
183800200529      ** Return Code
183900200529     C                   PARM                    RetCodeIn
184000200529      *
184100200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
184200200529      ** Mode = '      ' (Not Front Office Transaction Interface)
184300200529      ** Mode = '*RPR  ' (Repair function)
184400200529      ** Mode = '*SIN  ' (Screen input function)
184500200529     C                   PARM                    PMode
184600200529      *
184700200529      ** Response Mode
184800200529     C                   PARM                    PResponse
184900200529      *
185000200529      ** Action Code
185100200529     C                   PARM                    DDACTN
185200200529      *
185300200529      ** Front Office Transaction Id
185400200529     C                   PARM                    FOTRID
185500200529      *
185600200529      ** Security Shortname
185700200529     C                   PARM                    DDSDSN
185800200529      *
185900200529      ** Event Date
186000200529     C                   PARM                    DDSDED
186100200529      *
186200200529      ** Event Type
186300200529     C                   PARM                    DDSDET
186400200529      *
186500200529      ** STANDING DATA
186600200529      ** =============
186700200529      *
186800200529      ** SDBANK - Single Branch Code
186900200529     C                   PARM                    BJSBRC
187000200529      *
187100200529      ** SDBANK - Run day number
187200200529     C                   PARM                    BJRDNB
187300200529      *
187400200529      ** SDBANK - Date format indicator
187500200529     C                   PARM                    BJDFIN
187600200529      *
187700200529      ** SDBANK - Back value period
187800200529     C                   PARM                    BVBVP
187900200529      *
188000200529      ** ZMUSER - Default Branch
188100200529     C                   PARM                    PDBRN
188200200529      *
188300200529      ** SWITCHABLE FEATURES
188400200529      ** ===================
188500200529      *
188600200529      ** SE Transaction Enhancement
188700200529     C                   PARM                    CSE010
188800200529      *
188900200529      ** value Ccy to be Ccy of Issuer Payment
189000200529     C                   PARM                    S01509
189100200529      *                                                                                       CSE031
189200200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
189300200529     C                   PARM                    CSE031            1                          CSE031
189400200529                                                                                              CSE065
189500200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
189600200529     C                   PARM                    CSE065                                       CSE065
189700200529                                                                                              CSE065
189800200529      *
189900200529      ** OUTPUT
190000200529      ** ======
190100200529      *
190200200529      ** Error fields/message IDs/message data (arrays) from/to caller
190300200529     C                   PARM                    FldNameArr
190400200529     C                   PARM                    MsgIdArr
190500200529     C                   PARM                    MsgDtaArr
190600200529      *
190700200529      ** Array index (3P0) from/to caller
190800200529     C                   PARM                    IDx
190900200529      *
191000200529      ** Warning fields/message IDs/message data (arrays) from/to caller
191100200529     C                   PARM                    WFldNamArr
191200200529     C                   PARM                    WMsgIDArr
191300200529     C                   PARM                    WMsgDtaArr
191400200529      *
191500200529      ** Array index (3P0) from/to caller
191600200529     C                   PARM                    WIdx
191700200529      *
191800200529      ** OK Action Code
191900200529     C                   PARM                    OKACTN
192000200529      *
192100200529      ** OK Security Shortname
192200200529     C                   PARM                    OKSDSN
192300200529      *
192400200529      ** OK Event Date
192500200529     C                   PARM                    OKSDED
192600200529      *
192700200529      ** OK Event Type
192800200529     C                   PARM                    OKSDET
192900200529      *
193000200529      ** Security Diary Events retrieved from file - file format
193100200529     C                   PARM                    CrDEFilFmt
193200200529      *
193300200529      ** Security Details
193400200529     C                   PARM                    PSectyd
193500200529      *
193600200529      ** Processing type from PF/INVTPD
193700200529     C                   PARM      D1PROT        PPROT
193800200529      *
193900200529      ** Event Date in numeric format.
194000200529     C                   PARM      WEvtDNo       PEvtDno
194100200529      *
194200200529      ** Redisplay screen
194300200529     C                   PARM                    PReDsp
194400200529      *
194500200529      ** Key fields for LF/SEDEV
194600200529     C     KSEDEV        KLIST
194700200529     C                   KFLD                    DDSDSN
194800200529     C                   KFLD                    WEvtDNo
194900200529     C                   KFLD                    DDSDET
195000200529      *                                                                                       260331
195100200529      ** Check if S01512 is installed                                                         260331
195200200529      *                                                                                       260331
195300200529     C                   CALL      'AOSARDR0'                                                 260331
195400200529     C                   PARM      *BLANKS       @RTCD             7                          260331
195500200529     C                   PARM      '*VERIFY'     @OPTN             7                          260331
195600200529     C                   PARM      'S01512'      @SARD             6                          260331
195700200529      *                                                                                       260331
195800200529     C                   IF        @RTCD = *BLANKS                                            260331
195900200529     C                   MOVE      'Y'           S01512            1                          260331
196000200529     C                   ELSE                                                                 260331
196100200529     C                   MOVE      'N'           S01512                                       260331
196200200529     C                   ENDIF                                                                260331
196300200529      *
196400200529      ** Program, module and procedure names for database error processing
196500200529      ** =================================================================
196600200529      ** The following /COPY sets these values.
196700200529      *
196800200529      /COPY ZACPYSRC,DBFIELDS
196900200529
197000200529     C                   ENDSR
197100200529      *****************************************************************
197200200529      /EJECT
197300200529      *****************************************************************
197400200529      *
197500200529      ** The following /COPY contains the standard program status
197600200529      ** subroutine, including a bound call to the DBERRCTL module.
197700200529      *
197800200529      /COPY ZACPYSRC,PSSR_ILE
197900200529
198000200529      *****************************************************************
198100200529      *
198200200529**  CPY@
198300200529(c) Finastra International Limited 2001
198400200529**   TABMTH/TABDAY     Month No/No of days in month
198500200529013102280331043005310630073108310930103111301231
