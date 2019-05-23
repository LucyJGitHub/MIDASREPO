     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayments - control update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEMAPYCTU - LE Manual Repayments  - Control Update           *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             Manual Repayments.                                *
      *             It is a batch function.                           *
      *            Processes executed controlled by input Action Code *
      *            - For A (=Amend)                                   *
      *              - Validate the Repayment details fields          *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise)                               *
      *              - Validate the Repayment details fields          *
      *              - Validate the settlement fields                 *
      *              (Repayments are only sent from Loan Manager      *
      *               if authorised; validation need to be done here) *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246765             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 04Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CDE005             Date 23Sep02
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246765 - Uses the correct extra data layout file             *
      *           Test the correct return code when coming back from  *
      *           UPD_DBASE                                           *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CDE005 - Reservation ID                                      *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      *
     FLEIMAPYPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      * Hook to enable non-core files to be included
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
      *
     D TranInScr     E DS                  EXTNAME(LEMAPYPD)
      ***  Manual Repayments Details in screen format
     D  Incomkey               1     51
      *
     D CurMAPYCF     E DS                  EXTNAME(LEMAPYPD)
      ***  (Current) Screen Format
     D                                     PREFIX(@)
     D  Insertkey              1     51
      *
     D OKFlagsDS     E DS                  EXTNAME(LEEMAPYPD)
      ***  Manual Repayments Details OK indicator
      *
     D ValidMAPY     E DS                  EXTNAME(LEVMAPYPD)
      ***  New Manual Repayment Details in file format
     D***ValidREC             321    389                                                      CGL029
     D***ValidPAY             390    948                                                      CGL029
     D  ValidREC             335    389                                                       CGL029
     D  ValidPAY             404    948                                                       CGL029
     D  ValidRECEx          1195   1212                                                       CGL029
     D  ValidPAYEx          1213   1230                                                       CGL029
      *
     D CMAPYFilFmt   E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(MR_)
      ***  Repayment in File Format
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
      ***  Loan PAyment/receipt instructions
     D***LoanRecInst          459    527                                                      CGL029
     D***LoanPayInst          528   1086                                                      CGL029
     D  LoanRecInst          473    527                                                       CGL029
     D  LoanPayInst          542   1086                                                       CGL029
     D  LoanRecInstEx       1597   1614                                                       CGL029
     D  LoanPayInstEx       1615   1632                                                       CGL029
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
      *
     D F_REC         E DS                  EXTNAME(SDESFRPD)
      ***  File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
      *
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
      ***  File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
      *
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
      ***  File Fra/irs instructions
      *
     D S_REC         E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive instructions
      *
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      ***  Screen Payment instructions
      *
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
      ***  Screen Fra/irs instructions
      *
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
      ***  Current Screen Receive instructions
      *
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
      ***  Current Screen Payment instructions
      *
     D OKPayInsDS      DS
      ***  Flags to indicate whether Pay Settlement instruction fields
      ***  are valid
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
      *
     D OKRecInsDS      DS
      ***  Flags to indicate whether Receive Settlement instruction fields
      ***  are valid
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
      *
     D OKFRAInsDS      DS
      ***  Flags to indicate whether FRA/IRS instruction fields are valid
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
      *
     D***ExtData*******E DS                  EXTNAME(LERPEXPD)                                246765
      *****LE*Rollover Instructions Extra Data - File (D/B) format                            246765
     D ExtData       E DS                  EXTNAME(LEMAEXPD)                                  246765
      ***  LE Manual Payment Extra Data - Screen format                                       246765
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Bank Details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
     D SCA_LCD       E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs - long data structure
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
      *
     D P#InMf        E DS                  EXTNAME(LEM1MFPD)
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029
      ***  IN Message Format
     D  P#TSEQ                52     55  0
     D***P#PONS*              166    177                                                      CGL029
     D***P#RONS*              376    387                                                      CGL029
     D  PIDTPA               443    582
     D  PIDTP1               443    477
     D  PIDTP2               478    512
     D  PIDTP3               513    547
     D  PIDTP4               548    582
     D  PIBTBA               586    795
     D  PIBTB1               586    620
     D  PIBTB2               621    655
     D  PIBTB3               656    690
     D  PIBTB4               691    725
     D  PIBTB5               726    760
     D  PIBTB6               761    795
     D  P#PONS               886    906                                                       CGL029
     D  P#RONS               907    927                                                       CGL029
      *
     D P#OuMf        E DS                  EXTNAME(LEM2MFPD)
      ***  OUT Message Format
      *
     D***OldSettlDS     DS            34                                                      CGL029
     D  OldSettlDS     DS            40                                                       CGL029
      ***  Current Settlement details for Loan Amendment
      *
     D  OSETP                  1      2  0
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
      *
     D***NewSettlDS     DS            34                                                      CGL029
     D  NewSettlDS     DS            40                                                       CGL029
      ***  New settlement details for Loan Amendments
     D  WTYPE                  1      2
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
      *
     D  PassDtaDS      DS           256
      ***  Ds to pass details from caller
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D WrkDDESEQ              11     13A
     D WrkDDPASD              14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D WOSAC           S             18                                                       CGL029
      *
     D TimeStamp       S             26Z
      ***  Timestamp for the transaction
      *
      ***  Date fields used in call to ZDATE10
     D DateIn          S              8S 0
     D ZZMDNO          S              5  0
                                                                                              244636
      ** Parameter for LERPSCRTV                                                              244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Start of Main processing
      *****************************************************************
      *
      ***  Initialisation
      *
     C                   EXSR      INITPR
      *
      ***  Map incoming data into the screen fields
      *
     C                   EXSR      MAPMAPY                                       Manual Repayment
      *
      ***  Validate action code
      *
     C                   EXSR      ValidateAc
      *
      ***  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ***  Processing depends upon Action Code
      *
     C                   SELECT
      *
      ***  INSERT
      ***  ======
      *
     C     DDACTN        WHENEQ    'I'
      *
      ***  For insert, use LEMAPYCVT to setup loan details which will impact validation,
      ***  these are WrkOutPrinc and WrkRemainInt used by LEMAPYVAL Module.
      *
     C                   MOVEL     Incomkey      Insertkey                      (fill CurMAPYCF)
      *
     C                   CALLB     'LEMAPYCVT'
      *
      ***  Inputs
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    CMAPYFilFmt                    Current details
     C                   PARM                    PDLoAmFilFmt                   PD/RE Details
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    CLE023            1            Feature
     C                   parm                    WrkReactFacil     1            (from RTV)
      *
      ***  Output parameters
      *
      ***  Manual Repayment Details - screen format
     C                   PARM                    CurMAPYCF
     C                   PARM      0             WrkProcTypLoan    2 0          Current DSPF
     C                   PARM                    WrkOutPrinc      13 0
     C                   PARM                    WrkRemainInt     13 0
      *
      ***  Override details with incoming once
      *
     C                   MOVE      M1CNUM        DDCUST
     C                   MOVE      M1PRAM        DDRPRI
     C                   MOVE      M1PRAS        DDPSIG
     C                   MOVE      M1INTA        DDRINT
     C                   MOVE      M1INTS        DDISIG
     C                   MOVE      M1TAMT        DDRTOT
     C                   MOVE      M1TAMS        DDRSIG
     C                   MOVE      M1LWOI        DDWOFF
     C                   MOVE      M1PAST        DDPASD
      *
      *
     C                   EXSR      ValidateTR
      *
     C                   EXSR      ValidateST
      *
      ***  Amends, Authorise, Reverse
      ***  ==========================
      *
     C     DDACTN        WHENEQ    'A'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'X'
      *
     C                   EXSR      ValidateTR
      *
     C                   EXSR      ValidateAMD
      *
     C                   EXSR      ValidateST
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ***  Do updates for this transaction
      ***  according to whether it is valid or invalid
      *
     C     Idx           IFEQ      0
     C                   EXSR      UPDAT_VAL
     C                   ENDIF
     C     Idx           IFNE      0
     C                   EXSR      UPDAT_INVAL
     C                   ENDIF
      *
      ***  Terminate program
      *
     C                   SETON                                        LR
      *
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPMAPY       BEGSR
      *
      ***  Assume repair is in Front Office
      *
     C                   MOVEL     'F'           RPLOC             1
      *
     C                   MOVEL     M1TNRF        FOTRID
      *
      ***  Manual Repayment details
      *
     C                   CLEAR                   TranInScr
      *
     C                   MOVE      M1LNRF        DDLNRF
     C                   MOVEL     M1ACTN        DDACTN
     C                   if        DDACTN <> 'I'
     C                   MOVE      M1LASN        DDSEQN
     C                   Endif
     C                   if        M1XASQ <> 0
     C                   MOVE      M1XASQ        DDESEQ
     C                   Endif
      *
      ***  Convert Value date to MIDAS day number.
      *
     C                   MOVE      M1VDAT        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
      *
     C                   MOVE      ZZMDNO        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVALD
      *
      ***  Convert Expected Value date to MIDAS day number.
      *
     C                   If        M1XAVD  <> *blanks
     C                   MOVE      M1XAVD        DateIn
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
      *
     C                   MOVE      ZZMDNO        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDEVAL
     C                   endif
      *
     C                   ENDSR
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPSETTL      BEGSR
      ****
      **** Receive instructions
      ****
     C****               CLEAR                   F_REC
     C****               MOVE      M1RSTM        FLRSTM
     C****               MOVE      M1RONS        FLRONS
     C****               MOVEL     M1PCOB        FLROBR
     C****               MOVE      M1RIBN        FLRIBN
     C****               MOVE      M1RIBA        FLRIBA
     C****               MOVE      M1ROBN        FLROBN
     C****               MOVE      M1ROCN        FLROCN
     C****               MOVE      M1SCCY        FLRSCY
      ****
      **** Payment instructions
      ****
     C****               CLEAR                   F_PAY
     C****               MOVE      M1PSTM        FLPSTM
     C****               MOVE      M1PONS        FLPONS
     C****               MOVEL     M1PCOB        FLPOBR
     C****               MOVE      M1PIBN        FLPIBN
     C****               MOVE      M1PIBA        FLPIBA
     C****               MOVE      M1POBN        FLPOBN
     C****               MOVE      M1POCN        FLPOCN
     C****               MOVE      M1CVMR        FLCVMR
     C****               MOVE      M1RCRN        FLRCRN
     C****               MOVE      M1RCRA        FLRCRA
     C****               MOVE      M1RVNO        FLRVNO
     C****               MOVE      M1AWBN        FLAWBN
     C****               MOVE      M1AWBA        FLAWBA
     C****               MOVE      M1BENN        FLBENN
     C****               MOVE      M1BENA        FLBENA
     C****               MOVEL     PIDTP1        FLDTP1
     C****               MOVEL     PIDTP2        FLDTP2
     C****               MOVEL     PIDTP3        FLDTP3
     C****               MOVEL     PIDTP4        FLDTP4
     C****               MOVE      M1DCHG        FLDCHG
     C****               MOVEL     PIBTB1        FLBTB1
     C****               MOVEL     PIBTB2        FLBTB2
     C****               MOVEL     PIBTB3        FLBTB3
     C****               MOVEL     PIBTB4        FLBTB4
     C****               MOVEL     PIBTB5        FLBTB5
     C****               MOVEL     PIBTB6        FLBTB6
      ****
     C****               MOVE      M1SCCY        FLPSCY
     C****               MOVE      M1ICCY        FLIC72
      ****
      **** IF The settlements instructions are in file format, but the
      **** Settlements validation requires that they are in the input format.
      **** Therefore convert the file format to screen format.
      ****
     C****               CALLB     'ZASETINCVT'
      ****
      **** Settlement Instructions in file format
     C****               PARM                    F_PAY
     C****               PARM                    F_REC
     C****               PARM      *BLANK        F_FRI
      ****
      **** Settlement Instruction in input format
     C****               PARM                    S_PAY
     C****               PARM                    S_REC
     C****               PARM                    S_FRI
      ****
      *
      ***  Validate the Settlement instructions wich are send in SCREEN format by loan manager.
      *
     C                   CLEAR                   S_REC
     C                   MOVE      DDSCCY        DDRSCY
     C                   MOVE      M1RSTM        DDRSTM
     C                   MOVEL     M1RONS        DDRONX
     C                   MOVEL     M1RIBN        DDRIBN
     C                   MOVEL     M1RIBA        DDRIBA
     C                   MOVEL     M1ROBN        DDROBN
     C                   MOVEL     M1ROCN        DDROCN
     C                   CLEAR                   S_PAY
     C                   MOVE      DDSCCY        DDPSCY
     C                   MOVE      M1PSTM        DDPSTM
     C                   MOVEL     M1PONS        DDPONX
     C                   MOVEL     M1PIBN        DDPIBN
     C                   MOVEL     M1PIBA        DDPIBA
     C                   MOVEL     M1POBN        DDPOBN
     C                   MOVEL     M1POCN        DDPOCN
     C                   MOVE      M1CVMR        DDCVMR
     C                   MOVE      M1RCRN        DDRCRN
     C                   MOVE      M1RCRA        DDRCRA
     C                   MOVE      M1RVNO        DDRVNO
     C                   MOVE      M1AWBN        DDAWBN
     C                   MOVE      M1AWBA        DDAWBA
     C                   MOVE      M1BENN        DDBENN
     C                   MOVE      M1BENA        DDBENA
     C                   MOVEL     PIDTP1        DDDTP1
     C                   MOVEL     PIDTP2        DDDTP2
     C                   MOVEL     PIDTP3        DDDTP3
     C                   MOVEL     PIDTP4        DDDTP4
     C                   MOVE      M1DCHG        DDDCHG
     C                   MOVEL     PIBTB1        DDBTB1
     C                   MOVEL     PIBTB2        DDBTB2
     C                   MOVEL     PIBTB3        DDBTB3
     C                   MOVEL     PIBTB4        DDBTB4
     C                   MOVEL     PIBTB5        DDBTB5
     C                   MOVEL     PIBTB6        DDBTB6
      *
     C                   MOVE      M1ICCY        DDIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      M1SCCY        DDRSCY                                       CLE031
     C                   MOVE      M1REXR        DDREXR                                       CLE031
     C     M1REXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      M1REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDREXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      M1REXI        DDREXI                                       CLE031
     C     M1REXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      M1PSCY        DDPSCY                                       CLE031
     C                   MOVE      M1PEXR        DDPEXR                                       CLE031
     C     M1PEXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      M1PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   Z-ADD     *ZEROS        WSEXR            14 0                        CLE031
     C                   MOVEL     ZAVAL         WSEXR                                        CLE031
     C     PRTCD         IFNE      *BLANKS                                                    CLE031
     C     WSEXR         OREQ      *ZEROS                                                     CLE031
     C                   MOVE      *BLANKS       DDPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      M1PEXI        DDPEXI                                       CLE031
     C     M1PEXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
      *
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      ***  if DDACTN = 'I', ensure ModeOfOP is '*FRONT'
      *
     C                   if        ModeofOp <> '*FRONT' and DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   endif
      *
      *
      ***  Validate action code versus transaction IDs supplied
      ***  The Manual repayment in file format from the LE database is retrieved
      ***  as well.
      *
     C                   CALLB     'LEMAPYRTV'
      *
      ***  INPUTS
      *    ======
      *
     C                   PARM                    RetCodeIn                      Return code
     C                   PARM                    ModeofOp                       Mode
     C                   PARM      ' '           RespMode          1            Response mode
     C                   PARM                    DDACTN                         Action Code
     C                   PARM                    FOTRID           20            Front Office ID
     C                   PARM                    DDLNRF                         Loan Ref
     C                   PARM                    DDVALD            6            value date
     C                   PARM                    DDSEQN            3            Sequence
     C                   PARM                    DDEVAL                         Expected date
     C                   PARM                    DDESEQ                         Expected Sequence
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014
      *
      ***  OUTPUTS
      *    =======
      *
      ***  (Current) Repayment in file format
     C                   PARM                    CMAPYFilFmt
     C                   PARM      *BLANK        DDACTNOK                       OK Actn code
     C                   PARM      *BLANK        DDLNRFOK                       OK Loan ref
     C                   PARM                    DDVALDOK                       OK Value Date
     C                   PARM                    DDSEQNOK                       OK Sequence
     C                   PARM      *BLANK        DDEvalOK                       OK Expected Date
     C                   PARM      *BLANK        DDEseqOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WrkWHoldTaxRat   11 7          W/hold Tax Rate
     C                   PARM                    WrkExpectTyp      1            Expect Amend Loan tp
     C                   PARM                    WrkPTYP72         1            Expected on type 72
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      Counter MR
     C                   PARM                    PDLoAmFilFmt                   PD/RE if exists
     C                   PARM                    WrkLnDetails                   Loan File Fmt
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
     C                   PARM                    Widx
     C                   PARM                    PRcvParm                                     244636
      *
      ***  Save the settlement details for update if not insert
      *
     C     DDACTN        IFNE      'I'
     C                   MOVE      MR_SETP       OSETP
     C                   MOVEL     MR_OSAC       OOSAC
     C                   MOVEL     MR_TSEN       OTSEN
     C                   MOVEL     MR_FACO       OFACO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTR    BEGSR
      *
     C                   MOVEL     CMAPYFilFmt   ValidMAPY                      Current Details File
      *
     C                   CALLB     'LEMAPYVAL'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    P#Mode
      *
      ***  Manual Repayment Details in screen format
     C                   PARM                    TranInScr
     C                   PARM                    PDLoAmFilFmt                 Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan Details
     C                   PARM                    WrkReactFacil     1          Reactivated facility
     C                   PARM                    WrkOutPrinc      13 0        Outstanding Princ.
     C                   PARM                    WrkRemainInt     13 0        Loan Remaining int.
     C                   PARM                    WrkPTYP72         1          Expected on type 72
     C                   PARM                    CLE005            1          Feature
     C                   PARM                    CLE007            1          Feature
      *
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  OUTPUTS
      ***  =======
      *
      ***  Field OK flags
     C                   PARM                    OKFlagsDS
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      *
      ***  Valid file layout (DS) from/to caller
     C                   PARM                    ValidMAPY                      Nw MR in File Format
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
      *
      ***  Put Loam manager Settlement instruction ot be validated
      *
     C                   EXSR      MAPSETTL
      **
     C                   Z-ADD     *ZERO         ##DATR
      *
     C                   MOVE      DDVALD        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
      *
     C                   Z-ADD     ZDAYNO        ##DATP
     C                   Z-ADD     ZDAYNO        ##DATR
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'ZASETINVAL'
      *
      ***  Return Code
     C                   PARM      *BLANKS       ReturnCode
      *
      ***  Following parameters are output to called module
      ***  Calling function type
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Transaction Fields
      ***  Payment currency
     C                   PARM      DDSCCY        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDSCCY        ##RCCY            3
      *
      ***  Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan type
     C                   PARM      MRLTYP        ##TTYP            2
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Booking Branch
     C                   PARM      MRBRCA        ##BRCA            3
      *
      ***  Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM                    ##DATP            5 0
      *
      ***  Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
      *
      ***  Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
      *
      ***  Following parameters are returned by called module
      ***  Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      *
      ***  Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      *
      ***  FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      *
      ***  Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      *
      ***  File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      *
      ***  Extra Input
      ***  Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
      *
      ***  Update valid Manual Repayment in file format
      *
     C**********         MOVEL     F_REC         ValidREC                                     CGL029
     C                   MOVEL     FLREC         ValidREC                                     CGL029
     C                   MOVEL     FLRONS        ValidRECEx                                   CGL029
     C                   MOVEL     FLRSTM        MRRSTM                                       CGL029
     C                   MOVEL     FLRSCY        MRSCCY
      *
     C**********         MOVEL     F_PAY         ValidPAY                                     CGL029
     C                   MOVEL     FLPAY         ValidPAY                                     CGL029
     C                   MOVEL     FLPONS        ValidPAYEx                                   CGL029
     C                   MOVEL     FLPSTM        MRPSTM                                       CGL029
     C                   MOVEL     FLCVMR        MRCVMR
     C                   MOVEL     FLPSCY        MRSCCY
     C                   MOVEL     FLIC72        MRICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        MRREXR                                       CLE031
     C                   Z-ADD     FLPEXR        MRPEXR                                       CLE031
     C                   MOVE      FLREXI        MRREXI                                       CLE031
     C                   MOVE      FLPEXI        MRPEXI                                       CLE031
     C                   MOVE      FLRSCY        MRSCCY                                       CLE031
     C                   MOVE      FLPSCY        MRPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Save the new settlement details for update
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVE      FLPOBR        MROSBR
     C                   ELSE
     C                   MOVE      FLROBR        MROSBR
     C                   ENDIF
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C                   Endif
      *
      ***  Save NEW values for shadow posting
      *
     C                   MOVE      *BLANKS       NewSettlDS
     C                   MOVE      WSETP         WTYPE
     C                   MOVEL     WOSAC         WOURS
     C                   MOVEL     WTSEN         WTHRS
     C                   MOVEL     FLBENN        WFACO
      *
      ***  Perform the additional validations
      *
      ***  Set up PassDtaDs fields
     C                   eval      WrkDDeseq = DDeseq
     C                   eval      WrkDDpasd = DDpasd
     C
     C                   CALLB     'LEMAPY2VL'
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ***  Valid Manual Repayment
     C                   PARM                    ValidMAPY
      *
      ***  Payment instructions
     C                   PARM                    F_PAY
      *
      ***  Receive instructions
     C                   PARM                    F_REC
      *
     C                   PARM                    WTYPE             2          Settlement methode
     C                   PARM                    PassDtaDS                    Settlement methode
      ***  Field OK flags (DS)
     C                   PARM                    OKFlagsDS
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index
     C                   PARM                    WIdx
      *
     C                   MOVEL     ValidMAPY     CMAPYFilFmt                    new MR to update
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate amendments
      *****************************************************************
     C     ValidateAMD   BEGSR
      *
      ***  This subroutine calls a procedure which checks whether it
      ***  was valid to amend any of the fields which have been
      ***  changed.
      *
     C                   CALLB     'LEMAPYCVT'
      *
      ***  INPUTS
      ***  ======
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    CMAPYFilFmt                    RTV MR details
     C                   PARM                    PDLoAmFilFmt
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    CLE023            1            Feature
     C                   parm                    WrkReactFacil     1            (from RTV)
      *
      ***  OUTPUT
      ***  ======
      *
      ***  Manual Repayment in screen format
     C                   PARM                    CurMAPYCF                      Current details Scrn
     C                   PARM                    WrkProcTypLoan    2 0
     C                   PARM                    WrkOutPrinc      13 0
     C                   PARM                    WrkRemainInt     13 0
      *
      ***  Compare Screnne  fileds with Current File <> Received details in Screen format
      *
     C                   CALLB     'LEMAPYAMD'
      *
      ***  INPUTS
      ***  ======
      *
     C                   PARM                    RetCodeIn                      Return Code
     C                   PARM                    TranInScr                      New MR in Screen fmt
     C                   PARM                    CurMapyCF                      Cur MR in Screen fmt
      *
      ***  OUTPUTS
      ***  =======
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
     C                   PARM                    AmIdx             3 0
      ***  Amendments OK
     C                   PARM                    AmendOk           1
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
      *
      ***  If any errors overwrite previous error information
      *
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Add       AmIdx         Idx
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
      *
      ***  If repair in back-office
      *
     C     RPLOC         IFEQ      'B'
      *
      ***  Write to the invalid (repair) files
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      DDFOTRANID = M1TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'
     C                   EVAL      DDTMESTMP = TimeStamp
     C                   EVAL      DDMsgType  = 'LEMAPY'
      *
     C                   WRITE     LEIMAPYD0                                    Scn fmt input
     C                   WRITE     APIDSETD0                                    Scn - settl instr
     C                   EXSR      W_ZATRNERR
      *
      ***  Commit the database changes
      *
     C                   COMMIT
      *
     C                   ENDIF
      *
      ***  Get the text for the first error message
      *
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM                    @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
      *
      ***  Set up the returned message format
      *
     C                   MOVE      M1MSGT        M2MSGT
     C                   MOVE      M1TRUS        M2TRUS
     C                   MOVE      M1TRWS        M2TRWS
     C                   MOVE      M1TNRF        M2TNRF
     C                   MOVE      M1TRSN        M2TRSN
     C                   MOVE      M1ACTN        M2ACTN
     C                   MOVE      M1TRDS        M2TRDS
     C                   MOVE      M1TRTS        M2TRTS
     C                   MOVE      M1NRBA        M2NRBA
     C                   MOVEL     'E'           M2MSGS
     C                   MOVEL     ZAMSID        M2MSGI
     C                   MOVEL     ZAMSTX        M2MSTX
     C                   MOVE      M1LNRF        M2LNRF
     C                   MOVE      M1VDAT        M2VDAT
     C                   MOVE      M1LASN        M2LASN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
      *
      ***  Update the database
      *
     C                   EXSR      UPD_DBASE
      *
      ***  If there were errors, rollback any database changes and increment
      ***  the error index by 1 to drive the 'invalid' record processing
      *
     C*****RetCodeOut    IFNE      *BLANKS                                                    246765
     C     @RTCD         IFNE      *BLANKS                                                    246765
      *
     C                   ADD       1             Idx
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                 AR868380
     C                   EVAL      MsgIdArr(Idx) =  'LEL0817'                               AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   ROLBK
      *
     C                   ELSE
      *
      ***  Commit the database changes
      *
     C                   COMMIT
      *
      ***  Set up the returned message format
      *
     C                   MOVE      M1MSGT        M2MSGT
     C                   MOVE      M1TRUS        M2TRUS
     C                   MOVE      M1TRWS        M2TRWS
     C                   MOVE      M1TNRF        M2TNRF
     C                   MOVE      M1TRSN        M2TRSN
     C                   MOVE      M1ACTN        M2ACTN
     C                   MOVE      M1TRDS        M2TRDS
     C                   MOVE      M1TRTS        M2TRTS
     C                   MOVE      M1NRBA        M2NRBA
     C                   MOVE      M1LNRF        M2LNRF
     C                   MOVE      M1VDAT        M2VDAT
     C                   MOVE      M1LASN        M2LASN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
      ***  Setup Last change type on valid file
      *
     C                   MOVEL     DDACTN        MRCHTP
     C                   MOVEL     DDESEQ        WrkDDESEQ
     C                   MOVEL     DDPASD        WrkDDPASD
      *
     C                   CALLB     'LEMAPYUPD'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Return Code
     C**********         PARM      *BLANK        @@RTCD            7                          246765
     C                   PARM      *BLANK        @RTCD                                        246765
      ***  Externally described DS for valid Manual repayment
     C                   PARM                    CMAPYFilFmt
     C                   PARM                    PdLoamFilFmt                   PD/RE details
     C                   PARM                    WrkLnDetails                   Loan details
      *
      ***  Old settlement details
     C                   PARM                    OldSettlDS
      *
      ***  New settlement details
     C                   PARM                    NewSettlDS
      *
      ***  Data
     C                   PARM                    PassDtaDS
      *
      ***  OUTPUTS
      ***  =======
      *
      ***  Field OK flags
     C                   PARM                    OKFlagsDS
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
      * Reservation ID                                                          CDE005
     C                   PARM      *BLANKS       ResrvId          10            CDE005
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
      *
     C                   EVAL      ABFOTRNID  = DDFOTRANID
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = DDTMESTMP
      *
      ***  Do while error messages found
      ***  Write error messages to file
      *
     C                   Z-ADD     1             #C                2 0
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     FldNameArr(#C)ABFIELDNAM
     C                   MOVEL     MsgIdArr(#C)  ABMSGID
     C                   Z-ADD     1             Iy                3 0
     C     FldNameArr(#C)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      ABFIELDID  = FldSeqArr(Iy)
     C                   WRITE     ZATRNERRD0
     C                   ADD       1             #C
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#Mode            1
     C                   PARM                    P#InMf
     C                   PARM                    P#OuMf
      *
     C     P#Mode        IFEQ      'F'
     C                   MOVEL     '*FRONT'      ModeofOp          6
     C                   ENDIF
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access API ICD via access program
      ***  (database error handling done in access program)
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Check features
      *
     C                   MOVEL     'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
     C                   MOVEL     'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
     C                   MOVEL     'N'           CLE004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE004
     C                   END
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVEL     'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
     C                   END
      *
     C                   MOVEL     'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
      *
     C                   MOVEL     'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *
     C                   MOVEL     'N'           CLE023            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   END
      *
     C                   MOVEL     'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
     C                   MOVEL     'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   MOVEL     'LERMSGF '    ZAMSGF
      *
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   Z-ADD     0             AmIdx
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'D'           M2MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
