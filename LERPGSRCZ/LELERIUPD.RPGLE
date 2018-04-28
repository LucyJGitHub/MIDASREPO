     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)                 *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instr database update function')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIUPD - Rollover Instructions Update function module     *
      *                                                               *
      *  Function:  This is the update function for the Rollover      *
      *             Instructions                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD028338           Date 25Nov14               *
      *  Prev Amend No. AR826115           Date 07Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR820267           Date 25Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CAP207             Date 11Apr11               *
      *                 CLE139             Date 06Dec10               *
      *                 262581             Date 25Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      *                 246696             Date 28Mar07               *
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9507            Date 06Dec05               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3760            Date 22Jul04               *
      *                 BUG827             Date 05May04               *
      *                 BUG19  (CAP084)    Date 09Jan04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CDE005             Date 23Sep02               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 03May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Add new  *
      *             field to flag rollover as 'FX Rate Change Only'.  *
      *  AR826115 - Original base rate on rollover should be applied  *
      *             to Spread Rate when BPBRCF='N'. (Child: AR826116) *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR820267 - Mapping error and Contractual Spread error not    *
      *             recognized                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CAP207 - LERI maintenance is not creating shadow posts.      *
      *           Applied fix 261894.                                 *
      *  261894 - Incorrect Customer Balance                          *
      *           Resolution was formed based on shadow posting fixes *
      *           done to LE2070(LERI equiv in Midas R4)              *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  262581 - The validation added by CAS019 is not necessary,    *
      *           since the new maturity date can only be amended     *
      *           to be after the current maturity date.              *
      *           Also, ensure End Amortisation Date is changed on    *
      *           all fees attached to a loan only when loans file    *
      *           is updated.                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019  - Upgrade of CAS016 to Midas Plus.                   *
      *  246696 - Rollover status from valid file not updated         *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9507- Field NBSR is switchable under CLE036.              *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits.       *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs                                       *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  BUG19  - API wrapper project (CAP084)                        *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CDE005   Reservation ID                                      *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
 
     FCLOANX    UF A E           K DISK    COMMIT
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(*PSSR)
     F                                     USROPN
      * Midas LE Transaction Details Master File
 
     F***LTRIX**** UF   F   43        DISK    INFSR(*PSSR)                                  AR322732
     FLTRIX     O  A F   45        DISK    INFSR(SRERR)                                     AR322732
     F                                     COMMIT
      * Midas LE Loans Transactions Index File
 
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
                                                                                             BUG3760
     FLEEIRDL5  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     COMMIT                                             CAS011
      *****************************************************************
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEERAPL0  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
      ** Midas LE Fee Details                                                                 CAS019
     FLEFEEDLH  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     IGNORE(LEFHSTF)                                    262581
     F****                                 COMMIT                                             CAS019
      *                                                                                       CAS019
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D CrLnFilFmtL   E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D CrLnFilFmtK   E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(CHK)
      ** Rename fields for Timestamp checking
 
     D ValidloanL    E DS                  EXTNAME(LEVLERLPD)
     D                                     PREFIX(L_)
      ***  New Loan in File Format CL
 
     D ValidloanK    E DS                  EXTNAME(LEVLERKPD)
      ***  New Loan in File Format CK
     D                                     PREFIX(K_)
 
     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
      * Error indicators
 
 
      **  Loan Details File
     D CLOANLDS      E DS                  EXTNAME(CloanCL)
 
     D CLOANKDS      E DS                  EXTNAME(CloanCK)
     D  @KRECI       E                     EXTFLD(RECI)
     D  @KLNRF       E                     EXTFLD(LNRF)
     D  @KRCDT       E                     EXTFLD(RCDT)
     D  @KMRIN       E                     EXTFLD(MRIN)
     D  @KORED       E                     EXTFLD(ORED)
     D  @KLCD        E                     EXTFLD(LCD)
     D  @KCHTP       E                     EXTFLD(CHTP)
     D  @KTNLU       E                     EXTFLD(TNLU)
     D  @KFRNT       E                     EXTFLD(FRNT)
     D  @KAFRT       E                     EXTFLD(AFRT)
     D  @KREPA       E                     EXTFLD(REPA)
     D  @KTMST       E                     EXTFLD(TMST)
 
 
      * Data Structures for use with access programs
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structure for SAR details
     D  SCLCD        E                     EXTFLD(LCD)
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** EXTERNAL DS FOR CUSTOMER LENDING ICD
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
      ** External DS for Customer Details                                                    BUG3760
                                                                                             BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      ** External DS for Compliance Watch Transaction Details                                BUG3760
                                                                                             BUG3760
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
      ** Watch List Transaction Details Data Structure                                       BUG3760
                                                                                             BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
      ** External DS for Watch List Configuration Data                                       BUG3760
                                                                                             BUG3760
     D PFreeFmtStr     S          30000A                                                     BUG3760
      ** Compliance Engine Free Format String Parameter                                      BUG3760
                                                                                             BUG3760
     D Elements        C                   CONST(13)                                         BUG3760
      ** Array Size Definition                                                               BUG3760
                                                                                             BUG3760
     D WLF             S             18A   DIM(Elements)                                     BUG3760
      ** Watch List Fields Array.                                                            BUG3760
                                                                                             BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      ** 24X7 status data area                                                               BUG3760
                                                                                             BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
      ** SD data area                                                                        BUG3760
                                                                                             BUG3760
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D @Timestamp      S             26Z
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D T#TREF          S             26A                                                      CGL029
 
      ** Fields used in call to ZF2C
     D DateIn          S              5  0
     D FirstCcy        S              3A
     D FirstLoc        S              3A
     D SecondCcy       S              3A
     D SecondLoc       S              3A
     D NumDaysFwd      S              2S 0
     D DayNumber       S              5  0
 
     D CAS009          S              1                                                       CAS011
     D CAS016          S              1                                                       CAS019
     D CSD015          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CSC011          S              1                                                      BUG3760
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CLE036          S              1A   INZ('N')                                          BUG9507
     D CRE073          S              1A   INZ('N')                                           CRE073
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D WLChgFlg        S              1    INZ('N')                                          BUG3760
     D WXMLPacket      S            310                                                      BUG3760
     D WData           S            216                                                      BUG3760
     D Ctr             S              2P 0                                                   BUG3760
     D ConvertedAmt    S             18P 3                                                   BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PCust           S             10                                                      BUG3760
     D PStKey          S              7                                                      BUG3760
     D PAmt            S             15                                                      BUG3760
     D PCcy            S              3                                                      BUG3760
     D PFmtCCY         S              3                                                      BUG3760
     D PDummy6         S              6                                                      BUG3760
     D PDummy16        S             16                                                      BUG3760
     D PDummy35        S             35                                                      BUG3760
     D PZARtCd         S              7                                                      BUG3760
     D PZADayNo        S              5                                                      BUG3760
     D PZADDT          S               D                                                     BUG3760
     D PZACvtDt        S             10                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WDtlOPay        S              1                                                      BUG3760
     D WRLDT1          S              1                                                       CAS011
                                                                                             BUG3760
      ** Fields used in call to ZTNLU1
     D PNatn           S              5P 0
 
     D OVRDBF          C                   'OVRDBF FILE(CLOANX)-
     D                                       TOFILE(CLOAN) SHARE(*NO)'
 
     D LNOST           S              2    DIM(3) CTDATA PERRCD(3)
      **  Array containing valid settlement types for loan ccy.
 
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      ** XML Opening Tags for the Compliance Engine                                          BUG3760
                                                                                             BUG3760
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      ** XML Closing Tags for the Compliance Engine                                          BUG3760
                                                                                             BUG3760
     D Z#BSTS        E DS                  EXTNAME(Z#BST)                                     261894
      ***  before image of update to LE position files                                        261894
     D Z#ASTS        E DS                  EXTNAME(Z#AST)                                     261894
      ***  after image of update to LE position files                                         261894
     D Z#WSTS        E DS                  EXTNAME(Z#WST)                                     261894
      ***  work file of update to LE position files                                           261894
     D Z#BSTK          DS          2048                                                       261894
     D Z#ASTK          DS          2048                                                       261894
                                                                                              261894
     D CLONQD        E DS                  EXTNAME(LESTMP2PD)                               AR820267
      ** Externally desc'd DS for screen Loans extension                                    AR820267
                                                                                            AR820267
      ** Data structure to define LTRIX fields                                              AR322732
     D*LNRFX****       S              6S 0                                           AR322732 CLE148
     D LNRFX           S              6                                                       CLE148
     D CHTPX           S              1                                                     AR322732
     D TNLUX           S              5P 0                                                  AR322732
     D BRCAX           S              3                                                     AR322732
 
      ** Need to describe internally as only one format available
     I*LTRIX**** NS        1 CH                                                             AR322732
      ***Transaction*index*header**************************************                     AR322732
     I**********                        1    1  RECIX                                       AR322732
     I**********                        2    2  RCDTX                                       AR322732
     I**********                        3    8 0LNRFX                                       AR322732
     I**********                   P    9   11 0NOREX                                       AR322732
     I**********                   P   12   14 0FLSZX                                       AR322732
     I**********                   P   15   17 0RRLCX                                       AR322732
     I**********                   P   18   20 0RRNAX                                       AR322732
     I**********                   P   21   23 0RRLXX                                       AR322732
     I**********                   P   24   26 0RRXPX                                       AR322732
     I**********                   P   27   29 0NLNRX                                       AR322732
     I**********                   P   30   32 0NLARX                                       AR322732
     I**********                       33   33 0STPIX                                       AR322732
     I**********                   P   38   40 0TNLUX                                       AR322732
      *
     I**********NS        1 CD                                                              AR322732
      ***Transaction*index*detail**************************************                     AR322732
     I**********                        1    1  RECIX                                       AR322732
     I**********                        2    2  RCDTX                                       AR322732
     I**********                        3    8 0LNRFX                                       AR322732
     I**********                        9   13 0VDATX                                       AR322732
     I**********                       14   16 0LASNX                                       AR322732
     I**********                       17   17  CHTPX                                       AR322732
     I**********                       18   18  CNRQX                                       AR322732
     I**********                       19   19  CNPRX                                       AR322732
     I**********                       20   20  REPRX                                       AR322732
     I**********                       21   25 0RRLAX                                       AR322732
     I**********                       26   26  LADIX                                       AR322732
     I**********                       27   27 0PRI1X                                       AR322732
     I**********                       32   34  BRCAX                                       AR322732
     I**********                   P   35   37 0RRNTX                                       AR322732
     I**********                   P   38   40 0TNLUX                                       AR322732
     I**********                       41   41 0PRI2X                                       AR322732
     I**********                       42   42 0PRI3X                                       AR322732
     I**********                       43   43 0PRI4X                                       AR322732
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
      *
      ** Retrieve next available transaction number.
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM                    @@RTCD
     C                   PARM                    PNATN
 
      ** If called from CTU and action is Authorise, need to perform
      ** update for Amend and Authorisation
 
     C     @@CTU         IFEQ      'Y'
     C     @@ACTN        ANDEQ     'X'
     C     @@ACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   EXSR      AMEND
     C                   EXSR      AUTHOR
     C                   ELSE
 
      ** Amend or Authorise
 
     C     @@ACTN        CASEQ     'A'           AMEND
     C     @@ACTN        CASEQ     'X'           AUTHOR
     C     @@ACTN        CASEQ     'Q'           AUTHOR                                       CLE030
     C                   ENDCS
 
     C                   ENDIF
 
      ** Data export for CCRM - Limits
 
     C     CDE001        IFEQ      'Y'
     C                   MOVEL     L_CLLNRF      T#TREF
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LOAN'        T#TCAT            4
     C                   PARM                    ResrvId          10                          CDE005
     C                   ENDIF
 
      * Exit From Program
     C     EXIT          TAG
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Customer details
 
     C                   MOVE      L_CLLNRF      MidasLnrf         6
 
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      * Allow access to transaction record by Front-Office ID when in Repair
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~
      *                 b) action code is Insert - 'I'
      *                 c) Front-Office Id is NOT Blank
      *
     C                   IF        @Type = '1' AND
     C                             @@ACTN = 'I' AND
     C                             L_CLFRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE
      *
      * Otherwise, if running in batch use Front-Office ID
      *            (if insert)
      *            else, use Midas Deal Number
      *
     C                   IF        @Type = '0' AND
     C                             @@ACTN = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
 
 
     C                   CALLB     'LELERIRTV'
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      * Response mode
     C                   PARM      ' '           @@RSMD            1
      * Action Code
     C                   PARM      @@ACTN        ACTN              1
      * Front Office Transaction ID
     C                   PARM      L_CLFRNT      FOTRID           20
      * Midas Transaction Number
     C                   PARM                    MidasLnrf         6
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      *
      * Outputs
      *
      * (Current) loan in file format CL
     C                   PARM                    CrLnFilFmtL
      * (Current) loan in file format CK
     C                   PARM                    CrLnFilFmtK
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      * OK - Transaction Number
     C                   PARM                    DDLNRFOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C                   IF        @TYPE = '1'
 
     ** CloanCL
     C                   IF        CHTMST <> L_CLTMES
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
     ** CloanCK
     C                   IF        CHKTMST <> K_CLTMES
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDLNRFOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError         132
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a Loan                                        *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access Loan record (CLOANCL)
 
     C     L_CLLNRF      CHAIN     CLOANCLF                           99
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     L_CLLNRF      DBKEY
     C                   EVAL      DBFILE = 'CLOANCLF'                          ************
     C                   EVAL      DBASE  = 001                                 * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
                                                                                              261894
     C                   MOVEL     CrLnFilFmtL   Z#BSTS                                       261894
 
      ** If CAS009 is On, update LEEIRDPD records depending on                                CAS011
      ** action being done.                                                                   CAS011
      *                                                                                       CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
      *                                                                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     L_CLLNRF      CHAIN     LEEIRDL9                           20                      CAS019
     C                   ELSE                                                                 CAS019
     C     L_CLLNRF      CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C                   IF        *IN20 = '0'                                                CAS011
      *                                                                                       CAS011
      ** If Action is amend and rollover date is within this                                  CAS011
      ** EIR record's start and end dates, set to 'Y'                                         CAS011
      ** indicator fields accordingly.                                                        CAS011
      *                                                                                       CAS011
     C                   MOVEL     L_CLRLDT      WRLDT1                                       CAS011
      *                                                                                       CAS011
     C                   SELECT                                                               CAS011
     C     @@ACTN        WHENEQ    'A'                                                        CAS011
     C     RLDT          ANDLE     EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIADJP                                       CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 ='Y'                                                CAS019
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS011
      ** If Action is reverse                                                                 CAS011
      *                                                                                       CAS011
     C     WRLDT1        WHENEQ    '*'                                                        CAS011
      *                                                                                       CAS011
      ** If Rollover date is equal to end date, then                                          CAS011
      ** set Adjustment to EIR to 'Y'.                                                        CAS011
      *                                                                                       CAS011
     C     RLDT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIADJP                                       CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS011
     C                   ENDSL                                                                CAS011
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** ENDIF of CAS011                                                                      CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** If CAS016 is On, update LEERADPD records depending on                                CAS019
      ** action being done.                                                                   CAS019
      *                                                                                       CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
      *                                                                                       CAS019
      ** Set recalculation indicator to 'Y' for all records in EIR amortise over period       CAS019
      ** detail file if value date of the rollover is within the EIR period or                CAS019
      ** before the EIR period                                                                CAS019
      *                                                                                       CAS019
     C     L_CLLNRF      CHAIN     LEERAPL0                           21                      CAS019
     C                   DOW       *IN21 = *OFF                                               CAS019
     C                   IF        @@ACTN = 'A' AND                                           CAS019
     C                             L_CLRLDT <= EIENDT                                         CAS019
     C                   MOVE      'Y'           EIRCAL                                       CAS019
     C                   UPDATE    LEERAPD0                                                   CAS019
     C                   ENDIF                                                                CAS019
     C     L_CLLNRF      READE     LEERAPL0                               21                  CAS019
     C                   ENDDO                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** New Maturity Date                                                                    CAS019
      *                                                                                       CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
      *                                                                                       CAS019
      ** Check for valid values of maturity date when amortising fees exist                   CAS019
      *                                                                                       CAS019
     C**********         IF        @@ACTN = 'A' AND                                    CAS019 262581
     C**********                   L_CLNMDT <> *ZEROS                                  CAS019 262581
     C                   IF        L_CLNMDT <> *ZEROS                                         262581
     C     L_CLLNRF      CHAIN     LEFEEDF                            21                      CAS019
     C**********         DOW       *IN21 = *ON                                         CAS019 262581
     C                   DOW       *IN21 = *OFF                                               262581
      *                                                                                       CAS019
      ** Change Amortisation end date accordingly if loan's maturity date has changed         CAS019
      *                                                                                       CAS019
     C                   IF        FEAMRI = 'N' AND                                           CAS019
     C                             FERECI <> 'R' AND                                          262581
     C**********                   FESTPD > BJRDNB AND                                 CAS019 262581
     C                             FEENPD <> L_CLNMDT                                         CAS019
     C                   MOVE      L_CLNMDT      FEENPD                                       CAS019
     C                   MOVE      'A'           FELCHT                                       262581
     C                   Z-ADD     BJRDNB        FELCHD                                       262581
     C                   UPDATE    LEFEEDF                                                    CAS019
     C                   ENDIF                                                                CAS019
     C     L_CLLNRF      READE     LEFEEDF                                21                  CAS019
     C                   ENDDO                                                                CAS019
      **********                                                                       CAS019 262581
      ***Check*for history records                                                     CAS019 262581
      **********                                                                       CAS019 262581
     C*****L_CLLNRF      CHAIN     LEFHSTF                            21               CAS019 262581
     C**********         DOW       *IN21 = *ON                                         CAS019 262581
      **********                                                                       CAS019 262581
      ***Change*Amortisation end date accordingly if loan's maturity date has changed  CAS019 262581
      **********                                                                       CAS019 262581
     C**********         IF        HIAMRI = 'N' AND                                    CAS019 262581
     C**********                   HISTPD > BJRDNB AND                                 CAS019 262581
     C**********                   HIENPD <> L_CLNMDT                                  CAS019 262581
     C**********         MOVE      L_CLNMDT      HIENPD                                CAS019 262581
     C**********         UPDATE    LEFHSTF                                             CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
      **********                                                                       CAS019 262581
     C*****L_CLLNRF      READE     LEFHSTF                                21           CAS019 262581
     C**********         ENDDO                                                         CAS019 262581
      *                                                                                       CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      ** Set Transaction Detail fields on amend
      ** (only the fields changed by the Rollover function)
 
     C                   EVAL      RLDT = L_CLRLDT
     C                   EVAL      NROD = L_CLNROD
     C                   EVAL      RLFQ = L_CLRLFQ
     C                   EVAL      RLDY = L_CLRLDY
     C                   EVAL      NBRA = L_CLNBRA
     C                   EVAL      NRTS = L_CLNRTS
     C                   EVAL      NSIN = L_CLNSIN
     C                   EVAL      NCHI = L_CLNCHI
     C                   EVAL      NCAS = L_CLNCAS
     C                   EVAL      NIDT = L_CLNIDT
     C                   EVAL      IBDT = L_CLIBDT
     C                   EVAL      NIPD = L_CLNIPD
     C                   EVAL      NMDT = L_CLNMDT
     C                   EVAL      NFRS = L_CLNFRS
     C                   EVAL      NFSN = L_CLNFSN
     C                   EVAL      NFPC = L_CLNFPC
     C                   EVAL      PCOB = L_CLPCOB
     C                   EVAL      PCRF = L_CLPCRF
     C                   EVAL      MDAT = L_CLMDAT
     C                   EVAL      NMDT = L_CLNMDT
     C                   IF        CLE036 = 'Y'                                              BUG9507
     C                   EVAL      NBSR = L_CLNBSR                                            CLE035
     C                   ENDIF                                                               BUG9507
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      NNSP = L_CLCNSP                                            CRE073
     C                   EVAL      NNSG = L_CLCNSG                                            CRE073
     C                   EVAL      NDMT = L_CLRDMT                                            CRE073
     C                   EVAL      NDFD = L_CLRDFD                                            CRE073
     C                   ENDIF                                                                CRE073
      *
     C                   Z-ADD     BJRDNB        LCD
      *
     C                   EVAL      TNLU = PNATN
      ** Last Change Type
     C                   EVAL      CHTP = L_CLCHTP
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
      ** Front Office ID
     C                   EVAL      FRNT=L_CLFRNT
      ** Associated Front Office ID
     C                   EVAL      AFRT=L_CLAFRT
      *                                                                                     AR826115
      ** Check Base rate change facility flag from ICD                                      AR826115
      *                                                                                     AR826115
     C                   IF        BPBRCF = 'N'                                             AR826115
     C                   EVAL      BRTT = 0                                                 AR826115
     C                   EVAL      BRTE = 0                                                 AR826115
      *                                                                                     AR826115
     C                   IF        L_CLSPIN = 'A'                                           AR826115
     C                   EVAL      RTSP = L_CLBRTE + L_CLRTSP                               AR826115
     C                   ELSE                                                               AR826115
     C                   EVAL      RTSP = L_CLBRTE - L_CLRTSP                               AR826115
     C                   ENDIF                                                              AR826115
      *                                                                                     AR826115
     C                   EVAL      SPIN = ' '                                               AR826115
     C                   ENDIF                                                              AR826115
 
      *
      ** Update Record
 
     C                   UPDATE    CLOANCLF
 
     C                   MOVEL     CLOANLDS      Z#ASTS                                       261894
 
      ** Access Loan record (CLOANCLK)
 
     C     L_CLLNRF      CHAIN     CLOANCKF                           99
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     L_CLLNRF      DBKEY
     C                   EVAL      DBFILE = 'CLOANCKF'                          ************
     C                   EVAL      DBASE  = 002                                 * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
                                                                                              261894
     C                   MOVEL     CrLnFilFmtK   Z#BSTK                                       261894
 
      ** Set Transaction Detail fields on amend
      ** (only the fields changed by the Rollover function)
 
     C                   EVAL      RDST = K_CLRDST
     C                   EVAL      ORVD = K_CLORVD
     C                   EVAL      THRN = K_CLTHRN
     C                   EVAL      NPRAM = K_CLNPRA
     C                   EVAL      NDAM = K_CLNDAM
     C                   EVAL      RLBR = K_CLRLBR
     C                   EVAL      RRST = K_CLRRST
     C                   EVAL      RRON = K_CLRRON
     C                   EVAL      RRIB = K_CLRRIB
     C                   EVAL      RRBA = K_CLRRBA
     C                   EVAL      RROB = K_CLRROB
     C                   EVAL      RROC = K_CLRROC
     C                   EVAL      RRSC = K_CLRRSC
     C                   EVAL      RLBR = K_CLRLBR
     C                   EVAL      RLSB = K_CLRLSB
     C                   EVAL      RPST = K_CLRPST
     C                   EVAL      RPON = K_CLRPON
     C                   EVAL      RPIB = K_CLRPIB
     C                   EVAL      RPBA = K_CLRPBA
     C                   EVAL      RPOB = K_CLRPOB
     C                   EVAL      RPOC = K_CLRPOC
     C                   EVAL      RRCR = K_CLRRCR
     C                   EVAL      RRCA = K_CLRRCA
     C                   EVAL      RRVN = K_CLRRVN
     C                   EVAL      RAWB = K_CLRAWB
     C                   EVAL      RAWA = K_CLRAWA
     C                   EVAL      RBEN = K_CLRBEN
     C                   EVAL      RBNA = K_CLRBNA
     C                   EVAL      RDP1 = K_CLRDP1
     C                   EVAL      RDP2 = K_CLRDP2
     C                   EVAL      RDP3 = K_CLRDP3
     C                   EVAL      RDP4 = K_CLRDP4
     C                   EVAL      RDCH = K_CLRDCH
     C                   EVAL      RBB1 = K_CLRBB1
     C                   EVAL      RBB2 = K_CLRBB2
     C                   EVAL      RBB3 = K_CLRBB3
     C                   EVAL      RBB4 = K_CLRBB4
     C                   EVAL      RBB5 = K_CLRBB5
     C                   EVAL      RBB6 = K_CLRBB6
     C                   EVAL      RCVM = K_CLRCVM
     C                   EVAL      RPSC = K_CLRPSC
     C                   EVAL      RICY = K_CLRICY
     C                   EVAL      SPI1 = K_CLSPI1
     C                   EVAL      SPI2 = K_CLSPI2
     C                   EVAL      SPI3 = K_CLSPI3
     C                   EVAL      NCCY = K_CLNCCY
     C                   EVAL      NCPA = K_CLNCPA
     C                   EVAL      NFCE = K_CLNFCE
     C                   EVAL      NFMD = K_CLNFMD
     C                   EVAL      NBCE = K_CLNBCE
     C                   EVAL      NBMD = K_CLNBMD
     C                   EVAL      NLRA = K_CLNLRA
     C                   EVAL      RIUS = K_CLRIUS
     C                   EVAL      RAUS = K_CLRAUS
     C                   EVAL      RXUS = K_CLRXUS
     C                   EVAL      RSTS = K_CLRSTS
     C                   EVAL      RPCR = K_CLRPCR
     C                   EVAL      ECIN = K_CLECIN
     C                   EVAL      RSTA = K_CLRSTA                                            CLE034
                                                                                            MD028338
      ** Reuse filler to serve as FX Rate Change Only Indicator                             MD028338
                                                                                            MD028338
     C                   EVAL      ZZ004 = K_CLZZ04                                         MD028338
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C                   EVAL      FSFYLB = K_CLFYLB                                          BUG827
     C                   ENDIF                                                                BUG827
      *
     C                   EVAL      TNLU = PNATN
      *
      ** Last Change Type
     C                   EVAL      CHTP = K_CLCHTP
      *
     C                   Z-ADD     BJRDNB        LCD
 
      ** Timestamp (use same as CLOANCL)
     C                   EVAL      TMST=TimeStamp
      ** Front Office ID
     C                   EVAL      FRNT=K_CLFRNT
      ** Associated Front Office ID
     C                   EVAL      AFRT=K_CLAFRT
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                         BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
                                                                                             BUG3760
     C                   IF        L_CLPTYP = 63 or L_CLPTYP = 65 or                         BUG3760
     C                             L_CLPTYP = 67 or K_CLNCCY <> *BLANKS                      BUG3760
                                                                                             BUG3760
     C                   EVAL      WFuncType ='CLOANCK'                                      BUG3760
     C                   MOVEL     L_CLLNRF      WIdntifier                                  BUG3760
     C                   EVAL      WBranch = L_CLBRCA                                        BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                   MOVEL     RRON          WLF(1)                                      BUG3760
     C                   MOVEL     RRIB          WLF(2)                                      BUG3760
     C                   MOVEL     RROB          WLF(3)                                      BUG3760
     C                   MOVEL     RROC          WLF(4)                                      BUG3760
     C                   MOVEL     RPON          WLF(5)                                      BUG3760
     C                   MOVEL     RPIB          WLF(6)                                      BUG3760
     C                   MOVEL     RPOB          WLF(7)                                      BUG3760
     C                   MOVEL     RPOC          WLF(8)                                      BUG3760
     C                   MOVEL     RRCR          WLF(9)                                      BUG3760
     C                   MOVEL     RRVN          WLF(10)                                     BUG3760
     C                   MOVEL     RAWB          WLF(11)                                     BUG3760
     C                   MOVEL     RBEN          WLF(12)                                     BUG3760
     C                   EXSR      SRWatch                                                   BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   MOVEA     *BLANKS       WLF                                         BUG3760
                                                                                             BUG3760
     C                   IF        RRON <> CHKRRON                                           BUG3760
     C                   MOVEL     RRON          WLF(1)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RRIB <> CHKRRIB                                           BUG3760
     C                   MOVEL     RRIB          WLF(2)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RROB <> CHKRROB                                           BUG3760
     C                   MOVEL     RROB          WLF(3)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RROC <> CHKRROC                                           BUG3760
     C                   MOVEL     RROC          WLF(4)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RPON <> CHKRPON                                           BUG3760
     C                   MOVEL     RPON          WLF(5)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RPIB <> CHKRPIB                                           BUG3760
     C                   MOVEL     RPIB          WLF(6)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RPOB <> CHKRPOB                                           BUG3760
     C                   MOVEL     RPOB          WLF(7)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RPOC <> CHKRPOC                                           BUG3760
     C                   MOVEL     RPOC          WLF(8)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RRCR <> CHKRRCR                                           BUG3760
     C                   MOVEL     RRCR          WLF(9)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RRVN <> CHKRRVN                                           BUG3760
     C                   MOVEL     RRVN          WLF(10)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RAWB <> CHKRAWB                                           BUG3760
     C                   MOVEL     RAWB          WLF(11)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RBEN <> CHKRBEN                                           BUG3760
     C                   MOVEL     RBEN          WLF(12)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      WDtlOPay = 'N'                                            BUG3760
     C                   IF        RDP1 <> CHKRDP1 or                                        BUG3760
     C                             RDP2 <> CHKRDP2 or                                        BUG3760
     C                             RDP3 <> CHKRDP3 or                                        BUG3760
     C                             RDP4 <> CHKRDP4                                           BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   EVAL      WDtlOPay = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        WLChgFlg = 'Y'                                            BUG3760
     C                   EXSR      SRWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
 
      *
      ** Update Record
 
     C                   UPDATE    CLOANCKF
 
     C                   MOVEL     CLOANKDS      Z#ASTK                                       261894
                                                                                              261894
     C                   EXSR      SRSHDW                                                     261894
      *
      **  If LE Autorisation feature is switched off
      **  or not required, do automatic authorisation.
      **  if not called from the CTU
     C     BPROAU        IFNE      'Y'
     C     @@CTU         ANDNE     'Y'
     C     L_CLAUTH      OREQ      'Y'                                                        CAP086
     C                   EXSR      AUTHOR
     C                   ENDIF
 
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AUTHOR - Authorise a Rollover                                *
      *                                                              *
      ****************************************************************
     C     AUTHOR        BEGSR
 
      ** Access Loan record (CLOANCLK)
 
     C     L_CLLNRF      CHAIN     CLOANCKF                           99
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   MOVEL     L_CLLNRF      DBKEY
     C                   EVAL      DBFILE = 'CLOANCKF'                          ************
     C                   EVAL      DBASE  = 004                                 * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
 
      ** Set Transaction Detail fields on authorise
      ** (only the fields changed by the Rollover function)
 
      **  If Release Authorisation feature is on set rollover status                          CLE030
     C     CLE030        IFEQ      'Y'                                                        CLE030
     C                   MOVE      K_CLRSTS      RSTS                                         CLE030
     C                   ELSE                                                                 CLE030
      **  Set Rollover Status to 'A'.
     C                   MOVE      'A'           RSTS
     C                   MOVE      'A'           K_CLRSTS                                     246696
     C                   ENDIF                                                                CLE030
                                                                                              CAP086
     C     L_CLAUTH      IFEQ      'Y'                                                        CAP086
     C                   MOVE      'A'           RSTS                                         CAP086
     C                   MOVE      'A'           K_CLRSTS                                     246696
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *                                                                                       CAP086
      ** Automatic Authorisation flag                                                         CAP086
      *                                                                                       CAP086
     C                   EVAL      AUTH = L_CLAUTH                                            CAP086
      *
      **  Set Rollover Authorising User to current user.
     C                   MOVEL(P)  PSUSER        RXUS
      *
     C                   EVAL      TNLU = PNATN
     C                   EVAL      LCD = K_CLLCD
      *
      ** Last Change Type
     C                   EVAL      CHTP = K_CLCHTP
 
      ** Timestamp
      ** Generate only if subroutine is not called from subr AMEND
      ** and not called from CTU
      **  (if called from CTU action is X and Timestamp already generated in AMEND)
     C     @@ACTN        IFNE      'A'
     C     @@CTU         ANDNE     'Y'
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   ENDIF
     C                   EVAL      TMST=TimeStamp
      ** Front Office ID
     C                   EVAL      FRNT=K_CLFRNT
      ** Associated Front Office ID
     C                   EVAL      AFRT=K_CLAFRT
 
      *
      ** Update Record
 
     C                   UPDATE    CLOANCKF
 
      *
      **  For Discount loans, update LTRIX.
      *
     C     L_CLPTYP      IFEQ      63
     C     L_CLPTYP      OREQ      65
     C     L_CLPTYP      OREQ      67
     C                   EXSR      SRLTRX
     C                   ENDIF
 
 
 
     C                   ENDSR
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRWatch - Initiates the Midas Compliance Engine.              *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
                                                                                             BUG3760
     C     SRWatch       BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Initialise the Transaction Details parameter.                                       BUG3760
                                                                                             BUG3760
     C                   CLEAR                   SDWLTD                                      BUG3760
                                                                                             BUG3760
      ** Setup First Parameter                                                               BUG3760
                                                                                             BUG3760
     C                   MOVEL     'LEROLL'      W4ITEM                                      BUG3760
     C                   MOVEL     L_CLLNRF      W4IDEN                                      BUG3760
     C                   EVAL      W4BRCH = L_CLBRCA                                         BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y'                                              BUG3760
     C                   EVAL      W4SYSM = S1MAIN                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4SYSM = LIBR                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      W4FUNT = 'CLOANCK'                                        BUG3760
                                                                                             BUG3760
     C                   MOVEL     L_CLCNUM      PCUST                                       BUG3760
     C                   CALLB     'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*KEY'        POPTN                                       BUG3760
     C                   Parm                    PCUST                                       BUG3760
     C                   PARM      *BLANKS       PSTKEY                                      BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRTCD <> *BLANKS                                          BUG3760
     C                             AND PRTCD <> '*NRF   '                                    BUG3760
     C                   EVAL      DBKEY = POPTN                                             BUG3760
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG3760
     C                   EVAL      DBASE = 908                                               BUG3760
     C                   EXSR      SRERR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   MOVE      L_CLCNUM      W4CNUM                                      BUG3760
                                                                                             BUG3760
      ** Determine Counterparty Type                                                         BUG3760
                                                                                             BUG3760
     C                   IF        CCF001 = 'Y'                                              BUG3760
     C                   IF        BBCRPC = 'Y'                                              BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        BBLICD <> *BLANKS                                         BUG3760
     C                             AND BBLICD <> W1IND1                                      BUG3760
     C                             AND BBLICD <> W1IND2                                      BUG3760
     C                             AND BBLICD <> W1IND3                                      BUG3760
     C                             AND BBLICD <> W1IND4                                      BUG3760
     C                             AND BBLICD <> W1IND5                                      BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                  BUG3760
                                                                                             BUG3760
      ** Convert Dates                                                                       BUG3760
                                                                                             BUG3760
     C                   MOVE      '0001-01-01'  W4DDAT                                      BUG3760
     C                   MOVE      RLDT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4VDAT = WDDT                                             BUG3760
                                                                                             BUG3760
     C                   IF        NMDT <> *ZEROS                                            BUG3760
     C                   MOVE      NMDT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      MDAT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        NCCY <> *BLANKS                                           BUG3760
     C                   EVAL      W4DEN1 = NCCY                                             BUG3760
     C                   EVAL      W4DEN2 = *BLANKS                                          BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4DEN1 = L_CLCCY                                          BUG3760
     C                   EVAL      W4DEN2 = *BLANKS                                          BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        L_CLPTYP = 63 and NCCY = *BLANKS or                       BUG3760
     C                             L_CLPTYP = 65 and NCCY = *BLANKS or                       BUG3760
     C                             L_CLPTYP = 67 and NCCY = *BLANKS                          BUG3760
     C                   MOVE      NPRAM         PAMT                                        BUG3760
     C                   EVAL      PCcy = L_CLCCY                                            BUG3760
     C                   EXSR      SRCvtAmt                                                  BUG3760
     C                   MOVE      ConvertedAmt  W4AMT1                                      BUG3760
     C                   MOVE      *ZEROS        W4AMT2                                      BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        NCCY <> *BLANKS                                           BUG3760
     C                   MOVE      NCPA          PAMT                                        BUG3760
     C                   EVAL      PCcy = NCCY                                               BUG3760
     C                   EXSR      SRCvtAmt                                                  BUG3760
     C                   MOVE      ConvertedAmt  W4AMT1                                      BUG3760
     C                   MOVE      *ZEROS        W4AMT2                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Build the free format string.                                                       BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = 1                                                   BUG3760
     C                   EVAL      PFreeFmtStr = *BLANKS                                     BUG3760
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG3760
     C                   EVAL      WData = *BLANKS                                           BUG3760
                                                                                             BUG3760
     C                   DOU       Ctr >= Elements                                           BUG3760
                                                                                             BUG3760
     C                   IF        WLF(Ctr) <> *BLANKS                                       BUG3760
     C                             AND WLF(Ctr) <> '000000'                                  BUG3760
                                                                                             BUG3760
     C                   IF        RPSC <> *BLANKS                                           BUG3760
     C                   EVAL      PFmtCCY = RPSC                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      PFmtCCY = L_CLCCY                                         BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        NCCY <> *BLANKS                                           BUG3760
                                                                                             BUG3760
     C                   IF        L_CLPTYP <> 63 and L_CLPTYP <> 67 and                     BUG3760
     C                             L_CLPTYP <> 69                                            BUG3760
                                                                                             BUG3760
     C                   IF        Ctr = 5                                                   BUG3760
                                                                                             BUG3760
     C                   IF        RPSC <> *BLANKS                                           BUG3760
     C                   EVAL      PFmtCCY = RPSC                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      PFmtCCY = NCCY                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        Ctr = 1                                                   BUG3760
                                                                                             BUG3760
     C                   IF        RPSC <> *BLANKS                                           BUG3760
     C                   EVAL      PFmtCCY = RPSC                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      PFmtCCY = NCCY                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM                    PRTCD                                       BUG3760
     C                   PARM                    WLF(Ctr)                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PFmtCCY                                     BUG3760
     C                   PARM                    WData                                       BUG3760
     C                   PARM                    PDummy6                                     BUG3760
                                                                                             BUG3760
     C                   CAT       XOT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WData:0       WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   SELECT                                                              BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 2                                                   BUG3760
     C                   CAT       RRBA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 6                                                   BUG3760
     C                   CAT       RPBA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 9                                                   BUG3760
     C                   CAT       RRCA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 11                                                  BUG3760
     C                   CAT       RAWA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 12                                                  BUG3760
     C                   CAT       RBNA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   ENDSL                                                               BUG3760
                                                                                             BUG3760
     C                   CAT       XCT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG3760
     C                   EVAL      WData = *BLANKS                                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = Ctr + 1                                             BUG3760
     C                   ENDDO                                                               BUG3760
                                                                                             BUG3760
      ** Add the Payment Details.                                                            BUG3760
                                                                                             BUG3760
     C                   IF        RDP1 <> *BLANKS or RDP2 <> *BLANKS or                     BUG3760
     C                             RDP3 <> *BLANKS or RDP4 <> *BLANKS                        BUG3760
                                                                                             BUG3760
     C                   IF        WDtlOPay = 'Y'                                            BUG3760
     C                   CAT       XOT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       RDP1:0        WXMLPacket                                  BUG3760
     C                   CAT       RDP2:1        WXMLPacket                                  BUG3760
     C                   CAT       RDP3:1        WXMLPacket                                  BUG3760
     C                   CAT       RDP4:1        WXMLPacket                                  BUG3760
     C                   CAT       XCT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check for compliance.                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLCHK'                                                BUG3760
     C                   PARM                    SDWLTD                                      BUG3760
     C                   PARM                    PFreeFmtStr                                 BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
                                                                                             BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRCvtAmt - Converts amount using bound module ZACVTAMT        *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
                                                                                             BUG3760
     C     SRCvtAmt      BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   CALLB     'ZACVTAMT'                                                BUG3760
     C                   PARM                    PRetCode                                    BUG3760
     C                   PARM                    PCcy                                        BUG3760
     C                   PARM                    PAMT                                        BUG3760
     C                   PARM                    ConvertedAmt                                BUG3760
     C                   PARM                    PDummy16                                    BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
                                                                                             BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
                                                                                             BUG3760
     C     SRDateToDDT   BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
                                                                                             BUG3760
     C                   CALL      'ZACVTDATE'                                               BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZADayNo                                    BUG3760
     C                   PARM                    PZADDT                                      BUG3760
     C                   PARM                    PZACvtDt                                    BUG3760
                                                                                             BUG3760
     C                   EVAL      WDDT = PZADDT                                             BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
                                                                                             BUG3760
      ****************************************************************
      /EJECT                                                                                  261894
      *****************************************************************                       261894
      * SRSHDW  -  Update shadow files                                *                       261894
      *            PRONO, MEMOS, OLPOS and RSACMTPD                   *                       261894
      *****************************************************************                       261894
     C     SRSHDW        BegSR                                                                261894
                                                                                              261894
     C     *Like         Define    NMDT          #NMDT                                        261894
     C     *Like         Define    NMDT          #ONMDT                                       261894
                                                                                              261894
     C                   If        @Type = '0'                                                261894
     C                   Eval      PRTCD = '*LEBTCH'                                          261894
     C                   Else                                                                 261894
     C                   Eval      PRTCD = *blanks                                            261894
     C                   EndIf                                                                261894
      *                                                                                       261894
     C                   Call      'AOOULEU0'                                                 261894
     C                   Parm                    PRTCD                                        261894
     C                   Parm                    Z#BSTS                                       261894
     C                   Parm                    Z#ASTS                                       261894
     C                   Parm                    Z#WSTS                                       261894
     C                   Parm                    Z#BSTK                                       261894
     C                   Parm                    Z#ASTK                                       261894
     C                   PARM      *BLANKS       CLONQD                                     AR820267
                                                                                              261894
     C                   If        PRTCD = '*ERROR*'                                          261894
     C                   EXSR      *PSSR                                                      261894
     C                   EndIf                                                                261894
                                                                                              261894
     C                   If        PTYP <> 70 And PTYP <> 71 And                              261894
     C                             PTYP <> 72                                                 261894
     C                   Eval      #NMDT  = NMDT                                              261894
     C                   Eval      #ONMDT = CHNMDT                                            261894
                                                                                              261894
     C                   If        #ONMDT <> 0    Or  #NMDT <> 0 Or                           261894
     C                             CHNIDT <> NIDT Or                                          261894
     C                             (NCCY  <> ' '  And NCCY  <> CHKNCCY) Or                    261894
     C                             (NCCY  =  ' '  And NPRAM <> 0 And NFCE <> 0)               261894
     C                   If        #NMDT = 0                                                  261894
     C                   Eval      #NMDT = MDAT                                               261894
     C                   EndIf                                                                261894
                                                                                              261894
     C                   If        #ONMDT = 0                                                 261894
     C                   Eval      #ONMDT = MDAT                                              261894
     C                   EndIf                                                                261894
                                                                                              261894
     C                   Call      'LE2032 '                                                  261894
     C                   Parm                    PRTCD                                        261894
     C                   Parm                    LNRF                                         261894
     C                   Parm                    #NMDT                                        261894
     C                   Parm                    #ONMDT                                       261894
                                                                                              261894
     C                   If        PRTCD = '*ERROR*'                                          261894
     C                   EXSR      *PSSR                                                      261894
     C                   EndIf                                                                261894
     C                   EndIf                                                                261894
                                                                                              261894
     C                   EndIf                                                                261894
      *                                                                                       261894
     C                   EndSR                                                                261894
      ****************************************************************                        261894
      /EJECT
      ****************************************************************
      *                                                              *
      * SRLTRX  -  Update LTRIX header and detail record.             *
      *                                                              *
      *****************************************************************
     C     SRLTRX        BEGSR
      *
      **  Get telex notice days.
      *
     C                   MOVE      L_CLSDST      WSDST             2
     C     WSDST         LOOKUP    LNOST                                  85
     C     *IN85         IFEQ      *OFF
     C                   MOVEL     BJLCCY        @CURR
     C                   ELSE
     C                   MOVEL     L_CLCCY       @CURR
     C                   ENDIF
     C                   MOVE      *BLANKS       A6CYCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBKEY  = @CURR
     C                   EVAL      DBFILE = 'SDCURRPD'                          ************
     C                   EVAL      DBASE  = 005                                 * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
      *
     C                   Z-ADD     A6TXND        NumDaysFwd
     C                   Z-ADD     BJRDNB        DateIn
     C                   MOVEL     BJLCCY        FirstCcy
     C                   MOVEL     L_CLCCY       SecondCcy
      *
     C                   CALLB     'ZF2C'
     C                   PARM                    ReturnCode
     C                   PARM                    DateIn
     C                   PARM                    FirstCcy
     C                   PARM                    FirstLoc
     C                   PARM                    SecondCcy
     C                   PARM                    SecondLoc
     C                   PARM                    NumDaysFwd
     C                   PARM                    DayNumber
      *
     C                   Z-ADD     L_CLRLDT      XROLD             5 0
      *
      **  Write record to LTRIX for pay/receive if
      **    1. Rollover date is not zero
      **  + 2. Rollover date is not less than rundate
      **  + 3. Rollover date is within telex notice days
      **  + 4. Rollover date is same as original maturity date on loan.
      *
     C     L_CLOMDT      IFNE      *ZEROS
     C     XROLD         ANDEQ     L_CLOMDT
     C     XROLD         ANDLE     DayNumber
     C     L_CLOMDT      ANDGE     BJRDNB
      *
      ****Read*LTRIX*header.*******************************************                     AR322732
     C**********         Z-ADD     1             LXRRN             5 0                      AR322732
     C*****LXRRN         CHAIN     LTRIX                              85                    AR322732
     C******IN85         IFEQ      *OFF                                                     AR322732
     C*****RECIX         IFEQ      'H'                                                      AR322732
     C*****RRNAX         IFGT      FLSZX                                                    AR322732
     C**********         MOVE      *ON           *INU8                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ELSE                                                               AR322732
     C**********         MOVE      *ON           *IN85                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ENDIF                                                              AR322732
     C******IN85         IFEQ      *ON                                                      AR322732
     C******INU8         OREQ      *ON                                                      AR322732
 
      ** Database error
 
     C**********         EVAL      DBKEY  = '1     '                                        AR322732
     C**********         EVAL      DBFILE = 'LTRIX   '                          ************AR322732
     C**********         EVAL      DBASE  = 006                                 * DBERR 006*AR322732
     C**********         EXSR      SRERR                                        ************AR322732
     C**********         ENDIF                                                              AR322732
      *
      ****Save*relative*record*no.*of*next*available*record.***********                     AR322732
     C**********         Z-ADD     RRNAX         LXRRN                                      AR322732
      *
      **  Update LTRIX header details.
      *
     C**********         ADD       1             NOREX                                      AR322732
     C**********         ADD       1             RRNAX                                      AR322732
     C**********         ADD       1             NLNRX                                      AR322732
      *
     C**********         EXCEPT    TRXHDR                                                   AR322732
      *
      **  Access next available LTRIX record.
     C*****LXRRN         CHAIN     LTRIX                              85                    AR322732
     C******IN85         IFEQ      *ON                                                      AR322732
 
      ** Database error
 
     C**********         MOVEL     LXRRN         DBKEY                                      AR322732
     C**********         EVAL      DBFILE = 'LTRIX   '                          ************AR322732
     C**********         EVAL      DBASE  = 007                                 * DBERR 007*AR322732
     C**********         EXSR      SRERR                                        ************AR322732
     C**********         ENDIF                                                              AR322732
      *
      ** Update LTRIX detail record
      *
     C                   MOVEL     L_CLLNRF      LNRFX
     C                   MOVEL     L_CLCHTP      CHTPX
     C                   MOVEL     L_CLTNLU      TNLUX
     C                   MOVEL     L_CLBRCA      BRCAX
     C                   Z-ADD     0             LXRRN             5 0                      AR322732
      *
     C                   EXCEPT    TRXDTL
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      * Return Code
     C                   PARM                    @@RTCD            7
      * Action Code
     C                   PARM                    @@ACTN            1
      * Externally described DS for valid Transaction Detail
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      * Called from CTU
     C                   PARM                    @@CTU             1
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  = 900                                 * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   ENDIF
 
      ** Check if CDE001 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDE001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
     C                   MOVE      'Y'           CDE001            1
     C                   ELSE
      *
      * Database Error
      *
     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SCSARDPD'                          *************
     C                   EVAL      DBASE  = 901                                 * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Access Customer Lending ICD via access program
      *  (database error handling done in access program)
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '902'         DBASE                          * DBERR 902 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
                                                                                             BUG3760
      ** Access the SDSTAT Data Area.                                                        BUG3760
                                                                                             BUG3760
     C                   IN        SDSTAT                                                    BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CSD015 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 903                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
                                                                                             BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
                                                                                             BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 904                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*FIRST '     POption                                     BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = POption                                           BUG3760
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBase = 905                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CSC011 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSC011'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   IN        SC24X7                                                    BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSC011'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 906                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CCF001 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CCF001'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 8                                                  CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      SRErr                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                             BUG9507
      ** Check if CLE036 is enabled                                                          BUG9507
                                                                                             BUG9507
     C                   CALLB     'AOSARDR0'                                                BUG9507
     C                   PARM      *BLANKS       PRtCd                                       BUG9507
     C                   PARM      '*VERIFY'     POptn                                       BUG9507
     C                   PARM      'CLE036'      PSARD                                       BUG9507
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9507
                                                                                             BUG9507
     C                   IF        PRtCd = *BLANKS                                           BUG9507
     C                   EVAL      CLE036 = 'Y'                                              BUG9507
     C                   ELSE                                                                BUG9507
                                                                                             BUG9507
     C                   IF        PRtCd <> '*NRF'                                           BUG9507
     C     *LOCK         IN        LDA                                                       BUG9507
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG9507
     C                   EVAL      DBase = 9                                                 BUG9507
     C                   EVAL      DBKey = 'CLE036'                                          BUG9507
     C                   OUT       LDA                                                       BUG9507
     C                   EXSR      SRErr                                                     BUG9507
     C                   ENDIF                                                               BUG9507
                                                                                             BUG9507
     C                   ENDIF                                                               BUG9507
 
      ** OVRDBF CLOANX to CLOAN then OPEN CLOANX
 
     C                   EVAL      LENGTH = %SIZE(OVRDBF)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF        QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      CLOANX
 
      ** Determine if CAS009 is ON                                                            CAS011
      *                                                                                       CAS011
     C                   CALLB     'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY'     POPTN                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRTCD <> *Blanks    and                                    CAS011
     C                             PRTCD <> '*NRF   '                                         CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 66                                                 CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   IF        PRTCD = *Blanks                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   ENDIF                                                                CAS011
      ** Determine if CAS016 is ON                                                            CAS019
      *                                                                                       CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRTCD                                        CAS019
     C                   PARM      '*VERIFY'     POPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        PRTCD <> *Blanks    and                                    CAS019
     C                             PRTCD <> '*NRF   '                                         CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBase = 68                                                 CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   OUT       LDA                                                        CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C                   IF        PRTCD = *Blanks                                            CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** Check if Watch List Element (CSD083) is on                                           CSD083
      *                                                                                       CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *Blanks AND                                       CSD083
     C                             PRTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 69                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CAS011
      ** Determine if CRE073 is installed                                                     CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD <> *Blanks AND                                       CRE073
     C                             PRTCD <> '*NRF   '                                         CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBase = 70                                                 CRE073
     C                   EVAL      DBKey = 'CRE073'                                           CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'LELERIUPD'   DBPGM            10
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the Program
 
     C                   RETURN
 
 
     C                   ENDSR
      ****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      ** Update LTRIX header record
      *
     O*LTRIX**** E            TRXHDR                                                        AR322732
     O**********             NOREX               11P                                        AR322732
     O**********             RRNAX               20P                                        AR322732
     O**********             NLNRX               29P                                        AR322732
     O**********             TNLUX               40P                                        AR322732
      *
      ** Update LTRIX detail record
      *
     O**********E            TRXDTL                                                         AR322732
     OLTRIX     EADD         TRXDTL                                                         AR322732
     O                                            2 'DL'
     O                       LNRFX                8
     O                                           16 '00000000'
     O                       CHTPX               17
     O                                           19 'YN'
     O                                           20 ' '
     O                                           25 '00001'
     O                                           26 'N'
     O                                           27 '0'
     O                       BRCAX               34
     O                       LXRRN               37P
     O                       TNLUX               40P
     O                                           43 '010'
     O                                           44 ' '                                     AR322732
     O                                           45 ' '                                     AR322732
      ***************************************************************************
      *                                                                         *
      *                  F I E L D S   L O G                                    *
      *                  -------------------                                    *
      *                                                                         *
      *  Field                              Set in    Set in  Set in            *
      *  Name    Description              Validation SIN/RPR   This   Amendable *
      *                                     Module     CTL    Function          *
      *                                            (settl.inst)                 *
      ***************************************************************************
      * CLOANCL fields updated                                                  *
      ***************************************************************************
      *  RLDT    Rollover date                Yes                        Yes    *
      *  NROD    Next rollover date           Yes                        Yes    *
      *  RLFQ    Rollover freq                Yes                        Yes    *
      *  RLDY    Rollover day                 Yes                        Yes    *
      *  NBRA    Next base rate type          Yes                        Yes    *
      *  NRTS    Next rate/spread             Yes                        Yes    *
      *  NSIN    Next spread ind              Yes                        Yes    *
      *  NCHI    New Change Indicator         Yes                        Yes    *
      *  NCAS    Next calculation basis       Yes                        Yes    *
      *  NIDT    Next interest payment date   Yes                        Yes    *
      *  IBDT    Interest base date           Yes                        Yes    *
      *  NIPD    New Interest Payment Date    Yes                        Yes    *
      *  NMDT    New Maturity Date            Yes                        Yes    *
      *  NFRS    New Funding Spread/Rate      Yes                        Yes    *
      *  NFSN    New Funding Sign             Yes                        Yes    *
      *  NFPC    New Funding Profit Centre    Yes                        Yes    *
      *  TNLU    Trans no of Last Update      Yes                               *
      *  LCD     Last Change Date                              Yes              *
      *  CHTP    Type of Last Change                   Yes     Yes              *
      *  PCOB    PC Originating Branch        Yes                               *
      *  PCRF    PC Transaction Reference     Yes                               *
      *  MDAT    Maturity date                Yes                        Yes    *
      *  NMDT    New Maturity Date            Yes                        Yes    *
      *                                                                         *
      ***************************************************************************
      * CLOANCK fields updated                                                  *
      ***************************************************************************
      *  RDST    Rollover Settlement Type              Yes               Yes    *
      *  ORVD    Our Rollover Date A/C                 Yes               Yes    *
      *  THRN    Their Rollover Nostro                 Yes               Yes    *
      *  NPRAM   New Principal Amount         Yes                        Yes    *
      *  NDAM    New Discount Amount          Yes                        Yes    *
      *  RLBR    Rollover settlement branch            Yes               Yes    *
      *  RRST    receipt - settlement method           Yes               Yes    *
      *  RRON    receipt - our nostro                  Yes               Yes    *
      *  RRIB    receipt - intermediary bank           Yes               Yes    *
      *  RRBA    receipt - intermediary bank           Yes               Yes    *
      *  RROB    receipt - ordering bank no            Yes               Yes    *
      *  RROC    receipt - ordering customer           Yes               Yes    *
      *  RRSC    Roll Rec Settlement Ccy               Yes               Yes    *
      *  RLBR    Rollover settlement branch            Yes               Yes    *
      *  RRST    receipt - settlement method           Yes               Yes    *
      *  RLSB    Pay - Rollover Settle Brch            Yes               Yes    *
      *  RPST    Pay - Roll Settlement Meth            Yes               Yes    *
      *  RPON    Pay - Rollover Our Nostro             Yes               Yes    *
      *  RPIB    Pay - Roll Intermediary Bk            Yes               Yes    *
      *  RPBA    Pay - Roll Intermediary Bk            Yes               Yes    *
      *  RPOB    Pay - Roll Ordering Bank No           Yes               Yes    *
      *  RPOC    Pay - Roll Ordering Customer          Yes               Yes    *
      *  RRCR    Roll Receiver Corresp No              Yes               Yes    *
      *  RRCA    Roll Receiver Corresp A/C li          Yes               Yes    *
      *  RRVN    Rollover Receiver Number              Yes               Yes    *
      *  RAWB    Rollover A/C With Bank No             Yes               Yes    *
      *  RAWA    Roll A/C With Bank A/C Line           Yes               Yes    *
      *  RBEN    Rollover Beneficiary Number           Yes               Yes    *
      *  RBNA    Rollover Beneficiary A/C Li           Yes               Yes    *
      *  RDP1    Rollover Details of Pay 1             Yes               Yes    *
      *  RDP2    Rollover Details of Pay 2             Yes               Yes    *
      *  RDP3    Rollover Details of Pay 3             Yes               Yes    *
      *  RDP4    Rollover Details of Pay 4             Yes               Yes    *
      *  RDCH    Rollover Details of Charges           Yes               Yes    *
      *  RBB1    Rollover Bank to Bank Info 1          Yes               Yes    *
      *  RBB2    Rollover Bank to Bank Info 2          Yes               Yes    *
      *  RBB3    Rollover Bank to Bank Info 3          Yes               Yes    *
      *  RBB4    Rollover Bank to Bank Info 4          Yes               Yes    *
      *  RBB5    Rollover Bank to Bank Info 5          Yes               Yes    *
      *  RBB6    Rollover Bank to Bank Info 6          Yes               Yes    *
      *  RCVM    Roll Cover Message Required           Yes               Yes    *
      *  RPSC    Roll Pay Settlement Ccy               Yes               Yes    *
      *  RICY    Roll IN Ccy in Fld 72                 Yes               Yes    *
      *  SPI1    Special instructions - 1              Yes               Yes    *
      *  SPI2    Special instructions - 2              Yes               Yes    *
      *  SPI3    Special instructions - 3              Yes               Yes    *
      *  NCCY    New Currency                 Yes                        Yes    *
      *  NCPA    New Currency Principal Amoun Yes                        Yes    *
      *  NFCE    New Facility Ccy Exch Rate   Yes                        Yes    *
      *  NFMD    New Facility Ccy Mult/Div In Yes                        Yes    *
      *  NBCE    New Base Currency Exch Rate  Yes                        Yes    *
      *  NBMD    New Base Currency Mult/Div I Yes                        Yes    *
      *  NLRA    New Loan Ccy Repayment Amoun Yes                        Yes    *
      *  RIUS    Rollover Insert User Profile Yes                               *
      *  RAUS    Rollover Amend User Profile  Yes                               *
      *  RXUS    Rollover Authorise User Prof Yes              Yes              *
      *  RSTS    Rollover Status Indicator    Yes              Yes              *
      *  TNLU    Trans no of Last Update      Yes                               *
      *  LCD     Last Change Date                              Yes              *
      *  CHTP    Type of Last Change                   Yes     Yes              *
      *  RPCR    Rollover - PC Trans Ref.     Yes                               *
      *  ECIN    Euro Conversion Ind          Yes                               *
      *  FSFYLB  New Forward Yield Curve      Yes                        Yes    *             BUG874
      ***************************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
