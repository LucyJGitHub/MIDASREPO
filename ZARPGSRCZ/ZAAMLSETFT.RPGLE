     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA AML settlement extract for FT module')
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAAMLSETFT - Settlement Extract for Funds Transfer Module    *
      *                                                               *
      *  Function:  This module extracts the Funds Transfer           *
      *             Settlement Fields to be used in the AML Account   *
      *             History exports.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL020   *CREATE   Date 12Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DTLN            S             35A   DIM(6)
      ** Detail Lines Array
 
     D DTCDE           S             10A   DIM(4)
      ** Detail Codes Array
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details Data Structure
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Counterparty Nostro Data Structure
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** Location Codes Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D POrdCustA       S             35A
     D POrdCustB       S             35A
     D POrdCustC       S             35A
     D POrdCustD       S             35A
     D POrdCustE       S             35A
     D POrdBnkA        S             35A
     D POrdBnkB        S             35A
     D POrdBnkC        S             35A
     D POrdBnkD        S             35A
     D POrdBnkE        S             35A
     D POrdBnkCde      S             11A
     D PBenA           S             35A
     D PBenB           S             35A
     D PBenC           S             35A
     D PBenD           S             35A
     D PBenE           S             35A
     D PBenF           S             35A
     D PAWBnkA         S             35A
     D PAWBnkB         S             35A
     D PAWBnkC         S             35A
     D PAWBnkD         S             35A
     D PAWBnkE         S             35A
     D PAWBCde         S             35A
     D POrgCcy         S              3A
     D PDstCcy         S              3A
     D PROrgAcc        S             20A
     D PROrgCty        S              2A
     D PROrgBnk        S             20A
     D PROrgCde        S             11A
     D PPOrgAcc        S             20A
     D PPOrgCty        S              2A
     D PPOrgBnk        S             20A
     D PPOrgCde        S             11A
     D PDstAcc         S             35A
     D PDstCty         S              2A
     D PDstBnk         S             20A
 
      ** Access Object Parameters
     D PCust           S             10A
     D PErr            S              7A
     D PCNst           S              8A
     D PLCde           S              3A
 
      ** SPDrvDta Mode Parameter
     D PMode           S              7A
 
      ** Detail Currency Container
     D DTCCY           S              3A
 
      ** Working Variables
     D WOrgCust        S             12A
     D WCtrPrty        S              8A
     D WDstCust        S             12A
     D WRetCde         S              7A
     D WData           S            216A
     D WCtr            S              2P 0
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      ** WLC/AML Data Formatting/Conversion Program
     D SDCWLFMT        PR                  EXTPGM('SDCWLFMT')
     D  PRetCde                       7A
     D  PInpA                        35A   CONST OPTIONS(*VARSIZE)
     D  PInpB                        35A   CONST OPTIONS(*VARSIZE)
     D  PInpC                        35A   CONST OPTIONS(*VARSIZE)
     D  PInpD                        35A   CONST OPTIONS(*VARSIZE)
     D  PInpE                        35A   CONST OPTIONS(*VARSIZE)
     D  PInpF                        35A   CONST OPTIONS(*VARSIZE)
     D  PCcy                          3A   CONST OPTIONS(*VARSIZE)
     D  POutA                       216A
     D  POutB                         6A
 
      ** Account ID Validation Routine
     D SPIsAccID       PR             1A
     D  PAccDet                      35A   VALUE
 
      ** Derivative Data Routine
     D SPDrvDta        PR            35A
     D  PMode                         7A   VALUE
     D  PStr                        216A   VALUE
 
      ** SDCWLFMT Wrapper
     D SPCvtDet        PR             7A
     D  POutA                       216A
 
      ** Detail Line Validation Routine
     D SPChkDet        PR             1A
 
      ** Detail Line Loader
     D SPSetDet        PR
     D  PDetCde                      10A   VALUE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *
      ** Begin Settlement Fields Extraction
      ** ==================================
      *
      ** Initialise all relevant variables.
      *
     C                   EXSR      SRINIT
      *
      ** Extract origin-based data.
      *
     C                   EXSR      SRORIGIN
      *
      ** Extract destination-based data.
      *
     C                   EXSR      SRDEST
      *
      ** End Settlement Fields Extraction
      ** ================================
      *
     C                   EVAL      *INLR = True
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Performs the initial variable setup.                 *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Clear all output parameters.
      *
     C                   EVAL      PROrgAcc = *BLANKS
     C                   EVAL      PROrgCty = *BLANKS
     C                   EVAL      PROrgBnk = *BLANKS
     C                   EVAL      PROrgCde = *BLANKS
     C                   EVAL      PPOrgAcc = *BLANKS
     C                   EVAL      PPOrgCty = *BLANKS
     C                   EVAL      PPOrgBnk = *BLANKS
     C                   EVAL      PPOrgCde = *BLANKS
     C                   EVAL      PDstAcc = *BLANKS
     C                   EVAL      PDstCty = *BLANKS
     C                   EVAL      PDstBnk = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRORIGIN - Extracts all relevant origin-based data into       *
      *            output parameters.                                 *
      *                                                               *
      *****************************************************************
     C     SRORIGIN      BEGSR
      *
      ** Format Origin Account
      ** =====================
      *
      ** Set derivation to Account ID mode.
      *
     C                   EVAL      PMode = '*ACCID'
      *
      ** Derive the Origin Account by using the Ordering Customer Info.
      *
     C                   IF        SPIsAccID(POrdCustA) = 'Y'
      *
     C                   EVAL      WData = POrdCustA
     C                   EVAL      PROrgAcc = SPDrvDta(PMode : WData)
     C                   EVAL      PPOrgAcc = PROrgAcc
      *
     C                   ELSE
      *
      ** At this point, the Ordering Customer Info. is currently
      ** unusable. Lets use the Ordering Bank Info. instead.
      *
     C                   IF        SPIsAccID(POrdBnkA) = 'Y'
      *
     C                   EVAL      WData = POrdBnkA
     C                   EVAL      PROrgAcc = SPDrvDta(PMode : WData)
     C                   EVAL      PPOrgAcc = PROrgAcc
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format Origin Bank
      ** ==================
      *
      ** Derive the Origin Bank by using the Ordering Bank Code.
      *
     C                   IF        POrdBnkCde <> *BLANKS
      *
     C                   EVAL      PROrgBnk = POrdBnkCde
     C                   EVAL      PPOrgBnk = POrdBnkCde
      *
     C                   ELSE
      *
      ** At this point, the Ordering Bank Code is currently unusable.
      ** Lets use the Ordering Bank Info. instead.
      *
     C                   IF        SPIsAccID(POrdBnkA) = 'Y'
      *
     C                   EVAL      WData = POrdBnkA
     C                   EVAL      PROrgBnk = SPDrvDta(PMode : WData)
     C                   EVAL      PPOrgBnk = PROrgBnk
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Derive the Origin Customer.
      *
     C                   EXSR      SROCUST
      *
      ** Format Origin Country and Origin Code
      ** =====================================
      *
     C                   SELECT
      *
      ** Customer Data Format
      ** --------------------
      *
     C                   WHEN      WRetCde = '*CUST'
      *
      ** Get the Customer details.
      *
     C                   EVAL      PCust = WOrgCust
     C                   EXSR      SRGetCustDet
      *
      ** Set the P/R Origin Countries.
      *
     C                   EVAL      PPOrgCty = BBCOLC
     C                   EVAL      PROrgCty = BBCOLC
      *
      ** Set the P/R Origin Codes.
      *
      ** Use the customer's SWIFT ID if it is available. Otherwise,
      ** use the Customer No./Short Name field.
      *
     C                   IF        BBCSID <> *BLANKS
      *
     C                   EVAL      PPOrgCde = BBCSID
     C                   EVAL      PROrgCde = BBCSID
      *
     C                   ELSE
      *
     C                   EVAL      PPOrgCde = BBCUST
     C                   EVAL      PROrgCde = BBCUST
      *
     C                   ENDIF
      *
      ** Bank Identifier Code Data Format
      ** --------------------------------
      *
     C                   WHEN      WRetCde = '*BIC'
      *
      ** Set the P/R Origin Countries.
      *
     C                   EVAL      PROrgCty = %SUBST(WOrgCust : 5 : 2)
     C                   EVAL      PPOrgCty = %SUBST(WOrgCust : 5 : 2)
      *
      ** Set the P/R Origin Codes.
      *
     C                   EVAL      PROrgCde = WOrgCust
     C                   EVAL      PPOrgCde = WOrgCust
      *
      ** Counterparty Data Format
      ** ------------------------
      *
     C                   WHEN      WRetCde = '*CPARTY' OR
     C                             WRetCde = '*CPART1'
      *
      ** Get Counterparty Nostro details.
      *
     C                   EVAL      PCNst = WOrgCust
     C                   EXSR      SRGetCNstDet
      *
      ** If Customer Short Name (part 2) is not equal to blanks,
      ** check if it exists in the Location Codes database.
      *
     C                   IF        AWCSN2 <> *BLANKS
      *
     C                   EVAL      PLCde = AWCSN2
     C                   EXSR      SRGetLCdeDet
      *
      ** Set the P/R Origin Countries if a record was found.
      *
     C                   IF        @RtCd = *BLANKS
      *
     C                   EVAL      PROrgCty = DVCNCD
     C                   EVAL      PPOrgCty = DVCNCD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROCUST - Derives the Origin Customer.                        *
      *                                                               *
      *****************************************************************
     C     SROCUST       BEGSR
      *
      ** Set the detail lines to be processed.
      *
     C                   CLEAR                   DTCDE
     C                   EVAL      DTCDE(1) = '*ORDCUST'
     C                   EVAL      DTCDE(2) = '*ORDBNKCDE'
     C                   EVAL      DTCDE(3) = '*ORDBNK'
      *
      ** Begin Detail Line Processing
      ** ============================
      *
     C                   FOR       WCtr = 1 TO %ELEM(DTCDE)
      *
     C                   CALLP     SPSetDet(DTCDE(WCtr))
      *
      ** Can we process these detail lines?
      *
     C                   IF        SPChkDet() = 'Y'
      *
      ** Convert the detail lines into useful data.
      *
     C                   EVAL      WRetCde = SPCvtDet(WData)
      *
      ** Derive the Origin Customer.
      *
     C                   IF        WRetCde = '*CUST' OR
     C                             WRetCde = '*BIC'  OR
     C                             WRetCde = '*CPART1'
     C                   EVAL      WOrgCust = SPDrvDta(WRetCde : WData)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Derive the Counterparty.
      *
     C                   IF        WRetCde = '*CPARTY' AND
     C                             WCtrPrty = *BLANKS
     C                   EVAL      WCtrPrty = SPDrvDta(WRetCde : WData)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDFOR
      *
      ** End Detail Line Processing
      ** ==========================
      *
      ** At this point, no Origin Customer was derived. Lets use the
      ** Counterparty data instead.
      *
     C                   IF        WCtrPrty <> *BLANKS
     C                   EVAL      WOrgCust = WCtrPrty
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEST - Extracts all relevant destination-based data into    *
      *          output parameters.                                   *
      *                                                               *
      *****************************************************************
     C     SRDEST        BEGSR
      *
      ** Format Destination Account
      ** ==========================
      *
      ** Set derivation to Account ID mode.
      *
     C                   EVAL      PMode = '*ACCID'
      *
      ** Derive the Destination Account by using the first Ben. Line.
      *
     C                   IF        SPIsAccID(PBenA) = 'Y'
      *
     C                   EVAL      WData = PBenA
     C                   EVAL      PDstAcc = SPDrvDta(PMode : WData)
      *
     C                   ELSE
      *
      ** At this point, the first Ben. Line is currently unusable.
      ** Lets use the first Account with Bank Line instead.
      *
     C                   IF        SPIsAccID(PAWBnkA) = 'Y'
      *
     C                   EVAL      WData = PAWBnkA
     C                   EVAL      PDstAcc = SPDrvDta(PMode : WData)
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Derive the Destination Customer.
      *
     C                   EXSR      SRDCUST
      *
      ** Format Destination Country and Destination Code
      ** ===============================================
      *
     C                   SELECT
      *
      ** Customer Data Format
      ** --------------------
      *
     C                   WHEN      WRetCde = '*CUST'
      *
      ** Get the Customer details.
      *
     C                   EVAL      PCust = WDstCust
     C                   EXSR      SRGetCustDet
      *
      ** Set the Destination Country.
      *
     C                   EVAL      PDstCty = BBCOLC
      *
      ** Bank Identifier Code Data Format
      ** --------------------------------
      *
     C                   WHEN      WRetCde = '*BIC'
      *
      ** Set the Destination Country.
      *
     C                   EVAL      PDstCty = %SUBST(WOrgCust : 5 : 2)
      *
      ** Counterparty Data Format
      ** ------------------------
      *
     C                   WHEN      WRetCde = '*CPARTY' OR
     C                             WRetCde = '*CPART1'
      *
      ** Get Counterparty Nostro details.
      *
     C                   EVAL      PCNst = WDstCust
     C                   EXSR      SRGetCNstDet
      *
      ** If Customer Short Name (part 2) is not equal to blanks,
      ** check if it exists in the Location Codes database.
      *
     C                   IF        AWCSN2 <> *BLANKS
      *
     C                   EVAL      PLCde = AWCSN2
     C                   EXSR      SRGetLCdeDet
      *
      ** Set the Destination Country if a record was found.
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      PDstCty = DVCNCD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDCUST - Derives the Destination Customer.                   *
      *                                                               *
      *****************************************************************
     C     SRDCUST       BEGSR
      *
     C                   EVAL      WCtrPrty = *BLANKS
      *
      ** Set the detail lines to be processed.
      *
     C                   CLEAR                   DTCDE
     C                   EVAL      DTCDE(1) = '*BEN'
     C                   EVAL      DTCDE(2) = '*BENF'
     C                   EVAL      DTCDE(3) = '*AWBNKCDE'
     C                   EVAL      DTCDE(4) = '*AWBNK'
      *
      ** Begin Detail Line Processing
      ** ============================
      *
     C                   FOR       WCtr = 1 TO %ELEM(DTCDE)
      *
     C                   CALLP     SPSetDet(DTCDE(WCtr))
      *
      ** Can we process these detail lines?
      *
     C                   IF        SPChkDet() = 'Y'
      *
      ** Convert the detail lines into useful data.
      *
     C                   EVAL      WRetCde = SPCvtDet(WData)
      *
      ** Derive the Destination Customer.
      *
     C                   IF        WRetCde = '*CUST' OR
     C                             WRetCde = '*BIC'  OR
     C                             WRetCde = '*CPART1'
     C                   EVAL      WDstCust = SPDrvDta(WRetCde : WData)
     C                   EVAL      WData = DTLN(1)
     C                   EVAL      PDstBnk = SPDrvDta(PMode : WData)
     C                   LEAVESR
     C                   ENDIF
      *
      ** Derive the Counterparty.
      *
     C                   IF        WRetCde = '*CPARTY' AND
     C                             WCtrPrty = *BLANKS
     C                   EVAL      WCtrPrty = SPDrvDta(WRetCde : WData)
     C                   EVAL      WData = DTLN(1)
     C                   EVAL      PDstBnk = SPDrvDta(PMode : WData)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDFOR
      *
      ** End Detail Line Processing
      ** ==========================
      *
      ** At this point, no Destination Customer was derived. Lets use
      ** the Counterparty data instead.
      *
     C                   IF        WCtrPrty <> *BLANKS
     C                   EVAL      WDstCust = WCtrPrty
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetCustDet - Gets Customer details via AOCUSTR0.            *
      *                                                               *
      *****************************************************************
     C     SRGetCustDet  BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PErr
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetCNstDet - Gets Counterparty Nostro details via AOCNSTR0. *
      *                                                               *
      *****************************************************************
     C     SRGetCNstDet  BEGSR
      *
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCNst
     C     SDCNST        PARM      SDCNST        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCNSTPD'
     C                   EVAL      DBKey = PCNst
     C                   EVAL      DBase = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetLCdeDet - Gets Location Code details via AOLOCNR0.       *
      *                                                               *
      *****************************************************************
     C     SRGetLCdeDet  BEGSR
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PLCde
     C     SDLOCN        PARM      SDLOCN        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDLOCNPD'
     C                   EVAL      DBKey = PLCde
     C                   EVAL      DBase = 903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Subroutine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter List
      ** ==============
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters:
      *
      ** Ordering Customer Lines 1 to 5
      ** Ordering Bank Lines 1 to 5
      ** Ordering Bank Code
      ** Beneficiary Lines 1 to 6
      ** Account with Bank Lines 1 to 5
      ** Account with Bank Code
      ** Origin Currency
      ** Destination Currency
      *
     C                   PARM                    POrdCustA
     C                   PARM                    POrdCustB
     C                   PARM                    POrdCustC
     C                   PARM                    POrdCustD
     C                   PARM                    POrdCustE
     C                   PARM                    POrdBnkA
     C                   PARM                    POrdBnkB
     C                   PARM                    POrdBnkC
     C                   PARM                    POrdBnkD
     C                   PARM                    POrdBnkE
     C                   PARM                    POrdBnkCde
     C                   PARM                    PBenA
     C                   PARM                    PBenB
     C                   PARM                    PBenC
     C                   PARM                    PBenD
     C                   PARM                    PBenE
     C                   PARM                    PBenF
     C                   PARM                    PAWBnkA
     C                   PARM                    PAWBnkB
     C                   PARM                    PAWBnkC
     C                   PARM                    PAWBnkD
     C                   PARM                    PAWBnkE
     C                   PARM                    PAWBCde
     C                   PARM                    POrgCcy
     C                   PARM                    PDstCcy
      *
      ** Output Parameters:
      *
      ** Receipt Origin Account
      ** Receipt Origin Country
      ** Receipt Origin Bank
      ** Receipt Origin Code
      ** Pay Origin Account
      ** Pay Origin Country
      ** Pay Origin Bank
      ** Pay Origin Code
      ** Destination Account
      ** Destination Country
      ** Destination Bank
      *
     C                   PARM                    PROrgAcc
     C                   PARM                    PROrgCty
     C                   PARM                    PROrgBnk
     C                   PARM                    PROrgCde
     C                   PARM                    PPOrgAcc
     C                   PARM                    PPOrgCty
     C                   PARM                    PPOrgBnk
     C                   PARM                    PPOrgCde
     C                   PARM                    PDstAcc
     C                   PARM                    PDstCty
     C                   PARM                    PDstBnk
      *
      ** End of Parameter List
      ** =====================
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPIsAccID - Checks if the given detail is an Acc. Identifier. *
      *                                                               *
      *****************************************************************
     P SPIsAccID       B
     D SPIsAccID       PI             1A
     D  PAccDet                      35A   VALUE
      *
      ** Working Variables
      *
     D WRetCde         S              1A   INZ('N')
     D WAccDet         S                   LIKE(PAccDet)
      *
     C                   IF        PAccDet <> *BLANKS
      *
     C                   EVAL      WAccDet = %TRIM(PAccDet)
      *
      ** Is the first non-blank character a slash?
      *
     C                   IF        %SUBST(WAccDet : 1 : 1) = '/'
     C                   EVAL      WRetCde = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN    WRetCde
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPDrvDta - Derives useful data out of formatted strings.      *
      *                                                               *
      *****************************************************************
     P SPDrvDta        B
     D SPDrvDta        PI            35A
     D  PMode                         7A   VALUE
     D  PStr                        216A   VALUE
      *
      ** Working Variables
      *
     D WData           S             35A
     D WStr            S                   LIKE(PStr)
     D WPos            S              2P 0
      *
      ** Begin Data Format Selection
      ** ===========================
      *
     C                   EVAL      WStr = %TRIM(PStr)
      *
     C                   SELECT
      *
      ** Customer/Bank Identifier Code/CPART1 Data Format
      ** ------------------------------------------------
      *
     C                   WHEN      PMode = '*CUST' OR
     C                             PMode = '*BIC'  OR
     C                             PMode = '*CPART1'
      *
     C                   EVAL      WData = %SUBST(WStr : 1 : 12)
      *
      ** Counterparty Data Format
      ** ------------------------
      *
     C                   WHEN      PMode = '*CPARTY'
      *
     C                   EVAL      WData = %SUBST(WStr : 1 : 8)
      *
      ** Account ID Data Format
      ** ----------------------
      *
     C                   WHEN      PMode = '*ACCID'
      *
      ** Extract all useful data minus the preceding slashes.
      *
     C                   EVAL      WPos = 1
      *
     C                   IF        %SUBST(WStr : WPos : 1) = '/'
      *
     C                   EVAL      WPos = WPos + 1
      *
     C                   IF        %SUBST(WStr : WPos : 1) = '/'
     C                   EVAL      WPos = WPos + 1
     C                   ENDIF
      *
     C                   EVAL      WData = %SUBST(WStr : WPos)
      *
     C                   ELSE
      *
      ** If this Account ID does not have preceeding slashes, return
      ** it back unaltered to the calling program.
      *
     C                   EVAL      WData = PStr
      *
     C                   ENDIF
      *
     C                   OTHER
      *
     C                   EVAL      WData = PStr
      *
     C                   ENDSL
      *
      ** End Data Format Selection
      ** =========================
      *
      ** Return the derived (or unaltered) information.
      *
     C                   RETURN    WData
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPCvtDet - Converts detail lines into useful information      *
      *            through SDCWLFMT.                                  *
      *                                                               *
      *****************************************************************
     P SPCvtDet        B
     D SPCvtDet        PI             7A
     D  POutA                       216A
      *
      ** Additonal SDCWLFMT parameters.
      *
     D PRetCde         S              7A   INZ('*AML')
     D POutB           S              6A
      *
     C                   CALLP     SDCWLFMT(PRetCde :
     C                             DTLN(1) : DTLN(2) :
     C                             DTLN(3) : DTLN(4) :
     C                             DTLN(5) : DTLN(6) :
     C                             DTCCY :
     C                             POutA : POutB)
      *
     C                   RETURN    PRetCde
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPChkDet - Checks if there is something useful to process in  *
      *            the detail lines.                                  *
      *                                                               *
      *****************************************************************
     P SPChkDet        B
     D SPChkDet        PI             1A
      *
      ** Working Variables
      *
     D WRetCde         S              1A   INZ('N')
     D WCtr            S              2P 0
      *
      ** Loop through the current detail lines and check if any of
      ** them contains data.
      *
     C                   FOR       WCtr = 1 TO %ELEM(DTLN)
      *
     C                   IF        DTLN(WCtr) <> *BLANKS
     C                   EVAL      WRetCde = 'Y'
     C                   RETURN    WRetCde
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   RETURN    WRetCde
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SPSetDet - Sets what details are to be made available for     *
      *            further processing.                                *
      *                                                               *
      *****************************************************************
     P SPSetDet        B
     D SPSetDet        PI
     D  PDetCde                      10A   VALUE
      *
      ** Begin Program Parameter Selection
      ** =================================
      *
     C                   SELECT
      *
      ** Ordering Customer Lines
      ** -----------------------
      *
     C                   WHEN      PDetCde = '*ORDCUST'
      *
     C                   EVAL      DTLN(1) = POrdCustA
     C                   EVAL      DTLN(2) = POrdCustB
     C                   EVAL      DTLN(3) = POrdCustC
     C                   EVAL      DTLN(4) = POrdCustD
     C                   EVAL      DTLN(5) = POrdCustE
     C                   EVAL      DTLN(6) = *BLANKS
     C                   EVAL      DTCCY = POrgCcy
      *
      ** Ordering Bank Lines
      ** -------------------
      *
     C                   WHEN      PDetCde = '*ORDBNK'
      *
     C                   EVAL      DTLN(1) = POrdBnkA
     C                   EVAL      DTLN(2) = POrdBnkB
     C                   EVAL      DTLN(3) = POrdBnkC
     C                   EVAL      DTLN(4) = POrdBnkD
     C                   EVAL      DTLN(5) = POrdBnkE
     C                   EVAL      DTLN(6) = *BLANKS
     C                   EVAL      DTCCY = POrgCcy
      *
      ** Ordering Bank Code
      ** ------------------
      *
     C                   WHEN      PDetCde = '*ORDBNKCDE'
      *
     C                   CLEAR                   DTLN
     C                   EVAL      DTLN(1) = POrdBnkCde
     C                   EVAL      DTCCY = POrgCcy
      *
      ** Beneficiary Lines
      ** -----------------
      *
     C                   WHEN      PDetCde = '*BEN'
      *
     C                   EVAL      DTLN(1) = PBenA
     C                   EVAL      DTLN(2) = PBenB
     C                   EVAL      DTLN(3) = PBenC
     C                   EVAL      DTLN(4) = PBenD
     C                   EVAL      DTLN(5) = PBenE
     C                   EVAL      DTLN(6) = *BLANKS
     C                   EVAL      DTCCY = PDstCcy
      *
      ** Last Beneficiary Line
      ** ---------------------
      *
     C                   WHEN      PDetCde = '*BENF'
      *
     C                   CLEAR                   DTLN
     C                   EVAL      DTLN(1) = PBenF
     C                   EVAL      DTCCY = PDstCcy
      *
      ** Account with Bank Lines
      ** -----------------------
      *
     C                   WHEN      PDetCde = '*AWBNK'
      *
     C                   EVAL      DTLN(1) = PAWBnkA
     C                   EVAL      DTLN(2) = PAWBnkB
     C                   EVAL      DTLN(3) = PAWBnkC
     C                   EVAL      DTLN(4) = PAWBnkD
     C                   EVAL      DTLN(5) = PAWBnkE
     C                   EVAL      DTLN(6) = *BLANKS
     C                   EVAL      DTCCY = PDstCcy
      *
      ** Account with Bank Code
      ** ----------------------
      *
     C                   WHEN      PDetCde = '*AWBNKCDE'
      *
     C                   CLEAR                   DTLN
     C                   EVAL      DTLN(1) = PAWBCde
     C                   EVAL      DTCCY = PDstCcy
      *
     C                   OTHER
      *
     C                   CLEAR                   DTLN
     C                   EVAL      DTCCY = *BLANKS
      *
     C                   ENDSL
      *
      ** End Program Parameter Selection
      ** ===============================
      *
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
