     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio defns interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMCTL - Portfolio Definitions Interface Controller       *
      *                                                               *
      *  Function: This program validates Portfolio Definition        *
      *            Details for input into the Midas database.         *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert), A (=Amend) or C (=Closure)      *
      *              - validate the Portfolio Definition fields.      *
      *            - For A (=Amend)                                   *
      *              - if it is valid, call a separate function to    *
      *                check whether it is a valid amendment.         *
      *            For all action codes, the decision as to whether   *
      *            to write to the Valid or Invalid file and the call *
      *            to the Message Handler will take place in this     *
      *            module.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 205131             Date 25Jul02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  205131 - Do not default Investment and Management Type.      *
      *           They are now setup in Touch Of Finance.             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CPB002 - New Private Banking Customer Processing.            *
      *           Just recompile over changes in PMVPFDMPD.           *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid Portfolio Definitions
     FPMVPFDMPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Invalid Portfolio Definitions
     FPMIPFDMPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FPMVPFDML0 IF   E           K DISK    RENAME(PMVPFDMD0:PMVPFDMCHK)
      *
     FPMVPFDML1 IF   E           K DISK    RENAME(PMVPFDMD0:PMVPFDMCHM)
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,PMPFDMC001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** String for error messages to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Message Header
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction
     D PTransIn      E DS                  EXTNAME(PMPFDMPD)
      *
      ** Valid Portfolio Definition Details - for file update
     D PValidPort    E DS                  EXTNAME(PMVPFDMPD)
     D  PInvestInds           81     84
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D PPortFilFmt   E DS                  EXTNAME(PMVPFDMPD)
     D                                     PREFIX(O)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D PCurPort      E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(C)
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** Error indicators
     D POKFields     E DS                  EXTNAME(PMEPFDMPD)
     D   OKInds                1     42    DIM(42) INZ('Y')
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Portfolio Details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
      *
      ** Externally described DS for API ICD Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data Structure for last update
     D WLUP            DS
     D   WDLUP                 1      2  0
     D   WMLUP                 3      5
     D   WYLUP                 6      7  0
      *
      ** The Investment Policy Indicators are input-capable only
      ** on the Screen Input (*SIN) function:
      ** - (DDIPIN) Instrument Investment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
      ** For *CTL and *RPR, since no values are being received
      ** from the MQ Series, they are just defaulted to the file values.
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     D PCurInvestI     DS             4
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Field (500A) to receive the incoming transaction
     D PTrans5001      S            500A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *
      ** Index for arrays of error message IDs in Amend Validation
     D AMIDx           S              3P 0
      *
      ** Module ID to be passed to the message handler
     D PModuleID       S              2A
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
     D PObject         S             10A   INZ('PMPFDMUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list).
     D PClrPgmMsgQ     S              1A   INZ('Y')
      ** Override Database Table                                                CPB002
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)            CPB002
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Overall Transaction status, to be passed to the Message Handler
     D PTranStatus     S              1A
      *
                                                                                              CSC011
      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNum       S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
                                                                                              CSC011
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDMC002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDMC003
      *
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
      *
     C                   MOVEL     PTrans5001    PTransIn
     C                   MOVEL     PExtData500   PExtData
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,PMPFDMC004
      *
      ** Check if Portfolio Definition exists for Front Office ID
      ** in the Valid Records file.
      *
     C                   EXSR      SRChkValPort
      *
      ** If valid Portfolio Definition does exist even after delay,
      ** fail this input.
      *
     C     IDx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if Portfolio Definition exists for Customer Number
      ** and Portfolio Reference in the Valid Records file.
      *
     C                   EXSR      SRChkValMPort
      *
      ** If valid Portfolio Definition does exist even after delay,
      ** fail this input.
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Portfolio Definitions file.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,PMPFDMC005
      *
      ** Validate action code versus the transaction ID supplied.
      ** Original Portfolio Definition Details in file format are
      ** retrieved during the validation process.
      *
     C                   EXSR      SRValAction
      *
      /COPY WNCPYSRC,PMPFDMC006
      *
      ** If error in validation of action code, fail this input.
      *
     C     IDx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon Action Code.
      *
     C                   SELECT
      *
      ** INSERT
      ** ======
      *
     C                   WHEN      DDACTN = 'I'
      *
      /COPY WNCPYSRC,PMPFDMC007
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,PMPFDMC008
      *
      ** AMEND
      ** =====
      *
     C                   WHEN      DDACTN = 'A'
      *
      /COPY WNCPYSRC,PMPFDMC009
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *blank
      *
     C     GHSUBS        SCAN      PTransIn                               99
      *
     C                   IF        *IN99
      *
      ** Do the data substitution subroutine.
      *
     C                   EXSR      SRDtaSubs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,PMPFDMC010
      *
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      /COPY WNCPYSRC,PMPFDMC011
      *
      ** CLOSURE
      ** =======
      *
     C                   WHEN      DDACTN = 'C'
      *
      /COPY WNCPYSRC,PMPFDMC012
      *
      ** Validate Incoming Portfolio Definition Details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,PMPFDMC013
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,PMPFDMC014
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *blank
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError         28
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn        10
     C                   PARM                    PMQErrLong      132
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C                   MOVEL     ARErrMod      APRetCode
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
     C                   ELSE
      *
      ** Processing for Error checking/write to database
      *
      /COPY WNCPYSRC,PMPFDMC015
      *
     C                   EXSR      SRCheckWrite
      *
      /COPY WNCPYSRC,PMPFDMC016
      *
      ** If valid, send data queue entry to prompt DB update program.
      *
     C     IDx           IFEQ      0
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcObj
     C                   PARM      *BLANK        PReturn
      *
     C     PReturn       IFEQ      *BLANK
      *
      ** Check if any messages are already on the data queue.
      ** No need to send duplicate prompt messages.
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDMC017
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIDArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx
      *
     C                   RESET                   FldNoArr
      *
     C                   RESET                   POKFields
      *
     C                   RESET                   AmendOK
      *
      ** Valid Portfolio Definition Details - for file update
     C                   CLEAR                   PValidPort
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPOP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNBCGD
     C                   Z-ADD     *ZERO         P1PNCSDP
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C                   Z-ADD     *ZERO         P1PNMGTP
     C                   Z-ADD     *ZERO         P1PNINTP
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValPort - Routine to check if Valid Portfolio           *
      *                 Definition exists for Front Office ID in the  *
      *                 Valid Records file                            *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValPort  BEGSR
      *
      ** Check for Front Office ID in the Valid Records file.
      *
     C     APFOTRANID    CHAIN     PMVPFDML0                          01
      *
      ** Check if record found.
      *
     C     *IN01         IFEQ      '0'
      *
      ** Run delay program, then repeat chain.
      *
     C                   CALLB     'ZACDELAY'
      *
     C     APFOTRANID    CHAIN     PMVPFDML0                          01
      *
      ** Error if Front Office ID still present.
      *
     C     *IN01         IFEQ      '0'
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkValMPort - Routine to check if Valid Portfolio           *
      *                 Definition exists for Customer and Portfolio  *
      *                 Reference in the Valid Records file.          *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValMPort BEGSR
      *
      ** Key list for file PMVPFDML1
      *
     C     KMPort        KLIST
     C**********         KFLD                    KCSNM             6 0                        CSD027
     C                   KFLD                    KCSNM             6                          CSD027
     C                   KFLD                    KPREF             4
      *
      ** Test if '?' exists on Customer field.
      *
     C     '?'           SCAN      DDCSNM                                 01
      *
      ** Continue process if no '?' character on Customer field
      ** and Portfolio Reference has been supplied.
      *
     C     *IN01         IFEQ      '0'
     C     DDPREF        ANDNE     *BLANKS
      *
      ***Test*if Customer is numeric.                                                         CSD027
      **********                                                                              CSD027
     C**********         MOVEL     DDCSNM        WDCSNM1           6                          CSD027
     C**********         MOVE      DDCSNM        WDCSNM2           4                          CSD027
     C**********         TESTN                   WDCSNM1              9898                    CSD027
      *
     C******IN98         IFEQ      '0'                                                        CSD027
     C*****WDCSNM2       ORNE      *BLANKS                                                    CSD027
     C**********         MOVEL     '*CSHT  '     PKEY                                         CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     '*CNUM  '     PKEY                                         CSD027
     C**********         ENDIF                                                                CSD027
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DDCSNM        PCNUM            10
     C**********         PARM                    PKEY              7                          CSD027
     C     PKEY          PARM      *BLANKS       PKEY              7                          CSD027
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If record found...
      *
     C     PRTCD         IFEQ      *BLANKS
      *
      ** Check for Portfolio Definition on Valid Records file.
      *
     C                   MOVEL     DDCSNM        KCSNM
     C                   MOVEL     DDPREF        KPREF
     C     KMPort        CHAIN     PMVPFDML1                          99
      *
      ** If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ** Run delay program, then repeat chain.
      *
     C                   CALLB     'ZACDELAY'
      *
     C     KMPort        CHAIN     PMVPFDML1                          99
      *
      ** Error if still present.
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
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
      *  SRValAction - Routine to validate action code versus the     *
      *                transaction ID supplied                        *
      *              - Original Portfolio Definition details in file  *
      *                format are retrieved during the validation     *
      *                process                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRValAction   BEGSR
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and Midas transaction Id is present,
      ** set retrieve mode to blank (Access using Midas transaction Id).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      PModeofOp
     C                   ELSE
      *
     C     DDCSNM        IFEQ      *BLANK
     C     DDPREF        ANDEQ     *BLANK
     C                   MOVEL     '*FRONT'      PModeofOp
     C                   ELSE
     C                   MOVEL     '      '      PModeofOp
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'PMPFDM2RV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM                    PModeofOp         6
      *
      ** Response Mode
     C                   PARM                    APRESPMODE
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM                    APFOTRANID
      *
      ** Portfolio reference
     C                   PARM                    DDPREF
      *
      ** Customer
      *
     C                   PARM                    DDCSNM
      *
      ** REVIEW FROM key fields to position browse display in
      ** Screen Input function - not used in this function
     C                   PARM      *BLANKS       PREVIEW          10
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    PPortFilFmt
      *
      ** OK - Action Code
     C                   PARM                    OKACTN
      *
      ** OK - Portfolio Reference
     C                   PARM                    OKPREF
      *
      ** OK - Customer
     C                   PARM                    OKCSNM
      *
      ** OK - REVIEW FROM (not used in this function)
     C                   PARM                    POKREVIEW         1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Routine to validate incoming Portfolio        *
      *                 Definition Details                            *
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValDetails  BEGSR
      *
      ** For action codes Amend and Closure, put the complete (pre-existing)
      ** Portfolio Definition Details into the Valid File record.  Fields
      ** will be updated during processing.
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'C'
     C                   MOVE      PPortFilFmt   PValidPort
     C                   ENDIF
      *
      ** For Insert, default Date Opened to rundate and blank out
      ** Pledge Start and Finish Dates if Portfolio Lending is on.
      ** Also, if customer is not PM Customer, default mandatory
      ** fields.
      *
     C     DDACTN        IFEQ      'I'
      *
     C                   EVAL      OP1PNDPOP = BJRDNB
     C                   EVAL      P1PNDPOP = BJRDNB
      *
     C     BGLMCR        IFEQ      'Y'
     C                   MOVE      *BLANKS       DDPDGS
     C                   MOVE      *BLANKS       DDPDGF
     C                   ENDIF
      *
     C     PMCUST        IFNE      'Y'
     C                   EVAL      P1PNIPIN = 'N'
     C                   EVAL      P1PNCYIN = 'N'
     C                   EVAL      P1PNYPIN = 'N'
     C                   EVAL      P1PNNPIN = 'N'
     C                   EVAL      P1PNMNGI = 'M'
     C                   EVAL      P1PNRPYP = 'N'
     C                   Z-ADD     99999         P1PNPSDT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'PMPFDM2VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    APRESPMODE
      *
      ** Incoming Portfolio Definition Details - screen format
     C                   PARM                    PTransIn
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For this function, the values are the same as those
      **   kept on file.
     C                   PARM                    PInvestInds
      *
      ** Incoming Extra Data
     C                   PARM                    PExtData
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP
      *
      ** Original Performance Start Date
     C                   PARM                    OP1PNPSDT
      *
      ** Original Pledge Finish Date
     C                   PARM                    OP1PNPDGF
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     C                   PARM      '*FRONT'      PModeOfOp
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKFields
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Valid Portfolio Definition Details - for file update
     C                   PARM                    PValidPort
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted to their screen formats.      *
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValAmend    BEGSR
      *
      ** Convert the original Portfolio Definition Details to
      ** screen format.
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    PPortFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     C                   PARM                    PCurInvestI
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
      ** Check if amendment to the file values is valid.
      *
     C                   CALLB     'PMPFDM2AD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    PTransIn
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Date Opened retrieved from file
      ** - in screen format
     C                   PARM                    PDDDPOP
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           RESETERRS         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    POKFields
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIDArr
     C                   PARM                    AMMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AMIDx
      *
      ** Amendments OK
     C                   PARM                    AmendOK           1
      *
      ** If any errors, overwrite previous error information.
      *
     C                   IF        AMIDx <> 0
     C                   MOVEA     AMMsgIDArr    MsgIDArr
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AMIDx         IDx
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
      ** Convert file fields to screen format.
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    PPortFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    PCurPort
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     C                   PARM                    PCurInvestI
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    PDDDPOP           6
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      PTransIn      IncData        2000
      *
      ** Current Data
     C                   PARM      PCurPort      CurData        2000
      *
     C                   MOVEL     IncDATA       PTransIn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCheckWrite  BEGSR
      *
      ** If no errors were found:
      ** - set up additional data
      ** - write a record to the Valid Records file
      ** - use std message handler to report transaction status
      ** If any errors were found:
      ** - set up additional data
      ** - write a record to the Invalid Records file
      ** - call the message handler to pass the errors back
      ** - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      ** errors.
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date, this routine will have to cater for       |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C     IDx           IFEQ      0
     C                   EXSR      SRSetValid
     C                   WRITE     PMVPFDMD0
     C                   EXSR      SRMsgHdl
     C                   ENDIF
      *
     C     IDx           IFGT      0
     C                   EXSR      SRSetInvalid
      *
      ** Only write to invalid files if repair in back office.
     C     APRPRLOCN     IFEQ      'B'
     C                   WRITE     PMIPFDMD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = PTransIn                                        CSC011
     C                                        + PExtData                                      CSC011
     C                   EVAL      APTGTTYPE = 'PMPFDM'                                       CSC011
     C                   EVAL      PDealNum = DDCSNM                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    PHeadIn                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNum                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 10                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
     C                   EXSR      SRMsgHdl
     C                   ENDIF
      *
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetValid - Routine to set up fields in the Valid File      *
      *               record                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRSetValid    BEGSR
      *
      ** Set Details for Insert.
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'D'           P1PNRECI
     C                   MOVEL     DDCSNM        P1PNCNUM
     C                   MOVEL     DDPREF        P1PNPTFR
     C                   MOVEL     DDINTP        P1PNINTP                                     205131
     C                   MOVEL     DDMGTP        P1PNMGTP                                     205131
     C                   ENDIF
      *
      ** Set Details for Insert, Amend and Closure.
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EVAL      WLUP = BJMRDT
     C                   EVAL      P1PNDLUP = WDLUP
     C                   EVAL      P1PNMLUP = WMLUP
     C                   EVAL      P1PNYLUP = WYLUP
     C                   EVAL      P1PNTLUP = PSRUNTIME
     C                   EVAL      P1PNLCD  = BJRDNB
     C                   EVAL      P1PNTNLU = *ZERO
     C                   MOVEL     DDINTP        P1PNINTP                                     205131
     C                   MOVEL     DDMGTP        P1PNMGTP                                     205131
     C                   ENDIF
      *
      ** For Enquire, move Portfolio Definition Details directly
      ** to Valid Records file format.
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     PPortFilFmt   PValidPort
     C                   ENDIF
      *
      ** Move action code.
     C                   EVAL      P1PNCHTP = DDACTN
      *
      ** Move header details.
     C                   EVAL      P1PNFRNT = APFOTRANID
     C                   EVAL      P1PNAFRT = APFOASOCID
     C                   EVAL      P1PNREPA = APRPRLOCN
     C                   EVAL      P1PNTMST = PTimestamp
      *
      ** Master files will be updated.
     C                   EVAL      PTranStatus = 'S'
      *
      /COPY WNCPYSRC,PMPFDMC018
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInvalid - Routine to set up fields in the Invalid File  *
      *                 record                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSetInvalid  BEGSR
      *
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDAFRT = APFOASOCID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMESTMP = PTimestamp
      *
      ** Transaction needs to be repaired.
     C                   EVAL      PTranStatus = 'F'
      *
      /COPY WNCPYSRC,PMPFDMC019
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors.
      *
     C                   Z-ADD     1             W1
      *
     C                   DO        ArrayMax
      *
     C     FldNameArr(W1)IFNE      *BLANKS
      *
     C                   Z-ADD     1             W2
     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           02
     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             W1
     C                   ENDDO
      *
     C                   MOVEL     DDCSNM        WTRAN            10
     C                   MOVE      DDPREF        WTRAN
     C                   MOVEL     WTRAN         PTranID          20
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
      *
      ** Repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
      *
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCNFVALFO
      *
      ** List of messages (array of message IDs - from caller)
     C                   PARM                    MsgIDArr
      *
      ** List of field numbers (array of unsigned int. from caller)
     C                   PARM                    FldNoArr
      *
      ** List of field names (array of fields names from caller)
     C                   PARM                    FldNameArr
      *
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Midas module ID (2A)
     C                   PARM                    PModuleID
      *
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      *
      ** Message file (10A, from caller)
     C                   PARM                    #MSGFILE
      *
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    PTranStatus
      *
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRESPMODE
      *
      ** The following three parameters are needed when messages are
      ** to be displayed on a screen
      *
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #PROCPGM
      *
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #PROCMOD
      *
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #PROCNAME
      *
      ** The MQ series queue to send replies to
     C                   PARM                    APRPYQUEUE
      *
      ** The transaction's timestamp
     C                   PARM                    PTimestamp
      *
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MSGFARRAY
      *
      ** Whether or not clear the program message queue (1A)
     C                   PARM                    PClrPgmMsgQ
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Incoming Header details
     C                   PARM                    PHeadIn
      *
      ** Incoming Transaction details
     C                   PARM                    PTrans5001
      *
      ** Incoming Extra data
     C                   PARM                    PExtData500
      *
      ** Program details
     C                   PARM                    #PROCPGM
     C                   PARM                    #PROCMOD
     C                   PARM                    #PROCNAME
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
     C                   EVAL      #MSGFILE     = 'PMUSRMSG'
     C                   EVAL      MSGFARRAY(1) = 'DRSMM'
      *
      ** Setup the name of the module ID, used to make the transaction
      ** number unique
      *
     C                   EVAL      PModuleID = 'PM'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR file to determine if CAC003 (Profit Centre)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAC003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAC003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on Profit Centre feature if Analytical Accounting is
      ** also switched on.
     C     PRTCD         IFEQ      *BLANK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'Y'           CAC003            1
     C                   ELSE
     C                   MOVEL     'N'           CAC003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01464 (Safe Custody Fees)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01464'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01464'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01464            1
     C                   ELSE
     C                   MOVE      'N'           S01464
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 9                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      * Database Error                                                                        CSC022
      *                                                                                       CSC022
     C                   If        PRTCD <> *BLANKS and                                       CSC022
     C                             PRTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 11                                                 CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** If Safe Custody Fees is installed, access ICD details.
      *
     C     S01464        IFEQ      'Y'
      *
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSCFE        PARM      SDSCFE        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSCFEPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APPFDMDTQ'
                                                                                CPB002
     C* Override SDPBDSLR                                                       CPB002
     C                   Z-ADD     50            MESLEN           15 5          CPB002
     C                   CALL      'QCMDEXC'                                    CPB002
     C                   PARM                    ##OX1                          CPB002
     C                   PARM                    MESLEN                         CPB002
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,PMPFDMC020
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
