     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT details Validate & Update')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTM1012VU - Midas FT RFT details validate and update         *
      *                                                               *
      *  Function: This program validates RFT transactions for        *
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
      *  Last Amend No. 254598             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW215             Date 06Apr15               *
      *                 AR750695           Date 26Apr11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 BUG1901            Date 27Apr04               *
      *                 BUG1972            Date 20Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG575             Date 24Feb04               *
      *                 222373             Date 27Oct03               *
      *                 CAP084  *CREATE    Date 25Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  254598 - Increase length of DP32B and DATA2 (JMI106/113)     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  AR750695 - RFTD fails to create shadow postings. Expected    *
      *             data of core fix 212229 are not passed from *VU   *
      *             programs. Fix done as part of ABC Phase2 (CAP207) *
      *             (Child: AR750696)                                 *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  BUG1901 - db error encountered when amending or authorising  *
      *  BUG1972 - system hangs when inserting RFT details            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG575 - No 'reassign' action on detail row                  *
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
     D TranInRFTD    E DS                  EXTNAME(FT101DSPD)

      * Valid Incoming transaction in file format
     D ValInRFTD     E DS                  EXTNAME(FT101DPD)
     D                                     PREFIX(VL)

      * Current transaction record in file format
     D RFTDFilFmt    E DS                  EXTNAME(FT101DPD)
     D RFTHFilFmt    E DS                  EXTNAME(FT101HPD) PREFIX(H)

      * Current transaction in screen format
     D CurTrRFTD     E DS                  EXTNAME(FT101DSPD)
     D                                     PREFIX(@)
     D CurTrRFTH     E DS                  EXTNAME(FT101HSPD)
     D                                     PREFIX(@H)

      * Error indicators
     D OKTrRFTD      E DS                  EXTNAME(FTE101BPD)
     D OKTrRFTH      E DS                  EXTNAME(FTE101HBPD)
      *
      ** Ok RFT Credit Details
     D OKCre1        E DS                  EXTNAME(FTE101S1PD) PREFIX(OC)
     D OkCre2        E DS                  EXTNAME(FTE101S2PD)
     D OkCre3        E DS                  EXTNAME(FTE101S3PD)

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

      ** Current Incoming Debit Header Details                                              AR750695
     D NHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(NH)                     AR750695
      *                                                                                     AR750695
      ** Current Incoming Debit Details                                                     AR750695
     D NDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(ND)                     AR750695
      *                                                                                     AR750695
      ** Previous Incoming Debit Header Details                                             AR750695
     D PHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(PH)                     AR750695
      *                                                                                     AR750695
      ** Previous Incoming Debit Details                                                    AR750695
     D PDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(PD)                     AR750695
      *                                                                                     AR750695
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
     D Trans5003       S            500A

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
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** AOSARD parameters                                                                    CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
      **                                                                                      CSC022
                                                                                              BUG575
     D Len             S              5I 0                                                    BUG575

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
     C                   MOVE      Trans5003     TEMP4           500
     C                   EVAL      DDACTN = %SUBST(Trans5001:1:1)
     C                   EVAL      TEMP1  = %SUBST(Trans5001:2)
     C     TEMP1         CAT       TEMP2         TEMP3           999
     C     TEMP3         CAT       TEMP4         TEMP5          1499
     C                   EVAL      TranInRFTD  = TEMP5
     C                   EVAL      Len = %LEN(TranInRFTD) - %LEN(Trans5001)     BUG575
     C                                   - %LEN(Trans5002) +2                   BUG575
     C                   EVAL      OldRftId=%SUBST(Trans5003:LEN:15)            BUG575
     C                   EVAL      PRFTMSQ = 0
     C                   EVAL      PRFTMRF = 0
     C                   Clear                   NHdrRcdIn                                  AR750695
     C                   Clear                   NDtlRcdIn                                  AR750695
     C                   Clear                   PHdrRcdIn                                  AR750695
     C                   Clear                   PDtlRcdIn                                  AR750695

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
     C                                OR DDACTN = 'R'                           BUG575
     C                   EXSR      ValidateTr

      * Processing for amends or changes
     C                   WHEN         DDACTN = 'A'
     C                   EXSR      ValdateAmd

      * If error in validation, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

     C                   EXSR      ValidateTr

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
     C                   EVAL                    Buffer = DDACTN+TranInRFTD
     C                                                    + OldRftID            BUG575

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
     C                   PARM                    Trans5003
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

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'MEMSG'                                     CSW215

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
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
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
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTM1012VU'                                       CSC022
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
     C                   IF        DDACTN <>'I' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'A' AND DDACTN <> 'D' AND
     C                             DDACTN <> 'R' AND                            BUG575
     C                             DDACTN <> *BLANKS

     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   MOVE      'RFCB012'     MsgIdArr(Idx)
     C                   GOTO      ENDVALAC
     C                   ENDIF

     C                   RESET                   ReturnCode

     C*************      IF        DDACTN <> 'I'                                BUG575
     C                   IF        DDACTN <> 'I' AND DDACTN <> 'R'              BUG575
     C                   CALLB     'FTM1012RV'

      * Return code
     C                   Parm                    ReturnCode
      * Action Code
     C                   Parm                    DDACTN            1
      * (Midas) RFT ID
     C                   Parm      PRFTHDR       @@RFTID          15
     C                   Parm      PTRNSID       @@TRANR          16
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
     C                   Parm      *BLANKS       SQ101B            2
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * RFT Header Record
     C                   Parm                    RFTDFilFmt
      * Key Pressed
     C                   Parm      *BLANKS       @KeyP             2
      * Details of the message
     C                   Parm                    Phead
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      * Message ref array
     C                   PARM                    MREFARR
      * Message part array
     C                   PARM                    MPRTARR

      ** Errors produced during retrieve operation
     C                   Parm                    OKTrRFTD
     C                   Parm                    Idx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
      *                                                                                     AR750695
      ** Store original values of the transaction                                           AR750695
      *                                                                                     AR750695
     C                   EVAL      PDtlRcdIn = RFTDFilFmt                                   AR750695
     C                   ENDIF

     C                   IF        DDACTN = 'R'                                 BUG575
     C                   MOVE      OldRftID      @@RFTID                        BUG575
     C                   ELSE                                                   BUG575
     C                   MOVE      PRFTHDR       @@RFTID                        BUG575
     C                   ENDIF                                                  BUG575
                                                                                BUG575
      * Retrieve header details
     C                   CALLB     'FTM1011RV'

      * Return code
     C                   Parm                    ReturnCode
      * Action Code
     C                   Parm                    DDACTN            1
      * Rft type
     C                   Parm      *BLANKS       @RftTyp           2
      * (Midas) RFT ID
     C*******************Parm      PRFTHDR       @@RFTID          15            BUG575
     C                   Parm                    @@RFTID                        BUG575
      * Swift reference (ALSO OUPUT)
     C                   Parm      *BLANKS       SWIFTR           28
      * Message unique reference (for STP)
     C***************    Parm      *ZEROS        MGMSGR            8 0                        222373
     C                   Parm      *ZEROS        MGMSGR                                       222373
      * RFT Header Record
     C                   Parm                    RFTHFilFmt
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
     C                   Parm                    OKTrRFTH
     C                   Parm                    Idx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr

      ** If authorised, you cannot action the RFT
     C                   IF        HAUIN = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx)='DDACTN'
     C                   MOVE      'RFV0065'     MsgIdArr(Idx)
     C                   GOTO      ENDVALAC
     C                   ENDIF

      * Convert header details into screen format to use in validation
     C                   CALLB     'FTM1011CT'
      * Return Code
     C                   Parm                    ReturnCode
      *                                                                         BUG1901
      ** Action Code                                                            BUG1901
      *                                                                         BUG1901
     C                   Parm                    Actn              1            BUG1901
      *
      * Type of Conversion
     C                   Parm      'SH'          CnvTyp            2
      *
      * RFT Header Details in file format
     C                   Parm                    RFTHFilFmt
      *
      * MT101 details in message format
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      ** Message reference
     C                   PARM                    MGMSGR
      *
      * RFT details in screen format
     C                   Parm                    CurTrRFTH

     C     ENDVALAC      TAG

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

     C                   CALLB     'FTM1013VL'
      *
     C                   PARM                    ReturnCode
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    CurTrRFTH
     C                   PARM                    TranInRFTD
      *
     C                   PARM                    OkCre1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM      0             Idx
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    WIdx

     C                   IF        Idx <> 0
     C                   GOTO      ENDVALTR
     C                   ENDIF

     C                   CALLB     'FTM1014VL'
      *
     C                   PARM                    ReturnCode
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    CurTrRFTH
     C                   PARM                    TranInRFTD
      *
     C                   PARM                    OkCre2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM      0             Idx
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    WIdx

     C                   IF        Idx <> 0
     C                   GOTO      ENDVALTR
     C                   ENDIF

     C                   CALLB     'FTM1015VL'
      *
     C                   PARM                    ReturnCode
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    CurTrRFTH
     C                   PARM                    TranInRFTD
      *
     C                   PARM                    OkCre3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM      0             Idx
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    WIdx

     C     ENDVALTR      TAG

     C     EValidTr      ENDSR
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

     C                   CALLB     'FTM1012CT'
      * Return Code
     C                   Parm                    ReturnCode
      *                                                                         BUG1972
      ** Action Code                                                            BUG1972
      *                                                                         BUG1972
     C                   Parm                    Actn              1            BUG1972
      *
      * Type of Conversion
     C                   Parm      'SC'          CnvTyp            2
      *
      * RFT Header Details in file format
     C                   Parm                    RFTDFilFmt
      *
      * MT101 details in message format
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
      *
      * RFT details in screen format
     C                   Parm                    CurTrRFTD

      * Transaction reference cannot be amended
     C     PTRNSID       IFNE      @PTRNSID
     C                   ADD       1             AmIdx
     C                   EVAL      AmFldNamAr(AmIdx) = 'PTRNSID'
     C                   EVAL      AmMsgIdArr(AmIdx)   = 'RFV0910'
     C                   EVAL      AmMsgDtaAr(AmIdx)  = @PTRNSID
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

     C                   CLEAR                   CurTrRFTD

     C                   MOVE      *ALL'Y'       OKTrRFTD
     C                   MOVE      *ALL'Y'       OkCre1
     C                   MOVE      *ALL'Y'       OkCre2
     C                   MOVE      *ALL'Y'       OkCre3

     C                   CLEAR                   ValInRFTD

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

     C                   CALLB     'FTM1012CT'
      * Return Code
     C                   Parm      *BLANKS       ReturnCode
      *                                                                         BUG1972
      ** Action Code                                                            BUG1972
      *                                                                         BUG1972
     C                   Parm                    Actn              1            BUG1972
      *
      * Type of Conversion
     C                   Parm      'FC'          CnvTyp            2
      *
      * RFT Header Details in file format
     C                   Parm      *BLANKS       ValInRFTD
      *
      * MT101 details in message format
     C                   Parm      *BLANKS       PHEAD
     C                   Parm      *BLANKS       PDATA
     C                   Parm      *BLANKS       PDAT2                                        CSW209
      *
      * RFT details in screen format
     C                   Parm                    TranInRFTD

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

     C                   EVAL      NDtlRcdIn = ValInRFTD                                    AR750695
      * Remove all forward positions.
     C                   CALLB     'FTM101UPP'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM      'R'           AddRemove         1
     C                   PARM                    VLRFTID
     C                   PARM      *BLANKS       NHdrRcdIn                                  AR750695
     C                   PARM                    NDtlRcdIn                                  AR750695
     C                   PARM      *BLANKS       PHdrRcdIn                                  AR750695
     C                   PARM                    PDtlRcdIn                                  AR750695
     C                   PARM      'N'           HdrInfo                                    AR750695
     C                   PARM      'Y'           DtlInfo                                    AR750695
     C                   PARM      'N'           FTSTP             1                        AR750695

     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'FTM101UPP'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = AddRemove
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   RESET                   ReturnCode

     C                   CALLB     'FTM101UPD'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM                    RFTHFilFmt
     C                   PARM                    ValInRFTD
     C                   PARM      'N'           HdrInfo           1
     C                   PARM      'Y'           DtlInfo           1
     C*******************PARM      *BLANKS       OldRftID         15            BUG575
     C*******************PARM      *BLANKS       OldTransID       16            BUG575
     C                   PARM                    OldRftID         15            BUG575
     C                   PARM      PTRNSID       OldTransID       16            BUG575
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

     C                   RESET                   ReturnCode
     C                   EVAL      NDtlRcdIn = ValInRFTD                                    AR750695
      *
      ** Update forward positions file.
      *
     C                   CALLB     'FTM101UPP'
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
     C                   PARM      'A'           AddRemove
     C                   PARM                    VLRFTID
     C                   PARM      *BLANKS       NHdrRcdIn                                  AR750695
     C                   PARM                    NDtlRcdIn                                  AR750695
     C                   PARM      *BLANKS       PHdrRcdIn                                  AR750695
     C                   PARM                    PDtlRcdIn                                  AR750695
     C                   PARM      'N'           HdrInfo                                    AR750695
     C                   PARM      'Y'           DtlInfo                                    AR750695
     C                   PARM      'N'           FTSTP                                      AR750695
      *
      ** If errors
     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'FTM101UPP'
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

      * Return Transaction id as this is defaulted
     C                   IF        DDACTN = 'I'
     C                   EVAL      PTRNSID = VLTRNSID
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
