000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2004')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Security diary events interface cntroller')   *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SESEDEVU - Security Diary Events Validate and Update         *
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
002900200529      *                                                               *
003000200529      *                                                               *
003100200529      *  (c) Finastra International Limited 2004                      *
003200200529      *                                                               *
003300200604      *  Last Amend No. 260191A            Date 22May20               *
003400200529      *  Prev Amend No. CSD102             Date 08Jan19               *
003500200529      *                 MD046248           Date 27Oct17               *
003600200529      *                 MD037742           Date 01Apr16               *
003700200529      *                 CRE073             Date 06Dec10               *
003800200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003900200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
004000200529      * Midas Plus 1.4 Base ------------------------------------------*
004100200529      * Midas Plus 1.3 ----------- Base ------------------------------*
004200200529      *                 CSD027             Date 09Dec05               *
004300200529      *                 CSE075             Date 17Nov05               *
004400200529      *                 237063             Date 20Nov05               *
004500200529      *                 CGL031             Date 05Jul04               *
004600200529      *                 CSE065             Date 08Nov04               *
004700200529      *                 CSE071             Date 19Jul05               *
004800200529      *                 BUG7029            Date 09Jun05               *
004900200529      *                 BUG6782            Date 11May05               *
005000200529      *                 CSE072             Date 05Apr05               *
005100200529      *                 BUG4728            Date 05Nov04               *
005200200529      *                 BUG4258            Date 13Sep04               *
005300200529      *                 CAP084  *Create    Date 08Jan04               *
005400200529      *                                                               *
005500200529      *---------------------------------------------------------------*
005600200529      *                                                               *
005700200529      *  260191A- System should not allow deletion of LIVE/MATURED    *
005800200529      *           security diary event if ALL generated position      *
005900200529      *           settlements are still unsettled/live records.       *
006000200529      *           Hence, system will not generate reversal position   *
006100200529      *           settlements.                                        *
006200200529      *  260191 - System should not allow deletion of a security diary*
006300200529      *           event if atleast one live position exists for the   *
006400200529      *           event. This validation is only valid if the diary   *
006500200529      *           event being deleted is still live record. Applied   *
006600200529      *           fix 247625.                                         *
006700200529      *  CSD102 - Password Length Extension (Recompile)               *
006800200529      *  MD046248 - Finastra Rebranding                               *
006900200529      *  MD037742 - Security diary events - pool factor reversal.     *
007000200529      *             Patterned after 260331 changes in SESEDESIN.      *
007100200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
007200200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
007300200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
007400200529      *           (Recompile)                                         *
007500200529      *  237063 - EU Tax fixes upgrade to MP build 103.               *
007600200529      *  CGL031 - Taxation of Savings Income                          *
007700200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
007800200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
007900200529      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
008000200529      *            move out of *INZSR.                                *
008100200529      *  BUG6782- Redeliver to core.                                  *
008200200529      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
008300200529      *  BUG4728 - Serious Midas error with blank timestamp when      *
008400200529      *            authorising insert of transaction.                 *
008500200529      *  BUG4258- Stopping changes being overwritten by other user    *
008600200529      *           when try to amend the record at the same time.      *
008700200529      *  CAP084 - Synchronous calling of APIs                         *
008800200529      *                                                               *
008900200529      *****************************************************************
009000200529      *                                                               *
009100200529      *                                                               *
009200200529      *****************************************************************
009300200529      *                                                               *
009400200529      *  S U B R O U T I N E  I N D E X                               *
009500200529      *                                                               *
009600200529      *  SRChkValMTran - Routine to check if valid security diary     *
009700200529      *                  events exist for security shortname, event   *
009800200529      *                  date and event type in the valid security    *
009900200529      *                  diary events file.                           *
010000200529      *  SRValAction - Routine to validate Action Code for the        *
010100200529      *                security shortname, event date and event type  *
010200200529      *                supplied                                       *
010300200529      *  SRValDetails - Routine to validate Security Diary Events Det.*
010400200529      *  SRDefault1 - Defaulting for screen 1                         *
010500200529      *  SRVScrn1  - Validate screen 1 details                        *
010600200529      *  SRCvtSeDE - Convert security diary events details from file  *
010700200529      *              to screen format                                 *
010800200529      *  SRDtaSubs - Data Substitution Routine                        *
010900200529      *  SRValAmend - Routine to check whether the fields are         *
011000200529      *               amendable                                       *
011100200529      *  SetupValid - Routine to set up fields in the valid file      *
011200200529      *               record.                                         *
011300200529      *  SRResetFld - Routine to reset fields                         *
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
013000200529      ** Valid security diary events by key fields and timestamp
013100200529     FSEVSEDEL1 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHM)
013200200529      *
013300200529      ** Sequence number for input fields
013400200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
013500200529      *
013600200529      ** Midas Module Flag file
013700200529     FMMODF     IF   E             DISK    INFSR(*PSSR)
013800200529      *                                                                                      260191A
013900200529      ** Position Settlement by Security                                                     260191A
014000200529      *                                                                                      260191A
014100200529     FPOSET3    IF   E           K DISK    INFSR(*PSSR)                                      260191A
014200200529     F                                     PREFIX(F3)                                        260191A
014300200529      *
014400200529      ** Hook to enable non-core files to be included
014500200529      /COPY WNCPYSRC,SESEDEC001
014600200529      *
014700200529      *****************************************************************
014800200529      /EJECT
014900200529      *****************************************************************
015000200529      *
015100200529      ** +--------------------------------------+
015200200529      ** ¦ Automatically included D-specs       ¦
015300200529      ** ¦ ==============================       ¦
015400200529      ** +--------------------------------------+
015500200529      *
015600200529      ** Standard D-specs
015700200529      ** ================
015800200529      **
015900200529      ** The following /COPY line includes the LDA layout,
016000200529      ** the copyright array definition,
016100200529      ** and the following named constants:
016200200529      **    True       logical = *on (for indcator processing)
016300200529      **    False      logical = *off (for indicator processing)
016400200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
016500200529      **                                    handler)
016600200529      ** and the following variables:
016700200529      **    RunBefore  1A (for the PSSR)
016800200529
016900200529      /COPY ZACPYSRC,STD_D_SPEC
017000200529      *
017100200529      ** Program Status Data Structure
017200200529      ** =============================
017300200529      ** The following /COPY line includes all the defined fields in the
017400200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
017500200529
017600200529      /COPY ZACPYSRC,PSDS
017700200529      *
017800200529      ** The following /COPY line includes definition  for the above fields
017900200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
018000200529      ** corresponding fields in the PSDS /COPY member, so that member
018100200529      ** must be included where this one is used.
018200200529
018300200529      /COPY ZACPYSRC,PROCPARMS
018400200529      *
018500200529      ** The following /COPY line includes the definitions for error and
018600200529      ** warning message arrays.
018700200529
018800200529      /COPY ZACPYSRC,ERR_ARRAYS
018900200529      *
019000200529      ** The following /COPY line includes the definitions for arrays
019100200529      ** specific to API *CTL modules.
019200200529
019300200529      /COPY ZACPYSRC,APICTLARR
019400200529      *
019500200529      ** The following /COPY line includes the definitions for fields
019600200529      ** used in checking whether there are messages on the data queue.
019700200529
019800200529      /COPY ZACPYSRC,DTAQCHKDCL
019900200529      *
020000200529      ** +--------------------------------------+
020100200529      ** ¦ End of automatically included D-specs¦
020200200529      ** ¦ =====================================¦
020300200529      ** +--------------------------------------+
020400200529
020500200529      *****************************************************************
020600200529      /EJECT
020700200529      *****************************************************************
020800200529      *
020900200529      ** +--------------------------------------+
021000200529      ** ¦ Manually included D-specs            ¦
021100200529      ** ¦ =========================            ¦
021200200529      ** +--------------------------------------+
021300200529
021400200529      ** +--------------------------------------+
021500200529      ** ¦ Arrays and Data Structures           ¦
021600200529      ** ¦ ==========================           ¦
021700200529      ** +--------------------------------------+
021800200529
021900200529      *
022000200529      ** Message header details
022100200529     D PHeadIn       E DS                  EXTNAME(APHEADPD)
022200200529      *
022300200529      ** SE Diary Events Screen details from incoming transaction -
022400200529      ** - screen format
022500200529     D SedeScnFmt    E DS                  EXTNAME(SESEDEPD)
022600200529      *
022700200529      ** SE Diary Events for file update - file format
022800200529     D Sede1FilFmt   E DS                  EXTNAME(SEVSEDEPD)
022900200529     D*Sede1FilFmt1            1    231                                                CSE065 237063
023000200529      *
023100200529      ** SE Diary Events Screen details retrieved from file
023200200529      ** - screen format
023300200529     D Sede1ScnFmt   E DS                  EXTNAME(SESEDEPD)
023400200529     D                                     PREFIX(O)
023500200529      *
023600200529      ** Security diary events retrieved from file - file format
023700200529     D SedeFilFmt    E DS                  EXTNAME(SEDEVD)
023800200529     D*SedeFilFmt1             1    231                                                CSE065 237063
023900200529      *
024000200529      ** SE Diary Events screen error indicators
024100200529     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
024200200529      *
024300200529      ** Security Diary Events extra data
024400200529     D PExtData      E DS                  EXTNAME(SESDEXPD)
024500200529      *
024600200529      ** Externally described DS for security details
024700200529     D PSectyd       E DS                  EXTNAME(SECTYD)
024800200529     D                                     PREFIX(D1)
024900200529      *
025000200529      ** Externally described DS for bank details
025100200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
025200200529      *
025300200529      ** Externally described DS for API ICD details
025400200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
025500200529      *
025600200529      ** Externally described DS for securities trading icd details
025700200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
025800200529      *
025900200529      ** Externally described DS for SAR details
026000200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
026100200529     D SLCD          E                     EXTFLD(LCD)
026200200529      *
026300200529      ** 24x7 Status Dataarea
026400200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
026500200529      *
026600200529      ** SD Data Area
026700200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
026800200529      *
026900200529      ** DS for Access Objects - short data structure
027000200529     D DSFDY         E DS                  EXTNAME(DSFDY)
027100200529      *
027200200529      ** DS for Access Objects - long data structure
027300200529     D DSSDY         E DS                  EXTNAME(DSSDY)
027400200529      *
027500200529      ** DS for ZMUSER details
027600200529     D ZMUSER          DS            17
027700200529     D  PUSRID                 1     10
027800200529     D  PDBRN                 11     13
027900200529     D  PDPPT                 14     16
028000200529      *
028100200529      ** Indicator Array
028200200529     D Indicators      DS                  BASED(IndicatorP)
028300200529     D  RecNotFnd             01     01
028400200529      * Array to hold Commitment Job Names
028500200529     D CmtJobNArr      S             10A   DIM(10)
028600200529
028700200529      ** Commitment Control Data Area
028800200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
028900200529     D  wComitJob              4    103
029000200529
029100200529      *
029200200529      ** +--------------------------------------+
029300200529      ** ¦ Declared variables                   ¦
029400200529      ** ¦ ==================                   ¦
029500200529      ** +--------------------------------------+
029600200529
029700200529      *
029800200529      ** Index for arrays of error messages
029900200529     D IDx             S              3P 0
030000200529      *
030100200529      ** Index for arrays of warning messages
030200200529     D WIDx            S              3P 0
030300200529      *
030400200529      ** Pointer for the indicator array
030500200529     D IndicatorP      S               *   INZ(%Addr(*IN))
030600200529      *
030700200529      ** Indices for arrays used to set up corresponding sequence numbers
030800200529      ** for the fields that are in error
030900200529     D W1              S              3P 0
031000200529     D W2              S              3P 0
031100200529      *
031200200529      ** Index for arrays of error message Ids in amend validation
031300200529     D AMIDx           S              3P 0
031400200529      *
031500200529      ** Fields (500A) to receive the incoming transaction
031600200529     D PTrans5001      S            500A
031700200529      *
031800200529      ** Parametes for data substitution program.
031900200529     D PIncData        S           2000A
032000200529     D PCurData        S           2000A
032100200529      *
032200200529      ** Field (500A) to receive the incoming extra data
032300200529     D PExtData500     S            500A
032400200529      *
032500200529      ** Timestamp for the transaction
032600200529     D PTimestamp      S               Z
032700200529      *
032800200529      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
032900200529     D PObject         S             10A   INZ('SESEDEUPC')
033000200529     D PLib            S             10A   INZ('*LIBL')
033100200529     D PObjType        S              7A
033200200529     D PLockState      S              7A   INZ('*SHRRD')
033300200529     D PMember         S             10A
033400200529     D PWaitTime       S              6A   INZ('0     ')
033500200529     D PDlcObj         S              1A   INZ('Y')
033600200529     D PReturn         S              7A
033700200529      *
033800200529      ** Module Id to be passed to the message handler
033900200529     D PModuleId       S              2A   INZ('SE')
034000200529      *
034100200529      ** Whether or not to clear the program message queue (this is not
034200200529      ** actually used, but is required by the message handler's parameter
034300200529      ** list)
034400200529     D PClrPgmMsgQ     S              1A   INZ('Y')
034500200529      *
034600200529      ** Overall Transaction status, to be passed to the message handler
034700200529     D PTranStatus     S              1A
034800200529      *
034900200529      ** Dummy message Id and message file fields for use on the calls to
035000200529      ** ZAMSGTOOPR
035100200529     D PDummyMsgId     S                   LIKE(#MsgID)
035200200529     D PDummyMsgF      S             10A
035300200529      *
035400200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
035500200529      ** Mode = '      ' (Not Front Office Transaction Interface)
035600200529      ** Mode = '*RPR  ' (Repair Function)
035700200529      ** Mode = '*SIN  ' (Screen Input Function)
035800200529     D PMode           S              6A
035900200529      *
036000200529      ** Work parameters
036100200529     D PRTCD           S              7A
036200200529     D POPTN           S              7A
036300200529     D PSARD           S              6A
036400200529     D PTranID         S             20A
036500200529     D PResetFld       S              1A
036600200529     D PAmendOk        S              1A
036700200529     D PMQReturn       S             10A
036800200529     D PMQErrLong      S            132A
036900200529     D PEvtDno         S              5P 0
037000200529     D PPayCcy         S              3A
037100200529     D PPROT           S              1A
037200200529     D OKFLDS          S              1A   INZ('N')
037300200529      *
037400200529      ** Switchable features
037500200529     D CSE010          S              1A
037600200529     D S01509          S              1A
037700200529     D S01510          S              1A
037800200529     D CSE031          S              1A
037900200529     D CAS006          S              1A
038000200529     D CSC011          S              1A
038100200529     D CSE072          S              1A                                                      CSE072
038200200529     D CSE065          S              1A                                                      CSE065
038300200529     D CGL031          S              1A                                                      CGL031
038400200529      *
038500200529      ** Redisplay screen flag
038600200529     D PReDsp          S              1A
038700200529      *
038800200529      ** Work variables
038900200529     D WSubDE1         S              1A
039000200529     D WMQError        S             28A
039100200529     D WEvtDno         S              5P 0
039200200529     D DDCUCR          S             12A
039300200529     D DDSEXR          S             14A
039400200529     D DDNTCR          S             11A
039500200529     D DDMATY          S              8A                                                      CSE065
039600200529      *
039700200529      ** Parameters for ZDATE1
039800200529     D PDateIn         S              6A
039900200529     D PDayNoOut       S              5P 0
040000200529     D PErrorFlag      S              1A
040100200529      *
040200200529      ** Define parameter to be passed to APLOGTRAN.
040300200529     D TRANSDTL        S           5800A   INZ(*BLANKS)
040400200529      *
040500200529      ** Transaction number to be pass to APLOGTRAN.
040600200529     D PDealNo         S             18A   INZ(*BLANKS)
040700200529      *
040800200529      ** Associated transaction number
040900200529     D PADealNo        S             18A   INZ(*BLANKS)
041000200529      *
041100200529      ** Work variable for Diary event date -alpha
041200200529     D WSDED           S              5A
041300200529      *
041400200529      ** Processing date
041500200529     D WRDAY           S                   LIKE(BJRDNB)
041600200529      *
041700200529      ** Parameters for ZEDIT
041800200529     D ZField          S             16A
041900200529     D ZADec           S              1P 0
042000200529      ** Work variables for CSC022
042100200529     D CSC022          S              1A   INZ('N')
042200200529     D wCommitSkip     S              1A   INZ('N')
042300200529
042400200529      *
042500200529      ** +----------------------------------------+
042600200529      ** ¦ Hook for non-core D-specs (all types)  ¦
042700200529      ** ¦ also any I-specs (if necessary)        ¦
042800200529      ** ¦ =====================================  ¦
042900200529      ** +----------------------------------------+
043000200529      /COPY WNCPYSRC,SESEDEC002
043100200529      *
043200200529      ** +--------------------------------------+
043300200529      ** ¦ End of D-specs                       ¦
043400200529      ** ¦ ==============                       ¦
043500200529      ** +--------------------------------------+
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
044600200529      *****************************************************************
044700200529      * MAIN PROCEDURE                                                *
044800200529      *****************************************************************
044900200529      *                                                                                      BUG7029
045000200529      ** Retrieve ZMUSER details.                                                            BUG7029
045100200529      *                                                                                      BUG7029
045200200529     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
045300200529     C                   IN        ZMUSER                                                    BUG7029
045400200529      *
045500200529      /COPY WNCPYSRC,SESEDEC003
045600200529      *
045700200529      ** Incoming transaction is in 500A fields, so that a common
045800200529      ** CLP can be used between this module and the one that
045900200529      ** read the MQ queue.  Break the 500A data by loading
046000200529      ** them into the appropriate (externally-described)
046100200529      ** data structures.
046200200529     C                   MOVEL     PTrans5001    SedeScnFmt
046300200529     C                   MOVEL     PExtData500   PExtData
046400200529      *
046500200529      ** Reset fields.
046600200529     C                   EXSR      SRResetFld
046700200529      /COPY WNCPYSRC,SESEDEC004
046800200529      *
046900200529      ** Check if valid security diary event exist for security shortname,
047000200529      ** event date and event type.
047100200529     C                   EXSR      SRChkValMTran
047200200529      *
047300200529      ** If valid security diary event does exist even after delay,
047400200529      ** fail this input.
047500200529     C                   IF        IDx <> 0
047600200529     C                   GOTO      INVALID
047700200529     C                   ENDIF
047800200529      *
047900200529      /COPY WNCPYSRC,SESEDEC005
048000200529      *
048100200529      ** Validate action code versus the security shortname, event date
048200200529      ** and event type supplied. Original security diary events details
048300200529      ** are retrieved during the validation process.
048400200529     C                   EXSR      SRValAction
048500200529      *
048600200529      /COPY WNCPYSRC,SESEDEC006
048700200529      *
048800200529      ** If errors occurred in the initial validation, fail this input.
048900200529     C                   IF        IDx <> 0
049000200529     C                   GOTO      INVALID
049100200529     C                   ENDIF
049200200529      *
049300200529      ** Processing depends upon action code.
049400200529     C                   SELECT
049500200529      *
049600200529      ** Insert
049700200529      ** ======
049800200529     C                   WHEN      DDACTN = 'I'
049900200529      *
050000200529      /COPY WNCPYSRC,SESEDEC007
050100200529      *
050200200529      ** Validate incoming Security Diary Event details.
050300200529     C                   EXSR      SRValDetails
050400200529      *
050500200529      /COPY WNCPYSRC,SESEDEC008
050600200529      *
050700200529      ** Check if amended fields are amendable.
050800200529     C                   EXSR      SRValAmend
050900200529      *
051000200529      ** Setup field DDNTCR
051100200529     C                   IF        CAS006 = 'Y'  AND
051200200529     C                             DDSDET = 'IR' AND
051300200529     C                             D1CPNN <> *ZEROS
051400200529     C                   EXSR      SRSetupDDNTCR
051500200529     C                   ENDIF
051600200529      *
051700200529      /COPY WNCPYSRC,SESEDEC009
051800200529      *
051900200529      ** Amend
052000200529      ** =====
052100200529     C                   WHEN      DDACTN = 'A' OR
052200200529     C                             DDACTN = 'D'
052300200529      *
052400200529      /COPY WNCPYSRC,SESEDEC010
052500200529      *
052600200529      ** Convert original security diary events details from file
052700200529      ** to screen format.
052800200529     C                   EXSR      SRCvtSeDE
052900200529      *
053000200529      /COPY WNCPYSRC,SESEDEC011
053100200529      *
053200200529      ** Check for the existence of the replacement character; if this is
053300200529      ** used, only the changed data has been sent, and all occurrences of
053400200529      ** the replacement character must be replaced with the corresponding
053500200529      ** character from the original transaction.
053600200529     C                   IF        GHSUBS <> *BLANK
053700200529
053800200529     C     GHSUBS        SCAN      SedeScnFmt                             99
053900200529     C                   IF        *IN99
054000200529     C                   MOVE      'Y'           WSubDE1
054100200529     C                   ELSE
054200200529     C                   MOVE      'N'           WSubDE1
054300200529     C                   ENDIF
054400200529      *
054500200529      ** Do data substitution.
054600200529     C                   IF        WSubDE1 = 'Y'
054700200529     C                   EXSR      SRDtaSubs
054800200529     C                   ENDIF
054900200529
055000200529     C                   ENDIF
055100200529      *
055200200529      /COPY WNCPYSRC,SESEDEC012
055300200529      *
055400200529      ** Validate incoming Security Diary Event details.
055500200529     C                   EXSR      SRValDetails
055600200529      *
055700200529      /COPY WNCPYSRC,SESEDEC013
055800200529      *
055900200529      ** Check if amended fields are amendable.
056000200529     C                   EXSR      SRValAmend
056100200529      *
056200200529      ** Setup field DDNTCR
056300200529     C                   IF        CAS006 = 'Y'  AND
056400200529     C                             DDSDET = 'IR' AND
056500200529     C                             D1CPNN <> *ZEROS
056600200529     C                   EXSR      SRSetupDDNTCR
056700200529     C                   ENDIF
056800200529      /COPY WNCPYSRC,SESEDEC014
056900200529     C                   ENDSL
057000200529      *
057100200529     C     INVALID       TAG
057200200529
057300200529      *
057400200529      **Write to database
057500200529     C     UpdateYN      IFEQ      'Y'
057600200529     C     Idx           ANDEQ     0
057700200529     C     Idx           IFEQ      0
057800200529     C                   EXSR      SetupValid
057900200529     C                   EXSR      UpdateDB
058000200529     C                   ENDIF
058100200529     C                   ENDIF
058200200529
058300200529     C                   SETON                                        LR
058400200529     C     OKSDSN        IFEQ      'Y'
058500200529     C     OKSDED        ANDEQ     'Y'
058600200529     C     OKSDET        ANDEQ     'Y'
058700200529     C                   EVAL      OKFLDS = 'Y'
058800200529     C                   ENDIF
058900200529
059000200529      *
059100200529      **Remerge buffer with all relevant data structures
059200200529     C*************      EVAL      Buffer = SedeScnFmt +PPROT + RMFL                         BUG4258
059300200529     C                   EVAL      Buffer = SedeScnFmt                                       BUG4258
059400200529     C                                      + @TimeStamp                                     BUG4258
059500200529     C                                      +PPROT + RMFL                                    BUG4258
059600200529     C                                 + DDCUCR + DDSEXR +DDNTCR + OKFLDS
059700200529     C                   RETURN
059800200529      *
059900200529      *****************************************************************
060000200529      *
060100200529      ** Hook to enable non-core subroutines to be included
060200200529      /COPY WNCPYSRC,SESEDEC018
060300200529      *
060400200529      /EJECT
060500200529      *****************************************************************
060600200529      *                                                               *
060700200529      *  SRChkValMTran - Routine to check if valid security diary     *
060800200529      *                  events exist for security shortname, event   *
060900200529      *                  date and event type in the valid security    *
061000200529      *                  diary events file.                           *
061100200529      *                                                               *
061200200529      *****************************************************************
061300200529      *
061400200529     C     SRChkValMTran BEGSR
061500200529      *
061600200529      ** Convert event date into numeric format.
061700200529     C                   IF        DDSDED <> '999999'
061800200529     C                   EVAL      PDateIn = DDSDED
061900200529     C                   CALLB     'ZDATE1'
062000200529     C                   PARM                    PDateIn
062100200529     C                   PARM      *ZERO         PDaynoOut
062200200529     C                   PARM                    BJDFIN
062300200529     C                   PARM      *BLANK        PErrorFlag
062400200529
062500200529     C                   Z-ADD     PDaynoOut     WEvtDno
062600200529     C                   ELSE
062700200529     C                   Z-ADD     99999         WEvtDno
062800200529     C                   ENDIF
062900200529
063000200529     C                   ENDSR
063100200529      *
063200200529      *****************************************************************
063300200529      /EJECT
063400200529      *****************************************************************
063500200529      *                                                               *
063600200529      *  SRValAction - Routine to validate Action Code for the        *
063700200529      *                security shortname, event date and event type  *
063800200529      *                supplied                                       *
063900200529      *              - Original Security Diary Events details are     *
064000200529      *                retrieve during the validation process         *
064100200529      *                                                               *
064200200529      *****************************************************************
064300200529     C     SRValAction   BEGSR
064400200529     C                   EVAL      PMode = *BLANKS
064500200529
064600200529     C                   EVAL      WRDAY = BJRDNB
064700200529      *
064800200529      ** If CSC011 is present and CTL is still running in the support
064900200529      ** system, set the rundate to processing date in dtaara SC24X7,
065000200529      ** to be used by RTV module.
065100200529     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
065200200529     C                   EVAL      WRDAY = S1DATE
065300200529     C                   ENDIF
065400200529
065500200529     C                   CALLB     'SESEDERTV'
065600200529      *                             =========
065700200529      ** INPUT
065800200529      ** =====
065900200529
066000200529      *
066100200529      ** Retun Code
066200200529     C                   PARM      *BLANKS       RetCodeOut
066300200529      *
066400200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
066500200529      ** Mode = '      ' (Not Front Office Transaction Interface)
066600200529      ** Mode = '*RPR  ' (Repair function)
066700200529      ** Mode = '*SIN  ' (Screen input function)
066800200529     C                   PARM                    PMode
066900200529      *
067000200529      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
067100200529     C                   PARM                    APRESPMODE
067200200529      *
067300200529      ** Action Code
067400200529     C                   PARM                    DDACTN
067500200529      *
067600200529      ** Front office transaction identifier (20A from caller)
067700200529     C                   PARM                    APFOTRANID
067800200529      *
067900200529      ** Security Shortname
068000200529     C                   PARM                    DDSDSN
068100200529      *
068200200529      ** Event Date
068300200529     C                   PARM                    DDSDED
068400200529      *
068500200529      ** Event Type
068600200529     C                   PARM                    DDSDET
068700200529      *
068800200529      ** STANDING DATA
068900200529      ** =============
069000200529
069100200529      *
069200200529      ** SDBANK - Single Branch Code
069300200529     C                   PARM                    BJSBRC
069400200529      *
069500200529      ** SDBANK - Run day number
069600200529     C                   PARM                    WRDAY
069700200529      *
069800200529      ** SDBANK - Date format indicator
069900200529     C                   PARM                    BJDFIN
070000200529      *
070100200529      ** SDSTRD - Back value period
070200200529     C                   PARM                    BVBVP
070300200529      *
070400200529      ** ZMUSER - Default Branch
070500200529     C                   PARM                    PDBRN
070600200529      *
070700200529      ** SWITCHABLE FEATURES
070800200529      ** ===================
070900200529
071000200529      *
071100200529      ** SE Transaction Enhancement
071200200529     C                   PARM                    CSE010
071300200529      *
071400200529      ** value Ccy to be Ccy of Issuer Payment
071500200529     C                   PARM                    S01509
071600200529      *
071700200529      ** Coupon Fixing for Floating Rate Notes
071800200529     C                   PARM                    CSE031
071900200529                                                                                              CSE065
072000200529      ** Constant Yield Amortisation                                                          CSE065
072100200529     C                   PARM                    CSE065                                       CSE065
072200200529      *
072300200529      ** OUTPUT
072400200529      ** ======
072500200529
072600200529      *
072700200529      ** Error fields/message IDs/message data (arrays) from/to caller
072800200529     C                   PARM                    FldNameArr
072900200529     C                   PARM                    MsgIdArr
073000200529     C                   PARM                    MsgDtaArr
073100200529      *
073200200529      ** Array index (3P0) from/to caller
073300200529     C                   PARM                    IDx
073400200529      *
073500200529      ** Warning fields/message IDs/message data (arrays) from/to caller
073600200529     C                   PARM                    WFldNamArr
073700200529     C                   PARM                    WMsgIDArr
073800200529     C                   PARM                    WMsgDtaArr
073900200529      *
074000200529      ** Array index (3P0) from/to caller
074100200529     C                   PARM                    WIdx
074200200529      *
074300200529      ** OK Action Code
074400200529     C                   PARM                    OKACTN
074500200529      *
074600200529      ** OK Security Shortname
074700200529     C                   PARM                    OKSDSN
074800200529      *
074900200529      ** OK Event Date
075000200529     C                   PARM                    OKSDED
075100200529      *
075200200529      ** OK Event Type
075300200529     C                   PARM                    OKSDET
075400200529      *
075500200529      ** Security Diary Events retrieved from file - file format
075600200529     C                   PARM                    SedeFilFmt
075700200529      *
075800200529      ** Externally described DS for security details
075900200529     C                   PARM                    PSectyd
076000200529      *
076100200529      ** Processing type from PF/INVTPD
076200200529     C                   PARM                    PPROT
076300200529      *
076400200529      ** Event date (Day Number)
076500200529     C                   PARM                    PEvtDno
076600200529      *
076700200529      ** Redisplay screen
076800200529     C                   PARM      *BLANK        PReDsp
076900200529
077000200529     C                   ENDSR
077100200529      *
077200200529      *****************************************************************
077300200529      /EJECT
077400200529      *****************************************************************
077500200529      *                                                               *
077600200529      *  SRValDetails - Routine to validate Security Diary Events Det.*
077700200529      *               - Amended file fields (for update) are set up   *
077800200529      *                 during the validation process                 *
077900200529      *                                                               *
078000200529      *****************************************************************
078100200529     C     SRValDetails  BEGSR
078200200529      *
078300200529      ** Move Security Diary Event details retrieved from the midas
078400200529      ** database file into the update file record.  If no
078500200529      ** record has been retrieved (i.e. in Insert), fields
078600200529      ** contain initial values (zeros, blanks).
078700200529     C**********         MOVEL     SedeFilFmt    Sede1FilFmt                                  CSE065
078800200529     C**********         MOVEL     SedeFilFmt1   Sede1FilFmt1                          CSE065 237063
078900200529     C                   MOVEL     SedeFilFmt    Sede1FilFmt                                  237063
079000200529      *                                                                                       CSE065
079100200529     C                   IF        CSE065 = 'Y'                                               CSE065
079200200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
079300200529     C                   ELSE                                                                 CSE065
079400200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
079500200529     C                   ENDIF                                                                CSE065
079600200529      *
079700200529      ** Setup defaults on screen 1.
079800200529     C                   EXSR      SRDefault1
079900200529      *
080000200529      ** Validate screen 1 details.
080100200529     C                   EXSR      SRVScrn1
080200200529
080300200529     C     EValDetails   ENDSR
080400200529      *
080500200529      *****************************************************************
080600200529      /EJECT
080700200529      *****************************************************************
080800200529      *                                                               *
080900200529      *  SRDefault1 - Defaulting for screen 1                         *
081000200529      *                                                               *
081100200529      *****************************************************************
081200200529     C     SRDefault1    BEGSR
081300200529
081400200529     C                   CALLB     'SESEDE1DT'
081500200529      *
081600200529      ** INPUT
081700200529      ** =====
081800200529      *
081900200529      ** Return code
082000200529     C                   PARM      *BLANKS       RetCodeOut
082100200529      *
082200200529      ** SE Diary events retrieved from file - file format
082300200529     C                   PARM                    SedeFilFmt
082400200529      *
082500200529      ** Externally described DS for security details
082600200529     C                   PARM                    PSectyd
082700200529      *
082800200529      ** Event date (Day Number)
082900200529     C                   PARM                    PEvtDno
083000200529      *
083100200529      ** STANDING DATA
083200200529      ** =============
083300200529      *
083400200529      ** SDBANK - Date format indicator
083500200529     C                   PARM                    BJDFIN
083600200529      *
083700200529      ** MMODF - Strategic risk management indicator
083800200529     C                   PARM                    RMFL
083900200529      *
084000200529      ** SWITCHABLE FEATURES
084100200529      ** ===================
084200200529      *
084300200529      ** Dividend payments
084400200529     C                   PARM                    S01510
084500200529      *
084600200529      ** Value currency to be currency of issuer payments
084700200529     C                   PARM                    S01509
084800200529                                                                                              CSE065
084900200529     C                   PARM                    CSE065                                       CSE065
085000200529                                                                                              CGL031
085100200529      ** Taxation on Savings Income                                                           CGL031
085200200529                                                                                              CGL031
085300200529     C                   PARM                    CGL031                                       CGL031
085400200529      *
085500200529      ** OUTPUT
085600200529      ** ======
085700200529      *
085800200529      ** SE Diary events screen details from incoming transaction
085900200529      ** - screen format
086000200529     C                   PARM                    SedeScnFmt
086100200529      *
086200200529      ** Pay currency
086300200529     C                   PARM                    PPayCcy
086400200529      *
086500200529      ** Cumulative coupon rate
086600200529     C                   PARM                    DDCUCR
086700200529      *
086800200529      ** Current exchange rate
086900200529     C                   PARM                    DDSEXR
087000200529                                                                                              CSE065
087100200529     C                   PARM                    DDMATY                                       CSE065
087200200529
087300200529     C                   ENDSR
087400200529      *
087500200529      *****************************************************************
087600200529      /EJECT
087700200529      *****************************************************************
087800200529      *                                                               *
087900200529      *  SRVScrn1  - Validate screen 1 details                        *
088000200529      *                                                               *
088100200529      *****************************************************************
088200200529     C     SRVScrn1      BEGSR
088300200529
088400200529     C                   CALLB     'SESEDE1VL'
088500200529      *
088600200529      ** INPUT
088700200529      ** =====
088800200529      *
088900200529      ** Return Code
089000200529     C                   PARM      *BLANKS       RetCodeOut
089100200529      *
089200200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
089300200529      ** Mode = '      ' (Not Front Office Transaction Interface)
089400200529      ** Mode = '*RPR  ' (Repair function)
089500200529      ** Mode = '*SIN  ' (Screen Input function)
089600200529     C                   PARM                    PMode
089700200529      *
089800200529      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
089900200529     C                   PARM                    APRESPMODE
090000200529      *
090100200529      ** SE Diary Events screen details from incoming
090200200529      ** transaction - screen format
090300200529     C                   PARM                    SedeScnFmt
090400200529      *
090500200529      ** Security Diary Events retrieved from file - file format
090600200529     C                   PARM                    SedeFilFmt
090700200529      *
090800200529      ** Externally described DS for security details
090900200529     C                   PARM                    PSectyd
091000200529      *
091100200529      ** Processing type from PF/INVTPD
091200200529     C                   PARM                    PPROT
091300200529      *
091400200529      ** Event date (Day Number)
091500200529     C                   PARM                    PEvtDno
091600200529      *
091700200529      ** STANDING DATA
091800200529      ** =============
091900200529      *
092000200529      ** SDBANK - Date Format Indicator
092100200529     C                   PARM                    BJDFIN
092200200529                                                                                              CSE065
092300200529      ** SDBANK - Rundate                                                                     CSE065
092400200529     C                   PARM                    BJRDNB                                       CSE065
092500200529      *
092600200529      ** MMODF - Strategic risk management indicator
092700200529     C                   PARM                    RMFL
092800200529      *
092900200529      ** SWITCHABLE FEATURES
093000200529      ** ===================
093100200529      *
093200200529      ** SE Transactions Enhancement
093300200529     C                   PARM                    CSE010
093400200529      *
093500200529      ** Value CCY to be CCY of Issuer Payment
093600200529     C                   PARM                    S01509
093700200529      *
093800200529      ** Dividend Payments Base on EX-Date
093900200529     C                   PARM                    S01510
094000200529
094100200529      ** Hedge Accounting Phase B
094200200529     C                   PARM                    CAS006
094300200529                                                                                              CSE072
094400200529      ** Brazilian C Bonds                                                                    CSE072
094500200529     C                   PARM                    CSE072                                       CSE072
094600200529                                                                                              CSE065
094700200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
094800200529     C                   PARM                    CSE065                                       CSE065
094900200529                                                                                              CGL031
095000200529      ** Taxation on Savings Income                                                           CGL031
095100200529                                                                                              CGL031
095200200529     C                   PARM                    CGL031                                       CGL031
095300200529      *
095400200529      ** OUTPUT
095500200529      ** ======
095600200529      *
095700200529      ** Error fields/message IDs/message data (arrays) from/to caller
095800200529     C                   PARM                    FldNameArr
095900200529     C                   PARM                    MsgIdArr
096000200529     C                   PARM                    MsgDtaArr
096100200529      *
096200200529      ** Array index (3P0) from/to caller
096300200529     C                   PARM                    IDx
096400200529      *
096500200529      ** Warning flds/message IDs/message data (arrays) from/to caller
096600200529     C                   PARM                    WFldNamArr
096700200529     C                   PARM                    WMsgIdArr
096800200529     C                   PARM                    WMsgDtaArr
096900200529      *
097000200529      ** Array index (3P0) from/to caller
097100200529     C                   PARM                    WIDx
097200200529      *
097300200529      ** SE Diary Events screen error indicators
097400200529     C                   PARM                    SEESEDE
097500200529      *
097600200529      ** SE Diary Events for file update - file format
097700200529     C                   PARM                    Sede1FilFmt
097800200529      *
097900200529      ** Redisplay screen
098000200529     C                   PARM      *BLANK        PReDsp
098100200529
098200200529     C                   ENDSR
098300200529      *
098400200529      *****************************************************************
098500200529      /EJECT
098600200529      *****************************************************************
098700200529      *                                                               *
098800200529      *  SRCvtSeDE - Convert security diary events details from file  *
098900200529      *              to screen format                                 *
099000200529      *                                                               *
099100200529      *****************************************************************
099200200529     C     SRCvtSeDE     BEGSR
099300200529
099400200529     C                   CALLB     'SESEDECVT'
099500200529      *                             =========
099600200529      ** INPUT
099700200529      ** =====
099800200529      *
099900200529      ** Return code
100000200529     C                   PARM      *BLANKS       RetCodeOut
100100200529      *
100200200529      ** SE Diary events retrieved from file - file format
100300200529     C                   PARM                    SedeFilFmt
100400200529      *
100500200529      ** Externally described DS for security details
100600200529     C                   PARM                    PSectyd
100700200529      *
100800200529      ** Processing type from PF/INVTPD
100900200529     C                   PARM                    PPROT
101000200529      *
101100200529      ** Action code
101200200529     C                   PARM                    DDACTN
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
102600200529      ** Value currency to be currency of issuer payments
102700200529     C                   PARM                    S01509
102800200529      *
102900200529      ** Dividend payments
103000200529     C                   PARM                    S01510
103100200529
103200200529      ** Hedge Accounting Phase B
103300200529     C                   PARM                    CAS006
103400200529      *
103500200529      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
103600200529     C                   PARM                    CSE065                                       CSE065
103700200529      *                                                                                       CSE065
103800200529                                                                                              CGL031
103900200529      ** Taxation on Savings Income                                                           CGL031
104000200529                                                                                              CGL031
104100200529     C                   PARM                    CGL031                                       CGL031
104200200529      ** OUTPUT
104300200529      ** ======
104400200529      *
104500200529      ** SE Diary events screen details from incoming transaction
104600200529      ** - screen format
104700200529     C                   PARM                    Sede1ScnFmt
104800200529
104900200529     C                   ENDSR
105000200529      *
105100200529      *****************************************************************
105200200529      /EJECT
105300200529      *****************************************************************
105400200529      *                                                               *
105500200529      *  SRDtaSubs - Data Substitution Routine                        *
105600200529      *                                                               *
105700200529      *****************************************************************
105800200529      *
105900200529     C     SRDtaSubs     BEGSR
106000200529      *
106100200529      ** Substitute the data for the various parts of the transaction.
106200200529      *
106300200529     C                   IF        WSUBDE1 = 'Y'
106400200529     C                   CLEAR                   PIncData
106500200529     C                   CLEAR                   PCurData
106600200529
106700200529     C                   CALLB     'APDTASUBS'
106800200529      *                             =========
106900200529      ** Return code
107000200529     C                   PARM      *BLANKS       RetCodeOut
107100200529      *
107200200529      ** Substitution character
107300200529     C                   PARM                    GHSUBS
107400200529      *
107500200529      ** Incoming data
107600200529     C                   PARM      SedeScnFmt    PIncData
107700200529      *
107800200529      ** Current data
107900200529     C                   PARM      Sede1ScnFmt   PCurData
108000200529
108100200529     C                   MOVEL     PIncData      SedeScnFmt
108200200529     C                   ENDIF
108300200529
108400200529     C                   ENDSR
108500200529      *
108600200529      *****************************************************************
108700200529      /EJECT
108800200529      *****************************************************************
108900200529      *                                                               *
109000200529      *  SRValAmend - Routine to check whether the fields are         *
109100200529      *               amendable                                       *
109200200529      *             - This subroutine calls a procedure which checks  *
109300200529      *               whether it is valid to amend the fields which   *
109400200529      *               have been altered.  To determine what fields    *
109500200529      *               have been changed, the current fields on file   *
109600200529      *               must be converted first to their screen formats.*
109700200529      *               These fields are then compared with the fields  *
109800200529      *               on the input transaction.  Any errors detected  *
109900200529      *               by the called procedure take precedence over    *
110000200529      *               any errors found during the validation of the   *
110100200529      *               transaction.  The errors from the called        *
110200200529      *               procedure are kept separately and if any are    *
110300200529      *               found, these errors will REPLACE the normal     *
110400200529      *               validation errors.                              *
110500200529      *                                                               *
110600200529      *****************************************************************
110700200529     C     SRValAmend    BEGSR
110800200529
110900200529     C                   CALLB     'SESEDE1MD'
111000200529      *
111100200529      ** INPUT
111200200529      ** =====
111300200529      *
111400200529      ** Return code
111500200529     C                   PARM      *BLANKS       RetCodeOut
111600200529      *
111700200529      ** SE Diary events screen details from incoming transaction
111800200529      ** - screen format
111900200529     C                   PARM                    SedeScnFmt
112000200529      *
112100200529      ** SE Diary events screen details retrieved from file
112200200529      ** - screen format
112300200529     C                   PARM                    Sede1ScnFmt
112400200529      *
112500200529      ** SE Diary events retrieved from file - file format
112600200529     C                   PARM                    SedeFilFmt
112700200529      *
112800200529      ** Reset of fields in error required (Y/N)
112900200529     C                   PARM      'N'           PResetFld
113000200529      *
113100200529      ** Pay currency
113200200529     C                   PARM                    PPayCcy
113300200529      *
113400200529      ** STANDING DATA
113500200529      ** =============
113600200529      *
113700200529      ** MMODF - Strategic risk management indicator
113800200529     C                   PARM                    RMFL
113900200529      *
114000200529      ** SWITCHABLE FEATURES
114100200529      ** ===================
114200200529      *
114300200529      ** Value currency to be currency of issuer payments
114400200529     C                   PARM                    S01509
114500200529      *
114600200529      ** Dividend payments
114700200529     C                   PARM                    S01510
114800200529
114900200529      ** Hedge Accounting Phase B
115000200529     C                   PARM                    CAS006
115100200529      *
115200200529      ** OUTPUT
115300200529      ** ======
115400200529      *
115500200529      ** Error fields/message Ids/message data (arrays) from/to caller
115600200529     C                   PARM                    AMFldNamAr
115700200529     C                   PARM                    AMMsgIdArr
115800200529     C                   PARM                    AMMsgDtaAr
115900200529      *
116000200529      ** Array index (3P0) from/to caller
116100200529     C                   PARM                    AMIDx
116200200529      *
116300200529      ** SE Diary events screen error indicators
116400200529     C                   PARM                    SEESEDE
116500200529      *
116600200529      ** OK Amendments field
116700200529     C                   PARM                    PAmendOK
116800200529      *
116900200529      ** If errors occurred, overwrite previous error information.
117000200529      *
117100200529     C                   IF        AMIDx <> 0
117200200529     C                   MOVEA     AMFldNamAr    FldNameArr
117300200529     C                   MOVEA     AMMsgIdArr    MsgIdArr
117400200529     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
117500200529     C                   Z-ADD     AMIDx         IDx
117600200529     C                   ENDIF
117700200529      *
117800200529     C                   ENDSR
117900200529      *
118000200529      *****************************************************************
118100200529      /EJECT
118200200529      *****************************************************************
118300200529      *                                                               *
118400200529      *  SetupValid - Routine to set up fields in the valid file      *
118500200529      *               record.                                         *
118600200529      *                                                               *
118700200529      *****************************************************************
118800200529      *
118900200529     C     SetupValid    BEGSR
119000200529      *
119100200529      ** Action is delete.
119200200529      ** =================
119300200529      *
119400200529     C                   IF        DDACTN = 'D'
119500200529      *
119600200529      ** Move security diary events details retrieved from file
119700200529      ** directly to the valid record data structure.
119800200529     C**********         EVAL      Sede1FilFmt= SedeFilFmt                                    CSE065
119900200529     C**********         EVAL      Sede1FilFmt1 = SedeFilFmt1                          CSE065 237063
120000200529     C                   EVAL      Sede1FilFmt= SedeFilFmt                                    237063
120100200529      *                                                                                       260191
120200200529      ** If Record Id is 'D', reset SDDT to zero                                              260191
120300200529      *                                                                                       260191
120400200529     C                   IF        S2RECI = 'D'                                               260191
120500200529     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                             260191
120600200529     C                               OR S2SDET = 'PP'                                         260191
120700200529     C                   Z-ADD     0             S2SDDT                                       260191
120800200529     C                   ENDIF                                                                260191
120900200529      *                                                                                      260191A
121000200529     C                   ELSE                                                                260191A
121100200529     C                   IF        S2RECI = 'M'                                              260191A
121200200529     C                   MOVE      'N'           NOTALL            1                         260191A
121300200529     C     S2SDSN        SETLL     POSETDF                                                   260191A
121400200529     C     S2SDSN        READE     POSETDF                                02                 260191A
121500200529     C                   DOW       NOT *IN02                                                 260191A
121600200529      *                                                                                      260191A
121700200529     C     S2SDET        IFEQ      'MP'                                                      260191A
121800200529     C     S2SDET        OREQ      'DV'                                                      260191A
121900200529     C     S01512        ANDNE     'Y'                                                       260191A
122000200529     C                   Z-ADD     S2SDPD        WWPDUD            5 0                       260191A
122100200529     C                   ELSE                                                                260191A
122200200529     C                   Z-ADD     S2SDED        WWPDUD                                      260191A
122300200529     C                   ENDIF                                                               260191A
122400200529      *                                                                                      260191A
122500200529     C                   IF        S2SDET = F3PEVT and WWPDUD = F3PDUD                       260191A
122600200529     C                             AND F3RECI = 'M'                                          260191A
122700200529     C                   MOVE      'Y'           NOTALL                                      260191A
122800200529     C                   ENDIF                                                               260191A
122900200529      *                                                                                      260191A
123000200529     C     S2SDSN        READE     POSETDF                                02                 260191A
123100200529     C                   ENDDO                                                               260191A
123200200529      *                                                                                      260191A
123300200529     C                   IF        NOTALL = 'N'                                              260191A
123400200529     C                   Z-ADD     0             S2SDDT                                      260191A
123500200529     C                   ENDIF                                                               260191A
123600200529     C                   ENDIF                                                               260191A
123700200529      *                                                                                      260191A
123800200529     C                   ENDIF                                                                260191
123900200529      *                                                                                       CSE065
124000200529     C                   IF        CSE065 = 'Y'                                               CSE065
124100200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
124200200529     C                   ELSE                                                                 CSE065
124300200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
124400200529     C                   ENDIF                                                                CSE065
124500200529      *                                                                                     MD037742
124600200529      ** If Record Id is 'D', reset SDDT to zero                                            MD037742
124700200529      *                                                                                     MD037742
124800200529     C                   IF        S2RECI = 'D'                                             MD037742
124900200529     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                           MD037742
125000200529     C                               OR S2SDET = 'PP'                                       MD037742
125100200529     C                   Z-ADD     0             S2SDDT                                     MD037742
125200200529     C                   ENDIF                                                              MD037742
125300200529     C                   ENDIF                                                              MD037742
125400200529      *                                                                                     MD037742
125500200529      *
125600200529      ** Record Id - update to 'C'.
125700200529     C                   EVAL      S2RECI = 'C'
125800200529     C                   ENDIF
125900200529      *
126000200529      ** Action is enquire.
126100200529      ** ==================
126200200529     C                   IF        DDACTN = 'E'
126300200529      *
126400200529      ** Move security diary events details retrieved from file
126500200529      ** directly to the valid record data structure.
126600200529     C**********         EVAL      Sede1FilFmt= SedeFilFmt                                    CSE065
126700200529     C**********         EVAL      Sede1FilFmt1 = SedeFilFmt1                          CSE065 237063
126800200529     C                   EVAL      Sede1FilFmt= SedeFilFmt                                    237063
126900200529      *                                                                                       CSE065
127000200529     C                   IF        CSE065 = 'Y'                                               CSE065
127100200529     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
127200200529     C                   ELSE                                                                 CSE065
127300200529     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
127400200529     C                   ENDIF                                                                CSE065
127500200529     C                   ENDIF
127600200529      *
127700200529      ** Action is insert.
127800200529      ** =================
127900200529     C                   IF        DDACTN = 'I'
128000200529      *
128100200529      ** Record Id.
128200200529     C                   EVAL      S2RECI = 'D'
128300200529      *
128400200529      ** Nominal currency.
128500200529     C                   EVAL      S2NMCY = D1NMCY
128600200529      *
128700200529     C                   ENDIF
128800200529      *
128900200529      ** Security shortname
129000200529     C                   EVAL      S2SDSN = DDSDSN
129100200529      *
129200200529      ** Event Date
129300200529     C                   EVAL      S2SDED = WEvtDno
129400200529      *
129500200529      ** Event Type
129600200529     C                   EVAL      S2SDET = DDSDET
129700200529      *
129800200529      ** Last change type
129900200529     C                   EVAL      S2CHTP = DDACTN
130000200529                                                                                             BUG4258
130100200529      * Restore Timestamp from the original record                                           BUG4258
130200200529     C                   IF        DDACTN <> 'I'                                             BUG4258
130300200529     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
130400200529     C                   MOVEL     @TimeStamp    S2TMST                                      BUG4258
130500200529     C                   ENDIF                                                               BUG4258
130600200529      *
130700200529      /COPY WNCPYSRC,SESEDEC019
130800200529      *
130900200529     C                   ENDSR
131000200529      *
131100200529      *****************************************************************
131200200529      /EJECT
131300200529      *****************************************************************
131400200529      *                                                               *
131500200529      * UPDATEDB - Update database                                    *
131600200529      *                                                               *
131700200529      *****************************************************************
131800200529
131900200529     C     UPDATEDB      BEGSR
132000200529      *
132100200529      ** Update file.
132200200529     C                   CALLB     'SESEDEUPD'
132300200529      *                             =========
132400200529      ** INPUT
132500200529      ** =====
132600200529      *
132700200529      ** Return code
132800200529     C                   PARM      *BLANKS       RetCodeOut
132900200529      *
133000200529      ** SE Diary events for file update - file format
133100200529     C                   PARM                    Sede1FilFmt
133200200529      *
133300200529      ** STANDING DATA
133400200529      ** =============
133500200529      *
133600200529      ** SDBANK - Single branch code
133700200529     C                   PARM                    BJSBRC
133800200529      *
133900200529      ** SDBANK - Run day number
134000200529     C                   PARM                    BJRDNB
134100200529      *
134200200529      ** SDBANK - Date format indicator
134300200529     C                   PARM                    BJDFIN
134400200529      *
134500200529      ** SDSTRD - Back value period
134600200529     C                   PARM                    BVBVP
134700200529      *
134800200529      ** ZMUSER - Default branch
134900200529     C                   PARM                    PDBRN
135000200529      *
135100200529      ** SWITCHABLE FEATURES
135200200529      ** ===================
135300200529      *
135400200529      ** SE Transaction enhancement
135500200529     C                   PARM                    CSE010
135600200529      *
135700200529      ** Value currency to be currency of issuer payments
135800200529     C                   PARM                    S01509
135900200529      *
136000200529      ** Coupon Fixing for Floating Rate Notes
136100200529     C                   PARM                    CSE031
136200200529                                                                                              CSE065
136300200529     C                   PARM                    CSE065                                       CSE065
136400200529      *
136500200529      ** If errors occurred on update, rollback uncommitted file
136600200529      ** changes.
136700200529     C                   IF        RetCodeOut <> *BLANKS AND
136800200529     C                             RetCodeOut <> '*RECUPD'
136900200529     C                   MOVEL     '0'           APIRetc
137000200529     C                   ROLBK
137100200529     C                   EXSR      *PSSR
137200200529
137300200529     C                   ELSE
137400200529     C                   If        (CSC022 <> 'Y')
137500200529     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')
137600200529     C                   COMMIT
137700200529     C                   EndIf
137800200529     C                   EndIf
137900200529      *
138000200529      ** If update not done due to record being updated by another
138100200529      ** workstation, display message "The last transaction was not
138200200529      ** applied to the database." to the next screen.
138300200529     C                   IF        RetCodeOut = '*RECUPD'
138400200529     C                   Z-ADD     1             IDx
138500200529     C                   Eval      FldNameArr(IDx) = '*ANY'
138600200529     C                   Eval      MsgIdArr(IDx) = 'APM1000'
138700200529     C                   ENDIF
138800200529     C                   ENDSR
138900200529      *****************************************************************
139000200529      *                                                               *
139100200529      *  SRSetupDDNTCR - Routine to setup DDNTCR field.               *
139200200529      *                                                               *
139300200529      *                                                               *
139400200529      *****************************************************************
139500200529      *
139600200529     C     SRSetupDDNTCR BEGSR
139700200529     C                   EVAL      DDNTCR = *BLANKS
139800200529     C                   EVAL      ZField = *BLANKS
139900200529     C                   MOVE      D1CPNN        ZField
140000200529     C                   EVAL      ZADec = 7
140100200529     C                   CALLB     'ZEDIT'
140200200529     C                   PARM                    ZField
140300200529     C                   PARM                    ZADec
140400200529     C                   EVAL      DDNTCR = ZField
140500200529
140600200529     C                   ENDSR
140700200529      *****************************************************************
140800200529      /EJECT
140900200529      *****************************************************************
141000200529      *                                                               *
141100200529      *  SRResetFld - Routine to reset fields                         *
141200200529      *                                                               *
141300200529      *****************************************************************
141400200529     C     SRResetFld    BEGSR
141500200529
141600200529     C                   RESET                   FldNameArr
141700200529     C                   RESET                   MsgIdArr
141800200529     C                   RESET                   MsgDtaArr
141900200529     C                   RESET                   IDx
142000200529
142100200529     C                   RESET                   WFldNamArr
142200200529     C                   RESET                   WMsgIdArr
142300200529     C                   RESET                   WMsgDtaArr
142400200529     C                   RESET                   WIDx
142500200529
142600200529     C                   RESET                   AMFldNamAr
142700200529     C                   RESET                   AMMsgIdArr
142800200529     C                   RESET                   AMMsgDtaAr
142900200529     C                   RESET                   AMIDx
143000200529
143100200529     C                   RESET                   FldNoArr
143200200529
143300200529     C                   MOVE      *ALL'Y'       SEESEDE
143400200529
143500200529     C                   CLEAR                   Sede1ScnFmt
143600200529
143700200529     C                   ENDSR
143800200529      *
143900200529      *****************************************************************
144000200529
144100200529      *****************************************************************
144200200529      /EJECT
144300200529      *****************************************************************
144400200529      *                                                               *
144500200529      *  *INZSR - Program Initialisation                              *
144600200529      *         - This subroutine runs automatically for program      *
144700200529      *           initialisation.                                     *
144800200529      *                                                               *
144900200529      *****************************************************************
145000200529      *
145100200529     C     *INZSR        BEGSR
145200200529      *
145300200529     C     *ENTRY        PLIST
145400200529      *
145500200529      ** Common header information (DS) from source system
145600200529     C                   PARM                    PHeadIn
145700200529      *
145800200529      ** Incoming transaction details
145900200529     C                   PARM                    PTrans5001
146000200529      *
146100200529      ** Incoming transaction extra data
146200200529     C                   PARM                    PExtData500
146300200529      *
146400200529      ** Error information
146500200529     C                   PARM                    FldNameArr
146600200529     C                   PARM                    MsgIDArr
146700200529     C                   PARM                    MsgDtaArr
146800200529      *
146900200529      ** Warning Error information
147000200529     C                   PARM                    WFldNamArr
147100200529     C                   PARM                    WMsgIDArr
147200200529     C                   PARM                    WMsgDtaArr
147300200529      *
147400200529      ** Message File
147500200529     C                   PARM                    MsgFArray
147600200529      *
147700200529      ** Update Transaction
147800200529     C                   PARM                    UpdateYN          1
147900200529      *
148000200529      ** Output Buffer
148100200529     C                   PARM                    Buffer         6000
148200200529      *
148300200529      ** API Return Code
148400200529     C                   PARM                    APIRetc           1
148500200529     C                   PARM                    @TimeStamp       26                         BUG4258
148600200529      *
148700200529      ** Set up the name of the module Id used to make the transaction
148800200529      ** number unique.
148900200529     C                   EVAL      PModuleId = 'SE'
149000200529      *
149100200529      ** Set up the name of the primary and secondary message files from
149200200529      ** which the message handler will get the messages.
149300200529     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
149400200529     C                   EVAL      MsgFArray(2) = 'DRSMM'
149500200529     C                   EVAL      MsgFArray(3) = 'MEMSG'
149600200529      *
149700200529      ** Set up the name of the server/database updater data queue.
149800200529     C                   EVAL      DTAQNAME = 'APSEDEDTQ'
149900200529      *
150000200529      ** Access bank details.
150100200529     C                   CALLB     'AOBANKR0'
150200200529     C                   PARM      *BLANKS       PRTCD
150300200529     C                   PARM      '*FIRST '     POPTN
150400200529     C     SDBANK        PARM      SDBANK        DSFDY
150500200529      *
150600200529      ** Database error.
150700200529     C                   IF        PRTCD <> *BLANKS
150800200529     C     *LOCK         IN        LDA
150900200529     C                   EVAL      DBKEY = POPTN
151000200529     C                   EVAL      DBFILE = 'SDBANKPD'
151100200529     C                   EVAL      DBASE = 1
151200200529     C                   OUT       LDA
151300200529     C                   EXSR      *PSSR
151400200529     C                   ENDIF
151500200529      *
151600200529      ** Access API ICD details.
151700200529     C                   CALLB     'AOAPIR0'
151800200529     C                   PARM      *BLANKS       PRTCD
151900200529     C                   PARM      '*FIRST '     POPTN
152000200529     C     SDAPI         PARM      SDAPI         DSFDY
152100200529      *
152200200529      ** Database error.
152300200529     C                   IF        PRTCD <> *BLANKS
152400200529     C     *LOCK         IN        LDA
152500200529     C                   EVAL      DBKEY = POPTN
152600200529     C                   EVAL      DBFILE = 'SDAPIPD'
152700200529     C                   EVAL      DBASE = 2
152800200529     C                   OUT       LDA
152900200529     C                   EXSR      *PSSR
153000200529     C                   ENDIF
153100200529      *
153200200529      ** Retrieve ICD for securities trading.
153300200529     C                   CALLB     'AOSTRDR0'
153400200529     C                   PARM      *BLANKS       PRTCD
153500200529     C                   PARM      '*FIRST '     POPTN
153600200529     C     SDSTRD        PARM      SDSTRD        DSSDY
153700200529      *
153800200529      ** Database error.
153900200529     C                   IF        PRTCD <> *BLANKS
154000200529     C     *LOCK         IN        LDA
154100200529     C                   EVAL      DBKEY = POPTN
154200200529     C                   EVAL      DBFILE = 'SDSTRDPD'
154300200529     C                   EVAL      DBASE = 3
154400200529     C                   OUT       LDA
154500200529     C                   EXSR      *PSSR
154600200529     C                   ENDIF
154700200529      *
154800200529      ** Access SAR file to determine if CSE010
154900200529      ** (SE Transaction Enhancement) is installed.
155000200529     C                   CALLB     'AOSARDR0'
155100200529     C                   PARM      *BLANKS       PRTCD
155200200529     C                   PARM      '*VERIFY'     POPTN
155300200529     C                   PARM      'CSE010'      PSARD
155400200529     C     SCSARD        PARM      SCSARD        DSFDY
155500200529      *
155600200529      ** An NRF (No Record Found) return code is valid.
155700200529      ** Issue database error only for error return codes.
155800200529     C                   IF        PRTCD <> *BLANKS AND
155900200529     C                             PRTCD <> '*NRF   '
156000200529     C     *LOCK         IN        LDA
156100200529     C                   EVAL      DBKEY = 'CSE010'
156200200529     C                   EVAL      DBFILE = 'SCSARDPD'
156300200529     C                   EVAL      DBASE = 4
156400200529     C                   OUT       LDA
156500200529     C                   EXSR      *PSSR
156600200529     C                   ENDIF
156700200529
156800200529     C                   IF        PRTCD = *BLANKS
156900200529     C                   EVAL      CSE010 = 'Y'
157000200529     C                   ELSE
157100200529     C                   EVAL      CSE010 = 'N'
157200200529     C                   ENDIF
157300200529      *
157400200529      ** Access SAR file to determine if S01509
157500200529      ** (Value Ccy to be Ccy of Issuer Payment) is installed.
157600200529     C                   CALLB     'AOSARDR0'
157700200529     C                   PARM      *BLANKS       PRTCD
157800200529     C                   PARM      '*VERIFY'     POPTN
157900200529     C                   PARM      'S01509'      PSARD
158000200529     C     SCSARD        PARM      SCSARD        DSFDY
158100200529      *
158200200529      ** An NRF (No Record Found) return code is valid.
158300200529      ** Issue database error only for error return codes.
158400200529     C                   IF        PRTCD <> *BLANKS AND
158500200529     C                             PRTCD <> '*NRF   '
158600200529     C     *LOCK         IN        LDA
158700200529     C                   EVAL      DBKEY = 'S01509'
158800200529     C                   EVAL      DBFILE = 'SCSARDPD'
158900200529     C                   EVAL      DBASE = 5
159000200529     C                   OUT       LDA
159100200529     C                   EXSR      *PSSR
159200200529     C                   ENDIF
159300200529
159400200529     C                   IF        PRTCD = *BLANKS
159500200529     C                   EVAL      S01509 = 'Y'
159600200529     C                   ELSE
159700200529     C                   EVAL      S01509 = 'N'
159800200529     C                   ENDIF
159900200529      *
160000200529      ** Access SAR file to determine if S01510
160100200529      ** (Dividend Payments) is installed.
160200200529     C                   CALLB     'AOSARDR0'
160300200529     C                   PARM      *BLANKS       PRTCD
160400200529     C                   PARM      '*VERIFY'     POPTN
160500200529     C                   PARM      'S01510'      PSARD
160600200529     C     SCSARD        PARM      SCSARD        DSFDY
160700200529      *
160800200529      ** An NRF (No Record Found) return code is valid.
160900200529      ** Issue database error only for error return codes.
161000200529     C                   IF        PRTCD <> *BLANKS AND
161100200529     C                             PRTCD <> '*NRF   '
161200200529     C     *LOCK         IN        LDA
161300200529     C                   EVAL      DBKEY = 'S01510'
161400200529     C                   EVAL      DBFILE = 'SCSARDPD'
161500200529     C                   EVAL      DBASE = 6
161600200529     C                   OUT       LDA
161700200529     C                   EXSR      *PSSR
161800200529     C                   ENDIF
161900200529
162000200529     C                   IF        PRTCD = *BLANKS
162100200529     C                   EVAL      S01510 = 'Y'
162200200529     C                   ELSE
162300200529     C                   EVAL      S01510 = 'N'
162400200529     C                   ENDIF
162500200529      *
162600200529      ** Access SAR file to determine if CSE031
162700200529      ** (Coupon Fixing for Floating Rate Notes) is installed.
162800200529     C                   CALLB     'AOSARDR0'
162900200529     C                   PARM      *BLANKS       PRTCD
163000200529     C                   PARM      '*VERIFY'     POPTN
163100200529     C                   PARM      'CSE031'      PSARD
163200200529     C     SCSARD        PARM      SCSARD        DSFDY
163300200529      *
163400200529      ** An NRF (No Record Found) return code is valid.
163500200529      ** Issue database error only for error return codes.
163600200529     C                   IF        PRTCD <> *BLANKS AND
163700200529     C                             PRTCD <> '*NRF   '
163800200529     C     *LOCK         IN        LDA
163900200529     C                   EVAL      DBKEY = 'CSE031'
164000200529     C                   EVAL      DBFILE = 'SCSARDPD'
164100200529     C                   EVAL      DBASE = 7
164200200529     C                   OUT       LDA
164300200529     C                   EXSR      *PSSR
164400200529     C                   ENDIF
164500200529
164600200529     C                   IF        PRTCD = *BLANKS
164700200529     C                   EVAL      CSE031 = 'Y'
164800200529     C                   ELSE
164900200529     C                   EVAL      CSE031 = 'N'
165000200529     C                   ENDIF
165100200529      *
165200200529      ** Access SAR file to determine if 'Hedge Accounting
165300200529      ** Phase B(CAS006)' is installed.
165400200529     C                   CALLB     'AOSARDR0'
165500200529     C                   PARM      *BLANKS       PRTCD
165600200529     C                   PARM      '*VERIFY'     POPTN
165700200529     C                   PARM      'CAS006'      PSARD
165800200529     C     SCSARD        PARM      SCSARD        DSFDY
165900200529      *
166000200529      ** An NRF (No Record Found) return code is valid.
166100200529      ** Issue database error only for error return codes.
166200200529     C                   IF        PRTCD <> *BLANKS AND
166300200529     C                             PRTCD <> '*NRF   '
166400200529     C     *LOCK         IN        LDA
166500200529     C                   EVAL      DBKEY = 'CAS006'
166600200529     C                   EVAL      DBFILE= 'SCSARDPD'
166700200529     C                   EVAL      DBASE = 8
166800200529     C                   OUT       LDA
166900200529     C                   EXSR      *PSSR
167000200529     C                   ENDIF
167100200529
167200200529     C                   IF        PRTCD = *BLANKS
167300200529     C                   MOVEL     'Y'           CAS006
167400200529     C                   ELSE
167500200529     C                   MOVEL     'N'           CAS006
167600200529     C                   ENDIF
167700200529      *
167800200529      ** Check if CSC011 is installed
167900200529     C                   EVAL      CSC011 = 'N'
168000200529     C                   CALLB     'AOSARDR0'
168100200529     C                   PARM      *BLANKS       PRTCD
168200200529     C                   PARM      '*VERIFY'     POPTN
168300200529     C                   PARM      'CSC011'      PSARD
168400200529     C     SCSARD        PARM      SCSARD        DSFDY
168500200529     C                   IF        PRTCD = *BLANKS AND
168600200529     C                             PRTCD <> '*NRF   '
168700200529     C     *LOCK         IN        LDA
168800200529     C                   EVAL      DBFILE = 'SCSARDPD'
168900200529     C                   EVAL      DBKEY  = 'CSC011'
169000200529     C                   EVAL      DBASE = 9
169100200529     C                   OUT       LDA
169200200529     C                   EXSR      *PSSR
169300200529     C                   ENDIF
169400200529
169500200529     C                   IF        PRTCD = *BLANKS
169600200529     C                   EVAL      CSC011 = 'Y'
169700200529     C                   IN        SC24X7
169800200529     C                   IN        SDSTAT
169900200529     C                   ELSE
170000200529     C                   EVAL      CSC011 = 'N'
170100200529     C                   ENDIF
170200200529      ** Access SAR details file to determine if Commitment Control
170300200529      ** Changes is switched on.
170400200529      *
170500200529     C                   CallB     'AOSARDR0'
170600200529     C                   Parm      *BLANKS       PRTCD
170700200529     C                   Parm      '*VERIFY'     POPTN
170800200529     C                   Parm      'CSC022'      PSARD
170900200529     C     SCSARD        Parm      SCSARD        DSFDY
171000200529
171100200529     C                   If        PRTCD = *BLANKS
171200200529      *
171300200529     C                   Eval      CSC022 = 'Y'
171400200529     C                   In        SCCMTJOB
171500200529     C                   If        ComitNum > 0
171600200529      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
171700200529      ** (CSE072)' is installed.                                                              CSE072
171800200529                                                                                              CSE072
171900200529     C                   CALLB     'AOSARDR0'                                                 CSE072
172000200529     C                   PARM      *BLANKS       PRTCD                                        CSE072
172100200529     C                   PARM      '*VERIFY'     POPTN                                        CSE072
172200200529     C                   PARM      'CSE072'      PSARD                                        CSE072
172300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
172400200529                                                                                              CSE072
172500200529      ** An NRF (No Record Found) return code is valid.                                       CSE072
172600200529      ** Issue database error only for error return codes.                                    CSE072
172700200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
172800200529     C                             PRtcd <> '*NRF   '                                         CSE072
172900200529     C     *LOCK         IN        LDA                                                        CSE072
173000200529     C                   EVAL      DBKEY = 'CSE072'                                           CSE072
173100200529     C                   EVAL      DBFILE= 'SCSARDPD'                                         CSE072
173200200529     C                   EVAL      DBASE = 011                                                CSE072
173300200529     C                   OUT       LDA                                                        CSE072
173400200529     C                   EXSR      *PSSR                                                      CSE072
173500200529     C                   ENDIF                                                                CSE072
173600200529                                                                                              CSE072
173700200529     C                   IF        PRtcd = *BLANKS                                            CSE072
173800200529     C                   MOVEL     'Y'           CSE072                                       CSE072
173900200529     C                   ELSE                                                                 CSE072
174000200529     C                   MOVEL     'N'           CSE072                                       CSE072
174100200529     C                   ENDIF                                                                CSE072
174200200529                                                                                              CSE065
174300200529      ** Access SAR file to determine if CSE065 is installed                                  CSE065
174400200529                                                                                              CSE065
174500200529     C                   CALL      'AOSARDR0'                                                 CSE065
174600200529     C                   PARM      *BLANKS       PRtcd                                        CSE065
174700200529     C                   PARM      '*VERIFY'     POptn                                        CSE065
174800200529     C                   PARM      'CSE065'      PSarD                                        CSE065
174900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
175000200529                                                                                              CSE065
175100200529      ** An NRF (No Record Found) return code is valid.                                       CSE065
175200200529      ** Issue database error only for error return codes.                                    CSE065
175300200529                                                                                              CSE065
175400200529     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
175500200529     C                             PRtcd <> '*NRF   '                                         CSE065
175600200529     C     *LOCK         IN        LDA                                                        CSE065
175700200529     C                   EVAL      DBKey = 'CSE065'                                           CSE065
175800200529     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
175900200529     C                   EVAL      DBase = 12                                                 CSE065
176000200529     C                   OUT       LDA                                                        CSE065
176100200529     C                   EXSR      *PSSR                                                      CSE065
176200200529     C                   ENDIF                                                                CSE065
176300200529                                                                                              CSE065
176400200529     C                   IF        PRtcd = *BLANKS                                            CSE065
176500200529     C                   MOVEL     'Y'           CSE065                                       CSE065
176600200529     C                   ELSE                                                                 CSE065
176700200529     C                   MOVEL     'N'           CSE065                                       CSE065
176800200529     C                   ENDIF                                                                CSE065
176900200529      *
177000200529      ** Check if Current Job exists in the Commitment Job Names
177100200529      ** Data Area.
177200200529      *
177300200529     C                   MoveA     wComitJob     CmtJobNArr
177400200529     C     PSJOBNAME     LookUp    CmtJobNArr                             20
177500200529     C                   If        *IN20
177600200529     C                   Eval      wCommitSkip = 'Y'
177700200529     C                   EndIf
177800200529     C                   EndIf
177900200529      *
178000200529     C                   Else
178100200529      *
178200200529      ** Database error
178300200529      *
178400200529     C                   If        PRTCD <> '*NRF'
178500200529     C     *LOCK         In        LDA
178600200529     C                   Eval      DBKey = 'CSC022'
178700200529     C                   Eval      DBPgm = 'SESEDEVU'
178800200529     C                   Eval      DBFile = 'SCSARDPD'
178900200529     C                   Eval      DBase = 10
179000200529     C                   Out       LDA
179100200529     C                   ExSr      *PSSR
179200200529     C                   EndIf
179300200529      *
179400200529     C                   EndIf
179500200529                                                                                              CGL031
179600200529      ** Check if CGL031 is enabled.                                                          CGL031
179700200529                                                                                              CGL031
179800200529     C                   CALLB     'AOSARDR0'                                                 CGL031
179900200529     C                   PARM      *BLANKS       PRtCd                                        CGL031
180000200529     C                   PARM      '*VERIFY'     POptn                                        CGL031
180100200529     C                   PARM      'CGL031'      PSARD                                        CGL031
180200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
180300200529                                                                                              CGL031
180400200529     C                   EVAL      CGL031 = 'N'                                               CGL031
180500200529                                                                                              CGL031
180600200529     C                   IF        PRtCd = *BLANKS                                            CGL031
180700200529     C                   EVAL      CGL031 = 'Y'                                               CGL031
180800200529     C                   ELSE                                                                 CGL031
180900200529                                                                                              CGL031
181000200529     C                   IF        PRtCd <> '*NRF   '                                         CGL031
181100200529     C     *LOCK         IN        LDA                                                        CGL031
181200200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
181300200529     C                   EVAL      DBKey = PSARD                                              CGL031
181400200529     C                   EVAL      DBase = 101                                                CGL031
181500200529     C                   OUT       LDA                                                        CGL031
181600200529     C                   EXSR      *PSSR                                                      CGL031
181700200529     C                   ENDIF                                                                CGL031
181800200529                                                                                              CGL031
181900200529     C                   ENDIF                                                                CGL031
182000200529      *                                                                                      260191A
182100200529      ** Check if S01512 is installed                                                        260191A
182200200529      *                                                                                      260191A
182300200529     C                   CallB     'AOSARDR0'                                                260191A
182400200529     C                   Parm      *BLANKS       PRTCD             7                         260191A
182500200529     C                   Parm      '*VERIFY'     POPTN             7                         260191A
182600200529     C                   Parm      'S01512'      PSARD             6                         260191A
182700200529     C     SCSARD        Parm      SCSARD        DSFDY                                       260191A
182800200529      *                                                                                      260191A
182900200529      ** An NRF (No Record Found) return code is valid.                                      260191A
183000200529      ** Issue database error only for error return codes.                                   260191A
183100200529      *                                                                                      260191A
183200200529     C                   IF        PRtcd <> *BLANKS AND                                      260191A
183300200529     C                             PRtcd <> '*NRF   '                                        260191A
183400200529     C     *LOCK         IN        LDA                                                       260191A
183500200529     C                   EVAL      DBKey = 'S01512'                                          260191A
183600200529     C                   EVAL      DBFile= 'SCSARDPD'                                        260191A
183700200529     C                   EVAL      DBase = 013                                               260191A
183800200529     C                   OUT       LDA                                                       260191A
183900200529     C                   EXSR      *PSSR                                                     260191A
184000200529     C                   ENDIF                                                               260191A
184100200529      *                                                                                      260191A
184200200529     C                   IF        PRTCD = *BLANKS                                           260191A
184300200529     C                   MOVE      'Y'           S01512            1                         260191A
184400200529     C                   ELSE                                                                260191A
184500200529     C                   MOVE      'N'           S01512                                      260191A
184600200529     C                   ENDIF                                                               260191A
184700200529      *
184800200529      *
184900200529      ** Retrieve Midas Module Flag details
185000200529     C                   READ      MMODF                                  01
185100200529      **********                                                                             BUG7029
185200200529      ***Retrieve*ZMUSER*details.                                                            BUG7029
185300200529     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
185400200529     C**********         IN        ZMUSER                                                    BUG7029
185500200529      *
185600200529      ** Key fields for LF/SEDEV
185700200529     C     KDEVKA        KLIST
185800200529     C                   KFLD                    DDSDSN
185900200529     C                   KFLD                    WEvtDno
186000200529     C                   KFLD                    DDSDET
186100200529      *
186200200529      ** Program, module and procedure names for database error processing
186300200529      ** =================================================================
186400200529      ** The following /COPY sets these values.
186500200529      /COPY ZACPYSRC,DBFIELDS
186600200529      *
186700200529      ** Hook to enable non-core initial processing to be included
186800200529      /COPY WNCPYSRC,SESEDEC021
186900200529      *
187000200529     C                   ENDSR
187100200529      *
187200200529      *****************************************************************
187300200529      /EJECT
187400200529      *****************************************************************
187500200529      *
187600200529      ** The following /COPY contains the standard program status
187700200529      ** subroutine, including a bound call to the DBERRCTL module.
187800200529      /COPY ZACPYSRC,PSSR_ILENE
187900200529     C                   EVAL      APIRETC = '0'
188000200529     C                   RETURN
188100200529     C                   ENDSR
188200200529      *
188300200529      *****************************************************************
188400200529      /EJECT
188500200529      *****************************************************************
188600200529      *
188700200529**  CPY@
188800200529(c) Finastra International Limited 2001
