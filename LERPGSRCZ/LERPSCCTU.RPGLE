     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments schedule - control update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LERPSCCTU - LE Repayments Schedule - Control Update          *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             Repayments schedule.                              *
      *             It is a batch function.                           *
      *            Processes executed controlled by input Action Code *
      *            - For A (=Amend)                                   *
      *              - Validate the Repayment Sch. details fields     *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise)                               *
      *              - Validate the Repayment Sch. details fields     *
      *              - Validate the settlement fields                 *
      *              (Repayments Sch. are only sent from Loan Manager *
      *               if authorised; validation need to be done here) *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR991378           Date 18Jun12               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 CDL094             Date 11Jun14               *
      *                 AR868380           Date 11Jun13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246767             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4960            Date 22Dec04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CAP084             Date 31Jul03               *
      *                 CAP079  *CREATE    Date 18Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR991378 (Child  AR991379). Loans Events Modeller (CLE068)   *
      *           The validation of Total being paid and Loan         *
      *           Outstanding Principal should consider events being  *
      *           Modelled by LEM (Loan Events Modeller)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246767 -Wrong RetcodeOut used after UPD_DBASE Routine        *
      *          Missing Infdata Parm in LERPSC1VL (CAP086)           *
      *          Missing *entry Parm Extdata                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it (Recompile)                              *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      *
     FLEIRPSCPD O  A E             DISK    INFSR(*pssr)
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
      /COPY WNCPYSRC,LERPSCCT01
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
     D TranInScr     E DS                  EXTNAME(LERPSCPD)
      ***  Repayments schedule Details in screen format
      *
     D OKFlagsDS     E DS                  EXTNAME(LEERPSCPD)
      ***  Repayments schedule Details OK indicator
      *
     D ValidRPSC     E DS                  EXTNAME(LEVRPSCPD)
      ***  New Repayment schedule Details in file format
     D***RSREC**              321    389                                                      CGL029
     D***RSPAY**              390    948                                                      CGL029
     D  RSREC                335    389                                                       CGL029
     D  RSPAY                404    948                                                       CGL029
     D  RSRECEx             1195   1212                                                       CGL029
     D  RSPAYEx             1213   1230                                                       CGL029
      *
     D CRpScFilFmt   E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(L)
      ***  Repayment in File Format
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
     D RpScScnFmt    E DS                  EXTNAME(LERPSCPD)
      ***  Current Repayments schedule Details in screen format
     D                                     PREFIX(C_)
      *
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  246767
      * LE Extra Data - Classe 1 Data - File (D/B) format                                     246767
     D                                     PREFIX(IF_)                                        246767
     D ExtData       E DS                  EXTNAME(LERPEXPD)
      ***  LE Rollover Instructions Extra Data - File (D/B) format
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
     D P#InMf        E DS                  EXTNAME(LEP1MFPD)
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029
      ***  IN Message Format
     D  P#TSEQ                52     55  0
     D  PISPIS               122    211
     D  PISPI1               122    151
     D  PISPI2               152    181
     D  PISPI3               182    211
     D***P#PONS*              217    228                                                      CGL029
     D***P#RONS*              427    438                                                      CGL029
     D  PIDTPA               494    633
     D  PIDTP1               494    528
     D  PIDTP2               529    563
     D  PIDTP3               564    598
     D  PIDTP4               599    633
     D  PIBTBA               637    846
     D  PIBTB1               637    671
     D  PIBTB2               672    706
     D  PIBTB3               707    741
     D  PIBTB4               742    776
     D  PIBTB5               777    811
     D  PIBTB6               812    846
     D  P#PONS               943    963                                                       CGL029
     D  P#RONS               964    984                                                       CGL029
      *
     D P#OuMf        E DS                  EXTNAME(LEP2MFPD)
      ***  OUT Message Format
      *
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
      *
     D TimeStamp       S             26Z
      ***  Timestamp for the transaction
      *
      ***  Date fields used in call to ZDATE10
     D DateIn          S              8S 0
     D ZZMDNO          S              5  0
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                               TDA070 BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      *
     D/COPY WNCPYSRC,LERPSCCT02
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Start of Main processing
      *****************************************************************
      *
      ***  Initialisation
      *
      /COPY WNCPYSRC,LERPSCCT03
     C                   EXSR      INITPR
      /COPY WNCPYSRC,LERPSCCT04
      *
      ***  Map incoming data into the screen fields
      *
      /COPY WNCPYSRC,LERPSCCT05
     C                   EXSR      MAPFLD
      /COPY WNCPYSRC,LERPSCCT06
      *
      ***  Validate action code
      *
      /COPY WNCPYSRC,LERPSCCT07
     C                   EXSR      ValidateAc
      /COPY WNCPYSRC,LERPSCCT08
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
      /COPY WNCPYSRC,LERPSCCT09
     C                   EXSR      ValidateTR
      /COPY WNCPYSRC,LERPSCCT10
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
      /COPY WNCPYSRC,LERPSCCT11
     C                   EXSR      ValidateTR
      /COPY WNCPYSRC,LERPSCCT12
      *
     C                   EXSR      ValidateAMD
      *
      /COPY WNCPYSRC,LERPSCCT13
     C                   EXSR      ValidateST
      /COPY WNCPYSRC,LERPSCCT14
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ***  Do updates for this transaction
      ***  according to whether it is valid or invalid
      *
     C     Idx           IFEQ      0
      /COPY WNCPYSRC,LERPSCCT15
     C                   EXSR      UPDAT_VAL
      /COPY WNCPYSRC,LERPSCCT16
     C                   ENDIF
     C     Idx           IFNE      0
      /COPY WNCPYSRC,LERPSCCT17
     C                   EXSR      UPDAT_INVAL
      /COPY WNCPYSRC,LERPSCCT18
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
     C     MAPFLD        BEGSR
      *
      ***  Assume repair is in Front Office
      *
     C                   MOVEL     'F'           RPLOC             1
      *
      ***  Repayment schedule details
      *
     C                   CLEAR                   TranInScr
      *
     C                   MOVE      P1LNRF        DDLNRF
     C                   MOVEL     P1ACTN        DDACTN
     C                   MOVE      P1LASN        DDSEQN
      *
      ***  Convert NA sale date to MIDAS day number.
      *
     C                   MOVE      P1VDAT        DateIn
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
     C                   MOVE      ZDateFmt6     DDVDAT
      *
     C                   MOVE      P1CNUM        DDCUST
     C                   MOVEL     P1CCY         DDCURR
     C                   MOVE      P1PRAM        DDSAMT
     C                   MOVEL     P1AUTO        DDAUTO
     C                   MOVE      PISPI1        DDSPI1
     C                   MOVE      PISPI2        DDSPI2
     C                   MOVE      PISPI3        DDSPI3
      *
      ***  Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      P1RSTM        FLRSTM
     C                   MOVE      P1RONS        FLRONS
     C                   MOVEL     P1ROBR        FLROBR
     C                   MOVE      P1RIBN        FLRIBN
     C                   MOVE      P1RIBA        FLRIBA
     C                   MOVE      P1ROBN        FLROBN
     C                   MOVE      P1ROCN        FLROCN
     C                   MOVE      P1SCCY        FLRSCY
      *
      ***  Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      P1PSTM        FLPSTM
     C                   MOVE      P1PONS        FLPONS
     C                   MOVEL     P1ROBR        FLPOBR
     C                   MOVE      P1PIBN        FLPIBN
     C                   MOVE      P1PIBA        FLPIBA
     C                   MOVE      P1POBN        FLPOBN
     C                   MOVE      P1POCN        FLPOCN
     C                   MOVE      P1CVMR        FLCVMR
     C                   MOVE      P1RCRN        FLRCRN
     C                   MOVE      P1RCRA        FLRCRA
     C                   MOVE      P1RVNO        FLRVNO
     C                   MOVE      P1AWBN        FLAWBN
     C                   MOVE      P1AWBA        FLAWBA
     C                   MOVE      P1BENN        FLBENN
     C                   MOVE      P1BENA        FLBENA
     C                   MOVEL     PIDTP1        FLDTP1
     C                   MOVEL     PIDTP2        FLDTP2
     C                   MOVEL     PIDTP3        FLDTP3
     C                   MOVEL     PIDTP4        FLDTP4
     C                   MOVE      P1DCHG        FLDCHG
     C                   MOVEL     PIBTB1        FLBTB1
     C                   MOVEL     PIBTB2        FLBTB2
     C                   MOVEL     PIBTB3        FLBTB3
     C                   MOVEL     PIBTB4        FLBTB4
     C                   MOVEL     PIBTB5        FLBTB5
     C                   MOVEL     PIBTB6        FLBTB6
      *
     C                   MOVE      P1SCCY        FLPSCY
     C                   MOVE      P1ICCY        FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      P1SCCY        DDRSCY                                       CLE031
     C                   MOVE      P1REXR        DDREXR                                       CLE031
     C     P1REXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      P1REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
     C                   CALL      'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             1                          CLE031
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
     C                   MOVE      P1REXI        DDREXI                                       CLE031
     C     P1REXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVE      P1PSCY        DDPSCY                                       CLE031
     C                   MOVE      P1PEXR        DDPEXR                                       CLE031
     C     P1PEXR        IFNE      *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      P1PEXR        ZFIELD           16                          CLE031
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
     C                   MOVE      P1PEXI        DDPEXI                                       CLE031
     C     P1PEXI        IFEQ      'N'                                                        CLE031
     C                   MOVE      *BLANKS       DDPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
      *
     C                   CALLB     'LERPSCRTV'
      *
      ***  INPUTS
      *    ======
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  Mode
     C                   PARM                    ModeofOp
      *
      ***  Response mode
     C**********         PARM      ' '           RespMode          1                          CAP084
     C                   PARM      'S'           RespMode          1                          CAP084
      *
      ***  Action Code
     C                   PARM                    DDACTN
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  (Midas) Loan Number
     C                   PARM                    DDLNRF
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN            3
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT            6
      *
      ***  OUTPUTS
      *    =======
      *
      ***  (Current) Repayment in file format
     C                   PARM                    CRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ***  OK - Loan Number
     C                   PARM      *BLANK        DDLNRFOK
      *
      ***  OK - Sequence no.
     C                   PARM                    DDSEQNOK
      *
      ***  OK - Value date
     C                   PARM                    DDVDATOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
      *
      ***  Save the settlement details for update
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
     C                   MOVEL     LSPI1         OSPI1
     C                   MOVEL     LSPI2         OSPI2
     C                   MOVEL     LSPI3         OSPI3
      *
      ***  Save the last update for test
      *
     C                   Z-ADD     LLCD          WLCD
     C                   MOVE      LCHTP         WCHTP
     C                   Z-ADD     LTNLU         WTNLU
     C                   MOVE      WLSTC         SAVLC
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTR    BEGSR
      *
     C                   MOVEL     CRpScFilFmt   ValidRPSC
      *
     C                   CALLB     'LERPSC1VL'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Response mode (1A), from source system common header
     C**********         PARM                    P#Mode                                       CAP084
     C                   PARM      'S'           P#Mode                                       CAP084
      *
      ***  Repayment schedule Details in screen format
     C                   PARM                    TranInScr
      *                                                                                       246767
     C                   PARM                    InfData                                      246767
      *
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  OUTPUTS
      ***  =======
      *
      ***  Field OK flags
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      *
      ***  Valid file layout (DS) from/to caller
     C                   PARM                    ValidRPSC
      *
      ***  Processing type in CLOANCL file
     C                   PARM                    PTypFilCLOAN      2
      *                                                                                      BUG4960
      ***  Branch in CLOANCL file                                                            BUG4960
     C                   PARM                    BrcaFilCLOAN      3                         BUG4960
     C                   PARM      *BLANKS       WDDSTAT          16                        AR991378
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
      *
      ***  The settlements instructions are in file format, but the
      ***  Settlements validation requires that they are in the input format.
      ***  Therefore convert the file format to screen format.
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
      *
      ***  Settlement Instruction in input format
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
      ***  Validate the Settlement instructions
      *
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
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan type
     C**********         PARM      LLTYP         ##TTYP            2                         BUG4960
     C                   PARM      PtypFilCLOAN  ##TTYP            2                         BUG4960
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Booking Branch
     C**********         PARM      RPBRCA        ##BRCA            3                         BUG4960
     C                   PARM      BrcaFilCLOAN  ##BRCA            3                         BUG4960
      *
      ***  Receipt Date
     C                   PARM      RPVDAT        ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM      RPVDAT        ##DATP            5 0
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
      *
      ***  Save the new settlement details for update
      *
     C     PTypFilCLOAN  IFEQ      '66'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '69'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '72'
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLPSCY        WSCCY             3
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLRSCY        WSCCY             3
     C                   ENDIF
      *
     C                   END
      *
     C                   MOVEL     FLBENN        WFACO            10
     C                   MOVE      WSETP         WTYPE             2
      *
      ***  Update Repayment schedule in file format
      *
     C**********         MOVEL     F_PAY         RSPAY                                        CGL029
     C**********         MOVEL     F_REC         RSREC                                        CGL029
     C                   MOVEL     FLREC         RSREC                                        CGL029
     C                   MOVEL     FLRONS        RSRECEx                                      CGL029
     C                   MOVEL     FLRSTM        RPRSTM                                       CGL029
     C                   MOVEL     FLPAY         RSPAY                                        CGL029
     C                   MOVEL     FLPONS        RSPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        RPPSTM                                       CGL029
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        RPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        RPPEXR                                       CLE031
     C                   MOVE      FLREXI        RPREXI                                       CLE031
     C                   MOVE      FLPEXI        RPPEXI                                       CLE031
     C                   MOVE      FLRSCY        RPSCCY                                       CLE031
     C                   MOVE      FLPSCY        RPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     ValidRPSC     CRpScFilFmt
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
     C                   CALLB     'LERPSCCVT'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  File format
     C                   PARM                    CRpScFilFmt
      *
      ***  OUTPUT
      ***  ======
      *
      ***  Repayment schedule in screen format
     C                   PARM                    RpScScnFmt
      *
      *
     C                   CALLB     'LERPSCAMD'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  New Repayment schedule in Screen Format :
     C                   PARM                    TranInScr
      *
      ***  (Current) Repayment schedule in Screen Format :
     C                   PARM                    RpScScnFmt
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
      ***  Array index (3P0) from/to caller
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
     C                   Z-ADD     AmIdx         Idx
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
     C                   EVAL      DDFOTRANID = P1TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'
     C                   EVAL      DDTMESTMP = TimeStamp
     C                   EVAL      DDMsgType  = 'LERPSC'
      *
     C                   WRITE     LEIRPSCD0
     C                   WRITE     APIDSETD0
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
     C                   MOVE      P1MSGT        P2MSGT
     C                   MOVE      P1TRUS        P2TRUS
     C                   MOVE      P1TRWS        P2TRWS
     C                   MOVE      P1TNRF        P2TNRF
     C                   MOVE      P1TRSN        P2TRSN
     C                   MOVE      P1ACTN        P2ACTN
     C                   MOVE      P1TRDS        P2TRDS
     C                   MOVE      P1TRTS        P2TRTS
     C                   MOVE      P1NRBA        P2NRBA
     C                   MOVEL     'E'           P2MSGS
     C                   MOVEL     ZAMSID        P2MSGI
     C                   MOVEL     ZAMSTX        P2MSTX
     C                   MOVE      P1LNRF        P2LNRF
     C                   MOVE      P1VDAT        P2VDAT
     C                   MOVE      P1LASN        P2LASN

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
     C*****RetCodeOut    IFNE      *BLANKS                                                    246767
     C     @@RTCD        IFNE      *BLANKS                                                    246767
      *
     C                   ADD       1             Idx
     C     @@RTCD        IFEQ      '*RECLCK'                                                AR868380
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
     C                   MOVE      P1MSGT        P2MSGT
     C                   MOVE      P1TRUS        P2TRUS
     C                   MOVE      P1TRWS        P2TRWS
     C                   MOVE      P1TNRF        P2TNRF
     C                   MOVE      P1TRSN        P2TRSN
     C                   MOVE      P1ACTN        P2ACTN
     C                   MOVE      P1TRDS        P2TRDS
     C                   MOVE      P1TRTS        P2TRTS
     C                   MOVE      P1NRBA        P2NRBA
     C                   MOVE      P1LNRF        P2LNRF
     C                   MOVE      P1VDAT        P2VDAT
     C                   MOVE      P1LASN        P2LASN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *****************************************************************
     C     SetupAmend    BEGSR
      *
      ***  For Amends, put the complete (pre-existing) repayment into the Valid
      ***  file record - fields in this will be updated during processing
      *
     C                   MOVE      CRpScFilFmt   ValidRPSC
      *
      ***  Do data substitution for Settlement Instructions
      *
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      S_REC                                  99
     C  N99GHSUBS        scan      S_PAY                                  99
     C     *in99         ifeq      *on
     C                   EXSR      SDtDtaSubs
     C                   endif
     C                   endif
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *****************************************************************
     C     TDtDtaSubs    BEGSR
      *
      ***  Conversion of file fields to screen format
      *
     C                   CALLB     'LERPSCCVT'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      ***  File format
     C                   PARM                    CRpScFilFmt
      *
      ***  OUTPUT
      ***  ======
      *
      ***  Repayment schedule in screen format
     C                   PARM                    RpScScnFmt
      *
      ***  Data substitution
      *
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM      *BLANKS       ReturnCode       10
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      *
      ***  Incoming Data
     C                   PARM      TranInScr     IncDATA        2000
      *
      ***  Current Data
     C                   PARM      RpScScnFmt    CurDATA        2000
      *
     C                   MOVEL     IncDATA       TranInScr
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *****************************************************************
     C     SDtDtaSubs    BEGSR
      *
      ***  Payment instructions
      *
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM      *BLANKS       ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      S_PAY         IncDATA
      *
      ***  Current Data
     C                   PARM      C_PAY         CurDATA
      *
     C                   MOVEL     IncDATA       S_PAY
      *
      ***  Receipt instructions
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM      GHSUBS        SubsChar
      *
      ***  Incoming Data
     C                   PARM      S_REC         IncDATA
      *
      ***  Current Data
     C                   PARM      C_REC         CurDATA
      *
     C                   MOVEL     IncDATA       S_REC
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
     C                   EVAL      RPCHTP = 'A'
      *
     C                   CALLB     'LERPSCUPD'
      *
      ***  INPUTS
      ***  ======
      *
      ***  Return Code
     C                   PARM      *BLANK        @@RTCD            7
      *
      ***  Externally described DS for valid repayment schedule
     C                   PARM                    ValidRPSC
      *
      ***  Old settlement details
     C                   PARM                    OldStsDS
      *
      ***  New settlement details
     C                   PARM                    NewStsDS
      *
      ***  Data
     C                   PARM                    PasDtaDS
      *
      ***  OUTPUTS
      ***  =======
      *
      ***  Field OK flags
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
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
     C                   PARM                    ExtData                                      246767
      *                                                                                       246767
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
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE005
     C                   ELSE
      *
      ***  Database error
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     @SARD         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU004            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU004
     C                   ELSE
      *
      ***  Database error
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @SARD         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
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
     C                   MOVE      'D'           P2MSGS
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,LERPSCCT19
     C                   ENDSR
      *****************************************************************
      /COPY WNCPYSRC,LERPSCCT20
**  CPY@
(c) Finastra International Limited 2002