**  LNOST
010708
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                  BUG3760
<Receipt Nostro>                                                                             BUG3760
<Receipt Intermed Bank>                                                                      BUG3760
<Receipt Ordering Bank>                                                                      BUG3760
<Receipt Ordering Cust>                                                                      BUG3760
<Payment Nostro>                                                                             BUG3760
<Payment Intermed Bank>                                                                      BUG3760
<Payment Ordering Bank>                                                                      BUG3760
<Payment Ordering Cust>                                                                      BUG3760
<Receiver Correspondent>                                                                     BUG3760
<Receiver>                                                                                   BUG3760
<Account With Bank>                                                                          BUG3760
<Beneficiary>                                                                                BUG3760
<Details of Payment>                                                                         BUG3760
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                  BUG3760
</Receipt Nostro>                                                                            BUG3760
</Receipt Intermed Bank>                                                                     BUG3760
</Receipt Ordering Bank>                                                                     BUG3760
</Receipt Ordering Cust>                                                                     BUG3760
</Payment Nostro>                                                                            BUG3760
</Payment Intermed Bank>                                                                     BUG3760
</Payment Ordering Bank>                                                                     BUG3760
</Payment Ordering Cust>                                                                     BUG3760
</Receiver Correspondent>                                                                    BUG3760
</Receiver>                                                                                  BUG3760
</Account With Bank>                                                                         BUG3760
</Beneficiary>                                                                               BUG3760
</Details of Payment>                                                                        BUG3760
