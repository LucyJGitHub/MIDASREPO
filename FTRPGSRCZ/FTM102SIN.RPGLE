     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT controlling module')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM102SIN - Funds Transfer Customer Credit Transfer          *
      *              Controlling Module                               *
      *                                                               *
      *  Function:  This is the main screen input function for        *
      *             the control of all modules that are required for  *
      *             the insertion, maintenance and display of customer*
      *             credit transfer details.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034397           Date 13May15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221534             Date 13Apr04               *
      *                 212229             Date 13Apr04               *
      *                 221538             Date 13Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01               *
      *                 CFT009             Date 15Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178186             Date 26Apr00               *
      *                 177674             Date 20Apr00               *
      *                 CFT007             Date 21Mar00               *
      *                 CFT006  *CREATE    Date 10Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034397 - Error messages are not reset when shifting from   *
      *             Incoming to Outgoing transfer                     *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221534 - Not possible to enquire MT102s in VFTM.             *
      *  212229 - Every amendment on the transaction produces Unnece- *
      *           ssary Dr/Cr postings. Shadow posting for amendment  *
      *           should only be created when there's a change in     *
      *           account/amount/date.                                *
      *  221538 - Expansion of field details.                         *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  188649 - Show authorised text on screen                      *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  185107 - Mapping of details from swift message               *
      *  184060 - No transaction type code in detail screen -Recompile*
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
      *     82    - Chain FT102HLB                                    *         185107
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
      *     SRBRWI - Calls initial browse module                      *
      *     SRBRWC - Calls credit details browse module               *
      *     SRRTVH - Calls module to retrieve header details          *
      *     SRRTVC - Calls module to retrieve credit details          *
      *     SRCVTH - Calls module to convert PF header details to     *
      *              screen fields                                    *
      *     SRCVTC - Calls module to convert PF credit details to     *
      *              screen fields                                    *
      *     SRDSPH - Calls module to display header screen            *
      *     SRDSPC - Calls module to display credit screen            *
      *     SRVALH - Calls module which validates header screen input *
      *     SRUPDF - Calls module which updates files                 *
      *                                                               *
      *****************************************************************
     FFT102DL0  IF   E           K DISK    Prefix(CR)
     FFT102HLB  IF   E           K DISK    Prefix(MR)                           185107

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
     D HdrRcdIn      E DS                  EXTNAME(FT102HPD) PREFIX(HD)
      *
      ** Current Incoming Debit Details
     D DtlRcdIn      E DS                  EXTNAME(FT102DPD) PREFIX(CR)
      *
      ** Current Incoming Debit Details
     D Ft102hs       E DS                  EXTNAME(FT102HSPD) PREFIX(SH)
      *
      ** Current Incoming Debit Details
     D Ft102cs       E DS                  EXTNAME(FT102DSPD)
      *
      ** Ok CCT Header browse
     D OKCctHdB      E DS                  EXTNAME(FTE102HBPD) PREFIX(HB)
      *
      ** Ok CCT Header browse
     D OKCctDtB      E DS                  EXTNAME(FTE102BPD) PREFIX(CB)
      *
      ** Ok CCT Header Details
     D OKFlag1       E DS                  EXTNAME(FTE102H1PD) PREFIX(OA)
     D OKFlag2       E DS                  EXTNAME(FTE102H2PD) PREFIX(OB)

      ** Ok CCT Credit Details
     D OKCre1        E DS                  EXTNAME(FTE102S1PD) PREFIX(OC)
     D OkCre2        E DS                  EXTNAME(FTE102S2PD)

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
     D NHdrRcdIn     E DS                  EXTNAME(FT102HPD) PREFIX(NH)                       212229
      *                                                                                       212229
      ** Current Incoming Debit Details                                                       212229
     D NDtlRcdIn     E DS                  EXTNAME(FT102DPD) PREFIX(ND)                       212229
      *                                                                                       212229
      ** Previous Incoming Debit Header Details                                               212229
     D PHdrRcdIn     E DS                  EXTNAME(FT102HPD) PREFIX(PH)                       212229
      *                                                                                       212229
      ** Previous Incoming Debit Details                                                      212229
     D PDtlRcdIn     E DS                  EXTNAME(FT102DPD) PREFIX(PD)                       212229
      *                                                                                       212229

      ** INDEXS
      ** ------
      ** Index of error message Id arrays
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D IdxErr          S                   LIKE(Idx)
     D IdxErr1         S                   LIKE(Idx)
     D IdxErr2         S                   LIKE(Idx)
     D IdxWrn1         S                   LIKE(WIdx)
     D IdxWrn2         S                   LIKE(WIdx)

      ** Number of Fields on the screen
     D NBHdrFld        C                   Const(25)
     D NBCr1Fld        C                   Const(27)
     D NBCr2Fld        C                   Const(18)

      ** Index for arrays of msg ref and part                                   185660
     D MX              S              2  0                                      185660
                                                                                185660
      ** ARRAYS
      ** ------

      ** Errors coming from the validation
     D FldNmArr1       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr1       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr1       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D FldNmArr2       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr2       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr2       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)

      ** Warnings coming from the validation
     D WFldNmArr1      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr1      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr1      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
     D WFldNmArr2      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr2      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr2      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)

      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
      ** Array for turning indicator off
     D @IndOff         S              1    DIM(30) CTDATA PERRCD(30)
      *
      ** Warning error test for redisplay of fields
     D @WrnErArr       S              1    DIM(NBHdrFld)
     D @WrnCr1         S              1    DIM(NBCr1Fld)
     D @WrnCr2         S              1    DIM(NBCr2Fld)
      *
     D @WrkOkHd        S              1    DIM(NBHdrFld)
     D @WrkOkCr1       S              1    DIM(NBCr1Fld)
     D @WrkOkCr2       S              1    DIM(NBCr2Fld)

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

      ** Other parameters passed to modules
     D WrnToDsp        S              1A
     D RetCdeOut       S             10A
     D @Cctid          S             15A
     D @TransRf        S             16A
     D @SwiftRf        S             28A
     D @SwiftSq        S              2A
     D @CctTyp         S              2A
     D @MsgKey         S                   LIKE(PHMSGR)
     D @MsgPart        S                   LIKE(PHPART)
     D @Act            S              7A
     D @InitCVAL       S              1A
     D @InitHVAL       S              1A
     D @Rtn            S              7A
     D @HdrActn        S              1A
     D @FilRef         S             16A
     D @CallingPg      S             10A
     D @Network        S                   Like(PNWRK)

      ** Old CCT ID (used for reassign in credit display screen)
     D OldCctID        S                   Like(PCCTID)

      ** Old Transaction reference
     D OldTransID      S                   Like(PTRNSID)
                                                                                CFT007
     D @BIC            S              1                                         CFT007
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** AOSARD parameters                                                                    CSC022
     D PSard           S              6A                                                      CSC022

      ** CRE020 Parameters for QCMDEXC                                                        CRE020
     D SBMAdvice       S            150A   INZ('SBMJOB JOB(REC000881) +                       CRE020
     D                                       JOBD(MBATCH) USER(*JOBD) +                       CRE020
     D                                       RTGDTA(*JOBD) RQSDTA(+                           CRE020
     D                                       ''CALL REC000881 +                               CRE020
     D                                       (FTM102UPD FT)'') INLLIBL+                       CRE020
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

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** DO WHILE screen

     C                   Dow       @KeyP <> '03'

     C                   Select
      *
      ** First call will be to intial browse screen
      *
     C                   When      @Scrn = 'BI'
     C                   Exsr      SrBrwI
      *
      ** If option is taken the the credit browse screen will be taken
      *
     C                   When      @Scrn = 'BC'
     C                   Exsr      SrBrwC
      *
      ** On return from browse module, a CCT debit record will be
      ** retrieved (and action code validated) if it is required
      *
     C                   When      @Scrn = 'RH'
     C                   Exsr      SrRtvH
      *
      ** On return from module, a CCT Credit record will be retieved
      *
     C                   When      @Scrn = 'RC'
     C                   Exsr      SrRtvC
      *
      ** Once data has been retrieved it will be converted to
      ** to header screen fields (or back to file fields for update)
      *
     C                   When      @Scrn = 'CH'
     C                   Exsr      SrCvtH
      *
      ** Once data has been retrieved it will be converted to
      ** to detail screen fields (or in reverse for update)
      *
     C                   When      @Scrn = 'CC'
     C                   Exsr      SRCvtC
      *
      ** The general header details be displayed depending upon data
      ** input in browse
      *
     C                   When      @Scrn = 'DH'
     C                   Exsr      SrDspH
      *
      ** The credit screen will be displayed if relevant to action taken
      *
     C                   When      @Scrn = 'DC'
     C                   Exsr      SrDspC
      *
      ** Do Header Screen Validation
      *
     C                   When      @Scrn = 'VH'
     C                   Exsr      SrValH
      *
      ** Do Detail Screen Validation
      *
     C                   When      @Scrn = 'VC'
     C                   Exsr      SrValC
      *
      ** Do File updates
      *
     C                   When      @Scrn = 'UF'
     C                   Exsr      SrUpdF
      *                                                                         CFT007
      ** BIC Database + (Header)                                                CFT007
      *                                                                         CFT007
     C                   WHEN      @Scrn = 'BH'                                 CFT007
     C                   EXSR      BICHDR                                       CFT007
      *
      ** Leave loop and end program if F3 pressed
      *
     C                   When      @Scrn = 'TP'
     C                   Leave
      *
     C                   Endsl
      *
     C                   Enddo
      *
      ** End program
      *
     C                   Exsr      ENDPGM
                                                                                              CRE020
     C                   IF        *INU7 = *OFF AND *INU8 = *OFF                              CRE020
     C                              AND CRE020 = 'Y'                                          CRE020
     C                   CALL      'QCMDEXC'                                                  CRE020
     C                   PARM                    SBMAdvice                                    CRE020
     C                   PARM                    SBMAdvLngth                                  CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   Eval      *INLR = *ON

      *****************************************************************
      *
      * Hook to enable non-core subroutines to be included
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBrwI - Browse Screen to display current incoming CCT details
      *
      * Called From:  Main processing
      *
      * Calls:        FTM1021BW
      *
      *****************************************************************
     C     SrBrwI        Begsr
      *
     C                   Eval      @KeyP = *Blanks

      ** Call module FTM1021BW to build and process subfile list

     C                   CallB     'FTM1021BW'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn
     C                   Parm                    @Cctid
     C                   Parm                    @TransRf
     C                   Parm                    @SwiftRf
     C                   Parm                    @KeyP
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef

      ** If error set on external switches
     C                   Select
     C                   When      RetCdeOut <> *Blanks
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1021BW'
     C                   Eval      DBase = 2
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR

      ** If Exit (CF/3) taken in browse, or error message
      ** End program
     C                   When      @KeyP = '03' OR @KeyP = '12'
     C                   Eval      @Scrn = 'TP'
     C                   Other


      ** If data has been entered and it is correct determine
      ** which module to call next

     C                   Eval      @Scrn = 'RH'
     C                   EVAL      @HdrActn = @Actn
     C                   Endsl

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBrwC - Browse Screen to display current incoming CCT Credit
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrBrwC        Begsr

      ** Call module FTM1022BW to build and process subfile list

     C                   CallB     'FTM1022BW'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Cctid
     C                   PARM                    @HdrActn
     C                   Parm      *Blanks       @TransRf
     C                   Parm      *Blanks       @SwiftRf
     C                   Parm      *Blanks       @SwiftSq
     C                   Parm                    @Actn
     C                   Parm      *Blanks       @KeyP
      ** Errors produced during retrieve operation
     C                   Parm                    OkCctDtB
     C                   Parm                    Idx
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr

      ** If error set on external switches
     C                   Select
     C                   When      RetCdeOut <> *BLANKS
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1022BW'
     C                   Eval      DBase = 3
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR

      ** If Exit (CF/3) taken in browse, end program
     C                   When      @KeyP = '03'
     C                   Eval      @Scrn = 'TP'

      ** If Exit (CF/12) taken in browse, redisplay previous screen
     C                   When      @KeyP = '12'
     C                   If        @PrvS = 'HDSP'
     C                   Eval      @Scrn = 'DH'

      ** Redisplay screen with previous action code
     C                   Eval      @Actn = ACTN
     C                   Else

     C                   Eval      @Scrn = 'BI'
     C                   Endif

      ** If Exit (CF/05) taken in browse
     C                   When      @KeyP = '05'
     C                   Eval      @Scrn = 'BC'

      ** If data has been entered and it is correct then retrieve
      ** credit details for display
      ** If Exit (CF/09) taken in browse
     C                   When      @KeyP = '09'
     C                   Eval      @Scrn = 'RC'

      ** If enter pressed
     C                   When      @KeyP = *BLANKS
     C                   CLEAR                   MREFARR                        185660
     C                   CLEAR                   MPRTARR                        185660
     C                   Z-ADD     1             MX                             185660
     C                   Eval      @Scrn = 'RC'
     C                   Endsl

     C                   Eval      @PrvS = 'CBRW'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRtvH - Calls module which retrieves a CCT debit from
      *          database if required
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrRtvH        Begsr

     C                   Eval      @KeyP = *Blanks

      ** Retieve CCT debit details and validate action code
     C                   CallB     'FTM1021RV'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef
     C                   Parm                    @Cctid
     C                   Parm                    @SwiftRf
     C                   Parm                    @MsgKey
     C                   Parm                    HdrRcdIn
     C                   Parm                    @KeyP
     C                   Parm                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    MREFARR                        185660
     C                   PARM                    MPRTARR                        185660

     C                   Parm                    OkCctHdB
     C                   Parm      *ZEROS        Idx
     C                   Parm      *Blanks       FldNameArr
     C                   Parm      *Blanks       MsgIdArr
     C                   Parm      *Blanks       MsgDtaArr
      *                                                                                       212229
      ** Store original values of the transaction                                             212229
      *                                                                                       212229
     C                   EVAL      PHdrRcdIn = HdrRcdIn                                       212229

      ** If no errors in Retrieve then set up convert data module
     C                   Select
     C                   When      RetCdeOut = '*ERROR'
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1021RV'
     C                   Eval      DBase = 4
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR

     C                   When      RetCdeOut <> *Blanks or
     C                             Idx <> *ZEROS

      ** If FTM102SIN is called by ME1200,go back to ME1200 if there is
      ** an error else,
      ** Redisplay browse screen with error of swift displayed
     C                   IF        ME1200 = *blanks
     C                   Eval      @Scrn = 'BI'
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF

     C                   When      @KeyP = '03'
     C                   Eval      @Scrn = 'TP'

     C                   When      @KeyP = '12'
     C                   Eval      @Scrn = 'BI'

      ** Call convert header module, converting to SCREEN fields
     C                   Other
     C                   Eval      @CvtDrH = 'SH'
     C                   Eval      @Scrn = 'CH'

     C                   Endsl

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrCvtH - Calls module which converts data from database file
      *          to screen fields
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrCvtH        Begsr

      ** Convert CCT debit details
      ** Mapping fields from physical file to screen

      ** If Data have been picked up from a SWIFT message, that
      ** means Pdata is not blank. In this case message contents
      ** have been already converted to a screen format.
      ** We are not interested in Pdata anymore, we use the values
      ** of the screen.
     C                   If        @CvtDrH = 'FH'
     C                   If        Pdata <> *Blank
     C                   Eval      Pdata = *Blanks
     C                   Endif
      *                                                                                       CSW209
     C                   IF        PDAT2 <> *BLANK                                            CSW209
     C                   EVAL      PDAT2 = *BLANKS                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   Endif

     C                   CallB     'FTM1021CT'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   PARM                    @Actn                                        221538
     C                   Parm                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   Parm                    @MsgKey                        185107
     C                   Parm                    @CvtDrH
     C                   Parm                    HdrRcdIn
     C                   Parm                    Ft102hs

      ** Check for database error
     C                   If        RetCdeOut <> *BLANKS
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1021CT'
     C                   Eval      DBase = 6
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif

      ** Check for direction to determine module to call
     C                   If        @CvtDrH = 'FH'

     C                   If        @Actn = 'R'
     C                   Eval      @Scrn = 'CC'
     C                   Else
     C                   Eval      @Scrn = 'UF'
     C                   Endif

     C                   Else
     C                   Exsr      SrInput
     C                   Endif

     C                   CallB     'FTVDSPSTS'                                  188649
     C                   Parm                    HDAUP1                         188649
     C                   Parm                    HDAUP2                         188649
     C                   Parm                    HDAUIN                         188649
     C                   Parm      *Blanks       HDAIND           20            188649

      ** Ensures only goes to update after correctly validating fields
     C                   Eval      @CvtDrH = 'SH'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrInput - If header section of browse entered correctly then
      *           S/R will decide which further modules to call
      *
      * Called From:  SrCvtH
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrInput       Begsr

      ** Depending on data input on browse screen determine the next
      ** module to be chosen
     C                   Eval      Actn = @Actn
     C                   Eval      @PrvS = 'HBRW'
     C                   Eval      @MemF = 'Y'

     C                   If        Actn = 'I'
     C                   Select

      ** Leads to display of blank credit screen
     C                   When      @Cctid <> *Blanks
     C                   Eval      @Scrn = 'RC'

      ** Leads to display of blank header screen
     C                   When      @Cctid = *Blanks and @SwiftRf = *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   When      @SwiftRf <> *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   Endsl
     C                   Endif

     C                   If        Actn = 'A'
     C                   Select
     C                   When      @Cctid <> *Blanks and
     C                             @TransRf <> *Blanks
     C                   Eval      @Scrn = 'RC'
     C                   When      @Cctid <> *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   Endsl
     C                   Endif

     C                   If        Actn = 'E'
     C                   Select
     C                   When      @Cctid <> *Blanks and
     C                             @TransRf <> *Blanks
     C                   Eval      @Scrn = 'RC'
     C                   When      @Cctid <> *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   Endsl
     C                   Endif

     C                   If        Actn = 'D'
     C                   Select
     C                   When      @Cctid <> *Blanks and
     C                             @TransRf <> *Blanks
     C                   Eval      @Scrn = 'RC'
     C                   When      @Cctid <> *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   Endsl
     C                   Endif

     C                   If        Actn = 'X'
     C                   If        @Cctid <> *Blanks
     C                   Eval      @Scrn = 'DH'
     C                   Endif
     C                   Endif

     C                   If        Actn = 'C'
     C                   If        @Cctid <> *Blanks

      *                                                                         185107
      ** If program is called from ME1200, go straight to the credit            185107
      ** detail screen, otherwise go to the credit browse screen                185107
      *                                                                         185107
     C                   IF        ME1200 = *BLANKS                             185107
     C                   Eval      @Scrn = 'BC'
     C                   ELSE                                                   185107
     C                   EVAL      @SCRN = 'RC'                                 185107
     C                   EVAL      @ACTN = 'I'                                  185107
     C                   MOVEL     MSGREF        @MSGKEY                        185107
     C                   ENDIF                                                  185107

     C                   Endif
     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRtvC - Calls module which retrieves a CCT Credit from
      *          database if required
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrRtvC        Begsr

      ** Retieve CCT debit details and validate action code
     C                   CallB     'FTM1022RV'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn
     C                   Parm                    @Cctid
     C                   Parm                    @TransRf
     C                   Parm                    @SwiftRf
     C                   Parm                    @SwiftSq
     C                   Parm                    @MsgKey

     C                   Parm                    DtlRcdIn
     C                   Parm                    @KeyP
     C                   Parm                    Phead
     C                   Parm                    Pdata
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM                    MREFARR                        185660
     C                   PARM                    MPRTARR                        185660
     C                   Parm                    OkCctDtB
     C                   Parm      *ZEROS        Idx
     C                   Parm      *Blanks       FldNameArr
     C                   Parm      *Blanks       MsgIdArr
     C                   Parm      *Blanks       MsgDtaArr
      *                                                                                       212229
      ** Store original values of the transaction                                             212229
      *                                                                                       212229
     C                   EVAL      PDtlRcdIn = DtlRcdIn                                       212229

      ** If no errors in Retrieve then set up convert data module
     C                   Select

     C                   When      RetCdeOut = '*ERROR'
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1022RV'
     C                   Eval      DBase = 13
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR

     C                   When      RetCdeOut <> *Blanks or
     C                             Idx <> *ZEROS

      ** If FTM102SIN is called by ME1200,go back to ME1200 if there is         185107
      ** an error else,                                                         185107
      ** Redisplay brw screen with errror of swift displayed
     C                   IF        ME1200 = *blanks                             185107
     C                   Eval      @Scrn = 'BC'
     C                   ELSE                                                   185107
     C                   EVAL      @Scrn = 'TP'                                 185107
     C                   ENDIF                                                  185107

     C                   When      @KeyP = '03'
     C                   Eval      @Scrn = 'TP'

     C                   When      @KeyP = '12'
     C                   Eval      @Scrn = 'BC'

      ** Call convert detail module, converting to SCREEN fields
     C                   Other
     C                   Eval      @CvtDrC = 'SC'
     C                   Eval      @Scrn = 'CC'

     C                   Endsl

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrCvtC - Calls module which converts data from database file
      *          to screen fields
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrCvtC        Begsr

      ** Convert CCT debit details
      ** Mapping fields from physical file to screen

      ** If Data have been picked up from a SWIFT message, that
      ** means Pdata is not blank. In this case message contents
      ** have been already converted to a screen format.
      ** We are not interested in Pdata anymore, we use the values
      ** of the screen.
     C                   If        @CvtDrC = 'FC'
     C                   If        Pdata <> *Blank
     C                   Clear                   Phead
     C                   Eval      Pdata = *Blanks
     C                   Endif
      *                                                                                       CSW209
     C                   IF        PDAT2 <> *BLANK                                            CSW209
     C                   CLEAR                   PHEAD                                        CSW209
     C                   EVAL      PDAT2 = *BLANKS                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   Endif

     C                   CallB     'FTM1022CT'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   PARM                    @Actn                                        221538
     C                   Parm                    Phead
     C                   Parm                    Pdata
     C                   Parm                    PDAT2                                        CSW209
     C                   Parm                    @CvtDrC
     C                   PARM                    @CCttyp           2
     C                   PARM                    @FilRef          16
     C                   Parm                    DtlRcdIn

     C                   Parm                    Ft102cs

      ** If no errors call display credit module
     C                   If        RetCdeOut <> *Blanks
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1022CT'
     C                   Eval      DBase = 7
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Else

      ** Check for direction of conversion to call next module
     C                   If        @CvtDrC = 'FC'
     C                   Eval      @Scrn = 'UF'
     C                   Else
     C                   Eval      @Scrn = 'DC'
     C                   Endif

     C                   Endif

      ** Change back to screen direction so that update module cannot be called
     C                   Eval      @CvtDrC = 'SC'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDspH - Calls module which displays screen for general
      *          details maintenance/insertion
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrDspH        Begsr

     C                   If        @KeyP <> '11'
     C                   Eval      @KeyP = *Blanks
     C                   Endif

      ** If previous screen is BRW then there should be no errors
      ** and Key pressed should be blanks
     C                   If        @PrvS <> 'HDSP' and
     C                             @FileLk <> 'Y'

     C                   Eval      @MemF = 'Y'

     C                   MoveA     @IndOff       *IN(28)
     C                   Move      *ALL'Y'       OkFlag1
     C                   Move      *ALL'Y'       OkFlag2
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
     C                   Clear                   FldNmArr1                                  MD034397
     C                   Clear                   MsgIdArr1                                  MD034397
     C                   Clear                   MsgDtArr1                                  MD034397
     C                   Clear                   FldNmArr2                                  MD034397
     C                   Clear                   MsgIdArr2                                  MD034397
     C                   Clear                   MsgDtArr2                                  MD034397
     C                   Eval      Idx = 0
     C                   Clear                   WFldNamArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WMsgDtaArr
     C                   Clear                   WFldNmArr1                                 MD034397
     C                   Clear                   WMsgIdArr1                                 MD034397
     C                   Clear                   WMsgDtArr1                                 MD034397
     C                   Clear                   WFldNmArr2                                 MD034397
     C                   Clear                   WMsgIdArr2                                 MD034397
     C                   Clear                   WMsgDtArr2                                 MD034397
     C                   Eval      WIdx = 0
     C                   Movel     'Y'           @InitHVAL
     C                   Endif

      ** Display general details screen
     C                   CallB     'FTM1024DP'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef
     C                   Parm                    Ft102hs
     C                   Parm                    OKFlag1
     C                   Parm                    OKFlag2
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIdArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIdArr2
     C                   Parm                    MsgDtArr2
      ** ERROR fields/message IDs/message data
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
      *
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2
     C                   Parm                    @KeyP
     C                   Parm                    @Curs
     C                   Parm                    CsrFld           10            CFT007
      * Status description                                                      188649
     C                   PARM                    HDAIND                         188649


      ** If there are no errors determine next module to call
     C                   If        RetCdeOut <> *Blanks
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1024DP'
     C                   Eval      DBase = 8
     C                   Eval      DBKey = '*CALL'
     C                   EVal      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif


     C                   Select

      ** If F3 pressed
     C                   When      @KeyP = '03'
     C                   Eval      @Scrn = 'TP'
      *                                                                         CFT007
      ** If F4 or F16 pressed, call BIC module.                                 CFT007
      *                                                                         CFT007
     C                   WHEN      @KeyP = '04' OR                              CFT007
     C                             @KeyP = '16'                                 CFT007
     C                   EVAL      @Scrn = 'BH'                                 CFT007
     C                   EVAL      @BIC  = 'H'                                  CFT007

      ** If F5 pressed (refresh screen back to original format)
     C                   When      @KeyP = '05'
     C                   Eval      @Scrn = 'DH'

      ** If F11 pressed : Display user details
     C                   When      @KeyP = '11'
     C                   Eval      @Scrn = 'DH'

      ** If F12 pressed, go back to ME1200 if FTM102SIN was called by
      ** this else go back to browse screen
     C                   When      @KeyP = '12' and @Curs = '01'
     C                   IF        ME1200 = *blanks
     C                   Eval      @Scrn = 'BI'
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF

      ** If F12 pressed : Screen 2, redisplay screen 1
     C                   When      @KeyP = '12' and @Curs = '02'
     C                   Eval      @Scrn = 'DH'

      ** Initialise temporary warning
     C                   Exsr      INITARR

      ** If F10 pressed
     C                   When      @KeyP = '10'

      ** This will delete both the header and detail records
     C                   If        @Actn = 'D'
     C                   Eval      @CvtDrH = 'FH'
     C                   Eval      @Scrn = 'CH'
     C                   Eval      HdrInfo = 'Y'
     C                   Eval      DtlInfo = 'N'
     C                   Endif

      ** This will allow display of all associated detail records before
      ** authorisation of both header and detail together
     C                   If        @Actn = 'X'
     C                   Eval      @Scrn = 'RC'
     C                   Endif

      ** If Enter is pressed, then validate screen  fields
     C                   When      @KeyP = *Blanks

     C                   If        @Actn = 'A' or @Actn = 'I'
     C                   Eval      @Scrn = 'VH'
     C                   Endif

     C                   If        @Actn = 'E'
     C                   If        @Curs = '01'
     C                   Eval      @Scrn = 'DH'
     C                   Endif
     C                   If        @Curs = '02'
     C                   Eval      @Scrn = 'BC'
     C                   Endif
     C                   Endif

     C                   Endsl

     C                   Eval      @PrvS = 'HDSP'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrDspC  - Calls module which displays screen for transaction
      *           detail (credit detail) maintenance
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrDspC        Begsr

      ** If previous screen is not CDSP, then should be no errors on entry
      ** and key pressed should be blank
     C                   IF        @PrvS <> 'CDSP' and
     C                             @FileLk <> 'Y'

     C                   Eval      WPrvS = @PrvS
     C                   Eval      @KeyP = *Blanks
      *
     C                   MoveA     @IndOff       *IN(28)
     C                   Move      *ALL'Y'       OkCre1
     C                   Move      *ALL'Y'       OkCre2
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
     C                   Clear                   FldNmArr1
     C                   Clear                   MsgIdArr1
     C                   Clear                   MsgDtArr1
     C                   Clear                   FldNmArr2
     C                   Clear                   MsgIdArr2
     C                   Clear                   MsgDtArr2
     C                   Eval      IdxErr1 = 0
     C                   Eval      IdxErr2 = 0
     C                   Clear                   WFldNamArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WMsgDtaArr
     C                   Clear                   WFldNmArr1
     C                   Clear                   WMsgIdArr1
     C                   Clear                   WMsgDtArr1
     C                   Clear                   WFldNmArr2
     C                   Clear                   WMsgIdArr2
     C                   Clear                   WMsgDtArr2
     C                   Eval      IdxWrn1 = 0
     C                   Eval      IdxWrn2 = 0
     C                   Movel     'Y'           @InitCVAL
     C*******************If        @Actn = 'I'                                  185660
     C*******************Eval      PCCTID = HDCCTID                             185660
     C*******************Endif                                                  185660
     C                   Endif

     C                   If        @Actn = 'I'                                  185660
     C                   Eval      PCCTID = HDCCTID                             185660
     C                   Endif                                                  185660

      ** Display Credit details Screen
     C                   CallB     'FTM1021DP'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn
     C                   Parm                    @CctTyp
     C                   Parm                    @FilRef
     C                   Parm                    Ft102cs
     C                   Parm                    OKCre1
     C                   Parm                    OkCre2
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIdArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIdArr2
     C                   Parm                    MsgDtArr2
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2
     C                   Parm                    @KeyP
     C                   Parm                    OldCctID
      ** Screen Displayed (for SIN Module)
      **                  (for VAL module)
     C                   Parm                    @CurS
     C                   Parm                    CsrFld           10            CFT007
      * Status description                                                      188649
     C                   PARM                    HDAIND                         188649

      ** If there are no errors then determine next module to call
     C                   If        RetCdeOut <> *Blanks
     C                             or *IN90                                     178186
     C                   Eval      DBFile = 'FTM1021DP'
     C                   Eval      DBase = 9
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif

     C                   Select

      ** If F3 pressed
     C                   When      @KeyP = '03'
     C                   Eval      @Scrn = 'TP'
      *                                                                         CFT007
      ** BIC Database +                                                         CFT007
      *                                                                         CFT007
     C                   WHEN      @KeyP = '04' OR                              CFT007
     C                             @KeyP = '16'                                 CFT007
     C                   EVAL      @Scrn = 'BH'                                 CFT007
     C                   Eval      @BIC = 'C'                                   CFT007

      ** If F5 pressed (refresh screen back to original format)
     C                   When      @KeyP = '05'
     C                   Eval      @Scrn = 'DC'

      ** If F11 pressed
     C                   When      @KeyP = '11'
     C                   Eval      @Scrn = 'DC'

      ** If F12 pressed
     C                   When      @KeyP = '12'
      ** F12 pressed on the first screen
     C                   If        @CurS = '01'

     C                   If        WPrvS = 'CBRW'
     C                   Eval      @Scrn = 'BC'
     C                   Else
      ** Go back to ME1200 if FTM102SIN was called by this else go back
      ** to the browse screen
     C                   IF        ME1200 = *blanks
     C                   Eval      @Scrn = 'BI'
     C                   ELSE
     C                   EVAL      @Scrn = 'TP'
     C                   ENDIF
     C                   Endif

      ** F12 pressed on other screens
     C                   Else
     C                   Eval      @Scrn = 'DC'

     C                   Endif

      ** If F10 pressed
     C                   When      @KeyP = '10'

      ** This will delete the detail record only
     C                   If        @Actn = 'D'
     C                   Eval      @CvtDrC = 'FC'
     C                   Eval      @Scrn = 'CC'
     C                   Eval      HdrInfo = 'N'
     C                   Eval      DtlInfo = 'Y'
     C                   Endif

      ** This will authorise both the header and detail record
      ** do i need to convert header / and details
     C                   If        @Actn = 'X'
     C                   Eval      @CvtDrH = 'FH'
     C                   Eval      @Scrn = 'CH'
     C                   Eval      HdrInfo = *Blanks
     C                   Eval      DtlInfo = *Blanks
     C                   Endif

     C                   If        @Actn = 'R'
     C                   Eval      @Scrn = 'VC'
     C                   Endif

      ** If Enter pressed, validate screen fields
     C                   When      @KeyP = *Blanks
     C
     C                   If        @Actn = 'E'
     C                   If        @CurS = '02'
     C                   Eval      @Scrn = 'BC'
     C                   Else
     C                   Eval      @Scrn = 'DC'
     C                   Endif
     C                   Endif

     C                   If        @Actn = 'D'
     C                   Eval      @Scrn = 'DC'
     C                   Endif

     C                   If        @Actn = 'A' or @Actn = 'I' or
     C                             @Actn = 'R' or @Actn = *Blanks
     C                   Eval      @Scrn = 'VC'
     C                   Endif

     C                   Endsl

     C                   Eval      @PrvS = 'CDSP'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrValH - Calls Validation module
      *
      * Called From:  Main processing
      *
      * Calls:        None
      *
      *****************************************************************
     C     SrValH        Begsr
      *
      ** Call header validation module
      *
     C                   CallB     'FTM1021VL'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm                    RetCdeOut
     C                   Parm                    RespMode
     C                   Parm                    @CurS
     C                   Parm                    @Actn
     C                   Parm                    @InitHVAL
     C                   Parm                    Ft102hs
     C                   Parm                    WrnToDsp
     C                   Parm                    OKFlag1
     C                   Parm                    OKFlag2
     C                   Parm                    IdxErr1
     C                   Parm                    IdxErr2
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIDArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIDArr2
     C                   Parm                    MsgDtArr2
     C                   Parm                    IdxWrn1
     C                   Parm                    IdxWrn2
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2

      ** If any invalid entries redisplay header screen with error mess
     C                   If        RetCdeOut <> *BLANKS
     C                             or *IN90                                     178186
     C                   Eval      DBFILE = 'FTM1021VL'
     C                   Eval      DBASE = 10
     C                   Eval      DBKEY = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif

      ** If any invalid entries redisplay header screen with error message
     C                   If        IdxErr1 <> 0 OR
     C                             IdxErr2 <> 0 OR
     C                             WrnToDsp = 'Y'
     C                   Eval      @Scrn = 'DH'
     C                   Goto      ENDVH
     C                   Endif

     C                   Select
     C                   When      @Actn = 'I' and @CurS = '02' or
     C                             @Actn = 'A' and @CurS = '02' or
     C                             @Actn = 'D' and  @Keyp = '10'

      ** Call convert module to change screen fields back to FILE
      ** prior to update
     C                   Eval      @CvtDrH = 'FH'
     C                   Eval      @Scrn = 'CH'
     C                   Eval      HdrInfo  = 'Y'
     C                   Eval      DtlInfo  = 'N'

      ***If*FTM102SIN*was*called*by*ME1200,*set*message*ref.*to*0,*so           185107
      ***the*credit*retrieve*will*not*retrieve*anything**************           185107
      ***************************************************************           185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @MsgKey = 0                                  185107
     c*******************ENDIF                                                  185107

     C                   Other

     C                   Eval      @Scrn = 'DH'

     C                   Endsl

     C     ENDVH         TAG

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrValC - Determines which validation module to be called
      *
      * Called From:  Main processing
      *
      * Calls: FTM1022VL
      *
      *****************************************************************
      *
     C     SrValC        Begsr

     C     @ACTN         IFEQ      'I'                                                        212229
     C                   MOVE      *BLANKS       SHPCCTID                                     212229
     C                   MOVE      *BLANKS       SHPFILREF                                    212229
     C                   MOVEL     HDCCTID       SHPCCTID                                     212229
     C                   MOVEL     HDFILREF      SHPFILREF                                    212229
     C                   ENDIF                                                                212229
     C                   CallB     'FTM1022VL'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    @CurS
     C                   Parm                    @Actn
     C                   Parm                    @InitCVAL
     C                   Parm                    Ft102hs
     C                   Parm                    Ft102cs
     C                   Parm                    WrnToDsp
     C                   Parm                    OkCre1
     C                   Parm                    OkCre2
     C                   Parm                    OkFlag1
     C                   Parm                    OkFlag2
     C                   Parm                    IdxErr1
     C                   Parm                    IdxErr2
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIdArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIdArr2
     C                   Parm                    MsgDtArr2
     C                   Parm                    IdxWrn1
     C                   Parm                    IdxWrn2
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2
                                                                                178186
     C                   If        RetCodeIn <> *BLANKS                         178186
     C                             or *IN90                                     178186
     C                   Eval      DBFILE = 'FTM1022VL'                         178186
     C                   Eval      DBASE = 14                                   178186
     C                   Eval      DBKEY = '*CALL'                              178186
     C                   Eval      *INU7 = *ON                                  178186
     C                   Eval      *INU8 = *ON                                  178186
     C                   Exsr      *PSSR                                        178186
     C                   Endif                                                  178186

      ** If any invalid entries redisplay credit screen with error message
     C                   If        IdxErr1 <> 0 OR
     C                             IdxErr2 <> 0 OR
     C                             WrnToDsp = 'Y'

     C                   Eval      @Scrn = 'DC'
     C                   Goto      ENDVC
     C                   Endif

     C                   Select
     C                   When      @Actn = 'I' and @CurS = '02' or
     C                             @Actn = 'A' and @CurS = '02' or
     C                             @Actn = 'D' and @KeyP = '10'
      *
      ** Call convert module to change screen fields back to FILE
      ** prior to update
     C                   Eval      @CvtDrC = 'FC'
     C                   Eval      @Scrn = 'CC'
     C                   Eval      HdrInfo  = 'N'
     C                   Eval      DtlInfo  = 'Y'


     C                   When      @Actn = 'R' and
     C                             @KeyP = '10'

      ** Call convert module to change screen fields back to FILE
      ** prior to update
     C                   Eval      @CvtDrH = 'FH'
     C                   Eval      @CvtDrC = 'FC'
     C                   Eval      @Scrn = 'CH'
     C                   Eval      HdrInfo  = 'N'
     C                   Eval      DtlInfo  = 'Y'
     C                   Eval      OldCctId = HDCctId
     C                   Eval      OldTransId = CRTrnsId

     C                   Other

     C                   Eval      @Scrn = 'DC'

     C                   Endsl

     C     ENDVC         TAG
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpdF - UPDATES Files
      *
      * Called From: Main processing
      *
      * Calls:       None
      *
      *****************************************************************
     C     SrUpdF        Begsr
      *                                                                         177674
      ** WARNING :                                                              177674
      ** Straight Trough Processing (STP) will follow the update process        177674
      ** therefore, each time a change is done here (a new module, a new        177674
      ** condition) it has to be reported in FT0300                             177674
      *                                                                         177674

      ** Initialise temporary warning fields when going to update
     C                   Exsr      INITARR

      ** Initialise file lock field
     C                   Eval      @FileLK = 'N'

     C                   EVAL      NHdrRcdIn = HdrRcdIn                                       212229
     C                   EVAL      NDtlRcdIn = DtlRcdIn                                       212229
     C     HdrInfo       IFEQ      'Y'                                                        212229
     C                   Z-ADD     0             PDPAYAMT                                     212229
     C                   Z-ADD     0             NDPAYAMT                                     212229
     C                   ENDIF                                                                212229
     C                   MOVE      'N'           HdrDlt            1                          212229
     C     HdrInfo       IFEQ      'Y'                                                        212229
     C     @ACTN         ANDEQ     'D'                                                        212229
     C                   MOVE      'Y'           HdrDlt                                       212229
     C                   ENDIF                                                                212229
      * Remove all forward positions.
     C                   CallB     'FTM102UPP'                          90      178186
     C                   Parm                    RetCodeIn
     C                   Parm                    @Actn
     C                   Parm      'R'           AddRemove         1
     C                   Parm                    HDCctid
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HdrDlt                                       212229
      *                                                                          178186
     C                   If        RetCodeIn <> *BLANK                           178186
     C                             Or *IN90                                      178186
     C                   Eval      DBFILE = 'FTM102UPP'                          178186
     C                   Eval      DBASE = 015                                   178186
     C                   Eval      DBKEY = AddRemove                             178186
     C                   Eval      *INU7 = *ON                                   178186
     C                   Eval      *INU8 = *ON                                   178186
     C                   Exsr      *PSSR                                         178186
     C                   Endif                                                   178186

      ** Call module to update CCT files
     C                   CallB     'FTM102UPD'                          90      178186
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCdeOut
     C                   Parm                    @Actn             1
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   Parm                    HdrInfo           1
     C                   Parm                    DtlInfo           1
     C                   Parm                    OldCctID
     C                   Parm                    OldTransID
     C                   Parm      PSJobName     @CallingPg
     C                   Parm      PNWRK         @Network
      ** Errors produced during I/O operation
     C                   Parm                    IdxErr
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
      *
     C                   If        RetCdeOut <> *BLANKS
     C                             OR *In90                                     178186
     C                   Eval      DBFile = 'FTM102UPD'
     C                   Eval      DBase = 11
     C                   Eval      DBKey = '*CALL'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Else

      ** Check that file can be updated (i.e no lock in files) if not
      ** then redisplay screen with error
     C                   If        IdxErr <> 0
     C                   If        @PrvS = 'HDSP'
     C                   Eval      @Scrn = 'DH'
     C                   Eval      @FileLK = 'Y'
     C                   Endif
     C                   If        @PrvS = 'CDSP'
     C                   Eval      @Scrn = 'DC'
     C                   Eval      @FileLK = 'Y'
     C                   Endif
     C                   Else

      *
      ** Create totals
      *
      ** If Action is 'I' and the CCTID has just been created in the UPDATE
      ** module then need to move the new CCTID from FT102HPD and FT102DPD
      ** to the working files FT102HSPD and FT102DSPD
      *
     C                   IF        Actn = 'I' AND SHPCctid = *Blanks AND
     C                             PCctid = *Blanks
     C                   EVAL      SHPCCTid = HDCctid
     C                   EVAL      PCCTid = HDCctid
     C                   ENDIF
      *
     C                   CALLB     'FTVHDAM01'                          90      178186
     C                   PARM                    RetCodeIn
     C                   PARM                    Ft102hs
      *                                                                         178186
      ** If errors                                                              178186
      *                                                                         178186
     C                   If        RetCodeIn <> *BLANK                          178186
     C                             Or *IN90                                     178186
     C                   Eval      DBFILE = 'FT102SUMS'                         178186
     C                   Eval      DBASE = 017                                  178186
     C                   Eval      DBKEY = *BLANK                               178186
     C                   Eval      *INU7 = *ON                                  178186
     C                   Eval      *INU8 = *ON                                  178186
     C                   Exsr      *PSSR                                        178186
     C                   Endif                                                  178186
      *
      ** Depending on previous screen and action display next screen
      ** Move to the next relevant screen
     C                   If        @Actn = 'A' or
     C                             @Actn = 'R'
     C                   Eval      @Scrn = 'BC'
     C                   Endif

     C                   If        @Actn = 'I' or @Actn = *Blanks
      ** Message created through SWIFT message go to browse credit
      ** only if program was not called from ME1200.                            185107
      ** If pgm was called from ME1200, return back to ME1200                   185107
      *                                                                         185107
     C                   If        DtlInfo = 'Y'
     C                   If        CRCCTMSG <> 0 AND CRCCTMSQ <> 0

     C                   IF        ME1200 = *BLANKS                             185107
      ** Check if msg ref and part array are filled, if so move msg ref         185660
      ** and part to FTM1022RV parameters and goto call FTM1022RV               185660
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
     C                   Eval      @Scrn = 'BC'
     C                   ENDIF                                                  185660

     C                   ELSE                                                   185107
     C                   EVAL      @SCRN = 'TP'                                 185107
     C                   ENDIF                                                  185107

     C                   Else
     C                   Eval      @Scrn = 'RC'
     C                   Endif
     C                   Else
                                                                                185660
      ** Check if msg ref and part array are filled, if so move msg ref         185660
      ** and part to FTM1022RV parameters                                       185660
                                                                                185660
     C                   Z-ADD     1             MX                             185660
                                                                                185660
     C                   IF        MREFARR(MX) <> *BLANKS                       185660
     C                   MOVE      MREFARR(MX)   @MSGKEY                        185660
     C                   MOVE      MPRTARR(MX)   @SWIFTSQ                       185660
     C                   ENDIF                                                  185660
                                                                                185660
     C                   EVAL      @CCTID = HDCCTID                             185660

     C                   Eval      @Scrn = 'RC'
     C                   Endif
     **  blanks out key pressed
???  C                   Eval      @KeyP = *Blanks

     **  Taken out this part of fix 185107 to allow sfl readc processing        185107
     **  from browse screen when routing more than one message.                 185107
     C*******************If        DtlInfo = 'Y' and ME1200 <> *BLANKS          185107
     C*******************Eval      @KeyP = '12'                                 185107
     C*******************Endif                                                  185107

     C                   Endif

     C                   If        @Actn = 'D' or @Actn = 'X'
     C                   Eval      @Scrn = 'BI'
     C                   Endif

     C                   Endif

     C                   Endif

      *
      ** No errors trapped by the update module                                  178186
     C                   If        IdxErr = 0                                    178186
     C                   EVAL      NHdrRcdIn = HdrRcdIn                                       212229
     C                   EVAL      NDtlRcdIn = DtlRcdIn                                       212229
     C     HdrInfo       IFEQ      'Y'                                                        212229
     C                   Z-ADD     0             PDPAYAMT                                     212229
     C                   Z-ADD     0             NDPAYAMT                                     212229
     C                   ENDIF                                                                212229
     C                   MOVE      'N'           HdrDlt            1                          212229
     C     HdrInfo       IFEQ      'Y'                                                        212229
     C     @ACTN         ANDEQ     'D'                                                        212229
     C                   MOVE      'Y'           HdrDlt                                       212229
     C                   ENDIF                                                                212229
      *
      ** Update forward positions file.
      *
     C                   CallB     'FTM102UPP'                          90      178186
     C                   Parm                    RetCodeIn
     C                   Parm                    @Actn
     C                   Parm      'A'           AddRemove         1
     C                   Parm                    HDCctid
     C                   PARM                    NHdrRcdIn                                    212229
     C                   PARM                    NDtlRcdIn                                    212229
     C                   PARM                    PHdrRcdIn                                    212229
     C                   PARM                    PDtlRcdIn                                    212229
     C                   PARM                    HdrDlt                                       212229
     C                   EVAL      PHdrRcdIn = NHdrRcdIn                                      212229
     C                   EVAL      PDtlRcdIn = NDtlRcdIn                                      212229
      *                                                                          178186
      ** If errors                                                               178186
      *                                                                          178186
     C                   If        RetCodeIn <> *BLANK                           178186
     C                             Or *IN90                                      178186
     C                   Eval      DBFILE = 'FTM102UPP'                          178186
     C                   Eval      DBASE = 016                                   178186
     C                   Eval      DBKEY = AddRemove                             178186
     C                   Eval      *INU7 = *ON                                   178186
     C                   Eval      *INU8 = *ON                                   178186
     C                   Exsr      *PSSR                                         178186
     C                   Endif                                                   178186
      *                                                                          178186
     C                   Endif                                                   178186
      *                                                                          178186
      * END OF UPDATE PROCESS                                                    178186
      * ---------------------                                                    178186
      * If the modules which cause an update have terminated                     178186
      * successfully we commit all the changes                                   178186
     C                   If        IdxErr = 0  And                               178186
     C                             RetCodeIn = *BLANK And                        178186
     C                             RetCdeOut = *BLANKS                           178186
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   Commit                                                  178186
     C                   EndIf                                                                CSC022
     C                   Else                                                    178186
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   Rolbk                                                   178186
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Endif                                                   178186
      *                                                                          178186

     C                   Endsr
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
     C     INITARR       Begsr
      *
      ** Initialise temporary warning fields when going to update
      *
     C                   Move      *All'Y'       @WrnErArr
     C                   Move      *All'Y'       @WrkOkHd
     C                   Move      *All'Y'       @WrnCr1
     C                   Move      *All'Y'       @WrnCr2
     C                   Move      *All'Y'       @WrkOkCr1
     C                   Move      *All'Y'       @WrkOkCr2
      *
     C                   Endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDPGM - Terminate program
      *
      * CALLED FROM: -
      *
      * CALLS:       - None
      *
      *****************************************************************
     C     ENDPGM        Begsr
      *
      * Unlock all the messages reserved by the application
     C                   Call      'ME1070'                             90
     C                   Parm      '*END    '    @Act
     C                   Parm      0             @MsgKey
     C                   Parm      0             @MsgPart
     C                   Parm      *Blanks       @SwiftRf
     C                   Parm      *BLANKS       @SwiftRf
     C                   Parm      *BLANKS       @Rtn

     C                   If        *IN90
     C                   Eval      DBFile = 'ME1070'
     C                   Eval      DBase = 12
     C                   Eval      DBKey = '*CALL'
     C                   Exsr      *PSSR
     C                   Endif
      * Commit changes on MEINMRPD (no commit in ME1070)
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   Commit
     C                   EndIf                                                                CSC022

      ** If FTM102SIN was called by ME1200, return back a code
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
      *
     C                   Endsr
      *****************************************************************          CFT007
      /EJECT                                                                     CFT007
      *****************************************************************          CFT007
      * BICHDR.  Calls BIC modules for HEADER record                             CFT007
      *                                                                          CFT007
      * CALLED FROM: - Main processing                                           CFT007
      *                                                                          CFT007
      * CALLS:       - None                                                      CFT007
      *****************************************************************          CFT007
     C     BICHDR        BEGSR                                                   CFT007
      *                                                                          CFT007
      *                                                                          CFT007
DB+  C                   CallB     'FTM102GEN'                                   CFT007
DB+  C                   Parm                    RetCodeIn                       CFT007
DB+  C                   Parm                    RespMode                        CFT007
DB+  C                   Parm                    @Actn                           CFT007
DB+  C                   Parm                    Ft102hs                         CFT007
DB+  C                   Parm                    Ft102cs                         CFT007
DB+  C                   Parm                    @KeyP                           CFT007
DB+  C                   Parm                    FldNameArr                      CFT007
DB+  C                   Parm                    MsgIDArr                        CFT007
DB+  C                   Parm                    MsgDtaArr                       CFT007
DB+  C                   Parm                    WFldNamArr                      CFT007
DB+  C                   Parm                    WMsgIDArr                       CFT007
DB+  C                   Parm                    WMsgDtaArr                      CFT007
DB+  C                   Parm                    CsrFld           10             CFT007
DB+  C                   Parm                    OkCre1                          CFT007
DB+  C                   Parm                    OKFlag1                         CFT007
      *                                                                          CFT007
     C                   If        @BIC = 'H'                                    CFT007
     C                   Eval      @Scrn = 'DH'                                  CFT007
     C                   Else                                                    CFT007
     C                   Eval      @Scrn = 'DC'                                  CFT007
     C                   Endif                                                   CFT007
      *                                                                          CFT007
     C                   ENDSR                                                   CFT007
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *
      * Called From: Main processing
      *
      * Calls:       None
      *
      *****************************************************************
     C     *INZSR        Begsr

     C     *Entry        PLIST

      ** OUTPUTS

     C                   Parm                    ME1200            1
     C                   Parm                    MsgRef            8
     C                   Parm                    MSGPRT            3            185107
     C                   Parm                    @CCtId                         CFT009
     C                   Parm                    @Actn                          CFT009

     C                   MOVEL     MsgRef        @MsgKey
     C                   MOVE      MSGPRT        @SWIFTSQ                       185107

      ** Initialize program name
     C                   Movel     'FTM102SIN'   DBPgm

      **  Read data area - RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Access Module Details
     C                   CallB     'AOMMODR0'
     C                   Parm      *BLANKS       PRtcd             7
     C                   Parm      '*FIRST '     POptn             7
     C     SDMMOD        Parm      SDMMOD        Dsfdy
      *
      ** Database Error
     C                   If        PRtcd <> *Blanks
     C                   Eval      DBFILE = 'SDMMODPD'
     C                   Eval      DBASE = 1
     C                   Eval      DBKEY = POptn
     C                   Exsr      *PSSR
     C                   Endif
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
     C                   Eval      DBPgm  = 'FTM102SIN'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 020                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
      ****************************************************************          185107
      ***Start*program*on*Browse*Screen*else*if*FTM102SIN*is*called*by          185107
      ***ME1200,start*with*header*display*(retrieve*details*first)****          185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @Scrn = 'RH'                                 185107
     C*******************ELSE                                                   185107
     C*******************Movel     'BI'          @Scrn                          185107
     C*******************ENDIF                                                  185107
      *
      ** Start program on Browse Screen else if FTM101SIN is called by          CFT009
      ** another program.                                                       CFT009
      *                                                                         CFT009
     C                   IF        @CctId  <> *blanks                           CFT009
     C                   EVAL      @Scrn = 'RH'                                 CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'BI'          @Scrn                          CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Initialise fields
      *
     C                   Eval      RetCdeOut = *Blanks
     C                   Eval      @PrvS = *Blanks
     C                   Eval      @MemF = 'Y'
     C                   Eval      @CvtDrH  = 'SH'
     C                   Eval      @CvtDrC  = 'SC'
     C*******************Eval      @Cctid   = *Blanks                           CFT009
     C                   Eval      @TransRf = *Blanks
     C                   Eval      @SwiftRf = *Blanks
     C*******************Eval      @SwiftSq = *Blanks                           185107
     C                   Eval      @CctTyp  = 'BI'
     C                   Eval      @FilRef  = *Blanks
     C                   Eval      Actn     = *Blanks
     C                   Eval      @FileLk = 'N'
      *                                                                         185107
      ** Start program on Browse Screen else if FTM102SIN is called by          185107
      ** ME1200,start with header display (retrieve details first)              185107
      ** only if header record does not exist with the message ref from         185107
      ** ME1200, otherwise if a header record does exist with the               185107
      ** message ref, start with the credit display                             185107
      *                                                                         185107
     C                   IF        ME1200 <> *blanks                            185107
                                                                                185107
     C     @MSGKEY       CHAIN     FT102HLB                           82        185107
                                                                                185107
     C                   IF        *IN82 = *ON                                  185107
     C                   EVAL      @Actn = 'I'                                  185107
     C                   ELSE                                                   185107
     C**********         EVAL      @Actn = 'C'                                         185107 221534
     C                   EVAL      @CCTID  = MRCCTID                            185107
     C                   MOVEL     *BLANKS       @MSGKEY                        185107
     C                   ENDIF                                                  185107
                                                                                185107
     C                   EVAL      @Scrn = 'RH'                                 185107
                                                                                185107
     C                   ELSE                                                   185107
     C                   Movel     'BI'          @Scrn                          185107
     C                   ENDIF                                                  185107
      ****************************************************************          185107
      ***If*FTM102SIN*is*called*by*ME1200,*action*code*is*insert******          185107
      ****************************************************************          185107
     C*******************IF        ME1200 <> *blanks                            185107
     C*******************EVAL      @Actn = 'I'                                  185107
     C*******************ENDIF                                                  185107
      *
      ** Initialise function keys
      *
     C                   Eval      @KeyP = *Blanks
      *
      *
      ** Clear out all error processing
      *
     C                   MoveA     @IndOff       *IN(28)
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
     C                   Eval      Idx = 0
     C                   Clear                   WFldNamArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WMsgDtaArr
     C                   Eval      WIdx = 0
     C                   Move      *ALL'Y'       OkFlag1
     C                   Move      *ALL'Y'       OkFlag2
     C                   Move      *ALL'Y'       OkCre1
     C                   Move      *ALL'Y'       OkCre2
     C                   Move      *ALL'Y'       @WrnErArr
     C                   Move      *ALL'Y'       @WrkOkHd
     C                   CLEAR                   PHdrRcdIn                                    212229
     C                   CLEAR                   NHdrRcdIn                                    212229
     C                   CLEAR                   PDtlRcdIn                                    212229
     C                   CLEAR                   NDtlRcdIn                                    212229
                                                                                              CRE020
      ** Check if On Line Printing of Advice is on                                            CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtcd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSard                                        CRE020
     C     SCSARD        PARM      SCSARD        Dsfdy                                        CRE020
                                                                                              CRE020
     C                   IF        PRtcd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error                                                                       CRE020
                                                                                              CRE020
     C                   IF        PRtcd <> *BLANKS AND                                       CRE020
     C                             PRtcd <> '*NRF'                                            CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 018                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EVAL      *INU7 = *ON                                                CRE020
     C                   EVAL      *INU8 = *ON                                                CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
      *
      *  Hook to enable non-core initial processing to be included
      *
     C                   Endsr
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
(c) Finastra International Limited 2001
** @IndOff
000000000000000000000000000000
