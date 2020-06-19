000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Security diary events database update')       *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDEUPD - Security Diary Events database update            *
001100200529      *                                                               *
001200200529      *  Function: This module will perform the update of the Midas   *
001300200529      *            database for the Security Diary Events.            *
001400200529      *                                                               *
001500200529      *  Component of: SESEDESIN                                      *
001600200529      *                SESEDERPR                                      *
001700200529      *                SESEDEUPP                                      *
001800200529      *                                                               *
001900200529      *  (c) Finastra International Limited 2001                      *
002000200529      *                                                               *
002100200604      *  Last Amend No. 260191A            Date 22May20               *
002200200529      *  Prev Amend No. CSD102             Date 08Jan19               *
002300200529      *                 MD046248           Date 27Oct17               *
002400200529      *                 MD037742           Date 03Apr16               *
002500200529      *                 CRE073             Date 06Dec10               *
002600200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002800200529      *                 247277             Date 24May07               *
002900200529      * Midas Plus 1.4 Base ------------------------------------------*
003000200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003100200529      *                 CSD027             Date 09Dec05               *
003200200529      *                 CSE075             Date 17Nov05               *
003300200529      *                 237063             Date 20Nov05               *
003400200529      *                 CGL031             Date 05Jul04               *
003500200529      *                 CSE065             Date 18Nov04               *
003600200529      *                 CSE071             Date 19Jul05               *
003700200529      *                 CAP084             Date 06Feb04               *
003800200529      *                 CAS006             Date 21Jan03               *
003900200529      * Midas Release 4.01 -------------------------------------------*
004000200529      *                 CSE031             Date 09Nov01               *
004100200529      *                 CSC011             Date 18Sep01               *
004200200529      * Midas Release 4 --------------- Base -------------------------*
004300200529      * Midas DBA 3.05 -----------------------------------------------*
004400200529      *                 CSD006             Date 11Oct00               *
004500200529      *                 CAP140  *CREATE    Date 17Oct00               *
004600200529      *                                                               *
004700200529      *---------------------------------------------------------------*
004800200529      *                                                               *
004900200529      *  260191A - Incorrect dividend position settlement generated.  *
005000200529      *           Correct the validation of action 'D'elete.          *
005100200529      *  CSD102 - Password Length Extension (Recompile)               *
005200200529      *  MD046248 - Finastra Rebranding                               *
005300200529      *  MD037742 - Security diary events - pool factor reversal.     *
005400200529      *             Additional fix to allow deletion of matured diary *
005500200529      *             event with a live position settlement.            *
005600200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005700200529      *  247277 - Allow for native JDBC driver as well as toolbox.    *
005800200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
005900200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
006000200529      *           (Recompile)                                         *
006100200529      *  237063 - EU Tax fixes upgrade to MP build 103.               *
006200200529      *  CGL031 - Taxation on Savings Income (Recompile)              *
006300200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
006400200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
006500200529      *  CAP084 - Thin Client API Wrappers                            *
006600200529      *           Bypass setting of PModeX to '*FRONT' if module      *
006700200529      *           is called from Midas Plus interface.                *
006800200529      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
006900200529      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
007000200529      *  CSC011 - 24x7 Midas Availability                             *
007100200529      *  CSD006 - Recompiled over changed SECTYD.                     *
007200200529      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
007300200529      *           modular structure to use as APIs.                   *
007400200529      *                                                               *
007500200529      *****************************************************************
007600200529      *                                                               *
007700200529      *  Use of indicators.                                           *
007800200529      *                                                               *
007900200529      *    01-02      Use for chaining to file                        *
008000200529      *                                                               *
008100200529      *****************************************************************
008200200529      *                                                               *
008300200529      *  S U B R O U T I N E  I N D E X                               *
008400200529      *                                                               *
008500200529      *  SRSetRecTot - Setup total for the record.                    *
008600200529      *  SRChkOthUpd - Check for update by another workstation        *
008700200529      *  SRInsert - Insert Security Diary Events                      *
008800200529      *  SRAmend - Amend Security Diary Events                        *
008900200529      *  SRDelete - Delete Security Diary Events                      *
009000200529      *  SRFmtDat - Format date for display                           *
009100200529      *  SRErr - Routine for Exception Errors                         *
009200200529      *  *PSSR - Error processing                                     *
009300200529      *  *INZSR - Initialise                                          *
009400200529      *                                                               *
009500200529      *    The *INZSR subroutine will only get called automatically   *
009600200529      *    on entry to the module the first time it is run            *
009700200529      *    (unless you end the program with LR on).  Similarly        *
009800200529      *    D-spec initialisation only happens the first time.  Use    *
009900200529      *    RESET for subsequent passes.                               *
010000200529      *                                                               *
010100200529      *****************************************************************
010200200529      *
010300200529      ** +--------------------------------------+
010400200529      ** ¦ F-specs                              ¦
010500200529      ** ¦ =======                              ¦
010600200529      ** +--------------------------------------+
010700200529      *
010800200529      ** Security Diary Events - Detail
010900200529     FSEDEV     UF A E           K DISK    INFSR(*PSSR)
011000200529     F                                     COMMIT
011100200529      *
011200200529      ** Security Diary Events - Audit
011300200529     FSEDEVA    UF A E             DISK    INFSR(*PSSR)
011400200529     F                                     COMMIT
011500200529     F                                     PREFIX(F1)
011600200529      *
011700200529      ** Position Settlement by Security
011800200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)
011900200529     F                                     PREFIX(F2)
012000200529      *
012100200529      *****************************************************************
012200200529      /EJECT
012300200529      *****************************************************************
012400200529      *
012500200529      ** +--------------------------------------+
012600200529      ** ¦ Automatically included D-specs       ¦
012700200529      ** ¦ ==============================       ¦
012800200529      ** +--------------------------------------+
012900200529      *
013000200529      ** Standard D-specs
013100200529      ** ================
013200200529      **
013300200529      ** The following /COPY line includes the LDA layout,
013400200529      ** the copyright array definition,
013500200529      ** and the following named constants:
013600200529      **    True       logical = *On (for indicator processing)
013700200529      **    False      logical = *Off (for indicator processing)
013800200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
013900200529      **                                    handler)
014000200529      ** and the following variables:
014100200529      **    RunBefore  1A (for the PSSR)
014200200529      *
014300200529      /COPY ZACPYSRC,STD_D_SPEC
014400200529      *
014500200529      ** Program Status Data Structure
014600200529      ** =============================
014700200529      ** The following /COPY line includes all the defined fields in the
014800200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
014900200529      *
015000200529      /COPY ZACPYSRC,PSDS
015100200529      *
015200200529      ** The following /COPY line includes the definitions for error and
015300200529      ** warning message arrays.
015400200529      *
015500200529      /COPY ZACPYSRC,ERR_ARRAYS
015600200529      *
015700200529      ** +--------------------------------------+
015800200529      ** ¦ End of automatically included D-specs¦
015900200529      ** ¦ =====================================¦
016000200529      ** +--------------------------------------+
016100200529      *
016200200529      *****************************************************************
016300200529      /EJECT
016400200529      *****************************************************************
016500200529      *
016600200529      ** +--------------------------------------+
016700200529      ** ¦ Manually included D-specs            ¦
016800200529      ** ¦ =========================            ¦
016900200529      ** +--------------------------------------+
017000200529      *
017100200529      ** +--------------------------------------+
017200200529      ** ¦ Named constants                      ¦
017300200529      ** ¦ ===============                      ¦
017400200529      ** +--------------------------------------+
017500200529      *
017600200529      ** +--------------------------------------+
017700200529      ** ¦ Arrays and Data Structures           ¦
017800200529      ** ¦ ==========================           ¦
017900200529      ** +--------------------------------------+
018000200529      *
018100200529      ** SE Diary events for file update - file format
018200200529     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
018300200529     D*NwDEFilFmt1             1    231                                                CSE065 237063
018400200529      *
018500200529      ** SE Diary events for file update - Midas file format
018600200529     D SedevUpdF     E DS                  EXTNAME(SEDEVD)
018700200529     D*SedevUpdF1              1    231                                                CSE065 237063
018800200529      *
018900200529      ** SE Diary events retrieved from file - file format
019000200529     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
019100200529     D                                     PREFIX(CH)
019200200529      *
019300200529      ** Externally described DS for security details
019400200529     D PSectyd       E DS                  EXTNAME(SECTYD)
019500200529     D                                     PREFIX(D1)
019600200529                                                                                              CSC011
019700200529      ** Header information to be passed to APLOGTRAN                                         CSC011
019800200529     D PHead         E DS                  EXTNAME(APHEADPD)                                  CSC011
019900200529                                                                                              CSC011
020000200529      ** Externally described DS for SAR details                                              CSC011
020100200529     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(S)                        CSC011
020200200529                                                                                              CSC011
020300200529      ** DS for access programs - short data structure                                        CSC011
020400200529     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
020500200529                                                                                              CSC011
020600200529      ** Data structure for data area SC24X7                                                  CSC011
020700200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
020800200529                                                                                              CSC011
020900200529      ** Data structure for data area SDSTAT                                                  CSC011
021000200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
021100200529                                                                                              CSC011
021200200529      *
021300200529      ** Indicator Array
021400200529     D Indicators      DS                  BASED(IndicatorP)
021500200529     D  RecNotFnd             01     01
021600200529     D  EndOfFile             02     02
021700200529      *
021800200529      ** +--------------------------------------+
021900200529      ** ¦ Declared variables                   ¦
022000200529      ** ¦ ==================                   ¦
022100200529      ** +--------------------------------------+
022200200529      *
022300200529      ** Pointer for the indicator Array
022400200529     D IndicatorP      S               *   INZ(%Addr(*IN))
022500200529      *
022600200529      ** Index for arrays of error message ids, etc.
022700200529     D IDx             S              3P 0
022800200529      *
022900200529      ** Index for arrays of warning error message ids, etc.
023000200529     D WIDx            S              3P 0
023100200529      *
023200200529      ** Work variables
023300200529     D WType           S              1A
023400200529     D WSvSRMI         S              1A
023500200529     D WSDED           S              6A
023600200529     D WSvSDTP         S              7P 3
023700200529     D WOrSDTP         S              7P 3
023800200529     D WOlSDPC         S              7P 3
023900200529     D WSvSDTR         S             13P 0
024000200529     D WOlSRPT         S             13P 0
024100200529     D WOlSDPP         S             15P 0
024200200529     D WSvSDTA         S             15P 0
024300200529     D WOrSDTA         S             15P 0
024400200529     D WWPDUD          S              5P 0                                                   260191A
024500200529      *
024600200529      ** Work parameters
024700200529     D PPROT           S              1A
024800200529     D PReDsp          S              1A
024900200529     D PACTN           S              1A
025000200529     D BJDFIN          S              1A
025100200529     D CSE010          S              1A
025200200529     D S01509          S              1A
025300200529     D CSE031          S              1A                                                      CSE031
025400200529     D CSE065          S              1A                                                      CSE065
025500200529     D OKACTN          S              1A
025600200529     D OKSDSN          S              1A
025700200529     D OKSDED          S              1A
025800200529     D OKSDET          S              1A
025900200529     D PSDET           S              2A
026000200529     D PDBRN           S              3A
026100200529     D BJSBRC          S              3A
026200200529     D BVBVP           S              3P 0
026300200529     D PNatn           S              5P 0
026400200529     D BJRDNB          S              5P 0
026500200529     D PEventDat       S              5P 0
026600200529     D PMode           S              6A
026700200529     D PSDED           S              6A
026800200529     D PSDSN           S             10A
026900200529     D PFRNT           S             20A
027000200529     D PTimeStamp      S             26Z
027100200529      *
027200200529      ** Parameters for ZARTVJOBA
027300200529     D PReturn         S              6A
027400200529     D PType           S              1A
027500200529      *
027600200529      ** Parameter list for ZDATE2
027700200529     D PDateIn         S              5P 0
027800200529     D PDateOut        S              6P 0
027900200529     D PADateOut       S              7A
028000200529      *
028100200529      ** Parameter list for ZAMSGTOOPR
028200200529     D PMsgSndRtn      S             10A
028300200529     D PDBError        S            132A
028400200529     D PDummyMsgID     S                   LIKE(#MsgID)
028500200529     D PDummyMsgF      S             10A
028600200529     D Wc              S              2P 0
028700200529                                                                                              CSC011
028800200529      ** Define variable for switchable CSC011.                                               CSC011
028900200529     D CSC011          S              1A   INZ(*BLANKS)                                       CSC011
029000200529                                                                                              CSC011
029100200529      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
029200200529     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
029300200529                                                                                              CSC011
029400200529      ** Define Timestamp (alpha) variable                                                    CSC011
029500200529     D PTime           S             26A                                                      CSC011
029600200529                                                                                              CSC011
029700200529      ** Work field for Date to be passed to RTV module                                       CSC011
029800200529     D PDateRTV        S                   LIKE(BJRDNB)                                       CSC011
029900200529                                                                                              CSC011
030000200529      ** Define Return code                                                                   CSC011
030100200529     D PRetCode        S             10A                                                      CSC011
030200200529                                                                                              CSC011
030300200529      ** Define Deal no parameter for APLOGTRAN                                               CSC011
030400200529     D PDealno         S             18A                                                      CSC011
030500200529                                                                                              CSC011
030600200529      ** Define associated deal number                                                        CSC011
030700200529     D PADealNo        S             18A                                                      CSC011
030800200529                                                                                              CSC011
030900200529      ** Work variable for Diary event date -alpha                                            CSC011
031000200529     D WEventDate      S              5A                                                      CSC011
031100200529                                                                                              CSC011
031200200529      ** Define parameters for AOSARDR0                                                       CSC011
031300200529     D PRTCD           S              7A                                                      CSC011
031400200529     D POPTN           S              7A                                                      CSC011
031500200529     D PSARD           S              6A                                                      CSC011
031600200529      *
031700200529      ** +--------------------------------------+
031800200529      ** ¦ End of D-specs                       ¦
031900200529      ** ¦ ==============                       ¦
032000200529      ** +--------------------------------------+
032100200529      *
032200200529      *****************************************************************
032300200529      /EJECT
032400200529      *****************************************************************
032500200529      *
032600200529      ** +--- Start of Main processing -------------------------------+
032700200529      ** ¦                                                            ¦
032800200529      ** ¦ Initial processing is performed automatically.             ¦
032900200529      ** ¦ *INZSR is executed at program activation.                  ¦
033000200529      ** ¦                                                            ¦
033100200529      ** +------------------------------------------------------------+
033200200529      *
033300200529      *****************************************************************
033400200529      * MAIN PROCEDURE                                                *
033500200529      *****************************************************************
033600200529      *
033700200529      ** Check for update by another workstation.
033800200529      *
033900200529     C                   EXSR      SRChkOthUpd
034000200529      *
034100200529      ** Continue processing if no errors found.
034200200529      *
034300200529     C                   IF        RetCodeIn = *BLANKS
034400200529      *
034500200529      ** Retrieve next available transaction number.
034600200529      *
034700200529     C                   CALLB     'ZTNLU1'
034800200529     C                   PARM                    RetCodeOut
034900200529     C                   PARM                    PNATN
035000200529      *
035100200529      ** Perform corresponding processing for Insert, Amend and Delete.
035200200529     C     S2CHTP        CASEQ     'I'           SRInsert
035300200529     C     S2CHTP        CASEQ     'A'           SRAmend
035400200529     C     S2CHTP        CASEQ     'D'           SRDelete
035500200529     C                   ENDCS
035600200529
035700200529     C                   ENDIF
035800200529
035900200529     C                   IF        RetCodeIn = *BLANKS
036000200529      *
036100200529      ** Action type is amend, adjust totals.
036200200529      *
036300200529     C                   IF        S2CHTP = 'A'
036400200529      *
036500200529      ** Update any running total fields on succeeding records for
036600200529      ** event types 'MP' and 'PP'.
036700200529      *
036800200529     C                   IF        S2SDET = 'MP' OR  S2SDET = 'PP'
036900200529
037000200529     C                   EVAL      EndOfFile = False
037100200529     C     KSedev        SETGT     SEDEV
037200200529
037300200529     C                   DOW       EndOfFile = False
037400200529     C     S2SDSN        READE     SEDEV                                  02
037500200529
037600200529     C                   IF        EndOfFile = False AND
037700200529     C                             RECI <> 'C' AND S2SDET = SDET
037800200529      *
037900200529      ** Input mode - add to total.
038000200529      *
038100200529     C                   IF        SDET = 'MP'
038200200529     C                   SUB       WOlSRPT       SDTR
038300200529     C                   ADD       S2SRPT        SDTR
038400200529     C                   ENDIF
038500200529
038600200529     C                   IF        SDET = 'PP'
038700200529     C                   SUB       WOlSDPP       SDTA
038800200529     C                   ADD       S2SDPP        SDTA
038900200529     C                   SUB       WOlSDPC       SDTP
039000200529     C                   ADD       S2SDPC        SDTP
039100200529     C                   ENDIF
039200200529      *
039300200529      ** Update record.
039400200529      *
039500200529     C                   EXCEPT    UPDTOT
039600200529     C                   ENDIF
039700200529
039800200529     C                   ENDDO
039900200529
040000200529     C                   ENDIF
040100200529     C                   ENDIF
040200200529      *
040300200529      ** Fetch Audit record and update if found.  Otherwise, error.
040400200529      *
040500200529     C     1             CHAIN     SEDEVAF                            01
040600200529
040700200529     C                   IF        RecNotFnd = False
040800200529
040900200529     C                   SELECT
041000200529     C                   WHEN      S2CHTP = 'I'
041100200529     C                   EVAL      F1NOIN = F1NOIN + 1
041200200529     C                   EVAL      F1NORE = F1NORE + 1
041300200529
041400200529     C                   WHEN      S2CHTP = 'A'
041500200529      *                                                                                       CSE031
041600200529      ** If Amending a Security of Event type 'IR' which has been                             CSE031
041700200529      ** actioned then update trailer with 1 Delete and 1 Insert.                             CSE031
041800200529      *                                                                                       CSE031
041900200529     C                   IF        CSE031 = 'Y' AND S2SDET = 'IR' AND                         CSE031
042000200529     C                             S2SDED < BJRDNB AND S2SDAD <> 0                            CSE031
042100200529     C                   EVAL      F1NOIN = F1NOIN + 1                                        CSE031
042200200529     C                   EVAL      F1NORE = F1NORE + 1                                        CSE031
042300200529     C                   EVAL      F1NODE = F1NODE + 1                                        CSE031
042400200529      *                                                                                       CSE031
042500200529     C                   ELSE                                                                 CSE031
042600200529     C                   EVAL      F1NOAM = F1NOAM + 1
042700200529     C                   ENDIF                                                                CSE031
042800200529
042900200529     C                   WHEN      S2CHTP = 'D'
043000200529     C                   EVAL      F1NODE = F1NODE + 1
043100200529     C                   ENDSL
043200200529
043300200529     C                   EVAL      F1TNLU = PNATN
043400200529
043500200529     C                   UPDATE    SEDEVAF
043600200529
043700200529     C                   ELSE
043800200529
043900200529     C     *LOCK         IN        LDA
044000200529     C                   EVAL      DBFILE = 'SEDEVA'
044100200529     C                   EVAL      DBKEY  = 'AUDIT'
044200200529     C                   EVAL      DBASE  =  001
044300200529     C                   OUT       LDA
044400200529     C                   EXSR      *PSSR
044500200529
044600200529     C                   ENDIF
044700200529                                                                                              CSC011
044800200529      ** If CSC011 is on and current system is in support system, convert                     CSC011
044900200529      ** trade details and settlement details in file format to screen                        CSC011
045000200529      ** format to be written to support log file                                             CSC011
045100200529                                                                                              CSC011
045200200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
045300200529                                                                                              CSC011
045400200529     C                   CLEAR                   PRetCode                                     CSC011
045500200529     C                   EXSR      SRCONVERT                                                  CSC011
045600200529                                                                                              CSC011
045700200529      ** If there are no errors in conversion, proceed with writing to                        CSC011
045800200529      ** AP standard log file.                                                                CSC011
045900200529     C                   IF        PRetCode = *BLANKS                                         CSC011
046000200529     C                   EXSR      SRAPILOG                                                   CSC011
046100200529     C                   ENDIF                                                                CSC011
046200200529                                                                                              CSC011
046300200529     C                   ENDIF                                                                CSC011
046400200529
046500200529     C                   ENDIF
046600200529      *
046700200529      ** Return.
046800200529      *
046900200529     C                   RETURN
047000200529      *
047100200529      *****************************************************************
047200200529      /EJECT
047300200529      *****************************************************************
047400200529      *                                                               *
047500200529      *  SRSetRecTot - Setup total for the record.                    *
047600200529      *                                                               *
047700200529      *****************************************************************
047800200529     C     SRSetRecTot   BEGSR
047900200529      *
048000200529      ** Initialise variables
048100200529      *
048200200529     C                   MOVE      *BLANK        WSvSRMI
048300200529     C                   Z-ADD     *ZEROS        WOrSDTA
048400200529     C                   Z-ADD     *ZEROS        WOrSDTP
048500200529     C                   Z-ADD     *ZEROS        WSvSDTA
048600200529     C                   Z-ADD     *ZEROS        WSvSDTP
048700200529     C                   Z-ADD     *ZEROS        WSvSDTR
048800200529     C                   Z-ADD     *ZEROS        WOlSRPT
048900200529     C                   Z-ADD     *ZEROS        WOlSDPP
049000200529     C                   Z-ADD     *ZEROS        WOlSDPC
049100200529      *
049200200529      ** Get initial payments for this security if no payments has
049300200529      ** been made yet for partly paid diary events.
049400200529      *
049500200529     C                   IF        S2SDET = 'PP'
049600200529
049700200529     C     S2SDSN        SETGT     SEDEV
049800200529     C                   READP     SEDEV                                  02
049900200529
050000200529     C                   DOW       EndOfFile = False
050100200529      *
050200200529      ** Check record is not a cancelled record.
050300200529      *
050400200529     C                   IF        RECI <> 'C'
050500200529      *
050600200529      ** Check same security.
050700200529     C                   IF        S2SDSN = SDSN
050800200529      *
050900200529      ** Check same event type.
051000200529     C                   IF        SDET = 'PP'
051100200529     C                   LEAVE
051200200529     C                   ENDIF
051300200529      *
051400200529      ** Exit loop if security are not the same.
051500200529     C                   ELSE
051600200529     C                   EVAL      EndofFile = True
051700200529     C                   LEAVE
051800200529     C                   ENDIF
051900200529
052000200529     C                   ENDIF
052100200529
052200200529     C                   READP     SEDEV                                  02
052300200529     C                   ENDDO
052400200529
052500200529     C                   ENDIF
052600200529      *
052700200529      ** Update totals.
052800200529      *
052900200529     C     KSedev        SETLL     SEDEV
053000200529     C                   READP     SEDEV                                  02
053100200529
053200200529     C                   DOW       EndOfFile = False
053300200529
053400200529     C                   IF        S2SDSN = SDSN
053500200529
053600200529     C                   IF        RECI <> 'C'
053700200529
053800200529     C                   SELECT
053900200529      *
054000200529      ** For Partly Paids, add Call Amount to 'To date' figure.
054100200529      ** Fetch previous total.
054200200529      *
054300200529     C                   WHEN      S2SDET = 'PP' AND SDET = 'PP'
054400200529     C                   Z-ADD     SDTA          WSvSDTA
054500200529     C                   Z-ADD     SDPP          WOlSDPP
054600200529     C                   Z-ADD     SDTP          WSvSDTP
054700200529     C                   Z-ADD     SDPC          WOlSDPC
054800200529     C                   LEAVE
054900200529      *
055000200529      ** For mortgage payments, add Repayment amount to
055100200529      ** 'To date' figure. Fetch previous total.
055200200529      *
055300200529     C                   WHEN      S2SDET = 'MP' AND SDET = 'MP'
055400200529     C                   Z-ADD     SDTR          WSvSDTR
055500200529     C                   Z-ADD     SRPT          WOlSRPT
055600200529     C                   MOVE      SRMI          WSvSRMI
055700200529     C                   LEAVE
055800200529      *
055900200529      ** For Redemption Calls and Puts, add Call Amount to 'To date' figure.
056000200529      ** Fetch previous total.
056100200529      *
056200200529     C                   WHEN      (S2SDET = 'RP' OR S2SDET = 'RC') AND
056300200529     C                             (SDET = 'RP' OR SDET = 'RC')
056400200529     C                   Z-ADD     SDTA          WSvSDTA
056500200529     C                   Z-ADD     SDTP          WSvSDTP
056600200529     C                   LEAVE
056700200529
056800200529     C                   ENDSL
056900200529
057000200529     C                   ENDIF
057100200529      *
057200200529      ** Exit if not same security.
057300200529      *
057400200529     C                   ELSE
057500200529     C                   EVAL      EndOfFile = True
057600200529     C                   LEAVE
057700200529     C                   ENDIF
057800200529
057900200529     C                   READP     SEDEV                                  02
058000200529
058100200529     C                   ENDDO
058200200529      *
058300200529      ** If no event was read for Partly Paid event, get 'currently paid
058400200529      ** price' from security.
058500200529      *
058600200529     C                   IF        S2SDET = 'PP' AND EndofFile = True
058700200529     C                   MOVE      D1CPDP        WOrSDTA
058800200529     C                   MOVE      D1CPDP        WOrSDTP
058900200529     C                   ENDIF
059000200529      *
059100200529      ** Add above amounts to totals.
059200200529      *
059300200529     C                   IF        S2SDET = 'MP'
059400200529
059500200529     C                   EVAL      S2SDTR = WSvSDTR + S2SRPT
059600200529      *
059700200529      ** Set Repayment Method indicator to 'Y' if previously so, or if
059800200529      ** Repayment amount entered
059900200529      *
060000200529     C                   IF        WSvSRMI = 'Y' OR S2SRPT > *ZERO
060100200529     C                   MOVE      'Y'           S2SRMI
060200200529     C                   ENDIF
060300200529
060400200529     C                   ELSE
060500200529
060600200529     C                   EVAL      S2SDTA = WSvSDTA + S2SDPP
060700200529     C                   EVAL      S2SDTP = WSvSDTP + S2SDPC
060800200529
060900200529     C                   ENDIF
061000200529
061100200529     C                   ENDSR
061200200529      *
061300200529      *****************************************************************
061400200529      /EJECT
061500200529      *****************************************************************
061600200529      *                                                               *
061700200529      *  SRChkOthUpd - Check for update by another workstation        *
061800200529      *                                                               *
061900200529      *****************************************************************
062000200529     C     SRChkOthUpd   BEGSR
062100200529      *
062200200529      ** Determine whether program is running interactively or in batch
062300200529      ** ( 0 = batch   1 = interactive).
062400200529      *
062500200529     C                   CALLB     'ZARTVJOBA'
062600200529     C                   PARM                    PReturn
062700200529     C                   PARM                    Ptype
062800200529      *
062900200529      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
063000200529      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
063100200529      ** transaction Id).
063200200529      *
063300200529     C                   EVAL      WType = PType
063400200529
063500200529     C                   IF        S2CHTP <> 'I'
063600200529     C                   MOVEL     '1'           WType
063700200529     C                   ENDIF
063800200529
063900200529     C**********         IF        WType = '0'                                                CAP084
064000200529     C                   IF        WType = '0'   AND                                          CAP084
064100200529      *                                                                                       CAP084
064200200529      ** Only set up Pmode to '*FRONT' if not called from Midas Plus                          CAP084
064300200529      ** API wrapper.                                                                         CAP084
064400200529      *                                                                                       CAP084
064500200529     C                             PSJobName <> 'QZDASOINIT'
064600200529     C                             AND PSJobName <> 'QSQSRVR'                                 247277
064700200529     C                   MOVE      '*FRONT'      PMode
064800200529     C                   ELSE
064900200529     C                   MOVE      *BLANKS       PMode
065000200529     C                   ENDIF
065100200529      *
065200200529      ** Format diary event date.
065300200529      *
065400200529     C                   MOVEL     *BLANKS       PSDED
065500200529     C                   IF        S2SDED = 99999
065600200529     C                   MOVE      '999999'      PSDED
065700200529     C                   ELSE
065800200529     C                   Z-ADD     S2SDED        PDateIn
065900200529     C                   EXSR      SRFmtDat
066000200529     C                   MOVE      PDateOut      PSDED
066100200529     C                   ENDIF
066200200529                                                                                              CSC011
066300200529      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
066400200529      ** and current system is support system.                                                CSC011
066500200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
066600200529     C                   EVAL      PDateRTV = S1DATE                                          CSC011
066700200529     C                   ELSE                                                                 CSC011
066800200529     C                   EVAL      PDateRTV = BJRDNB                                          CSC011
066900200529     C                   ENDIF                                                                CSC011
067000200529                                                                                              CSC011
067100200529      *
067200200529      ** Retrieve details.
067300200529      *
067400200529     C                   CALLB     'SESEDERTV'
067500200529      *
067600200529      ** Input
067700200529      ** =====
067800200529      *
067900200529      ** Retun Code
068000200529     C                   PARM      *BLANKS       RetCodeOut
068100200529      *
068200200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
068300200529      ** Mode = '      ' (Not Front Office Transaction Interface)
068400200529      ** Mode = '*RPR  ' (Repair function)
068500200529      ** Mode = '*SIN  ' (Screen input function)
068600200529     C                   PARM                    PMode
068700200529      *
068800200529      ** Response Mode
068900200529     C                   PARM      *BLANK        ARRespMode
069000200529      *
069100200529      ** Action Code
069200200529     C                   PARM      S2CHTP        PACTN
069300200529      *
069400200529      ** Front Office Transaction Id
069500200529     C                   PARM      S2FRNT        PFRNT
069600200529      *
069700200529      ** Security Shortname
069800200529     C                   PARM      S2SDSN        PSDSN
069900200529      *
070000200529      ** Event Date
070100200529     C                   PARM                    PSDED
070200200529      *
070300200529      ** Event Type
070400200529     C                   PARM      S2SDET        PSDET
070500200529      *
070600200529      ** Standing data
070700200529      ** =============
070800200529      *
070900200529      ** SDBANK - Single Branch Code
071000200529     C                   PARM                    BJSBRC
071100200529      *
071200200529      ***SDBANK*- Run day number                                                              CSC011
071300200529     C**********         PARM                    BJRDNB                                       CSC011
071400200529      ** Processing Date                                                                      CSC011
071500200529     C                   PARM                    PDateRTV                                     CSC011
071600200529      *
071700200529      ** SDBANK - Date format indicator
071800200529     C                   PARM                    BJDFIN
071900200529      *
072000200529      ** SDSTRD - Back value period
072100200529     C                   PARM                    BVBVP
072200200529      *
072300200529      ** ZMUSER - Default Branch
072400200529     C                   PARM                    PDBRN
072500200529      *
072600200529      ** Switchable features
072700200529      ** ===================
072800200529      *
072900200529      ** SE Transaction Enhancement
073000200529     C                   PARM                    CSE010
073100200529      *
073200200529      ** Value Ccy to be Ccy of Issuer Payment
073300200529     C                   PARM                    S01509
073400200529      *                                                                                       CSE031
073500200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
073600200529     C                   PARM                    CSE031                                       CSE031
073700200529                                                                                              CSE065
073800200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
073900200529     C                   PARM                    CSE065                                       CSE065
074000200529      *
074100200529      ** Output
074200200529      ** ======
074300200529      *
074400200529      ** Error fields/message IDs/message data (arrays) from/to caller
074500200529     C                   PARM                    FldNameArr
074600200529     C                   PARM                    MsgIdArr
074700200529     C                   PARM                    MsgDtaArr
074800200529      *
074900200529      ** Array index (3P0) from/to caller
075000200529     C                   PARM                    IDx
075100200529      *
075200200529      ** Warning fields/message IDs/message data (arrays) from/to caller
075300200529     C                   PARM                    WFldNamArr
075400200529     C                   PARM                    WMsgIDArr
075500200529     C                   PARM                    WMsgDtaArr
075600200529      *
075700200529      ** Array index (3P0) from/to caller
075800200529     C                   PARM                    WIDx
075900200529      *
076000200529      ** OK Action Code
076100200529     C                   PARM                    OKACTN
076200200529      *
076300200529      ** OK Security Shortname
076400200529     C                   PARM                    OKSDSN
076500200529      *
076600200529      ** OK Event Date
076700200529     C                   PARM                    OKSDED
076800200529      *
076900200529      ** OK Event Type
077000200529     C                   PARM                    OKSDET
077100200529      *
077200200529      ** Security Diary Events retrieved from file - file format
077300200529     C                   PARM                    CrDEFilFmt
077400200529      *
077500200529      ** Security Details
077600200529     C                   PARM                    PSectyd
077700200529      *
077800200529      ** Processing type from PF/INVTPD
077900200529     C                   PARM                    PPROT
078000200529      *
078100200529      ** Event Date in numeric format.
078200200529     C                   PARM                    PEventDat
078300200529      *
078400200529      ** Redisplay screen
078500200529     C                   PARM                    PReDsp
078600200529      *
078700200529      ** Error if Timestamp is not the same (record has been changed
078800200529      ** by another workstation).
078900200529      *
079000200529      ** Processing varies according to mode program is running in.
079100200529      ** In interacive mode, simply check whether the Timestamp field
079200200529      ** has been updated since the original Incoming Security was
079300200529      ** fetched by this program.  In batch (API input), check return
079400200529      ** parameters from retrieve module for errors, and send
079500200529      ** message to system operator.
079600200529      *
079700200529      ** Interactive mode:
079800200529      *
079900200529     C                   IF        PType = '1'
080000200529
080100200529     C                   IF        CHTMST <> S2TMST
080200200529     C                   MOVEL     '*RECUPD'     RetCodeIn
080300200529     C                   ENDIF
080400200529      *
080500200529      ** Batch mode:
080600200529      *
080700200529     C                   ELSE
080800200529
080900200529     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
081000200529     C                             OKSDED = 'N' OR OKSDET = 'N'
081100200529     C                   MOVEL     '*RECUPD'     RetCodeIn
081200200529     C                   Z-ADD     1             Wc
081300200529
081400200529     C     Wc            DOWLE     ArrayMax
081500200529     C     FldNameArr(Wc)ANDNE     *BLANKS
081600200529     C                   CLEAR                   PDBError
081700200529     C                   EVAL      PDBError = MsgIDArr(Wc)
081800200529
081900200529     C                   CALLB     'ZAMSGTOOPR'
082000200529     C                   PARM                    PMsgSndRtn
082100200529     C                   PARM                    PDBError
082200200529     C                   PARM      *BLANKS       PDummyMsgID
082300200529     C                   PARM      *BLANKS       PDummyMsgF
082400200529     C                   ADD       1             Wc
082500200529     C                   ENDDO
082600200529
082700200529     C                   ENDIF
082800200529
082900200529     C                   ENDIF
083000200529
083100200529     C                   ENDSR
083200200529      *
083300200529      *****************************************************************
083400200529      /EJECT
083500200529      *****************************************************************
083600200529      *                                                               *
083700200529      *  SRInsert - Insert Security Diary Events                      *
083800200529      *                                                               *
083900200529      *****************************************************************
084000200529     C     SRInsert      BEGSR
084100200529      *
084200200529      ** Setup record's total
084300200529     C                   EXSR      SRSetRecTot
084400200529      *
084500200529      ** Check if record already exists in Security Diary Events file.
084600200529      ** Error if it already exists.
084700200529      *
084800200529     C     KSedev        CHAIN     SEDEVDF                            01
084900200529
085000200529     C                   IF        RecNotFnd = False
085100200529
085200200529     C     *LOCK         IN        LDA
085300200529     C                   MOVE      S2SDED        WSDED
085400200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
085500200529     C                   EVAL      DBFILE = 'SEDEVD'
085600200529     C                   EVAL      DBASE  =  002
085700200529     C                   OUT       LDA
085800200529     C                   EXSR      SRErr
085900200529
086000200529     C                   ELSE
086100200529      *
086200200529      ** Generate Timestamp.
086300200529     C                   CALLB     'ZAGENTMSTM'
086400200529     C                   PARM                    PTimestamp
086500200529
086600200529     C                   EVAL      S2TMST = PTimestamp
086700200529     C                   EVAL      S2LCD  = BJRDNB
086800200529     C                   EVAL      S2TNLU = PNATN
086900200529      *
087000200529      ** Move valid file fields to fields for update
087100200529     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
087200200529     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
087300200529     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
087400200529      *                                                                                       CSE065
087500200529     C                   IF        CSE065 = 'Y'                                               CSE065
087600200529     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
087700200529     C                   ELSE                                                                 CSE065
087800200529     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
087900200529     C                   ENDIF                                                                CSE065
088000200529
088100200529     C                   ENDIF
088200200529                                                                                              CSC011
088300200529      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
088400200529      ** transaction even if it originated from SIN module.                                   CSC011
088500200529                                                                                              CSC011
088600200529     C                   IF        CSC011 = 'Y'                                               CSC011
088700200529     C                   IF        FRNT = *BLANKS                                             CSC011
088800200529     C                   MOVE      SDED          WEventDate                                   CSC011
088900200529     C                   EVAL      FRNT = 'MD' + SDSN + WEventDate +                          CSC011
089000200529     C                                    SDET                                                CSC011
089100200529     C                   ENDIF                                                                CSC011
089200200529     C                   ENDIF                                                                CSC011
089300200529
089400200529     C                   WRITE     SEDEVDF                              99
089500200529      *
089600200529      ** DBError processing when error occurred during write.
089700200529      *
089800200529     C                   IF        *IN99 = *ON
089900200529     C     *LOCK         IN        LDA
090000200529     C                   MOVE      S2SDED        WSDED
090100200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
090200200529     C                   EVAL      DBFILE = 'SEDEVD'
090300200529     C                   EVAL      DBASE  =  003
090400200529     C                   OUT       LDA
090500200529     C                   EXSR      *PSSR
090600200529     C                   ENDIF
090700200529
090800200529     C                   ENDSR
090900200529      *
091000200529      *****************************************************************
091100200529      /EJECT
091200200529      *****************************************************************
091300200529      *                                                               *
091400200529      *  SRAmend - Amend Security Diary Events                        *
091500200529      *                                                               *
091600200529      *****************************************************************
091700200529     C     SRAmend       BEGSR
091800200529      *                                                                                       CSE031
091900200529      ** If Amending a Security of Event type 'IR' which has been                             CSE031
092000200529      ** actioned then Delete current event and Insert a new one.                             CSE031
092100200529      *                                                                                       CSE031
092200200529 B1  C                   IF        CSE031 = 'Y' AND S2SDET = 'IR' AND                         CSE031
092300200529     C                             S2SDED < BJRDNB AND S2SDAD <> 0                            CSE031
092400200529      *                                                                                       CSE031
092500200529      ** Delete this Diary Event                                                              CSE031
092600200529      ** -----------------------                                                              CSE031
092700200529      *                                                                                       CSE031
092800200529     C     KSedev        CHAIN     SEDEVDF                            01                      CSE031
092900200529      *                                                                                       CSE031
093000200529      ** Generate Timestamp.                                                                  CSE031
093100200529     C                   CALLB     'ZAGENTMSTM'                                               CSE031
093200200529     C                   PARM                    PTimestamp                                   CSE031
093300200529                                                                                              CSE031
093400200529     C                   EVAL      S2TMST = PTimestamp                                        CSE031
093500200529     C                   EVAL      S2LCD  = BJRDNB                                            CSE031
093600200529     C                   EVAL      S2TNLU = PNATN                                             CSE031
093700200529      *                                                                                       CSE031
093800200529      ** Move valid file fields to fields for update.                                         CSE031
093900200529     C**********         MOVEL     NwDEFilFmt    SedevUpdF                             CSE031 CSE065
094000200529     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
094100200529     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
094200200529      *                                                                                       CSE065
094300200529     C                   IF        CSE065 = 'Y'                                               CSE065
094400200529     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
094500200529     C                   ELSE                                                                 CSE065
094600200529     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
094700200529     C                   ENDIF                                                                CSE065
094800200529      *                                                                                       CSE031
094900200529      ** Update record.                                                                       CSE031
095000200529     C                   MOVE      'C'           RECI                                         CSE031
095100200529     C                   MOVE      'D'           CHTP                                         CSE031
095200200529      *                                                                                       CSE031
095300200529     C                   UPDATE    SEDEVDF                              99                    CSE031
095400200529      *                                                                                       CSE031
095500200529      ** Insert a New Diary Event                                                             CSE031
095600200529      ** ------------------------                                                             CSE031
095700200529      *                                                                                       CSE031
095800200529      ** Retrieve next available transaction number.                                          CSE031
095900200529      *                                                                                       CSE031
096000200529     C                   CALLB     'ZTNLU1'                                                   CSE031
096100200529     C                   PARM                    RetCodeOut                                   CSE031
096200200529     C                   PARM                    PNATN                                        CSE031
096300200529      *                                                                                       CSE031
096400200529      ** Generate Timestamp.                                                                  CSE031
096500200529     C                   CALLB     'ZAGENTMSTM'                                               CSE031
096600200529     C                   PARM                    PTimestamp                                   CSE031
096700200529                                                                                              CSE031
096800200529     C                   EVAL      S2TMST = PTimestamp                                        CSE031
096900200529     C                   EVAL      S2LCD  = BJRDNB                                            CSE031
097000200529     C                   EVAL      S2TNLU = PNATN                                             CSE031
097100200529      *                                                                                       CSE031
097200200529      ** Move valid file fields to fields for update.                                         CSE031
097300200529     C**********         MOVEL     NwDEFilFmt    SedevUpdF                             CSE031 CSE065
097400200529     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
097500200529     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
097600200529      *                                                                                       CSE065
097700200529     C                   IF        CSE065 = 'Y'                                               CSE065
097800200529     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
097900200529     C                   ELSE                                                                 CSE065
098000200529     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
098100200529     C                   ENDIF                                                                CSE065
098200200529      *                                                                                       CSE031
098300200529      ** Write record.                                                                        CSE031
098400200529     C                   MOVE      'D'           RECI                                         CSE031
098500200529     C                   MOVE      'I'           CHTP                                         CSE031
098600200529      *                                                                                       CSE031
098700200529     C                   WRITE     SEDEVDF                                                    CSE031
098800200529      *                                                                                       CSE031
098900200529 X1  C                   ELSE                                                                 CSE031
099000200529      *
099100200529      ** Setup record's total
099200200529     C                   EXSR      SRSetRecTot
099300200529      *
099400200529      ** Check if record already exists in Security Diary Events file.
099500200529      *
099600200529     C     KSedev        CHAIN     SEDEVDF                            01
099700200529      *
099800200529      ** Error if it does not exists.
099900200529     C                   IF        RecNotFnd = True
100000200529     C     *LOCK         IN        LDA
100100200529     C                   MOVE      S2SDED        WSDED
100200200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
100300200529     C                   EVAL      DBFILE = 'SEDEVD'
100400200529     C                   EVAL      DBASE  =  004
100500200529     C                   OUT       LDA
100600200529     C                   EXSR      SRErr
100700200529
100800200529     C                   ELSE
100900200529      *
101000200529      ** If transaction number changes, send error message "The last
101100200529      ** transaction was not applied to the database."
101200200529     C                   IF        TNLU <> S2TNLU
101300200529     C                   MOVEL     '*RECUPD'     RetCodeIn
101400200529     C                   RETURN
101500200529     C                   ENDIF
101600200529      *
101700200529      ** Generate Timestamp.
101800200529     C                   CALLB     'ZAGENTMSTM'
101900200529     C                   PARM                    PTimestamp
102000200529
102100200529     C                   EVAL      S2TMST = PTimestamp
102200200529     C                   EVAL      S2LCD  = BJRDNB
102300200529     C                   EVAL      S2TNLU = PNATN
102400200529      *
102500200529      ** Move valid file fields to fields for update
102600200529     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
102700200529     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
102800200529     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
102900200529      *                                                                                       CSE065
103000200529     C                   IF        CSE065 = 'Y'                                               CSE065
103100200529     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
103200200529     C                   ELSE                                                                 CSE065
103300200529     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
103400200529     C                   ENDIF                                                                CSE065
103500200529      *
103600200529      ** Update record
103700200529     C                   UPDATE    SEDEVDF                              99
103800200529      *
103900200529      ** DBError processing when error occurred during update.
104000200529     C                   IF        *IN99 = *ON
104100200529     C     *LOCK         IN        LDA
104200200529     C                   MOVE      S2SDED        WSDED
104300200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
104400200529     C                   EVAL      DBFILE = 'SEDEVD'
104500200529     C                   EVAL      DBASE  =  005
104600200529     C                   OUT       LDA
104700200529     C                   EXSR      *PSSR
104800200529     C                   ENDIF
104900200529
105000200529     C                   ENDIF
105100200529      *                                                                                       CSE031
105200200529 E1  C                   ENDIF                                                                CSE031
105300200529
105400200529     C                   ENDSR
105500200529      *
105600200529      *****************************************************************
105700200529      /EJECT
105800200529      *****************************************************************
105900200529      *                                                               *
106000200529      *  SRDelete - Delete Security Diary Events                      *
106100200529      *                                                               *
106200200529      *****************************************************************
106300200529     C     SRDelete      BEGSR
106400200529      *
106500200529      ** If there are any live position settlements for this security
106600200529      ** event, output message to screen, and prevent deletion.
106700200529      *
106800200529     C     S2SDSN        SETLL     POSETDF
106900200529     C     S2SDSN        READE     POSETDF                                02
107000200529
107100200529     C                   DOW       EndofFile = False
107200200529      *                                                                                      260191A
107300200529     C                   If        S2SDET = 'MP' or                                          260191A
107400200529     C                             S2SDET = 'DV' and S01512 <> 'Y'                           260191A
107500200529     C                   Eval      WWPDUD = S2SDPD                                           260191A
107600200529     C                   Else                                                                260191A
107700200529     C                   Eval      WWPDUD = S2SDED                                           260191A
107800200529     C                   Endif                                                               260191A
107900200529      *                                                                                      260191A
108000200529     C**********         IF        S2SDED = F2PDUD AND                                       260191A
108100200529     C**********                   S2SDET = F2PEVT AND                                       260191A
108200200529     C**********                   F2RECI = 'D'                                             MD037742
108300200529     C                   If        WWPDUD = F2PDUD and                                       260191A
108400200529     C                             S2SDET = F2PEVT and                                       260191A
108500200529     C                             F2RECI = 'D' AND S2RECI = 'D'                            MD037742
108600200529     C                   MOVEL     '*RECUPD'     RetCodeIn
108700200529     C                   RETURN
108800200529     C                   ENDIF
108900200529
109000200529     C     S2SDSN        READE     POSETDF                                02
109100200529     C                   ENDDO
109200200529      *
109300200529      ** Check if record already exists in Security Diary Events file.
109400200529      *
109500200529     C     KSedev        CHAIN     SEDEVDF                            01
109600200529      *
109700200529      ** Error if it does not exists.
109800200529     C                   IF        RecNotFnd = True
109900200529     C     *LOCK         IN        LDA
110000200529     C                   MOVE      S2SDED        WSDED
110100200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
110200200529     C                   EVAL      DBFILE = 'SEDEVD'
110300200529     C                   EVAL      DBASE  =  006
110400200529     C                   OUT       LDA
110500200529     C                   EXSR      SRErr
110600200529
110700200529     C                   ELSE
110800200529      *
110900200529      ** If transaction number changes, send error message "The last
111000200529      ** transaction was not applied to the database."
111100200529     C                   IF        TNLU <> S2TNLU
111200200529     C                   MOVEL     '*RECUPD'     RetCodeIn
111300200529     C                   RETURN
111400200529     C                   ENDIF
111500200529      *
111600200529      ** Generate Timestamp.
111700200529     C                   CALLB     'ZAGENTMSTM'
111800200529     C                   PARM                    PTimestamp
111900200529
112000200529     C                   EVAL      S2TMST = PTimestamp
112100200529     C                   EVAL      S2LCD  = BJRDNB
112200200529     C                   EVAL      S2TNLU = PNATN
112300200529      *
112400200529      ** Move valid file fields to fields for update.
112500200529     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
112600200529     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
112700200529     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
112800200529      *                                                                                       CSE065
112900200529     C                   IF        CSE065 = 'Y'                                               CSE065
113000200529     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
113100200529     C                   ELSE                                                                 CSE065
113200200529     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
113300200529     C                   ENDIF                                                                CSE065
113400200529      *
113500200529      ** Update record.
113600200529     C                   UPDATE    SEDEVDF                              99
113700200529      *
113800200529      ** DBError processing when error occurred during update.
113900200529     C                   IF        *IN99 = *ON
114000200529     C     *LOCK         IN        LDA
114100200529     C                   MOVE      S2SDED        WSDED
114200200529     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
114300200529     C                   EVAL      DBFILE = 'SEDEVD'
114400200529     C                   EVAL      DBASE  =  007
114500200529     C                   OUT       LDA
114600200529     C                   EXSR      *PSSR
114700200529     C                   ENDIF
114800200529
114900200529     C                   ENDIF
115000200529
115100200529     C                   ENDSR
115200200529      *
115300200529      *****************************************************************
115400200529      /EJECT
115500200529      *****************************************************************
115600200529      *                                                               *
115700200529      *  SRFmtDat - Format date for display                           *
115800200529      *                                                               *
115900200529      *****************************************************************
116000200529     C     SRFmtDat      BEGSR
116100200529
116200200529     C                   CALLB     'ZDATE2'
116300200529     C                   PARM                    PDateIn
116400200529     C                   PARM                    BJDFIN
116500200529     C                   PARM      *ZERO         PDateOut
116600200529     C                   PARM      *BLANKS       PADateOut
116700200529
116800200529     C                   ENDSR
116900200529      *
117000200529      *****************************************************************
117100200529      /EJECT
117200200529      *****************************************************************
117300200529      *                                                               *                       CSC011
117400200529      *  SRCONVERT - convert Securitiy Diary Event details to screen  *                       CSC011
117500200529      *    ~~~~~~~   format before writing to standard API log file.  *                       CSC011
117600200529      *                                                               *                       CSC011
117700200529      *  Called by: Main Processing                                   *                       CSC011
117800200529      *  Calls    : SESEDELOG - Diary events support log setup module *                       CSC011
117900200529      *                                                               *                       CSC011
118000200529      *****************************************************************                       CSC011
118100200529                                                                                              CSC011
118200200529     C     SRCONVERT     BEGSR                                                                CSC011
118300200529                                                                                              CSC011
118400200529      ** Input:                                                                               CSC011
118500200529      ** SE Diary events in file format                                                       CSC011
118600200529      ** Date Format Indicator                                                                CSC011
118700200529      ** Enhancement S01509                                                                   CSC011
118800200529                                                                                              CSC011
118900200529      ** Output parameters:                                                                   CSC011
119000200529      ** Return Code                                                                          CSC011
119100200529      ** SE Diary events in screen format                                                     CSC011
119200200529     C                   CALLB     'SESEDELOG'                                                CSC011
119300200529     C                   PARM                    PRetCode                                     CSC011
119400200529     C                   PARM                    SedevUpdF                                    CSC011
119500200529     C                   PARM                    BJDFIN                                       CSC011
119600200529     C                   PARM                    S01509                                       CSC011
119700200529     C                   PARM                    TRANSDTL                                     CSC011
119800200529                                                                                              CSC011
119900200529      ** If error occurred in program, return with an error code.                             CSC011
120000200529     C                   IF        PRetCode <> *BLANKS                                        CSC011
120100200529     C                   EVAL      DBASE = 9                                                  CSC011
120200200529     C                   EVAL      DBFILE = 'SESEDELOG'                                       CSC011
120300200529     C                   EVAL      DBKEY = '*CALL'                                            CSC011
120400200529     C                   EXSR      SRERR                                                      CSC011
120500200529     C                   ENDIF                                                                CSC011
120600200529                                                                                              CSC011
120700200529     C                   ENDSR                                                                CSC011
120800200529      *****************************************************************                       CSC011
120900200529      /EJECT                                                                                  CSC011
121000200529      *****************************************************************                       CSC011
121100200529      *                                                               *                       CSC011
121200200529      *  SRAPILOG - write SE Diary Event details to standard log file *                       CSC011
121300200529      *                                                               *                       CSC011
121400200529      *  Called by: Main processing                                   *                       CSC011
121500200529      *  Calls    : APLOGTRAN - Log transaction from support dbase    *                       CSC011
121600200529      *                                                               *                       CSC011
121700200529      *****************************************************************                       CSC011
121800200529                                                                                              CSC011
121900200529     C     SRAPILOG      BEGSR                                                                CSC011
122000200529                                                                                              CSC011
122100200529     C                   CLEAR                   PHead                                        CSC011
122200200529      ** Fill up other neccessary information in the header to be used                        CSC011
122300200529      ** by APTRANLOG                                                                         CSC011
122400200529     C                   EVAL      APTGTTYPE = 'SESEDE'                                       CSC011
122500200529     C                   EVAL      APFOTRANID = S2FRNT                                        CSC011
122600200529     C                   EVAL      APUSERID = PSUser                                          CSC011
122700200529                                                                                              CSC011
122800200529      ** Place event date to alpha field                                                      CSC011
122900200529     C                   MOVE      SDED          WEventDate                                   CSC011
123000200529                                                                                              CSC011
123100200529      ** Fill deal no. parameter with key values from SEDEV                                   CSC011
123200200529     C                   EVAL      PDealNo = SDSN + WEventDate + SDET                         CSC011
123300200529                                                                                              CSC011
123400200529      ** Input parameters:                                                                    CSC011
123500200529      ** Header information                                                                   CSC011
123600200529      ** SE Diary Event Details                                                               CSC011
123700200529      ** Timestamp                                                                            CSC011
123800200529      ** Event Identifier (deal no.)                                                          CSC011
123900200529                                                                                              CSC011
124000200529      ** Output parameter:                                                                    CSC011
124100200529      ** ReturnCode                                                                           CSC011
124200200529     C                   CALLB     'APLOGTRAN'                                                CSC011
124300200529     C                   PARM      *BLANKS       PRetCode                                     CSC011
124400200529     C                   PARM                    PHead                                        CSC011
124500200529     C                   PARM                    TRANSDTL                                     CSC011
124600200529     C                   PARM      *BLANKS       PTime                                        CSC011
124700200529     C                   PARM                    PDealNo                                      CSC011
124800200529     C                   PARM      *BLANKS       PADealNo                                     CSC011
124900200529                                                                                              CSC011
125000200529      ** If error occurred, return with an error to the calling program                       CSC011
125100200529     C                   IF        PRetCode <> *BLANKS                                        CSC011
125200200529     C                   EVAL      DBASE = 10                                                 CSC011
125300200529     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
125400200529     C                   EVAL      DBKEY = '*CALL'                                            CSC011
125500200529     C                   EXSR      SRERR                                                      CSC011
125600200529     C                   ENDIF                                                                CSC011
125700200529                                                                                              CSC011
125800200529     C                   ENDSR                                                                CSC011
125900200529                                                                                              CSC011
126000200529      *****************************************************************                       CSC011
126100200529      /EJECT                                                                                  CSC011
126200200529      *****************************************************************                       CSC011
126300200529      *                                                               *
126400200529      *  SRErr - Routine for Exception Errors                         *
126500200529      *                                                               *
126600200529      *****************************************************************
126700200529     C     SRErr         BEGSR
126800200529
126900200529     C                   EVAL      RetCodeIn = '*ERROR '
127000200529     C                   EVAL      *INU7 = *ON
127100200529     C                   EVAL      *INU8 = *ON
127200200529     C                   EVAL      *INLR = *ON
127300200529
127400200529     C                   DUMP
127500200529      *
127600200529      ** Terminate program.
127700200529      *
127800200529     C                   RETURN
127900200529
128000200529     C                   ENDSR
128100200529      *
128200200529      *****************************************************************
128300200529      /EJECT
128400200529      *****************************************************************
128500200529      *                                                               *
128600200529      * *INZSR - Program Initialisation routine                       *
128700200529      *                                                               *
128800200529      * Called by: Implicitly on program activation                   *
128900200529      *                                                               *
129000200529      * Calls: None                                                   *
129100200529      *                                                               *
129200200529      *****************************************************************
129300200529     C     *INZSR        BEGSR
129400200529
129500200529     C     *ENTRY        PLIST
129600200529      *
129700200529      ** Input
129800200529      ** =====
129900200529      *
130000200529      ** Return code
130100200529     C                   PARM                    RetCodeIn
130200200529      *
130300200529      ** SE Diary events for file update - file format
130400200529     C                   PARM                    NwDEFilFmt
130500200529      *
130600200529      ** Standing data
130700200529      ** =============
130800200529      *
130900200529      ** SDBANK - Single branch code
131000200529     C                   PARM                    BJSBRC
131100200529      *
131200200529      ** SDBANK - Run day number
131300200529     C                   PARM                    BJRDNB
131400200529      *
131500200529      ** SDBANK - Date format indicator
131600200529     C                   PARM                    BJDFIN
131700200529      *
131800200529      ** SDSTRD - Back value period
131900200529     C                   PARM                    BVBVP
132000200529      *
132100200529      ** ZMUSER - Default branch
132200200529     C                   PARM                    PDBRN
132300200529      *
132400200529      ** Switchable features
132500200529      ** ===================
132600200529      *
132700200529      ** SE Transaction enhancement
132800200529     C                   PARM                    CSE010
132900200529      *
133000200529      ** Value Ccy to be Ccy of issuer payment
133100200529     C                   PARM                    S01509
133200200529      *                                                                                       CSE031
133300200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
133400200529     C                   PARM                    CSE031                                       CSE031
133500200529                                                                                              CSE065
133600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
133700200529     C                   PARM                    CSE065                                       CSE065
133800200529      *
133900200529      ** Key list for Security Diary Events details
134000200529     C     KSedev        KLIST
134100200529     C                   KFLD                    S2SDSN
134200200529     C                   KFLD                    S2SDED
134300200529     C                   KFLD                    S2SDET
134400200529      *                                                                                      260191A
134500200529      ** Check if S01512 is installed                                                        260191A
134600200529      *                                                                                      260191A
134700200529     C                   CALL      'AOSARDR0'                                                260191A
134800200529     C                   PARM      *BLANKS       @RTCD             7                         260191A
134900200529     C                   PARM      '*VERIFY'     @OPTN             7                         260191A
135000200529     C                   PARM      'S01512'      @SARD             6                         260191A
135100200529      *                                                                                      260191A
135200200529     C                   IF        @RTCD = *BLANKS                                           260191A
135300200529     C                   MOVE      'Y'           S01512            1                         260191A
135400200529     C                   ELSE                                                                260191A
135500200529     C                   MOVE      'N'           S01512                                      260191A
135600200529     C                   ENDIF                                                               260191A
135700200529      *
135800200529      ** Program, module and procedure names for database error processing
135900200529      ** =================================================================
136000200529      ** The following /COPY sets these values.
136100200529      /COPY ZACPYSRC,DBFIELDS
136200200529
136300200529                                                                                              CSC011
136400200529      ** Check if Midas 24x7 Availability is installed.                                       CSC011
136500200529     C                   CALLB     'AOSARDR0'                                                 CSC011
136600200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
136700200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
136800200529     C                   PARM      'CSC011'      PSARD                                        CSC011
136900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
137000200529                                                                                              CSC011
137100200529      ** An NRF (No Record Found) return code is valid.                                       CSC011
137200200529      ** Issue database error only for error return codes.                                    CSC011
137300200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
137400200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
137500200529     C                   EVAL      DBKey = 'CSC011'                                           CSC011
137600200529     C                   EVAL      DBASE = 8                                                  CSC011
137700200529     C                   EXSR      SRERR                                                      CSC011
137800200529     C                   ENDIF                                                                CSC011
137900200529                                                                                              CSC011
138000200529     C                   IF        PRTCD = *BLANK                                             CSC011
138100200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
138200200529     C                   IN        SC24X7                                                     CSC011
138300200529     C                   IN        SDSTAT                                                     CSC011
138400200529     C                   ELSE                                                                 CSC011
138500200529     C                   EVAL      CSC011 = 'N'                                               CSC011
138600200529     C                   ENDIF                                                                CSC011
138700200529                                                                                              CSE065
138800200529      ** Access SAR file to determine if CSE065 is installed                                  CSE065
138900200529                                                                                              CSE065
139000200529     C                   CALL      'AOSARDR0'                                                 CSE065
139100200529     C                   PARM      *BLANKS       PRtcd                                        CSE065
139200200529     C                   PARM      '*VERIFY'     POptn                                        CSE065
139300200529     C                   PARM      'CSE065'      PSarD                                        CSE065
139400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
139500200529                                                                                              CSE065
139600200529      ** An NRF (No Record Found) return code is valid.                                       CSE065
139700200529      ** Issue database error only for error return codes.                                    CSE065
139800200529                                                                                              CSE065
139900200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
140000200529     C                             PRtcd <> '*NRF   '                                         CSE065
140100200529     C     *LOCK         IN        LDA                                                        CSE065
140200200529     C                   EVAL      DBKey = 'CSE065'                                           CSE065
140300200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
140400200529     C                   EVAL      DBase = 011                                                CSE065
140500200529     C                   OUT       LDA                                                        CSE065
140600200529     C                   EXSR      *PSSR                                                      CSE065
140700200529     C                   ENDIF                                                                CSE065
140800200529                                                                                              CSE065
140900200529     C                   IF        PRtcd = *BLANKS                                            CSE065
141000200529     C                   MOVEL     'Y'           CSE065                                       CSE065
141100200529     C                   ELSE                                                                 CSE065
141200200529     C                   MOVEL     'N'           CSE065                                       CSE065
141300200529     C                   ENDIF                                                                CSE065
141400200529                                                                                              CSC011
141500200529     C                   ENDSR
141600200529      *
141700200529      *****************************************************************
141800200529      /EJECT
141900200529      *****************************************************************
142000200529      *
142100200529      ** The following /COPY contains the standard program status
142200200529      ** subroutine, including a bound call to the DBERRCTL module.
142300200529      /COPY ZACPYSRC,PSSR_ILE
142400200529      *
142500200529      *****************************************************************
142600200529      /EJECT
142700200529     OSEDEVDF   E            UPDTOT
142800200529     O                       SDTR
142900200529     O                       SDTA
143000200529     O                       SDTP
143100200529      /EJECT
143200200529      *****************************************************************
143300200529      *
143400200529**  CPY@
143500200529(c) Finastra International Limited 2001
