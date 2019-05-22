     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT Validate & Update')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1021VU - Midas FT CCT validate and update                 *
      *                                                               *
      *  Function: This program validates CCT transactions for        *
      *            input into the Midas database.                     *
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
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15263           Date 09Nov07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG1901            Date 27Apr04               *
      *                 BUG1944            Date 20Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 27Oct03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15263 - Error upon authorisation with insufficient funds  *
      *             funds must only be a warning                      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG1901 - db error encountered when amending or authorising  *
      *  BUG1944 - Edit RFTD give Blank input form                    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter mismatch                                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
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
 
     D/COPY MECPYSRC,ME1100_ILE
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
     D TranInCCTD    E DS                  EXTNAME(FT102HSPD)
     D PPBRCA        E                     EXTFLD(PBRCA)
 
      * Valid Incoming transaction in file format
     D ValInCCTD     E DS                  EXTNAME(FT102HPD)
     D                                     PREFIX(VL)
 
      * Current transaction record in file format
     D CCTDFilFmt    E DS                  EXTNAME(FT102HPD)
 
      * Current transaction in screen format
     D CurTrCCTD     E DS                  EXTNAME(FT102HSPD)
     D                                     PREFIX(@)
 
      ** Current Incoming Debit Details screen format
     D DtlScnFmt     E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** Current Incoming Debit Details
     D DtlRcdIn      E DS                  EXTNAME(FT102DPD) PREFIX(CR)
 
      * Error indicators
     D OKTrCCTD      E DS                  EXTNAME(FTE102HBPD)
      *
      ** Ok CCT Header Details
     D OKHdr1        E DS                  EXTNAME(FTE102H1PD) PREFIX(O1)
     D OKHdr2        E DS                  EXTNAME(FTE102H2PD) PREFIX(O2)
 
     D MREFARR         S              8    DIM(100)
      ** Message reference array
 
     D MPRTARR         S              3    DIM(100)
      ** Message part array
 
      **                                                                                      CSC022
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **                                                                                      CSC022
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** AOSARD parameters                                                                    CSC022
     D PRtCde          S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
      **                                                                                      CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
     D Trans5002       S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              222373
      ** Message reference (input parameter)                                                  222373
     D MGMSGR          S                   LIKE(PHMSGR)                                       222373
 
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
     C                   MOVE      *BLANKS       TEMP1           499
     C                   MOVE      Trans5002     TEMP2           500
     C                   EVAL      DDACTN = %SUBST(Trans5001:1:1)
     C                   EVAL      TEMP1  = %SUBST(Trans5001:2)
     C     TEMP1         CAT       TEMP2         TEMP3           999
     C                   EVAL      TranInCCTD  = TEMP3
     C                   EVAL      PCHMSGR = 0
 
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
     C                   WHEN         DDACTN = 'I'
     C                   EXSR      ValidateTr
 
      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValdateAmd
 
      * If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   EXSR      ValidateTr
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C                   EVAL                    Buffer = DDACTN+TranInCCTD
 
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
     C                   PARM                    Trans5002
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
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTM102M01
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
 
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCde                                       CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCde = *BLANKS                                           CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCde <> '*NRF'                                           CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTM1021VU'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 003                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
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
      * The Transaction in file format from the Sk database is retrieved
      * as well.
     C                   IF        DDACTN <>'I' AND  DDACTN <> 'X' AND
     C                             DDACTN <> 'A' AND DDACTN <> 'D' AND
     C                             DDACTN <> 'E' AND DDACTN <> *BLANKS
 
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   MOVE      'RFV0064'     MsgIdArr(Idx)
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   RESET                   ReturnCode
 
     C                   IF        DDACTN <> 'I'
     C                   CALLB     'FTM1021RV'
 
      * Return code
     C                   Parm                    ReturnCode
      * Action Code
     C                   Parm                    DDACTN            1
      * CCT type
     C                   Parm      *BLANKS       @CCTTyp           2
      * File ref
     C                   Parm      *BLANKS       @FilRef          16
      * (Midas) CCT ID
     C                   Parm      PCCTID        @@CCTID          15
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * CCT Header Record
     C                   Parm                    CCTDFilFmt
      * Key Pressed
     C                   Parm      *BLANKS       @KeyP             2
      * Details of the message
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      * Message ref array
     C                   PARM                    MREFARR
      * Message part array
     C                   PARM                    MPRTARR
 
      ** Errors produced during retrieve operation
     C                   Parm                    OKTrCCTD
     C                   Parm                    Idx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** If authorised, you cannot action the CCT
 
     C                   IF        AUIN = 'Y' OR DDACTN <> 'X' AND
     C                             AUP1 <> *BLANKS
 
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   MOVE      'RFV0091'     MsgIdArr(Idx)
 
     C                   ELSE
 
      ** If action code is authorise, user must not be the same as authorise
      ** user on file
 
     C                   IF        DDACTN = 'X'
 
      * Validate user authorisation threshold
     C                   CallB     'FTVTHHD01'
     C                   Parm                    RetCodeIn
     C                   Parm                    CCTDFilFmt
 
      * Validate header and detail records
 
     C                   MOVE      INUSER        SAVUSER          10
     C                   CallB     'FTM1026VL'
     C                   Parm      *BLANKS       ValErrCde        10
     C                   Parm                    DDACTN
     C                   Parm                    CCTDFilFmt
     C                   Parm                    DtlRcdIn
     C                   Eval      Inuser = SavUser
 
      * Check for insufficient funds
 
     C                   EVAL      PRTCD = *BLANKS
 
     C                   IF        CCTTYP = 'BO' AND
     C                             VALERRCDE <> '*VALERROR'
 
     C**********         CALLB     'FTVCKIF01'                                              BUG15263
     C**********         PARM                    PRTCD            10                        BUG15263
     C**********         PARM                    PCCTID                                     BUG15263
 
     C                   ENDIF
 
     C                   Select
 
     C                   When      ValErrCde = '*VALERROR'
 
     C                   Add       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   Move      'RFV0146'     MsgIdArr(Idx)
 
     C                   When      RetCodeIn = 'TooSmall'
 
     C                   Add       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   Move      'RFV0142'     MsgIdArr(Idx)
 
     C**********         WHEN      PRTCD = '*NOFUNDS'                                       BUG15263
 
     C**********         ADD       1             Idx                                        BUG15263
     C**********         EVAL      FldNameArr(Idx)='DDACTN'                                 BUG15263
     C**********         Move      'FTM2412'     MsgIdArr(Idx)                              BUG15263
 
     C                   Endsl
 
      ** Retrieve user
     C                   CALL      'SFC000026'
     C*******************PARM      *BLANKS       USER             10            BUG1901
     C                   PARM      *BLANKS       USERNAME         10            BUG1901
      *
 
     C*******************If        user = inuser  or                            BUG1901
     C*******************          user = updusr                                BUG1901
     C                   If        username = inuser  or                        BUG1901
     C                             username = updusr                            BUG1901
 
     C                   Add       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   Move      'RFV0075'     MsgIdArr(Idx)
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   ENDIF
 
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate transaction details
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FTM1028VL'
      *
     C                   PARM                    ReturnCode
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    TranInCCTD
     C                   PARM                    DtlScnFmt
      *
     C                   PARM                    OKHdr1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM                    Idx
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    WIdx
 
     C                   IF        Idx <> 0
     C                   GOTO      ENDVALTR
     C                   ENDIF
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FTM1027VL'
      *
     C                   PARM                    ReturnCode
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    TranInCCTD
      *
     C                   PARM                    OKHdr2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM                    Idx
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    WIdx
                                                                                            BUG15263
     C                   EXSR      CHKFUNDS                                                 BUG15263
 
     C     ENDVALTR      TAG
     C     EValidTr      ENDSR
      *****************************************************************                     BUG15263
      /EJECT                                                                                BUG15263
      *****************************************************************                     BUG15263
     C     CHKFUNDS      BEGSR                                                              BUG15263
                                                                                            BUG15263
      * Check for insufficient funds                                                        BUG15263
                                                                                            BUG15263
     C                   EVAL      PRTCD = *BLANKS                                          BUG15263
                                                                                            BUG15263
     C                   IF        CCTTYP = 'BO' AND                                        BUG15263
     C                             VALERRCDE <> '*VALERROR'                                 BUG15263
                                                                                            BUG15263
     C                   CALLB     'FTVCKIF01'                                              BUG15263
     C                   PARM                    PRTCD            10                        BUG15263
     C                   PARM                    PCCTID                                     BUG15263
                                                                                            BUG15263
     C                   ENDIF                                                              BUG15263
                                                                                            BUG15263
     C                   IF        PRTCD = '*NOFUNDS'                                       BUG15263
                                                                                            BUG15263
     C                   ADD       1             WIdx                                       BUG15263
     C                   EVAL      WFldNamArr(WIdx) = 'DDACTN'                              BUG15263
     C                   EVAL      WMsgIdArr(WIdx) = 'FTM7113'                              BUG15263
                                                                                            BUG15263
     C                   EndIF                                                              BUG15263
                                                                                            BUG15263
     C                   ENDSR                                                              BUG15263
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      * Convert file format to screen format
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FTM1021CT'
      * Return Code
     C                   Parm                    ReturnCode
      *                                                                         BUG1944
      ** Action Code                                                            BUG1944
      *                                                                         BUG1944
     C                   Parm                    Actn              1            BUG1944
      *
      * MT102 details in message format
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      ** Message reference
     C                   PARM                    MGMSGR
      *
      * Type of Conversion
     C                   Parm      'SH'          CnvTyp            2
      *
      * CCT Header Details in file format
     C                   Parm                    CCTDFilFmt
      *
      * CCT details in screen format
     C                   Parm                    CurTrCCTD
 
      * File reference cannot be amended
     C     PFILREF       IFNE      @PFILREF
     C                   ADD       1             AmIdx
     C                   EVAL      AmFldNamAr(AmIdx) = 'PFILREF'
     C                   EVAL      AmMsgIdArr(AmIdx)   = 'RFV0912'
     C                   EVAL      AmMsgDtaAr(AmIdx)  = @PFILREF
     C                   ENDIF
 
      * CCT type cannot be amended
     C     PCCTTYP       IFNE      @PCCTTYP
     C                   ADD       1             AmIdx
     C                   EVAL      AmFldNamAr(AmIdx) = 'PCCTTYP'
     C                   EVAL      AmMsgIdArr(AmIdx)   = 'RFV0911'
     C                   EVAL      AmMsgDtaAr(AmIdx)  = @PCCTTYP
     C                   ENDIF
 
      * If any errors overwrite previous error information
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
 
     C                   CLEAR                   CurTrCCTD
 
     C                   MOVE      *ALL'Y'       OKTrCCTD
     C                   MOVE      *ALL'Y'       OKHdr1
     C                   MOVE      *ALL'Y'       OKHdr2
 
     C                   CLEAR                   ValInCCTD
 
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
 
     C                   CALLB     'FTM1021CT'
      * Return Code
     C                   Parm      *BLANKS       ReturnCode
      *                                                                         BUG1944
      ** Action Code                                                            BUG1944
      *                                                                         BUG1944
     C                   Parm                    Actn              1            BUG1944
      *
      * MT102 details in message format
     C                   Parm      *BLANKS       PDATA
     C                   Parm      *BLANKS       PDAT2                                        CSW209
      *
      ** Message reference
     C                   PARM      *ZEROS        MGMSGR
      *
      * Type of Conversion
     C                   Parm      'FH'          CnvTyp            2
      *
      * CCT Header Details in file format
     C                   Parm      *BLANKS       ValInCCTD
      *
      * CCT details in screen format
     C                   Parm                    TranInCCTD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      * Update
     C                   RESET                   ReturnCode
 
      * Remove all forward positions.
     C                   CALLB     'FTM102UPP'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM      'R'           AddRemove         1
     C                   PARM                    VLCCTID
 
     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'FTM102UPP'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = AddRemove
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FTM102UPD'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM                    ValInCCTD
     C                   PARM      *BLANKS       DtlRcdIn
     C                   PARM      'Y'           HdrInfo           1
     C                   PARM      'N'           DtlInfo           1
     C                   PARM      *BLANKS       OldCCTID         15
     C                   PARM      *BLANKS       OldTransID       16
     C                   PARM      PSJobName     @CallingPg       10
     C                   PARM      PNWRK         @Network          6
      *  Errors produced during I/O operation
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
 
      * Return CCT ID as this is defaulted and sender's reference
     C                   IF        DDACTN = 'I'
     C                   EVAL      PCCTID = VLCCTID
     C                   EVAL      PFILREF = VLFILREF
     C                   ENDIF
      *
     C                   CALLB     'FTVHDAM01'
     C                   PARM                    RetCodeIn
     C                   PARM                    TRANINCCTD
      *
      ** If errors
      *
     C                   If        RetCodeIn <> *BLANK
     C                   Eval      DBFILE = 'FT102SUMS'
     C                   Eval      DBASE = 003
     C                   Eval      DBKEY = *BLANK
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   ELSE
 
     C                   RESET                   ReturnCode
      *
      ** Update forward positions file.
      *
     C                   CALLB     'FTM102UPP'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM      'A'           AddRemove
     C                   PARM                    VLCCTID
      *
      ** If errors
     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'FTM102UPP'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = AddRemove
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ELSE
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
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
(c) Finastra International Limited 2003
