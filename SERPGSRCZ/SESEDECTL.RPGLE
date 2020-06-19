000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Security diary events interface cntroller')   *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDECTL - Security Diary Events Interface Controller       *
001100200529      *                                                               *
001200200529      *  Function: This module validates Security Diary Events input  *
001300200529      *            into the Midas database.                           *
001400200529      *            Processes to be executed controlled by input       *
001500200529      *            Action Code:                                       *
001600200529      *            - For I (=INSERT) or A (=AMEND), validate the      *
001700200529      *              Security Diary Events.                           *
001800200529      *            - For A (=AMEND),                                  *
001900200529      *              - if transaction is a partial amendment, call a  *
002000200529      *                separate function to complete the transaction  *
002100200529      *                details.                                       *
002200200529      *              - if transaction is valid, call a separate       *
002300200529      *                function to check whether it is a valid        *
002400200529      *                amendment.                                     *
002500200529      *            - For D (=DELETE) and E (=Enquire), call a         *
002600200529      *              seperate function to process the transaction and *
002700200529      *              bypass the rest of the validation.               *
002800200529      *                                                               *
002900200529      *            For all Action Codes, the decision as to whether   *
003000200529      *            to write to the Valid or Invalid file and the call *
003100200529      *            to the Message Handler (ZAMSGHNDLE) will take      *
003200200529      *            place in this module.                              *
003300200529      *                                                               *
003400200529      *  Component of: SESEDECTL                                      *
003500200529      *                                                               *
003600200529      *  (c) Finastra International Limited 2001                      *
003700200529      *                                                               *
003800200604      *  Last Amend No. 260191A            Date 22May20               **
003900200529      *  Prev Amend No. CSD102             Date 08Jan19               *
004000200529      *                 MD046248           Date 27Oct17               *
004100200529      *                 CRE073             Date 06Dec10               *
004200200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
004300200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
004400200529      * Midas Plus 1.4 Base ------------------------------------------*
004500200529      * Midas Plus 1.3 ----------- Base ------------------------------*
004600200529      *                 CSD027             Date 09Dec05               *
004700200529      *                 CSE075             Date 17Nov05               *
004800200529      *                 CGL031             Date 05Jul04               *
004900200529      *                 CSE065             Date 06Dec04               *
005000200529      *                 CSE071             Date 19Jul05               *
005100200529      *                 CSE072             Date 05Apr05               *
005200200529      *                 BUG2064            Date 29May04               *
005300200529      *                 BUG2604            Date 18May04               *
005400200529      *                 CAS006             Date 21Jan03               *
005500200529      * Midas Release 4.01 -------------------------------------------*
005600200529      *                 CSE031             Date 09Nov01               *
005700200529      *                 CSC011             Date 18Sep01               *
005800200529      * Midas Release 4 --------------- Base -------------------------*
005900200529      * Midas DBA 3.05 -----------------------------------------------*
006000200529      *                 CSD006             Date 11Oct00               *
006100200529      *                 CAP140  *CREATE    Date 17Oct00               *
006200200529      *                                                               *
006300200529      *---------------------------------------------------------------*
006400200529      *                                                               *
006500200529      *  260191A- System should not allow deletion of LIVE/MATURED    *
006600200529      *           security diary event if ALL generated position      *
006700200529      *           settlements are still unsettled/live records.       *
006800200529      *           Hence, system will not generate reversal position   *
006900200529      *           settlements.                                        *
007000200529      *  CSD102 - Password Length Extension (Recompile)               *
007100200529      *  MD046248 - Finastra Rebranding                               *
007200200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
007300200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
007400200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
007500200529      *           (Recompile)                                         *
007600200529      *  CGL031 - Taxation of Savings Income                          *
007700200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
007800200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
007900200529      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
008000200529      *  BUG2064 - Initialization of CSC022.                          *
008100200529      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
008200200529      *  CAS006 - Hedge Accounting Phase B                            *
008300200529      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
008400200529      *  CSC011 - 24x7 Midas Availability                             *
008500200529      *  CSD006 - Recompiled over changed SECTYD.                     *
008600200529      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
008700200529      *           modular structure to use as APIs.                   *
008800200529      *                                                               *
008900200529      *****************************************************************
009000200529      *                                                               *
009100200529      *  Use of indicators.                                           *
009200200529      *                                                               *
009300200529      *    01         Use for chaining to file                        *
009400200529      *                                                               *
009500200529      *****************************************************************
009600200529      *                                                               *
009700200529      *  S U B R O U T I N E  I N D E X                               *
009800200529      *                                                               *
009900200529      *  SRChkValTran - Routine to check if valid security diary      *
010000200529      *                 events exist for Front Office Id in the       *
010100200529      *                 valid security diary events file.             *
010200200529      *  SRChkValMTran - Routine to check if valid security diary     *
010300200529      *                  events exist for security shortname, event   *
010400200529      *                  date and event type in the valid security    *
010500200529      *                  diary events file.                           *
010600200529      *  SRValAction - Routine to validate Action Code for the        *
010700200529      *                security shortname, event date and event type  *
010800200529      *                supplied                                       *
010900200529      *  SRValDetails - Routine to validate Security Diary Events Det.*
011000200529      *  SRDefault1 - Defaulting for screen 1                         *
011100200529      *  SRVScrn1  - Validate screen 1 details                        *
011200200529      *  SRCvtSeDE - Convert security diary events details from file  *
011300200529      *              to screen format                                 *
011400200529      *  SRDtaSubs - Data Substitution Routine                        *
011500200529      *  SRValAmend - Routine to check whether the fields are         *
011600200529      *               amendable                                       *
011700200529      *  SRCheckWrite - Routine to control checking of error status   *
011800200529      *                 and sending of messages/writing to the        *
011900200529      *                 database                                      *
012000200529      *  SRSetValid - Routine to set up fields in the valid file      *
012100200529      *               record.                                         *
012200200529      *  SRSetInvalid - Routine to set up fields in the invalid file  *
012300200529      *                 record.                                       *
012400200529      *  SRMsgHdl - Routine to call the message handling module       *
012500200529      *  SRResetFld - Routine to reset fields                         *
012600200529      *  *PSSR - Error processing                                     *
012700200529      *  *INZSR - Initialise                                          *
012800200529      *                                                               *
012900200529      *    The *INZSR subroutine will only get called automatically   *
013000200529      *    on entry to the module the first time it is run            *
013100200529      *    (unless you end the program with LR on).  Similarly        *
013200200529      *    D-spec initialisation only happens the first time.  Use    *
013300200529      *    RESET for subsequent passes.                               *
013400200529      *                                                               *
013500200529      *****************************************************************
013600200529      *
013700200529      ** +--------------------------------------+
013800200529      ** ¦ F-specs                              ¦
013900200529      ** ¦ =======                              ¦
014000200529      ** +--------------------------------------+
014100200529      *
014200200529      ** Valid security diary events
014300200529     FSEVSEDEPD UF A E             DISK    INFSR(*PSSR)
014400200529     F                                     COMMIT
014500200529      *
014600200529      ** Invalid security diary events
014700200529     FSEISEDEPD UF A E             DISK    INFSR(*PSSR)
014800200529     F                                     COMMIT
014900200529      *
015000200529      ** Valid security diary events by front office Id
015100200529     FSEVSEDEL0 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHK)
015200200529      *
015300200529      ** Valid security diary events by key fields and timestamp
015400200529     FSEVSEDEL1 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHM)
015500200529      *
015600200529      ** Sequence number for input fields
015700200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
015800200529      *
015900200529      ** Midas Module Flag file
016000200529     FMMODF     IF   E             DISK    INFSR(*PSSR)
016100200529      *                                                                                      260191A
016200200529      ** Position Settlement by Security                                                     260191A
016300200529      *                                                                                      260191A
016400200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)                                      260191A
016500200529     F                                     PREFIX(F3)                                        260191A
016600200529      *
016700200529      ** Hook to enable non-core files to be included
016800200529      /COPY WNCPYSRC,SESEDEC001
016900200529      *
017000200529      *****************************************************************
017100200529      /EJECT
017200200529      *****************************************************************
017300200529      *
017400200529      ** +--------------------------------------+
017500200529      ** ¦ Automatically included D-specs       ¦
017600200529      ** ¦ ==============================       ¦
017700200529      ** +--------------------------------------+
017800200529      *
017900200529      ** Standard D-specs
018000200529      ** ================
018100200529      **
018200200529      ** The following /COPY line includes the LDA layout,
018300200529      ** the copyright array definition,
018400200529      ** and the following named constants:
018500200529      **    True       logical = *on (for indcator processing)
018600200529      **    False      logical = *off (for indicator processing)
018700200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
018800200529      **                                    handler)
018900200529      ** and the following variables:
019000200529      **    RunBefore  1A (for the PSSR)
019100200529      *
019200200529      /COPY ZACPYSRC,STD_D_SPEC
019300200529      *
019400200529      ** Program Status Data Structure
019500200529      ** =============================
019600200529      ** The following /COPY line includes all the defined fields in the
019700200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
019800200529      *
019900200529      /COPY ZACPYSRC,PSDS
020000200529      *
020100200529      ** The following /COPY line includes definition  for the above fields
020200200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
020300200529      ** corresponding fields in the PSDS /COPY member, so that member
020400200529      ** must be included where this one is used.
020500200529      *
020600200529      /COPY ZACPYSRC,PROCPARMS
020700200529      *
020800200529      ** The following /COPY line includes the definitions for error and
020900200529      ** warning message arrays.
021000200529      *
021100200529      /COPY ZACPYSRC,ERR_ARRAYS
021200200529      *
021300200529      ** The following /COPY line includes the definitions for arrays
021400200529      ** specific to API *CTL modules.
021500200529      *
021600200529      /COPY ZACPYSRC,APICTLARR
021700200529      *
021800200529      ** The following /COPY line includes the definitions for fields
021900200529      ** used in checking whether there are messages on the data queue.
022000200529      *
022100200529      /COPY ZACPYSRC,DTAQCHKDCL
022200200529      *
022300200529      ** +--------------------------------------+
022400200529      ** ¦ End of automatically included D-specs¦
022500200529      ** ¦ =====================================¦
022600200529      ** +--------------------------------------+
022700200529      *
022800200529      *****************************************************************
022900200529      /EJECT
023000200529      *****************************************************************
023100200529      *
023200200529      ** +--------------------------------------+
023300200529      ** ¦ Manually included D-specs            ¦
023400200529      ** ¦ =========================            ¦
023500200529      ** +--------------------------------------+
023600200529      *
023700200529      ** +--------------------------------------+
023800200529      ** ¦ Named constants                      ¦
023900200529      ** ¦ ===============                      ¦
024000200529      ** +--------------------------------------+
024100200529      *
024200200529      ** String for error messages to the operator
024300200529     D WProcErr        C                   CONST('Error in module')
024400200529      *
024500200529      ** +--------------------------------------+
024600200529      ** ¦ Arrays and Data Structures           ¦
024700200529      ** ¦ ==========================           ¦
024800200529      ** +--------------------------------------+
024900200529      *
025000200529      * Array to hold Commitment Job Names                                                   BUG2604
025100200529     D CmtJobNArr      S             10A   DIM(10)                                           BUG2604
025200200529                                                                                             BUG2604
025300200529      ** Commitment Control Data Area                                                        BUG2604
025400200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2604
025500200529     D  wComitJob              4    103                                                      BUG2604
025600200529                                                                                             BUG2604
025700200529      ** Message header details
025800200529     D PHeadIn       E DS                  EXTNAME(APHEADPD)
025900200529      *
026000200529      ** SE Diary Events Screen details from incoming transaction -
026100200529      ** - screen format
026200200529     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
026300200529      *
026400200529      ** SE Diary Events for file update - file format
026500200529     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
026600200529     D NwDEFilFmt1             1    231                                                       CSE065
026700200529      *
026800200529      ** SE Diary Events Screen details retrieved from file
026900200529      ** - screen format
027000200529     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
027100200529     D                                     PREFIX(O)
027200200529      *
027300200529      ** Security diary events retrieved from file - file format
027400200529     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
027500200529     D CrDEFilFmt1             1    231                                                       CSE065
027600200529      *
027700200529      ** SE Diary Events screen error indicators
027800200529     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
027900200529      *
028000200529      ** Security Diary Events extra data
028100200529     D PExtData      E DS                  EXTNAME(SESDEXPD)
028200200529      *
028300200529      ** Externally described DS for security details
028400200529     D PSectyd       E DS                  EXTNAME(SECTYD)
028500200529     D                                     PREFIX(D1)
028600200529      *
028700200529      ** Externally described DS for bank details
028800200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
028900200529      *
029000200529      ** Externally described DS for API ICD details
029100200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
029200200529      *
029300200529      ** Externally described DS for securities trading icd details
029400200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
029500200529      *
029600200529      ** Externally described DS for SAR details
029700200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
029800200529     D SLCD          E                     EXTFLD(LCD)
029900200529      *
030000200529      ** DS for Access Objects - short data structure
030100200529     D DSFDY         E DS                  EXTNAME(DSFDY)
030200200529      *
030300200529      ** DS for Access Objects - long data structure
030400200529     D DSSDY         E DS                  EXTNAME(DSSDY)
030500200529                                                                                              CSC011
030600200529      ** Data structure for data area SC24X7                                                  CSC011
030700200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
030800200529                                                                                              CSC011
030900200529      ** Data structure for data area SDSTAT                                                  CSC011
031000200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
031100200529      *
031200200529      ** DS for ZMUSER details
031300200529     D ZMUSER          DS            17
031400200529     D  PUSRID                 1     10
031500200529     D  PDBRN                 11     13
031600200529     D  PDPPT                 14     16
031700200529      *
031800200529      ** Indicator Array
031900200529     D Indicators      DS                  BASED(IndicatorP)
032000200529     D  RecNotFnd             01     01
032100200529      *
032200200529      ** +--------------------------------------+
032300200529      ** ¦ Declared variables                   ¦
032400200529      ** ¦ ==================                   ¦
032500200529      ** +--------------------------------------+
032600200529      *
032700200529      ** Index for arrays of error messages
032800200529     D IDx             S              3P 0
032900200529      *
033000200529      ** Index for arrays of warning messages
033100200529     D WIDx            S              3P 0
033200200529      *
033300200529      ** Pointer for the indicator array
033400200529     D IndicatorP      S               *   INZ(%Addr(*IN))
033500200529      *
033600200529      ** Indices for arrays used to set up corresponding sequence numbers
033700200529      ** for the fields that are in error
033800200529     D W1              S              3P 0
033900200529     D W2              S              3P 0
034000200529      *
034100200529      ** Index for arrays of error message Ids in amend validation
034200200529     D AMIDx           S              3P 0
034300200529      *
034400200529      ** Fields (500A) to receive the incoming transaction
034500200529     D PTrans5001      S            500A
034600200529      *
034700200529      ** Parametes for data substitution program.
034800200529     D PIncData        S           2000A
034900200529     D PCurData        S           2000A
035000200529      *
035100200529      ** Field (500A) to receive the incoming extra data
035200200529     D PExtData500     S            500A
035300200529      *
035400200529      ** Timestamp for the transaction
035500200529     D PTimestamp      S               Z
035600200529      *
035700200529      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
035800200529     D PObject         S             10A   INZ('SESEDEUPC')
035900200529     D PLib            S             10A   INZ('*LIBL')
036000200529     D PObjType        S              7A
036100200529     D PLockState      S              7A   INZ('*SHRRD')
036200200529     D PMember         S             10A
036300200529     D PWaitTime       S              6A   INZ('0     ')
036400200529     D PDlcObj         S              1A   INZ('Y')
036500200529     D PReturn         S              7A
036600200529      *
036700200529      ** Module Id to be passed to the message handler
036800200529     D PModuleId       S              2A   INZ('SE')
036900200529      *
037000200529      ** Whether or not to clear the program message queue (this is not
037100200529      ** actually used, but is required by the message handler's parameter
037200200529      ** list)
037300200529     D PClrPgmMsgQ     S              1A   INZ('Y')
037400200529      *
037500200529      ** Overall Transaction status, to be passed to the message handler
037600200529     D PTranStatus     S              1A
037700200529      *
037800200529      ** Dummy message Id and message file fields for use on the calls to
037900200529      ** ZAMSGTOOPR
038000200529     D PDummyMsgId     S                   LIKE(#MsgID)
038100200529     D PDummyMsgF      S             10A
038200200529      *
038300200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
038400200529      ** Mode = '      ' (Not Front Office Transaction Interface)
038500200529      ** Mode = '*RPR  ' (Repair Function)
038600200529      ** Mode = '*SIN  ' (Screen Input Function)
038700200529     D PMode           S              6A
038800200529      *
038900200529      ** Work parameters
039000200529     D PRTCD           S              7A
039100200529     D POPTN           S              7A
039200200529     D PSARD           S              6A
039300200529     D PTranID         S             20A
039400200529     D PResetFld       S              1A
039500200529     D PAmendOk        S              1A
039600200529     D PMQReturn       S             10A
039700200529     D PMQErrLong      S            132A
039800200529     D PEvtDno         S              5P 0
039900200529     D PPayCcy         S              3A
040000200529     D PPROT           S              1A
040100200529      *
040200200529      ** Switchable features
040300200529     D CSE010          S              1A
040400200529     D S01509          S              1A
040500200529     D S01510          S              1A
040600200529     D CSE031          S              1A                                                      CSE031
040700200529     D CAS006          S              1A                                                      CAS006
040800200529     D CSC022          S              1A                                                     BUG2064
040900200529     D CSE072          S              1A                                                      CSE072
041000200529     D CSE065          S              1A                                                      CSE065
041100200529     D CGL031          S              1A                                                      CGL031
041200200529      *
041300200529      ** Redisplay screen flag
041400200529     D PReDsp          S              1A
041500200529      *
041600200529      ** Work variables
041700200529     D WSubDE1         S              1A
041800200529     D WMQError        S             28A
041900200529     D WEvtDno         S              5P 0
042000200529     D DDCUCR          S             12A
042100200529     D DDSEXR          S             14A
042200200529      *
042300200529      ** Parameters for ZDATE1
042400200529     D PDateIn         S              6A
042500200529     D PDayNoOut       S              5P 0
042600200529     D PErrorFlag      S              1A
042700200529                                                                                              CSC011
042800200529      ** CSC011 enhancement                                                                   CSC011
042900200529     D CSC011          S              1A   INZ('N')                                           CSC011
043000200529                                                                                              CSC011
043100200529      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
043200200529     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
043300200529                                                                                              CSC011
043400200529      ** Transaction number to be pass to APLOGTRAN.                                          CSC011
043500200529     D PDealNo         S             18A   INZ(*BLANKS)                                       CSC011
043600200529                                                                                              CSC011
043700200529      ** Associated transaction number                                                        CSC011
043800200529     D PADealNo        S             18A   INZ(*BLANKS)                                       CSC011
043900200529                                                                                              CSC011
044000200529      ** Work variable for Diary event date -alpha                                            CSC011
044100200529     D WSDED           S              5A                                                      CSC011
044200200529                                                                                              CSC011
044300200529      ** Processing date                                                                      CSC011
044400200529     D WRDAY           S                   LIKE(BJRDNB)                                       CSC011
044500200529      *
044600200529      ** Work variables forBUG2604                                                           BUG2604
044700200529     DBUG2604          S              1A   INZ('N')                                          BUG2604
044800200529     D wCommitSkip     S              1A   INZ('N')                                          BUG2604
044900200529                                                                                             BUG2604
045000200529      ** +----------------------------------------+
045100200529      ** ¦ Hook for non-core D-specs (all types)  ¦
045200200529      ** ¦ also any I-specs (if necessary)        ¦
045300200529      ** ¦ =====================================  ¦
045400200529      ** +----------------------------------------+
045500200529      *
045600200529      /COPY WNCPYSRC,SESEDEC002
045700200529      *
045800200529      ** +--------------------------------------+
045900200529      ** ¦ End of D-specs                       ¦
046000200529      ** ¦ ==============                       ¦
046100200529      ** +--------------------------------------+
046200200529      *
046300200529      *****************************************************************
046400200529      /EJECT
046500200529      *****************************************************************
046600200529      *
046700200529      ** +--- Start of Main processing -------------------------------+
046800200529      ** ¦                                                            ¦
046900200529      ** ¦ Initial processing is performed automatically.             ¦
047000200529      ** ¦ *INZSR is executed at program activation.                  ¦
047100200529      ** ¦                                                            ¦
047200200529      ** +------------------------------------------------------------+
047300200529      *
047400200529      *****************************************************************
047500200529      * MAIN PROCEDURE                                                *
047600200529      *****************************************************************
047700200529      *
047800200529      /COPY WNCPYSRC,SESEDEC003
047900200529      *
048000200529      ** Incoming transaction is in 500A fields, so that a common
048100200529      ** CLP can be used between this module and the one that
048200200529      ** read the MQ queue.  Break the 500A data by loading
048300200529      ** them into the appropriate (externally-described)
048400200529      ** data structures.
048500200529      *
048600200529     C                   MOVEL     PTrans5001    NwDE1ScnFmt
048700200529     C                   MOVEL     PExtData500   PExtData
048800200529      *
048900200529      ** Generate a timestamp for this transaction.
049000200529      *
049100200529     C                   CALLB     'ZAGENTMSTM'
049200200529     C                   PARM                    PTimestamp
049300200529      *
049400200529      ** Reset fields.
049500200529      *
049600200529     C                   EXSR      SRResetFld
049700200529      *
049800200529      /COPY WNCPYSRC,SESEDEC004
049900200529      *
050000200529      ** Check if valid security diary events exists for front office Id
050100200529      ** in the valid records file.
050200200529      *
050300200529     C                   EXSR      SRChkValTran
050400200529      *
050500200529      ** If valid security diary events does exist even after delay,
050600200529      ** fail this input.
050700200529      *
050800200529     C                   IF        IDx <> 0
050900200529     C                   GOTO      INVALID
051000200529     C                   ENDIF
051100200529      *
051200200529      ** Check if valid security diary event exist for security shortname,
051300200529      ** event date and event type.
051400200529      *
051500200529     C                   EXSR      SRChkValMTran
051600200529      *
051700200529      ** If valid security diary event does exist even after delay,
051800200529      ** fail this input.
051900200529      *
052000200529     C                   IF        IDx <> 0
052100200529     C                   GOTO      INVALID
052200200529     C                   ENDIF
052300200529      *
052400200529      ** Reset fields again in case the details have been corrupted
052500200529      ** by previous chain to valid security diary event file.
052600200529      *
052700200529     C                   EXSR      SRResetFld
052800200529      *
052900200529      /COPY WNCPYSRC,SESEDEC005
053000200529      *
053100200529      ** Validate action code versus the security shortname, event date
053200200529      ** and event type supplied. Original security diary events details
053300200529      ** are retrieved during the validation process.
053400200529      *
053500200529     C                   EXSR      SRValAction
053600200529      *
053700200529      /COPY WNCPYSRC,SESEDEC006
053800200529      *
053900200529      ** If errors occurred in the initial validation, fail this input.
054000200529      *
054100200529     C                   IF        IDx <> 0
054200200529     C                   GOTO      INVALID
054300200529     C                   ENDIF
054400200529      *
054500200529      ** Processing depends upon action code.
054600200529      *
054700200529     C                   SELECT
054800200529      *
054900200529      ** Insert
055000200529      ** ======
055100200529      *
055200200529     C                   WHEN      DDACTN = 'I'
055300200529      *
055400200529      /COPY WNCPYSRC,SESEDEC007
055500200529      *
055600200529      ** Validate incoming Security Diary Event details.
055700200529      *
055800200529     C                   EXSR      SRValDetails
055900200529      *
056000200529      /COPY WNCPYSRC,SESEDEC008
056100200529      *
056200200529      ** Check if amended fields are amendable.
056300200529      *
056400200529     C                   EXSR      SRValAmend
056500200529      *
056600200529      /COPY WNCPYSRC,SESEDEC009
056700200529      *
056800200529      ** Amend
056900200529      ** =====
057000200529      *
057100200529     C                   WHEN      DDACTN = 'A'
057200200529      *
057300200529      /COPY WNCPYSRC,SESEDEC010
057400200529      *
057500200529      ** Convert original security diary events details from file
057600200529      ** to screen format.
057700200529      *
057800200529     C                   EXSR      SRCvtSeDE
057900200529      *
058000200529      /COPY WNCPYSRC,SESEDEC011
058100200529      *
058200200529      ** Check for the existence of the replacement character; if this is
058300200529      ** used, only the changed data has been sent, and all occurrences of
058400200529      ** the replacement character must be replaced with the corresponding
058500200529      ** character from the original transaction.
058600200529      *
058700200529     C                   IF        GHSUBS <> *BLANK
058800200529
058900200529     C     GHSUBS        SCAN      NwDE1ScnFmt                            99
059000200529     C                   IF        *IN99
059100200529     C                   MOVE      'Y'           WSubDE1
059200200529     C                   ELSE
059300200529     C                   MOVE      'N'           WSubDE1
059400200529     C                   ENDIF
059500200529      *
059600200529      ** Do data substitution.
059700200529      *
059800200529     C                   IF        WSubDE1 = 'Y'
059900200529     C                   EXSR      SRDtaSubs
060000200529     C                   ENDIF
060100200529
060200200529     C                   ENDIF
060300200529      *
060400200529      /COPY WNCPYSRC,SESEDEC012
060500200529      *
060600200529      ** Validate incoming Security Diary Event details.
060700200529      *
060800200529     C                   EXSR      SRValDetails
060900200529      *
061000200529      /COPY WNCPYSRC,SESEDEC013
061100200529      *
061200200529      ** Check if amended fields are amendable.
061300200529      *
061400200529     C                   EXSR      SRValAmend
061500200529      *
061600200529      /COPY WNCPYSRC,SESEDEC014
061700200529      *
061800200529     C                   ENDSL
061900200529      *
062000200529     C     INVALID       TAG
062100200529      *
062200200529      ** Check for exception error from any program lower in the stack.
062300200529      ** If error detected, send message to system operator and
062400200529      ** return to calling program without updating database or
062500200529      ** prompting the database update program.
062600200529      *
062700200529     C                   IN        APDUMP
062800200529      *
062900200529      /COPY WNCPYSRC,SESEDEC015
063000200529      *
063100200529     C                   IF        ARErrMod <> *BLANK
063200200529
063300200529     C                   EVAL      PMQErrLong = *BLANK
063400200529     C                   MOVEL     WProcErr      WMQError
063500200529     C                   MOVE      ARErrMod      WMQError
063600200529     C                   MOVEL     WMQError      PMQErrLong
063700200529
063800200529     C                   CALLB     'ZAMSGTOOPR'
063900200529     C                   PARM                    PMQReturn
064000200529     C                   PARM                    PMQErrLong
064100200529     C                   PARM                    PDummyMsgId
064200200529     C                   PARM                    PDummyMsgF
064300200529
064400200529     C                   MOVEL     ARErrMod      APRetCode
064500200529     C     *LOCK         IN        APDUMP
064600200529     C                   EVAL      ARErrMod = *BLANK
064700200529     C                   OUT       APDUMP
064800200529     C                   RETURN
064900200529
065000200529     C                   ELSE
065100200529      *
065200200529      ** Processing for error checking/write to database.
065300200529      *
065400200529      /COPY WNCPYSRC,SESEDEC016
065500200529
065600200529     C                   EXSR      SRCheckWrite
065700200529
065800200529      /COPY WNCPYSRC,SESEDEC017
065900200529      *
066000200529      ** If valid, send data queue entry to prompt DB update program.
066100200529      *
066200200529     C                   IF        IDx = 0
066300200529     C                   EVAL      PObjType = '*DTAARA'
066400200529      *
066500200529      ** Check if update program active using Allocate Object API.
066600200529      ** No prompting necessary if program is running.
066700200529      *
066800200529     C                   CALLB     'APCALCOBJ'
066900200529     C                   PARM                    PObject
067000200529     C                   PARM                    PLib
067100200529     C                   PARM                    PObjType
067200200529     C                   PARM                    PLockState
067300200529     C                   PARM                    PMember
067400200529     C                   PARM                    PWaitTime
067500200529     C                   PARM                    PDlcObj
067600200529     C                   PARM      *BLANK        PReturn
067700200529
067800200529     C                   IF        PReturn = *BLANK
067900200529      *
068000200529      ** Check if any messages are already on the data queue.
068100200529      ** No need to send duplicate prompt messages.
068200200529      *
068300200529      ** The following /COPY line includes a check for whether there
068400200529      ** are messages on the server/updater data queue, and sends a 'GO'
068500200529      ** message to the data queue if there are not.
068600200529      *
068700200529      /COPY ZACPYSRC,DTAQCHK
068800200529
068900200529     C                   ENDIF
069000200529
069100200529     C                   ENDIF
069200200529
069300200529     C                   ENDIF
069400200529
069500200529     C                   RETURN
069600200529      *
069700200529      *****************************************************************
069800200529      /EJECT
069900200529      *****************************************************************
070000200529      *
070100200529      ** Hook to enable non-core subroutines to be included
070200200529      *
070300200529      /COPY WNCPYSRC,SESEDEC018
070400200529      *
070500200529      *****************************************************************
070600200529      /EJECT
070700200529      *****************************************************************
070800200529      *                                                               *
070900200529      *  SRChkValTran - Routine to check if valid security diary      *
071000200529      *                 events exist for Front Office Id in the       *
071100200529      *                 valid security diary events file.             *
071200200529      *                                                               *
071300200529      *****************************************************************
071400200529      *
071500200529     C     SRChkValTran  BEGSR
071600200529      *
071700200529      ** Check for front office Id in the valid records file.
071800200529      ** Run delay program if record found.
071900200529      *
072000200529     C     APFOTRANID    CHAIN     SEVSEDEL0                          01
072100200529
072200200529     C                   IF        RecNotFnd = False
072300200529      *
072400200529      ** Run delay program, then repeat chain.
072500200529     C                   CALLB     'ZACDELAY'
072600200529
072700200529     C     APFOTRANID    CHAIN     SEVSEDEL0                          01
072800200529      *
072900200529      ** Error if front office Id is still present.
073000200529     C                   IF        RecNotFnd = False
073100200529     C                   ADD       1             IDx
073200200529     C                   EVAL      FldNameArr(IDx) = 'DDSDSN'
073300200529     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
073400200529     C                   ENDIF
073500200529
073600200529     C                   ENDIF
073700200529
073800200529     C                   ENDSR
073900200529      *
074000200529      *****************************************************************
074100200529      /EJECT
074200200529      *****************************************************************
074300200529      *                                                               *
074400200529      *  SRChkValMTran - Routine to check if valid security diary     *
074500200529      *                  events exist for security shortname, event   *
074600200529      *                  date and event type in the valid security    *
074700200529      *                  diary events file.                           *
074800200529      *                                                               *
074900200529      *****************************************************************
075000200529      *
075100200529     C     SRChkValMTran BEGSR
075200200529      *
075300200529      ** Convert event date into numeric format.
075400200529      *
075500200529     C                   IF        DDSDED <> '999999'
075600200529     C                   EVAL      PDateIn = DDSDED
075700200529     C                   CALLB     'ZDATE1'
075800200529     C                   PARM                    PDateIn
075900200529     C                   PARM      *ZERO         PDaynoOut
076000200529     C                   PARM                    BJDFIN
076100200529     C                   PARM      *BLANK        PErrorFlag
076200200529
076300200529     C                   Z-ADD     PDaynoOut     WEvtDno
076400200529
076500200529     C                   ELSE
076600200529     C                   Z-ADD     99999         WEvtDno
076700200529     C                   ENDIF
076800200529      *
076900200529      ** Check for midas security shortname, event date and event type
077000200529      ** in the valid record file. Run delay program if record found.
077100200529      *
077200200529     C     KDEVKA        CHAIN     SEVSEDEL1                          01
077300200529
077400200529     C                   IF        RecNotFnd = False
077500200529      *
077600200529      ** Run delay program, then repeat chain.
077700200529     C                   CALLB     'ZACDELAY'
077800200529
077900200529     C     KDEVKA        CHAIN     SEVSEDEL1                          01
078000200529      *
078100200529      ** Error if midas back office reference is still present.
078200200529     C                   IF        RecNotFnd = False
078300200529     C                   ADD       1             IDx
078400200529     C                   EVAL      FldNameArr(IDx) = 'DDSDSN'
078500200529     C                   EVAL      MsgIDArr(IDx) = 'APM0900'
078600200529     C                   ENDIF
078700200529
078800200529     C                   ENDIF
078900200529
079000200529     C                   ENDSR
079100200529      *
079200200529      *****************************************************************
079300200529      /EJECT
079400200529      *****************************************************************
079500200529      *                                                               *
079600200529      *  SRValAction - Routine to validate Action Code for the        *
079700200529      *                security shortname, event date and event type  *
079800200529      *                supplied                                       *
079900200529      *              - Original Security Diary Events details are     *
080000200529      *                retrieve during the validation process         *
080100200529      *                                                               *
080200200529      *****************************************************************
080300200529     C     SRValAction   BEGSR
080400200529      *
080500200529      ** If insert, set retrieve mode to '*FRONT' (Access using Front
080600200529      ** Office Id).  Otherwise, if not insert and midas security shortname,
080700200529      ** event date or event type is present, set retrive mode to blank
080800200529      ** (Access using Midas Security shortname).
080900200529      *
081000200529     C                   IF        DDACTN = 'I'
081100200529     C                   EVAL      PMode = '*FRONT'
081200200529     C                   ELSE
081300200529
081400200529     C                   IF        DDSDSN = *BLANK
081500200529     C                             AND DDSDED = *BLANK
081600200529     C                             AND DDSDET = *BLANK
081700200529     C                   EVAL      PMode = '*FRONT'
081800200529     C                   ELSE
081900200529     C                   EVAL      PMode = *BLANKS
082000200529     C                   ENDIF
082100200529
082200200529     C                   ENDIF
082300200529                                                                                              CSC011
082400200529     C                   EVAL      WRDAY = BJRDNB                                             CSC011
082500200529                                                                                              CSC011
082600200529      ** If CSC011 is present and CTL is still running in the support                         CSC011
082700200529      ** system, set the rundate to processing date in dtaara SC24X7,                         CSC011
082800200529      ** to be used by RTV module.                                                            CSC011
082900200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
083000200529     C                   EVAL      WRDAY = S1DATE                                             CSC011
083100200529     C                   ENDIF                                                                CSC011
083200200529
083300200529     C                   CALLB     'SESEDERTV'
083400200529      *                             =========
083500200529      ** INPUT
083600200529      ** =====
083700200529      *
083800200529      ** Retun Code
083900200529     C                   PARM      *BLANKS       RetCodeOut
084000200529      *
084100200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
084200200529      ** Mode = '      ' (Not Front Office Transaction Interface)
084300200529      ** Mode = '*RPR  ' (Repair function)
084400200529      ** Mode = '*SIN  ' (Screen input function)
084500200529     C                   PARM                    PMode
084600200529      *
084700200529      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
084800200529     C                   PARM                    APRESPMODE
084900200529      *
085000200529      ** Action Code
085100200529     C                   PARM                    DDACTN
085200200529      *
085300200529      ** Front office transaction identifier (20A from caller)
085400200529     C                   PARM                    APFOTRANID
085500200529      *
085600200529      ** Security Shortname
085700200529     C                   PARM                    DDSDSN
085800200529      *
085900200529      ** Event Date
086000200529     C                   PARM                    DDSDED
086100200529      *
086200200529      ** Event Type
086300200529     C                   PARM                    DDSDET
086400200529      *
086500200529      ** STANDING DATA
086600200529      ** =============
086700200529      *
086800200529      ** SDBANK - Single Branch Code
086900200529     C                   PARM                    BJSBRC
087000200529      *
087100200529      ** SDBANK - Run day number
087200200529     C**********         PARM                    BJRDNB                                       CSC011
087300200529     C                   PARM                    WRDAY                                        CSC011
087400200529      *
087500200529      ** SDBANK - Date format indicator
087600200529     C                   PARM                    BJDFIN
087700200529      *
087800200529      ** SDSTRD - Back value period
087900200529     C                   PARM                    BVBVP
088000200529      *
088100200529      ** ZMUSER - Default Branch
088200200529     C                   PARM                    PDBRN
088300200529      *
088400200529      ** SWITCHABLE FEATURES
088500200529      ** ===================
088600200529      *
088700200529      ** SE Transaction Enhancement
088800200529     C                   PARM                    CSE010
088900200529      *
089000200529      ** value Ccy to be Ccy of Issuer Payment
089100200529     C                   PARM                    S01509
089200200529      *                                                                                       CSE031
089300200529      ** Coupon Fixing for Floating Rate Notes                                                CSE031
089400200529     C                   PARM                    CSE031                                       CSE031
089500200529                                                                                              CSE065
089600200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
089700200529     C                   PARM                    CSE065                                       CSE065
089800200529      *
089900200529      ** OUTPUT
090000200529      ** ======
090100200529      *
090200200529      ** Error fields/message IDs/message data (arrays) from/to caller
090300200529     C                   PARM                    FldNameArr
090400200529     C                   PARM                    MsgIdArr
090500200529     C                   PARM                    MsgDtaArr
090600200529      *
090700200529      ** Array index (3P0) from/to caller
090800200529     C                   PARM                    IDx
090900200529      *
091000200529      ** Warning fields/message IDs/message data (arrays) from/to caller
091100200529     C                   PARM                    WFldNamArr
091200200529     C                   PARM                    WMsgIDArr
091300200529     C                   PARM                    WMsgDtaArr
091400200529      *
091500200529      ** Array index (3P0) from/to caller
091600200529     C                   PARM                    WIdx
091700200529      *
091800200529      ** OK Action Code
091900200529     C                   PARM                    OKACTN
092000200529      *
092100200529      ** OK Security Shortname
092200200529     C                   PARM                    OKSDSN
092300200529      *
092400200529      ** OK Event Date
092500200529     C                   PARM                    OKSDED
092600200529      *
092700200529      ** OK Event Type
092800200529     C                   PARM                    OKSDET
092900200529      *
093000200529      ** Security Diary Events retrieved from file - file format
093100200529     C                   PARM                    CrDEFilFmt
093200200529      *
093300200529      ** Externally described DS for security details
093400200529     C                   PARM                    PSectyd
093500200529      *
093600200529      ** Processing type from PF/INVTPD
093700200529     C                   PARM                    PPROT
093800200529      *
093900200529      ** Event date (Day Number)
094000200529     C                   PARM                    PEvtDno
094100200529      *
094200200529      ** Redisplay screen
094300200529     C                   PARM      *BLANK        PReDsp
094400200529      *
094500200529      ** For the rest of the processing, set Mode of Operation
094600200529      ** to '*FRONT' for the other modules to process the
094700200529      ** transaction as coming from an external system.
094800200529      *
094900200529     C                   MOVEL     '*FRONT'      PMode
095000200529
095100200529     C                   ENDSR
095200200529      *
095300200529      *****************************************************************
095400200529      /EJECT
095500200529      *****************************************************************
095600200529      *                                                               *
095700200529      *  SRValDetails - Routine to validate Security Diary Events Det.*
095800200529      *               - Amended file fields (for update) are set up   *
095900200529      *                 during the validation process                 *
096000200529      *                                                               *
096100200529      *****************************************************************
096200200529     C     SRValDetails  BEGSR
096300200529      *
096400200529      ** Move Security Diary Event details retrieved from the midas
096500200529      ** database file into the update file record.  If no
096600200529      ** record has been retrieved (i.e. in Insert), fields
096700200529      ** contain initial values (zeros, blanks).
096800200529      *
096900200529     C**********         MOVEL     CrDEFilFmt    NwDEFilFmt                                   CSE065
097000200529     C                   MOVEL     CrDEFilFmt1   NwDEFilFmt1                                  CSE065
097100200529      *                                                                                       CSE065
097200200529     C                   IF        CSE065 = 'Y'                                               CSE065
097300200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
097400200529     C                   ELSE                                                                 CSE065
097500200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
097600200529     C                   ENDIF                                                                CSE065
097700200529      *
097800200529      ** Setup defaults on screen 1.
097900200529      *
098000200529     C                   EXSR      SRDefault1
098100200529      *
098200200529      ** Validate screen 1 details.
098300200529      *
098400200529     C                   EXSR      SRVScrn1
098500200529
098600200529     C     EValDetails   ENDSR
098700200529      *
098800200529      *****************************************************************
098900200529      /EJECT
099000200529      *****************************************************************
099100200529      *                                                               *
099200200529      *  SRDefault1 - Defaulting for screen 1                         *
099300200529      *                                                               *
099400200529      *****************************************************************
099500200529     C     SRDefault1    BEGSR
099600200529
099700200529     C                   CALLB     'SESEDE1DT'
099800200529      *
099900200529      ** INPUT
100000200529      ** =====
100100200529      *
100200200529      ** Return code
100300200529     C                   PARM      *BLANKS       RetCodeOut
100400200529      *
100500200529      ** SE Diary events retrieved from file - file format
100600200529     C                   PARM                    CrDEFilFmt
100700200529      *
100800200529      ** Externally described DS for security details
100900200529     C                   PARM                    PSectyd
101000200529      *
101100200529      ** Event date (Day Number)
101200200529     C                   PARM                    PEvtDno
101300200529      *
101400200529      ** STANDING DATA
101500200529      ** =============
101600200529      *
101700200529      ** SDBANK - Date format indicator
101800200529     C                   PARM                    BJDFIN
101900200529      *
102000200529      ** MMODF - Strategic risk management indicator
102100200529     C                   PARM                    RMFL
102200200529      *
102300200529      ** SWITCHABLE FEATURES
102400200529      ** ===================
102500200529      *
102600200529      ** Dividend payments
102700200529     C                   PARM                    S01510
102800200529      *
102900200529      ** Value currency to be currency of issuer payments
103000200529     C                   PARM                    S01509
103100200529                                                                                              CSE065
103200200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
103300200529     C                   PARM                    CSE065                                       CSE065
103400200529                                                                                              CSE065
103500200529      *                                                                                       CGL031
103600200529      ** Taxation on Savings Income                                                           CGL031
103700200529     C                   PARM                    CGL031                                       CGL031
103800200529      *                                                                                       CGL031
103900200529      *
104000200529      ** OUTPUT
104100200529      ** ======
104200200529      *
104300200529      ** SE Diary events screen details from incoming transaction
104400200529      ** - screen format
104500200529     C                   PARM                    NwDE1ScnFmt
104600200529      *
104700200529      ** Pay currency
104800200529     C                   PARM                    PPayCcy
104900200529      *
105000200529      ** Cumulative coupon rate
105100200529     C                   PARM                    DDCUCR
105200200529      *
105300200529      ** Current exchange rate
105400200529     C                   PARM                    DDSEXR
105500200529
105600200529     C                   ENDSR
105700200529      *
105800200529      *****************************************************************
105900200529      /EJECT
106000200529      *****************************************************************
106100200529      *                                                               *
106200200529      *  SRVScrn1  - Validate screen 1 details                        *
106300200529      *                                                               *
106400200529      *****************************************************************
106500200529     C     SRVScrn1      BEGSR
106600200529
106700200529     C                   CALLB     'SESEDE1VL'
106800200529      *
106900200529      ** INPUT
107000200529      ** =====
107100200529      *
107200200529      ** Return Code
107300200529     C                   PARM      *BLANKS       RetCodeOut
107400200529      *
107500200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
107600200529      ** Mode = '      ' (Not Front Office Transaction Interface)
107700200529      ** Mode = '*RPR  ' (Repair function)
107800200529      ** Mode = '*SIN  ' (Screen Input function)
107900200529     C                   PARM                    PMode
108000200529      *
108100200529      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
108200200529     C                   PARM                    APRESPMODE
108300200529      *
108400200529      ** SE Diary Events screen details from incoming
108500200529      ** transaction - screen format
108600200529     C                   PARM                    NwDE1ScnFmt
108700200529      *
108800200529      ** Security Diary Events retrieved from file - file format
108900200529     C                   PARM                    CrDEFilFmt
109000200529      *
109100200529      ** Externally described DS for security details
109200200529     C                   PARM                    PSectyd
109300200529      *
109400200529      ** Processing type from PF/INVTPD
109500200529     C                   PARM                    PPROT
109600200529      *
109700200529      ** Event date (Day Number)
109800200529     C                   PARM                    PEvtDno
109900200529      *
110000200529      ** STANDING DATA
110100200529      ** =============
110200200529      *
110300200529      ** SDBANK - Date Format Indicator
110400200529     C                   PARM                    BJDFIN
110500200529      *
110600200529      ** MMODF - Strategic risk management indicator
110700200529     C                   PARM                    RMFL
110800200529      *
110900200529      ** SWITCHABLE FEATURES
111000200529      ** ===================
111100200529      *
111200200529      ** SE Transactions Enhancement
111300200529     C                   PARM                    CSE010
111400200529      *
111500200529      ** Value CCY to be CCY of Issuer Payment
111600200529     C                   PARM                    S01509
111700200529      *
111800200529      ** Dividend Payments Base on EX-Date
111900200529     C                   PARM                    S01510
112000200529                                                                                              CAS006
112100200529      ** Hedge Accounting Phase B                                                             CAS006
112200200529     C                   PARM                    CAS006                                       CAS006
112300200529                                                                                              CSE072
112400200529      ** Brazilian C Bonds                                                                    CSE072
112500200529     C                   PARM                    CSE072                                       CSE072
112600200529                                                                                              CSE065
112700200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
112800200529     C                   PARM                    CSE065                                       CSE065
112900200529                                                                                              CGL031
113000200529      ** Taxation on Savings Income                                                           CGL031
113100200529                                                                                              CGL031
113200200529     C                   PARM                    CGL031                                       CGL031
113300200529      *
113400200529      ** OUTPUT
113500200529      ** ======
113600200529      *
113700200529      ** Error fields/message IDs/message data (arrays) from/to caller
113800200529     C                   PARM                    FldNameArr
113900200529     C                   PARM                    MsgIdArr
114000200529     C                   PARM                    MsgDtaArr
114100200529      *
114200200529      ** Array index (3P0) from/to caller
114300200529     C                   PARM                    IDx
114400200529      *
114500200529      ** Warning flds/message IDs/message data (arrays) from/to caller
114600200529     C                   PARM                    WFldNamArr
114700200529     C                   PARM                    WMsgIdArr
114800200529     C                   PARM                    WMsgDtaArr
114900200529      *
115000200529      ** Array index (3P0) from/to caller
115100200529     C                   PARM                    WIDx
115200200529      *
115300200529      ** SE Diary Events screen error indicators
115400200529     C                   PARM                    SEESEDE
115500200529      *
115600200529      ** SE Diary Events for file update - file format
115700200529     C                   PARM                    NwDEFilFmt
115800200529      *
115900200529      ** Redisplay screen
116000200529     C                   PARM      *BLANK        PReDsp
116100200529
116200200529     C                   ENDSR
116300200529      *
116400200529      *****************************************************************
116500200529      /EJECT
116600200529      *****************************************************************
116700200529      *                                                               *
116800200529      *  SRCvtSeDE - Convert security diary events details from file  *
116900200529      *              to screen format                                 *
117000200529      *                                                               *
117100200529      *****************************************************************
117200200529     C     SRCvtSeDE     BEGSR
117300200529
117400200529     C                   CALLB     'SESEDECVT'
117500200529      *                             =========
117600200529      ** INPUT
117700200529      ** =====
117800200529      *
117900200529      ** Return code
118000200529     C                   PARM      *BLANKS       RetCodeOut
118100200529      *
118200200529      ** SE Diary events retrieved from file - file format
118300200529     C                   PARM                    CrDEFilFmt
118400200529      *
118500200529      ** Externally described DS for security details
118600200529     C                   PARM                    PSectyd
118700200529      *
118800200529      ** Processing type from PF/INVTPD
118900200529     C                   PARM                    PPROT
119000200529      *
119100200529      ** Action code
119200200529     C                   PARM                    DDACTN
119300200529      *
119400200529      ** STANDING DATA
119500200529      ** =============
119600200529      *
119700200529      ** SDBANK - Date format indicator
119800200529     C                   PARM                    BJDFIN
119900200529      *
120000200529      ** MMODF - Strategic risk management indicator
120100200529     C                   PARM                    RMFL
120200200529      *
120300200529      ** SWITCHABLE FEATURES
120400200529      ** ===================
120500200529      *
120600200529      ** Value currency to be currency of issuer payments
120700200529     C                   PARM                    S01509
120800200529      *
120900200529      ** Dividend payments
121000200529     C                   PARM                    S01510
121100200529                                                                                              CAS006
121200200529      ** Hedge Accounting Phase B                                                             CAS006
121300200529     C                   PARM                    CAS006                                       CAS006
121400200529                                                                                              CSE065
121500200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
121600200529     C                   PARM                    CSE065                                       CSE065
121700200529                                                                                              CSE065
121800200529                                                                                              CGL031
121900200529      ** Taxation on Savings Income                                                           CGL031
122000200529                                                                                              CGL031
122100200529     C                   PARM                    CGL031                                       CGL031
122200200529      *
122300200529      ** OUTPUT
122400200529      ** ======
122500200529      *
122600200529      ** SE Diary events screen details from incoming transaction
122700200529      ** - screen format
122800200529     C                   PARM                    CrDE1ScnFmt
122900200529
123000200529     C                   ENDSR
123100200529      *
123200200529      *****************************************************************
123300200529      /EJECT
123400200529      *****************************************************************
123500200529      *                                                               *
123600200529      *  SRDtaSubs - Data Substitution Routine                        *
123700200529      *                                                               *
123800200529      *****************************************************************
123900200529      *
124000200529     C     SRDtaSubs     BEGSR
124100200529      *
124200200529      ** Substitute the data for the various parts of the transaction.
124300200529      *
124400200529     C                   IF        WSUBDE1 = 'Y'
124500200529     C                   CLEAR                   PIncData
124600200529     C                   CLEAR                   PCurData
124700200529
124800200529     C                   CALLB     'APDTASUBS'
124900200529      *                             =========
125000200529      ** Return code
125100200529     C                   PARM      *BLANKS       RetCodeOut
125200200529      *
125300200529      ** Substitution character
125400200529     C                   PARM                    GHSUBS
125500200529      *
125600200529      ** Incoming data
125700200529     C                   PARM      NwDE1ScnFmt   PIncData
125800200529      *
125900200529      ** Current data
126000200529     C                   PARM      CrDE1ScnFmt   PCurData
126100200529
126200200529     C                   MOVEL     PIncData      NwDE1ScnFmt
126300200529     C                   ENDIF
126400200529
126500200529     C                   ENDSR
126600200529      *
126700200529      *****************************************************************
126800200529      /EJECT
126900200529      *****************************************************************
127000200529      *                                                               *
127100200529      *  SRValAmend - Routine to check whether the fields are         *
127200200529      *               amendable                                       *
127300200529      *             - This subroutine calls a procedure which checks  *
127400200529      *               whether it is valid to amend the fields which   *
127500200529      *               have been altered.  To determine what fields    *
127600200529      *               have been changed, the current fields on file   *
127700200529      *               must be converted first to their screen formats.*
127800200529      *               These fields are then compared with the fields  *
127900200529      *               on the input transaction.  Any errors detected  *
128000200529      *               by the called procedure take precedence over    *
128100200529      *               any errors found during the validation of the   *
128200200529      *               transaction.  The errors from the called        *
128300200529      *               procedure are kept separately and if any are    *
128400200529      *               found, these errors will REPLACE the normal     *
128500200529      *               validation errors.                              *
128600200529      *                                                               *
128700200529      *****************************************************************
128800200529     C     SRValAmend    BEGSR
128900200529
129000200529     C                   CALLB     'SESEDE1MD'
129100200529      *
129200200529      ** INPUT
129300200529      ** =====
129400200529      *
129500200529      ** Return code
129600200529     C                   PARM      *BLANKS       RetCodeOut
129700200529      *
129800200529      ** SE Diary events screen details from incoming transaction
129900200529      ** - screen format
130000200529     C                   PARM                    NwDE1ScnFmt
130100200529      *
130200200529      ** SE Diary events screen details retrieved from file
130300200529      ** - screen format
130400200529     C                   PARM                    CrDE1ScnFmt
130500200529      *
130600200529      ** SE Diary events retrieved from file - file format
130700200529     C                   PARM                    CrDEFilFmt
130800200529      *
130900200529      ** Reset of fields in error required (Y/N)
131000200529     C                   PARM      'N'           PResetFld
131100200529      *
131200200529      ** Pay currency
131300200529     C                   PARM                    PPayCcy
131400200529      *
131500200529      ** STANDING DATA
131600200529      ** =============
131700200529      *
131800200529      ** MMODF - Strategic risk management indicator
131900200529     C                   PARM                    RMFL
132000200529      *
132100200529      ** SWITCHABLE FEATURES
132200200529      ** ===================
132300200529      *
132400200529      ** Value currency to be currency of issuer payments
132500200529     C                   PARM                    S01509
132600200529      *
132700200529      ** Dividend payments
132800200529     C                   PARM                    S01510
132900200529                                                                                              CAS006
133000200529      ** Hedge Accounting Phase B                                                             CAS006
133100200529     C                   PARM                    CAS006                                       CAS006
133200200529      *
133300200529      ** OUTPUT
133400200529      ** ======
133500200529      *
133600200529      ** Error fields/message Ids/message data (arrays) from/to caller
133700200529     C                   PARM                    AMFldNamAr
133800200529     C                   PARM                    AMMsgIdArr
133900200529     C                   PARM                    AMMsgDtaAr
134000200529      *
134100200529      ** Array index (3P0) from/to caller
134200200529     C                   PARM                    AMIDx
134300200529      *
134400200529      ** SE Diary events screen error indicators
134500200529     C                   PARM                    SEESEDE
134600200529      *
134700200529      ** OK Amendments field
134800200529     C                   PARM                    PAmendOK
134900200529      *
135000200529      ** If errors occurred, overwrite previous error information.
135100200529      *
135200200529     C                   IF        AMIDx <> 0
135300200529     C                   MOVEA     AMFldNamAr    FldNameArr
135400200529     C                   MOVEA     AMMsgIdArr    MsgIdArr
135500200529     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
135600200529     C                   Z-ADD     AMIDx         IDx
135700200529     C                   ENDIF
135800200529      *
135900200529     C                   ENDSR
136000200529      *
136100200529      *****************************************************************
136200200529      /EJECT
136300200529      *****************************************************************
136400200529      *                                                               *
136500200529      *  SRCheckWrite - Routine to control checking of error status   *
136600200529      *                 and sending of messages/writing to the        *
136700200529      *                 database                                      *
136800200529      *                                                               *
136900200529      *****************************************************************
137000200529      *
137100200529     C     SRCheckWrite  BEGSR
137200200529      *
137300200529      ** If no errors were found:
137400200529      ** - set up additional data
137500200529      ** - write a record to the Valid Records file
137600200529      ** - use std message handler to report transaction status
137700200529      ** If any errors were found:
137800200529      ** - set up additional data
137900200529      ** - write a record to the Invalid Records file
138000200529      ** - call the message handler to pass the errors back
138100200529      ** - use std message handler to report transaction status
138200200529      ** The index to the error arrays is checked for presence/absence of
138300200529      ** errors.
138400200529      *
138500200529      ** +--- Note for a later release -------------------------------+
138600200529      ** |                                                            |
138700200529      ** | At a later date, this routine will have to cater for       |
138800200529      ** | warning messages.  The following logic will have to be     |
138900200529      ** | inserted before "If no errors were found", in the          |
139000200529      ** | above comments (and the code):                             |
139100200529      ** |                                                            |
139200200529      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
139300200529      ** | any warning messages were returned (WIDx <> 0)             |
139400200529      ** |                                                            |
139500200529      ** | -   If errors exist                                        |
139600200529      ** |     -     Add the warning array index to the error array   |
139700200529      ** |           index                                            |
139800200529      ** |     -     Append the contents of the warning arrays to the |
139900200529      ** |           end of the error arrays                          |
140000200529      ** | -   Else                                                   |
140100200529      ** |     -     Set the error array index equal to the warning   |
140200200529      ** |           array index                                      |
140300200529      ** |     -     Copy the contents of the warning arrays to the   |
140400200529      ** |           error arrays                                     |
140500200529      ** | -   Endif                                                  |
140600200529      ** |                                                            |
140700200529      ** | Endif                                                      |
140800200529      ** |                                                            |
140900200529      ** | Note that the "If errors exist ... Else ... " block above  |
141000200529      ** | can probably be implemented unconditionally (i.e. the same |
141100200529      ** | logic will apply whether errors exist as well as warnings  |
141200200529      ** | or not).  It is shown in the above form for clarity.       |
141300200529      ** |                                                            |
141400200529      ** +------------------------------------------------------------+
141500200529      *
141600200529     C     IDx           IFEQ      0
141700200529     C                   EXSR      SRSetValid
141800200529     C                   WRITE     SEVSEDED0
141900200529     C                   EXSR      SRMsgHdl
142000200529     C                   ENDIF
142100200529
142200200529     C     IDx           IFGT      0
142300200529     C                   EXSR      SRSetInvalid
142400200529      *
142500200529      ** Only write to invalid file if repair in back office.
142600200529     C     APRPRLOCN     IFEQ      'B'
142700200529     C                   WRITE     SEISEDED0
142800200529                                                                                              CSC011
142900200529      ** If CSC011 is present and CTL is still running in the support                         CSC011
143000200529      ** system, write invalid details to support log file                                    CSC011
143100200529                                                                                              CSC011
143200200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
143300200529     C                   EXSR      SRWriteLog                                                 CSC011
143400200529     C                   ENDIF                                                                CSC011
143500200529                                                                                              CSC011
143600200529     C                   ENDIF
143700200529
143800200529     C                   EXSR      SRMsgHdl
143900200529     C                   ENDIF
144000200529
144100200529     C                   If        (CSC022 = 'N')                                            BUG2604
144200200529     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
144300200529     C                   COMMIT
144400200529     C                   EndIf                                                               BUG2604
144500200529
144600200529     C                   ENDSR
144700200529      *
144800200529      *****************************************************************
144900200529      /EJECT
145000200529      *****************************************************************
145100200529      *                                                               *
145200200529      *  SRSetValid - Routine to set up fields in the valid file      *
145300200529      *               record.                                         *
145400200529      *                                                               *
145500200529      *****************************************************************
145600200529      *
145700200529     C     SRSetValid    BEGSR
145800200529      *
145900200529      ** Action is delete.
146000200529      ** =================
146100200529      *
146200200529     C                   IF        DDACTN = 'D'
146300200529      *
146400200529      ** Move security diary events details retrieved from file
146500200529      ** directly to the valid record data structure.
146600200529      *
146700200529     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
146800200529     C                   EVAL      NwDEFilFmt1 = CrDEFilFmt1                                  CSE065
146900200529      *                                                                                      260191A
147000200529      ** If Record Id is 'D', reset SDDT to zero                                             260191A
147100200529      *                                                                                      260191A
147200200529     C                   IF        S2RECI = 'D'                                              260191A
147300200529     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                            260191A
147400200529     C                               OR S2SDET = 'PP'                                        260191A
147500200529     C                   Z-ADD     0             S2SDDT                                      260191A
147600200529     C                   ENDIF                                                               260191A
147700200529      *                                                                                      260191A
147800200529     C                   ELSE                                                                260191A
147900200529     C                   IF        S2RECI = 'M'                                              260191A
148000200529     C                   MOVE      'N'           NOTALL            1                         260191A
148100200529     C     S2SDSN        SETLL     POSETDF                                                   260191A
148200200529     C     S2SDSN        READE     POSETDF                                02                 260191A
148300200529     C                   DOW       NOT *IN02                                                 260191A
148400200529      *                                                                                      260191A
148500200529     C     S2SDET        IFEQ      'MP'                                                      260191A
148600200529     C     S2SDET        OREQ      'DV'                                                      260191A
148700200529     C     S01512        ANDNE     'Y'                                                       260191A
148800200529     C                   Z-ADD     S2SDPD        WWPDUD            5 0                       260191A
148900200529     C                   ELSE                                                                260191A
149000200529     C                   Z-ADD     S2SDED        WWPDUD                                      260191A
149100200529     C                   ENDIF                                                               260191A
149200200529      *                                                                                      260191A
149300200529     C                   IF        S2SDET = F3PEVT and WWPDUD = F3PDUD                       260191A
149400200529     C                             AND F3RECI = 'M'                                          260191A
149500200529     C                   MOVE      'Y'           NOTALL                                      260191A
149600200529     C                   ENDIF                                                               260191A
149700200529      *                                                                                      260191A
149800200529     C     S2SDSN        READE     POSETDF                                02                 260191A
149900200529     C                   ENDDO                                                               260191A
150000200529      *                                                                                      260191A
150100200529     C                   IF        NOTALL = 'N'                                              260191A
150200200529     C                   Z-ADD     0             S2SDDT                                      260191A
150300200529     C                   ENDIF                                                               260191A
150400200529     C                   ENDIF                                                               260191A
150500200529      *                                                                                      260191A
150600200529     C                   ENDIF                                                               260191A
150700200529      *                                                                                       CSE065
150800200529     C                   IF        CSE065 = 'Y'                                               CSE065
150900200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
151000200529     C                   ELSE                                                                 CSE065
151100200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
151200200529     C                   ENDIF                                                                CSE065
151300200529      *
151400200529      ** Record Id - update to 'C'.
151500200529     C                   EVAL      S2RECI = 'C'
151600200529     C                   ENDIF
151700200529      *
151800200529      ** Action is enquire.
151900200529      ** ==================
152000200529      *
152100200529     C                   IF        DDACTN = 'E'
152200200529      *
152300200529      ** Move security diary events details retrieved from file
152400200529      ** directly to the valid record data structure.
152500200529      *
152600200529     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
152700200529     C                   EVAL      NwDEFilFmt1 = CrDEFilFmt1                                  CSE065
152800200529      *                                                                                       CSE065
152900200529     C                   IF        CSE065 = 'Y'                                               CSE065
153000200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
153100200529     C                   ELSE                                                                 CSE065
153200200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
153300200529     C                   ENDIF                                                                CSE065
153400200529      *                                                                                       CSE065
153500200529     C                   ENDIF
153600200529      *
153700200529      ** Action is insert.
153800200529      ** =================
153900200529      *
154000200529     C                   IF        DDACTN = 'I'
154100200529      *
154200200529      ** Record Id.
154300200529     C                   MOVEL     'D'           S2RECI
154400200529      *
154500200529      ** Nominal currency.
154600200529     C                   MOVEL     D1NMCY        S2NMCY
154700200529      *
154800200529     C                   ENDIF
154900200529      *
155000200529      ** Security shortname
155100200529      *
155200200529     C                   EVAL      S2SDSN = DDSDSN
155300200529      *
155400200529      ** Event Date
155500200529      *
155600200529     C                   EVAL      S2SDED = WEvtDno
155700200529      *
155800200529      ** Event Type
155900200529      *
156000200529     C                   EVAL      S2SDET = DDSDET
156100200529      *
156200200529      ** Last change type
156300200529      *
156400200529     C                   MOVEL     DDACTN        S2CHTP
156500200529      *
156600200529      ** Message header details.
156700200529      *
156800200529     C                   EVAL      S2FRNT = APFOTRANID
156900200529     C                   EVAL      S2REPA = APRPRLOCN
157000200529     C                   EVAL      S2TMST = PTimestamp
157100200529      *
157200200529      ** Master files will be updated.
157300200529      *
157400200529     C                   EVAL      PTranStatus = 'S'
157500200529      *
157600200529      /COPY WNCPYSRC,SESEDEC019
157700200529      *
157800200529     C                   ENDSR
157900200529      *
158000200529      *****************************************************************
158100200529      /EJECT
158200200529      *****************************************************************
158300200529      *                                                               *
158400200529      *  SRSetInvalid - Routine to set up fields in the invalid file  *
158500200529      *                 record.                                       *
158600200529      *                                                               *
158700200529      *****************************************************************
158800200529      *
158900200529     C     SRSetInvalid  BEGSR
159000200529      *
159100200529     C                   EVAL      DDFRNT = APFOTRANID
159200200529     C                   EVAL      DDREPA = APRPRLOCN
159300200529     C                   EVAL      DDTMST = PTimestamp
159400200529      *
159500200529      ** Transaction needs to be repaired.
159600200529      *
159700200529     C                   EVAL      PTranStatus = 'F'
159800200529      *
159900200529      /COPY WNCPYSRC,SESEDEC020
160000200529      *
160100200529     C                   ENDSR
160200200529      *
160300200529      *****************************************************************
160400200529      /EJECT
160500200529      *****************************************************************
160600200529      *                                                               *
160700200529      *  SRMsgHdl - Routine to call the message handling module       *
160800200529      *                                                               *
160900200529      *****************************************************************
161000200529      *
161100200529     C     SRMsgHdl      BEGSR
161200200529      *
161300200529      ** Set up an array of sequence numbers that correspond to the
161400200529      ** fields with errors.
161500200529      *
161600200529     C                   Z-ADD     1             W1
161700200529
161800200529     C                   DO        ArrayMax
161900200529
162000200529     C                   IF        FldNameArr(W1) <> *BLANKS
162100200529     C                   Z-ADD     1             W2
162200200529     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           02
162300200529     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
162400200529     C                   ELSE
162500200529     C                   LEAVE
162600200529     C                   ENDIF
162700200529
162800200529     C                   ADD       1             W1
162900200529
163000200529     C                   ENDDO
163100200529
163200200529     C                   EVAL      PTranID = DDSDSN + DDSDED + DDSDET
163300200529
163400200529     C                   CALLB     'ZAMSGHNDLE'
163500200529      *
163600200529      ** Return code (10A, returned to this procedure)
163700200529     C                   PARM      *BLANK        ReturnCode
163800200529      *
163900200529      ** Repair location (1A, from caller)
164000200529     C                   PARM                    APRPRLOCN
164100200529      *
164200200529      ** Confirm validity to front office (1A, from caller)
164300200529     C                   PARM                    APCNFVALFO
164400200529      *
164500200529      ** List of messages (array of message Ids - from caller)
164600200529     C                   PARM                    MsgIDArr
164700200529      *
164800200529      ** List of field numbers (array of unsigned int. from caller)
164900200529     C                   PARM                    FldNoArr
165000200529      *
165100200529      ** List of field names (array of fields names from caller)
165200200529     C                   PARM                    FldNameArr
165300200529      *
165400200529      ** List of message data Entries (Array of <ArrayMax>x45 - from caller)
165500200529     C                   PARM                    MsgDtaArr
165600200529      *
165700200529      ** Front office transaction identifier (20A from caller)
165800200529     C                   PARM                    APFOTRANID
165900200529      *
166000200529      ** Midas module Id (2A)
166100200529     C                   PARM                    PModuleId
166200200529      *
166300200529      ** Midas transaction Id (20A, from caller)
166400200529     C                   PARM                    PTranID
166500200529      *
166600200529      ** Message file (10A, from caller)
166700200529     C                   PARM                    #MSGFILE
166800200529      *
166900200529      ** Action code of transaction (1A, from transaction)
167000200529     C                   PARM                    DDACTN
167100200529      *
167200200529      ** Status of transaction (1A, F=Failure, S=Success)
167300200529     C                   PARM                    PTranStatus
167400200529      *
167500200529      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
167600200529     C                   PARM                    APRESPMODE
167700200529      *
167800200529      ** The following three parameters are needed when messages are
167900200529      ** to be displayed on a screen
168000200529      *
168100200529      ** Screen-handling program (10A, from caller)
168200200529     C                   PARM                    #ProcPgm
168300200529      *
168400200529      ** Screen-handling module (10A, from caller)
168500200529     C                   PARM                    #ProcMod
168600200529      *
168700200529      ** Screen-handling procedure (10A, from caller)
168800200529     C                   PARM                    #ProcName
168900200529      *
169000200529      ** The MQ series queue to send replies to
169100200529     C                   PARM                    APRPYQUEUE
169200200529      *
169300200529      ** The transaction's timestamp
169400200529     C                   PARM                    PTimestamp
169500200529      *
169600200529      ** Additional message files to Check (Array of <MsgFArrMax> x 10)
169700200529     C                   PARM                    MSGFARRAY
169800200529      *
169900200529      ** Whether or not clear the program message queue (1A)
170000200529     C                   PARM                    PClrPgmMsgQ
170100200529
170200200529     C                   ENDSR
170300200529      *
170400200529      *****************************************************************
170500200529      /EJECT
170600200529      *****************************************************************
170700200529      *                                                               *
170800200529      *  SRResetFld - Routine to reset fields                         *
170900200529      *                                                               *
171000200529      *****************************************************************
171100200529     C     SRResetFld    BEGSR
171200200529
171300200529     C                   RESET                   FldNameArr
171400200529     C                   RESET                   MsgIdArr
171500200529     C                   RESET                   MsgDtaArr
171600200529     C                   RESET                   IDx
171700200529
171800200529     C                   RESET                   WFldNamArr
171900200529     C                   RESET                   WMsgIdArr
172000200529     C                   RESET                   WMsgDtaArr
172100200529     C                   RESET                   WIDx
172200200529
172300200529     C                   RESET                   AMFldNamAr
172400200529     C                   RESET                   AMMsgIdArr
172500200529     C                   RESET                   AMMsgDtaAr
172600200529     C                   RESET                   AMIDx
172700200529
172800200529     C                   RESET                   FldNoArr
172900200529
173000200529     C                   MOVE      *ALL'Y'       SEESEDE
173100200529
173200200529     C                   CLEAR                   CrDE1ScnFmt
173300200529
173400200529     C                   ENDSR
173500200529      *
173600200529      *****************************************************************                       CSC011
173700200529      /EJECT                                                                                  CSC011
173800200529      *****************************************************************                       CSC011
173900200529      *                                                               *                       CSC011
174000200529      *  SRWriteLog - Setup data to be written to standard support    *                       CSC011
174100200529      *               log file                                        *                       CSC011
174200200529      *                                                               *                       CSC011
174300200529      *  Called by:  SRCheckWrite                                     *                       CSC011
174400200529      *                                                               *                       CSC011
174500200529      *  Calls: APLOGTRAN - API standard Log module                   *                       CSC011
174600200529      *                                                               *                       CSC011
174700200529      *****************************************************************                       CSC011
174800200529                                                                                              CSC011
174900200529     C     SRWriteLog    BEGSR                                                                CSC011
175000200529                                                                                              CSC011
175100200529      ** Setup value of TRANSDTL                                                              CSC011
175200200529                                                                                              CSC011
175300200529     C                   EVAL      TRANSDTL = NwDE1ScnFmt + PExtData                          CSC011
175400200529                                                                                              CSC011
175500200529      ** Initialise Deal no to pass                                                           CSC011
175600200529     C                   MOVE      WEvtDno       WSDED                                        CSC011
175700200529     C                   EVAL      PDealNo = DDSDSN + WSDED + DDSDET                          CSC011
175800200529                                                                                              CSC011
175900200529      ** Call program that will write to API standard log file.                               CSC011
176000200529     C                   CALLB     'APLOGTRAN'                                                CSC011
176100200529     C                   PARM      *BLANKS       ReturnCode                                   CSC011
176200200529     C                   PARM                    PHeadIn                                      CSC011
176300200529     C                   PARM                    TRANSDTL                                     CSC011
176400200529     C                   PARM                    PTimestamp                                   CSC011
176500200529     C                   PARM                    PDealNo                                      CSC011
176600200529     C                   PARM      *BLANKS       PADealNo                                     CSC011
176700200529      ** If error occurred, perform abnormal termination                                      CSC011
176800200529     C     ReturnCode    IFNE      *BLANKS                                                    CSC011
176900200529     C                   EVAL      DBASE = 8                                                  CSC011
177000200529     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
177100200529     C                   EVAL      DBKEY = '*CALL'                                            CSC011
177200200529     C                   EXSR      *pssr                                                      CSC011
177300200529     C                   ENDIF                                                                CSC011
177400200529                                                                                              CSC011
177500200529     C                   ENDSR                                                                CSC011
177600200529                                                                                              CSC011
177700200529      *****************************************************************
177800200529      /EJECT
177900200529      *****************************************************************
178000200529      *                                                               *
178100200529      *  *INZSR - Program Initialisation                              *
178200200529      *         - This subroutine runs automatically for program      *
178300200529      *           initialisation.                                     *
178400200529      *                                                               *
178500200529      *****************************************************************
178600200529      *
178700200529     C     *INZSR        BEGSR
178800200529      *
178900200529     C     *ENTRY        PLIST
179000200529      *
179100200529      ** Message header details
179200200529     C                   PARM                    PHeadIn
179300200529      *
179400200529      ** Incoming transaction details
179500200529     C                   PARM                    PTrans5001
179600200529      *
179700200529      ** Incoming transaction extra data
179800200529     C                   PARM                    PExtData500
179900200529      *
180000200529      ** Program details
180100200529     C                   PARM                    #ProcPgm
180200200529     C                   PARM                    #ProcMod
180300200529     C                   PARM                    #ProcName
180400200529      *
180500200529      ** Set up the name of the module Id used to make the transaction
180600200529      ** number unique.
180700200529      *
180800200529     C                   EVAL      PModuleId = 'SE'
180900200529      *
181000200529      ** Set up the name of the primary and secondary message files from
181100200529      ** which the message handler will get the messages.
181200200529      *
181300200529     C                   EVAL      #MSGFILE     = 'SEUSRMSG'
181400200529     C                   EVAL      MSGFArray(1) = 'DRSMM'
181500200529     C                   EVAL      MsgFArray(2) = 'MEMSG'
181600200529      *
181700200529      ** Set up the name of the server/database updater data queue.
181800200529      *
181900200529     C                   EVAL      DTAQNAME = 'APSEDEDTQ'
182000200529      *
182100200529      ** Access bank details.
182200200529      *
182300200529     C                   CALLB     'AOBANKR0'
182400200529     C                   PARM      *BLANKS       PRTCD
182500200529     C                   PARM      '*FIRST '     POPTN
182600200529     C     SDBANK        PARM      SDBANK        DSFDY
182700200529      *
182800200529      ** Database error.
182900200529     C                   IF        PRTCD <> *BLANKS
183000200529     C                   EVAL      DBKEY = POPTN
183100200529     C                   EVAL      DBFILE = 'SDBANKPD'
183200200529     C                   Z-ADD     1             DBASE
183300200529     C                   EXSR      *PSSR
183400200529     C                   ENDIF
183500200529      *
183600200529      ** Access API ICD details.
183700200529      *
183800200529     C                   CALLB     'AOAPIR0'
183900200529     C                   PARM      *BLANKS       PRTCD
184000200529     C                   PARM      '*FIRST '     POPTN
184100200529     C     SDAPI         PARM      SDAPI         DSFDY
184200200529      *
184300200529      ** Database error.
184400200529     C                   IF        PRTCD <> *BLANKS
184500200529     C                   EVAL      DBKEY = POPTN
184600200529     C                   EVAL      DBFILE = 'SDAPIPD'
184700200529     C                   Z-ADD     2             DBASE
184800200529     C                   EXSR      *PSSR
184900200529     C                   ENDIF
185000200529      *
185100200529      ** Access SAR file to determine if CSE010
185200200529      ** (SE Transaction Enhancement) is installed.
185300200529      *
185400200529     C                   CALLB     'AOSARDR0'
185500200529     C                   PARM      *BLANKS       PRTCD
185600200529     C                   PARM      '*VERIFY'     POPTN
185700200529     C                   PARM      'CSE010'      PSARD
185800200529     C     SCSARD        PARM      SCSARD        DSFDY
185900200529      *
186000200529      ** An NRF (No Record Found) return code is valid.
186100200529      ** Issue database error only for error return codes.
186200200529      *
186300200529     C                   IF        PRTCD <> *BLANKS AND
186400200529     C                             PRTCD <> '*NRF   '
186500200529     C                   EVAL      DBKEY = 'CSE010'
186600200529     C                   EVAL      DBFILE = 'SCSARDPD'
186700200529     C                   Z-ADD     3             DBASE
186800200529     C                   EXSR      *PSSR
186900200529     C                   ENDIF
187000200529
187100200529     C                   IF        PRTCD = *BLANKS
187200200529     C                   EVAL      CSE010 = 'Y'
187300200529     C                   ELSE
187400200529     C                   EVAL      CSE010 = 'N'
187500200529     C                   ENDIF
187600200529      *
187700200529      ** Access SAR file to determine if S01509
187800200529      ** (Value Ccy to be Ccy of Issuer Payment) is installed.
187900200529      *
188000200529     C                   CALLB     'AOSARDR0'
188100200529     C                   PARM      *BLANKS       PRTCD
188200200529     C                   PARM      '*VERIFY'     POPTN
188300200529     C                   PARM      'S01509'      PSARD
188400200529     C     SCSARD        PARM      SCSARD        DSFDY
188500200529      *
188600200529      ** An NRF (No Record Found) return code is valid.
188700200529      ** Issue database error only for error return codes.
188800200529      *
188900200529     C                   IF        PRTCD <> *BLANKS AND
189000200529     C                             PRTCD <> '*NRF   '
189100200529     C                   EVAL      DBKEY = 'S01509'
189200200529     C                   EVAL      DBFILE = 'SCSARDPD'
189300200529     C                   Z-ADD     4             DBASE
189400200529     C                   EXSR      *PSSR
189500200529     C                   ENDIF
189600200529
189700200529     C                   IF        PRTCD = *BLANKS
189800200529     C                   EVAL      S01509 = 'Y'
189900200529     C                   ELSE
190000200529     C                   EVAL      S01509 = 'N'
190100200529     C                   ENDIF
190200200529      *
190300200529      ** Access SAR file to determine if S01510
190400200529      ** (Dividend Payments) is installed.
190500200529      *
190600200529     C                   CALLB     'AOSARDR0'
190700200529     C                   PARM      *BLANKS       PRTCD
190800200529     C                   PARM      '*VERIFY'     POPTN
190900200529     C                   PARM      'S01510'      PSARD
191000200529     C     SCSARD        PARM      SCSARD        DSFDY
191100200529      *
191200200529      ** An NRF (No Record Found) return code is valid.
191300200529      ** Issue database error only for error return codes.
191400200529      *
191500200529     C                   IF        PRTCD <> *BLANKS AND
191600200529     C                             PRTCD <> '*NRF   '
191700200529     C                   EVAL      DBKEY = 'S01510'
191800200529     C                   EVAL      DBFILE = 'SCSARDPD'
191900200529     C                   Z-ADD     5             DBASE
192000200529     C                   EXSR      *PSSR
192100200529     C                   ENDIF
192200200529
192300200529     C                   IF        PRTCD = *BLANKS
192400200529     C                   EVAL      S01510 = 'Y'
192500200529     C                   ELSE
192600200529     C                   EVAL      S01510 = 'N'
192700200529     C                   ENDIF
192800200529                                                                                              CGL031
192900200529      ** Access SAR file to determine if Taxation on Savings                                  CGL031
193000200529      ** Income is installed.                                                                 CGL031
193100200529                                                                                              CGL031
193200200529     C                   CALLB     'AOSARDR0'                                                 CGL031
193300200529     C                   PARM      *BLANKS       PRtcd                                        CGL031
193400200529     C                   PARM      '*VERIFY'     POptn                                        CGL031
193500200529     C                   PARM      'CGL031'      PSarD                                        CGL031
193600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
193700200529                                                                                              CGL031
193800200529      ** An NRF (No Record Found) return code is valid.                                       CGL031
193900200529      ** Issue database error only for error return codes.                                    CGL031
194000200529                                                                                              CGL031
194100200529     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
194200200529     C                             PRtcd <> '*NRF   '                                         CGL031
194300200529     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
194400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
194500200529     C                   Z-ADD     10            DBASE                                        CGL031
194600200529     C                   EXSR      *PSSR                                                      CGL031
194700200529     C                   ENDIF                                                                CGL031
194800200529                                                                                              CGL031
194900200529     C                   IF        PRtcd = *BLANKS                                            CGL031
195000200529     C                   MOVEL     'Y'           CGL031                                       CGL031
195100200529     C                   ELSE                                                                 CGL031
195200200529     C                   MOVEL     'N'           CGL031                                       CGL031
195300200529     C                   ENDIF                                                                CGL031
195400200529      *
195500200529      ** Retrieve ICD for securities trading.
195600200529     C                   CALLB     'AOSTRDR0'
195700200529     C                   PARM      *BLANKS       PRTCD
195800200529     C                   PARM      '*FIRST '     POPTN
195900200529     C     SDSTRD        PARM      SDSTRD        DSSDY
196000200529      *
196100200529      ** Database error.
196200200529     C                   IF        PRTCD <> *BLANKS
196300200529     C                   EVAL      DBKEY = POPTN
196400200529     C                   EVAL      DBFILE = 'SDSTRDPD'
196500200529     C                   Z-ADD     6             DBASE
196600200529     C                   EXSR      *PSSR
196700200529     C                   ENDIF
196800200529                                                                                              CSC011
196900200529      ** Determine if 24x7 Midas availability is installed                                    CSC011
197000200529                                                                                              CSC011
197100200529     C                   CALLB     'AOSARDR0'                                                 CSC011
197200200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
197300200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
197400200529     C                   PARM      'CSC011'      PSARD                                        CSC011
197500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
197600200529                                                                                              CSC011
197700200529      ** An NRF (No Record Found) return code is valid.                                       CSC011
197800200529      ** Issue database error only for error return codes.                                    CSC011
197900200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
198000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
198100200529     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
198200200529     C                   EVAL      DBASE = 7                                                  CSC011
198300200529     C                   EXSR      *pssr                                                      CSC011
198400200529     C                   ENDIF                                                                CSC011
198500200529                                                                                              CSC011
198600200529     C                   IF        PRTCD = *BLANKS                                            CSC011
198700200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
198800200529     C                   IN        SC24X7                                                     CSC011
198900200529     C                   IN        SDSTAT                                                     CSC011
199000200529     C                   ELSE                                                                 CSC011
199100200529     C                   EVAL      CSC011 = 'N'                                               CSC011
199200200529     C                   ENDIF                                                                CSC011
199300200529      *                                                                                       CSE031
199400200529      ** Access SAR file to determine if CSE031                                               CSE031
199500200529      ** (Coupon Fixing for Floating Rate Notes) is installed.                                CSE031
199600200529      *                                                                                       CSE031
199700200529     C                   CALLB     'AOSARDR0'                                                 CSE031
199800200529     C                   PARM      *BLANKS       PRTCD                                        CSE031
199900200529     C                   PARM      '*VERIFY'     POPTN                                        CSE031
200000200529     C                   PARM      'CSE031'      PSARD                                        CSE031
200100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
200200200529      *                                                                                       CSE031
200300200529      ** An NRF (No Record Found) return code is valid.                                       CSE031
200400200529      ** Issue database error only for error return codes.                                    CSE031
200500200529      *                                                                                       CSE031
200600200529     C                   IF        PRTCD <> *BLANKS AND                                       CSE031
200700200529     C                             PRTCD <> '*NRF   '                                         CSE031
200800200529     C                   EVAL      DBKEY = 'CSE031'                                           CSE031
200900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE031
201000200529     C                   Z-ADD     8             DBASE                                        CSE031
201100200529     C                   EXSR      *PSSR                                                      CSE031
201200200529     C                   ENDIF                                                                CSE031
201300200529                                                                                              CSE031
201400200529     C                   IF        PRTCD = *BLANKS                                            CSE031
201500200529     C                   EVAL      CSE031 = 'Y'                                               CSE031
201600200529     C                   ELSE                                                                 CSE031
201700200529     C                   EVAL      CSE031 = 'N'                                               CSE031
201800200529     C                   ENDIF                                                                CSE031
201900200529                                                                                              CSC011
202000200529      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
202100200529      ** Phase B(CAS006)' is installed.                                                       CAS006
202200200529                                                                                              CAS006
202300200529     C                   CALLB     'AOSARDR0'                                                 CAS006
202400200529     C                   PARM      *BLANKS       PRtcd                                        CAS006
202500200529     C                   PARM      '*VERIFY'     POptn                                        CAS006
202600200529     C                   PARM      'CAS006'      PSarD                                        CAS006
202700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
202800200529                                                                                              CAS006
202900200529      ** An NRF (No Record Found) return code is valid.                                       CAS006
203000200529      ** Issue database error only for error return codes.                                    CAS006
203100200529     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
203200200529     C                             PRtcd <> '*NRF   '                                         CAS006
203300200529     C     *LOCK         IN        LDA                                                        CAS006
203400200529     C                   EVAL      DBKey = 'CAS006'                                           CAS006
203500200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
203600200529     C                   EVAL      DBase = 009                                                CAS006
203700200529     C                   OUT       LDA                                                        CAS006
203800200529     C                   EXSR      *PSSR                                                      CAS006
203900200529     C                   ENDIF                                                                CAS006
204000200529                                                                                              CAS006
204100200529     C                   IF        PRtcd = *BLANKS                                            CAS006
204200200529     C                   MOVEL     'Y'           CAS006                                       CAS006
204300200529     C                   ELSE                                                                 CAS006
204400200529     C                   MOVEL     'N'           CAS006                                       CAS006
204500200529     C                   ENDIF                                                                CAS006
204600200529                                                                                              CSE072
204700200529      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
204800200529      ** (CSE072)' is installed.                                                              CSE072
204900200529                                                                                              CSE072
205000200529     C                   CALLB     'AOSARDR0'                                                 CSE072
205100200529     C                   PARM      *BLANKS       PRtcd                                        CSE072
205200200529     C                   PARM      '*VERIFY'     POptn                                        CSE072
205300200529     C                   PARM      'CSE072'      PSarD                                        CSE072
205400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
205500200529                                                                                              CSE072
205600200529      ** An NRF (No Record Found) return code is valid.                                       CSE072
205700200529      ** Issue database error only for error return codes.                                    CSE072
205800200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
205900200529     C                             PRtcd <> '*NRF   '                                         CSE072
206000200529     C     *LOCK         IN        LDA                                                        CSE072
206100200529     C                   EVAL      DBKey = 'CSE072'                                           CSE072
206200200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
206300200529     C                   EVAL      DBase = 009                                                CSE072
206400200529     C                   OUT       LDA                                                        CSE072
206500200529     C                   EXSR      *PSSR                                                      CSE072
206600200529     C                   ENDIF                                                                CSE072
206700200529                                                                                              CSE072
206800200529     C                   IF        PRtcd = *BLANKS                                            CSE072
206900200529     C                   MOVEL     'Y'           CSE072                                       CSE072
207000200529     C                   ELSE                                                                 CSE072
207100200529     C                   MOVEL     'N'           CSE072                                       CSE072
207200200529     C                   ENDIF                                                                CSE072
207300200529                                                                                              CSE065
207400200529      ** Access SAR file to determine if CSE065 is installed                                  CSE065
207500200529                                                                                              CSE065
207600200529     C                   CALL      'AOSARDR0'                                                 CSE065
207700200529     C                   PARM      *BLANKS       PRtcd                                        CSE065
207800200529     C                   PARM      '*VERIFY'     POptn                                        CSE065
207900200529     C                   PARM      'CSE065'      PSarD                                        CSE065
208000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
208100200529                                                                                              CSE065
208200200529      ** An NRF (No Record Found) return code is valid.                                       CSE065
208300200529      ** Issue database error only for error return codes.                                    CSE065
208400200529                                                                                              CSE065
208500200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
208600200529     C                             PRtcd <> '*NRF   '                                         CSE065
208700200529     C     *LOCK         IN        LDA                                                        CSE065
208800200529     C                   EVAL      DBKey = 'CSE065'                                           CSE065
208900200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
209000200529     C                   EVAL      DBase = 010                                                CSE065
209100200529     C                   OUT       LDA                                                        CSE065
209200200529     C                   EXSR      *PSSR                                                      CSE065
209300200529     C                   ENDIF                                                                CSE065
209400200529                                                                                              CSE065
209500200529     C                   IF        PRtcd = *BLANKS                                            CSE065
209600200529     C                   MOVEL     'Y'           CSE065                                       CSE065
209700200529     C                   ELSE                                                                 CSE065
209800200529     C                   MOVEL     'N'           CSE065                                       CSE065
209900200529     C                   ENDIF                                                                CSE065
210000200529      *                                                                                      260191A
210100200529      ** Check if S01512 is installed                                                        260191A
210200200529      *                                                                                      260191A
210300200529     C                   CallB     'AOSARDR0'                                                260191A
210400200529     C                   Parm      *BLANKS       PRTCD             7                         260191A
210500200529     C                   Parm      '*VERIFY'     POPTN             7                         260191A
210600200529     C                   Parm      'S01512'      PSARD             6                         260191A
210700200529     C     SCSARD        Parm      SCSARD        DSFDY                                       260191A
210800200529      *                                                                                      260191A
210900200529      ** An NRF (No Record Found) return code is valid.                                      260191A
211000200529      ** Issue database error only for error return codes.                                   260191A
211100200529      *                                                                                      260191A
211200200529     C                   IF        PRtcd <> *BLANKS AND                                      260191A
211300200529     C                             PRtcd <> '*NRF   '                                        260191A
211400200529     C     *LOCK         IN        LDA                                                       260191A
211500200529     C                   EVAL      DBKey = 'S01512'                                          260191A
211600200529     C                   EVAL      DBFile= 'SCSARDPD'                                        260191A
211700200529     C                   EVAL      DBase = 011                                               260191A
211800200529     C                   OUT       LDA                                                       260191A
211900200529     C                   EXSR      *PSSR                                                     260191A
212000200529     C                   ENDIF                                                               260191A
212100200529      *                                                                                      260191A
212200200529     C                   IF        PRTCD = *BLANKS                                           260191A
212300200529     C                   MOVE      'Y'           S01512            1                         260191A
212400200529     C                   ELSE                                                                260191A
212500200529     C                   MOVE      'N'           S01512                                      260191A
212600200529     C                   ENDIF                                                               260191A
212700200529      *
212800200529      ** Retrieve Midas Module Flag details
212900200529      *
213000200529     C                   READ      MMODF                                  01
213100200529      *
213200200529      ** Retrieve ZMUSER details.
213300200529      *
213400200529     C     *DTAARA       DEFINE                  ZMUSER
213500200529     C                   IN        ZMUSER
213600200529      *
213700200529      ** Key fields for LF/SEDEV
213800200529     C     KDEVKA        KLIST
213900200529     C                   KFLD                    DDSDSN
214000200529     C                   KFLD                    WEvtDno
214100200529     C                   KFLD                    DDSDET
214200200529      *
214300200529      ** Program, module and procedure names for database error processing
214400200529      ** =================================================================
214500200529      ** The following /COPY sets these values.
214600200529      *
214700200529      /COPY ZACPYSRC,DBFIELDS
214800200529      *
214900200529      ** Hook to enable non-core initial processing to be included
215000200529      *
215100200529      /COPY WNCPYSRC,SESEDEC021
215200200529      *
215300200529      ** Access SAR details file to determine if Commitment Control                          BUG2604
215400200529      ** Changes is switched on.                                                             BUG2604
215500200529      *                                                                                      BUG2604
215600200529     C                   CallB     'AOSARDR0'                                                BUG2604
215700200529     C                   Parm      *BLANKS       PRTCD                                       BUG2604
215800200529     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
215900200529     C                   Parm      'CSC022'      PSARD                                       BUG2604
216000200529     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
216100200529                                                                                             BUG2604
216200200529     C                   If        PRTCD = *BLANKS                                           BUG2604
216300200529      *                                                                                      BUG2604
216400200529     C                   Eval      CSC022 = 'Y'                                              BUG2604
216500200529     C                   In        SCCMTJOB                                                  BUG2604
216600200529     C                   If        ComitNum > 0                                              BUG2604
216700200529      *                                                                                      BUG2604
216800200529      ** Check if Current Job exists in the Commitment Job Names                             BUG2604
216900200529      ** Data Area.                                                                          BUG2604
217000200529      *                                                                                      BUG2604
217100200529     C                   MoveA     wComitJob     CmtJobNArr                                  BUG2604
217200200529     C     PSJOBNAME     LookUp    CmtJobNArr                             20                 BUG2604
217300200529     C                   If        *IN20                                                     BUG2604
217400200529     C                   Eval      wCommitSkip = 'Y'                                         BUG2604
217500200529     C                   EndIf                                                               BUG2604
217600200529     C                   EndIf                                                               BUG2604
217700200529      *                                                                                      BUG2604
217800200529     C                   Else                                                                BUG2604
217900200529      *                                                                                      BUG2604
218000200529      ** Database error                                                                      BUG2604
218100200529      *                                                                                      BUG2604
218200200529     C                   If        PRTCD <> '*NRF'                                           BUG2604
218300200529     C     *LOCK         In        LDA                                                       BUG2604
218400200529     C                   Eval      DBKey = 'CSC022'                                          BUG2604
218500200529     C                   Eval      DBPgm = 'SESEDECTL'                                       BUG2604
218600200529     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2604
218700200529     C                   Eval      DBase = 10                                                BUG2604
218800200529     C                   Out       LDA                                                       BUG2604
218900200529     C                   ExSr      *PSSR                                                     BUG2604
219000200529     C                   EndIf                                                               BUG2604
219100200529      *                                                                                      BUG2604
219200200529     C                   EndIf                                                               BUG2604
219300200529      *                                                                                      BUG2604
219400200529     C                   ENDSR
219500200529      *
219600200529      *****************************************************************
219700200529      /EJECT
219800200529      *****************************************************************
219900200529      *
220000200529      ** The following /COPY contains the standard program status
220100200529      ** subroutine, including a bound call to the DBERRCTL module.
220200200529      *
220300200529      /COPY ZACPYSRC,PSSR_ILE
220400200529      *
220500200529      *****************************************************************
220600200529      /EJECT
220700200529      *****************************************************************
220800200529      *
220900200529**  CPY@
221000200529(c) Finastra International Limited 2001
