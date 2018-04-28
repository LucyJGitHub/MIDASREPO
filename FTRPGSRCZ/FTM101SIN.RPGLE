     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT screen input')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM101SIN - FUNDS TRANSFER REQUEST FOR TRANSFER/MT101        *
      *              AND MT102 CONTROL MODULE                         *
      *                                                               *
      *  Function:  This is the main screen input function for        *
      *             the control of all modules that are required for  *
      *             the insertion, maintenance and display of request *
      *             for transfer details                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG24998           Date 17Jul09               *
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221534             Date 13Apr04               *
      *                 212229             Date 13Apr04               *
      *                 221761             Date 13Apr04               *
      *                 221538             Date 13Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 08Feb01               *
      *                 CFT009             Date 15Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178186             Date 26Apr00               *
      *                 177674             Date 20Apr00               *
      *                 CFT007             Date 21Mar00               *
      *                 CFT006  *CREATE    Date 17Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221534 - Not possible to enquire MT101s in VFTM.             *
      *  212229 - Every amendment on the transaction produces Unnece- *
      *           ssary Dr/Cr postings. Shadow posting for amendment  *
      *           should only be created when there's a change in     *
      *           account/amount/date.                                *
      *  221761 - Incorrect routing of multiple MT101s. Use new field *
      *           RSEQNO in FTH101PD as Sender's Ref Routing Seq.     *
      *  221538 - Expansion of field details.                         *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  188649 - Retrieve and display 101 status on displays         *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  185107 - Mapping of details from swift message               *
      *  178186 - Remove duplicated commit                            *
      *  177674 - Add comments in update process                      *
      *  CFT007 - BIC Database Plus                                   *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     FUNCTION OF INDICATORS                                    *
      *     **********************                                    *
      *                                                               *
      *     25    - Protect fields in header display file             *
      *     28-51 - Field Error - highlight screen fields             *
      *     26    -                                                   *
      *     20    - Display header for incoming messages              *
      *                                                               *
      *     Enable CF03 - Exit                                        *
      *     Enable CF12 - Cancel                                      *
      *     Enable CF05 - Refresh                                     *
      *     Enable CF10 - Delete/Confirm                              *
      *     Enable CF09 - Add                                         *
      *                                                               *
      *     80    - Not multibranching                                *
      *     81    - Originating branch not used                       *
      *     82    - Chain FT101HLC                                    *         185107
      *                                                               *
      *****************************************************************
      *                                                               *
      *     FUNCTION OF MODULE INDICATORS                             *
      *     *****************************                             *
      *                                                               *
      *     BI - Browse Initial subfile screen                        *
      *     RH - Retrieve Header details for header display           *
      *     RC - Retrieve Credit details for credit display           *
      *     CH - Convert Header  details to header screen fields      *
      *     CC - Convert Credit  details to credit screen fields      *
      *     DH - Display Header screen                                *
      *     DC - Display Credit screen                                *
      *     VH - Validate Header screen fields                        *
      *     VC - Validate Credit screen fields                        *
      *     UF - Update files                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *     SUBROUTINES                                               *
      *     ***********                                               *
      *                                                               *
      *     *INZSR - Initial subroutine called on entry               *
      *     BRWINI - Calls initial browse module                      *
      *     BRWCRE - Calls credit details browse module               *
      *     RTVHDR - Calls module to retrieve header details          *
      *     RTVCRE - Calls module to retrieve credit details          *
      *     CVTHDR - Calls module to convert PF header details to     *
      *              screen fields                                    *
      *     CVTCRE - Calls module to convert PF credit details to     *
      *              screen fields                                    *
      *     DSPHDR - Calls module to display header screen            *
      *     DSPCRE - Calls module to display credit screen            *
      *     VALHDR - Calls module which validates header screen input *
      *     UPDFIL - Calls module which updates files                 *
      *                                                               *
      *****************************************************************
     FFT101HLC  IF   E           K DISK    Prefix(MR)                           185107
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the FT standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D/COPY MECPYSRC,ME1100_ILE
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Current Incoming Debit Header Details
     D HdrRcdIn      E DS                  EXTNAME(FT101HPD) PREFIX(HD)
      *
      ** Current Incoming Debit Details
     D DtlRcdIn      E DS                  EXTNAME(FT101DPD) PREFIX(CR)
      *
      ** Current Incoming Debit Details
     D Ft101hs       E DS                  EXTNAME(FT101HSPD) PREFIX(SH)
      *
      ** Current Incoming Debit Details
     D Ft101cs       E DS                  EXTNAME(FT101DSPD)
      *
      ** Ok RFT Header browse
     D OKRftHdB      E DS                  EXTNAME(FTE101HBPD) PREFIX(HB)
      *
      ** Ok RFT Header browse
     D OKRftDtB      E DS                  EXTNAME(FTE101BPD) PREFIX(CB)
      *
      ** Ok RFT Header Details
     D OKHdr         E DS                  EXTNAME(FTE101HPD) PREFIX(OH)
      *
      ** Ok RFT Credit Details
     D OKCre1        E DS                  EXTNAME(FTE101S1PD) PREFIX(OC)
     D OkCre2        E DS                  EXTNAME(FTE101S2PD)
     D OkCre3        E DS                  EXTNAME(FTE101S3PD)
 
      ** Midas Modules details accessed via access program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **                                                                                      CSC022
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
 
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  MBIN                  13     13
      ** Current Incoming Debit Header Details                                                212229
     D NHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(NH)                       212229
      *                                                                                       212229
      ** Current Incoming Debit Details                                                       212229
     D NDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(ND)                       212229
      *                                                                                       212229
      ** Previous Incoming Debit Header Details                                               212229
     D PHdrRcdIn     E DS                  EXTNAME(FT101HPD) PREFIX(PH)                       212229
      *                                                                                       212229
      ** Previous Incoming Debit Details                                                      212229
     D PDtlRcdIn     E DS                  EXTNAME(FT101DPD) PREFIX(PD)                       212229
      *                                                                                       212229
 
      ** INDEXS
      ** ------
      ** Index of error message Id arrays
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D IdxErr          S                   LIKE(Idx)
     D IdxErr1         S                   LIKE(Idx)
     D IdxErr2         S                   LIKE(Idx)
     D IdxErr3         S                   LIKE(Idx)
     D IdxWrn1         S                   LIKE(WIdx)
     D IdxWrn2         S                   LIKE(WIdx)
     D IdxWrn3         S                   LIKE(WIdx)
 
     D q               S              2  0
 
      ** Index for arrays of msg ref and part                                   185660
     D MX              S              2  0                                      185660
                                                                                185660
 
      ** Number of Fields on the screen
     D NBHdrFld        C                   Const(25)
     D NBCr1Fld        C                   Const(27)
     D NBCr2Fld        C                   Const(18)
     D NBCr3Fld        C                   Const(15)
 
      ** ARRAYS
      ** ------
 
      ** Errors coming from the validation
     D FldNmArr1       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr1       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr1       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D FldNmArr2       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr2       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr2       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D FldNmArr3       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr3       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr3       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
 
      ** Warnings coming from the validation
     D WFldNmArr1      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr1      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr1      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
     D WFldNmArr2      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr2      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr2      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
     D WFldNmArr3      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr3      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr3      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
      ** Array for turning indicator off
     D @IndOff         S              1    DIM(30) CTDATA PERRCD(30)
      *
      ** Warning error test for redisplay of fields
     D @WrnErArr       S              1    DIM(NBHdrFld)
     D @WrnCr1         S              1    DIM(NBCr1Fld)
     D @WrnCr2         S              1    DIM(NBCr2Fld)
     D @WrnCr3         S              1    DIM(NBcr3Fld)
      *
     D @WrkOkHd        S              1    DIM(NBHdrFld)
     D @WrkOkCr1       S              1    DIM(NBCr1Fld)
     D @WrkOkCr2       S              1    DIM(NBCr2Fld)
     D @WrkOkCr3       S              1    DIM(NBCr3Fld)
 
     D MREFARR         S              8    DIM(100)                             185660
      ** Message reference array                                                185660
                                                                                185660
     D MPRTARR         S              3    DIM(100)                             185660
      ** Message part array                                                     185660
      **                                                                                      CSC022
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      ** FLAGS
      ** -----
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Main Process control flags
 
      ** Screen indicator
     D @Scrn           S              2A
      ** Action Code
     D @Actn           S              1A
     D Actn            S              1A
      ** Function Keys
     D @KeyP           S              2A
      ** Last screen displayed
     D @PrvS           S              4A
     D WPrvS           S              4A
      ** Save fields for refresh function
     D @MemF           S              1A
      ** Change direction of convertion on hdr(i.e from file to scrn & vice versa)
     D @CvtDrH         S              2A
      ** Change direction of convertion on crd(i.e from file to scrn & vice versa)
     D @CvtDrC         S              2A
      ** Screen returned from in credit display (i.e 1st, 2nd or 3rd screen)
     D @CurS           S              2A
      ** File locking flag
     D @FileLK         S              1A
      ** BIC Process Flag                                                       CFT007
     D @BIC            S              1A                                        CFT007
 
      ** Other parameters passed to modules
     D WrnToDsp        S              1A
     D RetCdeOut       S             10A
     D @Rftid          S             15A
     D @TransRf        S             16A
     D @SwiftRf        S             28A
     D @SwiftSq        S              2A
     D @RftTyp         S              2A
     D @MsgKey         S                   LIKE(PHMSGR)
     D @MsgPart        S                   LIKE(PHPART)
     D @Act            S              7A
     D @InitCVAL       S              1A
     D @Rtn            S              7A
     D @HdrActn        S              1A
     D @CallingPg      S             10A
     D @Network        S                   Like(PNWRK)
     D WRSEQNO         S                   Like(HDRSEQNO)                                     221761
     D WWRSEQNO        S                   Like(HDRSEQNO)                                     221761
 
      ** Old RFT ID (used for reassign in credit display screen)
     D OldRftID        S                   Like(PRFTHDR)
 
      ** Old Transaction reference
     D OldTransID      S                   Like(PTRNSID)
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
 
      ** CRE020 Parameters for QCMDEXC                                                        CRE020
     D SBMAdvice       S            150A   INZ('SBMJOB JOB(REC000881) +                       CRE020
     D                                       JOBD(MBATCH) USER(*JOBD) +                       CRE020
     D                                       RTGDTA(*JOBD) RQSDTA(+                           CRE020
     D                                       ''CALL REC000881 +                               CRE020
     D                                       (FTM101UPD FT)'') INLLIBL+                       CRE020
     D                                       (*JOBD) MSGQ(MOPERQ)')                           CRE020
     D SBMAdvLngth     S             15  5 INZ(150)                                           CRE020
                                                                                              CRE020
      ** Switchable Features Flags                                                            CRE020
     D CRE020          S              1A   INZ('N')                                           CRE020
                                                                                              CRE020
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
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** DO WHILE screen
      *
     C                   DOW       @KeyP <> '03'
      *
      ** Select module to be called
      *
     C                   SELECT
      *
      ** First call will be to intial browse screen
      *
     C                   WHEN      @Scrn = 'BI'
     C                   EXSR      BRWINI
      *
      ** If option is taken the the credit browse screen will be taken
      *
     C                   WHEN      @Scrn = 'BC'
     C                   EXSR      BRWCRE
      *
      ** On return from browse module, a RFT debit record will be
      ** retrieved (and action code validated) if it is required
      *
     C                   WHEN      @Scrn = 'RH'
     C                   EXSR      RTVHDR
      *
      ** On return from module, a RFT Credit record will be retieved
      *
     C                   WHEN      @Scrn = 'RC'
     C                   EXSR      RTVCRE
      *
      ** Once data has been retrieved it will be converted to
      ** to header screen fields (or back to file fields for update)
      *
     C                   WHEN      @Scrn = 'CH'
     C                   EXSR      CVTHDR
      *
      ** Once data has been retrieved it will be converted to
      ** to detail screen fields (or in reverse for update)
      *
     C                   WHEN      @Scrn = 'CC'
     C                   EXSR      CVTCRE
      *
      ** The general header details be displayed depending upon data
      ** input in browse
      *
     C                   WHEN      @Scrn = 'DH'
     C                   EXSR      DSPHDR
      *
      ** The credit screen will be displayed if relevant to action taken
      *
     C                   WHEN      @Scrn = 'DC'
     C                   EXSR      DSPCRE
      *
      ** Do Header Screen Validation
      *
     C                   WHEN      @Scrn = 'VH'
     C                   EXSR      VALHDR
      *
      ** Do Detail Screen Validation
      *
     C                   WHEN      @Scrn = 'VC'
     C                   EXSR      VALCRE
      *
      ** Do File updates
      *
     C                   WHEN      @Scrn = 'UF'
     C                   EXSR      UPDFIL
      *                                                                         CFT007
      ** BIC Database + (Header)                                                CFT007
      *                                                                         CFT007
     C                   WHEN      @Scrn = 'BH'                                 CFT007
     C                   EXSR      BICHDR                                       CFT007
      *
      ** Leave loop and end program if F3 pressed
      *
     C                   WHEN      @Scrn = 'TP'
     C                   LEAVE
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
      ** End program
      *
     C                   EXSR      ENDPGM
                                                                                              CRE020
     C                   IF        *INU7 = *OFF AND *INU8 = *OFF                              CRE020
     C                              AND CRE020 = 'Y'                                          CRE020
     C                   CALL      'QCMDEXC'                                                  CRE020
     C                   PARM                    SBMAdvice                                    CRE020
     C                   PARM                    SBMAdvLngth                                  CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      *
      * Hook to enable non-core subroutines to be included
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BRWINI - Browse Screen to display current incoming RFT details
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - SR/INPUT
      *
      *****************************************************************
      *
     C     BRWINI        BEGSR
      *
     C                   EVAL      @KeyP = *BLANKS
      *
      ** Call module FTM1011BW to build and process subfile list
      *
     C                   CALLB     'FTM1011BW'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM                    RetCdeOut
     C                   PARM                    @Actn
     C                   PARM                    @Rftid
     C                   PARM                    @TransRf
     C                   PARM                    @SwiftRf
     C                   PARM                    @KeyP
     C                   PARM                    @RftTyp
      ** Errors produced during retrieve operation
     C                   PARM                    OkRftHdB
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** END OF PARAMTER LIST
      *
      ** If error set on external switches
      *
     C                   SELECT
     C                   WHEN      RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1011BW'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
      *
      ** If Exit (CF/3) taken in browse, or error message
      ** End program
      *
     C                   WHEN      @KeyP = '03' OR @KeyP = '12'
     C                   EVAL      @Scrn = 'TP'
     C                   OTHER
      *
      ** If data has been entered and it is correct determine
      ** which module to call next
      *
     C                   EVAL      @Scrn = 'RH'
     C                   EVAL      @HdrActn = @Actn
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * BRWCRE - Browse Screen to display current incoming RFT Credit
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     BRWCRE        BEGSR
      *
      ** Call module FTM1012BW to build and process subfile list
      *
     C                   CALLB     'FTM1012BW'                          90      178186
      *
     C                   PARM      *BLANKS       RetCdeOut
     C                   PARM                    @Rftid
     C                   PARM                    @HdrActn
     C                   PARM      *BLANKS       @TransRf
     C                   PARM      *BLANKS       @SwiftRf
     C                   PARM      *BLANKS       @SwiftSq
     C                   PARM                    @Actn
     C                   PARM      *BLANKS       @KeyP
      ** Errors produced during retrieve operation
     C                   PARM                    OkRftDtB
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** END OF PARAMTER LIST
      *
      ** If error set on external switches
      *
     C                   SELECT
     C                   WHEN      RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1012BW'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
      *
      ** If Exit (CF/3) taken in browse, end program
      *
     C                   WHEN      @KeyP = '03'
     C                   EVAL      @Scrn = 'TP'
      *
      ** If Exit (CF/12) taken in browse, redisplay previous screen
      *
     C                   WHEN      @KeyP = '12'
     C                   IF        @PrvS = 'HDSP'
     C                   EVAL      @Scrn = 'DH'
      *
      ** Redisplay screen with previous action code
     C                   EVAL      @Actn = ACTN
     C                   ELSE
      *
     C                   EVAL      @Scrn = 'BI'
     C                   ENDIF
      *
      ** If Exit (CF/05) taken in browse
      *
     C                   WHEN      @KeyP = '05'
     C                   EVAL      @Scrn = 'BC'
      *
      ** If data has been entered and it is correct then retrieve
      ** credit details for display
      *
      ** If Exit (CF/09) taken in browse
      *
     C                   WHEN      @KeyP = '09'
     C                   EVAL      @Scrn = 'RC'
      *
      ** If enter pressed
      *
     C                   WHEN      @KeyP = *BLANKS
     C                   CLEAR                   MREFARR                        185660
     C                   CLEAR                   MPRTARR                        185660
     C                   Z-ADD     1             MX                             185660
     C                   EVAL      @Scrn = 'RC'
     C                   ENDSL
      *
     C                   EVAL      @PrvS = 'CBRW'
      *
     C     EBRWCRE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVHDR - Calls module which retrieves a RFT debit from
      *          database if required
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     RTVHDR        BEGSR
      *
     C                   EVAL      @KeyP = *BLANKS
      *
      ** Retieve RFT debit details and validate action code
      *
     C                   CALLB     'FTM1011RV'                          90     178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM      *BLANKS       RetCdeOut
     C                   PARM                    @Actn
     C                   PARM                    @RftTyp
     C                   PARM                    @Rftid
     C                   PARM                    @SwiftRf
     C                   PARM                    @MsgKey
     C                   PARM                    HdrRcdIn
     C                   PARM                    @KeyP
     C                   PARM                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    MREFARR                        185660
     C                   PARM                    MPRTARR                        185660
      *
     C                   PARM                    OkRftHdB
     C                   PARM      *ZEROS        Idx
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** END OF PARAMTER LIST
      *                                                                                       212229
      ** Store original values of the transaction                                             212229
      *                                                                                       212229
     C                   EVAL      PHdrRcdIn = HdrRcdIn                                       212229
      *
      ** If no errors in Retrieve then set up convert data module
      *
     C                   SELECT
      *
     C                   WHEN      RetCdeOut = '*ERROR'
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1011RV'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
      *
     C                   WHEN      RetCdeOut <> *BLANKS OR
     C                             Idx <> *ZEROS
      ** If FTM101SIN is called by ME1200,go back to ME1200 if there is
      ** an error else,
      ** Redisplay brw screen with errror of swift displayed
     C                   IF        ME1200 = *blanks
     C                   EVAL      @Scrn = 'BI'
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF
      *
     C                   WHEN      @KeyP = '03'
     C                   EVAL      @Scrn = 'TP'
      *
     C                   WHEN      @KeyP = '12'
     C                   EVAL      @Scrn = 'BI'
      *
     C                   OTHER
      *
      ** Call convert header module, converting to SCREEN fields
     C                   EVAL      @CvtDrH = 'SH'
     C                   EVAL      @Scrn = 'CH'
      *
     C                   ENDSL
      *
     C     ERTVHDR       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTHDR - Calls module which converts data from database file
      *          to screen fields
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     CVTHDR        BEGSR
      *
      ** Convert RFT debit details
      ** Mapping fields from physical file to screen
      *
      ** If Data have been picked up from a SWIFT message, that
      ** means Pdata is not blank. In this case message contents
      ** have been already converted to a screen format.
      ** We are not interested in Pdata anymore, we use the values
      ** of the screen.
     C     @CvtDrH       IFEQ      'FH'
     C     Pdata         IFNE      *BLANK
     C                   MOVEL     *BLANK        Pdata
     C                   ENDIF
      *                                                                                       CSW209
     C     PDAT2         IFNE      *BLANK                                                     CSW209
     C                   MOVEL     *BLANK        PDAT2                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF
      *
     C                   CALLB     'FTM1011CT'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM      *BLANK        RetCdeOut
     C                   PARM                    @Actn                                        221538
     C                   PARM                    @CvtDrH
     C                   PARM                    HdrRcdIn
     C                   PARM                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    @MSGKEY                        185107
     C                   PARM                    Ft101hs
      *
      ** Check for database error
      *
     C                   IF        RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1011CT'
     C                   EVAL      DBASE = 007
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check for direction to determine module to call
      *
     C                   IF        @CvtDrH = 'FH'
     C                   IF        @Actn = 'R'
     C                   EVAL      @Scrn = 'CC'
     C                   ELSE
     C                   EVAL      @Scrn = 'UF'
     C                   ENDIF
     C                   ELSE
      *
     C                   EXSR      INPUT
     C                   ENDIF
      *
      *
      ** Ensures only goes to update after correctly validating fields
      *
     C                   EVAL      @CvtDrH = 'SH'
      *
     C                   CallB     'FTVDSPSTS'                                  188649
     C                   Parm                    HDAUP1                         188649
     C                   Parm                    HDAUP2                         188649
     C                   Parm                    HDAUIN                         188649
     C                   Parm      *Blanks       HDAIND           20            188649
      *
     C     ECVTHDR       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INPUT  - If header section of browse entered correctly then
      *         S/R will decide which further modules to call
      *
      * CALLED FROM: - SR/BRWINI
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     INPUT         BEGSR
      *
      ** Depending on data input on browse screen determine the next
      ** module to be chosen
      *
     C                   EVAL      Actn = @Actn
      *
     C                   EVAL      @PrvS = 'HBRW'
      *
     C                   EVAL      @MemF = 'Y'
      *
     C                   IF        Actn = 'I'
     C                   SELECT
     C                   WHEN      @Rftid <> *BLANKS
      ** Leads to display of blank credit screen
     C                   EVAL      @Scrn = 'RC'
     C                   WHEN      @Rftid = *BLANKS AND @SwiftRf = *BLANKS
      ** Leads to display of blank header screen
     C                   EVAL      @Scrn = 'DH'
     C                   WHEN      @SwiftRf <> *BLANK
     C                   EVAL      @Scrn = 'DH'
     C                   ENDSL
     C                   ENDIF
      *
     C                   IF        Actn = 'A'
     C                   SELECT
     C                   WHEN      @Rftid <> *BLANKS AND
     C                             @TransRf <> *BLANKS
     C                   EVAL      @Scrn = 'RC'
     C                   WHEN      @Rftid <> *BLANKS
     C                   EVAL      @Scrn = 'DH'
     C                   ENDSL
     C                   ENDIF
      *
     C                   IF        Actn = 'E'
     C                   SELECT
     C                   WHEN      @Rftid <> *BLANKS AND
     C                             @TransRf <> *BLANKS
     C                   EVAL      @Scrn = 'RC'
     C                   WHEN      @Rftid <> *BLANKS
     C                   EVAL      @Scrn = 'DH'
     C                   ENDSL
     C                   ENDIF
      *
     C                   IF        Actn = 'D'
     C                   SELECT
     C                   WHEN      @Rftid <> *BLANKS AND
     C                             @TransRf <> *BLANKS
     C                   EVAL      @Scrn = 'RC'
     C                   WHEN      @Rftid <> *BLANKS
     C                   EVAL      @Scrn = 'DH'
     C                   ENDSL
     C                   ENDIF
      *
     C                   IF        Actn = 'X'
     C                   IF        @Rftid <> *BLANKS
     C                   EVAL      @Scrn = 'DH'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        Actn = 'C'
     C                   IF        @Rftid <> *BLANKS
      *                                                                         185107
      ** If program is called from ME1200, go straight to the credit            185107
      ** detail screen, otherwise go to the credit browse screen                185107
      *                                                                         185107
     C                   IF        ME1200 = *BLANKS                             185107
     C                   EVAL      @Scrn = 'BC'
     C                   ELSE                                                   185107
     C                   EVAL      @SCRN = 'RC'                                 185107
     C                   EVAL      @ACTN = 'I'                                  185107
     C                   MOVEL     MSGREF        @MSGKEY                        185107
     C                   ENDIF                                                  185107
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVCRE - Calls module which retrieves a RFT Credit from
      *          database if required
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     RTVCRE        BEGSR
      *
      ** Retieve RFT debit details and validate action code
      *
     C                   CALLB     'FTM1012RV'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM                    RetCdeOut
     C                   PARM                    @Actn
     C                   PARM                    @Rftid
     C                   PARM                    @TransRf
     C                   PARM                    @SwiftRf
     C                   PARM                    @SwiftSq
 Ad  C                   PARM                    @MsgKey
      *
     C                   PARM                    DtlRcdIn
     C                   PARM                    @KeyP
     C                   PARM                    Phead
     C                   PARM                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    MREFARR                        185660
     C                   PARM                    MPRTARR                        185660
     C                   PARM                    OkRftDtB
     C                   PARM      *ZEROS        Idx
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** END OF PARAMTER LIST
      *                                                                                       212229
      ** Store original values of the transaction                                             212229
      *                                                                                       212229
     C                   EVAL      PDtlRcdIn = DtlRcdIn                                       212229
      *
      ** If no errors in Retrieve then set up convert data module
      *
     C                   SELECT
      *
     C                   WHEN      RetCdeOut = '*ERROR'
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1012RV'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
      *
      *
     C                   WHEN      RetCdeOut <> *BLANKS OR
     C                             Idx <> *ZEROS
      ** If FTM102SIN is called by ME1200,go back to ME1200 if there is         185107
      ** an error else,                                                         185107
      ** Redisplay brw screen with errror of swift displayed
     C                   IF        ME1200 = *blanks                             185107
     C                   EVAL      @Scrn = 'BC'
     C                   ELSE                                                   185107
     C                   EVAL      @Scrn = 'TP'                                 185107
     C                   ENDIF                                                  185107
      *
     C                   WHEN      @KeyP = '03'
     C                   EVAL      @Scrn = 'TP'
      *
     C                   WHEN      @KeyP = '12'
     C                   EVAL      @Scrn = 'BC'
      *
     C                   OTHER
      ** Call convert detail module, converting to SCREEN fields
     C                   EVAL      @CvtDrC = 'SC'
     C                   EVAL      @Scrn = 'CC'
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTCRE - Calls module which converts data from database file
      *          to screen fields
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     CVTCRE        BEGSR
      *
      ** Convert RFT debit details
      *
      ** Mapping fields from physical file to screen
      *
      ** If Data have been picked up from a SWIFT message, that
      ** means Pdata is not blank. In this case message contents
      ** have been already converted to a screen format.
      ** We are not interested in Pdata anymore, we use the values
      ** of the screen.
     C     @CvtDrC       IFEQ      'FC'
     C     Pdata         IFNE      *BLANK
     C                   MOVEL     *BLANK        Pdata
     C                   CLEAR                   Phead
     C                   ENDIF
      *                                                                                       CSW209
     C     PDAT2         IFNE      *BLANK                                                     CSW209
     C                   MOVEL     *BLANK        PDAT2                                        CSW209
     C                   CLEAR                   PHEAD                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF
      *
     C                   CALLB     'FTM1012CT'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM                    RetCdeOut
     C                   PARM                    @Actn                                        221538
     C                   PARM                    @CvtDrC
     C                   PARM                    DtlRcdIn
     C                   PARM                    Phead
     C                   PARM                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    Ft101cs
      *
      ** If no errors call display credit module
      *
     C                   IF        RetCdeOut <> *BLANK
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1012CT'
     C                   EVAL      DBASE = 008
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Check for direction of conversion to call next module
      *
     C                   IF        @CvtDrC = 'FC'
     C                   EVAL      @Scrn = 'UF'
     C                   ELSE
     C                   EVAL      @Scrn = 'DC'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Change back to screen direction so that update module cannot be called
      *
     C                   EVAL      @CvtDrC = 'SC'
      *
     C     ECVTCRE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * DSPHDR - Calls module which displays screen for general
      *          details maintenance/insertion
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     DSPHDR        BEGSR
      *
     C                   If        @KeyP <> '11'
     C                   EVAL      @KeyP = *BLANKS
     C                   Endif
      *
      ** If previous screen is BRW then there should be no errors
      ** and Key pressed should be blanks
     C                   IF        @PrvS <> 'HDSP' AND
     C                             @FileLk <> 'Y'
      *
     C                   EVAL      @MemF = 'Y'
      *
     C                   MOVEA     @IndOff       *IN(28)
     C                   MOVE      *ALL'Y'       OkHdr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      WIdx = 0
     C                   ENDIF
      *
      ** Display general details screen
      *
     C                   CALLB     'FTM1015DP'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM                    RetCdeOut
     C                   PARM                    @Actn
     C                   PARM                    @RftTyp
     C                   PARM                    @SwiftRf
     C                   PARM                    Ft101hs
     C                   PARM                    OKHdr
     C                   PARM                    @KeyP
     C                   PARM                    @MemF
      *
      ** ERROR fields/message IDs/message data
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      ** WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      * Field Name                                                              CFT007
     C                   PARM                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    HDAIND                         188649
      *
      ** END OF PARAMTERS LIST
      *
      ** If there are no errors determine next module to call
      *
     C                   IF        RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1015DP'
     C                   EVAL      DBASE = 009
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
      *
      ** If F3 pressed
      *
     C                   WHEN      @KeyP = '03'
     C                   EVAL      @Scrn = 'TP'
      *                                                                         CFT007
      ** If F4 or F16 pressed, call BIC module.                                 CFT007
      *                                                                         CFT007
     C                   WHEN      @KeyP = '04' OR                              CFT007
     C                             @KeyP = '16'                                 CFT007
     C                   EVAL      @Scrn = 'BH'                                 CFT007
     C                   EVAL      @BIC  = 'H'                                  CFT007
      *
      ** If F5 pressed (refresh screen back to original format)
      *
     C                   WHEN      @KeyP = '05'
     C                   EVAL      @Scrn = 'DH'
      *
      ** If F11 pressed : Display user details
      *
     C                   WHEN      @KeyP = '11'
     C                   EVAL      @Scrn = 'DH'
      *
      ** If F12 pressed, go back to ME1200 if FTM101SIN was called by
      ** this else go back to browse screen
     C                   WHEN      @KeyP = '12'
     C                   IF        ME1200 = *blanks
     C                   EVAL      @Scrn = 'BI'
      *
      ** Initialise temporary warning
      *
     C                   EXSR      INITARR
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF
      *
      *
      ** If F10 pressed
      *
     C                   WHEN      @KeyP = '10'
      *
     C                   IF        @Actn = 'D'
      ** This will delete both the header and detail records
     C                   EVAL      @CvtDrH = 'FH'
     C                   EVAL      @Scrn = 'CH'
     C                   EVAL      HdrInfo = 'Y'
     C                   EVAL      DtlInfo = 'N'
     C                   ENDIF
      *
     C                   IF        @Actn = 'X'
      ** This will allow display of all associated detail records before
      ** authorisation of both header and detail together
     C                   EVAL      @Scrn = 'RC'
     C                   ENDIF
      *
      ** If Enter is pressed, then validate screen  fields
      *
     C                   WHEN      @KeyP = *BLANKS
      *
     C                   IF        @Actn = 'A' OR @Actn = 'I'
     C                   EVAL      @Scrn = 'VH'
     C                   ENDIF
      *
     C                   IF        @Actn = 'E'
     C                   EVAL      @Scrn = 'BC'
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   EVAL      @PrvS = 'HDSP'
      *
     C     EDSPHDR       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * DSPCRE  - Calls module which displays screen for transaction
      *           detail (credit detail) maintenance
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     DSPCRE        BEGSR
      *
      ** If previous screen is not CDSP, then should be no errors on entry
      ** and key pressed should be blank
      *
     C                   IF        @PrvS <> 'CDSP' AND
     C                             @FileLk <> 'Y'
      *
      ** Move in the two header fields that will be displayed as
      ** output fields in credit ( i.e custrf and sndref)
      *
     C                   EVAL      PSNDREF = HDSNDREF
     C                   EVAL      PCUSREF = HDCUSTRF
      *
     C                   EVAL      WPrvS = @PrvS
     C                   EVAL      @KeyP = *BLANKS
      *
     C                   MOVEA     @IndOff       *IN(28)
     C                   MOVE      *ALL'Y'       OkCre1
     C                   MOVE      *ALL'Y'       OkCre2
     C                   MOVE      *ALL'Y'       OkCre3
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   FldNmArr1
     C                   CLEAR                   MsgIdArr1
     C                   CLEAR                   MsgDtArr1
     C                   CLEAR                   FldNmArr2
     C                   CLEAR                   MsgIdArr2
     C                   CLEAR                   MsgDtArr2
     C                   CLEAR                   FldNmArr3
     C                   CLEAR                   MsgIdArr3
     C                   CLEAR                   MsgDtArr3
     C                   EVAL      IdxErr1 = 0
     C                   EVAL      IdxErr2 = 0
     C                   EVAL      IdxErr3 = 0
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WFldNmArr1
     C                   CLEAR                   WMsgIdArr1
     C                   CLEAR                   WMsgDtArr1
     C                   CLEAR                   WFldNmArr2
     C                   CLEAR                   WMsgIdArr2
     C                   CLEAR                   WMsgDtArr2
     C                   CLEAR                   WFldNmArr3
     C                   CLEAR                   WMsgIdArr3
     C                   CLEAR                   WMsgDtArr3
     C                   EVAL      IdxWrn1 = 0
     C                   EVAL      IdxWrn2 = 0
     C                   EVAL      IdxWrn3 = 0
     C                   MOVEL     'Y'           @InitCVAL
     C*******************IF        @Actn = 'I'                                  185660
     C*******************EVAL      PRFTHDR = HDRFTID                            185660
     C*******************ENDIF                                                  185660
     C                   ENDIF
 
     C                   IF        @Actn = 'I'                                  185660
     C                   EVAL      PRFTHDR = HDRFTID                            185660
     C                   ENDIF                                                  185660
      *
      ** Display Credit details Screen
      *
     C                   CALLB     'FTM1011DP'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM      *BLANK        RetCdeOut
     C                   PARM                    @Actn
     C                   PARM                    @RftTyp
     C                   PARM                    Ft101cs
     C                   PARM                    OKCre1
     C                   PARM                    OkCre2
     C                   PARM                    OkCre3
     C                   PARM                    FldNmArr1
     C                   PARM                    MsgIdArr1
     C                   PARM                    MsgDtArr1
     C                   PARM                    FldNmArr2
     C                   PARM                    MsgIdArr2
     C                   PARM                    MsgDtArr2
     C                   PARM                    FldNmArr3
     C                   PARM                    MsgIdArr3
     C                   PARM                    MsgDtArr3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNmArr1
     C                   PARM                    WMsgIdArr1
     C                   PARM                    WMsgDtArr1
     C                   PARM                    WFldNmArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    WMsgDtArr2
     C                   PARM                    WFldNmArr3
     C                   PARM                    WMsgIdArr3
     C                   PARM                    WMsgDtArr3
     C                   PARM                    @KeyP
     C                   PARM                    OldRftID
     C                   PARM                    OldTransID
      ** Screen Displayed (for SIN Module)
      **                  (for VAL module)
     C                   PARM                    @CurS
     C                   PARM                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    HDAIND                         188649
      *
      ** END OF PARAMETERS LIST
      *
      ** If there are no errors then determine next module to call
      *
     C                   IF        RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1011DP'
     C                   EVAL      DBASE = 010
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SELECT
      *
      ** If F3 pressed
      *
     C                   WHEN      @KeyP = '03'
     C                   EVAL      @Scrn = 'TP'
      *                                                                         CFT007
      ** BIC Database +                                                         CFT007
      *                                                                         CFT007
     C                   WHEN      @KeyP = '04' OR                              CFT007
     C                             @KeyP = '16'                                 CFT007
     C                   EVAL      @Scrn = 'BH'                                 CFT007
     C                   Eval      @BIC = 'C'                                   CFT007
      *
      ** If F5 pressed (refresh screen back to original format)
      *
     C                   WHEN      @KeyP = '05'
     C                   EVAL      @Scrn = 'DC'
      *
      ** If F11 pressed
      *
     C                   WHEN      @KeyP = '11'
     C                   EVAL      @Scrn = 'DC'
      *
      ** If F12 pressed
      *
     C                   WHEN      @KeyP = '12'
      ** F12 pressed on the first screen
     C                   IF        @CurS = '01'
      *
     C                   IF        WPrvS = 'CBRW'
     C                   EVAL      @Scrn = 'BC'
     C                   ELSE
      ** Go back to ME1200 if FTM101SIN was called by this else go back
      ** to the browse screen
     C                   IF        ME1200 = *blanks
     C                   EVAL      @Scrn = 'BI'
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** F12 pressed on other screens
     C                   ELSE
     C                   EVAL      @Scrn = 'DC'
 
     C                   ENDIF
      *
      ** If F10 pressed
      *
     C                   WHEN      @KeyP = '10'
      *
     C                   IF        @Actn = 'D'
     C                   EVAL      @CvtDrC = 'FC'
      ** This will delete the detail record only
     C                   EVAL      @Scrn = 'CC'
     C                   EVAL      HdrInfo = 'N'
     C                   EVAL      DtlInfo = 'Y'
     C                   ENDIF
      *
     C                   IF        @Actn = 'X'
     C                   EVAL      @CvtDrH = 'FH'
      ** This will authorise both the header and detail record
      *** do i need to convert header / and details
     C                   EVAL      @Scrn = 'CH'
     C                   EVAL      HdrInfo = *BLANKS
     C                   EVAL      DtlInfo = *BLANKS
     C                   ENDIF
      *
     C                   IF        @Actn = 'R'
     C                   EVAL      @Scrn = 'VC'
     C                   ENDIF
      *
      ** If Enter pressed, validate screen fields
      *
     C                   WHEN      @KeyP = *BLANKS
     C
     C                   IF        @Actn = 'E'
     C                   IF        @CurS = '03'
     C                   EVAL      @Scrn = 'BC'
     C                   ELSE
     C                   EVAL      @Scrn = 'DC'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        @Actn = 'D'
     C                   EVAL      @Scrn = 'DC'
     C                   ENDIF
      *
     C                   IF        @Actn = 'A' OR @Actn = 'I' OR
     C                             @Actn = 'R' OR @Actn = *BLANKS
     C                   EVAL      @Scrn = 'VC'
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   EVAL      @PrvS = 'CDSP'
      *
     C     EDSPCRE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALHDR - Calls Validation module
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       None
      *
      *****************************************************************
      *
     C     VALHDR        BEGSR
      *
      ** Call header validation module
      *
     C                   CALLB     'FTM1011VL'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      *
     C                   PARM                    RetCdeOut
     C                   PARM                    RespMode
     C                   PARM                    @Actn
     C                   PARM                    Ft101hs
      *
     C                   PARM                    OKHdr
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
      *
      ** END OF PARAMETERS LIST
      *
      ** If any invalid entries redisplay header screen with error mess
      *
     C                   IF        RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1011VL'
     C                   EVAL      DBASE = 011
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        Idx <> 0
     C                   EVAL      @Scrn = 'DH'
     C                   GOTO      ENDVH
     C                   ENDIF
      *
     C                   IF        WIdx <> 0
      *
     C                   MOVEA     OKHdr         @WrkOkHd
      *
      ** Set screen error indicators according to statue of 'OK' flags
      ** Start screen indicator at first error indicator (i.e IN28)
      *
     C                   Z-ADD     1             Cnt               2 0
      *
     C                   DOW       Cnt <= NBHdrFld
     C                   IF        @WrkOkHd(Cnt) <> @WrnErArr(Cnt) AND
     C                             @WrkOkHd(Cnt) = 'W'
     C                   EVAL      @Scrn = 'DH'
     C                   GOTO      ENDVH
     C                   ENDIF
     C                   ADD       1             Cnt
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Call convert module to change screen fields back to FILE
      ** prior to update
      *
     C                   EVAL      @CvtDrH = 'FH'
     C                   EVAL      @Scrn = 'CH'
     C                   EVAL      HdrInfo  = 'Y'
     C                   EVAL      DtlInfo  = 'N'
 
      ***If*FTM101SIN*was*called*by*ME1200,*set*message*ref.*to*0,*so           185107
      ***the*credit*retrieve*will*not*retrieve*anything**************           185107
      ***************************************************************           185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @MsgKey = 0                                  185107
     c*******************ENDIF                                                  185107
      *
     C     ENDVH         TAG
      *
      ** Move 'OK' flags into array (to check whether along array for
      ** 'W' flags
      *
     C                   MOVEA     OKHdr         @WrnErArr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALCRE - Determines which validation module to be called
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:
      *
      *****************************************************************
      *
     C     VALCRE        BEGSR
     C
     C     @ACTN         IFEQ      'I'                                                        212229
     C                   MOVE      *BLANKS       SHPRFTID                                     212229
     C                   MOVE      *BLANKS       SHPSNDREF                                    212229
     C                   MOVEL     HDRFTID       SHPRFTID                                     212229
     C                   MOVEL     HDSNDREF      SHPSNDREF                                    212229
     C                   ENDIF                                                                212229
     C                   CALLB     'FTM1012VL'                          90      178186
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    @CurS
     C                   PARM                    @Actn
     C                   PARM                    @InitCVAL
     C                   PARM                    Ft101hs
     C                   PARM                    Ft101cs
     C                   PARM                    WrnToDsp
     C                   PARM                    OkCre1
     C                   PARM                    OkCre2
     C                   PARM                    OkCre3
     C                   PARM                    IdxErr1
     C                   PARM                    IdxErr2
     C                   PARM                    IdxErr3
     C                   PARM                    FldNmArr1
     C                   PARM                    MsgIdArr1
     C                   PARM                    MsgDtArr1
     C                   PARM                    FldNmArr2
     C                   PARM                    MsgIdArr2
     C                   PARM                    MsgDtArr2
     C                   PARM                    FldNmArr3
     C                   PARM                    MsgIdArr3
     C                   PARM                    MsgDtArr3
     C                   PARM                    IdxWrn1
     C                   PARM                    IdxWrn2
     C                   PARM                    IdxWrn3
     C                   PARM                    WFldNmArr1
     C                   PARM                    WMsgIdArr1
     C                   PARM                    WMsgDtArr1
     C                   PARM                    WFldNmArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    WMsgDtArr2
     C                   PARM                    WFldNmArr3
     C                   PARM                    WMsgIdArr3
     C                   PARM                    WMsgDtArr3
      *                                                                          178186
     C                   IF        RetCodeIn <> *BLANK                           178186
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM1012VL'                          178186
     C                   EVAL      DBASE = 019                                   178186
     C                   EVAL      DBKEY = @Actn                                 178186
     C                   EVAL      *INU7 = *ON                                   178186
     C                   EVAL      *INU8 = *ON                                   178186
     C                   EXSR      *PSSR                                         178186
     C                   ENDIF                                                   178186
      *
      ** If any invalid entries redisplay credit screen with error message
     C                   IF        IdxErr1 <> 0 OR
     C                             IdxErr2 <> 0 OR
     C                             IdxErr3 <> 0 OR
     C                             WrnToDsp = 'Y'
      *
     C                   EVAL      @Scrn = 'DC'
     C                   GOTO      ENDVC
     C                   ENDIF
      *
      *
     C                   SELECT
     C                   WHEN      @Actn = 'I' AND @CurS = '03' OR
     C                             @Actn = 'A' AND @CurS = '03'
      *
      ** Call convert module to change screen fields back to FILE
      ** prior to update
      *
     C                   EVAL      @CvtDrC = 'FC'
     C                   EVAL      @Scrn = 'CC'
     C                   EVAL      HdrInfo  = 'N'
     C                   EVAL      DtlInfo  = 'Y'
      *
     C                   WHEN      @Actn = 'D' AND
     C                             @KeyP = '10'
      *
      ** Call convert module to change screen fields back to FILE
      ** prior to update
      *
     C                   EVAL      @CvtDrC = 'FC'
     C                   EVAL      @Scrn = 'CC'
     C                   EVAL      HdrInfo  = 'N'
     C                   EVAL      DtlInfo  = 'Y'
      *
     C                   WHEN      @Actn = 'R' AND
     C                             @KeyP = '10'
      *
      ** Call convert module to change screen fields back to FILE
      ** prior to update
      *
     C                   EVAL      @CvtDrH = 'FH'
     C                   EVAL      @CvtDrC = 'FC'
     C                   EVAL      @Scrn = 'CH'
     C                   EVAL      HdrInfo  = 'N'
     C                   EVAL      DtlInfo  = 'Y'
     C                   Eval      OldRftId = HDRftId
     C                   Eval      OldTransId = CRTrnsId
      *
     C                   OTHER
      *
     C                   EVAL      @Scrn = 'DC'
      *
     C                   ENDSL
      *
     C     ENDVC         TAG
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDFIL - UPDATES Files
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     UPDFIL        BEGSR
      *                                                                         177674
      ** WARNING :                                                              177674
      ** Straight Trough Processing (STP) will follow the update process        177674
      ** therefore, each time a change is done here (a new module, a new        177674
      ** condition) it has to be reported in FT0300                             177674
      *                                                                         177674
      *
      ** Initialise temporary warning fields when going to update
      *
     C                   EXSR      INITARR
      *
      ** ¦initialise file lock field
      *
     C                   EVAL      @FileLK = 'N'
      *
     C                   EVAL      NHdrRcdIn = HdrRcdIn                                       212229
     C                   EVAL      NDtlRcdIn = DtlRcdIn                                       212229
     C                   Eval      HDRSEQNO = WWRSEQNO                                        221761
 
      * Remove all forward positions.
     C                   CallB     'FTM101UPP'                          90       178186
     C                   Parm                    RetCodeIn
     C                   Parm                    @Actn
     C                   Parm      'R'           AddRemove         1
     C                   Parm                    HDRftid
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HdrInfo                                      212229
     C                   PARM                    DtlInfo                                      212229
     C                   PARM      'N'           FTSTP             1                          212229
      *                                                                          178186
      ** If errors                                                               178186
      *                                                                          178186
     C                   IF        RetCodeIn <> *BLANK                           178186
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM101UPP'                          178186
     C                   EVAL      DBASE = 017                                   178186
     C                   EVAL      DBKEY = AddRemove                             178186
     C                   EVAL      *INU7 = *ON                                   178186
     C                   EVAL      *INU8 = *ON                                   178186
     C                   EXSR      *PSSR                                         178186
     C                   ENDIF                                                   178186
      *
      ** Call module to update RFT files
      *
     C                   CALLB     'FTM101UPD'                          90       178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        RetCdeOut
     C                   PARM                    @Actn             1
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
     C                   PARM                    HdrInfo           1
     C                   PARM                    DtlInfo           1
     C                   PARM                    OldRftID
     C                   PARM                    OldTransID
     C                   PARM      PSJobName     @CallingPg
     C                   PARM      PNWRK         @Network
      ** Errors produced during I/O operation
     C                   PARM                    IdxErr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
     C                   IF        RetCdeOut <> *BLANKS
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM101UPD'
     C                   EVAL      DBASE = 013
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Check that file can be updated (i.e no lock in files) if not
      ** then redisplay screen with error
     C                   IF        IdxErr <> 0
     C                   IF        @PrvS = 'HDSP'
     C                   EVAL      @Scrn = 'DH'
     C                   EVAL      @FileLK = 'Y'
     C                   ENDIF
     C                   IF        @PrvS = 'CDSP'
     C                   EVAL      @Scrn = 'DC'
     C                   EVAL      @FileLK = 'Y'
     C                   ENDIF
     C                   ELSE
      *
      ** Depending on previous screen and action display next screen
      ** Move to the next relevant screen
     C                   IF        @Actn = 'A' OR
     C                             @Actn = 'R'
     C                   EVAL      @Scrn = 'BC'
     C                   ENDIF
      *
     C                   IF        @Actn = 'I' OR @Actn = *BLANKS
      ** Message created through SWIFT message go to browse credit
      ** only if program was not called from ME1200.                            185107
      ** If pgm was called from ME1200, return back to ME1200                   185107
      *                                                                         185107
     C                   IF        DtlInfo = 'Y'
     C                   IF        CRRFTMSG <> 0 AND CRRFTMSQ <> 0
 
     C                   IF        ME1200 = *BLANKS                             185107
 
      ** Check if msg ref and part array are filled, if so move msg ref         185660
      ** and part to FTM1012RV parameters and goto call FTM1012RV               185660
                                                                                185660
     C                   ADD       1             MX                             185660
                                                                                185660
     C                   IF        MREFARR(MX) <> *BLANKS                       185660
     C                   MOVE      MREFARR(MX)   @MSGKEY                        185660
     C                   MOVE      MPRTARR(MX)   @SWIFTSQ                       185660
     C                   EVAL      @Scrn = 'RC'                                 185660
     C                   ELSE                                                   185660
 
     C                   MOVE      *BLANKS       @MSGKEY                        185660
     C                   MOVE      *BLANKS       @SWIFTSQ                       185660
     C                   EVAL      @Scrn = 'BC'
     C                   ENDIF                                                  185660
 
     C                   ELSE                                                   185107
     C                   EVAL      @SCRN = 'TP'                                 185107
     C                   ENDIF                                                  185107
 
     C                   ELSE
     C                   EVAL      @Scrn = 'RC'
     C                   ENDIF
     C                   ELSE
                                                                                185660
      ** Check if msg ref and part array are filled, if so move msg ref         185660
      ** and part to FTM1012RV parameters                                       185660
                                                                                185660
     C                   Z-ADD     1             MX                             185660
                                                                                185660
     C                   IF        MREFARR(MX) <> *BLANKS                       185660
     C                   MOVE      MREFARR(MX)   @MSGKEY                        185660
     C                   MOVE      MPRTARR(MX)   @SWIFTSQ                       185660
     C                   ENDIF                                                  185660
                                                                                185660
     C                   EVAL      @RFTID = HDRFTID                             185660
 
     C                   EVAL      @Scrn = 'RC'
     C                   ENDIF
     **  blanks out key pressed
???  C                   EVAL      @KeyP = *BLANKS
 
     **  Taken out this part of fix 185107 to allow sfl readc processing        185107
     **  from browse screen when routing more than one message.                 185107
     C*******************If        DtlInfo = 'Y' and ME1200 <> *BLANKS          185107
     C*******************Eval      @KeyP = '12'                                 185107
     C*******************Endif                                                  185107
 
     C                   ENDIF
      *
     C                   IF        @Actn = 'D' OR @Actn = 'X'
     C                   EVAL      @Scrn = 'BI'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** No errors trapped by the update module                                  178186
     C                   IF        IdxErr = 0                                    178186
     C                   EVAL      NHdrRcdIn = HdrRcdIn                                       212229
     C                   EVAL      NDtlRcdIn = DtlRcdIn                                       212229
      *
      ** Update forward positions file.
      *
     C                   CallB     'FTM101UPP'                          90       178186
     C                   Parm                    RetCodeIn
     C                   Parm                    @Actn
     C                   Parm      'A'           AddRemove         1
     C                   Parm                    HDRftid
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HdrInfo                                      212229
     C                   PARM                    DtlInfo                                      212229
     C                   PARM      'N'           FTSTP                                        212229
      *                                                                          178186
      ** If errors                                                               178186
      *                                                                          178186
     C                   IF        RetCodeIn <> *BLANK                           178186
     C                             OR *IN90                                      178186
     C                   EVAL      DBFILE = 'FTM101UPP'                          178186
     C                   EVAL      DBASE = 018                                   178186
     C                   EVAL      DBKEY = AddRemove                             178186
     C                   EVAL      *INU7 = *ON                                   178186
     C                   EVAL      *INU8 = *ON                                   178186
     C                   EXSR      *PSSR                                         178186
     C                   ENDIF                                                   178186
      *                                                                          178186
     C                   ENDIF                                                   178186
      *                                                                          178186
      * END OF UPDATE PROCESS                                                    178186
      * ---------------------                                                    178186
      * If the modules which cause an update have terminated                     178186
      * successfully we commit all the changes                                   178186
     C                   IF        IdxErr = 0  AND                               178186
     C                             RetCodeIn = *BLANK AND                        178186
     C                             RetCdeOut = *BLANKS                           178186
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT                                                  178186
     C                   EndIf                                                                CSC022
      *                                                                                       221761
     C                   If        @Actn = 'I'                                                221761
     C                             And ME1200 <> *blanks                                      221761
     C                   Eval      ME1200 = 'I'                                               221761
     C                   Endif                                                                221761
     C                   ELSE                                                    178186
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK                                                   178186
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF                                                   178186
      *                                                                          178186
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITARR - Initialise temporary warning arrays
      *
      * CALLED FROM: -
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     INITARR       BEGSR
      *
      ** Initialise temporary warning fields when going to update
      *
     C                   MOVE      *ALL'Y'       @WrnErArr
     C                   MOVE      *ALL'Y'       @WrkOkHd
     C                   MOVE      *ALL'Y'       @WrnCr1
     C                   MOVE      *ALL'Y'       @WrnCr2
     C                   MOVE      *ALL'Y'       @WrnCr3
     C                   MOVE      *ALL'Y'       @WrkOkCr1
     C                   MOVE      *ALL'Y'       @WrkOkCr2
     C                   MOVE      *ALL'Y'       @WrkOkCr3
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      * ENDPGM - Terminate program
      *
      * CALLED FROM: -
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     ENDPGM        BEGSR
      *
      * Unlock all the messages reserved by the application
     C                   CALL      'ME1070'                             90
     C                   PARM      '*END    '    @Act
     C                   PARM      0             @MsgKey
     C                   PARM      0             @MsgPart
     C                   PARM      *BLANKS       @SwiftRf
     C                   PARM      *BLANKS       @SwiftRf
     C                   PARM      *BLANKS       @Rtn
      *
     C     *IN90         IFEQ      '1'
     C                   EVAL      DBFILE = 'ME1070'
     C                   EVAL      DBASE = 016
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
      * Commit changes on MEINMRPD (no commit in ME1070)
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
      *
      ** If FTM101SIN was called by ME1200, return back a code
      ** according to the function key pressed
      *
      ** F3 pressed
      *
     C                   IF        ME1200 <> *blanks AND @KeyP = '03'
     C                   EVAL      ME1200 = '1'
     C                   ENDIF
      *
      ** F12 pressed
      *
     C                   IF        ME1200 <> *blanks AND @KeyP = '12'
     C                   EVAL      ME1200 = '5'
     C                   ENDIF
      *
      ** Error occurred
      *
      ** <Enter> is allowed so code below has been removed                      185107
      ** multiple routing from browse screen is now possible                    185107
     C*******************IF        ME1200 <> *blanks AND @KeyP = *blanks        185107
     C*******************EVAL      ME1200 = 'E'                                 185107
     C*******************ENDIF                                                  185107
     C                   ENDSR
      *
      *****************************************************************         CFT007
      /EJECT                                                                    CFT007
      *****************************************************************         CFT007
      * BICHDR.  Calls BIC modules for HEADER record                            CFT007
      *                                                                         CFT007
      * CALLED FROM: - Main processing                                          CFT007
      *                                                                         CFT007
      * CALLS:       - None                                                     CFT007
      *****************************************************************         CFT007
     C     BICHDR        BEGSR                                                  CFT007
      *                                                                         CFT007
      *                                                                         CFT007
     C                   CallB     'FTM101GEN'                                  CFT007
     C                   Parm                    RetCodeIn                      CFT007
     C                   Parm                    RespMode                       CFT007
     C                   Parm                    @Actn                          CFT007
     C                   Parm                    Ft101hs                        CFT007
     C                   Parm                    Ft101cs                        CFT007
     C                   Parm                    @KeyP                          CFT007
     C                   Parm                    FldNameArr                     CFT007
     C                   Parm                    MsgIDArr                       CFT007
     C                   Parm                    MsgDtaArr                      CFT007
     C                   Parm                    WFldNamArr                     CFT007
     C                   Parm                    WMsgIDArr                      CFT007
     C                   Parm                    WMsgDtaArr                     CFT007
     C                   Parm                    CsrFld           10            CFT007
     C                   Parm                    OkCre1                         CFT007
     C                   Parm                    OKHdr                          CFT007
      *                                                                         CFT007
     C                   If        @BIC = 'H'                                   CFT007
     C                   Eval      @Scrn = 'DH'                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      @Scrn = 'DC'                                 CFT007
     C                   Endif                                                  CFT007
      *                                                                         CFT007
     C                   ENDSR                                                  CFT007
      *****************************************************************
      /EJECT
      *****************************************************************
      * * INZSR - INITIAL PROCESSING
      *
      * CALLED FROM: - Main processing
      *
      * CALLS:       - None
      *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** OUTPUTS
 
     C                   Parm                    ME1200            1
     C                   Parm                    MsgRef            8
     C                   Parm                    MSGPRT            3            185107
     C                   Parm                    @RftId                         CFT009
     C                   Parm                    @Actn                          CFT009
 
     C                   MOVEL     MsgRef        @MsgKey
     C                   MOVE      MSGPRT        @SWIFTSQ                       185107
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTM101SIN'   DBPGM
      *
      **  Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        Dsfdy
      *
      ** Database Error
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CFT006 (MT101 and
      ** MT102 messages are acessable) is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFT006'      @Sard             6
     C     SCSARD        PARM      SCSARD        Dsfdy
      *
      ** Database Error
      *
     C                   IF        @Rtcd <> *BLANKS AND
     C                             @Rtcd <> '*NRF'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = 'CFT006'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @Rtcd = *BLANKS
     C                   MOVEL     'Y'           CFT006            1
     C                   ELSE
     C                   MOVEL     'N'           CFT006
     C                   ENDIF
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       @RtCd                                        CSC022
     C                   Parm      '*VERIFY'     @Optn                                        CSC022
     C                   Parm      'CSC022'      @Sard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        @RtCd = *BLANKS                                            CSC022
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
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTM101SIN'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 020                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
                                                                                              CRE020
      ** Check if On Line Printing of Advice is on                                            CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       @Rtcd                                        CRE020
     C                   PARM      '*VERIFY'     @Optn                                        CRE020
     C                   PARM      'CRE020'      @Sard                                        CRE020
     C     SCSARD        PARM      SCSARD        Dsfdy                                        CRE020
                                                                                              CRE020
     C                   IF        @Rtcd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error                                                                       CRE020
                                                                                              CRE020
     C                   IF        @Rtcd <> *BLANKS AND                                       CRE020
     C                             @Rtcd <> '*NRF'                                            CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 021                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EVAL      *INU7 = *ON                                                CRE020
     C                   EVAL      *INU8 = *ON                                                CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
      ****************************************************************          185107
      ***Start*program*on*Browse*Screen*else*if*FTM101SIN*is*called*by          185107
      ***ME1200,start*with*header*display*(retrieve*details*first)****          185107
      ****************************************************************          185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @Scrn = 'RH'                                 185107
     C*******************ELSE                                                   185107
     C*******************MOVEL     'BI'          @Scrn                          185107
     C*******************ENDIF                                                  185107
      *
      ** Start program on Browse Screen else if FTM101SIN is called by          CFT009
      ** another program.                                                       CFT009
      *                                                                         CFT009
     C                   IF        @RftId  <> *blanks                           CFT009
     C                   EVAL      @Scrn = 'RH'                                 CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'BI'          @Scrn                          CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Initialise fields
      *
     C                   EVAL      RetCdeOut = *BLANKS
     C                   EVAL      @PrvS = *BLANKS
     C                   EVAL      @MemF = 'Y'
     C                   EVAL      @CvtDrH  = 'SH'
     C                   EVAL      @CvtDrC  = 'SC'
     C*******************EVAL      @Rftid   = *BLANKS                           CFT009
     C                   EVAL      @TransRf = *BLANKS
     C*******************EVAL      @SwiftSq = *BLANKS                           185107
     C                   EVAL      @RftTyp  = 'RI'
     C                   EVAL      Actn     = *BLANKS
     C                   EVAL      @SwiftRf = *BLANKS
      ***If*FTM101SIN*is*called*by*ME1200,*action*code*is*insert******          185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @Actn = 'I'                                  185107
     C*******************ENDIF                                                  185107
 
     C                   EVAL      @FileLk = 'N'
      *
      ** Start program on Browse Screen else if FTM101SIN is called by          185107
      ** ME1200,start with header display (retrieve details first)              185107
      ** only if header record does not exist with the message ref from         185107
      ** ME1200, otherwise if a header record does exist with the               185107
      ** message ref, start with the credit display                             185107
      *                                                                         185107
     C                   Z-ADD     0             WWRSEQNO                                     221761
     C                   IF        ME1200 <> *blanks                            185107
                                                                                185107
     C     @MSGKEY       CHAIN     FT101HLC                           82        185107
                                                                                185107
     C                   IF        *IN82 = *ON                                  185107
     C                   EVAL      @Actn = 'I'                                  185107
     C                   Z-ADD     1             WWRSEQNO                                     221761
     C                   ELSE                                                   185107
      *                                                                                       221761
     C     @MSGSEQ       Klist                                                                221761
     C                   Kfld                    @MSGKEY                                      221761
     C                   Kfld                    WRSEQNO                                      221761
      *                                                                                       221761
      ** Look for the last record in FT101HPD with the same message reference.                221761
      ** This should be the latest RFT header for the message.                                221761
      *                                                                                       221761
     C                   MOVE      999           WRSEQNO                                      221761
     C     @MSGSEQ       SETGT     FT101HLC                                                   221761
     C                   READP     FT101HLC                               82                  221761
      *                                                                                       221761
      ** Action Code is still blank and there is a record found.                              221761
      ** If authorising indictor NOT 'Y', attach the message part to current RFT ID,          221761
      ** ELSE create a new RFTID.                                                             221761
      *                                                                                       221761
     C                   If        *IN82 = '0'                                                221761
     C                   IF        @Actn = ' '                                                221534
     C                   If        MRAUIN <> 'Y'                                              221761
     C                   EVAL      @Actn = 'C'                                  185107
     C                   EVAL      @RFTID  = MRRFTID                                          221761
     C                   MOVEL     *BLANKS       @MSGKEY                                      221761
     C                   ELSE                                                                 221761
     C                   EVAL      @Actn = 'I'                                                221761
     C     MRRSEQNO      ADD       1             WWRSEQNO                                     221761
     C                   Endif                                                                221761
     C                   ELSE                                                                 221761
     C**********         ENDIF                                                         221534 221761
     C                   EVAL      @RFTID  = MRRFTID                            185107
     C                   MOVEL     *BLANKS       @MSGKEY                        185107
     C                   Endif                                                                221761
     C                   Endif                                                                221761
     C                   ENDIF                                                  185107
                                                                                185107
     C                   EVAL      @Scrn = 'RH'                                 185107
     C                   ELSE                                                   185107
     C                   MOVEL     'BI'          @Scrn                          185107
     C                   ENDIF                                                  185107
      *
      ** Initialise function keys
      *
     C                   EVAL      @KeyP = *BLANKS
      *
      *
      ** Clear out all error processing
      *
     C                   MOVEA     @IndOff       *IN(28)
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      WIdx = 0
     C                   MOVE      *ALL'Y'       OkHdr
     C                   MOVE      *ALL'Y'       OkCre1
     C                   MOVE      *ALL'Y'       OkCre2
     C                   MOVE      *ALL'Y'       OkCre3
     C                   MOVE      *ALL'Y'       @WrnErArr
     C                   MOVE      *ALL'Y'       @WrkOkHd
      *
      *  Hook to enable non-core initial processing to be included
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @IndOff
000000000000000000000000000000
