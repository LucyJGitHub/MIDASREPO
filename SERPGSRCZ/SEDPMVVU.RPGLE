     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Depot WalkIn/WalkOut validate and update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEDPMVVU - SE Depot Walk-In/Walk-Out Validate and Update     *
      *                                                               *
      *  Function: This program validates depot WalkIn/WalkOut for    *
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
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR971184A          Date 13Jun12               *
      *                 AR971184           Date 28May12               *
      *                 AR596674           Date 12Aug10               *
      *                 AR589197           Date 11Aug10               *
      *                 AR589037           Date 06Aug10               *
      *                 AR586519           Date 02Aug10               *
      *                 AR586112           Date 02Aug10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22147           Date 14Jan09               *
      *                 BUG21269           Date 06Oct08               *
      *                 BUG21230           Date 29Sep08               *
      *                 BUG21221           Date 27Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244007             Date 01Dec06               *
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10915           Date 30Mar06               *
      *                 BUG10476           Date 15Feb06               *
      *                 BUG10120           Date 26Jan06               *
      *                 BUG10824           Date 15Mar06               *
      *                 BUG10561           Date 15Feb06               *
      *                 BUG10142           Date 26Jan06               *
      *                 BUG10026           Date 24Jan06               *
      *                 BUG9089            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8849            Date 04Oct05               *
      *                 CAP087             Date 02Sep05               *
      *                 237063             Date 20Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 FIX001             Date 17Mar04               *
      *                 CGL031             Date 05Jul04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG3714            Date 20Jul04               *
      *                 BUG2392            Date 15Jun04               *
      *                 CGP003             Date 01Jun04               *
      *                 BUG2398            Date 24May04               *
      *                 TCA046             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1569            Date 17Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR971184A - Additional Coding. Front Ofc Id should not be    *
      *              equal to blanks when calling RTV                 *
      *            - Applied fix for AR989192 (Child:AR989193)        *
      *            - During Amend Front Ofc Id must be updated with   *
      *              the new one                                      *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR596674 - Field :97::CASH//IBAN not reflected in MT543      *
      *  AR589197 - The input validation of //xx has been removed if  *
      *             ISO15022 is switched on, it should be reapplied   *
      *             as the code is still used                         *
      *  AR589037 - Destination of Settlement Field is blank in DPWI  *
      *  AR586519 - Account for Payment and Account for Payment       *
      *             (detail) not populated from SEST                  *
      *  AR586112 - Destination of Settlement field is blank          *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  BUG22147 - Missing authorization field in repository.        *
      *  BUG21269 - Applied Fix BUG20643                              *
      *  BUG20643 - Serious Midas Error when authorise a reversal     *
      *  BUG21230 - Applied fix BUG20870                              *
      *  BUG20870 - Missing MT518 at maturity date in MGOREFPD.       *
      *  BUG21221 - Applied fix BUG19956                              *
      *  BUG19956 - SEW7010 Confirmation Request error                *
      *  244007 - Add repo indicator from repurchased agreement input.*
      *  244537 - To avoid overriding front office identifier.        *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10915- validation should not be done for deletion of      *
      *            depot movements. Patterned after other APIs.       *
      *  BUG10476- Market Centre defaulting.                          *
      *          - Place of settlement defaulting.                    *
      *  BUG10120- No Defaulting from SSI                             *
      *  BUG10824 - Include DDDPRNOk in conditioning for the compu-   *
      *             tation of countervalue.                           *
      *  BUG10561 - No Lux Extension for Depot Movements              *
      *  BUG10142 - 3 Extension fields are invalid after pressing     *
      *             complete button                                   *
      *  BUG10026 - (DPWI Input) Narrative field in transction        *
      *             confirmation is incorrect.                        *
      *  BUG9089- Mapping error with Java for DPMV                    *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG8849 - Do not issue database error if Beneficiary         *
      *            Customer is not defined as Security Customer.      *
      *            Only issue an error message for this.              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  FIX001 - Incorrect parameter passed to SEDPMVVAL.            *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG3714- Generate reference not display on confirmation      *
      *  BUG2392- Correct defaulting errors                           *
      *  CGP003 - Add calculation of consideration for authorisation  *
      *           limit checking.                                     *
      *  BUG2398 - SSI Defaulting not working for WI/WO transactions. *
      *  TCA046 - Recompiled over changes made in SEDMIDPD.           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FSEVDPMVL1 IF   E           K DISK    RENAME(SEVDPMVD0:SEVDPMVCK1)
     F                                     INFSR(*PSSR)
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FINVTP     IF   E           K DISK
     FSECTY     IF   E           K DISK    RENAME(SECTYDF:SECTYDF2)                          BUG2392
     F                                     PREFIX(I_)                                        BUG2392
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                       CAP087
     F                                     INFDS(INFDS)                                       CAP087
     F                                     IGNORE(MMDENSP0)                                   CAP087
     F                                     IGNORE(MMDENBP0)                                   CAP087
                                                                                            BUG10476
     FSEMKC     IF   E           K DISK                                                     BUG10476
      ** Midas SE Market Centres                                                            BUG10476

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Standard D-specs
      ** ================
      **                                    handler)
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022

      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D TransIn       E DS                  EXTNAME(SEDMWIPD)
     D DDDEPOT       E                     EXTFLD(DDDPID)
     D DDDATE        E                     EXTFLD(DDDPMD)

      ** Incoming transaction in screen format
     D TranInDPMV    E DS                  EXTNAME(SEDMIDPD)
     D                                     PREFIX(IN_)
     D TranInDMES    E DS                  EXTNAME(SEDMESPD)
     D                                     PREFIX(IN_)

      ** Valid file layout
     D ValidDPMV     E DS                  EXTNAME(SEVDPMVPD)
     D                                     PREFIX(V_)
     D ValidDPX1     E DS                  EXTNAME(SEVDMX1PD)
     D                                     PREFIX(V_)
     D ValidDPX2     E DS                  EXTNAME(SEVDMX2PD)
     D                                     PREFIX(V_)
     D ValidLUX      E DS                  EXTNAME(SEVDMLX1PD)                                CER001
      *                                                                                       CER001
      ** Extended Depot Movements File                                                        CER001
      *                                                                                       CER001
     D SVRCD         E DS                  EXTNAME(SEDPX1PD)                                  CER001

     D OKFlagsDS     E DS                  EXTNAME(SEEDMWIPD)
     D DDDEPOTOk     E                     EXTFLD(DDDPIDOk)
     D DDDATEOk      E                     EXTFLD(DDDPMDOk)

      ** Current transaction record in file format
     D DPMVFilFmt    E DS                  EXTNAME(DPTMVD)
     D DPMVX1Fmt     E DS                  EXTNAME(DPTMVDX1)
     D DPMVX2Fmt     E DS                  EXTNAME(DPTMVDX2)

      ** Current transaction in screen format
     D CurWholeScn   E DS                  EXTNAME(SEDMWIPD)
     D                                     PREFIX(W_)
     D CurTrDPMV     E DS                  EXTNAME(SEDMIDPD)
     D                                     PREFIX(@)
     D CurTrDMES     E DS                  EXTNAME(SEDMESPD)
     D                                     PREFIX(@)
     D CurScnFld     E DS                  EXTNAME(SEDMESPD) PREFIX(C_)
      ** Current Extension & Extended Settlement fields in screen format

     D InwScnFld     E DS                  EXTNAME(SEDMESPD) PREFIX(I_)
      ** Initial Extension & Extended Settlement fields in screen format


      ** Extra data in file format
     D ExtData       E DS                  EXTNAME(SEDMEXPD)
      *                                                                                      BUG9089
      ** Other data in file format                                                           BUG9089
      *                                                                                      BUG9089
     D DPMVOth       E DS                  EXTNAME(SEDMAXPD)                                 BUG9089
      *                                                                                       CER001
      ** Extra data in file format (Regional)                                                 CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SEDMRXPD)                                  CER001

      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT

      ** Security Details
     D*SECTY******** E DS                  EXTNAME(SECTYD)                                   BUG2392
     D SECTYX        E DS                  EXTNAME(SECTYD)                                   BUG2392
     D                                     PREFIX(SEC)

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** External DS for Security Customer details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Branch Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD status data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Additional entry parameter for Midas Compliance Watch
     D PMCWL           DS          9999

      ** Country of treaty (Not use for Depot Movement)
     D PDRBW           S              2A
      *
      ** Withholding tax (Not use for Depot Movement)
     D DDWTAX          S             15A

      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CAP087
     D INFDS           DS                                                                     CAP087
      **  Data structure for file status of MM deals file.                                    CAP087
      *                                                                                       CER001
      ** Data passed from caller program                                                      CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
     D  #1DPSS                 1     10                                                       CER001
     D  #1DPRN                11     16                                                       CER001
     D  #1DPMV                17     18                                                       CER001
     D  #1FOTR                19     38                                                       CER001
     D  #1TMST                39     64Z                                                      CER001

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)

      ** Fields (500A) to receive the incoming transaction
     D Trans500        S            500A
     D Ext500          S            500A
     D DPMVOth500      S            500A                                                     BUG9089
     D RegData500      S            500A                                                      CER001

      ** Field (500A) to receive the incoming Extended settlement
     D OthrData        S           4755A

      ** Entry parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D APIRetc         S              1A

      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     D ModeofOp        S              6A

     D CallProg        S             10A   INZ('       ')
     D DPMVType        S              2A
     D*DDSPXR***       S             14A                                                      CER001
     D*DDSPMD***       S              1A                                                      CER001
     D*DDSecSts*       S              7A                                                     BUG9089
     D*DDTranSts       S              7A                                                     BUG9089
     D PortCusInd      S              1A
     D PBInd           S              1A
     D PBFieldInd      S              1A

     D IncDATA         S           2000A
     D CurDATA         S           2000A

     D SubsChar        S              1A

     D Module          S              2A
     D TranType        S              1A

     D PRtCd           S              7A   INZ(*BLANK)
     D POptn           S              7A   INZ(*BLANK)
     D PSard           S              6A   INZ(*BLANK)
     D PEUTX           S             13P 0                                                    237063
     D WProcDate       S                   LIKE(BJRDNB)
     D DateFmtInd      S                   LIKE(BJDFIN)                                       CAP087
     D DateFormat      S                   LIKE(BJDFIN)                                       CAP087
     D DADJN           S              1A                                                      CAP087
      ** Day adjustment                                                                       CAP087
     D  ZDADJ          S              3P 0                                                    CAP087
      ** Accrued indicator                                                                    CAP087
     D  ZACIN          S              1A                                                      CAP087
      ** Actual Difference indicator                                                          CAP087
     D  ZADIN          S              1A                                                      CAP087
      ** Coupon rate (trade)                                                                  CAP087
     D  ZADEC          S              1P 0                                                    CAP087
      ** Output of ZSEDIT                                                                     CAP087
     D   ZFLD15        S             15  0                                                    CAP087
      ** Output of ZPCINT                                                                     CAP087
     D   ZITRA         S             13  0                                                    CAP087
     D   ZTINA         S             13  0                                                    CAP087
      ** Coupon rate (trade)                                                                  CAP087
     D TDCR            S             11P 7                                                    CAP087
      ** Overide Indicator                                                                    CAP087
     D  ZCPOVR         S              1A                                                      CAP087
      ** Nominal                                                                              CAP087
     D NOML            S             11P 0 INZ(0)                                             CAP087
      ** Value Date Interest                                                                  CAP087
     D**DDVDIN**       S             16A                                              CAP087 BUG9089
      ** Maturity Date Interest                                                               CAP087
     D**DDMDIN**       S             16A                                              CAP087 BUG9089
      ** Error arrays                                                                         CAP087
     D XArrayMax       C                   CONST(40)                                          CAP087
     D FldNamXAr       S             10A   DIM(XArrayMax)                                     CAP087
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)                        CAP087
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CAP087

      * Timestamp for the transaction
     D WTimeStamp      S               Z
     D WorkTime        S             26A

      *
      ** Switchable features
     D CSW003          S              1A
     D S01401          S              1A
     D CSC011          S              1A
     D CSE022          S              1A
     D CSE028          S              1A
     D CSE029          S              1A
     D CSE033          S              1A
     D CSW014          S              1A
     D CSW098          S              1A
     D CSW201          S              1A
     D CSW202          S              1A
     D CGL031          S              1A                                                      CGL031
     D SWRTN           S              7A
     D ULX008          S              1A                                                      CER001
     D ULX602          S              1A                                                      CER001
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CAP087
      ***** Data used by SEDPMVR ******                                                       CAP087
      ** Array of Fields in error.                                                            CAP087
     D @FldNameArr     S             10A   DIM(ArrayMax)                                      CAP087
                                                                                              CAP087
      ** Array of error message IDs                                                           CAP087
     D @MsgIDArr       S                   DIM(ArrayMax)                                      CAP087
     D                                     LIKE(#MsgID)                                       CAP087
                                                                                              CAP087
      ** Array of error message data.                                                         CAP087
     D @MsgDtaArr      S                   DIM(ArrayMax)                                      CAP087
     D                                     LIKE(#MsgData)                                     CAP087
                                                                                              CAP087
      ** Array of message files to check                                                      CAP087
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                    CAP087
                                                                                              CAP087
                                                                                              CER001
     D @@FIND          S              1A                                                      CER001

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
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
                                                                                             BUG7029
      ** Set Front Office ID = User ID                                                       BUG7029
     C*******************EVAL      APFOTranID = %SUBST(PUSRID:1:3) +                  BUG7029 CAP087
     C*******************                       %SUBST(WorkTime:3:17)                 BUG7029 CAP087
      *                                                                                       CAP087
      * Set Front Office ID - need to include the milliseconds to ensure unique ID.           CAP087
      * (SOAP interface can insert multiple records within the same second)                   CAP087
     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3) +                 CAP087 AR971184
     C**********                                %SUBST(WorkTime:3:2) +               CAP087 AR971184
     C**********                                %SUBST(WorkTime:6:2) +               CAP087 AR971184
     C**********                                %SUBST(WorkTime:9:2) +               CAP087 AR971184
     C**********                                %SUBST(WorkTime:12:2) +              CAP087 AR971184
     C**********                                %SUBST(WorkTime:15:9)                CAP087 AR971184

      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.

     C                   MOVEL     Trans500      TranInDPMV
     C                   MOVEL     DPMVOth500    DPMVOth                                     BUG9089
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   MOVEL     OthrData      TranInDMES
     C                   EVAL      TransIn = TranInDPMV + TranInDMES

      ** Reset variables gradually updated

     C                   EXSR      ResetCycle

      ** Validate action code

     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      *  Check if valid depot movement already exist for Midas Trade Ref

     C                   EXSR      ChkValMiTR

      ** Processing depends upon action code

     C                   SELECT

      ** Processing for inserts
      ** ======================

     C                   WHEN      DDACTN = 'I'
     C                   EXSR      ValidateTr

      ** Processing for amends or changes
      ** ================================

     C                   WHEN      DDACTN = 'A'
     C***********                  OR DDACTN = 'D'                                          BUG10915
     C                   EXSR      ConvertDPMV
     C                   EXSR      ChkDtaSubs
     C                   EXSR      ValidateTr

      ** Processing for deletions                                                           BUG10915
      ** ========================                                                           BUG10915
                                                                                            BUG10915
     C                   WHEN      DDACTN = 'D'                                             BUG10915
     C                   EXSR      ConvertDPMV                                              BUG10915
     C                   EXSR      ChkDtaSubs                                               BUG10915
     C                   EXSR      ValidateTr                                               BUG20643
                                                                                            BUG10915
     C                   ENDSL
      *
     C     INVALID       TAG

      ** Write to database

     C                   IF        UpdateYN = 'Y' AND
     C                             Idx = 0
     C                   EXSR      SetUpValid
     C                   EXSR      UpdateDB
      *                                                                                       CER001
     C                   EVAL      #6LXWNDPRN = DDDPRN                                        CER001
     C                   EVAL      #6LXWNDPSS = DDDPSS                                        CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   CALLB     'SEDPMV2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANKS       ReturnCode                                   CER001
     C                   PARM      'Y'           @@FIND                                       CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   PARM      *BLANKS       SVRCD                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF

      ** Workout destination address for settlement to be display on screen
      ** only

     C                   IF        DPID <> *BLANKS OR DPOD <> *BLANKS                       AR589037
                                                                                            AR589037
     C     DPMV          IFEQ      'WI'
     C     DPMVType      OREQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'DT'                                                       CAP087
     C                   IF        DPID <> *BLANKS                                          AR586112
     C                   MOVE      DPID          WSNDR
     C                   MOVE      DPID          WDEST
     C                   ELSE                                                               AR586112
     C                   MOVE      V_DPID        WSNDR                                      AR586112
     C                   MOVE      V_DPID        WDEST                                      AR586112
     C                   ENDIF                                                              AR586112
     C                   ELSE
     C                   IF        DPOD <> *BLANKS                                          AR586112
     C                   MOVE      DPOD          WSNDR
     C                   MOVE      DPOD          WDEST
     C                   ELSE                                                               AR586112
     C                   MOVE      V_DPOD        WSNDR                                      AR586112
     C                   MOVE      V_DPOD        WDEST                                      AR586112
     C                   ENDIF                                                              AR586112
     C                   END
     C                   MOVE      '08'          WSETP
     C                   EXSR      SR1100
                                                                                            AR589037
     C                   ELSE                                                               AR589037
     C                   MOVE      DDROUS        WWROU                                      AR589037
     C                   MOVE      DDROTS        WWROT                                      AR589037
     C                   ENDIF                                                              AR589037

     C                   MOVE      WWROU         DSROUC
     C                   MOVE      WWROT         DSROTC

      ** Calculate Consideration for authorisation limit check
      ** Note : Instead of using error index to condition when to calculate countervalue,     CAP087
      **        use the OK flags instead. This is to enable calculation to proceed even if    CAP087
      **        errors on other non-related fields exists.                                    CAP087
     C*******************IF        idx = 0                                                    CAP087
     C                   IF        DDACTN <> 'D'                                            BUG10915
     C                   IF            DDDPSSOk <> 'N' AND DDDATEOk <> 'N'                    CAP087
     C                             AND DDDPDOOk <> 'N' AND DDDPBNOk <> 'N'                    CAP087
     C                             AND DDDPNAOk <> 'N' AND DDMKTPOk <> 'N'                    CAP087
     C**********                   AND DDACTNOk <> 'N'                               CAP087 BUG10824
     C                             AND DDACTNOk <> 'N' AND DDDPRNOk <> 'N'                  BUG10824
     C                   EXSR      CalcTrCVAL
      * Calculate Purchase Interest                                                           CAP087
     C                   EXSR      CalcPurchInt                                               CAP087
     C                   ELSE                                                                BUG2392
     C                   EXSR      GetPROT                                                   BUG2392
     C                   ENDIF
                                                                                            BUG10915
     C                   ENDIF                                                              BUG10915

      ** Remerge buffer with all relevant data structures

      ** If action is for Update, get the correct record information                         CAP087
      ** from file                                                                           CAP087
     C                   IF        UpdateYN = 'Y'                                            CAP087
     C                   MOVE      DPMVType      DDDPMV_IN                                   CAP087
     C                   MOVE      DDDPRN        DDDPRN_IN                                   CAP087
     C                   MOVE      DDDPSS        DDDPSS_IN                                   CAP087
     C                   CALL      'SEDPMVR'                                                 CAP087
     C                   PARM                    @AuthComp         1                         CAP087
     C                   PARM                    @FwdBck           1                         CAP087
     C                   PARM                    DDDPMV_IN         2                         CAP087
     C                   PARM                    DDDPRN_IN         6                         CAP087
     C                   PARM                    DDDPSS_IN        10                         CAP087
     C                   PARM                    Buffer                                      CAP087
     C                   PARM                    @FldNameArr                                 CAP087
     C                   PARM                    @MsgIDArr                                   CAP087
     C                   PARM                    @MsgDtaArr                                  CAP087
     C                   PARM                    @MsgFArray                                  CAP087
     C                   PARM                    APIRetC                                     CAP087
     C                   ELSE                                                                CAP087
      *                                                                                      CAP087
     C                   EVAL      IN_DDDPRN = DDDPRN                                        BUG3714
     C                   EVAL      IN_DDOPIN = DDOPIN                                         237063
     C                   EVAL      DDNMCY = SECNMCY                                          BUG9089
     C***********        EVAL      TransIn = TranInDPMV + TranInDMES               BUG2392  BUG10120
     C                   EVAL      Buffer = TransIn + DPMVType
     C***********                           + ExtData                                        BUG1569
     C**********                            + @TimeStamp + ExtData                    BUG1569 CER001
     C**********                            + DDTranSts + DDSecSts                           BUG9089
     C**********                            + DDSPXR + DDSPMD                                BUG9089
     C**********                            + DDTCTR + SECNMCY                               BUG9089
     C**********                            + PROT                                   BUG2392 BUG9089
     C                                      + @TimeStamp + DPMVOth                           BUG9089
     C**********                            + DDVDIN + DDMDIN                        CAP087 BUG10026
     C**********                            + RegData + ExtData                      CER001 BUG10026
     C**********                            + ExtData + RegData                    BUG10026 BUG10142
     C                                      + RegData + ExtData                    BUG10026 BUG10142
     C                   ENDIF                                                                CAP087

     C                   EVAL      *INLR = *ON

     C                   RETURN

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR

      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the SE database is retrieved
      * as well.
      *
     C     DDACTN        IFEQ      'I'
     C*****APFOTRANID    ANDEQ     *BLANKS                                        AR971184 AR971184A
     C     APFOTRANID    ANDNE     *BLANKS                                                 AR971184A
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   MOVE      'S'           APRespMode
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF

     C                   CALLB     'SEDPMVRTV'

     ** Screen Fields
      * Action Code (1A)
      * Depot Movement Reference Number (6A)
      * Booking Branch  (3A)
      * Originating Branch  (3A)

     C                   PARM                    DDACTN
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPBA
     C                   PARM                    DDORBR

     ** Operation Details
      * Mode of Operation (6A)
      * Response Mode (1A)
      * Front Office ID No. (20A)
      * Depot Movement Type. (2A)

     C                   PARM                    ModeofOp
     C                   PARM                    APRespMode
     C                   PARM                    APFOTranId
     C                   PARM                    DPMVType
     C                   PARM                    CallProg
     C                   PARM                    DDDPSS                                       CAP087

      ** Returned Parameters
      ** -------------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Error Index (3P 0)

     C                   PARM                    Idx

      ** Depot movement transaction file Output

     C                   PARM                    DPMVFilFmt

     ** Ok Indicators
      * Action Code Ok Indicator (1A)
      * Transaction ID number Ok Indicator (1A)
      * Booking Branch Ok indicator (1A)
      * Originating Branch Ok indicator (1A)

     C                   PARM                    DDACTNOk
     C                   PARM                    DDDPRNOk
     C                   PARM                    DDDPBAOk
     C                   PARM                    DDORBROk
      *
      ** Retrieve the eventual current database records
      *
     C                   IF        S01401 = 'Y'

     C                   CALLB     'SEDMESRTV'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Movement references
     C                   PARM                    DPSS
     C                   PARM                    DPRN
      ** Features
     C                   PARM                    CSE028
     C                   PARM                    CSW003
      *
      ** OUTPUT PARAMETERS
      ** Extension and Extended Settlement details
     C                   PARM                    DPMVX1Fmt
     C                   PARM                    DPMVX2Fmt

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiTR - Routine to check if valid Depot Movement exist   *
      *              for the Movement Reference                       *
      *                                                               *
      *****************************************************************

     C     ChkValMiTR    BEGSR

      * If (numeric) Reference supplied

     C                   TESTN                   DDDPRN               9898

     C     DDDPRN        IFNE      *BLANKS
     C     *IN98         ANDEQ     '1'

      * Check for trade on Valid file
     C                   MOVEL     DDDPRN        DPRN
     C     DPRN          CHAIN     SEVDPMVL1                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     DPRN          CHAIN     SEVDPMVL1                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDPRN'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertDPMV - Convert Depot Movement details from file to    *
      *                screen format                                  *
      *                                                               *
      *****************************************************************

     C     ConvertDPMV   BEGSR

     C                   RESET                   ReturnCode
     C                   CALLB     'SEDPMVCVT'

      ** Input Parameters
      ** ================

      ** Return Code
     C                   PARM      *BLANKS       ReturnCode

      ** (Current) Depot movement in file format
     C                   PARM                    DPMVFilFmt

      ** Output Parameters
      ** =================

      ** (Current) Depot movement in screen format
     C                   PARM                    CurTrDPMV

      ** Fx Rate
      ** Mul/Div Indicator
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
      ** Security Status
      ** Transaction status
     C**********         PARM                    DDSecSts                                    BUG9089
     C**********         PARM                    DDTranSts                                   BUG9089
     C                   PARM                    DDSSTS                                      BUG9089
     C                   PARM                    DDTSTS                                      BUG9089
     C                   PARM                    PortCusInd
     C                   PARM                    PBFieldInd
     C                   PARM                    CGL031                                       CGL031
      *
      ** Convert X1 and X2 record into screen field if S01401 is present
      *
     C                   IF        S01401 = 'Y'

     C                   CALLB     'SEDMESCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Extension and Extended Settlements Details
     C                   PARM                    DPMVX1Fmt
     C                   PARM                    DPMVX2Fmt
      ** Features status
     C                   PARM                    CSE028
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
      *
      ** INPUT/OUTPUT PARAMETERS
      ** New fields in screen format (whole API message)
      ** Only the sub-field NewScnFld will be updated
     C                   PARM                    CurWholeScn

     C                   MOVE      CurWholeScn   CurTrDMES
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkDtaSubs - Data Substitution Routine                       *
      *                                                               *
      *****************************************************************

     C     ChkDtaSubs    BEGSR

      ** Substitute the data for the various parts of the transaction.

     C     GHSUBS        IFNE      *BLANKS
     C     GHSUBS        SCAN      TranInDPMV                             99
     C  N99GHSUBS        SCAN      TranInDMES                             99
     C     *IN99         IFEQ      *ON
     C                   RESET                   ReturnCode
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
     C                   CALLB     'APDTASUBS'
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      TranInDPMV    IncDATA
     C                   PARM      CurTrDPMV     CurDATA
     C                   MOVEL     IncDATA       TranInDPMV

      ** SWIFT Detail
     C                   RESET                   ReturnCode
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
     C                   CALLB     'APDTASUBS'
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      TranInDMES    IncDATA
     C                   PARM      CurTrDMES     CurDATA
     C                   MOVEL     IncDATA       TranInDMES
     C                   ENDIF
     C                   ENDIF

     C                   CLEAR                   TransIn
     C                   EVAL      TransIn = TranInDPMV + TranInDMES

     C                   ENDSR

      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************

     C     ValidateTr    BEGSR

      ** Move Depot movement details retrieved from the Midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros and blanks)

     C                   MOVEL     DPMVFilFmt    ValidDPMV

      ** Validate screen 1 details.

     C                   EXSR      ValidateTr1

      ** Validate screen 2 details.

     C                   EXSR      ValidateTr2

      ** Validate SWIFT Message Detail Screen

     C                   IF        DDDPSSOk <> 'N' AND DDDPBNOk <> 'N'                      AR586519
     C                             AND DDDEPOTOk <> 'N'                                     AR586519
     C                             AND DDDATEOk <> 'N'                                      AR586519
     C                             AND DDDPODOk <> 'N'                                      AR586519
     C                             AND DDDPDOOk <> 'N'                                      AR586519
     C                   EXSR      ValidateMess
     C                   ENDIF                                                              AR586519
      *                                                                                       CER001
      ** Validate Extension Details Screen                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EXSR      ValidateLUX                                                CER001
     C                   ENDIF                                                                CER001

     C     EValidTr      ENDSR

      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr1 - Validate Screen 1 details                        *
      *                                                                *
      ******************************************************************

     C     ValidateTr1   BEGSR

     C                   RESET                   ReturnCode

     C                   CALLB     'SEDPMVVAL'

      ** Inputs
      ** ======

      ** Depot movement Transaction Details
     C**********         PARM                    TranInDPMV                                   FIX001
     C                   PARM                    TransIn                                      FIX001
      ** Extra Data
     C                   PARM                    ExtData
      *
     C***************    PARM                    SECTY                                       BUG2392
     C                   PARM                    SECTYX                                      BUG2392
     C                   PARM                    DPMVType
     C                   PARM                    DDDRID                                      244007
     C                   PARM                    APRespMode
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
     C*******************PARM      'Y'           PortCusInd                                  CAP087
     C*******************PARM      'Y'           PBInd                                       CAP087
     C                   PARM      'N'           PortCusInd                                  CAP087
     C                   PARM      'N'           PBInd                                       CAP087
     C                   PARM                    PBFieldInd

     C                   PARM                    ValidDPMV

      ** Outputs
      ** ======

      ** Depot movement Transaction Details OK inds
     C                   PARM                    OKFlagsDS

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WIdx
     C                   PARM                    CGL031                                       CGL031

      ** If the depot movement type is Walk-In, and there are errors or
      ** warning with Depot In or In Date, then need to change the
      ** field ID from DDDPID to DDDPOD and DDDPMD to DDDPDO.
      ** Because we are using one API xml for both WI and WO.
     C                   IF        DPMVType = 'WI'
     C                   IF        Idx <> 0
     C                   Z-ADD     1             I                 2 0
     C     'DDDPID    '  LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   EVAL      FlDNameArr(I) = 'DDDPOD    '
     C                   END
     C                   Z-ADD     1             I
     C     'DDDPMD    '  LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   EVAL      FlDNameArr(I) = 'DDDPDO    '
     C                   END
     C                   ENDIF
     C                   IF        WIdx <> 0
     C                   Z-ADD     1             I
      ** Use WARNING array here instead                                                       CAP087
     C*****'DDDPID    '  LOOKUP    FldNameArr(I)                          99                  CAP087
     C     'DDDPID    '  LOOKUP    WFldNamArr(I)                          99                  CAP087
     C     *IN99         IFEQ      '1'
     C*******************EVAL      FlDNameArr(I) = 'DDDPOD    '                               CAP087
     C                   EVAL      WFldNamArr(I) = 'DDDPOD    '                               CAP087
     C                   END
     C                   Z-ADD     1             I
     C*****'DDDPMD    '  LOOKUP    FldNameArr(I)                          99                  CAP087
     C     'DDDPMD    '  LOOKUP    WFldNamArr(I)                          99                  CAP087
     C     *IN99         IFEQ      '1'
     C*******************EVAL      FlDNameArr(I) = 'DDDPDO    '                               CAP087
     C                   EVAL      WFldNamArr(I) = 'DDDPDO    '                               CAP087
     C                   END
     C                   ENDIF
     C                   ENDIF

      ** If type is REPO or DEPOT TRANSFER and there are errors or                            CAP087
      ** warning with IN DEPOT or IN DATE, then need to change the                            CAP087
      ** field ID from DDDPID to DDDPOD and DDDPMD to DDDPDO. Also                            CAP087
      ** need to change from DDDPOD to DDDPID and DDDPDO to DDDPMD.                           CAP087
      ** REASON IS WE ARE USING ONE API XML FOR WI, WO, REPO and DEPOT                        CAP087
      ** TRANSFERS AND 'OUT' FIELDS ARE USED AS 'IN' FIELDS HERE.                             CAP087
     C                   IF           DPMVType = 'RR'                                         CAP087
     C                             or DPMVType = 'RP'                                         CAP087
     C                             or DPMVType = 'BB'                                         CAP087
     C                             or DPMVType = 'BL'                                         CAP087
     C                             or DPMVType = 'PL'                                         CAP087
     C                             or DPMVType = 'PD'                                         CAP087
     C                             or DPMVType = 'DT'                                         CAP087
      *                                                                                       CAP087
      ** Check error message array                                                            CAP087
      *                                                                                       CAP087
     C                   IF        Idx <> 0                                                   CAP087
     C                   Z-ADD     1             J                 2 0                        CAP087
                                                                                              CAP087
     C     FldNameArr(J) DOWNE     *BLANKS                                                    CAP087
                                                                                              CAP087
     C     FldNameArr(J) IFEQ      'DDDPID    '                                               CAP087
     C                   MOVEA     'DDDPOD    '  FldNameArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     FldNameArr(J) IFEQ      'DDDPMD    '                                               CAP087
     C                   MOVEA     'DDDPDO    '  FldNameArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     FldNameArr(J) IFEQ      'DDDPOD    '                                               CAP087
     C                   MOVEA     'DDDPID    '  FldNameArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     FldNameArr(J) IFEQ      'DDDPDO    '                                               CAP087
     C                   MOVEA     'DDDPMD    '  FldNameArr(J)                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   ADD       1             J                                            CAP087
     C                   ENDDO                                                                CAP087
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      ** Check warning message array                                                          CAP087
      *                                                                                       CAP087
     C                   IF        WIdx <> 0                                                  CAP087
     C                   Z-ADD     1             J                                            CAP087
                                                                                              CAP087
     C     WFldNamArr(J) DOWNE     *BLANKS                                                    CAP087
                                                                                              CAP087
     C     WFldNamArr(J) IFEQ      'DDDPID    '                                               CAP087
     C                   MOVEA     'DDDPOD    '  WFldNamArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     WFldNamArr(J) IFEQ      'DDDPMD    '                                               CAP087
     C                   MOVEA     'DDDPDO    '  WFldNamArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     WFldNamArr(J) IFEQ      'DDDPOD    '                                               CAP087
     C                   MOVEA     'DDDPID    '  WFldNamArr(J)                                CAP087
     C                   ELSE                                                                 CAP087
     C     WFldNamArr(J) IFEQ      'DDDPDO    '                                               CAP087
     C                   MOVEA     'DDDPMD    '  WFldNamArr(J)                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   ADD       1             J                                            CAP087
     C                   ENDDO                                                                CAP087
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   ENDSR

      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr2 - Validate Screen 2 details                        *
      *                                                                *
      ******************************************************************

     C     ValidateTr2   BEGSR

     C                   RESET                   ReturnCode

     C                   CALLB     'SEDPMV2VL'
     C                   PARM                    ReturnCode
     C                   PARM                    DDDPNR2
     C                   PARM                    DDDPNR3
     C                   PARM                    DDDPNR4
     C                   PARM                    DDDPNR5
     C                   PARM                    ValidDPMV
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WIdx

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateMess - Validate Extension & Extended Settlement       *
      *                                                               *
      * Calls: EvalParms                                              *
      *                                                               *
      *****************************************************************
      *
     C     ValidateMess  BEGSR
      *
      ** Clear all the data structures
      *
     C                   CLEAR                   CurScnFld
     C                   CLEAR                   InwScnFld
      *
      ** Set up parameters for the called modules
      *
     C     DDDPBA        IFEQ      '   '
     C                   EVAL      DDDPBA = V_DPBA
     C                   END
     C     DSGMES        IFEQ      ' '
     C                   EVAL      DSGMES = 'N'
     C                   END
     C                   EXSR      EvalParms
      *
      ** Apply the eventual defaultings
      *------------------
     C**********         IF        V_CPTY <> *ZEROS                                   BUG2398 CSD027
     C                   IF        V_CPTY <> *BLANKS                                          CSD027
     C                   MOVEL     V_CPTY        WCPTY
     C                   ELSE                                                                BUG2398
     C                   MOVEL     V_DPBN        WCPTY                                       BUG2398
     C                   ENDIF                                                               BUG2398
      *                                                                                      BUG2398
     C                   CALLB     'SEDMESDFT'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Depot movement type
     C                   PARM                    DPMVType
      ** Receive/Deliver type
     C                   PARM                    @REDE
      ** Branch internal customer number
     C                   PARM                    @BICN
      ** Security Customer classification
     C                   PARM                    @CLAS
      ** Security data:
      ** . Market center
      ** . Nominal currency
      ** . Investment type
     C                   PARM                    SECSMCC
     C                   PARM                    SECNMCY
     C                   PARM                    SECSITP
      ** Midas Run Date number & Date format
     C                   PARM                    WProcDate
     C                   PARM                    BJDFIN
      ** Features status
     C                   PARM                    CSE022
     C                   PARM                    CSE028
     C                   PARM                    CSE029
     C                   PARM                    CSW003
     C                   PARM                    CSW098
     C                   PARM                    CSW202
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
      *
      ** INPUT/OUTPUT PARAMETERS:
      ** Transaction Details in screen format
     C                   PARM                    WCPTY             6
     C                   PARM                    TransIn
      *
      ** OUTPUT PARAMETERS:
      ** Additional screen fields (destination of settlement)
     C                   PARM                    DDROUS            6
     C                   PARM                    DDROTS           12
                                                                                            BUG10476
      * Default Market centre from security                                                 BUG10476
     C     DDMRKT        IFEQ      *BLANKS                                                  BUG10476
     C                   EVAL      DDMRKT = SECSMCC                                         BUG10476
     C                   ENDIF                                                              BUG10476
                                                                                            BUG10476
      * If Place of settlement is blank then use market Centre to access SEMKC              BUG10476
      * and default from here.                                                              BUG10476
     C     DSPSET        IFEQ      *BLANKS                                                  BUG10476
     C     DDMRKT        IFNE      *BLANKS                                                  BUG10476
     C     DDMRKT        CHAIN     SEMKCDF                            99                    BUG10476
     C     *IN99         IFEQ      *OFF                                                     BUG10476
     C                   EVAL      DSPSET = PSETL                                           BUG10476
     C                   ENDIF                                                              BUG10476
     C                   ENDIF                                                              BUG10476
     C                   ENDIF                                                              BUG10476
                                                                                            BUG10476
      *------------------
      ** Validate the extension screen
      *------------------
     C                   CALLB     'SEDMES1VL'
      ** INPUT PARAMETERS
      ** Actual Action Code
     C                   PARM                    DDACTN
      ** Screen Fields
     C                   PARM                    TransIn
      ** Depot movement type                                                                BUG19956
     C                   PARM                    DPMVType                                   BUG19956
      ** Additional screen field (destination of settlement)
     C                   PARM                    DDROTS
      ** Calculated Instructions Type
     C                   PARM                    @INST
      ** Security Customer classification
     C                   PARM                    @CLAS
      ** Security information: Market Indicator
     C                   PARM                    SECMKTI
      ** Features Status
     C                   PARM                    CSE028
     C                   PARM                    CSE029
     C                   PARM                    CSW003
     C                   PARM                    CSW202
      *
      ** OUTPUT PARAMETERS
      ** Error indicator flags from/to caller
     C                   PARM                    OKFlagsDS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Core Extension details layout (DS) from/to caller
     C                   PARM                    ValidDPX1
      *------------------
      ** Validate the extended settlement screen if necessary
      *
     C                   CALLB     'SEDMES2VL'
      ** INPUT PARAMETERS
      ** Actual Action Code
     C                   PARM                    DDACTN
      ** Screen Fields
     C                   PARM                    TransIn
      ** Depot movement type
     C                   PARM                    DPMVType
      ** Receive/Deliver type
     C                   PARM                    @REDE
      ** Calculated Instructions Type
     C                   PARM                    @INST
      ** Security Customer classification
     C                   PARM                    @CLAS
      ** Security information: Nominal currency
     C                   PARM                    SECNMCY
      ** Features Status
     C                   PARM                    CSE028
     C                   PARM                    CSW003
     C                   PARM                    CSW014
     C                   PARM                    CSW098
     C                   PARM                    CSW201
     C                   PARM                    CSE029            1
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** INPUT/OUTPUT PARAMETERS
      ** Override validations flags
     C                   PARM      *BLANK        OVER2             1
     C                   PARM      *BLANK        OVER3             1
     C                   PARM      *BLANK        OVER6             1
     C                   PARM      *BLANK        OVER7             1
     C                   PARM      *BLANK        OVER8             1
     C                   PARM      *BLANK        OVER9             1
      ** Overide validations Fonction Key
     C                   PARM      '0'           @INKS             1
     C                   PARM                    WCPTY
      *
      ** OUTPUT PARAMETERS
      ** Error indicator flags from/to caller
     C                   PARM                    OKFlagsDS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Core Extension details layout (DS) from/to caller
     C                   PARM                    ValidDPX2
      *------------------
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValidateLUX  - Validate Extension Details                     *                       CER001
      *                                                               *                       CER001
      * Calls:                                                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     ValidateLUX   BEGSR                                                                CER001
     C                   EVAL      #1DPSS  =  DPSS                                            CER001
     C                   EVAL      #1DPRN  =  DPRN                                            CER001
     C                   EVAL      #1DPMV  =  DPMV                                            CER001
      *                                                                                       CER001
     C                   CALLB     'SEDPMV3VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsDS                                    CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX                                     CER001
      *                                                                                       CER001
     C                   PARM                    ULX008                                       CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
      * EvalParms - Set up parameters for the called modules
      *****************************************************************
     C     EvalParms     BEGSR
      *
      ** Access Branch Details via access program
      *
     C                   IF        DDDPBA <> WDSNB
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDDPBA        WDSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDBRCHPD'                           ************
     C                   EVAL      DBASE  = 901                                  * DBERR 901*
     C                   EVAL      DBKEY = DDDPBA                                ************
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A8BICN        @BICN             6
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Determine Free/Against Payment work field
      *
     C                   IF        DSFIND = *BLANK
     C                   MOVE      'F'           WWFIND            1
     C                   ELSE
     C                   MOVE      DSFIND        WWFIND
     C                   ENDIF
      *
      ** Determine Reception/Delivery Type and Instruction
      *
      ** If CSW003 is off
      *
 B1  C     CSW003        IFNE      'Y'
      *
      ** Determine Receive Free of Payment
      *
     C                   MOVE      *Blanks       @INST             7
     C                   MOVE      *Blanks       @REDE             2
      *
 B2  C     WWFIND        IFEQ      'F'
      *
 B3  C     DPMVType      IFEQ      'WI'
 B3  C     DPMVType      OREQ      'RR'                                                       CAP087
 B3  C     DPMVType      OREQ      'BB'                                                       CAP087
 B3  C     DPMVType      OREQ      'PL'                                                       CAP087
 B3  C     DPMVType      OREQ      'RP'                                                       CAP087
 B3  C     DPMVType      OREQ      'PD'                                                       CAP087
 B3  C     DPMVType      OREQ      'BL'                                                       CAP087
     C                   MOVEL     DDDATE        ZDATE
     C                   EXSR      ZDATE1
      *
 B4  C     ZDAYNO        IFLE      BJDNWD
     C                   MOVE      'RECFREE'     @INST
     C                   MOVE      'TP'          @REDE
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
      ** Determine Deliver Free of Payment
      *
 B3  C     DPMVType      IFEQ      'WO'
 B3  C     DPMVType      OREQ      'RP'                                                       CAP087
 B3  C     DPMVType      OREQ      'BL'                                                       CAP087
 B3  C     DPMVType      OREQ      'PD'                                                       CAP087
 B3  C     DPMVType      OREQ      'RR'                                                       CAP087
 B3  C     DPMVType      OREQ      'BB'                                                       CAP087
 B3  C     DPMVType      OREQ      'PL'                                                       CAP087
 B3  C     DPMVType      OREQ      'DT'                                                       CAP087
     C                   MOVEL     DDDATE        ZDATE
     C                   EXSR      ZDATE1
      *
 B4  C     ZDAYNO        IFLE      BJDNWD
     C                   MOVE      'DELFREE'     @INST
     C                   MOVE      'TS'          @REDE
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** Determine Receive Against Payment
      *
 B2  C     WWFIND        IFEQ      'A'
      *
 B3  C     DPMVType      IFEQ      'WI'
 B3  C     DPMVType      OREQ      'RR'                                                       CAP087
 B3  C     DPMVType      OREQ      'BB'                                                       CAP087
 B3  C     DPMVType      OREQ      'PL'                                                       CAP087
 B3  C     DPMVType      OREQ      'RP'                                                       CAP087
 B3  C     DPMVType      OREQ      'PD'                                                       CAP087
 B3  C     DPMVType      OREQ      'BL'                                                       CAP087
     C                   MOVEL     DDDATE        ZDATE
     C                   EXSR      ZDATE1
      *
 B4  C     ZDAYNO        IFLE      BJDNWD
     C                   MOVE      'RECAPMT'     @INST
     C                   MOVE      'TP'          @REDE
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
      ** Determine Deliver Against Payment
      *
 B3  C     DPMVType      IFEQ      'WO'
 B3  C     DPMVType      OREQ      'RP'                                                       CAP087
 B3  C     DPMVType      OREQ      'BL'                                                       CAP087
 B3  C     DPMVType      OREQ      'PD'                                                       CAP087
 B3  C     DPMVType      OREQ      'RR'                                                       CAP087
 B3  C     DPMVType      OREQ      'BB'                                                       CAP087
 B3  C     DPMVType      OREQ      'PL'                                                       CAP087
 B3  C     DPMVType      OREQ      'DT'                                                       CAP087
     C                   MOVEL     DDDATE        ZDATE
     C                   EXSR      ZDATE1
      *
 B4  C     ZDAYNO        IFLE      BJDNWD
     C                   MOVE      'DELAPMT'     @INST
     C                   MOVE      'TS'          @REDE
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** CSW003 is on
      *
 X1  C                   ELSE
      *
      ** Determine Receive or Deliver, Free or Against Payment
      *
 B2  C     DPMVType      IFEQ      'WI'
 B2  C     DPMVType      OREQ      'BB'                                                       CAP087
 B2  C     DPMVType      OREQ      'RR'                                                       CAP087
 B2  C     DPMVType      OREQ      'PD'                                                       CAP087
     C                   MOVE      'TP'          @REDE
      *
 B3  C     WWFIND        IFEQ      'A'
     C                   MOVE      'RECAPMT'     @INST
 X3  C                   ELSE
     C                   MOVE      'RECFREE'     @INST
 E3  C                   ENDIF
      *
 X2  C                   ELSE
     C                   MOVE      'TS'          @REDE
      *
 B3  C     WWFIND        IFEQ      'A'
     C                   MOVE      'DELAPMT'     @INST
 X3  C                   ELSE
     C                   MOVE      'DELFREE'     @INST
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Security Customer classification
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDDEPOT       WCUST             6
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C                   MOVE      BFCLAS        @CLAS             1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ResetCycle - Reset error information that is gradually       *
      *               updated during each run of this program         *
      *                                                               *
      *****************************************************************

     C     ResetCycle    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   CLEAR                   DPMVFilFmt
     C                   CLEAR                   DPMVX1Fmt
     C                   CLEAR                   DPMVX2Fmt

     C                   CLEAR                   CurTrDPMV
     C                   CLEAR                   CurTrDMES

     C                   MOVE      *ALL'Y'       OKFlagsDS

     C                   CLEAR                   ValidDPMV
     C                   CLEAR                   ValidDPX1
     C                   CLEAR                   ValidDPX2

     C                   CLEAR                   Buffer

      ** Numeric fields within 'ValidDPMV' have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields

     C**********         Z-ADD     *ZERO         V_DPID                                       CSD027
     C                   EVAL      V_DPID = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPMD
     C**********         Z-ADD     *ZERO         V_DPOD                                       CSD027
     C                   EVAL      V_DPOD = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPDO
     C**********         Z-ADD     *ZERO         V_DPBN                                       CSD027
     C                   EVAL      V_DPBN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         V_DPNA
     C                   Z-ADD     *ZERO         V_MKTP
     C                   Z-ADD     *ZERO         V_DPAD
     C                   Z-ADD     *ZERO         V_ORED
     C                   Z-ADD     *ZERO         V_LCD
     C                   Z-ADD     *ZERO         V_TNLU
     C                   Z-ADD     *ZERO         V_DCHA
     C                   Z-ADD     *ZERO         V_DCSE
     C                   Z-ADD     *ZERO         V_DPVD
     C                   Z-ADD     *ZERO         V_SPXR
     C                   Z-ADD     *ZERO         V_CYLD
     C                   Z-ADD     *ZERO         V_PINT
     C                   Z-ADD     *ZERO         V_DVIN
     C                   Z-ADD     *ZERO         V_DMIN
     C                   Z-ADD     *ZERO         V_DEXRT
     C                   Z-ADD     *ZERO         V_DMTD
     C**********         Z-ADD     *ZERO         V_CPTY                                       CSD027
     C                   EVAL      V_CPTY = *BLANKS                                           CSD027

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetUpValid - Set up additional fields that are needed on the *
      *               valid file record.                              *
      *                                                               *
      *****************************************************************

     C     SetUpValid    BEGSR

      ** Setup Reference number for insert

     C                   IF        DDDPRN = *BLANKS
     C                             AND DDACTN = 'I'
     C                   EXSR      SRGenRefNo
     C                   ENDIF

      ** For Delete put the complete (pre-existing) deal
      ** into the Valid file record

     C                   IF        DDACTN = 'D'
     C                   MOVEL     DPMVFilFmt    ValidDPMV
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

      ** Last Change type
      ** Movement Type

     C                   EVAL      V_CHTP = DDACTN
     C                   EVAL      V_DPMV = DPMVType

      ** Message Header details.

      * Do not override header fields from existing transaction.                              244537
                                                                                              244537
     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      V_DMFRNT = APFOTranID
     C                   EVAL      V_DMREPA = APRprLocn
     C                   EVAL      V_DMAFRT = APFOASOCID                                    AR971184
                                                                                              244537
     C                   ENDIF                                                                244537

      ** Keys for X1 and X2 files

     C                   EVAL      V_VDPDPSS = V_DPSS
     C                   EVAL      V_VDPDPRN = V_DPRN
     C                   EVAL      V_VDPWHEN = 'S'
     C                   EXSR      SETUPX1                                                  BUG20870
     C                   EVAL      V_VD2DPSS = V_DPSS
     C                   EVAL      V_VD2DPRN = V_DPRN
     C                   EVAL      V_VD2WHEN = 'S'

      * Restore Timestamp from the original record                                           BUG1569
     C                   IF        DDACTN <> 'I'                                             BUG1569
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    V_DMTMST                                    BUG1569
     C                   ENDIF                                                               BUG1569
      *                                                                                      BUG1569
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdateDB - Update database                                   *
      *                                                               *
      *****************************************************************

     C     UpdateDB      BEGSR

      ** Update files

     C                   RESET                   ReturnCode
     C                   CALLB     'SEDPMVUPD'
     C                   PARM                    ReturnCode
     C                   PARM                    ValidDPMV
     C                   PARM                    PMCWL
     C                   PARM                    V_NOTM            7
     C                   PARM                    V_MSGK           40
     C                   PARM                    CGL031                                       CGL031

      ** If no error on update, then also update extended settlement
      ** records

     C                   IF        ReturnCode = *BLANKS
     C                   CALLB     'SEDMESUPD'
     C                   PARM                    ReturnCode
     C                   PARM                    ValidDPX1
     C                   PARM                    ValidDPX2
     C                   PARM                    WProcDate

     C                   ENDIF
     C                   EVAL      V_VDPWHEN = 'M'                                          BUG20870
     C                   EVAL      V_VD2WHEN = 'M'                                          AR596674
     C                   EXSR      SETUPX1                                                  BUG20870
     C                   IF        ReturnCode = *BLANKS                                     BUG20870
     C                   CALLB     'SEDMESUPD'                                              BUG20870
     C                   PARM                    ReturnCode                                 BUG20870
     C                   PARM                    ValidDPX1                                  BUG20870
     C                   PARM                    ValidDPX2                                  BUG20870
     C                   PARM                    WProcDate                                  BUG20870
                                                                                            BUG20870
     C                   ENDIF                                                              BUG20870

      ** If errors occurred on update, rollback uncommitted file
      ** changes.

     C                   IF        ReturnCode <> *BLANKS and
     C                             ReturnCode <> '*RECUPD'
     C                   MOVEL     '0'           APIRetc
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        ReturnCode = '*RECUPD'
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
     C                   ENDIF

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C                   IF        ReturnCode = '*RECUPD'
     C                   Z-ADD     1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'MMM1067'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenRefNo - Reference Number Generation Routine.             *
      *                                                               *
      * Called by: SetUpValid                                         *
      *                                                               *
      * Calls: ZATRNRTV                                               *
      *                                                               *
      *****************************************************************

     C     SRGenRefNo    BEGSR

     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          Module
     C                   PARM      'D'           TranType
     C                   PARM                    DDDPRN
     C                   PARM      *ZERO         V_DPRN

      ** Database Error

     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     DDDPRN        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C     RetCodeOut    IFEQ      *BLANK
     C                   EVAL      DDDPRN = V_DPRN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcTrCVAL - Calculate Countervalue                           *
      *                                                               *
      *****************************************************************
     C     CalcTrCVAL    BEGSR

      ** INITIALISE UN-USED FIELDS
     C                   EVAL      V_RALL = 0
     C                   EVAL      V_ITRA = 0
     C                   EVAL      V_TBCA = 0
     C                   EVAL      V_TCCA = 0
     C                   EVAL      V_TCA1 = 0
     C                   EVAL      V_TCA2 = 0
     C                   EVAL      V_TCA3 = 0
     C                   EVAL      V_TCA4 = 0
     C                   EVAL      V_TCA5 = 0
     C                   EVAL      V_TCA6 = 0
     C                   EVAL      V_TCA7 = 0
     C                   EVAL      V_TAXA = 0
     C                   EVAL      V_TDER = 1
     C                   EVAL      V_TMDI = 'M'
     C                   EVAL      V_TDTP = 'TP'
     C                   IF        V_DPMV = 'WI'
     C                             OR V_DPMV = 'RR'                                           CAP087
     C                             OR V_DPMV = 'BB'                                           CAP087
     C                             OR V_DPMV = 'PL'                                           CAP087
     C                             OR V_DPMV = 'DT'                                           CAP087
     C                   EVAL      V_TDVD = V_DPMD
     C                   ELSE
     C                   EVAL      V_TDVD = V_DPDO
     C                   ENDIF

      * Access Investment Type details

     C     KLINVT        CHAIN     INVTPDF                            99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     SECNMCY       DBKEY
     C                   MOVE      SECSITP       DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END

      * Get nominal currency details

     C                   MOVE      SECNMCY       @AJCD
     C                   EXSR      ACSCURR

     C                   MOVEL     A6SPRT        NomCcySPRT
     C                   Z-ADD     A6NBDP        NomCcyDec
     C                   MOVEL     A6MDIN        NomCcyMDIN
     C                   MOVEL     A6NQDP        NomCcyNQDP
     C                   MOVEL     A6SWCY        NomCcySWCY
     C                   MOVEL     A6CDFN        NomCcyCDFN
     C                   MOVEL     A6ECDN        NomCcyECDN

     C                   EXSR      ACSCUST

      ** CALCULATE COUNTERVALUE

     C                   CALLB     'SETCVALCAL'

      * INPUTS

      ** Trade details
     C                   PARM                    V_TDTP            2
     C                   PARM                    V_DPNA
     C                   PARM                    V_MKTP
     C                   PARM                    V_RALL            9 5
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    SECNMCY
     C                   PARM                    V_TDVD            5 0

      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SECSPBS
     C                   PARM                    SECCFCT
     C                   PARM                    SECNMCY
     C                   PARM                    SECNMDP
     C                   PARM                    SECSESN

      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    NomCcyDts

      ** Customer classification
     C                   PARM                    CustClass         1

      ** Country of treaty from PF/SECTYD
     C                   PARM                    SECCRTT

      ** Default basket for backup withholding
     C                   PARM                    PDRBW

      ** Value date
     C                   PARM                    V_TDVD
                                                                                              237063
      ** EU Tax                                                                               237063
     C                   PARM                    PEUTX                                        237063

      * OUTPUTS

      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format
     C                   PARM                    V_TCSR           15 0
     C                   PARM                    V_TCTR           15 0
     C                   PARM                    WHTX             13 0
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX

     C                   ENDSR
      *****************************************************************                       CSE045
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * CalcPurchInt - Calculate Purchase Interest for Repos          *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
     C     CalcPurchInt  BEGSR                                                                CAP087
      *                                                                                       CAP087
      ** Only process if movement type is Repo.                                               CAP087
     C                   IF        DPMVType = 'RR' OR DPMVType = 'RP'                         CAP087
     C                             OR DPMVType = 'PL' OR DPMVType = 'PD'                      CAP087
     C                             OR DPMVType = 'BL' OR DPMVType = 'BB'                      CAP087
      *                                                                                       CAP087
      ** Processing type must not be 2, 4 nor 7.                                              CAP087
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'                CAP087
      *                                                                                       CAP087
     C                   EVAL      DDAcinOK = 'Y'                                             CAP087
      *                                                                                       CAP087
     C                   CALLB     'SEVTACCRIN'                                               CAP087
     C                   PARM      *BLANKS       ReturnCode                                   CAP087
     C                   PARM      'Y'           Default           1                          CAP087
     C                   PARM      'N'           Validate          1                          CAP087
     C                   PARM      *BLANK        DDACIN            1                          CAP087
     C                   PARM      V_TDVD        TDVD              5 0                        CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDAcinOK          1                          CAP087
     C                   PARM                    ACIN              1                          CAP087
      *                                                                                       CAP087
     C                   CALLB     'ZPCINT'                                                   CAP087
                                                                                              CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM      *BLANK        DADJN                                        CAP087
     C                   PARM                    NomCcyDec                                    CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      V_DPNA        NOML                                         CAP087
     C                   PARM      DDACIN        ZACIN                                        CAP087
     C                   PARM      *ZERO         ZDADJ                                        CAP087
     C                   PARM      *BLANK        ZADIN                                        CAP087
     C                   PARM      SECCPNR       TDCR                                         CAP087
     C                   PARM      *BLANK        ZCPOVR                                       CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM      V_TDVD        ECD               5 0                        CAP087
     C                   PARM                    ZITRA                                        CAP087
     C                   PARM                    ZTINA                                        CAP087
                                                                                              CAP087
     C                   MOVE      ZITRA         ZFLD15                                       CAP087
     C                   Z-ADD     ZITRA         ITRA_S           13 0                      BUG20870
      *                                                                                       CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      *BLANKS       DDVDIN                                       CAP087
     C                   MOVE      ZOUT21        DDVDIN                                       CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
      * Format a zero value                                                                   CAP087
     C                   Z-ADD     0             ZFLD15                                       CAP087
                                                                                              CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDVDIN                                       CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      * Set Up Maturity Date Interest, if Associated Deal's MATD is not zero.                 CAP087
      *                                                                                       CAP087
     C     V_DPAD        CHAIN     MMDELDP0                           90                      CAP087
     C                   IF        *IN90 = '0' AND HKMATD <> 0                                CAP087
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'                CAP087
                                                                                              CAP087
     C                   CALLB     'ZPCINT'                                                   CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM      *BLANK        DADJN                                        CAP087
     C                   PARM                    NomCcyDec                                    CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      V_DPNA        NOML                                         CAP087
     C                   PARM      DDACIN        ZACIN                                        CAP087
     C                   PARM      *ZERO         ZDADJ                                        CAP087
     C                   PARM      *BLANK        ZADIN                                        CAP087
     C                   PARM      SECCPNR       TDCR                                         CAP087
     C                   PARM      *BLANK        ZCPOVR                                       CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM      HKMATD        ECD               5 0                        CAP087
     C                   PARM                    ZITRA                                        CAP087
     C                   PARM                    ZTINA                                        CAP087
      *                                                                                       CAP087
     C                   MOVE      ZITRA         ZFLD15                                       CAP087
     C                   Z-ADD     ZITRA         ITRA_M           13 0                      BUG20870
     C                   MOVE      *BLANKS       DDMDIN                                       CAP087
      *                                                                                       CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDMDIN                                       CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
      * Format a zero value                                                                   CAP087
     C                   Z-ADD     0             ZFLD15                                       CAP087
     C                   MOVE      *BLANKS       DDMDIN                                       CAP087
                                                                                              CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDMDIN                                       CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                 BUG2392
      *****************************************************************                      BUG2392
      *                                                               *                      BUG2392
      * GetPROT -  Get Nominal Currency and Processing Type           *                      BUG2392
      *                                                               *                      BUG2392
      *****************************************************************                      BUG2392
     C     GetPROT       BEGSR                                                               BUG2392
                                                                                             BUG2392
      * Access Securities Details                                                            BUG2392
                                                                                             BUG2392
     C     DDDPSS        CHAIN     SECTYDF2                           99                     BUG2392
      *                                                                                      BUG2392
      * If Securities Detail Found                                                           BUG2392
      *                                                                                      BUG2392
     C                   IF        *IN99 = '0'                                               BUG2392
     C                   MOVE      I_SESN        SECSESN                                     BUG2392
     C                   MOVE      I_NMCY        SECNMCY                                     BUG2392
                                                                                             BUG2392
      * Access Investment Type details                                                       BUG2392
                                                                                             BUG2392
     C     KLINVT        CHAIN     INVTPDF                            99                     BUG2392
     C                   ENDIF                                                               BUG2392
                                                                                             BUG2392
     C                   ENDSR                                                               BUG2392
      *****************************************************************                      BUG2392
      /EJECT
      *****************************************************************
      * ZDATE1 - Convert a date into a day number
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR1100 - Determine Network and Addresses.                    *
      *                                                               *
      *****************************************************************
     C     SR1100        BEGSR
      *
     C                   CALL      'ZM1100'                             99
     C                   PARM                    WSNDR             6
     C                   PARM                    WSCSD            12
     C                   PARM                    WDEST             6
     C                   PARM                    WSETP             2
     C                   PARM      *BLANKS       WNWSN            20
     C                   PARM      *BLANKS       WNWDS            22
     C                   PARM      *BLANKS       WNWRK             6
     C                   PARM      *BLANKS       WERRC             1
     C                   PARM      *BLANKS       WSRNM            20
     C                   PARM      *BLANKS       WSRTN            10
     C                   PARM      *BLANKS       WDRNM            20
     C                   PARM      *BLANKS       WDRTN            10
      *
     C     WSNDR         IFNE      *BLANKS
     C     WDEST         ANDNE     *BLANKS
      *
     C     *IN99         IFEQ      '1'
     C     WERRC         OREQ      'S'
     C     WERRC         OREQ      'D'
     C     WNWRK         OREQ      'UNROUT'
      *
     C                   MOVEL     *BLANKS       WWROU             6
     C                   MOVEL     '  UNRO'      WWROT            12
     C                   MOVE      'UTABLE'      WWROT
     C                   ELSE
      *
     C                   MOVEL     WNWRK         WWROU
     C                   MOVEA     WNWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     WNWDS         WWROT
     C                   ELSE
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WWROT
     C                   END
     C                   END

     C                   ELSE

     C                   MOVEL     *BLANKS       WWROU
     C                   MOVEL     *BLANKS       WWROT
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSCURR - ACCESS CURRENCY DETAILS                             *
      *****************************************************************
     C     ACSCURR       BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM                    @AJCD             3                           S0111
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSCUST - ACCESS CUSTOMER DETAILS                             *
      *****************************************************************
     C     ACSCUST       BEGSR

     C                   MOVEL     *BLANK        @KEY1
     C                   MOVEL     V_DPBN        @KEY1

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     V_DPBN        DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C                   CALL      'AOSECSR0'                                                  S0111
     C                   PARM                    @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM      BBCUST        @SCKY             6                           S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
      *
      **DATABASE*ERROR*******************************************                            BUG8849
      ***********************************************************                            BUG8849
     C*****@RTCD*        IFNE      *BLANK                                                    BUG8849
     C***********        MOVEL     V_DPBN        DBKEY                                       BUG8849
     C***********        MOVEL     'SDSECSPD'    DBFILE                                      BUG8849
     C***********        MOVEL     '005'         DBASE                                       BUG8849
     C***********        EXSR      *PSSR                                                     BUG8849
     C***********        END                                                                 BUG8849
      *                                                                                      BUG8849
      ** Issue error message to indicate customer is not defined                             BUG8849
      ** as Security Customer.                                                               BUG8849
     C     @RTCD         IFNE      *BLANK                                                    BUG8849
     C                   ADD       1             Idx                                         BUG8849
     C                   EVAL      FldNameArr(Idx) = 'DDDPBN'                                BUG8849
     C                   EVAL      MsgIDArr(Idx) = 'MMA0197'                                 BUG8849
     C                   ENDIF                                                               BUG8849

     C                   MOVE      BFCLAS        CustClass                                     S0111

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG20870
      *****************************************************************                     BUG20870
      * SETUPX1 - Sets up Values for DPTMVDX1 Record.                 *                     BUG20870
      *****************************************************************                     BUG20870
      *                                                                                     BUG20870
     C     SETUPX1       BEGSR                                                              BUG20870
      *                                                                                     BUG20870
     C                   IF        CSW003 = 'Y' AND V_DPMV <> 'WI' AND                      BUG20870
     C                             V_DPMV <> 'WO' AND V_DPMV <> 'DT'                        BUG20870
      ** Exchange Rate                                                                      BUG20870
     C                   IF        V_TDER = 0                                               BUG20870
     C                   EVAL      V_VDPTDER = 1                                            BUG20870
     C                   ELSE                                                               BUG20870
     C                   EVAL      V_VDPTDER = V_TDER                                       BUG20870
     C                   ENDIF                                                              BUG20870
      ** Price                                                                              BUG20870
     C                   MOVE      V_MKTP        V_VDPPRIC                                  BUG20870
      ** Interest Rate                                                                      BUG20870
     C                   IF        PROT <> '2' AND PROT <> '4' AND PROT <> '7'              BUG20870
     C                   EXSR      CalcTrCVAL                                               BUG20870
      * Calculate Purchase Interest                                                         BUG20870
     C                   EXSR      CalcPurchInt                                             BUG20870
     C                   IF        V_VDPWHEN = 'S'                                          BUG20870
     C                   Eval      V_VDPITRA = ITRA_S                                       BUG20870
     C                   ELSE                                                               BUG20870
     C                   IF        V_VDPWHEN = 'M'                                          BUG20870
     C                   Eval      V_VDPITRA = ITRA_S                                       BUG20870
     C                   ENDIF                                                              BUG20870
     C                   ENDIF                                                              BUG20870
     C                   ENDIF                                                              BUG20870
     C                   ENDIF                                                              BUG20870
      *                                                                                     BUG20870
     C                   ENDSR                                                              BUG20870
      *****************************************************************                     BUG20870
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
     C                   PARM                    Trans500
     C                   PARM                    OthrData
     C                   PARM                    DPMVType
     C                   PARM                    DPMVOth500                                  BUG9089
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    Ext500
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Warning error fields/message IDs/message data (arrays)
      ** from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
      ** Update Transaction
     C                   PARM                    UpdateYN
      ** Output Buffer
     C                   PARM                    Buffer
      ** API Return Code
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp       26                         BUG1569
     C                   PARM                    AAuth             1                        BUG22147

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages

     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'                                   AR589197
      *
     C                   MOVE      *ALL'Y'       OKFlagsDS

      ** Access bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CAP087
      ** Retrieve Date Format                                                                 CAP087
     C                   EVAL      DateFmtInd = BJDFIN                                        CAP087

      ** Access Switchable Features File, for CSW003                   ves

     C                   MOVE      'N'           CSW003
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSW003'      PSard
     C*
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW003
     C                   ENDIF

      ** Access Switchable Features File, CSE028                       ves

     C                   MOVE      'N'           CSE028
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE028'      PSard
     C*
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSE028
     C                   ENDIF
      *
      ** Retrieve the status of CSE029
      *
     C                   MOVE      'N'           CSE029            1
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSE029'      @SARD
      *
     C                   IF        @RtCd = *Blanks
     C                   MOVE      'Y'           CSE029
     C                   ENDIF
      *
      ** Retrieve the status of CSE033
      *
     C                   MOVE      'N'           CSE033            1
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSE033'      @SARD
      *
     C                   IF        @RtCd = *Blanks
     C                   MOVE      'Y'           CSE033
     C                   MOVE      'Y'           CSE029
     C                   ENDIF

      ** Access Switchable Features File, CSE022                       ves

     C                   MOVE      'N'           CSE022
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE022'      PSard
     C*
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSE022
     C                   ENDIF
      *
      ** Access SAR file to determine if S01401
      ** (MT5xx message generation) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT

      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF

     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check to see if switchable feature CSW098 is on or if date is
      ** greater than 16 October 1998.
      *
     C                   MOVE      'N'           CSW098
     C                   CALL      'SWIFT98'                            99
     C                   PARM                    SWRTN
      *
     C     SWRTN         IFEQ      'CSW098 '
     C                   MOVE      'Y'           CSW098
     C                   ENDIF

      ** Check if CSW201 - Swift 2001 Standards Update is installed

     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       @RTCD

     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
      *
      ** Retrieve the status of CSW202
      *
     C                   MOVE      'N'           CSW202
      *
     C                   CALL      'SWIF2002'
     C                   PARM                    @RtCd
      *
     C     @RtCd         IFEQ      'CSW2002'
     C                   MOVE      'Y'           CSW202
     C                   ENDIF
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on                                      CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Check if CFT004 feature is installed                                                 CSW210
      *                                                                                       CSW210
     C                   MOVE      'N'           CFT004                                       CSW210
     C                   CALLB     'AOSARDR0'                                                 CSW210
     C                   PARM      *BLANKS       @RtCd                                        CSW210
     C                   PARM      '*VERIFY'     @Optn                                        CSW210
     C                   PARM      'CFT004'      @SARD                                        CSW210
     C*                                                                                       CSW210
     C                   IF        @RtCd = *Blanks                                            CSW210
     C                   MOVE      'Y'           CFT004                                       CSW210
     C                   ENDIF                                                                CSW210

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RtCd                                        CSC022
     C                   Parm      '*VERIFY'     @Optn                                        CSC022
     C                   Parm      'CSC022'      @Sard             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CER001
      ** Retrieve the status of ULX008                                                        CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX008                                       CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*VERIFY'     @Optn                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RtCd = *Blanks                                            CER001
      *                                                                                     BUG10561
      ** ULX008 is ON only if Depot Movement is 'WI' or 'WO'                                BUG10561
      *                                                                                     BUG10561
     C                   IF        DPMVType = 'WI' OR                                       BUG10561
     C                             DPMVType = 'WO'                                          BUG10561
     C                   MOVE      'Y'           ULX008                                       CER001
     C                   ENDIF                                                              BUG10561
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Retrieve the status of ULX602                                                        CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX602                                       CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*VERIFY'     @Optn                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RtCd = *Blanks                                            CER001
     C                   MOVE      'Y'           ULX602                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSC022
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WTimeStamp
     C                   MOVE      WTimeStamp    WorkTime

      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details.                                                            BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
      **********                                                                             BUG7029
      ***Set*Front*Office*ID*=*User*ID                                                       BUG7029
     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3) +                         BUG7029
     C**********                                %SUBST(WorkTime:3:17)                        BUG7029

     C*
     C* Define key list for file INVTP
     C*
     C     KLINVT        KLIST
     C                   KFLD                    SECNMCY
     C                   KFLD                    SECSITP
     C                   ENDSR
      *
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
(c) Finastra International Limited 2002
