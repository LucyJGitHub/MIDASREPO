     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base Rate Codes interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTCTL - SD Base Rate Codes Controller                    *
      *                                                               *
      *  Function: This Program Validates SD Base rate codes for      *
      *            input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Base Rate fields.                 *
      *            - For all action codes                             *
      *              - Call the retrieve module to validate the       *
      *                action code.
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247439             Date 07Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 24Oct03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 26Jan01               *
      *                 CAP038  *CREATE    Date 24Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247439 - Kondor transactions go missing...                   *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CSD012 - Standing Data Authorisation                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      * Valid Base Rate
     FSDVBSRTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      * Invalid Base Rate
     FSDIBSRTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT

      * Valid Base Rate  (Keyed by Front Office Transaction Id)
     FSDVBSRTL0 IF   E           K DISK    RENAME(SDVBSRTD0:SDVBSRTCHK)
     F                                     INFSR(*pssr)

      * Valid Base Rate  (Keyed by currency code and base rate code)
     FSDVBSRTL1 IF   E           K DISK    RENAME(SDVBSRTD0:SDVBSRTCH1)
     F                                     INFSR(*pssr)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDBSRTC001

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------

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

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Base Rate
     D BaseRateIn    E DS                  EXTNAME(SDBSRSPD)

      * (Current) Transaction in Screen Format - Main Details
     D CurTrTran     E DS                  EXTNAME(SDBSRSPD)
     D                                     PREFIX(@)

      * Valid Base Rate layout
     D ValdBasRat    E DS                  EXTNAME(SDVBSRTPD)


      * (Current) Base Rate in File Format
     D BasRFilFmt    E DS                  EXTNAME(SDBSRTPD)

     D ExtData       E DS                  EXTNAME(SDBSEXPD)
      * SD Extra Data - File (D/B) format

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas modules

      ** External DS for SAR details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
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

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      ** Field (500A) to receive the incoming  base rate
     D BaseR500        S            500A

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A


      ** Flags to indicate whether Base Rate fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SDEBSRTPD)

      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D Object          S             10A   INZ('SDBSRTUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Transaction Id
     D DDTRNN          DS
     D   DDTRCYCD                          LIKE(DDCYCD)
     D   DDTRBSRC                          LIKE(DDBSRC)

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepTran         S              1A   inz('N')

      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      * Fields defined for CSD012                                                             CSC012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')                      CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSC012
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDBSRTC002

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,SDBSRTC003

      * Incoming base rate is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     BaseR500      BaseRateIn
     C                   MOVEL     Extdata500    Extdata

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,SDBSRTC004

      *  Check if valid Base rate code details exists for Front Office ID

     C                   EXSR      ChkValBasR
      *
      *  If valid Base Rate does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

      *  Check if valid base rate code exists for Midas Base Rate code

     C                   EXSR      ChkValMiBs
      *
      *  If valid base rate does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END


      * Reset variables again in case the details have been corrupted
      * by previous chain to valid base rate file.

     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,SDBSRTC005

      *  Validate Action Code

     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,SDBSRTC006

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        GHSUBS <> *blank

     C     GHSUBS        SCAN      BaseRateIn                             99
     C                   IF        *in99
     C                   EVAL      RepTran = 'Y'
     C                   ENDIF

      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepTran = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF

     C                   ENDIF
      **                 (End of "GHSUBS <> *blank")

      *  Processing request ( Amend and Insert)

      /COPY WNCPYSRC,SDBSRTC007
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   EXSR      ValidateBr
     C                   ELSE
     C     DDACTN        IFEQ      'D'
     C                   CLEAR                   ValdBasRat
     C                   MOVEL     BasRFilFmt    ValdBasRat
     C                   MOVEL     DDACTN        BVTYLC
     C                   ENDIF
     C                   ENDIF
      /COPY WNCPYSRC,SDBSRTC008
      *
     C     INVALID       TAG

      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP

      /COPY WNCPYSRC,SDBSRTC011

     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE

      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,SDBSRTC012
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,SDBSRTC013

      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
     C     Return        IFEQ      *BLANK
      *  Check if any messages are already on the data queue
      *  No need to send duplicate prompt messages

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   END
     C                   END
     C                   END

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDBSRTC014

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValBasR - Routine to check if valid Base rate exists       *
      *    for Front Office ID                                        *
      *                                                               *
      *****************************************************************

     C     ChkValBasR    BEGSR

      * Check for base rate on Valid file
     C     APFOTranID    CHAIN     SDVBSRTCHK                         99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     APFOTranID    CHAIN     SDVBSRTCHK                         99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'
     C                   EVAL      MsgIDArr(Idx) = 'USR4441'
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiBs - Routine to check if valid Base Rate code exists  *
      *    for Midas base rate code                                   *
      *                                                               *
      *****************************************************************

     C     ChkValMiBS    BEGSR

     C     DDCYCD        IFNE      *BLANKS
     C     DDBSRC        ANDNE     *BLANKS

      * Check for Key Currency Code/Base Rate Code on Valid file
     C     SDBSRT        CHAIN     SDVBSRTCH1                         99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     SDBSRT        CHAIN     SDVBSRTCH1                         99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'
     C                   EVAL      MsgIDArr(Idx) = 'USR4447'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR
      *
      *  MUST use the same processing as in SDBSRTUPD, otherwise it passes                    247439
      *  validation, but fails on update - and the error handling there                       247439
      *  cannot cope...                                                                       247439
      **Set*retrieve*mode*to*'*FRONT'*(Access*using*Front*Office*ID)****                      247439
      ***if*insert******************************************************                      247439
      ***if*not*insert*and*Midas*transaction*ID*is*not*present**********                      247439
      **Otherwise*******************************************************                      247439
      ***Set*retrieve*mode*to*blank**(Access*using*Midas*transaction*ID).                     247439
      ******************************************************************                      247439
      ***We*assume*no*substitution*has*been*defined*for*the*transaction*ID                    247439
      ******************************************************************                      247439
      ***Check*for*the*existence*of*the*replacement*character*at*the****                      247439
      ***Transaction*Id*level.******************************************                      247439
     C**********         MOVEL     DDCYCD        DDTRCYCD                                     247439
     C**********         MOVEL     DDBSRC        DDTRBSRC                                     247439
     C**********         IF        GHSUBS <> *blank                                           247439
     C*****GHSUBS        SCAN      DDTRNN        SubForTRNN        2 0                        247439
     C**********         ENDIF                                                                247439
      **********                                                                              247439
     C*****DDACTN        IFEQ      'I'                                                        247439
     C**********         MOVEL     '*FRONT'      ModeofOp                                     247439
     C**********         ELSE                                                                 247439
     C*****DDTRNN        IFEQ      *BLANK                                                     247439
     C*****SubForTRNN    ORNE      0                                                          247439
     C**********         MOVEL     '*FRONT'      ModeofOp                                     247439
     C**********         ELSE                                                                 247439
     C**********         MOVEL     '      '      ModeofOp                                     247439
     C**********         ENDIF                                                                247439
     C**********         ENDIF                                                                247439
      *                                                                                       247439
      ** Determine whether program is running interactively or in batch                       247439
      **  ( 0 = batch   1 = interactive)                                                      247439
      *                                                                                       247439
     C                   CALLB     'ZARTVJOBA'                                                247439
     C                   PARM                    @Return           6                          247439
     C                   PARM                    @Type             1                          247439
      *                                                                                       247439
      *  Set retrieve mode to blank  (Access using Midas transaction ID).                     247439
      *                                                                                       247439
     C     @Type         IFEQ      '0'                                                        247439
     C                   MOVE      '*FRONT'      ModeofOp                                     247439
     C                   ELSE                                                                 247439
     C                   MOVE      *BLANKS       ModeofOp                                     247439
     C                   END                                                                  247439

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas Base Rate Code
      * The Base Rate in file format from the SD database is retrieved
      * as well.
     C                   RESET                   ReturnCode
     C                   CALLB     'SDBSRTRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE

      * Action Code
     C                   PARM                    DDACTN

      * Front Office Transaction ID
     C                   PARM                    APFOTranID

      * Currency Code
     C                   PARM                    DDCYCD

      * Base Rate Code
     C                   PARM                    DDBSRC

      * OUTPUTS

      * (Current) Base rate in file format
     C                   PARM                    BasRFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK

      * OK - Currency Code
     C                   PARM                    DDCycdOK

      * OK - Base Rate Code
     C                   PARM                    DDBsrcOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * ICD - Private Banking
     C                   PARM                    BGN4ST
      * Base Rate Shortname
     C                   PARM                    DDBSRS
      *
      * Base Rate Name
     C                   PARM                    DDBSRN
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateBr - Routine to validate the Base Rate details        *
      *                                                               *
      *****************************************************************

     C     ValidateBr    BEGSR

     C                   CLEAR                   ValdBasRat
      *
      * Initialize valid file with format output by the RTV API
      * Some fields may be overwritten by the validation.
     C                   MOVEL     BasRFilFmt    ValdBasRat
      *
     C                   CALLB     'SDBSRTVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction Information (DS) from source system
     C                   PARM                    BaseRateIn
      * Base Rate Extra Data
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Valid Base Rate layout (DS) from/to caller
     C                   PARM                    ValdBasRat
      * Switchable features
     C                   PARM                    CSD006                                       CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************

     C     CheckWrite    BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     SDVBSRTD0

      /COPY WNCPYSRC,SDBSRTC015

     C                   EXSR      CallMsgHdl
     C                   ENDIF


     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
      *
     C     APRprLocn     IFEQ      'B'
     C                   WRITE     SDIBSRTD0
     C                   ENDIF
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = BaseRateIn + ExtData                            CSC011
     C                   EVAL      APTGTTYPE = 'SDBSRT'                                       CSC011
     C                   EVAL      PDealNum = DDCYCD + DDBSRC                                 CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      DBKEY = PDealNum                                           CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 2                                                  CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
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

     C                   MOVE      *ALL'Y'       OKFlagsDS

     C                   CLEAR                   CurTrTran
     C                   CLEAR                   ValdBasRat
      ** Numeric fields within 'ValdBasRat' have to be reset explicitlyas
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         BVLCD
     C                   Z-ADD     *ZERO         BVCBSR
     C                   Z-ADD     *ZERO         BVVDRC
     C                   Z-ADD     *ZERO         BVNBRT
     C                   Z-ADD     *ZERO         BVVDNR

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************

     C     SETUPINVAL    BEGSR

      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp

     C                   EVAL      TranStatus = 'F'

      /COPY WNCPYSRC,SDBSRTC016

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR




      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      BVFOTRANID = APFOTranID
     C                   EVAL      BVRPRLOCN  = APRprLocn
     C                   EVAL      BVTMESTMP = TimeStamp

     C                   EVAL      TranStatus = 'S'

      /COPY WNCPYSRC,SDBSRTC016

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************

     C     CallMsgHdl    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C     FldNameArr(Ix)IFNE      *BLANKS

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode

     C     DDCYCD        CAT       DDBSRC        PTranID          20

     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Base rate repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
     C                   PARM                    MsgFArray                                    222373
      ** Whether or not to clear the program message queue (1A)                               222373
     C                   PARM                    ClearPgmQ         1                          222373

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************

     C     DtaSubs       begsr

      * Convert file fields to screen format
     C                   RESET                   RetCodeOut
      *
      * Call program to fill screen fields with data from FXDEALPP
      *
     C                   CALLB     'SDBSRTCVT'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    BasRFilFmt
     C                   PARM                    CurTrTran
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103

      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   if        RepTran = 'Y'

     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
      * Substitution character
      * Incoming Data
      * Current Data
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM      BaseRateIn    IncData        2000
     C                   PARM      CurTrTran     CurData        2000

     C                   MOVEL     IncDATA       BaseRateIn

     C                   endif

     C                   endsr

      *****************************************************************
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
      * Transaction information in a single large field from source system
     C                   PARM                    BaseR500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld       27                          CSD103
                                                                                              CSD012
      * Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012

      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'SDUSRMSG'

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'SD'

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Access Modules details
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM                    @RTCD
     C                   PARM                    @OPTN
     C     SDMMOD        PARM                    DSFDY


      ** Check whether MDF is installed                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C                   IF        @RTCD = *BLANK                                             CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006

      ** MT34* MT36* Message Generation for FRA/IRS
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW005'      @SARD             6
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW005            1
     C                   ELSE
     C                   MOVEL     'N'           CSW005
     C                   ENDIF

      ** MT34* Message Generation
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW011'      @SARD             6
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW011            1
     C                   ELSE
     C                   MOVEL     'N'           CSW011
     C                   ENDIF

      ** SWIFT 2000 Changes
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW200'      @SARD             6
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSW200            1
     C                   ELSE
     C                   MOVEL     'N'           CSW200
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> *BLANKS) and                                     CSC011
     C                             (PRtCd <> '*NRF   ')                                       CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011

      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APBSRTDTQ'

      ** Check if CSD012 is installed                                                         CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANKS                                                    CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Base Rate Authorisation is ON                              CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     3             DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDBSRTCTL'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Base Rate Authorisation is On set to Authorise                                    CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
      *
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 4                                                  CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
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
      * Key Lists
      *
     C     SDBSRT        KLIST
     C                   KFLD                    DDCYCD
     C                   KFLD                    DDBSRC

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDBSRTC017

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
