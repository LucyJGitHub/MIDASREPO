     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax details validate & Update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTVU - Customer Withholding Tax API validate and         *
      *             update                                            *
      *                                                               *
      *  Function: This program validates Customer Withholding Tax    *
      *            API for input into the Midas database.             *
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
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22148           Date 19Jan09               *
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG22148 - Missing authorization field in repository.        *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

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

      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming transaction in screen format
     D TranInCUWT    E DS                  EXTNAME(SDCUWTPD)
     D TranIn5001              1    500
     D TranIn5002            501   1000

      ** Valid file layout
     D ValidCUWT     E DS                  EXTNAME(SDVCUWTPD)
     D                                     PREFIX(V_)

      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions

     D CUWTFilFmt    E DS                  EXTNAME(SDVCUWTPD)
      ** Withholding Tax in Valid File Format
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
      ** Separate out settlement instructions

      ** Current transaction in screen format
     D CurTrCUWT     E DS                  EXTNAME(SDCUWTPD)
     D                                     PREFIX(@)

      ** Error indicators
     D OKTrCUWT      E DS                  EXTNAME(SDECUWTPD)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

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

      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A

      ** Indices for arrays used to set up corresponding
      ** sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Entry Parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D PTimeStamp      S             26A

     D @AuthComp       S              1A
     D @FwdBck         S              1A
     D DDCSNO_In       S              6A
     D APIRetC         S              1A
     D PRTCD           S              7A
     D POPTN           S              7A

     D ModeofOp        S              6A

     D RespMode        S              1A
     D AmendOk         S              1A
     D ResetErrs       S              1A

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

      ** Incoming transaction is broken into 500A fields, so that a
      ** common CL can be used between this module and the one that
      ** read the MQ queue.  This module needs to break these 500A
      ** fields by loading them into the appropriate (externally
      ** described) data structure.

     C                   MOVEL     Trans5001     TranIn5001
     C                   MOVEL     Trans5002     TranIn5002

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
     C                   EXSR      ValidateTr

      ** Processing for amends or changes

     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr

      ** Processing for Authorises

     C                   WHEN      DDACTN = 'X'
     C                   EXSR      ValidateTr
     C                   ENDSL

     C     INVALID       TAG

      ** Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information
      ** from file

     C                   IF        UpdateYN = 'Y'  AND
     C                             IDX = 0        AND
     C                             DDACTN <> 'D'
     C                   MOVE      DDCSNO        DDCSNO_In
     C                   CALL      'SDCUWTR'
     C                   PARM                    @AuthComp
     C                   PARM                    @FwdBck
     C                   PARM                    DDCSNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC

     C                   EVAL      BUFFER = %REPLACE(DDACTN:BUFFER:27:1)

      ** Remerge buffer with all relevant data structures

     C                   ELSE
     C                   EVAL           Buffer = PTimeStamp + TranInCUWT
     C                   ENDIF

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

      ** Common header information (DS) from source system

     C                   PARM                    HeadIn

      ** Transaction information

     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
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
     C                   PARM                    PTimeStamp
     C                   PARM                    AAuth             1                        BUG22148

      ** Set up the name of the primary and secondary message files
      ** from which the message handler will get the messages

     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'

      ** Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDCUWTM01
      *
      ** Access bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,SDCUWT01

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAc - Routine to validate action code versus          *
      *  Customer Number supplied                                     *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

      ** Validate action code versus Customer Number supplied
      ** The Withholding Tax in file format from the SD database is
      ** retrieved as well.

     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SDCUWTRTV'

      ** Ensure correct parameters for this RTV function
      ** Inputs
      ** Return code

     C                   PARM      *BLANK        ReturnCode

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp

      ** Response mode
     C                   PARM      'S'           APRESPMODE

      ** Action Code

     C                   PARM                    DDACTN

      ** (Midas) Customer Number

     C                   PARM                    DDCSNO

      ** Securities Classification

     C                   PARM                    DDCLAS

      ** Outputs
      ** (Current) Withholding Tax in file format

     C                   PARM                    CUWTFilFmt

      ** OK - Action code

     C                   PARM                    DDACTNOK

      ** OK - Customer Number

     C                   PARM                    DDCSNOOK

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
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      ** For amends, put the complete (pre-existing) transaction into
      ** the valid file record - fields in this will be updated during
      ** processing

     C                   MOVE      CUWTFilFmt    ValidCUWT

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      *  ValidateTr - Routine to validate the Customer withholding Tax *
      *              Details                                           *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      ** Validate Customer Withholding Tax Details

     C                   RESET                   ReturnCode

     C                   CALLB     'SDCUWTVAL'

      ** Inputs
      ** Response mode

     C                   PARM      'S'           RespMode

      ** Withholding Tax Details

     C                   PARM                    TranInCUWT

      ** Ensure validation module is ready to accept infdata and
      ** extdata
      ** Outputs
      ** Withholding Tax Details OK inds

     C                   PARM                    OKTrCUWT

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

      ** Valid Withholding Tax (DS) from/to caller

     C                   PARM                    ValidCUWT

      ** Insert correct parameters for this VAL function
      ** If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValdateAmd - Routine to check whether the fields amended     *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

      ** Convert file format to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'SDCUWTCVT'

      ** Ensure correct parameters for this CVT function
      ** Output Parameters
      ** Return Code

     C                   PARM      *BLANKS       RetCodeIn

      ** Withholding Tax Details File Format

     C                   PARM                    CUWTFilFmt

      ** Output Parameters
      ** Withholding Tax Details Screen Format

     C                   PARM                    CurTrCUWT

      ** Insert correct parameters for this CVT function

     C                   RESET                   ReturnCode

     C                   CALLB     'SDCUWTAMD'

      ** INPUTS
      ** Return Code

     C                   PARM                    ReturnCode

      ** New Deal in Screen Format (Incoming Transaction)

     C                   PARM                    TranInCUWT

      ** (Current) Deal in Screen Format

     C                   PARM                    CurTrCUWT

      ** (Current) Deal in file format

     C                   PARM                    CUWTFilfmt

      ** OUTPUTS
      ** Field OK flags (DS) from/to caller

     C                   PARM                    OKTrCUWT

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr

      ** Array index (3P0) from/to caller

     C                   PARM                    AmIdx

      ** Amendments OK

     C                   PARM                    AmendOk

      ** Reset of Fields in Error Required (Y/N)

     C                   PARM      'N'           ResetErrs

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETCYCLE- Reset error information that is gradually        *
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

     C                   CLEAR                   CurTrCUWT
     C                   MOVE      *ALL'Y'       OKTrCUWT
     C                   CLEAR                   ValidCUWT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Reset error information that is gradually updated*
      *              during each run of this program                  *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * Set file field(s) that are needed for all action codes
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A' OR
     C                             DDACTN = 'D'
     C                   EVAL      V_WTTYLC = DDACTN
     C                   ENDIF
      *
     C                   EVAL      V_WTRECI  = 'D'
     C                   EVAL      V_WTCSNO  = DDCSNO
     C                   EVAL      V_WTCRTT1 = DDCRTT1
     C                   EVAL      V_WTINTS1 = DDINTS1
     C                   EVAL      V_WTDCRC1 = DDDCRC1
     C                   EVAL      V_WTEXCD1 = DDEXCD1
     C                   EVAL      V_WTBCWA1 = DDBCWA1
     C                   EVAL      V_WTRPCD1 = DDRPCD1
     C                   EVAL      V_WTTXBS1 = DDTXBS1
     C                   EVAL      V_WTRFSI1 = DDRFSI1
     C                   EVAL      V_WTDBTT1 = DDDBTT1
     C                   EVAL      V_WTTIN1  = DDTIN1
      *
     C                   EVAL      V_WTCRTT2 = DDCRTT2
     C                   EVAL      V_WTINTS2 = DDINTS2
     C                   EVAL      V_WTDCRC2 = DDDCRC2
     C                   EVAL      V_WTEXCD2 = DDEXCD2
     C                   EVAL      V_WTBCWA2 = DDBCWA2
     C                   EVAL      V_WTRPCD2 = DDRPCD2
     C                   EVAL      V_WTTXBS2 = DDTXBS2
     C                   EVAL      V_WTRFSI2 = DDRFSI2
     C                   EVAL      V_WTDBTT2 = DDDBTT2
     C                   EVAL      V_WTTIN2  = DDTIN2
      *
     C                   EVAL      V_WTCRTT3 = DDCRTT3
     C                   EVAL      V_WTINTS3 = DDINTS3
     C                   EVAL      V_WTDCRC3 = DDDCRC3
     C                   EVAL      V_WTEXCD3 = DDEXCD3
     C                   EVAL      V_WTBCWA3 = DDBCWA3
     C                   EVAL      V_WTRPCD3 = DDRPCD3
     C                   EVAL      V_WTTXBS3 = DDTXBS3
     C                   EVAL      V_WTRFSI3 = DDRFSI3
     C                   EVAL      V_WTDBTT3 = DDDBTT3
     C                   EVAL      V_WTTIN3  = DDTIN3
      *
     C                   EVAL      V_WTCRTT4 = DDCRTT4
     C                   EVAL      V_WTINTS4 = DDINTS4
     C                   EVAL      V_WTDCRC4 = DDDCRC4
     C                   EVAL      V_WTEXCD4 = DDEXCD4
     C                   EVAL      V_WTBCWA4 = DDBCWA4
     C                   EVAL      V_WTRPCD4 = DDRPCD4
     C                   EVAL      V_WTTXBS4 = DDTXBS4
     C                   EVAL      V_WTRFSI4 = DDRFSI4
     C                   EVAL      V_WTDBTT4 = DDDBTT4
     C                   EVAL      V_WTTIN4  = DDTIN4
      *
     C                   EVAL      V_WTCRTT5 = DDCRTT5
     C                   EVAL      V_WTINTS5 = DDINTS5
     C                   EVAL      V_WTDCRC5 = DDDCRC5
     C                   EVAL      V_WTEXCD5 = DDEXCD5
     C                   EVAL      V_WTBCWA5 = DDBCWA5
     C                   EVAL      V_WTRPCD5 = DDRPCD5
     C                   EVAL      V_WTTXBS5 = DDTXBS5
     C                   EVAL      V_WTRFSI5 = DDRFSI5
     C                   EVAL      V_WTDBTT5 = DDDBTT5
     C                   EVAL      V_WTTIN5  = DDTIN5
      *
     C                   EVAL      V_WTCRTT6 = DDCRTT6
     C                   EVAL      V_WTINTS6 = DDINTS6
     C                   EVAL      V_WTDCRC6 = DDDCRC6
     C                   EVAL      V_WTEXCD6 = DDEXCD6
     C                   EVAL      V_WTBCWA6 = DDBCWA6
     C                   EVAL      V_WTRPCD6 = DDRPCD6
     C                   EVAL      V_WTTXBS6 = DDTXBS6
     C                   EVAL      V_WTRFSI6 = DDRFSI6
     C                   EVAL      V_WTDBTT6 = DDDBTT6
     C                   EVAL      V_WTTIN6  = DDTIN6
      *
     C                   EVAL      V_WTCRTT7 = DDCRTT7
     C                   EVAL      V_WTINTS7 = DDINTS7
     C                   EVAL      V_WTDCRC7 = DDDCRC7
     C                   EVAL      V_WTEXCD7 = DDEXCD7
     C                   EVAL      V_WTBCWA7 = DDBCWA7
     C                   EVAL      V_WTRPCD7 = DDRPCD7
     C                   EVAL      V_WTTXBS7 = DDTXBS7
     C                   EVAL      V_WTRFSI7 = DDRFSI7
     C                   EVAL      V_WTDBTT7 = DDDBTT7
     C                   EVAL      V_WTTIN7  = DDTIN7
      *
     C                   EVAL      V_WTCRTT8 = DDCRTT8
     C                   EVAL      V_WTINTS8 = DDINTS8
     C                   EVAL      V_WTDCRC8 = DDDCRC8
     C                   EVAL      V_WTEXCD8 = DDEXCD8
     C                   EVAL      V_WTBCWA8 = DDBCWA8
     C                   EVAL      V_WTRPCD8 = DDRPCD8
     C                   EVAL      V_WTTXBS8 = DDTXBS8
     C                   EVAL      V_WTRFSI8 = DDRFSI8
     C                   EVAL      V_WTDBTT8 = DDDBTT8
     C                   EVAL      V_WTTIN8  = DDTIN8
      *
     C                   EVAL      V_WTCRTT9 = DDCRTT9
     C                   EVAL      V_WTINTS9 = DDINTS9
     C                   EVAL      V_WTDCRC9 = DDDCRC9
     C                   EVAL      V_WTEXCD9 = DDEXCD9
     C                   EVAL      V_WTBCWA9 = DDBCWA9
     C                   EVAL      V_WTRPCD9 = DDRPCD9
     C                   EVAL      V_WTTXBS9 = DDTXBS9
     C                   EVAL      V_WTRFSI9 = DDRFSI9
     C                   EVAL      V_WTDBTT9 = DDDBTT9
     C                   EVAL      V_WTTIN9  = DDTIN9
      *
     C                   EVAL      V_WTCRTT10 = DDCRTT10
     C                   EVAL      V_WTINTS10 = DDINTS10
     C                   EVAL      V_WTDCRC10 = DDDCRC10
     C                   EVAL      V_WTEXCD10 = DDEXCD10
     C                   EVAL      V_WTBCWA10 = DDBCWA10
     C                   EVAL      V_WTRPCD10 = DDRPCD10
     C                   EVAL      V_WTTXBS10 = DDTXBS10
     C                   EVAL      V_WTRFSI10 = DDRFSI10
     C                   EVAL      V_WTDBTT10 = DDDBTT10
     C                   EVAL      V_WTTIN10  = DDTIN10
      *
     C                   EVAL      V_WTCRTT11 = DDCRTT11
     C                   EVAL      V_WTINTS11 = DDINTS11
     C                   EVAL      V_WTDCRC11 = DDDCRC11
     C                   EVAL      V_WTEXCD11 = DDEXCD11
     C                   EVAL      V_WTBCWA11 = DDBCWA11
     C                   EVAL      V_WTRPCD11 = DDRPCD11
     C                   EVAL      V_WTTXBS11 = DDTXBS11
     C                   EVAL      V_WTRFSI11 = DDRFSI11
     C                   EVAL      V_WTDBTT11 = DDDBTT11
     C                   EVAL      V_WTTIN11  = DDTIN11
      *
     C                   EVAL      V_WTCRTT12 = DDCRTT12
     C                   EVAL      V_WTINTS12 = DDINTS12
     C                   EVAL      V_WTDCRC12 = DDDCRC12
     C                   EVAL      V_WTEXCD12 = DDEXCD12
     C                   EVAL      V_WTBCWA12 = DDBCWA12
     C                   EVAL      V_WTRPCD12 = DDRPCD12
     C                   EVAL      V_WTTXBS12 = DDTXBS12
     C                   EVAL      V_WTRFSI12 = DDRFSI12
     C                   EVAL      V_WTDBTT12 = DDDBTT12
     C                   EVAL      V_WTTIN12  = DDTIN12
      *
     C                   EVAL      V_WTCRTT13 = DDCRTT13
     C                   EVAL      V_WTINTS13 = DDINTS13
     C                   EVAL      V_WTDCRC13 = DDDCRC13
     C                   EVAL      V_WTEXCD13 = DDEXCD13
     C                   EVAL      V_WTBCWA13 = DDBCWA13
     C                   EVAL      V_WTRPCD13 = DDRPCD13
     C                   EVAL      V_WTTXBS13 = DDTXBS13
     C                   EVAL      V_WTRFSI13 = DDRFSI13
     C                   EVAL      V_WTDBTT13 = DDDBTT13
     C                   EVAL      V_WTTIN13  = DDTIN13
      *
     C                   EVAL      V_WTCRTT14 = DDCRTT14
     C                   EVAL      V_WTINTS14 = DDINTS14
     C                   EVAL      V_WTDCRC14 = DDDCRC14
     C                   EVAL      V_WTEXCD14 = DDEXCD14
     C                   EVAL      V_WTBCWA14 = DDBCWA14
     C                   EVAL      V_WTRPCD14 = DDRPCD14
     C                   EVAL      V_WTTXBS14 = DDTXBS14
     C                   EVAL      V_WTRFSI14 = DDRFSI14
     C                   EVAL      V_WTDBTT14 = DDDBTT14
     C                   EVAL      V_WTTIN14  = DDTIN14
      *
     C                   EVAL      V_WTCRTT15 = DDCRTT15
     C                   EVAL      V_WTINTS15 = DDINTS15
     C                   EVAL      V_WTDCRC15 = DDDCRC15
     C                   EVAL      V_WTEXCD15 = DDEXCD15
     C                   EVAL      V_WTBCWA15 = DDBCWA15
     C                   EVAL      V_WTRPCD15 = DDRPCD15
     C                   EVAL      V_WTTXBS15 = DDTXBS15
     C                   EVAL      V_WTRFSI15 = DDRFSI15
     C                   EVAL      V_WTDBTT15 = DDDBTT15
     C                   EVAL      V_WTTIN15  = DDTIN15
      *
     C                   EVAL      V_WTCRTT16 = DDCRTT16
     C                   EVAL      V_WTINTS16 = DDINTS16
     C                   EVAL      V_WTDCRC16 = DDDCRC16
     C                   EVAL      V_WTEXCD16 = DDEXCD16
     C                   EVAL      V_WTBCWA16 = DDBCWA16
     C                   EVAL      V_WTRPCD16 = DDRPCD16
     C                   EVAL      V_WTTXBS16 = DDTXBS16
     C                   EVAL      V_WTRFSI16 = DDRFSI16
     C                   EVAL      V_WTDBTT16 = DDDBTT16
     C                   EVAL      V_WTTIN16  = DDTIN16
      *
     C                   EVAL      V_WTCRTT17 = DDCRTT17
     C                   EVAL      V_WTINTS17 = DDINTS17
     C                   EVAL      V_WTDCRC17 = DDDCRC17
     C                   EVAL      V_WTEXCD17 = DDEXCD17
     C                   EVAL      V_WTBCWA17 = DDBCWA17
     C                   EVAL      V_WTRPCD17 = DDRPCD17
     C                   EVAL      V_WTTXBS17 = DDTXBS17
     C                   EVAL      V_WTRFSI17 = DDRFSI17
     C                   EVAL      V_WTDBTT17 = DDDBTT17
     C                   EVAL      V_WTTIN17  = DDTIN17
      *
     C                   EVAL      V_WTCRTT18 = DDCRTT18
     C                   EVAL      V_WTINTS18 = DDINTS18
     C                   EVAL      V_WTDCRC18 = DDDCRC18
     C                   EVAL      V_WTEXCD18 = DDEXCD18
     C                   EVAL      V_WTBCWA18 = DDBCWA18
     C                   EVAL      V_WTRPCD18 = DDRPCD18
     C                   EVAL      V_WTTXBS18 = DDTXBS18
     C                   EVAL      V_WTRFSI18 = DDRFSI18
     C                   EVAL      V_WTDBTT18 = DDDBTT18
     C                   EVAL      V_WTTIN18  = DDTIN18
      *
     C                   EVAL      V_WTCRTT19 = DDCRTT19
     C                   EVAL      V_WTINTS19 = DDINTS19
     C                   EVAL      V_WTDCRC19 = DDDCRC19
     C                   EVAL      V_WTEXCD19 = DDEXCD19
     C                   EVAL      V_WTBCWA19 = DDBCWA19
     C                   EVAL      V_WTRPCD19 = DDRPCD19
     C                   EVAL      V_WTTXBS19 = DDTXBS19
     C                   EVAL      V_WTRFSI19 = DDRFSI19
     C                   EVAL      V_WTDBTT19 = DDDBTT19
     C                   EVAL      V_WTTIN19  = DDTIN19
      *
     C                   EVAL      V_WTCRTT20 = DDCRTT20
     C                   EVAL      V_WTINTS20 = DDINTS20
     C                   EVAL      V_WTDCRC20 = DDDCRC20
     C                   EVAL      V_WTEXCD20 = DDEXCD20
     C                   EVAL      V_WTBCWA20 = DDBCWA20
     C                   EVAL      V_WTRPCD20 = DDRPCD20
     C                   EVAL      V_WTTXBS20 = DDTXBS20
     C                   EVAL      V_WTRFSI20 = DDRFSI20
     C                   EVAL      V_WTDBTT20 = DDDBTT20
     C                   EVAL      V_WTTIN20  = DDTIN20
      *
     C                   EVAL      V_WTCRTT21 = DDCRTT21
     C                   EVAL      V_WTINTS21 = DDINTS21
     C                   EVAL      V_WTDCRC21 = DDDCRC21
     C                   EVAL      V_WTEXCD21 = DDEXCD21
     C                   EVAL      V_WTBCWA21 = DDBCWA21
     C                   EVAL      V_WTRPCD21 = DDRPCD21
     C                   EVAL      V_WTTXBS21 = DDTXBS21
     C                   EVAL      V_WTRFSI21 = DDRFSI21
     C                   EVAL      V_WTDBTT21 = DDDBTT21
     C                   EVAL      V_WTTIN21  = DDTIN21
      *
     C                   EVAL      V_WTCRTT22 = DDCRTT22
     C                   EVAL      V_WTINTS22 = DDINTS22
     C                   EVAL      V_WTDCRC22 = DDDCRC22
     C                   EVAL      V_WTEXCD22 = DDEXCD22
     C                   EVAL      V_WTBCWA22 = DDBCWA22
     C                   EVAL      V_WTRPCD22 = DDRPCD22
     C                   EVAL      V_WTTXBS22 = DDTXBS22
     C                   EVAL      V_WTRFSI22 = DDRFSI22
     C                   EVAL      V_WTDBTT22 = DDDBTT22
     C                   EVAL      V_WTTIN22  = DDTIN22
      *
     C                   EVAL      V_WTCRTT23 = DDCRTT23
     C                   EVAL      V_WTINTS23 = DDINTS23
     C                   EVAL      V_WTDCRC23 = DDDCRC23
     C                   EVAL      V_WTEXCD23 = DDEXCD23
     C                   EVAL      V_WTBCWA23 = DDBCWA23
     C                   EVAL      V_WTRPCD23 = DDRPCD23
     C                   EVAL      V_WTTXBS23 = DDTXBS23
     C                   EVAL      V_WTRFSI23 = DDRFSI23
     C                   EVAL      V_WTDBTT23 = DDDBTT23
     C                   EVAL      V_WTTIN23  = DDTIN23
      *
     C                   EVAL      V_WTCRTT24 = DDCRTT24
     C                   EVAL      V_WTINTS24 = DDINTS24
     C                   EVAL      V_WTDCRC24 = DDDCRC24
     C                   EVAL      V_WTEXCD24 = DDEXCD24
     C                   EVAL      V_WTBCWA24 = DDBCWA24
     C                   EVAL      V_WTRPCD24 = DDRPCD24
     C                   EVAL      V_WTTXBS24 = DDTXBS24
     C                   EVAL      V_WTRFSI24 = DDRFSI24
     C                   EVAL      V_WTDBTT24 = DDDBTT24
     C                   EVAL      V_WTTIN24  = DDTIN24
      *
     C                   EVAL      V_WTCRTT25 = DDCRTT25
     C                   EVAL      V_WTINTS25 = DDINTS25
     C                   EVAL      V_WTDCRC25 = DDDCRC25
     C                   EVAL      V_WTEXCD25 = DDEXCD25
     C                   EVAL      V_WTBCWA25 = DDBCWA25
     C                   EVAL      V_WTRPCD25 = DDRPCD25
     C                   EVAL      V_WTTXBS25 = DDTXBS25
     C                   EVAL      V_WTRFSI25 = DDRFSI25
     C                   EVAL      V_WTDBTT25 = DDDBTT25
     C                   EVAL      V_WTTIN25  = DDTIN25
      *
     C                   EVAL      V_WTCRTT26 = DDCRTT26
     C                   EVAL      V_WTINTS26 = DDINTS26
     C                   EVAL      V_WTDCRC26 = DDDCRC26
     C                   EVAL      V_WTEXCD26 = DDEXCD26
     C                   EVAL      V_WTBCWA26 = DDBCWA26
     C                   EVAL      V_WTRPCD26 = DDRPCD26
     C                   EVAL      V_WTTXBS26 = DDTXBS26
     C                   EVAL      V_WTRFSI26 = DDRFSI26
     C                   EVAL      V_WTDBTT26 = DDDBTT26
     C                   EVAL      V_WTTIN26  = DDTIN26
      *
     C                   EVAL      V_WTCRTT27 = DDCRTT27
     C                   EVAL      V_WTINTS27 = DDINTS27
     C                   EVAL      V_WTDCRC27 = DDDCRC27
     C                   EVAL      V_WTEXCD27 = DDEXCD27
     C                   EVAL      V_WTBCWA27 = DDBCWA27
     C                   EVAL      V_WTRPCD27 = DDRPCD27
     C                   EVAL      V_WTTXBS27 = DDTXBS27
     C                   EVAL      V_WTRFSI27 = DDRFSI27
     C                   EVAL      V_WTDBTT27 = DDDBTT27
     C                   EVAL      V_WTTIN27  = DDTIN27
      *
     C                   EVAL      V_WTCRTT28 = DDCRTT28
     C                   EVAL      V_WTINTS28 = DDINTS28
     C                   EVAL      V_WTDCRC28 = DDDCRC28
     C                   EVAL      V_WTEXCD28 = DDEXCD28
     C                   EVAL      V_WTBCWA28 = DDBCWA28
     C                   EVAL      V_WTRPCD28 = DDRPCD28
     C                   EVAL      V_WTTXBS28 = DDTXBS28
     C                   EVAL      V_WTRFSI28 = DDRFSI28
     C                   EVAL      V_WTDBTT28 = DDDBTT28
     C                   EVAL      V_WTTIN28  = DDTIN28
      *
     C                   EVAL      V_WTCRTT29 = DDCRTT29
     C                   EVAL      V_WTINTS29 = DDINTS29
     C                   EVAL      V_WTDCRC29 = DDDCRC29
     C                   EVAL      V_WTEXCD29 = DDEXCD29
     C                   EVAL      V_WTBCWA29 = DDBCWA29
     C                   EVAL      V_WTRPCD29 = DDRPCD29
     C                   EVAL      V_WTTXBS29 = DDTXBS29
     C                   EVAL      V_WTRFSI29 = DDRFSI29
     C                   EVAL      V_WTDBTT29 = DDDBTT29
     C                   EVAL      V_WTTIN29  = DDTIN29
      *
     C                   EVAL      V_WTCRTT30 = DDCRTT30
     C                   EVAL      V_WTINTS30 = DDINTS30
     C                   EVAL      V_WTDCRC30 = DDDCRC30
     C                   EVAL      V_WTEXCD30 = DDEXCD30
     C                   EVAL      V_WTBCWA30 = DDBCWA30
     C                   EVAL      V_WTRPCD30 = DDRPCD30
     C                   EVAL      V_WTTXBS30 = DDTXBS30
     C                   EVAL      V_WTRFSI30 = DDRFSI30
     C                   EVAL      V_WTDBTT30 = DDDBTT30
     C                   EVAL      V_WTTIN30  = DDTIN30

     C                   EVAL      V_WTLCD  = BJRDNB

     C                   IF        DDACTN <> 'I'
     C                   MOVEL     PTimeStamp    V_WTTMST
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATEDB - Update database                                   *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR

      ** Update

     C                   RESET                   ReturnCode

     C                   CALLB     'SDCUWTUPD'

      ** Ensure correct parameters for this UPD function

     C                   PARM                    PRTCD
     C                   PARM                    ValidCUWT

      ** If there were any errors in the update functions, rollback any
      ** updates (done in *PSSR) and end this program. Otherwise commit.

     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   EndIf

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     PRTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)

     C                   MOVEL     'USR7518'     MsgIdArr(1)

     C                   EndIf

     C                   ENDSR
      *****************************************************************
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
(c) Finastra International Limited 2007
