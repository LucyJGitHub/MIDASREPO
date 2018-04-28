     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contracts validate and update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  ABINTCVU - Internal Contracts validate and update            *
      *                                                               *
      *  Function: This program validates Internal Contract           *
      *            transactions for input into the Midas database.    *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. 261962             Date 23Sep09               *
      *                 259924A            Date 31May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22140           Date 14Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG698             Date 30Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 05Aug03               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  259924A- Amended so that system can get the front office ID  *
      *           from Java.                                          *
      *  BUG22140 - Missing authorization field in repository.        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG698 - Certain fields need formatting before being adding  *
      *           into the buffer. This is for the reverse confirm    *
      *           screen.                                             *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Current transactions (Keyed by .............)
     FABDEALL1  IF   E           K DISK    RENAME(ABDEALP0:ABINTCChk)
     F                                     INFSR(*pssr)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     F/COPY WNCPYSRC,ABH00006
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D TranInINTC    E DS                  EXTNAME(ABINTCPD)
 
      * Valid file layout
     D ValidINTC     E DS                  EXTNAME(ABVINTCPD)
     D                                     PREFIX(V_)
      * *** NOTE: there are no settlements for Internal Contracts, so we
      *           can probably remove these
      * ***
      *** INTCRecIns            456    524
      *** INTCPayIns            525   1083
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      *  Separate out settlement instructions
 
      * Current transaction record in file format
     D INTCFilFmt    E DS                  EXTNAME(ABDEALPP)
      *** INTCRecIns            456    524
      *** INTCPayIns            525   1083
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
      *  Separate out settlement instructions
 
      * Current transaction in screen format
     D CurTrINTC     E DS                  EXTNAME(ABINTCPD)
     D                                     PREFIX(@)
 
      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
 
      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
 
      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
 
      * Pay settlement instructions in file format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
 
      * Receive settlement instructions in file format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
 
      * FRA/IRS settlement instructions in file format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(ABICEXPD)
 
      * Error indicators
     D OKTrINTC      E DS                  EXTNAME(ABEINTCPD)
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
                                                                                              BUG698
      * EXTERNAL DS FOR DEALING DETAILS                                                       BUG698
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  BUG698
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D DDFOID          S             20                                                      259924A
     D DDAFID          S             20                                                       261962
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInINTC
     C                   MOVEL     Extdata500    Extdata
     C**********         EVAL      DDFOID = %SUBST(Trans5001:295:20)                  259924A 261962
     C                   EVAL      APFOTranID = DDFOID                                       259924A
     C                   EVAL      APFOASOCID = DDAFID                                        261962
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
      * Get deal numbers for insert.
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
      *                                                                                       BUG698
      * Need to set the following screen fields if action is reverse                          BUG698
      * for reverse confirmation screen.                                                      BUG698
      * DDL2RT DDL2CB DDL2BA DDL2CS DDL2SA DDLOIA DDDPIA                                      BUG698
     C                   SELECT                                                               BUG698
     C                   WHEN      DDACTN = 'D'                                               BUG698
      *                                                                                       BUG698
      ** 2nd leg exch rate                                                                    BUG698
     C                   Z-ADD     *ZERO         @@AMTW                                       BUG698
     C                   MOVE      JPFDXR        @@AMTW                                       BUG698
     C                   Z-ADD     8             W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTP        DDL2RT                                       BUG698
      ** 2nd leg buy currency                                                                 BUG698
      ** 2nd leg buy amount                                                                   BUG698
      ** 2nd leg sell currency                                                                BUG698
      ** 2nd leg sell amount                                                                  BUG698
      *                                                                                       BUG698
     C     JPFDA1        IFLT      *ZERO                                                      BUG698
                                                                                              BUG698
     C                   MOVE      JPDFCY        DDL2CS                                       BUG698
                                                                                              BUG698
     C                   Z-SUB     JPFDA1        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPF        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTP        DDL2SA                                       BUG698
                                                                                              BUG698
     C                   MOVE      JPDSCY        DDL2CB                                       BUG698
                                                                                              BUG698
     C                   Z-ADD     JPFDA2        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPS        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTP        DDL2BA                                       BUG698
                                                                                              BUG698
     C                   ELSE                                                                 BUG698
                                                                                              BUG698
     C                   MOVE      JPDSCY        DDL2CS                                       BUG698
                                                                                              BUG698
     C                   Z-SUB     JPFDA2        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPS        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTP        DDL2SA                                       BUG698
                                                                                              BUG698
     C                   MOVE      JPDFCY        DDL2CB                                       BUG698
                                                                                              BUG698
     C                   Z-ADD     JPFDA1        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPF        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTP        DDL2BA                                       BUG698
                                                                                              BUG698
     C                   END                                                                  BUG698
      *                                                                                       BUG698
      * Loan Interest Amount                                                                  BUG698
     C                   Z-ADD     JPINA1        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPF        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTD        DDLOIA                                       BUG698
      *                                                                                       BUG698
      * Deposit Interest Amount                                                               BUG698
     C                   Z-ADD     JPINA2        @@AMTW                                       BUG698
     C                   Z-ADD     JPCDPS        W@DECP                                       BUG698
     C                   EXSR      FMTAMT                                                     BUG698
     C                   MOVE      @@AMTD        DDDPIA                                       BUG698
     C                   ENDSL                                                                BUG698
 
      * Remerge buffer with all relevant data structures
     C                   EVAL      Buffer = TranInINTC + DDL2RT
     C                             + DDL2CB + DDL2BA + DDL2CS
     C                             + DDL2SA + DDLOIA + DDDPIA
     C**********                   + DDSTS + Extdata                                         259924A
     C**********                   + DDSTS + DDFOID + Extdata                         259924A 261962
     C/COPY WNCPYSRC,ABH00016
     C                             + DDSTS + DDFOID + DDAFID + Extdata                        261962
     C/COPY WNCPYSRC,ABH00017
     C                   RETURN
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
 
      * Transaction information
     C                   PARM                    Trans5001
     C/COPY WNCPYSRC,ABH00007
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    AAuth             1                        BUG22140
     C                   PARM                    DDFOID                                       261962
     C                   PARM                    DDAFID                                       261962
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,ABINTC02
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      * Initialise the OK flags structure (can't do this on the D-spec because
      * it is an externally-defined DS)
     C                   EVAL      OKTrINTC = *all'Y'
      *                                                                                       BUG698
      ** ACCESS DEALING DETAILS                                                               BUG698
      *                                                                                       BUG698
     C                   CALL      'AODEALR1'                                                 BUG698
     C                   PARM      '*DBERR '     @RTCD                                        BUG698
     C                   PARM      '*FIRST '     @OPTN                                        BUG698
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        BUG698
      *                                                                                       BUG698
      * DATABASE ERROR                                                                        BUG698
      *                                                                                       BUG698
     C     @RTCD         IFNE      *BLANK                                                     BUG698
     C                   MOVEL     @OPTN         DBKEY                                        BUG698
     C                   MOVEL     'SDDEALPD'    DBFILE                                       BUG698
     C                   MOVEL     '903'         DBASE                                        BUG698
     C                   EXSR      *PSSR                                                      BUG698
     C                   END                                                                  BUG698
      *                                                                                       BUG698
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRtCd                                        CSC022
     C                   PARM      '*VERIFY'     POptn                                        CSC022
     C                   PARM      'CSC022'      PSard                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 001                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,ABINTC01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the AB database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ABINTCRTV'
      * Ensure correct parameters for this RTV function
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Front Office AssociatedTransaction ID
     C                   PARM                    APFOASOCID
      *
      * (Midas) First deal no
     C                   PARM                    DDL1DN
      *
      * (Midas) Second Deal Number
     C                   PARM                    DDL2DN
      *
      * Booking branch
     C                   PARM                    DDBRCD            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    INTCFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK
      *
      * OK - First Deal Number
     C                   PARM                    ddL1DNok
      *
      * OK - Second Deal Number
     C                   PARM                    ddL2DNok
      *
      * OK - Booking branch
     C                   PARM                    ddBRCDok
      *
      * OK - Originating branch
     C                   PARM                    ddORBRok
 
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C/COPY WNCPYSRC,ABH00008
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate transaction details
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ABINTCVAL'
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Internal Contract Transaction Details
     C                   PARM                    TranInINTC
 
      * Extra Data
     C                   PARM                    ExtData
 
      * Outputs
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      * Deposit Interest Amount
     C                   PARM                    DDSTS            24
      ** Transaction Details OK inds
     C                   PARM                    OKTrINTC
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
      * Valid INTC Transaction (DS) from/to caller
     C                   PARM                    ValidINTC
 
      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
 
     C     EValidTr      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrINTC
 
     C                   MOVE      *ALL'Y'       OKTrINTC
 
     C                   CLEAR                   ValidINTC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************
 
     C     SETUPDEALN    BEGSR
 
      * First deal number
 
     C                   IF           DDL1DN = *blanks
     C                             OR DDL1DN = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDL1DN
     C                   PARM      *ZEROS        V_JUFD38
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDL1DN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDL1DNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDL1DN        V_JUFD38
 
     C                   ENDIF
 
      * Second deal number
 
     C                   IF           DDL2DN = *blanks
     C                             OR DDL2DN = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDL2DN
     C                   PARM      *ZEROS        V_JUSD38
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDL2DN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDL2DNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDL2DN        V_JUSD38
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * For Deletes, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF        DDACTN = 'D'
     C                   MOVEL     INTCFilFmt    ValidINTC
     C                   ENDIF
 
      * Set file field(s) that are needed for all action codes
     C                   EVAL      V_JULACT = DDACTN
 
      * Include header fields that need to be o/p to the valid file
     C                   EVAL      V_JUFRNT = APFOTranID
     C                   EVAL      V_JUAFRT = APFOAsocID
     C                   EVAL      V_JUREPA = APRprLocn
     C                   EVAL      V_JUTMST = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      * Update
     C                   MOVE      *BLANKS       @RTCD
     C                   CALLB     'ABINTCUPD'
     C                   PARM                    @RTCD
     C                   PARM                    ValidINTC
     C/COPY WNCPYSRC,ABH00009
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
 
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
 
     C                   EndIf
 
     C                   ENDSR
      /EJECT                                                                                  BUG698
      *****************************************************************                       BUG698
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *                       BUG698
      *****************************************************************                       BUG698
     C     FMTAMT        BEGSR                                                                BUG698
      *                                                                                       BUG698
     C                   CALLB     'ZA0921'                                                   BUG698
     C                   PARM      *BLANK        @@RETC           10                          BUG698
     C                   PARM                    @@AMTW           15 0                        BUG698
     C                   PARM                    W@DECP            1 0                        BUG698
     C                   PARM      BNDCSP        @@DCSP            1                          BUG698
     C                   PARM      *BLANK        @@AMTP           16                          BUG698
     C                   PARM      *BLANK        @@AMTD           17                          BUG698
      *                                                                                       BUG698
     C                   ENDSR                                                                BUG698
      *****************************************************************
     C/COPY WNCPYSRC,ABH00010
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
