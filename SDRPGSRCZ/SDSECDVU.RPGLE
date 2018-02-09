     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients Validate & Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data  ILE Module                            *
      *                                                               *
      *  SDSECDVU - Securities details  validate and update           *
      *                                                               *
      *  Function: This program validates Securities details for      *
      *            input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
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
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1005480          Date 16Jul12               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 13May12               *
      *                 AR875962           Date 15Dec11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22155           Date 16Jan09               *
      *                 243070             Date 10Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12213           Date 07Dec06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3122            Date 09Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1005480 - Depot customer reference error                   *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *           - Applied fix for AR989192 (Child:AR989193)         *
      *  AR875962 - Customer not found when creating a new customer   *
      *  BUG22155 - Missing authorization field in repository.        *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  BUG12213 - Depot details missing on wholesale customer input *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Amendment due to addition of zone field.           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *                                                                                     BUG12213
     FSDVCSDRL3 UF A E           K DISK    INFSR(*PSSR)                                     BUG12213
     F                                     PREFIX(EV_)                                      BUG12213
     F                                     COMMIT                                           BUG12213
     FSDVCSDRL1 UF A E           K DISK    INFSR(*PSSR)                                     BUG12213
     F                                     RENAME(SDVCSDRD0:SDVCSDRD1)                      BUG12213
     F                                     COMMIT                                           BUG12213
      *                                                                                     BUG12213
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInSecd    E DS                  EXTNAME(SDSECDPD)
 
      * Valid Customer Securities Details layout
     D ValidSecd     E DS                  EXTNAME(SDVSECDPD)
     D                                     PREFIX(V_)
 
      * (Current) Customer record in file Format
     D SecdFilFmt    E DS                  EXTNAME(SDSECSPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      * (Current) Customer in Screen Format - Main Details
     D CurCuSecd     E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKCuSecd      E DS                  EXTNAME(SDESECDPD)
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D*ExtData**     E DS                  EXTNAME(SDSEEXPD)                                 BUG3122
      **SD*Customer*Security*details*Extra*Data*-*File*(D/B)*format****                      BUG3122
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                 BUG3122
      ** EXTERNAL DS FOR SECURITIES ICD DATA                                                 BUG3122
 
      ** Customer Depot Reference
     D PDepotRef     E DS                  EXTNAME(SDCSDSPD)
     D                                     PREFIX(ES_)
 
      ** Customer Depot Reference OK indicators
     D PDepotRefOK   E DS                  EXTNAME(SDECSDRPD)
     D                                     PREFIX(EO_)
 
      ** Valid Customer Depository Reference File
     D PValidDepot   E DS                  EXTNAME(SDVCSDRPD)
 
     D DepData         DS
     D**PDepCtr                1      3  0                                                  BUG12213
     D**PDepDet                4   4755                                                     BUG12213
     D  PDepDet                1   4050                                                     BUG12213
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepSecd         S              1A   inz('N')
 
      ** Depository Definition Enhancement Indicator
     D CSE022          S              1A
 
      ** Counter for CSE022 Enhancement
     D WCounter        S              3  0
     D DOwctr          S              1A                                                    BUG12213
     D WkCnt           S              3  0
 
     D WFirst          S              1A
     D X1              S              4  0
     D X2              S              4  0
     D X3              S              4  0
 
     D DBerrUpd        C                   CONST('DB error in CUSD API update')
     D DepotName       DS                                                                    BUG3122
     D  DDDSN1                 1     10                                                      BUG3122
     D  DDDSN2                11     20                                                      BUG3122
     D  DDDSN3                21     30                                                      BUG3122
     D  DDDSN4                31     40                                                      BUG3122
     D  DDDSN5                41     50                                                      BUG3122
     D  DDDSN6                51     60                                                      BUG3122
     D  DDDSN7                61     70                                                      BUG3122
     D  DDDSN8                71     80                                                      BUG3122
     D  DDDSN9                81     90                                                      BUG3122
     D  DDDSN0                91    100                                                      BUG3122
     D WRDAY           S                   LIKE(BJRDNB)                                      BUG3122
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInSecd
     C**********         MOVEL     Extdata500    Extdata                                     BUG3122
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateTr
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *  Processing for Amends or Changes
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
 
     C     GHSUBS        scan      TranInSecd                             99
     C                   if        *in99
     C                   eval      RepSecd = 'Y'
     C                   endif
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        RepSecd = 'Y'
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
      **                 (End of "if DDACTN = 'A' and GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
     C                   MOVEA     Depotsn       DepotName                                   BUG3122
     C                   EVAL      @DDCUSN = DDCUSN                                          BUG3122
     C**********         EVAL                    Buffer = TranInSecd
     C**********                                 + ExtData
     C**********         EVAL      Buffer = TraninSecd + Depotname                           BUG3122
     C**********                   + DDCSSN + DDCRNM + DDCRTN + BVACOP + BVCUIN     BUG3122 BUG12213
     C**********                       + BVDR1 + BVDR2 + BVDR3 + BVDR4 + BVDR5      BUG3122 BUG12213
     C**********                       + BVDR6 + BVDR7 + BVDR8 + BVDR9 + BVDR10     BUG3122 BUG12213
     C**********         EVAL      Buffer = TraninSecd + DepData                  BUG12213 AR1005480
     C                   EVAL      Buffer = TraninSecd + AAuth + DepData                   AR1005480
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Customer number supplied                                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = '*VU   '                                      AR971184
     C                   ENDIF                                                              AR971184
      * Validate action code versus transaction IDs supplied
      * The Customer in file format from the SD database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   EVAL      WRDAY = BJRDNB                                            BUG3122
     C                   CALLB     'SDSECDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C**********         PARM      '      '      ModeofOp          6                        AR875962
     C**********         PARM      '*VU   '      ModeofOp          6               AR875962 AR971184
     C                   PARM                    ModeofOp          6                        AR971184
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
      * (Midas) Customer Number
     C                   PARM                    DDCUSN            6
      *
      * (Midas) Customer Number/Shortname
     C                   PARM                    DDCSST           10
      *
      * OUTPUTS
      *
      * (Current) Security Customer in file format
     C                   PARM                    SecdFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDCusnOK          1
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN           10
 
      ** Customer Report Name
     C                   PARM                    DDCRNM           20
 
      ** Customer Report Town
     C                   PARM                    DDCRTN           10
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Customer into the Valid
      *  file record - fields in this will be updated during processing
 
     C**********         MOVE      SecdFilFmt    ValidSecd                                   BUG3122
     C                   MOVEL     SecdFilFmt    ValidSecd                                   BUG3122
 
      * For Amends, convert the Securities Customer to screen format
 
     C                   CALLB     'SDSECDCVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Security Customer - file formats
     C                   PARM                    ValidSecd
      *
      * Output parameters
      *
      * Security Customer Details - screen formats
     C                   PARM                    CurCuSecd
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Security Customer Client details
 
     C                   EXSR      ValdCuSecd
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      ** If CSE022 is installed
 
     C                   IF        CSE022 = 'Y'
 
     C                   EVAL      WCounter = 0
     C                   EVAL      WFirst = 'Y'
 
     C                   EVAL      ES_DDCUST = DDCUSN
 
      ** If classification is 'E' or 'C' other depot not allowed.
 
     C**********         IF        PDepCtr > 0                                             BUG12213
     C                   IF        DepData <> *Blanks                                      BUG12213
     C                   IF        DDCLAS = 'C' OR DDCLAS = 'E'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY  '
     C                   EVAL      MsgIDArr(Idx) = 'USR9118'
     C                   ELSE
 
      ** Check if all ten depot reference has been entered.
 
     C                   EVAL      WkCnt = 1
     C                   DOW       WkCnt <= 10
 
     C                   IF        DepotSn(WkCnt) = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY  '
     C                   EVAL      MsgIDArr(Idx) = 'USR9118'
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WkCnt = WkCnt + 1
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
 
     C**********         DOW       PDepCtr > WCounter AND                                   BUG12213
     C**********                   Idx = 0                                                  BUG12213
     C                   EVAL      DoWctr = 'N'                                             BUG12213
     C                   DOW       DoWctr = 'N'                                             BUG12213
                                                                                            BUG12213
     C                   EVAL      WCounter = WCounter + 1                                  BUG12213
 
     C                   EXSR      SRSetValDep
 
     C                   IF        ES_DDDPOT = *BLANKS AND                                  BUG12213
     C                             ES_DDREFN = *BLANKS                                      BUG12213
     C                   EVAL      DOwctr = 'Y'                                             BUG12213
     C                   ENDIF                                                              BUG12213
 
     C                   IF        DOwctr = 'N'                                             BUG12213
                                                                                            BUG12213
     C                   CALLB     'SDCDRFVAL'
 
      * Response mode
     C                   PARM      *BLANKS       RespMode
 
      ** Customer Depository Reference
     C                   PARM                    PDepotRef
 
      ** Security Customer Client Details
     C                   PARM                    TranInSecd
 
      ** Customer Depository OK Indicators
     C                   PARM                    PDepotRefOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Valid Customer Depository Reference File
     C                   PARM                    PValidDepot
 
     C**********         EVAL      WCounter = WCounter + 1                                  BUG12213
 
     C                   ENDIF                                                              BUG12213
     C                   ENDDO
 
     C                   IF        Idx = 0                                                  BUG12213
     C                   EVAL      EV_DSCUST = DDCUSN                                       BUG12213
     C                   EVAL      WFirst = 'Y'                                             BUG12213
     C                   EVAL      WCounter = WCounter - 1                                  BUG12213
                                                                                            BUG12213
     C                   DO        WCounter                                                 BUG12213
                                                                                            BUG12213
      ** Format fields for output to file                                                   BUG12213
                                                                                            BUG12213
     C                   EXSR      SRSetValDep1                                             BUG12213
                                                                                            BUG12213
     C                   WRITE     SDVCSDRD0                            59                  BUG12213
                                                                                            BUG12213
     C                   ENDDO                                                              BUG12213
     C                   ENDIF                                                              BUG12213
                                                                                            BUG12213
     C                   ENDIF
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetValDep - Set-up fields for depot reference validation    *
      *                                                               *
      *****************************************************************
 
     C     SRSetValDep   BEGSR
 
     C                   IF        WCounter > 150                                           BUG12213
     C                   EVAL      ES_DDDPOT = *BLANKS                                      BUG12213
     C                   EVAL      ES_DDREFN = *BLANKS                                      BUG12213
     C                   ELSE                                                               BUG12213
                                                                                            BUG12213
     C                   IF        WFirst = 'Y'
 
     C                   Z-ADD     1             X1
     C                   Z-ADD     2             X2
     C                   Z-ADD     8             X3
 
     C                   ELSE
 
     C                   EVAL      X1 = X1 + 27
     C                   EVAL      X2 = X2 + 27
     C                   EVAL      X3 = X3 + 27
 
     C                   ENDIF
 
     C                   EVAL      ES_DDACTN = %SUBST(PDepDet:X1:1)
     C                   EVAL      ES_DDDPOT = %SUBST(PDepDet:X2:6)
     C                   EVAL      ES_DDREFN = %SUBST(PDepDet:X3:20)
 
     C                   EVAL      WFIRST = 'N'
 
     C                   ENDIF                                                              BUG12213
                                                                                            BUG12213
     C                   ENDSR
 
      *****************************************************************                     BUG12213
      /EJECT                                                                                BUG12213
      *****************************************************************                     BUG12213
      *                                                               *                     BUG12213
      * SRSetValDep1- Set-up fields for depot reference validation 1  *                     BUG12213
      *                                                               *                     BUG12213
      *****************************************************************                     BUG12213
                                                                                            BUG12213
     C     SRSetValDep1  BEGSR                                                              BUG12213
                                                                                            BUG12213
     C                   IF        WFirst = 'Y'                                             BUG12213
                                                                                            BUG12213
     C                   Z-ADD     2             X2                                         BUG12213
     C                   Z-ADD     8             X3                                         BUG12213
                                                                                            BUG12213
     C                   ELSE                                                               BUG12213
                                                                                            BUG12213
     C                   EVAL      X2 = X2 + 27                                             BUG12213
     C                   EVAL      X3 = X3 + 27                                             BUG12213
                                                                                            BUG12213
     C                   ENDIF                                                              BUG12213
                                                                                            BUG12213
     C                   EVAL      EV_DSDPOT = %SUBST(PDepDet:X2:6)                         BUG12213
     C                   EVAL      EV_DSREFN = %SUBST(PDepDet:X3:20)                        BUG12213
                                                                                            BUG12213
     C                   EVAL      WFIRST = 'N'                                             BUG12213
                                                                                            BUG12213
     C                   ENDSR                                                              BUG12213
                                                                                            BUG12213
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuSecd - Validate Security Customer Client details        *
      *                                                               *
      *****************************************************************
     C     ValdCuSecd    BEGSR
 
     C                   CALLB     'SDSECDVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Security Customer Client Details
     C                   PARM                    TranInSecd
 
      ** Automatic Settlement of Trades                                                       222373
     C                   PARM                    CSE039                                       222373
      * OUTPUTS
 
      *
      ** Security Details OK inds
     C                   PARM                    OKCuSecd
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid Security Customer Client (DS) from/to caller
     C                   PARM                    ValidSecd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
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
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_SETYLC = DDACTN
     C                   EVAL      V_SECUST = DDCUSN
     C                   EVAL      V_SENARR = DDNARR                                         BUG3122
 
      * Include Header fields that need to be o/p to the Valid file
     C**********         IF        APFOTranID <> ' ' and                          AR971184 AR971184A
     C**********                   DDACTN = 'I'                                   AR971184 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      V_SEFRNT = APFOTranID
     C                   EVAL      V_SEAFRT = APFOAsocID
     C                   EVAL      V_SEREPA = APRprLocn
     C                   ENDIF                                                              AR971184
 
     C                   EVAL      TranStatus = 'S'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      * Securities Clients Details Updates
      *
     C                   CALLB     'SDSECDUPD'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ValidSecd
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
                                                                                            BUG12213
     C     DDCUSN        SETLL     SDVCSDRL1                                                BUG12213
     C     DDCUSN        READE     SDVCSDRL1                              98                BUG12213
     C                   DOW       *IN98 <> True                                            BUG12213
     C                   DELETE    SDVCSDRD1                                                BUG12213
     C     DDCUSN        READE     SDVCSDRL1                              98                BUG12213
     C                   ENDDO                                                              BUG12213
                                                                                            BUG12213
     C                   COMMIT
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DBerrUpd      MsgIdArr(1)
     C
     C                   END
 
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
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurCuSecd
 
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   MOVE      *ALL'Y'       PDepotRefOK                                BUG12213
 
     C                   CLEAR                   ValidSecd
     C                   CLEAR                   PValidDepot                                BUG12213
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       begsr
 
      ** Convert file fields to screen format
     C                   reset                   ReturnCode
     C                   CALLB     'SDSECDCVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * Security Customer - file formats
     C                   PARM                    SecdFilFmt
      *
      * Output parameters
      * Security Customer Details - screen formats
     C                   PARM                    CurCuSecd
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   if        RepSecd = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSecd    IncData        2000
      * Current Data
     C                   PARM      CurCuSecd     CurData        2000
 
     C                   MOVEL     IncDATA       TranInSecd
 
     C                   endif
 
     C                   endsr
 
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
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
     C                   PARM                    ExtData500
     C                   PARM                    Depdata                                BUG12213
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
     C                   PARM                    AAuth             1                        BUG22155
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDSECDM01
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'SD'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Access SAR details file to determine if CSE022
      ** (Depository Definition Enhancement) is on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANKS
 
     C                   MOVEL     'Y'           CSE022
 
     C                   ELSE
 
     C                   MOVEL     'N'           CSE022
 
     C                   ENDIF
 
      ** Access SAR details file to determine if CSE039                                       222373
      ** (Depository Definition Enhancement) is on.                                           222373
                                                                                              222373
     C                   CALLB     'AOSARDR0'                                                 222373
     C                   PARM      *BLANKS       @RTCD                                        222373
     C                   PARM      '*VERIFY'     @OPTN                                        222373
     C                   PARM      'CSE039'      @SARD                                        222373
     C     SCSARD        PARM      SCSARD        DSFDY                                        222373
                                                                                              222373
     C                   IF        @RTCD = *BLANKS                                            222373
                                                                                              222373
     C                   MOVEL     'Y'           CSE039            1                          222373
                                                                                              222373
     C                   ELSE                                                                 222373
                                                                                              222373
     C                   MOVEL     'N'           CSE039                                       222373
                                                                                              222373
     C                   ENDIF                                                                222373
      ** Access Securities Clients Details                                                   BUG3122
      *                                                                                      BUG3122
     C                   CALLB     'AOSTRDR0'                                                BUG3122
     C                   PARM      '*DBERR '     @RTCD             7                         BUG3122
     C                   PARM      '*FIRST '     @OPTN             7                         BUG3122
     C     SDSTRD        PARM      SDSTRD        DSFDY                                       BUG3122
      *                                                                                      BUG3122
      **Database error                                                                       BUG3122
      *                                                                                      BUG3122
     C     @RTCD         IFNE      *BLANKS                                                   BUG3122
     C                   MOVEL     'SDSTRDPD'    DBFILE                                      BUG3122
     C                   Z-ADD     1             DBASE                                       BUG3122
     C                   MOVEL     @OPTN         DBKEY                                       BUG3122
     C                   EXSR      *PSSR                                                     BUG3122
     C                   END                                                                 BUG3122
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
