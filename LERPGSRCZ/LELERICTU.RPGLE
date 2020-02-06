     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover instructions control update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LELERICTU - Rollover Instruction Control Update              *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             Rollover Instructions.                            *
      *             It is a batch function.                           *
      *            Processes executed controlled by input Action Code *
      *            - For A (=Amend)                                   *
      *              - Validate the Rollover Instr. details fields    *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise)                               *
      *              - Validate the Rollover Instr. details fields    *
      *              - Validate the settlement fields                 *
      *              (Roll Instr are only sent from Loan Manager      *
      *               if authorised; validation need to be done here) *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702532           Date 13Jan15               *
      *                 MD028338           Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13843           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10456           Date 10Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2579            Date 07Jun04               *
      *                 BUG827             Date 06May04               *
      *                 CAP084             Date 09Jan04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 WA0021             Date 02Oct03               *
      *                 WA0027             Date 01Oct03               *
      *                 WA0005             Date 19Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 22May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Recompile*
      *             due to changes on LELERIPD and LELERI2PD.         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10456- Validate and update settlement details without     *
      *            limitations.                                       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - API wrapper project                                 *
      *           Remove Rollover Status from defn file (recompile)   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  WA0021 - Remove Rollover Status from defn file (recompile)   *
      *  WA0027 - Loan number should be alpha not numeric             *
      *  WA0005 - Recompiled over changed LEVLERLPD                   *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
 
     FLEILERIPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(LO_)
     FLEFCLTL0  IF   E           K DISK
     F                                     PREFIX(F_)
     FLELOAML0  IF   E           K DISK
     F                                     PREFIX(A_)
     FPSOLD     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDFF)
     F                                     PREFIX(P_)
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
 
      ** Rollover Instructions Details in screen format
     D LERI          E DS                  EXTNAME(LELERIPD)
 
     D NwRoScnFmt2   E DS                  EXTNAME(LELERI2PD)
      *** Rollover Instructions Work fields
 
      ** Rollover Instructions Details OK indicator
     D LERI_OK       E DS                  EXTNAME(LEELERIPD)
 
     D SvLELERI2     E DS                  EXTNAME(LELERI2PD)
      *** Rollover Instructions Work fields
     D                                     PREFIX(Sv)
 
 
      ** Customer Loans Details in file format
 
     D CrLnFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Current Loan in File Format CL
     D                                     PREFIX(L)
      *
     D CrLnFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Current Loan in File Format CK
     D                                     PREFIX(K)
     D***CUREC**              401    469                                                      CGL029
     D***CUPAY**              544   1102                                                      CGL029
     D  CUREC                415    469                                                       CGL029
     D  CUPAY                558   1102                                                       CGL029
     D  CURECEx             1266   1283                                                       CGL029
     D  CUPAYEx             1284   1301                                                       CGL029
 
      ** New Customer Loans Details in file format
     D ValidloanL    E DS                  EXTNAME(LEVLERLPD)
     D                                     PREFIX(L_)
      ***  New Loan in File Format CL
     D***CLREC**              459    527                                                      CGL029
     D***CLPAY**              528   1086                                                      CGL029
     D  CLREC                473    527                                                       CGL029
     D  CLPAY                572   1086                                                       CGL029
     D***CLRECEx             1579   1596                                               CGL029 TDA023
     D***CLPAYEx             1597   1614                                               CGL029 TDA023
     D  CLRECEx             1597   1614                                                       TDA023
     D  CLPAYEx             1615   1632                                                       TDA023
      *
     D ValidloanK    E DS                  EXTNAME(LEVLERKPD)
      ***  New Loan in File Format CK
     D                                     PREFIX(K_)
     D***CKREC**              401    469                                                      CGL029
     D***CKPAY**              544   1102                                                      CGL029
     D  CKREC                415    469                                                       CGL029
     D  CKPAY                558   1102                                                       CGL029
     D  CKRECEx             1266   1283                                                       CGL029
     D  CKPAYEx             1284   1301                                                       CGL029
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      * Curent Screen Receive instructions
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
 
      * Current Screen Payment instructions
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
 
      * Current Fra/irs instructions
     D C_FRI         E DS                  EXTNAME(SDESSFPD) PREFIX(C_)
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
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
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
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
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
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
 
      ** Current Rollover Instructions Details in screen format
     D C_LERI        E DS                  EXTNAME(LELERIPD)
     D                                     PREFIX(C_)
 
     D ExtData       E DS                  EXTNAME(LELEEXPD)
      * LE Rollover Instructions Extra Data - File (D/B) format
 
      *                                                                                     AR702532
      ** LE Extra Data - Classe 1 Data - File (D/B) format                                  AR702532
      *                                                                                     AR702532
     D InfData       E DS                  EXTNAME(LELEIFPD)                                AR702532
     D                                     PREFIX(IF_)                                      AR702532
                                                                                            AR702532
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition
 
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D*OLNOAlpha               1      6                                                CSD027 CLE148
     D*OLNONum**               1      6  0                                             CSD027 CLE148
      *
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEO1MFPD)
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEO2MFPD)
 
     D ACCYA           S              3    DIM(12)
 
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D WDealNo         S              6A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      /SPACE 5
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      *  Amends
      *  ======
 
     C     DDACTN        WHENEQ    'A'
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      LERI                                   99
     C     *in99         ifeq      *on
     C                   endif
     C                   endif
 
     C                   EXSR      SetupAmend
 
     C                   EXSR      ValidateRo
 
      *
      ****Validate*settlement*details*if*Discount*Loan*****************                     BUG10456
      ****or*a*multi-currency*rollover*********************************                     BUG10456
      ** Validate settlement details unconditionally                                        BUG10456
      *
     C*****WDisc         IFEQ      'Y'                                                      BUG10456
     C*****DDNCCY        ORNE      *BLANKS                                                  BUG10456
     C*****DDNCCYB       ORNE      *BLANKS                                                  BUG10456
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
     C**********         ENDIF                                                              BUG10456
 
     C                   EXSR      ValdateAmd
 
      *  Authorisations
      *  ==============
 
      *  (need to validate here because Rollover Instr are only sent by Loan Manager
      *   when authorised)
 
     C     DDACTN        WHENEQ    'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
 
     C                   EXSR      SetupAmend
 
     C                   EXSR      ValidateRo
      *
      ****Validate*settlement*details*if*Discount*Loan*****************                     BUG10456
      ****or*a*multi-currency*rollover*********************************                     BUG10456
      ** Validate settlement details unconditionally                                        BUG10456
      *
     C*****WDisc         IFEQ      'Y'                                                      BUG10456
     C*****DDNCCY        ORNE      *BLANKS                                                  BUG10456
     C*****DDNCCYB       ORNE      *BLANKS                                                  BUG10456
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
     C**********         ENDIF                                                              BUG10456
 
     C                   EXSR      ValdateAmd
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Do updates for this transaction
      ** according to whether it is valid or invalid
 
     C     Idx           IFEQ      0
     C                   EXSR      UPDAT_VAL
     C                   ENDIF
     C     Idx           IFNE      0
     C                   EXSR      UPDAT_INVAL
     C                   ENDIF
 
      **  Terminate program
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPFLD        BEGSR
 
     C*************      MOVEL     O1RPLC        RPLOC             1                not on LEO1MFPD
      * Assume repair is in Front Office
     C                   MOVEL     'F'           RPLOC             1
      *
      ** Rollover Instructions details
      *
     C                   CLEAR                   LERI
     C                   MOVE      O1ACTN        DDACTN
      *
     C                   MOVEL     O1LNRF        DDLNRF
     C                   MOVEL     O1CNUM        DDCUST
      * format Rollover date
     C                   MOVEL     O1RLDT        DDRLDTB
     C                   MOVE      O1RLDT        ##YEAR            2
     C                   MOVE      ##YEAR        DDRLDTB
      *
     C                   MOVEL     O1RLFQ        DDRLFQB
     C     O1RLDY        IFNE      0
     C                   MOVEL     O1RLDY        DDRLDYB
     C                   END
     C     O1NBRA        IFNE      0
     C                   MOVEL     O1NBRA        DDNBRAB
     C                   END
     C                   MOVEL     O1NRTS        DDNRTSB
     C                   MOVEL     O1NSIN        DDNSINB
     C     O1NCAS        IFNE      0
     C                   MOVEL     O1NCAS        DDNCASB
     C                   END
     C                   MOVEL     O1NCHI        DDNCHIB
      * format Next Rollover date
     C                   MOVEL     O1NROD        DDNRODB
     C                   MOVE      O1NROD        ##YEAR            2
     C                   MOVE      ##YEAR        DDNRODB
      *
     C                   MOVEL     O1NPAM        DDNPRAB
     C                   MOVEL     O1NDAM        DDNDAMB
      * format New Interest date
     C                   MOVEL     O1NIPD        DDNIPDB
     C                   MOVE      O1NIPD        ##YEAR            2
     C                   MOVE      ##YEAR        DDNIPDB
      *
      * format New Maturity date
     C                   MOVEL     O1NMDT        DDNMDTB
     C                   MOVE      O1NMDT        ##YEAR            2
     C                   MOVE      ##YEAR        DDNMDTB
      *
     C                   MOVEL     O1NCCY        DDNCCYB
     C                   MOVEL     O1NCPA        DDNCPAB
     C                   MOVEL     O1NFCE        DDNFCEB
     C                   MOVEL     O1NFMD        DDNFMDB
     C                   MOVEL     O1NBCE        DDNBCEB
     C                   MOVEL     O1NBMD        DDNBMDB
     C                   MOVEL     O1NLRA        DDNLRAB
     C                   MOVEL     O1NFRS        DDNFRSB
     C                   MOVEL     O1NFSN        DDNFSNB
     C                   MOVEL     O1NFPC        DDNFPCB
      *
      ** Receive instructions
      *
     C                   CLEAR                   S_REC
     C                   MOVE      O1RRST        DDRSTM
     C                   MOVE      O1RRON        DDRONX
     C                   MOVE      O1RRIB        DDRIBN
     C                   MOVE      O1RRBA        DDRIBA
     C                   MOVE      O1RROB        DDROBN
     C                   MOVE      O1RROC        DDROCN
     C                   MOVE      O1RRSC        DDRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      O1RPST        FLPSTM
     C                   MOVE      O1RPON        FLPONS
     C                   MOVEL     O1RPON        FLPOBR
     C                   MOVE      O1RPIB        FLPIBN
     C                   MOVE      O1RPBA        FLPIBA
     C                   MOVE      O1RPOB        FLPOBN
     C                   MOVE      O1RPOC        FLPOCN
     C                   MOVE      O1RCVM        FLCVMR
     C                   MOVE      O1RRCR        FLRCRN
     C                   MOVE      O1RRCA        FLRCRA
     C                   MOVE      O1RRVN        FLRVNO
     C                   MOVE      O1RAWB        FLAWBN
     C                   MOVE      O1RAWA        FLAWBA
     C                   MOVE      O1RBEN        FLBENN
     C                   MOVE      O1RBNA        FLBENA
      * Details of payment
     C     35            SUBST     O1RDP1:1      FLDTP1
     C     35            SUBST     O1RDP1:36     FLDTP2
     C     35            SUBST     O1RDP1:71     FLDTP3
     C     35            SUBST     O1RDP1:106    FLDTP4
      *
     C                   MOVE      O1RDCH        FLDCHG
      * Bank to bank info
     C     35            SUBST     O1RBB1:1      FLBTB1
     C     35            SUBST     O1RBB1:36     FLBTB2
     C     35            SUBST     O1RBB1:71     FLBTB3
     C     35            SUBST     O1RBB1:106    FLBTB4
     C     35            SUBST     O1RBB1:141    FLBTB5
     C     35            SUBST     O1RBB1:176    FLBTB6
      *
     C                   MOVE      O1RPSC        FLPSCY
     C                   MOVE      O1RICY        FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      O1RRSR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLREXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      O1RPSR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLPEXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      O1RRSI        DDREXI                                       CLE031
     C                   MOVE      O1RRSC        DDRSCY                                       CLE031
     C                   MOVE      O1RPSI        DDPEXI                                       CLE031
     C                   MOVE      O1RPSC        DDPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LELERIRTV'
      *
      * INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      ' '           RESPMODE          1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Loan Number
     C                   PARM                    DDLNRF
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      *
      * OUTPUTS
 
      * (Current) loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      * (Current) loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Loan Number
     C                   PARM      *BLANK        DDLNRFOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateRo    BEGSR
      *
      *  First retrieve the current rollover fields using module CVT
      *  (needed for validation purpose)
 
     C                   CALLB     'LELERICVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      * Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      * Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE011
     C                   PARM                    S01465
     C                   PARM                    CLE005
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      * OUTPUTS
      *
      * Loan in screen format
     C                   PARM                    C_LERI
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
 
      *  If action is X, the VAL module validates the current file fields
      *  instead of the screen fields and move these fields into V fields
      *  ready for update.
      *  Move the screen fields into the current file fields DS on LELERI2PD
      *  so that the VAL module uses the correct fields for validation and update.
      *  This is only valid for the CTU as action X must validate the transaction.
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      *    Save fields from LELERI2PD
     C                   MOVEL     NwRoScnFmt2   SvLELERI2
      *
      *    Check if fields are to be removed
     C                   EXSR      SRRVFD2
      *
      *    If fields are be removed, keep current value
      *    else, need to have screen values into current fields
     C     WRLDT2        IFNE      '*'
     C                   MOVEL     DDRLDTB       DDRLDT
     C                   ENDIF
      *
     C     WRLFQ2        IFNE      '*'
     C                   MOVEL     DDRLFQB       DDRLFQ
     C                   ENDIF
      *
     C     WRLDY2        IFNE      '*'
     C                   MOVEL     DDRLDYB       DDRLDY
     C                   ENDIF
      *
     C     WNBRA2        IFNE      '*'
     C                   MOVEL     DDNBRAB       DDNBRA
     C                   ENDIF
      *
     C     WNRTS2        IFNE      '*'
     C                   MOVEL     DDNRTSB       DDNRTS
     C                   ENDIF
      *
     C     WNSIN2        IFNE      '*'
     C                   MOVEL     DDNSINB       DDNSIN
     C                   ENDIF
      *
     C     WNCAS2        IFNE      '*'
     C                   MOVEL     DDNCASB       DDNCAS
     C                   ENDIF
      *
     C     WNCHI2        IFNE      '*'
     C                   MOVEL     DDNCHIB       DDNCHI
     C                   ENDIF
      *
     C     WNROD2        IFNE      '*'
     C                   MOVEL     DDNRODB       DDNROD
     C                   ENDIF
      *
     C     WNPRA2        IFNE      '*'
     C                   MOVEL     DDNPRAB       DDNPRAM
     C                   ENDIF
      *
     C     WNDAM2        IFNE      '*'
     C                   MOVEL     DDNDAMB       DDNDAM
     C                   ENDIF
      *
     C     WNIPD2        IFNE      '*'
     C                   MOVEL     DDNIPDB       DDNIPD
     C                   ENDIF
      *
     C     WNMDT2        IFNE      '*'
     C                   MOVEL     DDNMDTB       DDNMDT
     C                   ENDIF
      *
     C     WNCCY2        IFNE      '*'
     C                   MOVEL     DDNCCYB       DDNCCY
     C                   ENDIF
      *
     C     WNCPA2        IFNE      '*'
     C                   MOVEL     DDNCPAB       DDNCPA
     C                   ENDIF
      *
     C     WNFCE2        IFNE      '*'
     C                   MOVEL     DDNFCEB       DDNFCE
     C                   ENDIF
      *
     C     WNFMD2        IFNE      '*'
     C                   MOVEL     DDNFMDB       DDNFMD
     C                   ENDIF
      *
     C     WNBCE2        IFNE      '*'
     C                   MOVEL     DDNBCEB       DDNBCE
     C                   ENDIF
      *
     C     WNBMD2        IFNE      '*'
     C                   MOVEL     DDNBMDB       DDNBMD
     C                   ENDIF
      *
     C     WNLRA2        IFNE      '*'
     C                   MOVEL     DDNLRAB       DDNLRA
     C                   ENDIF
      *
     C                   MOVEL     DDNFRSB       DDNFRS
     C                   MOVEL     DDNFSNB       DDNFSN
     C                   MOVEL     DDNFPCB       DDNFPC
      *
 
     C                   ENDIF
      *
      *  Check if Extended Settlements, Funding details and Mutli ccy
      *  Rollovers are required
      *
     C                   EXSR      @CHKLOAN
 
     C                   CALLB     'LELERIVAL'
      *
      * INPUTS
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Rollover Instructions Details in screen format
     C                   PARM                    LERI
     C                   PARM                    InfData                                    AR702532
     C                   PARM                    @@FRNT           20
     C                   PARM                    ExtData
      *                                                                                     AR702532
      ** Action Code (Reject transaction)                                                   AR702532
      *                                                                                     AR702532
     C                   PARM      *BLANK        @ACTRV            1                        AR702532
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    LERI_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      * Valid Loans layout (DS) from/to caller
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
      * Multi-currency allowed by Loan facility
     C                   PARM                    @MULTI            1
                                                                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
                                                                                             BUG2579
      * Funding Details required
     C                   PARM                    @FUNDING          1
                                                                                              BUG827
      ** Forward Yield required                                                               BUG827
     C                   PARM                    @FYIELD           1                          BUG827
      *                                                                                       BUG827
      * Repayment Exist
     C                   PARM                    @WERLN
     C                   PARM                    @WLNNO
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
     C                   PARM                    WINCY
     C                   PARM                    WPSET
     C                   PARM                    WRLDT1            1
     C                   PARM                    WNCCY1            1
     C                   PARM                    MULTIC
     C                   PARM                    WSett
      * Current Loan
     C                   PARM                    CrLnFilFmtCL
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM      'Y'           @@CTU             1
 
      *
     C     DDACTN        IFEQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
      *    Restore fields from LELERI2PD (needed for settl. instr. validation)
     C                   MOVEL     SvLELERI2     NwRoScnFmt2
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
 
      *  The settlements instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore convert the file format to screen format.
 
     C                   CALLB     'ZASETINCVT'
      **   Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
 
      **   Settlement Instruction in input format
     C                   PARM                    C_PAY
     C                   PARM                    C_REC
     C                   PARM                    C_FRI
     C                   PARM                    ##RCCY                                      CSF011A
     C                   PARM                    ##PCCY                                      CSF011A
 
      *
      *  Validate the Settlement instructions
      *
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    ##CALP            4
      ** Transaction Fields
      ** Payment currency (or Loan currency if only one currency on Loan)
     C                   PARM                    ##PCCY            3
      ** Receive currency (or Loan currency if only one currency on Loan)
     C                   PARM                    ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      ** Loan type
     C                   PARM      LLTYP         ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM                    ##FFND            1
      ** Booking Branch
     C                   PARM                    ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    S_FRI
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         CKPAY
     C                   MOVEL     FLPONS        CKPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        K_CLRPST                                     CGL029
     C                   MOVEL     FLPOBR        K_CLRLSB
     C                   MOVEL     FLCVMR        K_CLRCVM
     C                   MOVEL     FLPSCY        K_CLRPSC
     C                   MOVEL     FLIC72        K_CLRICY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         CKREC
     C                   MOVEL     FLRONS        CKRECEx                                      CGL029
     C                   MOVEL     FLRSTM        K_CLRRST                                     CGL029
     C                   MOVEL     FLROBR        K_CLRLBR
     C                   MOVEL     FLRSCY        K_CLRRSC
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        K_CLRRSR                                     CLE031
     C                   Z-ADD     FLPEXR        K_CLRPSR                                     CLE031
     C                   MOVE      FLREXI        K_CLRRSI                                     CLE031
     C                   MOVE      FLPEXI        K_CLRPSI                                     CLE031
     C                   MOVE      FLRSCY        K_CLRRSC                                     CLE031
     C                   MOVE      FLPSCY        K_CLRPSC                                     CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate amendments
      *****************************************************************
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
     C                   CALLB     'LELERICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      * Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      * Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      * Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      *
      * OUTPUTS
      *
      * Loan in screen format
     C                   PARM                    C_LERI
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
 
 
     C                   CALLB     'LELERIAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      * New funding participant in Screen Format
     C                   PARM                    LERI
      * Current funding participant in Screen Format
     C                   PARM                    C_LERI
      * Current Loan in file format (CL)
     C                   PARM                    CrLnFilFmtCL
      * Current Loan in file format (CK)
     C                   PARM                    CrLnFilFmtCK
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    LERI_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
 
      ** If repair in back-office
 
     C     RPLOC         IFEQ      'B'
 
      ** Write to the invalid (repair) files
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      DDFOTRANID = O1TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'
     C                   EVAL      DDTMESTMP = TimeStamp
     C                   EVAL      DDMsgType  = 'LELERI'
 
     C                   WRITE     LEILERID0
     C                   WRITE     APIDSETD0
     C                   EXSR      W_ZATRNERR
 
      ** Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM                    @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      ** Set up the returned message format
 
     C                   MOVE      O1MSGT        O2MSGT
     C                   MOVE      O1TRUS        O2TRUS
     C                   MOVE      O1TRWS        O2TRWS
     C                   MOVE      O1TNRF        O2TNRF
     C                   MOVE      O1TRSN        O2TRSN
     C                   MOVE      O1ACTN        O2ACTN
     C                   MOVE      O1TRDS        O2TRDS
     C                   MOVE      O1TRTS        O2TRTS
     C                   MOVE      O1NRBA        O2NRBA
     C                   MOVEL     'E'           O2MSGS
     C                   MOVEL     ZAMSID        O2MSGI
     C                   MOVEL     ZAMSTX        O2MSTX
     C                   MOVE      O1LNRF        O2LNRF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
 
      ** Update the database
 
     C                   EXSR      UPD_DBASE
 
      ** If there were errors, rollback any database changes and increment
      ** the error index by 1 to drive the 'invalid' record processing
 
     C     RetCodeOut    IFNE      *BLANK
 
     C                   ADD       1             Idx
 
     C                   ROLBK
 
     C                   ELSE
 
      ** Commit the database changes
 
     C                   COMMIT
 
      ** Set up the returned message format
 
     C                   MOVE      O1MSGT        O2MSGT
     C                   MOVE      O1TRUS        O2TRUS
     C                   MOVE      O1TRWS        O2TRWS
     C                   MOVE      O1TNRF        O2TNRF
     C                   MOVE      O1TRSN        O2TRSN
     C                   MOVE      O1ACTN        O2ACTN
     C                   MOVE      O1TRDS        O2TRDS
     C                   MOVE      O1TRTS        O2TRTS
     C                   MOVE      O1NRBA        O2NRBA
     C                   MOVE      O1LNRF        O2LNRF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) customer loan into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      CrLnFilFmtCL  ValidLoanL
     C                   MOVE      CrLnFilFmtCK  ValidLoanK
 
      * Do data substitution for Settlement Instructions
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      S_REC                                  99
     C  N99GHSUBS        scan      S_PAY                                  99
     C     *in99         ifeq      *on
     C                   endif
     C                   endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      *
      **  Set up date of receipt for amend.
      **  and date of payment
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     L_CLRLDT      ##DATR                         new RLDT
     C                   Z-ADD     L_CLRLDT      ##DATP                         new RLDT
     C                   ENDIF
      *
      ** Allow rec/pay settlement details for multi-ccy rollover
      *
     C     MULTIC        IFEQ      *ON
     C     DDNCCY        ANDNE     *BLANKS
     C     MULTIC        OREQ      *ON
     C     DDNCCYB       ANDNE     *BLANKS
     C                   MOVE      'Y'           WPSET             1
     C     DDACTN        IFEQ      'A'
     C     WRLDT1        ANDNE     '*'
     C     DDACTN        OREQ      'X'
     C     WRLDT1        ANDNE     '*'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     WRLDT1        ANDNE     '*'                                                        CLE030
     C                   Z-ADD     L_CLRLDT      ##DATP                         new RLDT
     C                   ENDIF
     C                   ENDIF
      *
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (F_Pay = *blank)
     C                             AND (F_Rec = *blank)
      *
      **  Get receipt settlement from CLOANCK if not blank
      **  Else, get details from CLOANCL
      **  If all details in first screen has been '*'ed
      **  settlement details would be blanked out.
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     WPSET         IFEQ      'Y'
     C     LPTYP         OREQ      63
     C     LPTYP         OREQ      65
      *
     C     KRRST         IFNE      *ZERO
      *
      * Set up Receive Instructions from CLOANCK
      *
     C                   MOVEL     CKREC         FLREC
     C                   MOVEL     CKRECEx       FLRONS                                       CGL029
     C                   MOVEL     KRRST         FLRSTM                                       CGL029
     C                   MOVEL     KRLBR         FLROBR
     C                   MOVEL     KRRSC         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRRSR         FLREXR                                       CLE031
     C                   MOVE      KRRSI         FLREXI                                       CLE031
     C                   MOVE      KRRSC         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Receive Instructions from CLOANCL
      *
     C                   MOVEL     CLREC         FLREC
     C                   MOVEL     CLRECEx       FLRONS                                       CGL029
     C                   MOVEL     LRSTM         FLRSTM                                       CGL029
     C                   MOVEL     LOMDB         FLROBR
     C                   MOVEL     LSCCY         FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLREXR                                       CLE031
     C                   MOVE      LREXI         FLREXI                                       CLE031
     C                   MOVE      LSCCY         FLRSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For multi-currency rollover, also allow for pay settle input
      ** Default coming from CLOANCK or CLOANCL
      *
     C     DDACTN        IFEQ      'A'
     C     WPSET         ANDEQ     'Y'
     C     DDACTN        OREQ      'A'
     C     LPTYP         ANDEQ     67
     C     DDACTN        OREQ      'X'
     C     WPSET         ANDEQ     'Y'
     C     DDACTN        OREQ      'X'
     C     LPTYP         ANDEQ     67
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     WPSET         ANDEQ     'Y'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     LPTYP         ANDEQ     67                                                         CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
     C     KRPST         IFNE      *ZERO
      *
      * Set up Pay Instructions from CLOANCK
      *
     C                   MOVEL     CKPAY         FLPAY
     C                   MOVEL     CKPAYEx       FLPONS                                       CGL029
     C                   MOVEL     KRPST         FLPSTM                                       CGL029
     C                   MOVEL     KRLSB         FLPOBR
     C                   MOVEL     KRCVM         FLCVMR
     C                   MOVEL     KRPSC         FLPSCY
     C                   MOVEL     KRICY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     KRPSR         FLPEXR                                       CLE031
     C                   MOVE      KRPSI         FLPEXI                                       CLE031
     C                   MOVE      KRPSC         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE
      *
      * Set up Pay Instructions from CLOANCL
      *
     C                   MOVEL     CLPAY         FLPAY
     C                   MOVEL     CLPAYEx       FLPONS                                       CGL029
     C                   MOVEL     LPSTM         FLPSTM                                       CGL029
     C                   MOVEL     LOMDB         FLPOBR
     C                   MOVEL     LCVMR         FLCVMR
     C                   MOVEL     LSCCY         FLPSCY
     C                   MOVEL     LICCY         FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     LREXR         FLPEXR                                       CLE031
     C                   MOVE      LREXI         FLPEXI                                       CLE031
     C                   MOVE      LSCCY         FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                     Pay/Rec = blanks
      *
      * Fill Our Pay branch and Our Receive branch if blank
      *
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLRSTM        IFEQ      05
     C     KRLBR         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ENDIF
     C                   ENDIF
      *
     C     LPTYP         IFEQ      67
     C                   MOVEL     LCCY          ##PCCY
     C                   MOVEL     LCCY          ##RCCY
     C     FLPSTM        IFEQ      05
     C     KRLSB         ANDEQ     *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ENDIF
     C                   ENDIF
      *
      **  If Rollover date is to be removed,
      **  or multi-currency details are to be removed
      **  settlement details must be removed also.
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'X'                                                        CLE030
     C                   Z-ADD     L_CLRLDT      ##DATR                         new RLDT
     C                   Z-ADD     L_CLRLDT      ##DATP                         new RLDT
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
      *
      * Remove Receive Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     63
     C     LPTYP         ANDNE     65
     C                   MOVE      *BLANKS       FLREC
     C                   MOVE      *BLANKS       FLRONS                                       CGL029
     C                   MOVE      *BLANKS       FLRSTM                                       CGL029
     C                   MOVEL     *BLANKS       FLROBR
     C                   MOVEL     *BLANKS       FLRSCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   MOVE      *BLANKS       FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
      *
      * Remove Pay Settlements Intructions
      *
     C     WRLDT1        IFEQ      '*'
     C     WNCCY1        OREQ      '*'
     C     LPTYP         ANDNE     67
     C                   MOVE      *BLANKS       FLPAY
     C                   MOVE      *BLANKS       FLPONS                                       CGL029
     C                   MOVE      *BLANKS       FLPSTM                                       CGL029
     C                   MOVEL     *BLANKS       FLPOBR
     C                   MOVEL     *BLANKS       FLCVMR
     C                   MOVEL     *BLANKS       FLPSCY
     C                   MOVEL     *BLANKS       FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   MOVE      *BLANKS       FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up other payment settlement details
      ** For parts sold, pay out in old ccy, receive in new ccy
      ** For the rest, receive in old ccy, pay out in new ccy
      *
     C     WPSET         IFEQ      'Y'
      *
     C     DDNCCYB       IFNE      *BLANKS
     C     WNCCY1        ANDNE     '*'
     C                   MOVE      DDNCCYB       WNCCY             3
     C                   ELSE
     C                   MOVE      DDNCCY        WNCCY
     C                   ENDIF
      *
     C     WSOLD         IFEQ      'Y'
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
      *
     C                   ELSE
     C     FLPSTM        IFEQ      05
     C     KRLSB         IFEQ      *BLANKS
     C                   MOVE      LOSDB         FLPOBR
     C                   ELSE
     C                   MOVE      KRLSB         FLPOBR
     C                   ENDIF
     C                   ENDIF
     C     FLRSTM        IFEQ      05
     C     KRLBR         IFEQ      *BLANKS
     C                   MOVE      LOMDB         FLROBR
     C                   ELSE
     C                   MOVE      KRLBR         FLROBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WNCCY         ##PCCY
     C                   MOVE      WNCCY         ##RCCY
      *
     C     CEU020        IFEQ      'Y'
     C     WNCCY         ANDNE     *BLANKS
     C     WNCCY         ANDEQ     BKEURO
     C                   MOVE      WNCCY         ##RCCY
     C                   MOVE      WNCCY         ##PCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up date of receipt and payment
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     L_CLRLDT      ##DATP                         new RLDT
     C     L_CLRLDT      IFEQ      *ZEROS                                       new RLDT
     C                   Z-ADD     LRLDT         ##DATP                         current RLDT
     C                   Z-ADD     LRLDT         ##DATR                         current RLDT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Defaults settlement details for multi-ccy rollover
      *
     C     FLPSTM        IFEQ      *ZERO
     C     FLRSTM        ANDEQ     *ZERO
     C     WPSET         ANDEQ     'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     DDACTN        ANDEQ     'A'
     C     FLPSTM        OREQ      *ZERO
     C     FLRSTM        ANDEQ     *ZERO
     C     WPSET         ANDEQ     'Y'
     C     DDNCCYB       ANDNE     *BLANKS
     C     WNCCY1        ANDNE     '*'
     C     DDACTN        ANDEQ     'X'
     C     FLPSTM        OREQ      *ZERO                                                      CLE030
     C     FLRSTM        ANDEQ     *ZERO                                                      CLE030
     C     WPSET         ANDEQ     'Y'                                                        CLE030
     C     DDNCCYB       ANDNE     *BLANKS                                                    CLE030
     C     WNCCY1        ANDNE     '*'                                                        CLE030
     C     DDACTN        ANDEQ     'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *
 
     C                   CALLB     'ZASETINDFT'
 
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Payment currency
     C                   PARM                    ##PCCY            3
      * Receive currency
     C                   PARM                    ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      * Transaction Type
     C                   PARM      LLTYP         ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    F_PAY
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    F_REC
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    F_FRI
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LELERICVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ***  Loan in file format CL
     C                   PARM                    CrLnFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    CrLnFilFmtCK
      *
      ***  Features
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI                                      BUG2579
     C                   PARM                    @FCXRATE                                    BUG2579
      *
      * OUTPUTS
      *
      * Loan in screen format
     C                   PARM                    LERI
      *
      * Rollover Work Fields
     C                   PARM                    NwRoScnFmt2
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      LERI          IncDATA        2000
      * Current Data
     C                   PARM      C_LERI        CurDATA        2000
 
     C                   MOVEL     IncDATA       LERI
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************
 
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_PAY         IncDATA
      * Current Data
     C                   PARM      C_PAY         CurDATA
 
     C                   MOVEL     IncDATA       S_PAY
 
      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      S_REC         IncDATA
      * Current Data
     C                   PARM      C_REC         CurDATA
 
     C                   MOVEL     IncDATA       S_REC
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
 
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Rollover Instructions support log
 
     C                   CALLB     'LELERILOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    LERI
     C                   PARM                    S_PAY
     C                   PARM                    S_REC
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'LELERI'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     K_CLFRNT      APFOTRANID
     C                   MOVEL     K_CLLNRF      PDealNo
     C                   MOVEL     *BLANKS       PADealNo
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
     C                   ENDIF
 
      ** If error occured,
 
     C                   IF        RetCodeOut <> *BLANKS
 
     C                   EVAL      @RTCD    = '*ERROR'
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Setup Last change type on valid file
 
     C                   EVAL      L_CLCHTP = 'A'
     C                   EVAL      K_CLCHTP = 'A'
 
      *
     C                   CALLB     'LELERIUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Action Code
     C                   PARM                    DDACTN
 
     C                   PARM                    ValidLoanL
     C                   PARM                    ValidLoanK
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM      'Y'           @@CTU             1
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   EVAL      ABFOTRNID  = DDFOTRANID
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = DDTMESTMP
 
      *  Do while error messages found
      *  Write error messages to file
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * @CHKLOAN - Check if Extended Settlements, Funding details and
      *            Mutli ccy Rollovers are required
      *****************************************************************
     C     @CHKLOAN      BEGSR
      *
     C                   MOVE      ' '           @FUNDING
     C                   MOVE      ' '           @MULTI                                       BUG827
     C                   MOVE      ' '           WSett                                        BUG827
     C                   MOVE      ' '           @FCXRATE                                    BUG2579
      *
      **  Enable display of Funding Details if Analytical Accounting
      **  module is switched on and loan is directly funded.
      **  or enable display of Funding Details if Revenue Analysis
      **  is switched on.
      *
     C     BGN0ST        IFEQ      'Y'
     C     LFPRC         ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
      *
     C     LPTYP         IFEQ      62
     C     LPTYP         OREQ      64
     C     LPTYP         OREQ      66
     C     LPTYP         OREQ      61
     C     LPTYP         OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     LPTYP         OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     LPTYP         OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      'Y'           @FUNDING
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      **  Enable Extended Settlement Details for Discount Loan.
      **  and discounted parts purchased or sold
      *
     C                   MOVE      *BLANKS       WDisc             1
     C     LPTYP         IFEQ      63
     C     LPTYP         OREQ      65
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WDisc
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WSOLD             1
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
      *
      **  Get facility details.
      *
     C     WFCLT         CHAIN     LEFCLTL0                           85
      *
      **  Enable New currency, New currency amount, Exchange rate,
      **  Exchange rate indicator, Next loan currency repayment
      **  amount will be displayed if Customer Lending Enhancement
      **  Syndications feature is switched on and if it is a
      **  Multi-currency rollover or if EMU Lending Multi currency
      **  rollover feauture is switched on and if loan currency is
      **  an 'In' currency
      *
     C     CEU020        IFEQ      'Y'
     C                   MOVE      LCCY          @CURR
     C                   Z-ADD     61            DBASE
     C                   EXSR      SRCurrDet
     C                   ENDIF
      *
     C     LMCRA         IFEQ      'Y'
     C     CEU020        IFEQ      'Y'
     C                   MOVE      A6INCY        WINCY             1
     C                   Z-ADD     A6TPSD        WTPSD             5 0
     C                   Z-ADD     A6SPRT        WASPRT           13 8
     C                   ENDIF
     C                   MOVE      'Y'           @MULTI
      *
      **  Determine if multi-currency rollover
      **  can be processed.
      **  If Multi Ccy Rollovers, enable the Settlements Screen
     C                   EXSR      SRMCCY
      *
     C     MULTIC        IFEQ      *ON
     C                   MOVEA     F_ALCY        ACCYA
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     KNCCY         ORNE      *BLANKS
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C     CEU020        IFEQ      'Y'
     C     KNCCY         ORNE      *BLANKS
     C                   MOVE      'Y'           WSett             1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              BUG827
      ** Determine if New Forward Yield is required                                           BUG827
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C     LPTYP         ANDNE     70                                                         BUG827
     C     LPTYP         ANDNE     71                                                         BUG827
     C     LPTYP         ANDNE     72                                                         BUG827
     C                   MOVE      'Y'           @FYIELD                                      BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           @FYIELD                                      BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG2579
      ** Determine if New Facility Exchange Rate is required                                 BUG2579
                                                                                             BUG2579
     C     CLE023        IFEQ      'Y'                                                       BUG2579
     C     F_MCCY        ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      'Y'           @FCXRATE                                    BUG2579
     C                   ELSE                                                                BUG2579
     C                   MOVE      'N'           @FCXRATE                                    BUG2579
     C                   ENDIF                                                               BUG2579
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMCCY  -  Check if Mutli-currency rollover is allowed.       *
      *****************************************************************
     C     SRMCCY        BEGSR
      *
     C                   MOVE      *OFF          MULTIC            1
     C                   MOVE      'N'           @WERLN
      *
      **  Multi-currency rollover processing are allowed
      **  if there are no past due payments outstanding.
      **  and no future-dated loan amendments (except for repay sched)
      *
      **  Access loan amendments file.
      *
     C**********         Z-ADD     LLNRF         ALNRF                                        CLE148
     C                   MOVEL     LLNRF         ALNRF                                        CLE148
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
      *
      **  Check if past due exists.
     C                   MOVE      *ON           WLOGIC            1
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     LLNRF         ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     LLNRF
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C     CLE014        ANDEQ     'N'
     C                   MOVE      *OFF          WLOGIC
      *
      ** If CEU020 is installed, future dated loan amendments will be
      ** allowed if amendment currency is equal to Euro ccy
      *
     C     CEU020        IFEQ      'Y'
     C     A_CCY         ANDEQ     BKEURO
     C                   MOVE      *ON           WLOGIC
     C                   ENDIF
      *
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
     C                   ENDIF
      *
      ** If parts sold, check if original loan has no past due
      ** payments or future dated loan amendments except for 'RE'.
      *
     C**********         Z-ADD     LLNRF         WWLNRF            6 0                        CLE148
     C                   MOVEL     LLNRF         WWLNRF            6                          CLE148
      *
     C     LPTYP         IFEQ      66
     C     LPTYP         OREQ      67
     C     LPTYP         OREQ      69
     C     LPTYP         OREQ      72
      *
     C                   MOVE      LOLNO         ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****LOLNO         ANDEQ     A_LNRF                                                     CSD027
     C     ALNRF         ANDEQ     A_LNRF                                                     CSD027
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C*****A_LNRF        ANDEQ     LOLNO                                                      CSD027
     C     A_LNRF        ANDEQ     ALNRF                                                      CSD027
     C     @WERLN        ANDEQ     'N'
      *
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
      *
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
     C                   MOVE      LOLNO         WOLNO
      *
      ** Multi-ccy rollover allowed indicator of original loan must
      ** be 'Y'.
      *
     C                   MOVE      'A'           WRCDT
     C                   MOVE      LOLNO         WLNRF
     C     WLOAN         CHAIN     CLOAN                              85
     C     *IN85         IFEQ      *OFF
     C     LO_MCRA       ANDEQ     'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      LO_LNRF       @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
      *
     C                   ELSE
     C**********         MOVE      LLNRF         WOLNO             6 0                        CLE148
     C                   MOVE      LLNRF         WOLNO             6                          CLE148
     C                   ENDIF
      *
      ** Check if all the related parts sold has no past due payments
      ** or future dated loan amendments except for 'RE'.
      *
     C*****WOLNO         SETLL     PSOLDFF                                                    CSD027
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C**********         EVAL      OLNONum = WOLNO                                     CSD027 CLE148
     C*****OLNOAlpha     SETLL     PSOLDFF                                             CSD027 CLE148
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         SETLL     PSOLDFF                                                    CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
      *
     C     *IN85         DOWEQ     '0'
     C     @WERLN        ANDEQ     'N'
      *
     C     P_LNRF        IFNE      WWLNRF
     C                   MOVE      P_LNRF        ALNRF
     C                   Z-ADD     *ZEROS        AVDAT
     C                   Z-ADD     *ZEROS        ALASN
     C     WLOAM         SETLL     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     P_LNRF        ANDEQ     A_LNRF
     C     A_AMTP        IFEQ      'PD'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN            1
     C***********        MOVE      A_LNRF        @WLNNO            6 0                        WA0027
     C                   MOVE      A_LNRF        @WLNNO            6                          WA0027
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
      ** Future dated loan amendments except repayment schedules must
      ** first be deleted before a multi-ccy rollover can be allowed
      *
     C     WLOGIC        IFEQ      *ON
     C                   Z-ADD     BJRDNB        AVDAT
     C     WLOAM         SETGT     LELOAML0
     C                   READ      LELOAML0                               85
      *
     C     *IN85         DOWEQ     '0'
     C     A_LNRF        ANDEQ     P_LNRF
     C     @WERLN        ANDEQ     'N'
     C     A_VDAT        IFGT      BJRDNB
     C     A_AMTP        ANDNE     'RE'
     C                   MOVE      *OFF          WLOGIC
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      A_LNRF        @WLNNO
     C                   LEAVE
     C                   ENDIF
     C                   READ      LELOAML0                               85
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multi-ccy rollover allowed indicator must be 'Y' for all of
      ** the related loan
      *
     C     P_MCRA        IFEQ      'N'
     C                   MOVE      'Y'           @WERLN
     C                   MOVE      P_LNRF        @WLNNO
     C                   MOVE      *OFF          WLOGIC
     C                   ENDIF
     C*****WOLNO         READE     PSOLDFF                                85                  CSD027
     C*****OLNOAlpha     READE     PSOLDFF                                85           CSD027 CLE148
     C     WOLNO         READE     PSOLDFF                                85                  CLE148
     C                   ENDDO
      *
     C                   MOVE      WLOGIC        MULTIC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRVFD2 -  Define Removeable fields                           *
      *                                                               *
      *****************************************************************
     C     SRRVFD2       BEGSR
      *
      **  Rollover date
     C                   MOVEL     DDRLDTB       WRLDT2            1
      *
      **  Rollover frequency and day number
     C                   MOVEL     DDRLFQB       WRLFQ2            1
     C                   MOVEL     DDRLDYB       WRLDY2            1
      *
      **  New base rate
     C                   MOVEL     DDNBRAB       WNBRA2            1
      *
      **  New spread/rate and spread indicator
     C                   MOVEL     DDNRTSB       WNRTS2            1
     C                   MOVEL     DDNSINB       WNSIN2            1
      *
      **  New interest calculation basis
     C                   MOVEL     DDNCASB       WNCAS2            1
      *
      **  New change indicator
     C                   MOVEL     DDNCHIB       WNCHI2            1
      *
      **  Next rollover date
     C                   MOVEL     DDNRODB       WNROD2            1
      *
      **  Principal
     C                   MOVEL     DDNPRAB       WNPRA2            1
      *
      **  New discount amount
     C                   MOVEL     DDNDAMB       WNDAM2            1
      *
      **  New interest and maturity date - for S01465
     C                   MOVEL     DDNIPDB       WNIPD2            1
     C                   MOVEL     DDNMDTB       WNMDT2            1
      *
      **  New currency
     C                   MOVEL     DDNCCYB       WNCCY2            1
      *
      **  New currency amount
     C                   MOVEL     DDNCPAB       WNCPA2            1
      *
      **  Exchange rate
     C                   MOVEL     DDNFCEB       WNFCE2            1
      *
      **  Exchange rate indicator
     C                   MOVEL     DDNFMDB       WNFMD2            1
      *
      **  Base ccy exchange rate
     C                   MOVEL     DDNBCEB       WNBCE2            1
      *
      **  Base ccy exchange rate indicator
     C                   MOVEL     DDNBMDB       WNBMD2            1
      *
      **  Next loan currency repayment amount.
     C                   MOVEL     DDNLRAB       WNLRA2            1
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
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Check if Customer Lending Enhancements - Authorisation
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE002            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE002
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Backvaluations
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if Customer Lending Enhancements - Others
      *  feature is installed
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
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
 
      *
      ** Determine if Lending Enhancements for BHF-London is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      PSARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014            1
     C                   ELSE
     C                   MOVE      'N'           CLE014
     C     @RTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     906           DBASE                          * DBERR 906*
     C                   MOVEL     'CLE014'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Access SAR details file to determine if CDE002 is switched on
 
     C                   CallB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CDE002'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE002            1
     C                   ELSE
     C                   MOVE      'N'           CDE002
     C     @RTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     907           DBASE                          * DBERR 907*
     C                   MOVEL     'CDE002'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011            1
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   MOVE      'N'           CSC011
     C     @RTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     908           DBASE                          * DBERR 908*
     C                   MOVEL     'CDE002'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if BLI Lending Enhancements feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01465'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01465            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           S01465
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 909*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
 
      *
      ** Check if Rollover rate fixing day enhancement - CLE011
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE011'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE011            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CLE011
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '910'         DBASE                          * DBERR 910*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                             BUG2579
      ** Check if Lending Facility History Improvements - CLE023                             BUG2579
      ** feature is installed                                                                BUG2579
                                                                                             BUG2579
     C                   CALLB     'AOSARDR0'                                                BUG2579
     C                   PARM      *BLANKS       @RTCD                                       BUG2579
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2579
     C                   PARM      'CLE023'      @SARD                                       BUG2579
     C                   PARM                    DSFDY                                       BUG2579
     C     @RTCD         IFEQ      *BLANK                                                    BUG2579
     C                   MOVE      'Y'           CLE023            1                         BUG2579
     C                   ELSE                                                                BUG2579
     C     @RTCD         IFEQ      '*NRF'                                                    BUG2579
     C                   MOVE      'N'           CLE023                                      BUG2579
     C                   ELSE                                                                BUG2579
      *                                                                                      BUG2579
      * DATABASE ERROR                                                                       BUG2579
      *                                                                                      BUG2579
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************ BUG2579
     C                   MOVEL     '914'         DBASE                          * DBERR 914* BUG2579
     C                   MOVEL     @OPTN         DBKEY                          ************ BUG2579
     C                   EXSR      *PSSR                                                     BUG2579
     C                   END                                                                 BUG2579
     C                   END                                                                 BUG2579
 
      *
      ** Check if EMU Lending Multi Currency Rollover - CEU020
      *  feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU020'      @SARD             6
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU020            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU020
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '911'         DBASE                          * DBERR 911*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
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
     C                   MOVEL     '912'         DBASE                          * DBERR 912 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD             7                          BUG827
     C                   PARM      '*VERIFY '    @OPTN             7                          BUG827
     C                   PARM      'CAS001'      @SARD             6                          BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
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
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
      **  Key list for LEFCLTL0
      *
     C     WFCLT         KLIST
     C                   KFLD                    LFCUS
     C                   KFLD                    LFTYP
     C                   KFLD                    LFSEQ
      *
      **  Key list for LELOAML0
      *
     C     WLOAM         KLIST
     C**********         KFLD                    ALNRF             6 0                        CLE148
     C                   KFLD                    ALNRF             6                          CLE148
     C                   KFLD                    AVDAT             5 0
     C                   KFLD                    ALASN             3 0
      *
      **  Key list for CLOAN
      *
     C     WLOAN         KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
     C                   KFLD                    WRCDT             1
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
     C                   MOVE      'D'           O2MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
