     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Validate & Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  LEPDCLVU - Midas LE Past Due Call Loan                       *
      *             Validate and Update                               *
      *                                                               *
      *  Function: Validates PDCL detail for input into Midas database*
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD020270           Date 25Jun13               *
      *                 AR1078092          Date 20Jan13               *
      *                 AR1021983          Date 01Aug12               *
      *                 264044             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020270 - PDCL generation went to Repair Queue to BASEL II  *
      *             validation-encountered in EOM validation          *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  AR1021983 - Option C - Technical Enhancements Stated in POC  *
      *  264044 - CLE134 Test PDCL SOAP API                           *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *on (for indicator processing)
      ** False      logical = *off (for indicator processing)
      ** DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      ** error handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
 
      ** The following /COPY includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** Incoming header
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming transaction in screen format
 
     D TranInPDCL    E DS                  EXTNAME(LEPDCLPD)
 
      ** Valid file layout
 
     D ValidPDCL     E DS                  EXTNAME(LEVPDCLPD)
 
      ** Current transaction record in file format Loan
 
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
 
      ** Current transaction record in file format Loan 2
 
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Current transaction record in file format Fee
 
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Current transaction record in file format Facility
 
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** Loan Link File Format
 
     D PDCLFilFmtLnkLE DS                  EXTNAME(LEPDUEPD)
     D                                     PREFIX(X_)
 
      ** Fee Link File Format
 
     D PDCLFilFmtLnkFE DS                  EXTNAME(LEPDUFPD)
     D                                     PREFIX(Z_)
 
      ** Current transaction in screen format
 
     D CurTrPDCL     E DS                  EXTNAME(LEPDCLPD)
     D                                     PREFIX(@)
 
      ** Error indicators
 
     D OKTrPDCL      E DS                  EXTNAME(LEEPDCLPD)
 
      ** EXTERNAL DS FOR Bank Detail
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSSDY         E DS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
 
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc in amend validation
 
     D AmIdx           S              3P 0 INZ(0)
 
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
 
     D WIdx            S              3P 0 INZ(0)
 
      ** Fields (1000A) to receive the incoming transaction
 
     D Trans10001      S           1000A
 
      ** Indices for arrays used to set up corresponding
      ** sequence numbers for the fields that are in error
 
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Timestamp for the transaction
 
     D TimeStamp       S               Z
 
     D @AuthComp       S              1A
     D @FwdBck         S              1A
 
     D APIRetC         S              1A
 
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D @TimeStamp      S             26A
 
     D ModeofOp        S              6A
 
     D RespMode        S              1A
 
     D AmendOk         S              1A
     D ResetErrs       S              1A
 
     D RecordType      S              1A
     D WMODE           S              1A
 
     D NBCDY           S              3  0
     D NBCSD           S              5  0
     D NRCDY           S              3  0
     D NRCSD           S              5  0
 
      ** Additional Field Definitions
     D WPLON           S              6
     D WPLO2           S              6
     D IUSR            S             10
 
     D CobMode         S              1A
 
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initial processing is performed automatically: *INZSR is
      ** executed at program activation
 
      ** Incoming transaction is broken into 500A fields, so a common
      ** CL can be used between this module and the one that read MQ
      ** queue.  This module needs to break these 500A fields by
      ** loading them in the appropriate (externally described) data
      ** structure.
 
     C                   MOVEL     Trans10001    TranInPDCL
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      ** If error in validation of action code, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon action code
 
     C                   SELECT
 
      ** Processing for inserts
 
     C                   WHEN      DDACTN = 'I'
     C                   IF        COBMode <> 'Y'                                           MD020270
     C                   EXSR      ValidateTr
     C                   ENDIF                                                              MD020270
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     DDACTN        ANDEQ     'I'
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
     *** If action is for Update, get the correct record information
     *** from file
 
     C                   IF           UpdateYN = 'Y'
     C                             AND IDX     = 0
     C                             AND DDACTN <> 'D'
 
     C                   EVAL      DDACTN = 'E'
     C                   MOVE      NPLON         WPLON                                        264044
     C                   IF        NPLON = *BLANKS and DDPLON <> *BLANKS
     C**********         MOVE      DDPLON        NPLON                                        264044
     C                   MOVE      DDPLON        WPLON                                        264044
     C                   ENDIF
     C                   MOVE      NPLO2         WPLO2                                        264044
     C                   IF        NPLO2 = *BLANKS and DDPLO2 <> *BLANKS
     C**********         MOVE      DDPLO2        NPLO2                                        264044
     C                   MOVE      DDPLO2        WPLO2                                        264044
     C                   ENDIF
 
     C                   CALL      'LEPDCLR'
     C                   PARM                    @AuthComp
     C                   PARM                    @FwdBck
     C                   PARM                    HeadIn                                    AR1078092
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
     C**********         PARM                    NPLON                                        264044
     C**********         PARM                    NPLO2                                        264044
     C                   PARM                    WPLON                                        264044
     C                   PARM                    WPLO2                                        264044
     C                   PARM                    DDACTN
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C                   MOVEL     DDACTN        Buffer
 
     C                   ELSE
 
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL      Buffer      = TranInPDCL
     C                                         + @TimeStamp
     C                                         + %CHAR(NBCDY)                              AR1021983
     C                                         + %CHAR(NBCSD)                              AR1021983
     C                                         + %CHAR(NRCDY)                              AR1021983
     C                                         + %CHAR(NRCSD)                              AR1021983
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
 
     C                   PARM                    HeadIn
 
      ** Transaction information
 
     C                   PARM                    Trans10001
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp
 
      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      ** Access bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   EVAL      COBMode = *BLANKS
     C                   IF        APSRCSYS = 'MIDASCOB'
     C                   EVAL      COBMode = 'Y'
     C                   ENDIF
 
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
 
      ** Validate action code versus transaction IDs supplied
      ** The PDCL info from the database are retrieved as well.
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'LEPDCLRTV'
 
      ** Inputs
 
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           APRESPMODE
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
 
     C                   PARM                    APFOTranID
 
      ** User ID
 
     C                   PARM                    IUSR
 
      ** Contains Key fields which identify Transaction
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
     C                   PARM                    NPLON
     C                   PARM                    NPLO2
     C                   PARM                    DDSEIN
     C                   PARM                    COBMode                                   AR1078092
 
      ** Outputs
 
      ** Transaction Type
 
     C                   PARM                    RecordType
 
      ** Transaction Details in File Format: Loan 1
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** Transaction Details in File Format: Loan Link
 
     C                   PARM                    PDCLFilFmtLnkL
 
      ** Transaction Details in File Format: Fee Link
 
     C                   PARM                    PDCLFilFmtLnkF
 
      ** PDCL Details OK inds
 
     C                   PARM                    OKTrPDCL
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main transaction details *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR
 
      ** Validate transaction details
 
     C                   CALLB     'LEPDCLVAL'
 
      ** Inputs
 
      ** Response mode
 
     C                   PARM      'S'           RespMode
 
      ** PDCL Details
 
     C                   PARM                    TranInPDCL
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
 
      ** Transaction Type
 
     C                   PARM                    RecordType
 
      ** Transaction Details in File Format: loan 1
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** COB Mode
 
     C                   PARM                    COBMode
 
      ** Outputs
 
      ** Interest Type/sub-type Details OK inds
 
     C                   PARM                    OKTrPDCL
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Interest type/sub-type (DS) from/to caller
 
     C                   PARM                    ValidPDCL
 
      ** Insert correct parameters for this VAL function
 
     C                   ENDSR
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
 
     C                   RESET                   AmIdx
 
     C                   CLEAR                   CurTrPDCL
     C                   MOVE      *ALL'Y'       OKTrPDCL
     C                   CLEAR                   ValidPDCL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
     C                   CALLB     'LEPDCLUPD'
 
     C                   PARM      *BLANKS       @RTCD
 
     C                   PARM                    DDACTN
 
      ** Valid values
 
     C                   PARM                    ValidPDCL
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
 
      ** Record Type
 
     C                   PARM                    RecordType
 
      ** Front Office ID
 
     C                   PARM                    APFOTranID
 
      ** Transaction Details in File Format: Loan 1
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** Other fields
 
     C                   PARM                    IUSR
 
      ** If there were any errors in the update functions, rollback any
      ** updates (done in *PSSR) and end this program. Otherwise
      ** commit.
 
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
 
     C                   MOVEL     'USR0015'     MsgIdArr(1)
 
     C                   ENDIF
 
     C     UPDATEDBEND   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
 
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2011
