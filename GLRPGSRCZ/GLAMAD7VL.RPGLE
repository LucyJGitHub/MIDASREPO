     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Period and Penalty Details Validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD7VL -  Period and Penalty Details Validation           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      *  Prev Amend No. AR947093A          Date 04May12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR854615           Date 19Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27631           Date 12May10               *
      *                 BUG27484           Date 21Apr10               *
      *                 BUG27488           Date 15Apr10               *
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR854615 - Contractual spread indicator is always +          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27631 - Cannot proceed with authorization but was able    *
      *             to proceed with confirm complete                  *
      *  BUG27484 - Error validation for period and penalty details   *
      *             is not working when AMAD is entered via SOAP      *
      *  BUG27488 - Commitment definition error on ACCNT              *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FREPRPNPD  IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
 
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
 
      ** The following /COPY line includes the definitions for error and
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
 
      ** The maximum size of the appended error arrays
 
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Event sequence array
 
     D ArrEvnt         S              1    DIM(26) CTDATA PERRCD(26)
      **********                                                                            BUG27488
      ***DB*override*command*                                                               BUG27488
      **********                                                                            BUG27488
     D***OVR1***         S              1    DIM(50) CTDATA PERRCD(50)                      BUG27488
 
      ** Array of Fields in error
 
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
 
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data
 
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings
 
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
 
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data
 
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE073
     D  QQLCD        E                     EXTFLD(LCD)                                        CRE073
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D TranInMast    E DS                  EXTNAME(GLAMADPD)
     D TranInDebi    E DS                  EXTNAME(GLAMDIPD)
     D TranInCred    E DS                  EXTNAME(GLAMCIPD)
     D PrevInDebi    E DS                  EXTNAME(GLAMDIPD) PREFIX(PR_)
     D PrevInCred    E DS                  EXTNAME(GLAMCIPD) PREFIX(PR_)
     D TranInPena    E DS                  EXTNAME(GLAMPPPD)
     D**ScnPenaRows           33   4166                                                       CRE073
     D  ScnPenaRows           33   5414                                                       CRE073
 
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
     D ValidPena     E DS                  EXTNAME(GLVAMPPPD)
 
     D OKFlagsDS     E DS                  EXTNAME(GLEAMPPPD)
     D**OKPenaRows             6    941                                                       CRE073
     D  OKPenaRows             6   1149                                                       CRE073
 
      ** Array for screen definition
 
     D GLAMPR        E DS                  EXTNAME(GLAMPRPD)
     D ArrScnBuf       S                   DIM(26) LIKE(GLAMPR)
     D ArrSort         S                   DIM(26) LIKE(GLAMPR)
     D GLAM2PR       E DS                  EXTNAME(GLAMPRPD) PREFIX(S2:2)
 
      ** Array for file definition
 
     D REPRPN        E DS                  EXTNAME(REPRPNPD)
     D ArrFilBuf       S                   DIM(26) LIKE(REPRPN)
 
      ** Array for screen OK flags
 
     D GLEAMPR       E DS                  EXTNAME(GLEAMPRPD)
     D ArrOkBuf        S                   DIM(26) LIKE(GLEAMPR)
 
      ** Convert ddmmyy into separate components for start/work date
 
     D DTCVT           DS
     D  WDMY                   1      6  0
     D  WDAY                   1      2  0
     D  WMTH                   3      4  0
     D  WYEAR                  5      6  0
 
      ** Convert ddmmyy into separate components for given month
 
     D DTCVT2          DS
     D  GVNDMY                 1      6  0
     D  GVNDAY                 1      2  0
     D  GVNMTH                 3      4  0
     D  GVNYER                 5      6  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
 
     D X               S              2  0
     D Y               S              2  0
     D Idx             S              3  0
     D WIdx            S              3  0
 
     D W#TotalSet      S              2  0
     D W#CEDE          S              5  0
     D W#MDAT          S              5  0
     D W#DRIS          S             11  7
     D W#CRIS          S             11  7
     D W#EVNT          S              1
     D W#VDAT          S              6
     D R#EVNT          S              1
     D TOTSET          S              2  0
     D MAINT           S              7
     D WMODE           S              7
     D CURSET          S              2  0
     D SMDATN          S              5  0
     D TRMDAT          S              6
     D PRTCD           S              7
     D POPTN           S              7
     D PCCY            S              3
     D RUNCHG          S              5
     D PRCEDE          S              5  0
     D W9DCAP          S              5  0
     D W9CCAP          S              5  0
     D CMDLEN          S             15  5
     D LASTIN          S              1                                                     BUG27484
     D C#TRMDAT        C                   CONST(26664)
     D P#CEDE          S              6                                                     BUG27631
     D P#VDAT          S              6                                                     BUG27631
     D P#MDAT          S              6                                                     BUG27631
     D P#CSET          S              2  0                                                  BUG27631
     D P#CEED          S              5  0                                                  BUG27631
     D PSARD           S              6A                                                      CRE073
     D CRE073          S              1A   INZ('N')                                           CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D NEWSRT          S             11P 7                                                    CRE073
     D #DRSpread       S             11P 7                                                    CRE073
     D #CRSpread       S             11P 7                                                    CRE073
     D #E2DCSP         S             11P 7                                                    CRE073
     D #E2CCSP         S             11P 7                                                    CRE073
     D W#DRBrt         S             11P 7                                                    CRE073
     D W#CRBrt         S             11P 7                                                    CRE073
     D Indx            S              3  0                                                    CRE073
     D NEWFRT          S             11P 7                                                  AR847249
                                                                                              CRE073
      ** Entry Parameters                                                                     CRE073
                                                                                              CRE073
     D PBaseRat        S             12A                                                      CRE073
     D PBaseCod        S              2A                                                      CRE073
     D PFixRate        S             12A                                                      CRE073
     D PContSprd       S             12A                                                      CRE073
     D PContSign       S              1A                                                      CRE073
     D PRoundMth       S              7A                                                      CRE073
     D PRFracDec       S              4A                                                      CRE073
     D PConSprd        S             11P 7                                                    CRE073
     D PModule         S              6A                                                      CRE073
     D PCurset         S              2P 0 INZ(0)                                             CRE073
     D PConSprdOK      S              1A   INZ('Y')                                           CRE073
     D PRoundMthOK     S              1A   INZ('Y')                                           CRE073
     D PFracDecOK      S              1A   INZ('Y')                                           CRE073
     D PCOnSignOK      S              1A   INZ('Y')                                           CRE073
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRInit
 
      ** Sort penalty events from input
 
     C                   EXSR      SRSort
 
      ** Load repeating fields in array
 
     C                   EXSR      SRLoadInput
 
      ** Validate input fields
 
     C                   EXSR      SRValidate
 
      ** Reload data from array to main file
 
     C                   EXSR      SRReload
 
      ** Setup affected dates in the screen display
 
     C                   IF        Idx = 0
     C                   EXSR      SRSetupHdr
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSort - Sort Penalty Events                                 *
      *                                                               *
      *****************************************************************
     C     SRSort        BEGSR
 
      ** Move screen row fields to array
 
     C                   MOVEA     ScnPenaRows   ArrSort
 
      ** Sort array in ascending order
 
     C                   SORTA     ArrSort
 
      ***Select*only*valid*events*for*processing**                                          BUG27484
      ** Select all non-blank term and notice details                                       BUG27484
 
     C                   EVAL      ArrScnBuf = *BLANKS
 
     C                   EVAL      Y = *ZERO
     C                   DO        26            X
     C**********         EVAL      W#EVNT = %SUBST(ArrSort(X):1:1)                          BUG27484
     C*****W#EVNT        LOOKUP    ArrEvnt                                50                BUG27484
     C**********         IF        %EQUAL                                                   BUG27484
     C                   IF        ArrSort(X) <> *BLANKS                                    BUG27484
     C                   EVAL      Y = Y + 1
     C                   EVAL      ArrScnBuf(Y) = ArrSort(X)
     C                   ENDIF
     C                   ENDDO
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      DDDCSP = DDADCSP                                           CRE073
     C                   EVAL      DDDCSG = DDADCSG                                           CRE073
     C                   EVAL      DDDRMT = DDADRMT                                           CRE073
     C                   EVAL      DDDRFD = DDADRFD                                           CRE073
 
     C                   EVAL      DDCCSP = DDACCSP                                           CRE073
     C                   EVAL      DDCCSG = DDACCSG                                           CRE073
     C                   EVAL      DDCRMT = DDACRMT                                           CRE073
     C                   EVAL      DDCRFD = DDACRFD                                           CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Move sorted events back to screen data structure
 
     C                   MOVEA     ArrScnBuf     ScnPenaRows
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadInput - Load Repeating Fields in Array                 *
      *                                                               *
      *****************************************************************
     C     SRLoadInput   BEGSR
 
      ** Move screen row fields to array
 
     C                   MOVEA     ScnPenaRows   ArrScnBuf
 
      ** Move screen row field OK flags to array
 
     C                   MOVEA     OKPenaRows    ArrOkBuf
 
      ** Count total set of periods passed
 
     C                   EVAL      W#TotalSet = 0
     C                   DO        26            X
     C                   IF        ArrScnBuf(X) <> *BLANKS
     C                   EVAL      W#TotalSet = W#TotalSet + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
 
      ** Initialise file format array
 
     C                   CLEAR                   REPRPN
     C                   DO        26            X
     C                   EVAL      ArrFilBuf(X) = REPRPN
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRReload - Reload Data from Work Arrays                      *
      *                                                               *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Move array to screen row fields
 
     C                   MOVEA     ArrScnBuf     ScnPenaRows
 
      ** Move array to screen row field OK flags
 
     C                   MOVEA     ArrOkBuf      OKPenaRows
 
      ** Move array to valid file
 
     C                   IF        Idx = 0
     C                   MOVEA     ArrFilBuf     ValidPena
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Perform Field Validation                        *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Setup initial values for event date calculation
 
     C                   MOVE      BJRDNB        RUNCHG
     C                   EVAL      PRCEDE = BJRDNB
     C                   IF        DDACTN = 'I'
     C                   EVAL      MAINT = '*NEW'
     C                   ELSE
     C                   EVAL      MAINT = '*EXIST'
     C                   ENDIF
 
      ** Validate fixed fields
 
     C                   EXSR      SRPeriodType
     C                   EXSR      SRAmountType
     C                   EXSR      SRNextDate
 
      ** Validate repeating fields
 
     C                   IF        W#TotalSet > 0
     C                   DO        W#TotalSet    X
 
      ** Load screen fields and ok flags
 
     C                   EVAL      GLAMPR  = ArrScnBuf(X)
     C                   EVAL      GLEAMPR = ArrOkBuf(X)
 
      ** Load adjacent period for comparison
 
     C                   IF        X < W#TotalSet
     C                   EVAL      GLAM2PR = ArrScnBuf(X+1)
     C                   ELSE
     C                   CLEAR                   GLAM2PR
     C                   ENDIF
 
      ** Replace value date with the calculated value date
 
     C                   IF        X > 1
     C                             AND W#VDAT <> *BLANKS
     C                             AND Idx = 0
     C                   EVAL      RWVDAT = W#VDAT
     C                   ENDIF
 
      ** Pass the re-sequenced event id to the validation modules but
      ** retain the original value to update the correct row.  The
      ** actual re-sequencing of events in done during file update
 
     C                   IF        RWEVNT <> 'Z'
     C                   EVAL      R#EVNT = ArrEvnt(X)
     C                   ELSE
     C                   EVAL      R#EVNT = RWEVNT
     C                   ENDIF
 
      ** Validate each field in the period
 
     C                   EXSR      SREvent                                                  BUG27484
     C                   EXSR      SRStartDate                                              BUG27484
     C                   EXSR      SREndDate
                                                                                            BUG27631
      ** Save parameters use for SREndDate                                                  BUG27631
                                                                                            BUG27631
     C                   IF        R#EVNT = 'A'                                             BUG27631
     C                   EXSR      SRSaveParm                                               BUG27631
     C                   ENDIF                                                              BUG27631
                                                                                            BUG27631
     C                   EXSR      SRNumPeriod
     C                   EXSR      SRRollFreq
     C                   EXSR      SRRollDay
 
     C                   EXSR      SRCalcBasis
     C                   EXSR      SRRateFix
     C                   EXSR      SRCapFreq
     C                   EXSR      SRBaseRate
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      PModule   = 'PENADr'                                       CRE073
     C                   MOVE      RWDCSP        PContSprd                                    CRE073
     C                   EVAL      PContSign = RWDCSG                                         CRE073
     C                   EVAL      PRoundMth = RWDRMT                                         CRE073
     C                   EVAL      PRFracDec = RWDRFD                                         CRE073
      *                                                                                       CRE073
      ** DR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRContSprd                                                 CRE073
     C                   Z-ADD     TMCNSP        PConSprd                                     CRE073
      *                                                                                       CRE073
      ** DR Rounding Method and Rounding Fractional/Decimal                                   CRE073
      *                                                                                       CRE073
     C                   IF        RWDCSPOK <> 'N'                                            CRE073
     C                   EXSR      SRRoundMth                                                 CRE073
     C                   EXSR      SRRFracDec                                                 CRE073
     C                   IF        RWDCSPOK <> 'N' AND                                        CRE073
     C                             RWDCSGOK <> 'N' AND                                        CRE073
     C                             RWDRMTOK <> 'N' AND                                        CRE073
     C                             RWDRFDOK <> 'N'                                            CRE073
      *                                                                                       CRE073
      ** DR Rate/SPread Calculation                                                           CRE073
      *                                                                                       CRE073
     C                   Z-ADD     W#DRBrt       PBaseRate        11 7                        CRE073
     C                   EXSR      SRCalcSpr                                                  CRE073
     C                   Z-ADD     NEWSRT        #DRSpread                                    CRE073
     C**********         IF        NEWFRT <= *ZEROS AND                            AR847249 AR947093
     C**********                   PRoundMth <> *BLANKS                            AR847249 AR947093
     C**********         EVAL      RWDRMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      FldNamXAr(1) = 'DPDRMT' + %CHAR(X)              AR847249 AR947093
     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(1) = %EDITC(NEWFRT:'J')               AR847249 AR947093
     C**********         EXSR      UPDATERRS                                       AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        #DRSpread = 0                                              CRE073
     C                   EVAL      RWDRIS = *BLANKS                                           CRE073
     C                   EVAL      RWSIGD = *BLANKS                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        #DRSpread < 0                                              CRE073
                                                                                            AR847249
     C                   EVAL      RWDRISOK = 'W'                                           AR847249
     C                   EVAL      WFldNmXAr(1) = 'DDPDRS' + %CHAR(X)                       AR847249
     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
     C**********         EVAL      WMsgDtXAr(1) = %EDITC(NEWSRT:'J')               AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(NEWSRT:'J')                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   EXSR      UPDATERRS                                                AR847249
                                                                                            AR847249
     C                   IF        RWDCSG = '+'                                             AR847249
     C                   EVAL      RWSIGD = '-'                                               CRE073
     C                   ELSEIF    RWDCSG = '-'                                             AR847249
     C                   EVAL      RWSIGD = '+'                                             AR847249
     C                   ENDIF                                                              AR847249
                                                                                            AR847249
     C**********         EVAL      RWSIGD = '-'                                      CRE073 AR854615
     C**********         EVAL      RWSIGD = '+'                                    AR854615 AR847249
     C                   EVAL      RWDRIS = %CHAR(%ABS(#DRSpread))                            CRE073
     C                   ELSE                                                                 CRE073
     C**********         EVAL      RWSIGD = '+'                                      CRE073 AR854615
     C                   EVAL      RWSIGD = RWDCSG                                          AR854615
     C                   EVAL      RWDRIS = %CHAR(#DRSpread)                                  CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR847249 AR947093
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   EVAL      PModule   = 'PENACr'                                       CRE073
     C                   MOVE      RWCCSP        PContSprd                                    CRE073
     C                   EVAL      PContSign = RWCCSG                                         CRE073
      *                                                                                       CRE073
      ** CR Contractual Spread                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRContSprd                                                 CRE073
     C                   Z-ADD     TMCNSP        PConSprd                                     CRE073
      *                                                                                       CRE073
      ** CR Rounding Method and Rounding Fractional/Decimal                                   CRE073
      *                                                                                       CRE073
     C                   EVAL      PRoundMth = RWCRMT                                         CRE073
     C                   EVAL      PRFracDec = RWCRFD                                         CRE073
     C                   IF        RWCCSPOK <> 'N'                                            CRE073
     C                   EXSR      SRRoundMth                                                 CRE073
     C                   EXSR      SRRFracDec                                                 CRE073
     C                   IF        RWCCSPOK <> 'N' AND                                        CRE073
     C                             RWCCSGOK <> 'N' AND                                        CRE073
     C                             RWCRMTOK <> 'N' AND                                        CRE073
     C                             RWCRFDOK <> 'N'                                            CRE073
      *                                                                                       CRE073
      ** CR Rate/SPread Calculation                                                           CRE073
      *                                                                                       CRE073
     C                   Z-ADD     W#CRBrt       PBaseRate                                    CRE073
     C                   EXSR      SRCalcSpr                                                  CRE073
     C                   Z-ADD     NEWSRT        #CRSpread                                    CRE073
     C**********         IF        NEWFRT <= *ZEROS AND                            AR847249 AR947093
     C**********                   PRoundMth <> *BLANKS                            AR847249 AR947093
     C**********         EVAL      RWCRMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      FldNamXAr(1) = 'DPCRMT' + %CHAR(X)              AR847249 AR947093
     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(1) = %EDITC(NEWFRT:'J')               AR847249 AR947093
     C**********         EXSR      UPDATERRS                                       AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        #CRSpread = 0                                              CRE073
     C                   EVAL      RWCRIS = *BLANKS                                           CRE073
     C                   EVAL      RWSIGC = *BLANKS                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        #CRSpread < 0                                              CRE073
                                                                                            AR847249
     C                   EVAL      RWCRISOK = 'W'                                           AR847249
     C                   EVAL      WFldNmXAr(1) = 'DDPCRS' + %CHAR(X)                       AR847249
     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
     C**********         EVAL      WMsgDtXAr(1) = %EDITC(NEWSRT:'J')               AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(NEWSRT:'J')                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   EXSR      UPDATERRS                                                AR847249
                                                                                            AR847249
     C                   IF        RWCCSG = '+'                                             AR847249
     C                   EVAL      RWSIGC = '-'                                               CRE073
     C                   ELSEIF    RWCCSG = '-'                                             AR847249
     C                   EVAL      RWSIGC = '+'                                             AR847249
     C                   ENDIF                                                              AR847249
                                                                                            AR847249
     C**********         EVAL      RWSIGC = '-'                                      CRE073 AR854615
     C**********         EVAL      RWSIGC = '+'                                    AR854615 AR847249
     C                   EVAL      RWCRIS = %CHAR(%ABS(#CRSpread))                            CRE073
     C                   ELSE                                                                 CRE073
     C**********         EVAL      RWSIGC = '+'                                      CRE073 AR854615
     C                   EVAL      RWSIGC = RWCCSG                                          AR854615
     C                   EVAL      RWCRIS = %CHAR(#CRSpread)                                  CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR847249 AR947093
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRIntType
     C                   EXSR      SRIntSubTyp
     C                   EXSR      SRCapDayMon
     C                   EXSR      SRAltAcct
     C                   EXSR      SRPenaType
     C                   EXSR      SRPenaTime
     C                   EXSR      SRPenaRest
 
      ** Update screen fields and OK flags
 
     C                   EVAL      ArrScnBuf(X) = GLAMPR
     C                   EVAL      ArrOkBuf(X) = GLEAMPR
 
      ** If no errors, set up valid file for this row and calculate
      ** event dates
 
     C                   IF        Idx = 0
     C                   EXSR      SRSetupValRow
 
      ** Calculate value, maturity and end dates
 
     C                   EXSR      SRCalDat
 
      ** Calculate capitalisation date
 
     C                   IF        X = 1
     C                   EXSR      SRCapDat
     C                   EVAL      W9DCAP = E2NDID
     C                   EVAL      W9CCAP = E2NCID
     C                   ELSE
     C                   EVAL      E2NDID = W9DCAP
     C                   EVAL      E2NCID = W9CCAP
     C                   ENDIF
 
     C                   EVAL      ArrFilBuf(X) = REPRPN
 
      ** Pass the effective interest rate of the active event to the
      ** standard debit and credit details of the account maintenance API
 
     C                   IF        BJRDNB >= E2VDAT
     C                             AND BJRDNB <= E2MDAT
     C                   EXSR      SRCalRat
     C                   ENDIF
 
      ** Calculate the next event's value date. This is the current
      ** event's period end date + 1 day
 
     C                   EXSR      SRCalcVdat
     C                   ENDIF
 
     C                   ENDDO
     C                   ELSE                                                               BUG27484
                                                                                            BUG27484
      ** Z Period must be included for the account                                          BUG27484
                                                                                            BUG27484
     C                   EVAL      GLEAMPR = ArrOkBuf(1)                                    BUG27484
     C                   EVAL      X = 0                                                    BUG27484
     C                   EVAL      RWEVNT = *BLANKS                                         BUG27484
     C                   EXSR      SREvent                                                  BUG27484
     C                   EVAL      ArrOkBuf(1) = GLEAMPR                                    BUG27484
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPeriodType - Validate type of period                       *
      *                                                               *
      *****************************************************************
     C     SRPeriodType  BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVTPRD'
     C                   PARM                    RetCodeOut
     C                   PARM                    DD0TPRD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    DDTPRDOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRAmountType - Validate interest rollover amount type        *
      *                                                               *
      *****************************************************************
     C     SRAmountType  BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVIRLI'
     C                   PARM                    RetCodeOut
     C                   PARM                    DD0IRLI
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    DDIRLIOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRNextDate - Validate next date                              *
      *                                                               *
      *****************************************************************
     C     SRNextDate    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVMDAT'
     C                   PARM                    RetCodeOut
     C                   PARM                    DD0MDAT
     C                   PARM      W#TotalSet    TOTSET
     C                   PARM                    MAINT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    DD0TPRD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    DDMDATOK
     C                   PARM                    W#MDAT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************                     BUG27484
     C/EJECT                                                                                BUG27484
      *****************************************************************                     BUG27484
      *                                                               *                     BUG27484
      *  SREvent - Validate event type                                *                     BUG27484
      *                                                               *                     BUG27484
      *****************************************************************                     BUG27484
     C     SREvent       BEGSR                                                              BUG27484
                                                                                            BUG27484
      ** Reset variables updated by each module                                             BUG27484
                                                                                            BUG27484
     C                   EXSR      RESETERRS                                                BUG27484
                                                                                            BUG27484
      ** Determine last event indicator                                                     BUG27484
                                                                                            BUG27484
     C                   IF        X = W#TotalSet                                           BUG27484
     C                   EVAL      LASTIN = 'Y'                                             BUG27484
     C                   ELSE                                                               BUG27484
     C                   EVAL      LASTIN = 'N'                                             BUG27484
     C                   ENDIF                                                              BUG27484
                                                                                            BUG27484
     C                   CALLB     'GLVEVNT'                                                BUG27484
     C                   PARM                    RetCodeOut                                 BUG27484
     C                   PARM                    RWEVNT                                     BUG27484
     C                   PARM      X             CURSET                                     BUG27484
     C                   PARM                    LASTIN                                     BUG27484
                                                                                            BUG27484
      ** Error fields/message IDs/message data (arrays) from/to caller                      BUG27484
                                                                                            BUG27484
     C                   PARM                    FldNamXAr                                  BUG27484
     C                   PARM                    MsgIDXAr                                   BUG27484
     C                   PARM                    MsgDtaXAr                                  BUG27484
                                                                                            BUG27484
      ** Warning message IDs/message data (arrays) from/to caller                           BUG27484
                                                                                            BUG27484
     C                   PARM                    WFldNmXAr                                  BUG27484
     C                   PARM                    WMsgIDXAr                                  BUG27484
     C                   PARM                    WMsgDtXAr                                  BUG27484
                                                                                            BUG27484
     C                   PARM                    RWEVNTOK                                   BUG27484
                                                                                            BUG27484
      ** Update error info with that returned from the validation module                    BUG27484
                                                                                            BUG27484
     C                   EXSR      UPDATERRS                                                BUG27484
                                                                                            BUG27484
     C                   ENDSR                                                              BUG27484
      *****************************************************************                     BUG27484
     C/EJECT                                                                                BUG27484
      *****************************************************************                     BUG27484
      *                                                               *                     BUG27484
      *  SRStartDate - Validate Period Start Date                     *                     BUG27484
      *                                                               *                     BUG27484
      *****************************************************************                     BUG27484
     C     SRStartDate   BEGSR                                                              BUG27484
                                                                                            BUG27484
      ** Reset variables updated by each module                                             BUG27484
                                                                                            BUG27484
     C                   EXSR      RESETERRS                                                BUG27484
                                                                                            BUG27484
     C                   CALLB     'GLVVDAT'                                                BUG27484
     C                   PARM                    RetCodeOut                                 BUG27484
     C                   PARM                    RWVDAT                                     BUG27484
     C                   PARM                    BJDFIN                                     BUG27484
     C                   PARM                    BJRDNB                                     BUG27484
     C                   PARM                    MAINT                                      BUG27484
     C                   PARM      X             CURSET                                     BUG27484
                                                                                            BUG27484
      ** Error fields/message IDs/message data (arrays) from/to caller                      BUG27484
                                                                                            BUG27484
     C                   PARM                    FldNamXAr                                  BUG27484
     C                   PARM                    MsgIDXAr                                   BUG27484
     C                   PARM                    MsgDtaXAr                                  BUG27484
                                                                                            BUG27484
      ** Warning message IDs/message data (arrays) from/to caller                           BUG27484
                                                                                            BUG27484
     C                   PARM                    WFldNmXAr                                  BUG27484
     C                   PARM                    WMsgIDXAr                                  BUG27484
     C                   PARM                    WMsgDtXAr                                  BUG27484
                                                                                            BUG27484
     C                   PARM                    RWVDATOK                                   BUG27484
                                                                                            BUG27484
      ** Update error info with that returned from the validation module                    BUG27484
                                                                                            BUG27484
     C                   EXSR      UPDATERRS                                                BUG27484
                                                                                            BUG27484
     C                   ENDSR                                                              BUG27484
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SREndDate - Validate period end date                         *
      *                                                               *
      *****************************************************************
     C     SREndDate     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVCEDE'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWCEDE
     C                   PARM                    R#EVNT
     C                   PARM                    RWVDAT
     C                   PARM                    MAINT
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    TRMDAT
     C                   PARM      X             CURSET
     C                   PARM                    DD0TPRD
     C                   PARM                    DD0MDAT
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWCEDEOK
     C                   PARM                    W#CEDE
     C                   PARM                    DDMDATOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRNumPeriod - Validate number of days/months in period       *
      *                                                               *
      *****************************************************************
     C     SRNumPeriod   BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVNUMB'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWNDPD
     C                   PARM                    RWNMPD
     C                   PARM                    R#EVNT
     C                   PARM                    RWFREQ
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWNDPDOK
     C                   PARM                    RWNMPDOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRollFreq - Validate rollover frequency                     *
      *                                                               *
      *****************************************************************
     C     SRRollFreq    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVFREQ'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWFREQ
     C                   PARM                    R#EVNT
     C                   PARM      X             CURSET
     C                   PARM                    DD0TPRD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWFREQOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRollDay - Validate rollover frequency day                  *
      *                                                               *
      *****************************************************************
     C     SRRollDay     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVDAYM'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDAYM
     C                   PARM                    RWFREQ
     C                   PARM                    RWNMPD
     C                   PARM                    MAINT
     C                   PARM                    BJLCCY
     C                   PARM      W#MDAT        SMDATN
     C                   PARM      X             CURSET
     C                   PARM                    DD0MDAT                                    BUG27484
     C                   PARM                    DD0TPRD                                    BUG27484
     C                   PARM                    R#EVNT                                     BUG27484
     C                   PARM                    RWNDPD                                     BUG27484
     C                   PARM                    RWVDAT                                     BUG27484
     C                   PARM                    BJRDNB                                     BUG27484
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDAYMOK
     C                   PARM                    DDMDATOK                                   BUG27484
     C                   PARM                    RWVDATOK                                   BUG27484
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBaseRate - Validate base rate and spread                   *
      *                                                               *
      *****************************************************************
     C     SRBaseRate    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVRIS'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDRIB
     C                   PARM                    RWDRIS
     C                   PARM                    RWSIGD
     C                   PARM                    RWCRIB
     C                   PARM                    RWCRIS
     C                   PARM                    RWSIGC
     C                   PARM                    S2DRIB
     C                   PARM                    S2CRIB
     C                   PARM      X             CURSET
     C                   PARM                    RWVDAT
     C                   PARM                    RWDNIR
     C                   PARM                    RWCNIR
     C                   PARM                    DD0TPRD
     C                   PARM                    MAINT
     C                   PARM      '*UPD'        WMODE
     C                   PARM                    DDCCY
     C                   PARM                    RWDICT
     C                   PARM                    RWDCST
     C                   PARM                    RWCICT
     C                   PARM                    RWCCST
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDRIBOK
     C                   PARM                    RWDRISOK
     C                   PARM                    RWSIGDOK
     C                   PARM                    RWCRIBOK
     C                   PARM                    RWCRISOK
     C                   PARM                    RWSIGCOK
     C                   PARM      *ZERO         W#DRIS
     C                   PARM      *ZERO         W#CRIS
     C                   PARM      *ZERO         W#DRBrt                                      CRE073
     C                   PARM      *ZERO         W#CRBrt                                      CRE073
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRContSprd - Validate Contractual Spread/Sign                *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRContSprd    BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      *BLANKS       PBaseRat                                     CRE073
     C                   PARM      *BLANKS       PBaseCod                                     CRE073
     C                   PARM      *BLANKS       PFixRate                                     CRE073
     C                   PARM                    PContSprd                                    CRE073
     C                   PARM                    PContSign                                    CRE073
     C                   PARM      *ZEROS        TMCNSP                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM      *BLANKS       PConSprdOK                                   CRE073
     C                   PARM      *BLANKS       PCOnSignOK                                   CRE073
                                                                                              CRE073
     C                   IF        PModule = 'PENADr'                                         CRE073
     C                   EVAL      RWDCSPOK = PConSprdOK                                      CRE073
     C                   EVAL      RWDCSGOK = PCOnSignOK                                      CRE073
     C                   Z-ADD     TMCNSP        #E2DCSP                                      CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      RWCCSPOK = PConSprdOK                                      CRE073
     C                   EVAL      RWCCSGOK = PCOnSignOK                                      CRE073
     C                   Z-ADD     TMCNSP        #E2CCSP                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRRoundMth - Validate Rounding Method                        *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRRoundMth    BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    PRoundMth                                    CRE073
     C                   PARM                    PContSprd                                    CRE073
     C                   PARM                    PRFracDec                                    CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM      *BLANKS       PRoundMthOK                                  CRE073
                                                                                              CRE073
     C                   IF        PModule = 'PENADr'                                         CRE073
     C                   EVAL      RWDRMTOK = PRoundMthOK                                     CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      RWCRMTOK = PRoundMthOK                                     CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRRFracDec - Validate Fraction/Decimal                       *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRRFracDec    BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    PRFracDec                                    CRE073
     C                   PARM                    PContSprd                                    CRE073
     C                   PARM                    PRoundMth                                    CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM      *BLANKS       PFracDecOK                                   CRE073
                                                                                              CRE073
     C                   IF        PModule = 'PENADr'                                         CRE073
     C                   EVAL      RWDRFDOK = PFracDecOK                                      CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      RWCRFDOK = PFracDecOK                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRCalcSpr    - Compute for the new spread rate based on the  *                       CRE073
      *                 rounding rules                                *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRCalcSpr     BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    PBaseRate                                    CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    PContSign                                    CRE073
     C                   PARM                    PRoundMth                                    CRE073
     C                   PARM                    PRFracDec                                    CRE073
     C                   PARM      *ZEROS        NEWSRT                                       CRE073
     C                   PARM      *ZEROS        NEWFRT                                     AR847249
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS                                           CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRIntType - Validate interest type                           *
      *                                                               *
      *****************************************************************
     C     SRIntType     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVICT'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDICT
     C                   PARM                    RWCICT
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDICTOK
     C                   PARM                    RWCICTOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRIntSubTyp - Validate interest subtype                      *
      *                                                               *
      *****************************************************************
     C     SRIntSubTyp   BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVCST'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDCST
     C                   PARM                    RWCCST
     C                   PARM                    RWDICT
     C                   PARM                    RWCICT
     C                   PARM                    RWDNIR
     C                   PARM                    RWCNIR
     C                   PARM                    RWVDAT
     C                   PARM                    DDCCY
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDCSTOK
     C                   PARM                    RWCCSTOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcBasis - Validate interest calculation basis            *
      *                                                               *
      *****************************************************************
     C     SRCalcBasis   BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVRIC'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDRIC
     C                   PARM                    RWCRIC
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDRICOK
     C                   PARM                    RWCRICOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRateFix - Validate interest rate fixing indicator          *
      *                                                               *
      *****************************************************************
     C     SRRateFix     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVNIR'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDNIR
     C                   PARM                    RWCNIR
     C                   PARM                    DD0TPRD
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDNIROK
     C                   PARM                    RWCNIROK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCapFreq - Validate interest capitalisation frequency       *
      *                                                               *
      *****************************************************************
     C     SRCapFreq     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVRIF'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDRIF
     C                   PARM                    RWCRIF
     C                   PARM                    RWDRDD
     C                   PARM                    RWCRDD
     C                   PARM                    RWDRMM
     C                   PARM                    RWCRMM
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDRIFOK
     C                   PARM                    RWCRIFOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCapDayMon - Validate interest capitalisation day/month     *
      *                                                               *
      *****************************************************************
     C     SRCapDayMon   BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVRDP'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDRDD
     C                   PARM                    RWDRMM
     C                   PARM                    RWCRDD
     C                   PARM                    RWCRMM
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDRDDOK
     C                   PARM                    RWDRMMOK
     C                   PARM                    RWCRDDOK
     C                   PARM                    RWCRMMOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRAltAcct - Validate alternative settlement account          *
      *                                                               *
      *****************************************************************
     C     SRAltAcct     BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVACP'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDACP
     C                   PARM                    RWCACP
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDACPOK
     C                   PARM                    RWCACPOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPenaType - Validate penalty transaction type               *
      *                                                               *
      *****************************************************************
     C     SRPenaType    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVRTTV'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWRTTD
     C                   PARM                    RWRTTC
     C                   PARM                    R#EVNT
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWRTTDOK
     C                   PARM                    RWRTTCOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPenaTime - Validate penalty time basis                     *
      *                                                               *
      *****************************************************************
     C     SRPenaTime    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVDYBV'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDYBD
     C                   PARM                    RWDYBC
     C                   PARM                    RWRTTD
     C                   PARM                    RWRTTC
     C                   PARM                    R#EVNT
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDYBDOK
     C                   PARM                    RWDYBCOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPenaRest - Validate penalty restriction                    *
      *                                                               *
      *****************************************************************
     C     SRPenaRest    BEGSR
 
      ** Reset variables updated by each module
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'GLVVRST'
     C                   PARM                    RetCodeOut
     C                   PARM                    RWDRST
     C                   PARM                    RWCRST
     C                   PARM                    R#EVNT
     C                   PARM                    RWRTTD
     C                   PARM                    RWRTTC
     C                   PARM      X             CURSET
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    RWDRSTOK
     C                   PARM                    RWCRSTOK
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRSetupValRow - Set up valid file for the period              *
      *                                                               *
      *****************************************************************
     C     SRSetupValRow BEGSR
 
     C                   CLEAR                   REPRPN
     C                   EVAL      E2BRCA = AMBRCA
     C                   EVAL      E2CNUM = AMCNUM
     C                   EVAL      E2CCY  = AMCCY
     C                   EVAL      E2ACOD = AMACOD
     C                   EVAL      E2ACSQ = AMACSQ
     C                   EVAL      E2EVNT = RWEVNT
     C                   EVAL      E2ITEM = 1
 
      ** Retrieve existing record and update, otherwise create from
      ** a clear record
 
     C     K@PRPNPD      CHAIN     REPRPNPD                           51
 
     C                   EVAL      ZDATEC = RWVDAT
     C                   EVAL      ZDATFM = BJDFIN
     C                   EXSR      SRCnvDate1
     C                   EVAL      E2VDAT = ZDAYNO
     C                   EVAL      E2MDAT = W#MDAT
     C                   EVAL      E2CEDE = W#CEDE
     C                   EVAL      E2FREQ = RWFREQ
 
     C                   EVALR     RWDAYM = %TRIM(RWDAYM)
     C                   MOVE      RWDAYM        E2DAYM
     C                   EVALR     RWNDPD = %TRIM(RWNDPD)
     C                   MOVE      RWNDPD        E2NDPD
     C                   EVALR     RWNMPD = %TRIM(RWNMPD)
     C                   MOVE      RWNMPD        E2NMPD
 
     C                   EVAL      E2IRLI = DD0IRLI
     C                   EVAL      E2TPRD = DD0TPRD
 
     C                   EVALR     RWDRIB = %TRIM(RWDRIB)
     C                   MOVE      RWDRIB        E2DRIB
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      E2DCSP = #E2DCSP                                           CRE073
     C                   MOVE      RWDCSG        E2DCSG                                       CRE073
     C                   MOVE      RWDRMT        E2DRMT                                       CRE073
     C                   MOVE      RWDRFD        E2DRFD                                       CRE073
     C                   IF        RWDCSG    = '-'                                          AR854615
     C**********                   AND #DRSpread > 0                              AR854615 AR947093A
      ** Convert to positive for Negative spread rate                                       AR854615
     C**********                   OR  #DRSpread < 0                              AR854615 AR947093A
     C                   MULT      -1            #DRSpread                                  AR854615
     C                   ENDIF                                                              AR854615
     C                   EVAL      E2DRIS = #DRSpread                                         CRE073
     C                   IF        RWEVNT = 'A'                                               CRE073
     C                   MOVE      RWDCSG        AMDCSG                                       CRE073
     C                   MOVE      RWDRMT        AMDRMT                                       CRE073
     C                   MOVE      RWDRFD        AMDRFD                                       CRE073
     C                   EVAL      AMDCSP = #E2DCSP                                           CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      E2DRIS = W#DRIS
     C                   ENDIF                                                                CRE073
     C                   EVALR     RWDICT = %TRIM(RWDICT)
     C                   MOVE      RWDICT        E2DICT
     C                   EVALR     RWDCST = %TRIM(RWDCST)
     C                   MOVE      RWDCST        E2DCST
     C                   MOVE      RWDRIC        E2DRIC
     C                   EVAL      E2DNIR = RWDNIR
     C                   EVAL      E2DRIF = RWDRIF
     C                   EVALR     RWDRDD = %TRIM(RWDRDD)
     C                   EVALR     RWDRMM = %TRIM(RWDRMM)
     C                   MOVEL     RWDRDD        E2DRDY
     C                   MOVE      RWDRMM        E2DRDY
     C                   EVAL      E2DACP = RWDACP
 
     C                   EVALR     RWCRIB = %TRIM(RWCRIB)
     C                   MOVE      RWCRIB        E2CRIB
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      E2CCSP = #E2CCSP                                           CRE073
     C                   MOVE      RWCCSG        E2CCSG                                       CRE073
     C                   MOVE      RWCRMT        E2CRMT                                       CRE073
     C                   MOVE      RWCRFD        E2CRFD                                       CRE073
     C                   IF        RWCCSG    = '-'                                          AR854615
     C**********                   AND #CRSpread > 0                              AR854615 AR947093A
      ** Convert to positive for Negative spread rate                                       AR854615
     C**********                   OR  #CRSpread < 0                              AR854615 AR947093A
     C                   MULT      -1            #CRSpread                                  AR854615
     C                   ENDIF                                                              AR854615
     C                   EVAL      E2CRIS = #CRSpread                                         CRE073
     C                   IF        RWEVNT = 'A'                                               CRE073
     C                   MOVE      RWCCSG        AMCCSG                                       CRE073
     C                   MOVE      RWCRMT        AMCRMT                                       CRE073
     C                   MOVE      RWCRFD        AMCRFD                                       CRE073
     C                   EVAL      AMCCSP = #E2CCSP                                           CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      E2CRIS = W#CRIS
     C                   ENDIF                                                                CRE073
     C                   EVALR     RWCICT = %TRIM(RWCICT)
     C                   MOVE      RWCICT        E2CICT
     C                   EVALR     RWCCST = %TRIM(RWCCST)
     C                   MOVE      RWCCST        E2CCST
     C                   MOVE      RWCRIC        E2CRIC
     C                   EVAL      E2CNIR = RWCNIR
     C                   EVAL      E2CRIF = RWCRIF
     C                   EVALR     RWCRDD = %TRIM(RWCRDD)
     C                   EVALR     RWCRMM = %TRIM(RWCRMM)
     C                   MOVEL     RWCRDD        E2CRDY
     C                   MOVE      RWCRMM        E2CRDY
     C                   EVAL      E2CACP = RWCACP
 
     C                   EVAL      E2RTTD = RWRTTD
     C                   EVAL      E2DYBD = RWDYBD
     C                   EVAL      E2DRST = RWDRST
 
     C                   EVAL      E2RTTC = RWRTTC
     C                   EVAL      E2DYBC = RWDYBC
     C                   EVAL      E2CRST = RWCRST
 
     C                   IF        RWBALN <> *BLANKS
     C                   EVAL      ZFIELD = %SUBST(RWBALN:1:16)
     C                   EVAL      ZADEC  = A6NBDP
     C                   EVAL      ZADIG  = 15 - A6NBDP
     C                   EXSR      SRAlign
     C                   MOVE      ZAFLD         E2BALN
     C                   IF        %SUBST(RWBALN:17:2) <> 'D '
     C                   EVAL      E2BALN = E2BALN * -1
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     AMACNO        E2KEY1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcVdat - Calculate Value Date of New Event               *
      *                                                               *
      *****************************************************************
     C     SRCalcVdat    BEGSR
 
      ** Add 1 day to the current event's calculated end date
 
     C                   IF        PRCEDE > *ZERO
     C                   EVAL      ZDAYNO = PRCEDE + 1
     C                   EVAL      ZDATFM = BJDFIN
     C                   EXSR      SRCnvDate2
     C                   MOVE      ZDATE         W#VDAT
     C                   ELSE
     C                   EVAL      W#VDAT = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalDat - Calculate Event Dates                             *
      *                                                               *
      *****************************************************************
     C     SRCalDat      BEGSR
 
     C                   CALL      'RETNDAT1'
     C                   PARM                    REPRPN
     C                   PARM                    MAINT
     C                   PARM                    RUNCHG
     C                   PARM                    PRCEDE
     C                   PARM      *BLANKS       PRTCD
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'RETNDAT1'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCapDat - Determine Capitalisation Date                     *
      *                                                               *
      *****************************************************************
     C     SRCapDat      BEGSR
 
      ** Update the next cap date:
      **  o  For newly inserted accounts
      **  o  If the next cap date on REPRPN < run date and
      **     next cap date on REPRPN <= last cap date on ACCNTAB
      **  o  If the next cap date on REPRPN >= run date
 
     C                   Z-ADD     BJRDNB        XDATE             5 0
 
      ** DR capitalisation date
 
     C                   IF        DDACTN = 'I'
     C                             OR (E2NDID < BJRDNB AND E2NDID <= LDID)
     C                             OR E2NDID >= BJRDNB
     C                   MOVE      E2DRIF        W9XRIF            1
     C                   Z-ADD     E2DRDY        W9XRDY            4 0
     C                   EXSR      SRNxtCap
     C                   EVAL      E2NDID = W9CAPD
     C                   EVAL      E2DRDY = W9XRDY
     C                   ENDIF
 
      ** CR capitalisation date
 
     C                   IF        DDACTN = 'I'
     C                             OR (E2NCID < BJRDNB AND E2NCID <= LCID)
     C                             OR E2NCID >= BJRDNB
     C                   MOVE      E2CRIF        W9XRIF            1
     C                   Z-ADD     E2CRDY        W9XRDY            4 0
     C                   EXSR      SRNxtCap
     C                   EVAL      E2NCID = W9CAPD
     C                   EVAL      E2CRDY = W9XRDY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNxtCap - Calculate Next Capitalisation Date                *
      *                                                               *
      *****************************************************************
     C     SRNxtCap      BEGSR
 
      ** Minimum cap date must be end of term for notice account
 
     C     E2TPRD        IFEQ      'N'
     C                   Z-ADD     E2CEDE        W9EOTD            5 0
     C                   ENDIF
 
      ** For active term, this is maturity
 
     C     E2TPRD        IFEQ      'T'
     C                   Z-ADD     E2MDAT        W9EOTD
     C                   ENDIF
 
      ** Initialise next cap date to far in the future
 
     C                   Z-ADD     26664         W9CAPD            5 0
 
      ** Initialise start date to far in the future
 
     C                   Z-ADD     26664         W9ADVD            5 0
 
      ** If frequency is 'M' monthly
      **                 'Q' quarterly
      **                 'X' half-yearly
      **                 'Y' yearly
      ** check to see if you need to advance the next frequency cap date
 
     C     W9XRIF        IFEQ      'M'
     C     W9XRIF        OREQ      'Q'
     C     W9XRIF        OREQ      'X'
     C     W9XRIF        OREQ      'Y'
     C                   EXSR      SRCapFrq
     C                   ENDIF
 
      ** Select minimum of advance-by-freq date and end-of-term date
 
     C     W9ADVD        IFLE      W9EOTD
     C                   Z-ADD     W9ADVD        W9CAPD
     C                   ELSE
     C                   Z-ADD     W9EOTD        W9CAPD
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCapFrq - Do Next Cap Date Frequency Calculations           *
      *                                                               *
      *****************************************************************
     C     SRCapFrq      BEGSR
 
      ** Identify given frequency day and month
      ** (data structure GVNDMY splits into GVNDAY/GVMTH/GVNYER)
 
     C     W9XRDY        MULT      100           GVNDMY
 
      ** Redetermine start date for frequency
      ** (start date is lower limit on next frequency cap date and is
      ** equal to working run day or start of term, whichever is later)
 
     C     XDATE         IFGT      E2VDAT
     C                   Z-ADD     XDATE         W9ADVD            5 0
     C                   ELSE
     C                   Z-ADD     E2VDAT        W9ADVD            5 0
     C                   END
 
      ** Split up start date into WDAY/WMTH/WYEAR components
 
     C                   EVAL      ZDAYNO = W9ADVD
     C                   EVAL      ZDATFM = 'D'
     C                   EXSR      SRCnvDate2
     C                   MOVEL     ZDATE         WDMY
 
      ** If start date is the run day and the given day and given
      ** month have just passed then assume month must now be
      ** advanced
 
     C     W9ADVD        IFEQ      XDATE
     C     GVNMTH        ADD       1             W5N0              5 0
     C     W5N0          IFGT      12
     C                   SUB       12            W5N0
     C                   END
     C     W5N0          IFEQ      WMTH
     C     GVNMTH        OREQ      WMTH
     C     GVNDAY        ANDLT     WDAY
     C     W9XRIF        IFEQ      'M'
     C                   ADD       1             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'Q'
     C                   ADD       3             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'X'
     C                   ADD       6             GVNMTH
     C                   END
     C     W9XRIF        IFEQ      'Y'
     C                   ADD       12            GVNMTH
     C                   END
     C     GVNMTH        IFGT      12
     C                   SUB       12            GVNMTH
     C                   END
     C                   END
     C                   END
 
      ** Check if the given year needs advancing
      **  start with start date year
 
     C                   Z-ADD     WYEAR         GVNYER
     C     GVNMTH        IFLT      WMTH
     C                   ADD       1             GVNYER
     C                   END
     C     GVNMTH        IFEQ      WMTH
     C     GVNDAY        ANDLT     WDAY
     C                   ADD       1             GVNYER
     C                   END
 
      ** Convert this given date into Midas day number
      ** (i.e.  GVNDAY/GVNMTH/GVNYER -> Midas day number)
 
     C                   MOVE      GVNDMY        ZDATEC
     C                   EVAL      ZDATFM = 'D'
     C                   EXSR      SRCnvDate1
     C                   Z-ADD     ZDAYNO        W9MIND            5 0
 
      **   If start date and inferred (minimum) given date are in same
      **   month, and start date <=given date, the std frequency routine
      **   unfortunately advances to the following month.
      **   So artificially subtract one month for this case
 
     C     WMTH          IFEQ      GVNMTH
     C     W9ADVD        ANDLE     W9MIND
     C                   SUB       31            W9ADVD
     C                   SUB       1             WMTH
     C                   END
 
      **   If start date < given date, advance monthly until they equal
      **   using given day for positioning within month
 
     C                   MOVEL     'N'           MTHOK             1
     C     W9ADVD        DOWLT     W9MIND
     C     MTHOK         OREQ      'N'
 
      ** Advance start/working date by one month
 
     C                   CALL      'ZFRQB5'
     C                   PARM      'M'           ZFREQ             1
     C                   PARM      W9ADVD        ZDAYNO            5 0
     C                   PARM      GVNDAY        ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
     C                   Z-ADD     ZDAYNO        W9ADVD
 
      ** Convert this working date to WDAY/WMTH/WYEAR
 
     C                   EVAL      ZDAYNO = W9ADVD
     C                   EVAL      ZDATFM = 'D'
     C                   EXSR      SRCnvDate2
     C                   MOVEL     ZDATE         WDMY
 
      ** Find difference between working month and given month
 
     C     WMTH          SUB       GVNMTH        W3N0              3 0
     C     W3N0          IFLE      0
     C                   ADD       12            W3N0
     C                   END
 
      ** Difference must be a suitable multiple of given month
 
     C     W9XRIF        IFEQ      'M'
     C     W3N0          IFGE      1
     C     W3N0          ANDLE     12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'Q'
     C     W3N0          IFEQ      3
     C     W3N0          OREQ      6
     C     W3N0          OREQ      9
     C     W3N0          OREQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'X'
     C     W3N0          IFEQ      6
     C     W3N0          OREQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C     W9XRIF        IFEQ      'Y'
     C     W3N0          IFEQ      12
     C                   MOVEL     'Y'           MTHOK
     C                   END
     C                   END
     C                   END
 
      ** Provide new given day/month, in case advancement occurred
 
     C                   MOVEL     GVNDMY        W9XRDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalRat - Determine Effective Interest Rates                *
      *                                                               *
      *****************************************************************
     C     SRCalRat      BEGSR
 
     C                   CALL      'RE4009B'
     C                   PARM                    TranInMast
     C                   PARM                    TranInDebi
     C                   PARM                    TranInCred
     C                   PARM                    PrevInDebi
     C                   PARM                    PrevInCred
     C                   PARM                    REPRPN
     C                   PARM      *BLANKS       PRTCD
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'RE4009B'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupHdr - Setup Dates in the Header                       *
      *                                                               *
      *****************************************************************
     C     SRSetupHdr    BEGSR
 
      ** Next date (maturity date)
 
     C                   IF        APAVDAT > *ZEROS
     C                             AND APAMDAT > *ZEROS
     C                             AND APAMDAT < C#TRMDAT
     C                   EVAL      ZDAYNO = APAMDAT
     C                   EVAL      ZDATFM = BJDFIN
     C                   EXSR      SRCnvDate2
     C                   MOVE      ZDATE         DD0MDAT
     C                   EXSR      SREndDate2                                               BUG27631
     C                   ENDIF
 
      ** Available date
 
     C                   IF        APAVDAT > *ZEROS
     C                             AND APAMDAT > *ZEROS
     C                             AND APAMDAT < C#TRMDAT
 
      ** Get the next working date after maturity date, that is, the
      ** first working day of the new term
 
     C                   EVAL      ZDAYNO = APAMDAT
     C                   EVAL      ZDATFM = BJDFIN
     C                   EXSR      SRNxtFreq
     C                   EXSR      SRCnvDate2
     C                   MOVE      ZDATE         DD0AVAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlign - Align Amount to the Decimal Position               *
      *                                                               *
      *****************************************************************
     C     SRAlign       BEGSR
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCnvDate1 - Convert DMY or MDY Format to Midas Date         *
      *                                                               *
      *****************************************************************
     C     SRCnvDate1    BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEC            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZDATFM            1
     C                   PARM      *BLANKS       ZERR              1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCnvDate2 - Convert Midas Date to DMY or MDY Format         *
      *                                                               *
      *****************************************************************
     C     SRCnvDate2    BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNxtFreq - Get Next Frequence Date                          *
      *                                                               *
      *****************************************************************
     C     SRNxtFreq     BEGSR
 
     C                   CALL      'ZFRQB5'
     C                   PARM      'D'           ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      *ZERO         ZMDAY             2 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
 
     C                   ENDSR
      *****************************************************************                     BUG27631
     C/EJECT                                                                                BUG27631
      *****************************************************************                     BUG27631
      *                                                               *                     BUG27631
      *  SRSaveParm - Save some parameter values from SREndDate.      *                     BUG27631
      *               This will be used for SREndDate2 later          *                     BUG27631
      *                                                               *                     BUG27631
      *****************************************************************                     BUG27631
     C     SRSaveParm    BEGSR                                                              BUG27631
                                                                                            BUG27631
      ** Save the input parameters used during SREndDate                                    BUG27631
                                                                                            BUG27631
     C                   EVAL      P#CEDE = RWCEDE                                          BUG27631
     C                   EVAL      P#VDAT = RWVDAT                                          BUG27631
     C                   EVAL      P#MDAT = TRMDAT                                          BUG27631
     C                   EVAL      P#CSET = CURSET                                          BUG27631
     C                   EVAL      P#CEED = W#CEDE                                          BUG27631
                                                                                            BUG27631
     C                   ENDSR                                                              BUG27631
      *****************************************************************                     BUG27631
     C/EJECT                                                                                BUG27631
      *****************************************************************                     BUG27631
      *                                                               *                     BUG27631
      *  SREndDate2 - Validate period end date again after setup      *                     BUG27631
      *               header                                          *                     BUG27631
      *                                                               *                     BUG27631
      *****************************************************************                     BUG27631
     C     SREndDate2    BEGSR                                                              BUG27631
                                                                                            BUG27631
      ** Reset variables updated by each module                                             BUG27631
                                                                                            BUG27631
     C                   EXSR      RESETERRS                                                BUG27631
                                                                                            BUG27631
     C                   CALLB     'GLVCEDE'                                                BUG27631
     C                   PARM                    RetCodeOut                                 BUG27631
     C                   PARM                    P#CEDE                                     BUG27631
     C                   PARM      'A'           R#EVNT                                     BUG27631
     C                   PARM                    P#VDAT                                     BUG27631
     C                   PARM                    MAINT                                      BUG27631
     C                   PARM                    BJRDNB                                     BUG27631
     C                   PARM                    BJDFIN                                     BUG27631
     C                   PARM                    P#MDAT                                     BUG27631
     C                   PARM                    P#CSET                                     BUG27631
     C                   PARM                    DD0TPRD                                    BUG27631
     C                   PARM                    DD0MDAT                                    BUG27631
                                                                                            BUG27631
      ** Error fields/message IDs/message data (arrays) from/to caller                      BUG27631
                                                                                            BUG27631
     C                   PARM                    FldNamXAr                                  BUG27631
     C                   PARM                    MsgIDXAr                                   BUG27631
     C                   PARM                    MsgDtaXAr                                  BUG27631
                                                                                            BUG27631
      ** Warning message IDs/message data (arrays) from/to caller                           BUG27631
                                                                                            BUG27631
     C                   PARM                    WFldNmXAr                                  BUG27631
     C                   PARM                    WMsgIDXAr                                  BUG27631
     C                   PARM                    WMsgDtXAr                                  BUG27631
                                                                                            BUG27631
     C                   PARM                    RWCEDEOK                                   BUG27631
     C                   PARM                    P#CEED                                     BUG27631
     C                   PARM                    DDMDATOK                                   BUG27631
                                                                                            BUG27631
      ** Update error info with that returned from the validation module                    BUG27631
                                                                                            BUG27631
     C                   EXSR      UPDATERRS                                                BUG27631
                                                                                            BUG27631
     C                   ENDSR                                                              BUG27631
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Process Initialisation                              *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Access currency details via access program
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DDCCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      Idx = I - 1
     C                   ELSE
     C                   EVAL      Idx = %ELEM(FldNameArr)
     C                   ENDIF
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
 
      ** Set warning index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      WIdx = I - 1
     C                   ELSE
     C                   EVAL      WIdx = %ELEM(WFldNamArr)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    TranInMast
     C                   PARM                    TranInDebi
     C                   PARM                    TranInCred
     C                   PARM                    PrevInDebi
     C                   PARM                    PrevInCred
     C                   PARM                    TranInPena
     C                   PARM                    OKFlagsDS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C                   PARM                    AccnFilFmt
     C                   PARM                    ValidAccn
     C                   PARM                    ValidPena
 
      ** Key list
 
     C     K@PRPNPD      KLIST
     C                   KFLD                    E2BRCA
     C                   KFLD                    E2CNUM
     C                   KFLD                    E2CCY
     C                   KFLD                    E2ACOD
     C                   KFLD                    E2ACSQ
     C                   KFLD                    E2EVNT
     C                   KFLD                    E2ITEM
 
      **  Move program name into LDA field
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD7VL'   DBPGM
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        BJDFIN = 'D'
     C                   EVAL      TRMDAT = '311244'
     C                   ELSE
     C                   EVAL      TRMDAT = '123144'
     C                   ENDIF
      **********                                                                            BUG27488
      ***Override*ACCNT*                                                                    BUG27488
      **********                                                                            BUG27488
     C**********         EVAL      CMDLEN = 50                                              BUG27488
     C**********         CALL      'QCMDEXC'                                                BUG27488
     C**********         PARM                    OVR1                                       BUG27488
     C**********         PARM                    CMDLEN                                     BUG27488
 
      ** Check if CRE073 is installed                                                         CRE073
                                                                                              CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   IF        PRTCD <> '*NRF'                                            CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBASE = 5                                                  CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      *                                                                                     BUG27488
      ** Array OVR1 deleted                                                                 BUG27488
      *                                                                                     BUG27488
 
** CPY@
(c) Misys International Banking Systems Ltd. 2009
** ARREVNT
ABCDEFGHIJKLMNOPQRSTUVWXYZ
