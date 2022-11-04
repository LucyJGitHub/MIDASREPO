     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading  Module                           *
      *                                                               *
      *  XX118009 - SE Position Settlement Split for Treaty WHT       *
      *                                                               *
      *  Function:  This program sub-divides each position settlement *
      *             record into either records for different  Tax     *
      *             groups or records for different  beneficial       *
      *             owners.                                           *
      *                                                               *
      *  Called By: XX118004 - Generate Position Settlements - Depots *
      *             XX118008 - Generate Position Settlements - Cust   *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *****************************************************************
      *  NOTE: This program is a copy of SE4861 (SE2310).             *
      *        Should you have to add any fix or code to this program *
      *        please consider the fact that similar changes may very *
      *        well have to be applied to SE2310 too.                 *
      *        Because of that, even if the program is new, the old   *
      *        tags have not been removed                             *
      *****************************************************************
      *                                                               *
      *  Last Amend No. HUT118   *Create   Date 03Nov22               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  HUT118 - Position Settlements Online Generation              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicators                          *
      *                                                               *
      *    21     Record missing from SECTYD                          *
      *    22     Record missing from INVTPD                          *
      *    23     Write to POSETD/Update POSET5 indicator             *
      *                                                               *
      *    25     No record found in CPOSND                           *
      *    26     No record found in UDEPP                            *
      *    27     No record found in UDEPH                            *
      *    28     No record found in SECDEPL6                         *
      *    29     No record found in CDEPH                            *
      *    30     No record found in CDEPSL1                          *                       203270
      *    31     Record not found in SDWHTTPD                        *
      *    32     Record not found in SDWTCSPD                        *
      *    33     Record not found in SDBNFOL1                        *
      *    34     No record found in SDINTCLPD                        *
      *    35     Stop reading records from CDEPSL1                   *                       203270
      *    36     The nominal of the previous record read is zero     *                       203270
      *                                                               *
      *   LR :    Last record                                         *
      *   U7/U8 : Database error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCust      Process Customer Position Settlement Record       *
      * SRCustInfo  Get Customer withholding Tax detail               *
      * SRSingleRec Process withholding Tax for single individual     *
      *             Customer.                                         *
      * SRCalTax    Get Tax Basket Information and Calculate Tax      *
      *             amount.                                           *
      * SRInter     Process Withholding Tax for Intermediary          *
      * SRGetBenTax Get Tax Basket for Beneficial Owner               *
      * SRWrtOrUpd  Write new Position record or Update position      *
      * SRDepot     Process Depot Position Settlement Record          *
      * SRUDPos     Get User Depot Position and update Position       *
      * SRCPoset    Get Customer Depot Position                       *
      * SRSetlAmt   Calculate Settlement Amount                       *
      * SRNDIFF     Output position different                         *
      * *INZSR      Initialise                                        *
      * *PSSR       Error processing                                  *
      *                                                               *
      *****************************************************************

     F****POSET5    UF A E           K DISK                                                   HUT118
     FPOSET55   UF A E           K DISK                                                       HUT118
      ** Position Settlement
     F                                     RENAME(POSETDF:POSETUP)
     F                                     PREFIX(Nw_)
     F                                     COMMIT
     FPOSETD    O    E             DISK
      ** Position Settlement for output only
     F                                     RENAME(POSETDF:POSETUP2)
     F                                     PREFIX(Nw_)
     F                                     COMMIT
     FSECOALL4  IF   E           K DISK                                         215575
      ** Corporate allocation Client - MC                                       215575
     FSECTY     IF   E           K DISK
      ** Security Detail
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK
      ** Investment type Detail
     FSDWTCSL1  IF   E           K Disk
      ** Customer Withholding Tax detail - WH
     FSDWHTTL0  IF   E           K Disk
      ** Treaty Withholding Tax Detail - WT
     FSDBNFOL1  IF   E           K Disk
      ** Beneficial Owner Detail - (Including Depot as Key)
     FSDINTCLL1 IF   E           K Disk
     F*SDINTCLL2 IF   E           K Disk                                               233084 233084
     F**********                           RENAME(SDINTCD0:SDINTCD1)                   233084 233084
      ** Intermediary Client Detail - IN
     FUDEPP     IF   E           K Disk
      ** User Depot Position
     F                                     RENAME(UDEPPDF:UDEPPDF1)
     F                                     PREFIX(LU_)
     FUDEPH     IF   E           K Disk
      ** User Depot Position
     F                                     RENAME(UDEPPDF:UDEPPDF2)
     F                                     PREFIX(LU_)
     FSECDEPL6  IF   E           K Disk
      ** Customer Depot Position
     F                                     PREFIX(LC_)
     **FCDEPH     IF   E           K Disk                                       195635
     FCDEPO     IF   E           K Disk                                         195635
      ** Customer Depot Position
     F                                     RENAME(CDEPPDF:CDEPPDF2)
     F                                     PREFIX(LC_)
     F*CDEPS**** IF   E           K Disk                                                      201820
     F*CDEPX1 ** IF   E           K Disk                                               201820 203270
      ***Customer*Depot*Position*-*Live*position*Only******************                       203270
     F**********                           RENAME(CDEPPDF:CDEPPDF3)                           203270
     F**********                           PREFIX(LC_)                                        203270
     F*CDEPSL1   IF   E           K Disk                                               203270 242428
     FCDEPSL2   IF   E           K Disk                                                       242428
      *                                                                                       203270
      ** Customer Depot Position                                                              203270
      *                                                                                       203270
     F                                     RENAME(CDEPPDF:CDEPPDF4)                           203270
     F                                     PREFIX(LC_)                                        203270
     FCPOSN     IF   E           K Disk
      ** Customer Position
     F                                     PREFIX(CP_)
     FBKPHD     IF   E           K Disk                                         186001
      ** Book Position Header - Live Position                                   186001
     F                                     PREFIX(BH_)                          186001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
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

     D InPoset       E DS                  EXTNAME(POSETD)
     D                                     PREFIX(In_)

     D OutPoset      E DS                  EXTNAME(POSETD)
     D                                     PREFIX(Nw_)

     D WrkPoset      E DS                  EXTNAME(POSETD)
     D                                     PREFIX(Wk_)

     D P@DATA          DS           128
     D** Data structure for the parameter passed to and from SEZ010
     D P@CLAS                  1      1
     D P@PPRE                  2      2
     D P@PAMD                  3     15  0
     D P@PCHA                 16     28  0
     D P@PCAM                 29     41  0
     D P@TASO                 42     54  0
     D P@TAUS                 55     67  0
     D P@PSXR                 68     80  8
     D P@PMDI                 81     81
     D P@PNCY                 82     84
     D P@PSCU                 85     87
     D P@PSAT                 88    100  0
     D P@FXMR                101    113  8
     D P@MAMT                114    126  0
     D P@TDTP                127    128

      ** ICD/SD Data Structures
      ** ----------------------

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Data Structure for Branch Details                                      186001
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    186001
     D  QSDFAC       E                     EXTFLD(QQDFAC)                       HUT118
                                                                                186001
      ** DS for Access Programs, Short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                            TLIFIX
      ** DS for access objects - long data structure                               TLIFIX
     D DSLDY         E DS                  EXTNAME(DSLDY)                          TLIFIX

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @AccAmtDue      S             13  0
     D @AccPosit       S             13  0
     D @Acccharge      S             13  0
     D @AccComm        S             13  0
     D @AccDpIncome    S             13  0
     D @AccDpPosit     S             13  0
     D @AccDpcharge    S             13  0
     D @AccDpComm      S             13  0
     D @AmtDiff        S             13  0
     D @Bendept        S                   LIKE(BNDEPT)
     D @Book           S                   LIKE(LU_UDBK)
     D @CallFrom       S              1                                         186001
     D @ChgDiff        S             13  0
     D @Cost           S             13  0
     D @CountryTax     S                   LIKE(WHCRTT)
     D @CommDiff       S             13  0
     D @CTotAmt        S             13  0
     D @CTotNoml       S             13  0
     D @CTotChg        S             13  0
     D @CTotComm       S             13  0
     D @Cust           S                   LIKE(BBCUST)
     D @CustNDTXBS     S                   LIKE(WTDBDC)
     D @CustNo         S                   LIKE(LC_CDCN)
     D @Depot          S                   LIKE(BBCUST)
     D @DepotNo        S                   LIKE(LC_CDPT)
     D @Discount       S             20  8
     D @EvDate         S              5  0                                                    203270
     D @HoldingCust    S                   LIKE(INCNUM)
     D @HoldingDept    S                   LIKE(BNDEPT)
     D @INBONO         S                   LIKE(INBONO)
     D @INCNUM         S                   LIKE(INCNUM)
     D**** @INPTFR         S                   LIKE(INPTFR)                            233084 HUT118
     D*****@Indepot        S              6  0                                         242428 HUT118
     D@Indepot         S              6                                                       HUT118
     D**** @DEPT           S                   LIKE(INDEPT)                            233084 HUT118
     D InDivDate       S              5  0
     D InTVPosit       S              1
     D @LCouponD       S              5  0
     D @Loc            S                   LIKE(BBCOLC)
     D Lt_PBCA         S                   LIKE(Wk_PBCA)
     D Lt_PSSH         S                   LIKE(Wk_PSSH)
     D Lt_PCPY         S                   LIKE(Wk_PCPY)
     D Lt_PDUD         S                   LIKE(Wk_PDUD)
     D Lt_PEVT         S                   LIKE(Wk_PEVT)
     D Lt_TNLU         S                   LIKE(Wk_TNLU)
     D Lt_TXBS         S                   LIKE(Wk_TXBS)
     D Lt_EXCD         S                   LIKE(Wk_EXCD)
     D Lt_BNFO         S                   LIKE(Wk_BNFO)
     D @Mket           S                   LIKE(LU_UDMK)
     D @NomlDiff       S             13  0
     D @NoDoc          S              1
     D @NoTax          S              1
     D NWrtn           S              3  0
     D @PositDate      S              5  0
     D @PDate          S                   LIKE(LU_UDDT)
     D PgmErr          S              1
     D @Rec_Found      S              1
     D @RoundingRec    S              1
     D @Secty          S                   LIKE(INSECS)
     D @SetExCode      S              1
     D @SITP           S                   LIKE(SE_SITP)
     D @TreatyTax      S              1
     D @TVInd          S              1                                         186001
     D @U_Cost         S             15  0                                      186001
     D @U_Exnml        S                   LIKE(LU_UECN)
     D @U_TDnml        S                   LIKE(LU_UDNT)
     D @U_VDnml        S                   LIKE(LU_UDNV)
     D @UnitIncome     S             13  9
     D Upd_Rounding    S              1                                         185604
     D @WhingTax       S                   LIKE(NW_PAMD)
     D***** @Portfolio      S                   LIKE(INPTFR)                           233084 HUT118

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

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
      ** Get Security Details
      *

     C                   MOVE      IN_PSSH       @Secty
     C     IN_PSSH       CHAIN     SECTY                              21
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SECTYD'
     C                   EVAL      DBKEY  =  In_PSSH
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  102
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If no error and Country of Tax Treaty in the security detail
      ** is equal to *BLANK, then output the original record to file.
      *
     C     SE_CRTT       IFEQ      *BLANK
     C                   EVAL      @TreatyTax = 'N'
     C                   EVAL      Wk_RPCD = *BLANKS                            185748
     C                   EXSR      SRWrtOrUpd
     C                   ELSE
     C                   EVAL      @TreatyTax = 'Y'
     C                   EVAL      Wk_CRTX = SE_CRTT
     C                   EVAL      Wk_ICTP = SE_INCT

     C                   ENDIF
      *
      ** If Treaty Tax processing is needed
      *
     C                   IF        @TreatyTax = 'Y'
      *
      ** Get Investment Details
      *
     C     InvestKey     CHAIN     INVTP                              22
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'INVTPD'
     C                   EVAL      DBKEY  =  SE_SITP
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  103
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Process input Position Settlement record depending on the Customer
      ** type.
      *
     C     IN_CTYP       IFEQ      'C'
     C                   MOVE      In_PCPY       @Cust
     C                   MOVE      In_PCPY       @HoldingCust
     C                   EXSR      SRCust
     C                   ELSE
     C                   EXSR      SRDepot
     C                   ENDIF

     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCust - Process Customer Position Settlement Record          *
      *                                                               *
      * Called by: Main, SRCPoset                                     *
      *                                                               *
      * Calls: SRCustInfo, SRWrtOrUpd, SRSingleRec, SRInter           *
      *                                                               *
      *****************************************************************

     C     SRCust        BEGSR

     C                   MOVE      ' '           @CallFrom                      186001
     C                   EXSR      SRCustInfo
      *
      ** If no withholding tax needs to be appied to the customer
      ** or Customer is exempt from tax
      ** Then If it is a customer's position settlement
      **      Then output the original record to file.
      **      ELSE Setup position settlement record using customer depot
      **           position information and group the result in the correct
      **           tax basket.
      *
     C                   IF        In_PPRE = 'R' and In_CTYP = 'C'                            216556
     C                   EVAL      @NoTax = 'Y'                                               216556
     C                   END                                                                  216556
      *                                                                                       216556
     C     @NoTax        IFEQ      'Y'

     C                   EVAL      Wk_TASO = 0
     C                   EVAL      Wk_TAUS = 0
     C                   EVAL      Wk_TASR = 0
     C***********        EVAL      Wk_DAMT = 0                                  186051
     C                   EVAL      Wk_DAMT = In_DAMT                            186051
      *
      ** If Position Settlement is for Customer Position then
      ** find out what depot the holding is at.
      *
     C********           EVAL      LC_CDPT = 0                                  HUT118
     C                   EVAL      LC_CDPT = *BLANKS                            HUT118
     C                   IF        In_CTYP = 'C'
                                                                                              203270
     C                   IF        In_PEVT = 'DV'                                             203270
      *                                                                                       203270
      ** If S01510 is on, @EvDate should be '@PositDate - 1' since                            203270
      ** SE2400 adds 1 to the ex-date before passing it to SE2310                             203270
      *                                                                                       203270
     C                   IF        S01510 = 'Y'                                               203270
     C                   EVAL      @EvDate = @PositDate - 1                                   203270
     C                   ELSE                                                                 203270
     C                   EVAL      @EvDate = @PositDate                                       203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ELSE                                                                 203270
     C*******************EVAL      @EvDate = @LCouponD                                 203270 221659
     C                   EVAL      @EvDate = IN_PDUD                                          221659
     C                   ENDIF                                                                203270
                                                                                              203270
     C**   CdepsPKey     SETGT     CDEPSL1                                             203270 242428
     C     Cdeps2PKey    SETGT     CDEPSL2                                                    242428
     C                   MOVE      '0'           *IN35                                        203270
     C                   MOVE      '0'           *IN36                                        203270
     C******             Z-ADD     0             Wk_DEPT2          6 0                 203270 HUT118
     C                   MOVEL     *BLANKS       Wk_DEPT2          6                          HUT118
                                                                                              203270
     C     *IN35         DOWEQ     '0'                                                        203270
     C*****CdepsPKey     CHAIN     CDEPS                              30                      201820
     C*****CdepsPKey     CHAIN     CDEPX1                             30             201820   203270
     C**   CdepsPKey2    READPE    CDEPSL1                                30           203270 242428
     C     Cdeps2PKey2   READPE    CDEPSL2                                30                  242428
     C     *IN30         IFEQ      '0'                                                        203270
      *                                                                                       203270
      ** If the event type is a Dividend Payment, check if Trade or                           203270
      ** Value date basis. Then make sure the corresponding nominal                           203270
      ** is not zero. If not a Dividend Payment, Value Date Nominal                           203270
      ** should not be zero.                                                                  203270
      *                                                                                       203270
     C                   IF        In_PEVT <> 'DV'                                            203270
     C                             and LC_CDNV <> 0                                           203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and LC_CDNT <> 0                                           203270
     C                             and InTVPosit = 'T'                                        203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and InTVPosit = 'V'                                        203270
     C                             and LC_CDNV <> 0                                           203270
      *                                                                                       203270
      ** If the previous position read has a nominal of zero, its                             203270
      ** depot should not be used                                                             203270
      *                                                                                       203270
     C     *IN36         IFEQ      '0'                                                        203270
     C     *IN36         OREQ      '1'                                                        203270
     C     Wk_DEPT2      ANDNE     LC_CDPT                                                    203270
                                                                                              203270
     C*******            IF        LC_CDPT <> 0                                 HUT118
     C                   IF        LC_CDPT <> *BLANKS                           HUT118
     C                   MOVE      LC_CDPT       Wk_DEPT
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If the nominal is zero                                                               203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      '1'           *IN36                                        203270
     C                   MOVE      LC_CDPT       Wk_DEPT2                                     203270
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If no record was found using READPE                                                  203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      *BLANKS       Wk_DEPT                                      203270
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ENDDO                                                                203270
                                                                                              203270
     C                   ENDIF
     C*******            IF        LC_CDPT = 0                                  HUT118
     C                   IF        LC_CDPT = *BLANKS                            HUT118
     C                   MOVE      *BLANKS       Wk_DEPT
     C                   ENDIF

     C                   EVAL      Wk_RPCD = WHRPCD                             185748
     C                   EVAL      Wk_PNMP = @CTotNoml                          196830
     C                   EVAL      Wk_PAMD = @CTotAmt                           196830
     C                   EVAL      Wk_PCHA = @CTotChg                           196830
     C                   EVAL      Wk_PCAM = @CTotComm                          196830
     C                   EXSR      SRWrtOrUpd
     C                   ENDIF
      *
      ** If withholding Tax needs to be applied and Documentation status
      ** is not equal to 'I', then calculte tax for single customer
      ** Else calculate tax for Intermediary.
      *
     C     @NoTax        IFEQ      'N'

     C                   IF        WHDCRC <> 'I'
     C                   EXSR      SRSingleRec

     C                   ELSE
     C                   EXSR      SRInter
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustInfo - Get Customer withholding Tax details             *
      *                                                               *
      * Called by: SRCust                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     SRCustInfo    BEGSR

      ** Only Process this part if not call from Subroutine SRICInfo            186001
      *                                                                         186001
     C                   IF        @CallFrom <> 'U'                             186001
                                                                                186001
     C                   IF        In_CTYP = 'C'
     C                   EVAL      @CTotAmt = In_PAMD
     C                   EVAL      @CTotNoml = In_PNMP
     C                   EVAL      @CTotChg = In_PCHA
     C                   EVAL      @CTotComm = In_PCAM
     C                   ELSE
     C                   EVAL      @CTotNoml = Wk_PNMP
     C                   EVAL      @CTotAmt = In_PAMD * @CTotNoml / In_PNMP
     C                   EVAL      @CTotChg = In_PCHA * @CTotNoml / In_PNMP
     C                   EVAL      @CTotComm = In_PCAM * @CTotNoml / In_PNMP
     C                   ENDIF
      *
      ** If Position Settlement record is for Maturity Event, and the
      ** OID indicator on security details is equal to 'Y'
      ** or OID indicator is equal to 'S' (Short term security)                 185292
      ** then need to calculate the cost for the holding.
      *
     C*************      IF        In_PEVT = 'MT' and SE_OIDI = 'Y'             185292
     C                   EVAL      @Discount = 0                                185292
     C                   EVAL      In_DAMT = 0                                  185292
     C                   IF        In_PEVT = 'MT'                               185292
     C                   IF        SE_OIDI = 'Y' or SE_OIDI = 'S'               185292
     C                   MOVE      @Cust         @CustNo
     C     CposnKey      CHAIN     CPOSN                              25
     C                   IF        *IN25 = '1'
     C                   EVAL      CP_CSPT = 0
     C                   EVAL      CP_CSNT = 1
     C                   ENDIF
                                                                                185731
     C                   IF        CP_CSNT = 0                                  185731
     C                   EVAL      @Cost = 0                                    185731
     C                   ELSE                                                   185731
     C                   EVAL      @Cost = @CTotNoml * CP_CSPT / CP_CSNT
     C                   ENDIF                                                  185731
     C                   EVAL      @Discount = @CTotAmt -  @Cost
     C                   EVAL      In_DAMT = @Discount

     C*************      ELSE
     C*************      EVAL      In_DAMT = 0
     C                   ENDIF
     C                   ENDIF                                                  185292

     C                   ENDIF
      *
      ** Get Customer Country of residence
      *
     C*******************CALLB     'AOCUSTR0'                                  TLIFIX
     C                   CALLB     'AOCUSTR1'                                  TLIFIX
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @Cust         @KEY1            10
     C                   PARM                    @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                         TLIFIX
     C     SDCUST        PARM      SDCUST        DSLDY                         TLIFIX
      *
      ** If Customer detail not found, issue DB error.
      *
     C     @RTCD         IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'                                         TLIFIX
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  @KEY1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  104
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRCustInfo'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       203270
      ** Check if S01510 is switched on                                                       203270
      *                                                                                       203270
     C                   CALL      'AOSARDR0'                                                 203270
     C                   PARM      *BLANKS       @RTCD                                        203270
     C                   PARM      '*VERIFY'     @OPTN                                        203270
     C                   PARM      'S01510'      @SARD             6                          203270
                                                                                              203270
     C                   IF        @RTCD = *BLANKS                                            203270
     C                   MOVE      'Y'           S01510            1                          203270
     C                   ELSE                                                                 203270
     C                   MOVE      'N'           S01510                                       203270
     C                   ENDIF                                                                203270
      *
      ** Initialise work fields
      *
     C                   EVAL      @NoTax = 'N'
     C                   EVAL      @NoDoc = 'N'
     C                   EVAL      @SetExCode = 'N'
      *
      ** Initialise Exemption Code, Beneficial Number, and Tax Basket.
      *
     C                   EVAL      Wk_EXCD = '  '
     C                   EVAL      Wk_BNFO = *BLANKS
     C                   EVAL      Wk_TXBS = '  '
     C                   EVAL      Wk_TXBN = '  '                                             187962
      *
      ** Get withholding tax information for
      ** Country of Treaty, Investment type and location.
      *
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @Loc = BBCOLC

     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
      *                                                                                242304
      ** If no record found, then check if there is a record for general use           242304
      ** Country of Treaty,  Investment type and *BLANK (location)                     242304
      *                                                                                242304
     C     *IN31         IFEQ      '1'                                                 242304
     C                   MOVE      @Loc          @LocSV            2                   242304
     C                   MOVE      '  '          @Loc                                  242304
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31               242304
     C                   MOVE      @LocSV        @Loc                                  242304
     C                   ENDIF                                                         242304
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty,  *BLANK (Investment) and location.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      '   '         @SITP
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *                                                                                242304
      ** If no record found, then check if there is a record for general use           242304
      ** Country of Treaty, *BLANK (Investment) and *BLANK (location)                  242304
      *                                                                                242304
     C     *IN31         IFEQ      '1'                                                 242304
     C                   MOVE      @Loc          @LocSV            2                   242304
     C                   MOVE      '  '          @Loc                                  242304
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31               242304
     C                   MOVE      @LocSV        @Loc                                  242304
     C                   ENDIF                                                         242304
      *                                                                                242304
      ** If no record found with location = *BLANK, following processing will          242304
      ** retrieve first record (with any location)                                     242304
      ** => 'Default Basket for No Documentation' will then be used                    242304
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, Investment type and *BLANK (Location)
      ** to get default tax basket for No Documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, *BLANK (Investment) and *BLANK (Location)
      ** to get default tax basket for No Documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      *BLANKS       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then Data Base Error
      *
     C     *IN31         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDWHTTPD'
     C                   EVAL      DBKEY  =  SE_CRTT + SE_SITP + BBCOLC
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  105
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRCustInfo'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save Customer No documentation tax basket
      *
     C                   EVAL      @CustNDTXBS = WTDBDC
      *
      ** Get Customer Withholding Tax detail
      *
     C     Wt_CustKey    CHAIN     SDWTCSL1                           32
      *
      ** If no record found, then treat the customer as no documentation
      ** and donot need to set up exemtion code.
      *
     C     *IN32         IFEQ      '1'
     C                   EVAL      @NoDoc = 'Y'
     C                   EVAL      @SetExCode = 'Y'
     C                   ELSE
      *                                                                                       187745
      ** But if tax basket from Customer details is not blank, revert                         187745
      ** to previous logic: dont treat the customer as no documentation                       187745
      *                                                                                       187745
     C                   IF        @NoDoc = 'Y'                                               187745
     C                   IF        WHTXBS <> *Blank AND WHDCRC <> 'E'                         187745
     C                             OR WHDCRC = 'E' AND WHEXCD <> *Blank                       187745
     C                   EVAL      @NoDoc = 'N'                                               187745
     C                   ENDIF                                                                187745
     C                   ENDIF                                                                187745
      *
      ** Check if Customer is exempted from Tax.
      *
      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
      ** and allow for portfolio income exemption is 'Y' and customer
      ** documentation is 'L'or 'Y', then it is exempt from Tax.
      *
     C                   IF        SE_APIE = 'Y'

     C                   IF        WHDCRC = 'L' or WHDCRC = 'Y'

     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'
     C**********         EVAL      @NoTax = 'Y'                                               216559
     C                   EVAL      @NoTax = 'Y'                                               225537
      *
      ** Tax basket = Default Portfolio Exemption Tax Basket
      *
     C                   EVAL      Wk_TXBS = WTPFEX
     C                   IF        Wk_TXBS = *BLANK                                           187962
     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
     C                   ENDIF                                                                187962
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        WHEXCD <> *BLANK
     C                   EVAL      WK_EXCD = WHEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXPI
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      ** If the customer documentation is 'E' then the customer is exempted
      ** from Tax.
      *
     C                   IF        WHDCRC = 'E'
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Customer Tax Basket
      *
     C                   EVAL      Wk_TXBS = WHTXBS
     C                   IF        Wk_TXBS = *BLANK                                           187962
     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
     C                   ENDIF                                                                187962
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'

     C                   IF        WHEXCD <> *BLANKS
     C                   EVAL      Wk_EXCD = WHEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXCD
     C                   ENDIF

     C                   ENDIF
      *                                                                         186303
      ** If OID = 'S', event = 'MT' and Documentation status is not 'U'         186303
      ** and is not 'N' then no tax will be calculated.                         186303
      *                                                                         186303
     C                   IF        WHDCRC <> 'U' AND WHDCRC <> 'N' AND          186303
     C                             WHDCRC <> 'I' AND                            186303
     C                             In_PEVT = 'MT' AND SE_OIDI = 'S'             186303
     C                   EVAL      @NoTax = 'Y'                                 186303
     C                   EVAL      Wk_EXCD = *BLANK                             186303
     C                   EVAL      Wk_TXBS = *BLANK                             186303
     C                   EVAL      Wk_TXBN = *BLANK                             186303
     C                   EVAL      Wk_DAMT = 0                                  186303
     C                   EVAL      @SetExCode = 'Y'                             186303
     C                   ENDIF                                                  186303

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSingleRec - Process withholding Tax for single individual   *
      *               Customer.                                       *
      *                                                               *
      * Called by: SRCust                                             *
      *                                                               *
      * Calls: SRCalTax, SRWrtOrUpd                                   *
      *                                                               *
      *****************************************************************

     C     SRSingleRec   BEGSR
      *
      ** Get Tax rate for Customer with no documentation.
      *
     C                   IF        WHDCRC = 'N' or @NoDoc = 'Y'

     C                   EVAL      @TaxBasket = WTDBDC
      *
      ** If position settlement is for Maturity and OID indicator is 'S'        185292
      ** then use Backup withholding tax rate.                                  185292
      *                                                                         185292
     C                   EVAL      Wk_EXCD = ' '                                185292
     C                   EVAL      @SetExCode = 'Y'                             185292
     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             185292
     C                   EVAL      @TaxBasket = WTDRBW                          185292
     C                   ENDIF                                                  185292

     C                   ELSE
      *
      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
      *
     C                   IF        WHDCRC = 'U'
     C                   EVAL      Wk_EXCD = ' '                                185292
     C                   EVAL      @SetExCode = 'Y'                             185292
     C                   EVAL      @TaxBasket = WTDRBW
     C                   ELSE
      *
      ** Get Tax rate for Customer with completed documentation
      ** If Tax basket on Customer detail = *BLANK then use tax basket from
      ** treaty detail.
      *
     C**********         IF        SE_APIE = 'N'                                       216559 218116
     C                   IF        SE_APIE = ' '                                              218116
     C                             or Wk_TXBS = ' '                                           FIXMRS
     C                   IF        WHTXBS <> *BLANKS
     C                   EVAL      @TaxBasket = WHTXBS
     C                   ELSE
     C                   EVAL      @TaxBasket = WTTXBS
     C                   ENDIF
     C                   ELSE                                                     216559
     C                   EVAL      @TaxBasket = Wk_TXBS                           216559
     C                   END                                                      216559
      *
      ** Set up Exemption Code
      ** If Exemption Code from customer is *BLANK then use exemption
      ** Code from the treaty
      *
     C                   If        @SetExCode = 'N'
     C                   If        @TaxBasket = WHTXBS or WHEXCD <> *BLANKS
     C                   EVAL      Wk_EXCD = WHEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXCD
     C                   ENDIF
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
      *
      ** If Position Settlement is for Customer Position then
      ** find out what depot the holding is at.
      *
     C*******            EVAL      LC_CDPT = 0                                  HUT118
     C                   EVAL      LC_CDPT = *BLANKS                            HUT118
     C                   IF        In_CTYP = 'C'
                                                                                              203270
     C                   IF        In_PEVT = 'DV'                                             203270
      *                                                                                       203270
      ** If S01510 is on, @EvDate should be '@PositDate - 1' since                            203270
      ** SE2400 adds 1 to the ex-date before passing it to SE2310                             203270
      *                                                                                       203270
     C                   IF        S01510 = 'Y'                                               203270
     C                   EVAL      @EvDate = @PositDate - 1                                   203270
     C                   ELSE                                                                 203270
     C                   EVAL      @EvDate = @PositDate                                       203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ELSE                                                                 203270
     C*******************EVAL      @EvDate = @LCouponD                                 203270 221659
     C                   EVAL      @EvDate = IN_PDUD                                          221659
     C                   ENDIF                                                                203270
                                                                                              203270
     C**   CdepsPKey     SETGT     CDEPSL1                                             203270 242428
     C     Cdeps2PKey    SETGT     CDEPSL2                                                    242428
     C                   MOVE      '0'           *IN35                                        203270
     C                   MOVE      '0'           *IN36                                        203270
     C******             Z-ADD     0             Wk_DEPT2          6 0                 203270 HUT118
     C                   MOVEL     *BLANKS       Wk_DEPT2          6                          HUT118
                                                                                              203270
     C     *IN35         DOWEQ     '0'                                                        203270
     C**** CdepsPKey     CHAIN     CDEPS                              30                      201820
     C*****CdepsPKey     CHAIN     CDEPX1                             30            201820    203270
     C**   CdepsPKey2    READPE    CDEPSL1                                30        203270    242428
     C     Cdeps2PKey2   READPE    CDEPSL2                                30                  242428
     C     *IN30         IFEQ      '0'                                                        203270
      *                                                                                       203270
      ** If the event type is a Dividend Payment, check if Trade or                           203270
      ** Value date basis. Then make sure the corresponding nominal                           203270
      ** is not zero. If not a Dividend Payment, Value Date Nominal                           203270
      ** should not be zero.                                                                  203270
      *                                                                                       203270
     C                   IF        In_PEVT <> 'DV'                                            203270
     C                             and LC_CDNV <> 0                                           203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and LC_CDNT <> 0                                           203270
     C                             and InTVPosit = 'T'                                        203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and InTVPosit = 'V'                                        203270
     C                             and LC_CDNV <> 0                                           203270
      *                                                                                       203270
      ** If the previous position read has a nominal of zero, its                             203270
      ** depot should not be used                                                             203270
      *                                                                                       203270
     C     *IN36         IFEQ      '0'                                                        203270
     C     *IN36         OREQ      '1'                                                        203270
     C     Wk_DEPT2      ANDNE     LC_CDPT                                                    203270
                                                                                              203270
     C*******            IF        LC_CDPT <> 0                                 HUT118
     C                   IF        LC_CDPT <> *BLANKS                           HUT118
     C                   MOVE      LC_CDPT       Wk_DEPT
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If the nominal is zero                                                               203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      '1'           *IN36                                        203270
     C                   MOVE      LC_CDPT       Wk_DEPT2                                     203270
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If no record was found using READPE                                                  203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      *BLANKS       Wk_DEPT                                      203270
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ENDDO                                                                203270
                                                                                              203270
     C                   ENDIF
     C*******            IF        LC_CDPT = 0                                  HUT118
     C                   IF        LC_CDPT = *BLANKS                            HUT118
     C                   MOVE      *BLANKS       Wk_DEPT
     C                   ENDIF
      *
      ** Set up Nominal and charges fields
      *
     C     COALRF        IFEQ      *BLANKS                                      215575
     C     IN_CTYP       OREQ      'C'                                          215575
     C                   EVAL      Wk_PNMP = @CTotNoml
     C                   EVAL      Wk_PAMD = @CTotAmt
     C                   END                                                    215575
     C                   EVAL      Wk_PCHA = @CTotChg
     C                   EVAL      Wk_PCAM = @CTotComm
      *
      ** Calculate withholding Tax
      *
     C                   EXSR      SRCalTax
      *                                                                         186000
      ** Set Up TIN                                                             186000
      *                                                                         186000
     C                   EVAL      Wk_CTIN = WHTIN                              186000
      *
      ** Output to POSETD
      *
     C                   EVAL      Wk_RPCD = WHRPCD                             185748
     C                   EXSR      SRWrtOrUpd

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalTax - Get Tax Basket Information and Calculate Tax amount*
      *                                                               *
      * Called by: SRSingleRec, SRInter, SRNDIFF                      *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     SRCalTax      BEGSR
     C                   EVAL      @CountryTax = SE_CRTT
     C                   EVAL      @EffDate   = IN_PDUD
      *

     C                   CALL      'AOTXBSR0'
     C                   PARM                    @RtnCode          7
     C                   PARM      '*KEY   '     @OptionCode       7
     C                   PARM                    @CountryTax       2
     C                   PARM                    @TaxBasket        2
     C                   PARM                    @EffDate          5 0
     C                   PARM                    @RtNarr          15
     C                   PARM                    @RtTaxRate        6 4

     C                   IF        @RtnCode <> *BLANKS
     C                   EVAL      @RtTaxRate = 0                                             239992
     C                   MOVE      *BLANKS       @RtNarr                                      239992
     C                   MOVEL     'NOT FOUND'   @RtNarr                                      239992
     C                   ENDIF
      *
      ** If no Error, then Calculate Withholding Tax.
      *
     C                   EVAL      @WhingTax = Wk_PAMD * @RtTaxRate / 100
     C                   EVAL      Wk_DAMT = 0
      *
      ** If Position is -ve, then no withholding tax
      *
     C                   IF        Wk_PNMP < 0
     C                   EVAL      @WhingTax = 0
     C                   EVAL      @TaxBasket = *BLANKS
     C                   EVAL      @RtNarr = *BLANKS
     C                   ENDIF

     C                   IF        WTDTSU = 'S'
     C                   EVAL      Wk_TASO = @WhingTax
     C                   EVAL      Wk_TAUS = 0
     C                   ELSE
     C                   EVAL      Wk_TAUS = @WhingTax
     C                   EVAL      Wk_TASO = 0
     C                   ENDIF

     C                   EVAL      Wk_TASR = 0
      *
      ** To ensure taht the output Tax basket is the tax basket used for
      ** the calucaltion of tax.
      *
     C                   EVAL      Wk_TXBS = @TaxBasket
     C                   EVAL      Wk_TXBN = @RtNarr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInter - Process Withholding Tax for Intermediary            *
      *                                                               *
      * Called by: SRCust                                             *
      *                                                               *
      * Calls: SRCalTax, SRWrtOrUpd, SRNDIFF                          *
      *                                                               *
      *****************************************************************

     C     SRInter       BEGSR
      *
      ** Initialise cumulative fields
      *
     C                   EVAL      @AccAmtDue = 0
     C                   EVAL      @AccPosit = 0
     C                   EVAL      @AccCharge = 0
     C                   EVAL      @AccComm = 0
     C                   EVAL      @Rec_Found = 'N'
     C                   EVAL      @RoundingRec = 'N'
     C                   EVAL      Wk_DEPT = *BLANKS
      *
      ** set up Holding Depot for Intermediary Details
      *
     C                   IF        In_CTYP = 'C'
     C                   EVAL      @HoldingDept = *LOVAL
     C                   ELSE
     C                   MOVE      In_PCPY       @HoldingDept
     C                   END
      *
      ** Get beneficial Holding by reading Intermediary detail until EOF.
      *
     C******             EVAL      @Portfolio = In_PTFR                                233084 HUT118

     C******             IF        In_CTYP = 'C'                                       233084 HUT118
     C*****InterMCkey    SETLL     SDINTCLL1                          34               233084 HUT118
     C*****              ELSE                                                          233084 HUT118
     C     InterMlkey    SETLL     SDINTCLL1                          34
     C******             ENDIF                                                         233084 HUT118

     C     *IN34         DOUEQ     '1'

     C*****              IF        In_CTYP = 'C'                                       233084 HUT118
     C*****InterMCkey    READE     SDINTCLL1                              34           233084 HUT118
     C*****              ELSE                                                          233084 HUT118
     C     InterMlkey    READE     SDINTCLL1                              34
     C*****              ENDIF                                                         233084 HUT118

     C                   IF        *IN34 = '0'
     C                             AND INTOTH <> 0                              185756
      *
      ** Initialise exemption code and tax basket for each beneficial owner
      *
     C                   EVAL      Wk_TXBS = '  '
     C                   EVAL      Wk_EXCD = '  '
     C                   EVAL      @SetExCode = 'N'
     C                   IF        In_CTYP = 'C'
     C                   MOVE      INDEPT        Wk_DEPT
     C                   ENDIF
      *
      ** Workout the total holding for the beneficial owner
      ** (If the total holding in the Intermediary Client details is equal
      ** to the total holding for the customer, then use the holding from
      ** file, else use the ratio between the total holding and the holding
      ** to caluclate the holding for the beneficial owner.)
      *
     C                   IF        @CTotNoml = INTOTH
     C                   EVAL      Wk_PNMP = INHLDN
     C                   ELSE
     C                   EVAL      Wk_PNMP = @CTotNoml * INHLDN / INTOTH
     C                   ENDIF
      *
      ** Workout the total amount due to the beneficial owner
      *
     C                   EVAL      Wk_PAMD = @CTotAmt * Wk_PNMP / @CTotNoml
      *
      ** Set up Withholding Tax Basket
      *
     C                   EXSR      SRGetBenTax
      *                                                                         186237
     C                   EVAL      Wk_DAMT = 0                                  186237
      *
      ** Calucalte Withholding Tax
      *
     C                   IF        @NoTax = 'N'
     C                   EXSR      SRCalTax
     C                   ELSE                                                   186303
     C                   EVAL      Wk_TASO = 0                                  186303
     C                   EVAL      Wk_TAUS = 0                                  186303
     C                   EVAL      Wk_TASR = 0                                  186303
     C                   EVAL      Wk_TXBN = @RtNarr                            186237
     C                   ENDIF
      *
      ** Set up fields for position settlement
      *
     C                   EVAL      Wk_BNFO = INBONO
     C                   EVAL      Wk_CTIN = INCSTN

     C                   EXSR      SRWrtOrUpd

     C                   IF        Wk_PNMP <> 0
     C                   EVAL      @AccAmtDue = @AccAmtDue + Wk_PAMD
     C                   EVAL      @AccPosit = @AccPosit + Wk_PNMP
     C                   EVAL      @AccCharge = @AccCharge + Wk_PCHA
     C                   EVAL      @AccComm = @AccComm + Wk_PCAM
     C                   ENDIF

     C                   ENDIF
     C                   ENDDO
      *
      ** Check for rounding error
      *
     C                   EVAL      @NomlDiff = @CTotNoml - @AccPosit
     C                   EVAL      @AmtDiff  = @CTotAmt - @AccAmtDue
     C                   EVAL      @ChgDiff  = @CTotChg - @AccCharge
     C                   EVAL      @CommDiff = @CTotComm - @AccComm
      *
      ** Output a new position settlement record if Nominal is not the
      ** same as the total nominal and it will be taxed as it is without
      ** any documentation.
      *
     C                   IF        @NomlDiff <> 0
     C                   EXSR      SRNDIFF
     C                   END

     C                   IF        @AmtDiff <> 0 or
     C                             @ChgDiff <> 0 or @CommDiff <> 0
      *
      ** Get position settlement record to update rounding
      ** If Record for rounding is defined then get the position settlement
      ** using the last key.
      *
     C                   IF        @Rec_Found = 'Y'
     C                   EVAL      Wk_PBCA = Lt_PBCA
     C                   EVAL      Wk_PSSH = Lt_PSSH
     C                   EVAL      Wk_PCPY = Lt_PCPY
     C                   EVAL      Wk_PDUD = Lt_PDUD
     C                   EVAL      Wk_PEVT = Lt_PEVT
     C                   EVAL      Wk_TNLU = Lt_TNLU
     C                   EVAL      Wk_TXBS = Lt_TXBS
     C                   EVAL      Wk_EXCD = Lt_EXCD
     C                   EVAL      Wk_BNFO = Lt_BNFO
     C                   ENDIF
      *                                                                         185604
      ** Initialise work fields                                                 185604
      *                                                                         185604
     C                   EVAL      Wk_PNMP = 0                                  185604
     C                   EVAL      Wk_TASO = 0                                  185604
     C                   EVAL      Wk_TAUS = 0                                  185604
     C                   EVAL      Wk_PSAT = 0                                  185604
     C                   EVAL      Wk_DAMT = 0                                  185604
     C                   EVAL      Upd_Rounding = 'Y'                           185604
      *
      ** Else add the rounding to the last position settlement record.
      *

     C                   EVAL      Wk_PAMD = @AmtDiff
     C                   EVAL      Wk_PCHA = @ChgDiff                           185604
     C                   EVAL      Wk_PCAM = @CommDiff                          185604

     C                   EXSR      SRWrtOrUpd

     C                   EVAL      Upd_Rounding = 'N'                           185604

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetBenTax - Get Tax Basket for Beneficial Owner             *
      *                                                               *
      * Called by: SRInter                                            *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     SRGetBenTax   BEGSR
      *
      ** Get Benefical Owners details - If Beneficial Owner Number is not
      ** equal to *BLANK
      *
     C                   IF        INBONO <> *BLANK

     C                   EVAL      @INCNUM = INCNUM
     C                   EVAL      @INBONO = INBONO
     C                   EVAL      @HoldingDept = INDEPT
     C                   EVAL      @BenDept = @HoldingDept                      185936
     C*****              EVAL      @INPTFR = INPTFR                                    233084 HUT118
     C     SDBNFOKey     CHAIN     SDBNFOL1                           33
     C                   IF        *IN33 = '1'
     C                   EVAL      @BenDept = *BLANKS                           185936
     C     SDBNFOKey     CHAIN     SDBNFOL1                           33
      *
      ** If no record found, then Database error
      *
     C     *IN31         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBNFOPD'
     C                   EVAL      DBKEY  =  SE_CRTT + INCNUM + INBONO
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  110
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRGetBenTax'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ELSE
     C                   MOVE      '1'           *IN33

     C                   ENDIF
      *
      ** Initialise Exemption Code, Beneficial Number, and Tax Basket.
      *
     C                   EVAL      @RoundingRec = 'N'
     C                   EVAL      @NoDoc = 'N'
     C                   EVAL      @NoTax = 'N'
      *
      ** If Beneficial Owner record found
      *
     C                   IF        *IN33 = '0'

     C                   IF        BNDFRD = 'Y'
     C                   EVAL      @RoundingRec = 'Y'
     C                   ENDIF
      *
      ** Set Up Recipient Code for Beneficial Owner
      ** (Only if record found and the position settlement is for
      **  Customer).
      *
     C                   IF        In_CTYP = 'C'
     C                   EVAL      Wk_RPCD = BNRPCD
     C                   ENDIF
      *
      ** Get withholding tax information for
      ** Country of Treaty, Investment type and location.
      ** with location from the benefical owner detail if not *BLANK
      *
     C                   IF        BNCTRS <> *BLANKS
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @Loc = BNCTRS

     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
      *                                                                                242304
      ** If no record found, then check if there is a record for general use           242304
      ** Country of Treaty,  Investment type and *BLANK (location)                     242304
      *                                                                                242304
     C     *IN31         IFEQ      '1'                                                 242304
     C                   MOVE      @Loc          @LocSV            2                   242304
     C                   MOVE      '  '          @Loc                                  242304
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31               242304
     C                   MOVE      @LocSV        @Loc                                  242304
     C                   ENDIF                                                         242304
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty,  *BLANK (Investment) and location.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      '   '         @SITP
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *                                                                                242304
      ** If no record found, then check if there is a record for general use           242304
      ** Country of Treaty, *BLANK (Investment) and *BLANK (location)                  242304
      *                                                                                242304
     C     *IN31         IFEQ      '1'                                                 242304
     C                   MOVE      @Loc          @LocSV            2                   242304
     C                   MOVE      '  '          @Loc                                  242304
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31               242304
     C                   MOVE      @LocSV        @Loc                                  242304
     C                   ENDIF                                                         242304
      *                                                                                242304
      ** If no record found with location = *BLANK, following processing will          242304
      ** retrieve first record (with any location)                                     242304
      ** => 'Default Basket for No Documentation' will then be used                    242304
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, Investment type and *BLANK (Location)
      ** for default tax basket for no documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, *BLANKS (Investment) and *BLANK (Location)
      ** for default tax basket for no documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      *BLANKS       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then DBase error.
      *
     C     *IN31         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDWHTTPD'
     C                   EVAL      DBKEY  =  SE_CRTT + SE_SITP + BNCTRS
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  107
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRGetBenTax'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       187745
      ** But if tax basket from Beneficial owner details is not blank,                        187745
      ** dont treat the beneficial owner as no documentation                                  187745
      *                                                                                       187745
     C                   IF        @NoDoc = 'Y'                                               187745
     C                   IF        BNTXBS <> *Blank AND BNDCRC <> 'E'                         187745
     C                             OR BNDCRC = 'E' AND BNEXCD <> *Blank                       187745
     C                   EVAL      @NoDoc = 'N'                                               187745
     C                   ENDIF                                                                187745
     C                   ENDIF                                                                187745
      *
      ** Check if Customer is exempted from Tax.
      *
      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
      ** and allow for portfolio income exemption is 'Y' and customer
      ** documentation is 'L'or 'Y', then it is exempt from Tax.
      *
     C                   IF        SE_APIE = 'Y'

     C                   IF        BNDCRC = 'L' or BNDCRC = 'Y'

     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'

     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Default Portfolio Exemption Tax Basket
      *
     C                   EVAL      Wk_TXBS = WTPFEX
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        BNEXCD <> *BLANK
     C                   EVAL      WK_EXCD = BNEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXPI
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      ** If the customer documentation is 'E' then the customer is exempted
      ** from Tax.
      *
     C                   IF        BNDCRC = 'E'
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Customer Tax Basket
      *
     C                   EVAL      Wk_TXBS = BNTXBS
     C                   IF        Wk_TXBS = *BLANK                                           187962
     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
     C                   ENDIF                                                                187962
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'

     C                   IF        BNEXCD <> *BLANKS
     C                   EVAL      Wk_EXCD = BNEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXCD
     C                   ENDIF

     C                   ENDIF
      *                                                                         186303
      ** If OID = 'S', event = 'MT' and Documentation status is not 'U'         186303
      ** and is not 'N' then no tax will be calculated.                         186303
      *                                                                         186303
     C                   IF        BNDCRC <> 'U' AND BNDCRC <> 'N' AND          186303
     C                             In_PEVT = 'MT' AND SE_OIDI = 'S'             186303
     C                   EVAL      @NoTax = 'Y'                                 186303
     C                   EVAL      Wk_EXCD = *BLANK                             186303
     C                   EVAL      Wk_TXBS = *BLANK                             186303
     C                   EVAL      Wk_TXBN = *BLANK                             186303
     C                   EVAL      Wk_DAMT = 0                                  186303
     C                   EVAL      @SetExCode = 'Y'                             186303
     C                   ENDIF                                                  186303

      ** Check if position is exempted from Tax.                                228553
      *                                                                         228553
     C                   IF        WHDCRC = 'E' or WHDCRC = 'Y'                 228553
      *                                                                         228553
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'       228553
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'    228553
     C                   EVAL      @NoTax = 'Y'                                 228553
     C                   EVAL      Wk_TXBS = '06'                               228553
     C                   EVAL      Wk_TXBN = 'Port Interest'                    228553
     C                   EVAL      Wk_DAMT = 0                                  228553
     C                   EVAL      @SetExCode = 'Y'                             228553
     C                   ENDIF                                                  228553
      *                                                                         228553
     C                   ENDIF                                                  228553
      *                                                                         186303
      ** Get Tax Basket if tax calucaltion is needed                            186303
      *                                                                         186303
     C                   IF        @NoTax = 'N'                                 186303
      *
      ** Get Tax rate for Customer with no documentation.
      *
     C                   IF        BNDCRC = 'N' or @NoDoc = 'Y'

     C                   EVAL      @TaxBasket = WTDBDC
      *                                                                         185292
      ** If position settlement is for Maturity and OID indicator is 'S'        185292
      ** then use Backup withholding tax rate.                                  185292
      *                                                                         185292
     C                   EVAL      Wk_EXCD = ' '                                185292
     C                   EVAL      @SetExCode = 'Y'                             185292
     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             185292
     C                   EVAL      @TaxBasket = WTDRBW                          185292
     C                   ENDIF                                                  185292

     C                   ELSE
      *
      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
      *
     C                   IF        BNDCRC = 'U'
     C                   EVAL      Wk_EXCD = ' '                                185292
     C                   EVAL      @SetExCode = 'Y'                             185292
     C                   EVAL      @TaxBasket = WTDRBW
     C                   ELSE
      *
      ** Get Tax rate for Customer with completed documentation
      ** If Tax basket on Customer detail = *BLANK then use tax basket from
      ** treaty detail.
      *
     C                   IF        INTXBS <> *BLANKS
     C                   EVAL      @TaxBasket = INTXBS
     C                   ELSE
     C                   IF        BNTXBS <> *BLANKS
     C                   EVAL      @TaxBasket = BNTXBS
     C                   ELSE
     C                   EVAL      @TaxBasket = WTTXBS
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up Exemption Code
      ** If Exemption Code from customer is *BLANK then use exemption
      ** Code from the treaty
      *
     C                   If        @SetExCode = 'N'
     C                   If        @TaxBasket = BNTXBS or BNEXCD <> *BLANKS
     C                             or @TaxBasket = INTXBS
     C                   EVAL      Wk_EXCD = BNEXCD
     C                   ELSE
     C                   EVAL      Wk_EXCD = WTEXCD
     C                   ENDIF
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  187179

     C                   IF        *IN33 = '1'
      *
      ** 1. No Docoumentation - use the no documentation basket
      ** 2. Use Tax Basket from Intermediary holding detail if set up
      ** 3. Use tax basket from Treaty if none set up for above.
      *
      ** CASE 1
     C                   IF        @NoDoc = 'Y'
     C                   EVAL      Wk_EXCD = '  '
     C                   EVAL      @SetExCode = '  '
     C                   EVAL      @TaxBasket = WTDBDC

     C                   ELSE
      ** CASE 2
     C                   IF        INTXBS <> *BLANK
     C                   EVAL      @TaxBasket = INTXBS

     C                   ELSE
      ** CASE 3
     C                   EVAL      @TaxBasket = WTTXBS
     C                   IF        @SetExCode = 'N'
     C                   EVAL      Wk_EXCD = WTEXCD
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *                                                                         187179
      ** If OID = 'S', event = 'MT' then no tax will be calculate               187179
      *                                                                         187179
     C                   IF        In_PEVT = 'MT' AND SE_OIDI = 'S'             187179
     C                   EVAL      @NoTax = 'Y'                                 187179
     C                   EVAL      Wk_EXCD = *BLANK                             187179
     C                   EVAL      Wk_TXBS = *BLANK                             187179
     C                   EVAL      Wk_TXBN = *BLANK                             187179
     C                   EVAL      Wk_DAMT = 0                                  187179
     C                   EVAL      @SetExCode = 'Y'                             187179
     C                   ENDIF                                                  187179

     C                   ENDIF

     C************       ENDIF                                           186303 187179
                                                                                186303
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrtOrUpd - Write new Position record or Update position     *
      *              record if record with the same key exist on file.*
      *                                                               *
      * Called by: SRCust, SRSingleRec, SRInter, SRNDIFF, SRUDPos     *
      *                                                               *
      * Calls: SRSetlAmt                                              *
      *                                                               *
      *****************************************************************

     C     SRWrtOrUpd    BEGSR
      *
      ** Only output to file if holding is not equal 0.
      *
     C*******************IF        Wk_PNMP <> 0                                 185604
     C                   IF        Wk_PNMP <> 0 or Upd_Rounding = 'Y'           185604

     C                   EVAL      *IN23 = '1'
      *
      ** Only if the Security is cover by the Treaty withholding Tax.
      *
     C                   IF        @TreatyTax = 'Y'
      *
      ** Set up recipient Code if the position settlement is for
      ** Customer position.
      *
     C***********        EVAL      Wk_RPCD = WHRPCD                             185748
      *
      ** Calculate Settlement Amount - only if Withholding Tax is being
      ** calculated or the Nominal position is not the same as the original
      ** position settlement.
      *
      *                                                                         188071
      ** If the settlement amount became <0 due to charges, commissions         188071
      *  taxes, adjust the charges/commission amount to have a sett= 0.         188071
      *                                                                         188071
      ** Check if position is exempted from Tax.                                197644
      *                                                                         197644
      ** If security is SHARE (Adr's), ie processing type is 4                  197644
      ** and  income type is '08 , then it is exempt from Tax.                  197644
      *                                                                         197644
     C                   IF        PROT = '4'                                   197644
     C                   IF        SE_INCT = '08'                               197644
     C                   EVAL      Wk_TASO = 0                                  197644
     C                   EVAL      Wk_TAUS = 0                                  197644
     C                   EVAL      Wk_TASR = 0                                  197644
     C                   EVAL      Wk_TXBS = WTPFEX                             197644
     C                   EVAL      Wk_TXBN = 'Portfolio Int.'                   197644
     C                   ENDIF                                                  197644
     C                   ENDIF                                                  197644
      *                                                                         197644
      ** Check if position is exempted from Tax. Portfolio Interest Exemption   197644
      ** is 'Y' so do not calculate any tax                                     197644
      *                                                                         197644
     C**********         IF        SE_APIE = 'Y'                                       197644 203541
     C                   IF        SE_APIE = 'Y' and WHDCRC <> 'U'                            203541
      *                                                                         197644
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'       197644
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'    197644
     C                   EVAL      @NoTax = 'Y'                                 197644
     C                   EVAL      Wk_TASO = 0                                  197644
     C                   EVAL      Wk_TAUS = 0                                  197644
     C                   EVAL      Wk_TASR = 0                                  197644
     C                   EVAL      Wk_TXBS = WTPFEX                             197644
     C                   EVAL      Wk_TXBN = 'Portfolio Int.'                   197644
     C                   ENDIF                                                  197644
     C                   ENDIF                                                  197644
     C                   Z-ADD     0             WTOTC                          188071
     C                   Z-ADD     0             WTAX                           188071
     C                   Z-ADD     0             WTOTCT                         188071
     C     Wk_PCHA       ADD       Wk_PCAM       WTOTC            13 0          188071
     C     Wk_TASO       ADD       Wk_TAUS       WTAX             13 0          188071
     C     WTOTC         ADD       WTAX          WTOTCT           13 0          188071
      *                                                                         188071
     C     WTOTCT        IFGT      Wk_PAMD                                      188071
     C     Wk_PAMD       SUB       WTAX          WPAMD            13 0          188071
     C     WPAMD         IFLT      Wk_PCHA                                      188071
     C                   Z-ADD     0             Wk_PCAM                        188071
     C                   Z-ADD     WPAMD         Wk_PCHA                        188071
     C                   ELSE                                                   188071
     C     WPAMD         SUB       Wk_PCHA       Wk_PCAM                        188071
     C                   ENDIF                                                  188071
     C                   ENDIF                                                  188071
     C                   IF        Wk_PNMP <> In_PNMP OR Wk_TASO <> 0
     C                             OR Wk_TAUS <> 0

     C*******************IF        Wk_PNMP <> In_PNMP                           185604
     C     COALRF        IFEQ      *BLANKS                                      215575
     C     IN_CTYP       OREQ      'C'                                          215575
     C                   IF        Wk_PNMP <> In_PNMP AND Wk_PNMP <> 0          185604
     C                   EVAL      Wk_PAMD = In_PAMD * Wk_PNMP / In_PNMP
     C                   EVAL      Wk_PCHA = In_PCHA * Wk_PNMP / In_PNMP
     C                   EVAL      Wk_PCAM = In_PCAM * Wk_PNMP / In_PNMP
     C                   ENDIF
     C                   END                                                    215575

     C                   EXSR      SRSetlAmt
     C                   ENDIF
      *
      ** If the record will be used to correct rounding, then store the key
      *
     C                   IF        @RoundingRec = 'Y'
     C                   EVAL      Lt_PBCA = Wk_PBCA
     C                   EVAL      Lt_PSSH = Wk_PSSH
     C                   EVAL      Lt_PCPY = Wk_PCPY
     C                   EVAL      Lt_PDUD = Wk_PDUD
     C                   EVAL      Lt_PEVT = Wk_PEVT
     C                   EVAL      Lt_TNLU = Wk_TNLU
     C                   EVAL      Lt_TXBS = Wk_TXBS
     C                   EVAL      Lt_EXCD = Wk_EXCD
     C                   EVAL      Lt_BNFO = Wk_BNFO
     C                   EVAL      @Rec_Found = 'Y'
     C                   EVAL      @RoundingRec = 'N'
     C                   ENDIF
      *
      ** Check if position is exempted from Tax.                                228553
      *                                                                         228553
     C                   IF        WHDCRC = 'E' or WHDCRC = 'Y'                 228553
      *                                                                         228553
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'       228553
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'    228553
     C                   EVAL      Wk_TASO = 0                                  228553
     C                   EVAL      Wk_TXBS = '06'                               228553
     C                   EVAL      Wk_TXBN = 'Port Interest'                    228553
     C                   EVAL      Wk_DAMT = 0                                  228553
     C                   EVAL      @SetExCode = 'Y'                             228553
     C                   ENDIF                                                  228553
      *                                                                         228553
     C                   ENDIF                                                  228553
      ** If this is position settlement for depot, then do not output
      ** Exemption Code, Recipient Code, Income type, Beneficial owner,
      ** and Tax ID number.
      *
     C                   IF        Wk_CTYP = 'D'
     C                   EVAL      Wk_RPCD = *BLANKS
     C                   EVAL      Wk_BNFO = *BLANKS
     C                   EVAL      Wk_CTIN = *BLANKS
     C                   EVAL      Wk_DEPT = *BLANKS
     C                   ENDIF
      *
      ** Check if a record for this customer and tax basket already in file.
      *
     C     PosetKey3     CHAIN     POSET55                            23                      HUT118

     C     In_Dept       IFNE      Wk_Dept                                                    242428
     C                   EVAL      *in23 = '1'                                                242428
     C                   ENDIF                                                                242428

     C                   ENDIF
      *
     C     COALRF        IFNE      *BLANKS                                      226732
     C     IN_PEVT       ANDEQ     'CS'                                         226732
     C     Wk_PAMD       ANDEQ     *ZEROS                                       226732
     C                   EVAL      Wk_PAMD = In_PAMD * Wk_PNMP / In_PNMP        226732
     C                   ENDIF                                                  226732
      *
      ** If record not on file, write a new record.
      *
     C     *IN23         IFEQ      '1'

     C                   EVAL      OutPoset = WrkPoset
     C     COALRF        IFNE      *BLANKS                                      215575
     C                   EVAL      Wk_PAMD = 0                                  215575
     C                   END                                                    215575
      ** Retrieve next available transaction number.                                          HUT118
     C                   CallB     'ZTNLU1'                                                   HUT118
     C                   Parm                    RetCodeOut                                   HUT118
     C                   Parm                    PNATN             5 0                        HUT118
     C                   Z-ADD     PNATN         Nw_TNLU                                      HUT118
      *                                                                                       HUT118
     C                   WRITE     POSETUP2
     C                   ADD       1             NWrtn

     C                   ELSE
      *
      ** If record found, and RECI is not equal to '*', then combine
      ** position holding, tax amount, settlement amount to file
      *
     C                   IF        Nw_RECI <> '*'

     C                   EVAL      Nw_PNMP = Nw_PNMP + Wk_PNMP
     C                   EVAL      Nw_PAMD = Nw_PAMD + Wk_PAMD
     C                   EVAL      Nw_PCHA = Nw_PCHA + Wk_PCHA
     C                   EVAL      Nw_PCAM = Nw_PCAM + Wk_PCAM
     C                   EVAL      Nw_PSAT = Nw_PSAT + Wk_PSAT
     C                   EVAL      Nw_TASO = Nw_TASO + Wk_TASO
     C                   EVAL      Nw_TAUS = Nw_TAUS + Wk_TAUS
     C                   EVAL      Nw_DAMT = Nw_DAMT + Wk_DAMT
      *                                                                         189342
      ** If no Error, then Calculate Withholding Tax.                           189342
      *                                                                         189342
     C                   IF        In_PEVT <>'MT'                               189342
     C                   EVAL      Nw_TASO = Nw_PAMD * @RtTaxRate / 100         189342
      *                                                                         197644
      ** Check if position is exempted from Tax. Portfolio Interest Exemption   197644
      ** is 'Y' so do not calculate any tax                                     197644
      *                                                                         197644
     C                   IF        SE_APIE = 'Y' and WHDCRC <> 'U'                            203541
      *                                                                         197644
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'       197644
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'    197644
     C                   EVAL      Nw_TASO = 0                                  197644
     C                   ENDIF                                                  197644
     C                   ENDIF                                                  197644
      *                                                                         197644
      ** Check if position is exempted from Tax.                                197644
      *                                                                         197644
      ** If security is SHARE (Adr's), ie processing type is 4                  197644
      ** and  income type is '08 , then it is exempt from Tax.                  197644
      *                                                                         197644
     C                   IF        PROT = '4'                                   197644
     C                   IF        SE_INCT = '08'                               197644
     C                   EVAL      Nw_TASO = 0                                  197644
     C                   ENDIF                                                  197644
     C                   ENDIF                                                  197644
      *                                                                         197644
      ** Check if position is exempted from Tax.                                228553
      *                                                                         228553
     C                   IF        WHDCRC = 'E' or WHDCRC = 'Y'                 228553
      *                                                                         228553
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'       228553
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'    228553
     C                   EVAL      Nw_TXBS = '06'                               228553
     C                   EVAL      Nw_TXBN = 'Port Interest'                    228553
     C                   EVAL      Nw_TASO = 0                                  228553
     C                   ENDIF                                                  228553
      *                                                                         228553
     C                   ENDIF                                                  228553
      *                                                                         228553
     C                   EVAL      Nw_PSAT = Nw_PAMD - Nw_TASO - Nw_PCHA        189342
     C                   EVAL      Nw_PSAT = Nw_PSAT - Nw_TAUS - Nw_PCAM        189342
     C                   ENDIF                                                  189342
                                                                                189342

     C                   ELSE

     C                   EVAL      OutPoset = WrkPoset
     C     COALRF        IFNE      *BLANKS                                      215575
     C                   EVAL      Wk_PAMD = 0                                  215575
     C                   END                                                    215575

     C                   ENDIF

      ** Retrieve next available transaction number.                                          HUT118
     C                   CallB     'ZTNLU1'                                                   HUT118
     C                   Parm                    RetCodeOut                                   HUT118
     C                   Parm                    PNATN             5 0                        HUT118
     C                   Z-ADD     PNATN         Nw_TNLU                                      HUT118
      *                                                                                       HUT118
     C                   UPDATE    POSETUP
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDepot - Process Depot Position Settlement Record            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRUDPos, SRCPoset                                      *
      *                                                               *
      *****************************************************************

     C     SRDepot       BEGSR
      *
      ** Get customer detail to check if they have a  SWIFT Address
      *
     C                   MOVE      In_PCPY       @Depot
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @Depot        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ** If Customer detail not found, issue DB error.
      *
     C     @RTCD         IFNE      *BLANKS
     C     BBCLST        ANDNE     'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  @KEY1 + @RTCD
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  108
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRDepot'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        BBCSID = *BLANKS AND BBSTAD = *BLANKS
     C                             AND BBTXA1 = *BLANKS
     C                   EVAL      Wk_MT5R = 'N'
     C                   ELSE
     C                   EVAL      Wk_MT5R = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** Get Total User Position for the Depot.
      ** Generate Position Settlement for user position if it is not equal
      ** to zero.
      *
     C                   EXSR      SRUDPos
      *
      ** Generate Position Settlement for Customer Depot Position.
      *
     C                   IF        In_PNMP <> Wk_PNMP
     C                   EXSR      SRCPoset
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUDPos  - Get User Depot Position and update Position        *
      *            Settlement File.                                   *
      *                                                               *
      * Called by: SRDepot                                            *
      *                                                               *
      * Calls:  SRWrtOrUpd                                            *
      *                                                               *
      *****************************************************************
     C     SRUDPos       BEGSR
      *                                                                         186001
      ** Get Internal Customer Information                                      186001
      *                                                                         186001
     C                   EXSR      SRICInfo                                     186001
                                                                                186001
      ** Initialise work fields                                                 186001
      *                                                                         186001
     C                   MOVE      *LOVAL        @Book
     C                   MOVE      *LOVAL        @Mket
     C                   EVAL      @U_EXnml = 0                                 186001
     C                   EVAL      @U_TDnml = 0                                 186001
     C                   EVAL      @U_VDnml = 0                                 186001
     C                   EVAL      @U_Cost = 0                                  186001
                                                                                186001
     C     UdeppFKey     SETLL     UDEPP                              26
     C     *IN26         DOUEQ     '1'
     C     UdeppSKey     READE     UDEPP                                  26
     C                   IF        *IN26 = '0'
     C                   EVAL      *IN27 = '0'
      *
      ** If Position date is greater than the coupon/dividend date then
      ** get position record before that date.
      *
     C                   IF        LU_UDDT > @PositDate
     C                   EVAL      @PDate = @PositDate
     C                   EVAL      @Book = LU_UDBK
     C                   EVAL      @Mket = LU_UDMK
     C     UdepHFKey     SETGT     UDEPH
     C     UdeppFKey     READPE    UDEPH                                  27

     C                   ENDIF

     C                   EVAL      @NoTax = 'Y'                                               235049
     C                   IF        *IN27 = '0'
      *
      ** For Coupon Event, if position date is less than the last coupon
      ** date, then the ex-coupon nominal should be zero.
      *
     C                   IF        In_PEVT = 'CP' and LU_UDDT < @LCouponD
     C                   EVAL      LU_UECN = 0
     C                   ENDIF
      *                                                                         186001
      ** If it is for Maturity Event, then get the book cost                    186001
      *                                                                         186001
     C                   IF        In_PEVT = 'MT'                               186001
     C                   EXSR      SRGetBkCost                                  186001
     C                   EVAL      @U_Cost = @U_Cost + ZCONS                    186001
     C                   ENDIF                                                  186001

     C                   EVAL      @U_EXnml = @U_Exnml + LU_UECN
     C                   EVAL      @U_TDnml = @U_TDnml + LU_UDNT
     C                   EVAL      @U_VDnml = @U_VDnml + LU_UDNV
     C                   ENDIF
     C     COALRF        IFNE      *BLANKS                                      215575
     C     CorpabKey     CHAIN     SECOALL4                           21        215575
     C     *IN21         IFEQ      '0'                                          215575
      *                                                                         215575
      ***  Total Cash = Actual Cash Allocation + Cash Rounding                  215575
      *                                                                         215575
     C                   Z-ADD     MCACAA        WWPAMD           17 0          215575
     C                   ADD       MCACAR        WWPAMD                         215575
     C                   ADD       WWPAMD        Wk_PAMD                        215575
     C                   SUB       WWPAMD        IN_PAMD                        215575
                                                                                215575
     C                   END                                                    215575
     C                   END                                                    215575
     C                   ENDIF
     C                   ENDDO

     C                   IF        In_PEVT = 'CP'
     C                   EVAL      @U_VDnml = @U_VDnml - LU_UECN
     C                   ENDIF
      *
      ** For Dividend Event, Set up to use trade date position if specified.
      *
     C                   IF        InTVPosit = 'T'
     C                   EVAL      Wk_PNMP = @U_TDnml
     C                   ELSE
     C                   EVAL      Wk_PNMP = @U_VDnml
     C                   ENDIF
      *                                                                         186001
      ** Calculate Amount Due                                                   186001
      *                                                                         186001
     C     COALRF        IFEQ      *BLANKS                                      215575
     C                   EVAL      Wk_PAMD = In_PAMD * Wk_PNMP / In_PNMP        186001
     C                   END                                                    215575
      *                                                                         186001
      ** Calculate discount amount for Maturity.                                186001
      *                                                                         186001
     C                   EVAL      @Discount = 0                                186001
     C***********        IF        In_PEVT = 'MT'                        186001 186303
     C                   IF        In_PEVT = 'MT' AND @NoTax = 'N'              186303
     C                   EVAL      @Discount = Wk_PAMD - @U_Cost                186001
     C                   ENDIF                                                  186001
      *                                                                         186001
      ** Calculate Withholding Tax                                              186001
      *                                                                         186001
     C                   EVAL      Wk_TASO = 0                                  186001
     C                   EVAL      Wk_TAUS = 0                                  186001
     C                   EVAL      Wk_TASR = 0                                  186001
     C                   IF        @NoTax <> 'Y'                                186001
     C                   EXSR      SRCalTax                                     186001
     C                   ENDIF                                                  186001
      *
      ** Exemption Code for user position always = *BLANK
      *
     C                   EVAL      Wk_EXCD = '  '
     C                   EVAL      @SetExCode = 'Y'

     C                   EVAL      Wk_RPCD = *BLANKS                            185748
     C                   EXSR      SRWrtOrUpd

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    186001
      *****************************************************************         186001
      *                                                               *         186001
      * SRICInfo - Get Internal Customer Information                  *         186001
      *                                                               *         186001
      * Called by: SRUDPos                                            *         186001
      *                                                               *         186001
      * Calls:                                                        *         186001
      *                                                               *         186001
      *****************************************************************         186001
     C     SRICInfo      BEGSR                                                  186001
      *                                                                         186001
      ** Get Internal Customer                                                  186001
      *                                                                         186001
     C                   CALLB     'AOBRCHR0'                                   186001
     C                   PARM      *BLANKS       @RTCD             7            186001
     C                   PARM      '*KEY   '     @OPTN             7            186001
     C                   PARM      In_PBCA       @DDPBA            3            186001
     C     SDBRCH        PARM      SDBRCH        DSFDY                          186001
      *                                                                         186001
      **  Invalid Branch                                                        186001
      *                                                                         186001
     C     @RTCD         IFNE      *BLANKS                                      186001
     C     *LOCK         IN        LDA                                          186001
     C                   EVAL      DBFILE =  'SDBRCHPD'                         186001
     C                   EVAL      DBKEY  =  In_PBCA                            186001
     C                   EVAL      DBPGM  =  PSProcPgm                          186001
     C                   EVAL      DBASE  =  102                                186001
     C                   EVAL      DBMOD  =  PSProcMod                          186001
     C                   EVAL      DBPROC =  'SRUDPos'                          186001
     C                   OUT       LDA                                          186001
     C                   EXSR      *PSSR                                        186001
     C                   END                                                    186001
      *                                                                         186001
      ** Get Tax Basket for Withholding Tax                                     186001
      *                                                                         186001
     C                   MOVE      A8BICN        @Cust                          186001
     C                   MOVE      'U'           @CallFrom                      186001
     C                   EXSR      SRCustInfo                                   186001
      *                                                                         186001
      ** Get Tax rate for Customer with no documentation.                       186001
      *                                                                         186001
     C                   IF        @NoDoc = 'Y'                                 186001
                                                                                186001
     C                   EVAL      @TaxBasket = WTDBDC                          186001
      *                                                                         186001
      ** If position settlement is for Maturity and OID indicator is 'S'        186001
      ** then use Backup withholding tax rate.                                  186001
      *                                                                         186001
     C                   EVAL      Wk_EXCD = ' '                                186001
     C                   EVAL      @SetExCode = 'Y'                             186001
     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             186001
     C                   EVAL      @TaxBasket = WTDRBW                          186001
     C                   ENDIF                                                  186001
                                                                                186001
     C                   ELSE                                                   186001
      *                                                                         186001
      ** Get Tax rate for Customer with completed documentation                 186001
      ** If Tax basket on Customer detail = *BLANK then use tax basket from     186001
      ** treaty detail.                                                         186001
      *                                                                         186001
     C                   IF        @NoTax <> 'Y'                                186303
                                                                                186303
     C                   IF        WHTXBS <> *BLANKS                            186001
     C                   EVAL      @TaxBasket = WHTXBS                          186001
     C                   ELSE                                                   186001
     C                   EVAL      @TaxBasket = WTTXBS                          186001
     C                   ENDIF                                                  186001
                                                                                186303
     C                   ELSE                                                   186303
     C                   EVAL      @TaxBasket = *BLANKS                         186303
     C                   ENDIF                                                  186303
                                                                                186303
     C                   ENDIF                                                  186001
                                                                                186001
     C                   ENDSR                                                  186001
      *****************************************************************         186001
      /EJECT                                                                    186001
      *****************************************************************         186001
      *                                                               *         186001
      * SRGetBkCost - Get book value for matured Security             *         186001
      *                                                               *         186001
      * Called by: SRUDPos                                            *         186001
      *                                                               *         186001
      * Calls:                                                        *         186001
      *                                                               *         186001
      *****************************************************************         186001
     C     SRGetBkCost   BEGSR                                                  186001
      *                                                                         186001
      ** Get the latest price from Book Position Header (value date)            186001
      *                                                                         186001
     C                   EVAL      @TVInd = 'V'                                 186001
     C     BKPHDKey      CHAIN     BKPHD                              43        186001
      *                                                                         186001
      ** If no record found then issued DB error.                               186001
      *                                                                         186001
     C     *IN43         IFEQ      '1'                                          186001
     C     *LOCK         IN        LDA                                          186001
     C                   EVAL      DBFILE =  'BKPHDD'                           186001
     C                   EVAL      DBKEY  =  LU_UDSN + LU_UDBK                  186001
     C                   EVAL      DBPGM  =  PSProcPgm                          186001
     C                   EVAL      DBASE  =  112                                186001
     C                   EVAL      DBMOD  =  PSProcMod                          186001
     C                   EVAL      DBPROC =  'SRGetBkCost'                      186001
     C                   OUT       LDA                                          186001
     C                   EXSR      *PSSR                                        186001
     C                   ENDIF                                                  186001
      *                                                                         186001
      ** GET NOMINAL CURRENCY DECIMAL PLACES                                    186001
      *                                                                         186001
     C                   CALLB     'AOCURRR0'                                   186001
     C                   PARM      '*MSG   '     @RTCD             7            186001
     C                   PARM      '*KEY   '     @OPTN             7            186001
     C                   PARM      SE_NMCY       @AJCD             3            186001
     C     SDCURR        PARM      SDCURR        DSSDY                          186001
      *                                                                         186001
      ** DATABASE ERROR                                                         186001
      *                                                                         186001
     C     @RTCD         IFNE      *BLANK                                       186001
     C     *LOCK         IN        LDA                                          186001
     C                   EVAL      DBFILE =  'SDCURRPD'                         186001
     C                   EVAL      DBKEY  =  @AJCD                              186001
     C                   EVAL      DBPGM  =  PSProcPgm                          186001
     C                   EVAL      DBASE  =  113                                186001
     C                   EVAL      DBMOD  =  PSProcMod                          186001
     C                   EVAL      DBPROC =  'SRGetBkCost'                      186001
     C                   OUT       LDA                                          186001
     C                   EXSR      *PSSR                                        186001
     C                   ENDIF                                                  186001
                                                                                186001
     C                   MOVE      A6NBDP        NomCcyDec         1 0          186001
     C                   Z-ADD     BH_LAVP       ZPRC                           186001
     C                   Z-ADD     LU_UDNV       ZNOML                          186001
     C                   CALLB     'ZCNSD'                                      186001
     C                   PARM                    ZNOML            15 0          186001
     C                   PARM                    ZPRC             16 9          186001
     C                   PARM      SE_SPBS       SPBS              1            186001
     C                   PARM      SE_NMDP       NMDP              1 0          186001
     C                   PARM      NomCcyDec     ZCDP              1 0          186001
     C                   PARM                    ZCONS            15 0          186001
                                                                                186001
     C                   ENDSR                                                  186001
      *****************************************************************         186001
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCPoset - Get Customer Depot Position                        *
      *                                                               *
      * Called by: SRDepot                                            *
      *                                                               *
      * Calls:  SRCust                                                *
      *                                                               *
      *****************************************************************
     C     SRCPoset      BEGSR
      *
      ** Get Customer Depot Position that makes up the depot position
      *
     C                   MOVE      *LOVAL        @CustNo
     C                   EVAL      @DepotNo = In_PCPY
     C     CdeppFKey     SETLL     SECDEPL6                           28
     C     *IN28         DOWEQ     '0'
     C     CdeppSKey     READE     SECDEPL6                               28
      *
      ** If Position date is greater than the coupon/dividend date then
      ** get position record before that date.
      *
     C                   IF        *IN28 = '0'
     C                   EVAL      *IN29 = '0'
      *
      ** If Position date is greater than the coupon/dividend date then
      ** get position record before that date.
      *
     C                   IF        LC_DDTE > @PositDate
     C                   EVAL      @PDate = @PositDate
      ** The @PositDate is position date -1 (Ex -1 for Div)                     242126
     C****************   ADD       1             @PDate                 195635  242126
     C                   EVAL      @CustNo = LC_CDCN
     C*****CdepHFKey     SETGT     CDEPH                                        195635
     C*****CdepHSKey     READPE    CDEPH                                  29    195635
     C     CdepHFKey     SETLL     CDEPO                                        195635
     C     CdepHSKey     READE     CDEPO                                  29    195635

     C                   ENDIF

     C     *IN29         IFEQ      '0'
     C                   MOVE      LC_CDCN       @Cust
     C                   MOVE      @Cust         @HoldingCust
      *
      ** For Coupon Event, if position date is less than the last coupon
      ** date, then the ex-coupon nominal should be zero.
      *
     C                   IF        In_PEVT = 'CP' and LC_DDTE < @LCouponD
     C                   EVAL      LC_CECN = 0
     C                   ENDIF
      *
      ** For Dividend Event, Set up to use trade date position if specified.
      *
     C                   IF        In_PEVT <> 'CP' and InTVPosit = 'T'
     C                             and In_PEVT <> 'MT'
     C                   EVAL      Wk_PNMP = LC_CDNT
     C                   ELSE
     C                   EVAL      Wk_PNMP = LC_CDNV - LC_CECN
     C                   ENDIF

     C                                                                          215575
     C                   IF        IN_PEVT <> 'CP' and IN_PEVT <> 'MT' and      215575
     C                             IN_PEVT <> 'DV' and IN_PEVT <> 'MR'          215575
     C                                                                          215575
      ** Full Key Lists for Corporate allocation - SECOALL4                     215575
      *  Client                                                                 215575
     C     CorpacKey     KLIST                                                  215575
     C                   KFLD                    COALRF                         215575
     C                   KFLD                    In_PBCA                        215575
     C                   KFLD                    In_PCPY                        215575
     C                   KFLD                    CASH                           215575
     C                   KFLD                    MCLIN                          215575
     C                   KFLD                    In_PBCD                        215575
     C                   KFLD                    LC_CDCN                        215575
     C                   KFLD                    LC_PTFR                        215575

     C     CorpacKey     CHAIN     SECOALL4                           21        215575
     C     *IN21         IFEQ      '0'                                          215575
      *                                                                         215575
      ***  Total Cash = Actual Cash Allocation + Cash Rounding                  215575
      *                                                                         215575
     C                   Z-ADD     MCACAA        WWPAMD           17 0          215575
     C                   ADD       MCACAR        WWPAMD                         215575
     C                   Z-ADD     WWPAMD        Wk_PAMD                        215575
     C                   SUB       WWPAMD        IN_PAMD                        215575
                                                                                215575
     C                   END                                                    215575
     C                                                                          215575
     C                   END                                                    215575
     C                                                                          215575
     C                   EXSR      SRCust
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetlAmt - Calculate Settlement Amount                       *
      *                                                               *
      * Called by: SRWrtOrUpd                                         *
      *                                                               *
      * Calls:  SEZ010                                                *
      *                                                               *
      *****************************************************************
     C     SRSetlAmt     BEGSR
      *
      ** Set up parameter for call to SEZ010
      *
     C                   IF        In_CTYP = 'D'
     C                   MOVE      'X'           P@CLAS
     C                   ELSE
     C                   MOVE      'D'           P@CLAS
     C                   END

     C                   MOVEL     Wk_PPRE       P@PPRE
     C                   Z-ADD     Wk_PAMD       P@PAMD
     C                   Z-ADD     Wk_PCHA       P@PCHA
     C                   Z-ADD     Wk_PCAM       P@PCAM
     C                   Z-ADD     Wk_TASO       P@TASO
     C                   Z-ADD     Wk_TAUS       P@TAUS
     C                   Z-ADD     Wk_PSXR       P@PSXR
     C                   MOVEL     Wk_PMDI       P@PMDI
     C                   MOVEL     Wk_PNCY       P@PNCY
     C                   MOVEL     Wk_PSCU       P@PSCU

     C                   IF        In_CTYP = 'D'
     C                   MOVE      'TS'          P@TDTP
     C                   ELSE
     C                   MOVE      'TP'          P@TDTP
     C                   ENDIF

     C                   Z-ADD     0             P@FXMR
     C                   Z-ADD     0             P@MAMT
     C*
     C** Call SEZ010 to calculate the settlement amount in settle ccy
     C*
     C                   CALL      'SEZ010'
     C                   PARM      *BLANKS       P@RCDE            7
     C                   PARM                    P@DATA
     C     P@RCDE        IFEQ      *BLANKS
     C                   Z-ADD     P@PSAT        Wk_PSAT
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SEZ010'
     C                   EVAL      DBKEY  =  P@RCDE
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  109
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRSetlAmt'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNDIFF - Output position different                           *
      *                                                               *
      * Called by: SRInter                                            *
      *                                                               *
      * Calls: SRCalTax, SRWrtOrUpd                                   *
      *                                                               *
      *****************************************************************
     C     SRNDIFF       BEGSR
      *
      ** If nothing set up for Beneficial Owner the find depot for
      ** position
      *
     C                   IF        In_CTYP = 'C' and Wk_DEPT = *BLANKS
      *
      ** If Position Settlement is for Customer Position then
      ** find out what depot the holding is at.
      *
     C*******            EVAL      LC_CDPT = 0                                  HUT118
     C                   EVAL      LC_CDPT = *BLANKS                            HUT118
                                                                                              203270
     C                   IF        In_PEVT = 'DV'                                             203270
      *                                                                                       203270
      ** If S01510 is on, @EvDate should be '@PositDate - 1' since                            203270
      ** SE2400 adds 1 to the ex-date before passing it to SE2310                             203270
      *                                                                                       203270
     C                   IF        S01510 = 'Y'                                               203270
     C                   EVAL      @EvDate = @PositDate - 1                                   203270
     C                   ELSE                                                                 203270
     C                   EVAL      @EvDate = @PositDate                                       203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ELSE                                                                 203270
     C*******************EVAL      @EvDate = @LCouponD                                 203270 221659
     C                   EVAL      @EvDate = IN_PDUD                                          221659
     C                   ENDIF                                                                203270
                                                                                              203270
     C**   CdepsPKey     SETGT     CDEPSL1                                             203270 242428
     C     Cdeps2PKey    SETGT     CDEPSL2                                                    242428
     C                   MOVE      '0'           *IN35                                        203270
     C                   MOVE      '0'           *IN36                                        203270
     C*******            Z-ADD     0             Wk_DEPT2          6 0                 203270 HUT118
     C                   MOVEL     *BLANKS       Wk_DEPT2          6                          HUT118
                                                                                              203270
     C     *IN35         DOWEQ     '0'                                                        203270
     C**** CdepsPKey     CHAIN     CDEPS                              30                      201820
     C*****CdepsPKey     CHAIN     CDEPX1                                              201820 203270
     C**   CdepsPKey2    READPE    CDEPSL1                                             203270 242428
     C     Cdeps2PKey2   READPE    CDEPSL2                                                    242428
     C     *IN30         IFEQ      '0'                                                        203270
      *                                                                                       203270
      ** If the event type is a Dividend Payment, check if Trade or                           203270
      ** Value date basis. Then make sure the corresponding nominal                           203270
      ** is not zero. If not a Dividend Payment, Value Date Nominal                           203270
      ** should not be zero.                                                                  203270
      *                                                                                       203270
     C                   IF        In_PEVT <> 'DV'                                            203270
     C                             and LC_CDNV <> 0                                           203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and LC_CDNT <> 0                                           203270
     C                             and InTVPosit = 'T'                                        203270
     C                             or In_PEVT = 'DV'                                          203270
     C                             and InTVPosit = 'V'                                        203270
     C                             and LC_CDNV <> 0                                           203270
      *                                                                                       203270
      ** If the previous position read has a nominal of zero, its                             203270
      ** depot should not be used                                                             203270
      *                                                                                       203270
     C     *IN36         IFEQ      '0'                                                        203270
     C     *IN36         OREQ      '1'                                                        203270
     C     Wk_DEPT2      ANDNE     LC_CDPT                                                    203270
                                                                                              203270
     C******             IF        LC_CDPT <> 0                                 HUT118
     C                   IF        LC_CDPT <> *BLANKS                           HUT118
     C                   MOVE      LC_CDPT       Wk_DEPT
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If the nominal is zero                                                               203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      '1'           *IN36                                        203270
     C                   MOVE      LC_CDPT       Wk_DEPT2                                     203270
     C                   ENDIF                                                                203270
      *                                                                                       203270
      ** If not record was found using READPE                                                 203270
      *                                                                                       203270
     C                   ELSE                                                                 203270
     C                   MOVE      *BLANKS       Wk_DEPT                                      203270
     C                   MOVE      '1'           *IN35                                        203270
     C                   ENDIF                                                                203270
                                                                                              203270
     C                   ENDDO                                                                203270
                                                                                              203270
     C*******            IF        LC_CDPT = 0                                  HUT118
     C                   IF        LC_CDPT = *BLANKS                            HUT118
     C                   MOVE      *BLANKS       Wk_DEPT
     C                   ENDIF
     C                   ENDIF
      *
      ** Get Tax rate for Customer with no documentation.
      *
     C                   EVAL      @TaxBasket = @CustNDTXBS
     C                   EVAL      Wk_EXCD = '  '

     C                   EVAL      Wk_PNMP = @NomlDiff
     C                   EVAL      Wk_PAMD = @AmtDiff
     C                   EVAL      Wk_PCHA = @ChgDiff
     C                   EVAL      Wk_PCAM = @CommDiff
                                                                                185292
     C************       IF        In_PEVT = 'MT'  and SE_OIDI = 'Y'            185292
     C                   IF        In_PEVT = 'MT'                               185292
     C                   IF        SE_OIDI = 'Y' OR SE_OIDI = 'S'               185292
     C                   EVAL      @Cost = Wk_PNMP * CP_CSPT / CP_CSNT
     C                   EVAL      @Discount = Wk_PAMD - @Cost
     C                   ENDIF
     C                   ENDIF                                                  185292
      *
      ** Get Tax Rate and calculate withholding Tax
      *
     C                   EXSR      SRCalTax
      *
      ** Set up fields for position settlement
      *
     C                   EVAL      Wk_BNFO = *BLANKS
     C                   EVAL      Wk_CTIN = *BLANKS

     C                   EVAL      Wk_RPCD = WHRPCD                             185748
     C                   EXSR      SRWrtOrUpd

     C                   EVAL      @NomlDiff = 0
     C                   EVAL      @AmtDiff = 0
     C                   EVAL      @ChgDiff = 0
     C                   EVAL      @CommDiff = 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     *InzSR        BEGSR
      *
      ** Key Lists for Withholding Tax Customer detail
      *
     C     Wt_CustKey    KLIST
     C                   KFLD                    @Cust
     C                   KFLD                    SE_CRTT
      *
      ** Key Lists for Withholding Tax Treaty detail
      *
     C     Wt_TreatKy    KLIST
     C                   KFLD                    SE_CRTT
     C                   KFLD                    @SITP
     C                   KFLD                    @Loc
      *
      ** Partial Key Lists for Withholding Tax Treaty detail
      *
     C     Wt_TreatPky   KLIST
     C                   KFLD                    SE_CRTT
     C                   KFLD                    @SITP
      *
      ** Key Lists for Intermediary Client Detail - for Depot Position
      **                                            settlement
      *
     C     InterMlKey    KLIST
     C                   KFLD                    @HoldingCust
     C                   KFLD                    @Secty
     C                   KFLD                    @HoldingDept
     C*******            KFLD                    LC_PTFR                               233084 HUT118
      *
      ** Key Lists for Intermediary Client Detail - for Customer Position
      **                                            settlement
      *
     C     InterMCKey    KLIST
     C                   KFLD                    @HoldingCust
     C                   KFLD                    @Secty
     C*******            KFLD                    @Dept                                 233084 HUT118
     C*******            KFLD                    @Portfolio                            233084 HUT118
      *
      ** Key Lists for Investment Type
      *
     C     InvestKey     KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
      *
      ***Short*Key*Lists*for*Customer*Depot*(Live*record)*-*CDEPS******                       203270
      ** Short Key Lists to position pointer: Customer Depot - CDEPSL1             203270     242428
      *                                                                                       242428
     C*    CdepsPKey     KLIST                                                                242428
     C*                  KFLD                    In_PBCA                           203270     242428
     C*                  KFLD                    In_PSSH                                      242428
     C*                  KFLD                    In_PCPY                                      242428
     C*                  KFLD                    In_PTFR                           203270     242428
     C*                  KFLD                    In_PMAR                           203270     242428
     C*                  KFLD                    @EvDate                           203270     242428
      *                                                                            203270     242428
      ** Short Key Lists for Customer Depot - CDEPSL1                              203270     242428
      *                                                                            203270     242428
     C*    CdepsPKey2    KLIST                                                     203270     242428
     C*                  KFLD                    In_PBCA                           203270     242428
     C*                  KFLD                    In_PSSH                           203270     242428
     C*                  KFLD                    In_PCPY                           203270     242428
     C*                  KFLD                    In_PTFR                           203270     242428
     C*                  KFLD                    In_PMAR                           203270     242428
      *
      ** Short Key Lists to position pointer: Customer Depot - CDEPSL2                        242428
      *                                                                                       242428
     C     Cdeps2PKey    KLIST                                                                242428
     C                   KFLD                    In_PBCA                                      242428
     C                   KFLD                    In_PSSH                                      242428
     C                   KFLD                    In_PCPY                                      242428
     C                   KFLD                    @Indepot                                     242428
     C                   KFLD                    In_PTFR                                      242428
     C                   KFLD                    In_PMAR                                      242428
     C                   KFLD                    @EvDate                                      242428
      *                                                                                       242428
      ** Short Key Lists for Customer Depot - CDEPSL2                                         242428
      *                                                                                       242428
     C     Cdeps2PKey2   KLIST                                                                242428
     C                   KFLD                    In_PBCA                                      242428
     C                   KFLD                    In_PSSH                                      242428
     C                   KFLD                    In_PCPY                                      242428
     C                   KFLD                    @Indepot                                     242428
     C                   KFLD                    In_PTFR                                      242428
     C                   KFLD                    In_PMAR                                      242428
      *
      ** Short Key Lists for User Depot File - UDEPP
      *
     C     UdeppSKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    In_PSSH
     C                   KFLD                    In_PCPY
      *
      ** Full Key Lists for User Depot File - UDEPP
      *
     C     UdeppFKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    In_PSSH
     C                   KFLD                    In_PCPY
     C                   KFLD                    @Book
     C                   KFLD                    @Mket
      *
      ** Full Key Lists for User Depot File - UDEPH
      *
     C     UdepHFKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    In_PSSH
     C                   KFLD                    In_PCPY
     C                   KFLD                    @Book
     C                   KFLD                    @Mket
     C                   KFLD                    @PDate
      *
      ** Short Key Lists for Customer Depot - SECDEPL6
      *
     C     CdeppSKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    In_PSSH
     C                   KFLD                    In_PMAR
     C                   KFLD                    @DepotNo
      *
      ** Full Key Lists for Customer Depot - SECDEPL6
      *
     C     CdeppFKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    In_PSSH
     C                   KFLD                    In_PMAR
     C                   KFLD                    @DepotNo
     C                   KFLD                    @CustNo
      *
      ** Short Key Lists for Customer Depot - CDEPH
      *
     C     CdepHSKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    @CustNo
     C                   KFLD                    Lc_PTFR                        195635
     C                   KFLD                    In_PSSH
     C                   KFLD                    @DepotNo
     C                   KFLD                    In_PMAR
      *
      ** Full Key Lists for Customer Depot - SECDEPL6
      *
     C     CdepHFKey     KLIST
     C                   KFLD                    In_PBCA
     C                   KFLD                    @CustNo
     C                   KFLD                    Lc_PTFR                        195635
     C                   KFLD                    In_PSSH
     C                   KFLD                    @DepotNo
     C                   KFLD                    In_PMAR
     C                   KFLD                    @PDate
      *
      ** Key Lists for Beneficial Owner Detail - SDBNFOL1
      *
     C     SDBNFOKey     KLIST
     C                   KFLD                    @INCNUM
     C                   KFLD                    SE_CRTT
     C**************     KFLD                    @HoldingDept                   185936
     C                   KFLD                    @BenDept                       185936
     C********           KFLD                    @INPTFR                               233084 HUT118
     C                   KFLD                    @INBONO
      *
      ** Part Key Lists for Beneficial Owner Detail - SDBNFOL1
      *
     C     SDBNFOPKey    KLIST
     C                   KFLD                    @INCNUM
     C                   KFLD                    SE_CRTT
      *
      ** Key Lists for Position Settlement File
      *
     C*****PosetKey      KLIST                                                                HUT118
     C     PosetKey3     KLIST                                                                HUT118
     C                   KFLD                    Wk_PBCA
     C                   KFLD                    Wk_PSSH
     C                   KFLD                    Wk_PCPY
     C                   KFLD                    Wk_PDUD
     C                   KFLD                    Wk_PEVT
     C                   KFLD                    Wk_PTFR
     C******             KFLD                    Wk_TNLU                                      HUT118
     C                   KFLD                    Wk_TXBS
     C                   KFLD                    Wk_EXCD
     C                   KFLD                    Wk_BNFO
      *
      *
      ** Key Lists for Customer Position File -CPOSN
      *
     C     CposnKey      KLIST
     C                   KFLD                    Wk_PBCA
     C                   KFLD                    Wk_PSSH
     C                   KFLD                    @CustNo
      *                                                                         186001
      ** Key Lists for Book Position Header File - BKPHD                        186001
      *                                                                         186001
     C     BKPHDKey      KLIST                                                  186001
     C                   KFLD                    LU_UDSN                        186001
     C                   KFLD                    LU_UDBA                        186001
     C                   KFLD                    LU_UDBK                        186001
     C                   KFLD                    LU_UDMK                        186001
     C                   KFLD                    @TVInd                         186001
      *
      ** Full Key Lists for Corporate allocation - SECOALL4                     215575
      *  Book                                                                   215575
     C     CorpabKey     KLIST                                                  215575
     C                   KFLD                    COALRF                         215575
     C                   KFLD                    In_PBCA                        215575
     C                   KFLD                    In_PCPY                        215575
     C                   KFLD                    CASH                           215575
     C                   KFLD                    MBOOK                          215575
     C                   KFLD                    LU_UDBK                        215575
     C                   KFLD                    CUSTOM                         215575
     C                   KFLD                    PORTFO                         215575

      *
      ** Program Input Paramenters
      *
     C     *Entry        PLIST
      *
      ** INPUT fields
      *
      ** Original Position Settlement record to be written
      *
     C                   PARM                    InPoset
      *
      ** Trade/Value Date position for Dividend
      *
     C                   PARM                    InTVPosit
      *
      ** Dividend Date / Last Coupon Date
      *
     C                   PARM                    InDivDate
      *
      ** OUTPUT fields
      *
     C                   PARM                    NWrtn                          No of record written
     C                   PARM                    PgmErr                         Program Error
      *                                                                         215575
     C                   MOVE      In_PSPI       COALRF            6            215575
     C                   MOVE      '**CASH**  '  CASH             10            215575
     C                   MOVE      'B'           MBOOK             1            215575
     C                   MOVE      'C'           MCLIN             1            215575
     C                   EVAL      In_PSPI = *BLANKS                            215575
     C*******            Z-ADD     *ZERO         CUSTOM            6 0          215575 HUT118
     C                   MOVEL     *BLANKS       CUSTOM            6            HUT118
     C                   MOVE      *BLANKS       PORTFO            4            215575
      *                                                                         215575
      *
      ** Initialize Output fields
      *
     C                   EVAL      NWrtn = 0
     C                   EVAL      PgmErr= 'N'
      *
     C                   EVAL      NW_PBRX = 0
     C                   EVAL      WK_PBRX = 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'SE2310'      DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  101
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*InzSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C******                                                                           233084 HUT118
     C***Keep Depot from SE2400 for Intermediary Client processing                     233084 HUT118
     C******                                                                           233084 HUT118
     C******             EVAL      @Dept = In_Dept                                     233084 HUT118
     C******             EVAL      @Indepot=0                                          242428 HUT118
     C******             Move      @Dept         @Indepot                              242428 HUT118
      *
      ** Initialise Treaty Tax fields
      *
     C                   EVAL      @RoundingRec = 'N'
     C                   EVAL      Upd_Rounding = 'N'                           185604

     C                   EVAL      In_PSEQ =  001
     C                   EVAL      In_CTIN = *BLANKS
     C                   EVAL      In_PREF = '000000'
     C                   EVAL      In_MT5G = 'N'
     C                   EVAL      In_MT5R = 'N'
     C                   EVAL      In_BNFO = *BLANKS
     C                   EVAL      In_ICTP = *BLANKS
     C                   EVAL      In_CRTX = *BLANKS
     C                   EVAL      In_TXBS = *BLANKS
     C                   EVAL      In_TXBN = *BLANKS
     C                   EVAL      In_EXCD = *BLANKS
     C                   EVAL      In_DEPT = *BLANKS
      *                                                                         239774
     C                   If        In_TXCY = *Blanks                            239774
     C                   EVAL      In_TXNM = 0                                  239774
     C                   EVAL      In_TXST = 0                                  239774
     C                   EVAL      In_TAXA = 0                                  239774
      * with CGL053 add next line                                               CGL053
     C*******            EVAL      In_TISD = 0                           239774 HUT118
     C                   ENDIF                                                  239774
      *
      ** If it is Dividend Event, then use Dividend date as Event Date.
      *
     C                   If        In_PEVT <> 'CP' and In_PEVT <> 'MT'
     C                   EVAL      @PositDate = InDivDate
     C                   ELSE
     C                   EVAL      @PositDate = In_PSVL
     C                   ENDIF

     C                   IF        In_PEVT = 'CP'
     C                   EVAL      @LCouponD = InDivDate
     C                   ENDIF

     C                   MOVE      InPoset       WrkPoset
     C     COALRF        IFNE      *BLANKS                                      215575
     C                   EVAL      Wk_PAMD = 0                                  215575
     C                   END                                                    215575

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   MOVE      'Y'           PgmErr
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2022
