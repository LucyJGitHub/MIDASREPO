     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of Loans/Deposits')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTLDNI - Extract for Money Market Loans,                   *
      *             Deposits and NA's Issued                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG2937             Date 23May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 TDA102             Date 28Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Churh Tax (Recompile)             *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3860 - (recompile)                                        *
      *  BG2937 - Internal deals & loans have bad asset/liability ind.*
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
      **  Deal types
     D*TABCDE**********S              2    DIM(15) CTDATA PERRCD(1)                           BG2937
     D*TABTYP**********S              1    DIM(15) ALT(TABCDE)                                BG2937
     D TABCDE          S              2    DIM(17) CTDATA PERRCD(1)                           BG2937
     D TABTYP          S              1    DIM(17) ALT(TABCDE)                                BG2937
 
 
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D DEALDC        E DS                  EXTNAME(DEALSDC)
 
 
     D W#PAYD          DS
     D  W#PAYM                 1      2
     D  W#PAYA                 3     20                                                       TDA102
     D  W#PAYB                21     23                                                       TDA102
     D  W#PSCY                24     26                                                       TDA102
     D**W#PAYA**************** 3     14                                                       TDA102
     D**W#PAYB****************15     17                                                       TDA102
     D**W#PSCY****************18     20                                                       TDA102
     D W#RECD          DS
     D  W#RECM                 1      2
     D  W#RECA                 3     20                                                       TDA102
     D  W#RECB                21     23                                                       TDA102
     D  W#RSCY                24     26                                                       TDA102
     D**W#RECA**************** 3     14                                                       TDA102
     D**W#RECB****************15     17                                                       TDA102
     D**W#RSCY****************18     20                                                       TDA102
     D W#INTS          DS
     D  W#INTM                 1      2
     D  W#INTA                 3     20                                                       TDA102
     D  W#INTB                21     23                                                       TDA102
     D  W#ISCY                24     26                                                       TDA102
     D**W#INTA**************** 3     14                                                       TDA102
     D**W#INTB****************15     17                                                       TDA102
     D**W#ISCY****************18     20                                                       TDA102
     D W#TABT          DS
     D  W#ASLI                 1      1
 
 
      ** DEFINE FIELDS FOR ZDATE10
     D                 DS
     D ZWDTIN                  1      8S 0
     D  ZWYYYY                 1      4S 0
     D  ZWMTH                  5      6S 0
     D  ZWDAY                  7      8S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    I#DNWD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    I#TVDI            1
     C                   PARM                    MMDELD
     C                   PARM                    DEALDC
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * NO VALUE DATE POSITION EXTRACT IS REQUIRED IF MATURED
 
     C     I#TVDI        IFEQ      'V'
     C     T_MATI        ANDEQ     'Y'
     C                   RETURN
     C                   ENDIF
 
      * SETUP SETTLEMENT INSTRUCTIONS
 
     C                   EXSR      SETUP_SETI
 
      * IMPORT OPENING POSITION AND EVENTS
 
     C                   EXSR      IMPORT
 
      * PROCESS IMPORTED EVENTS
 
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   EXSR      WRKEDTA
 
      * WRITE TRANSACTION INDEX RECORD
      * Commitment Cycle ID
     C     I#TVDI        IFEQ      'T'
     C                   Z-ADD     I#CCID        T_CCID
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
     C                   CALLB     'GOSETLDNI'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDELD
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETLDNI'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETUP SETTLEMENT INSTRUCTIONS
      *****************************************************************
     C     SETUP_SETI    BEGSR
 
      **  Pay and receive settlement methods, accounts & branches
 
     C                   MOVEL     HKMOPM        W#PAYM                         * pay method
     C                   MOVEL     HKMOPI        W#PAYA                         * pay account
     C                   MOVEL     HKPOBR        W#PAYB                         * pay branch
     C                   MOVEL     HKSTCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     HKORCM        W#RECM                         * rec method
     C                   MOVEL     HKMORI        W#RECA                         * rec account
     C                   MOVEL     HKROBR        W#RECB                         * rec branch
     C                   MOVEL     HKSTCY        W#RSCY                         * rec settle ccy
 
      * If interest is paid separately set up interest instructions
 
     C     HKIPDS        IFEQ      'Y'
     C                   MOVE      HKIMET        W#INTM                         * settle method
     C                   MOVEL     HKINSA        W#INTA                         * settle A/C
     C                   MOVE      HKINSA        W#INTB                         * settle branch
     C                   MOVEL     HKISCY        W#ISCY                         * settle currency
      *
     C                   ELSE
 
      * If interest is not paid separately use maturity details
 
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        W#INTS
     C                   ELSE
     C                   MOVEL     W#PAYD        W#INTS
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      * IMPORT OPENING BALANCE
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT PERIOD END DATES
      *
     C                   EXSR      IMP_PE
      *
      * IMPORT DEAL DATE EVENT
      *
     C                   EXSR      IMP_DD
      *
      * IMPORT DEAL AMENDMENT EVENTS
      *
     C                   EXSR      IMP_DEAM
      *
      * END IF TRADE DATE
      *
     C     I#TVDI        CABEQ     'T'           E_IMPORT
      *
      * IMPORT VALUE DATE EVENT
      *
     C                   EXSR      IMP_VD
      *
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *
     C     AIAN          IFNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C                   EXSR      IMP_IP
      *
      * If date present (ie not a call/notice deal)
      * IMPORT MATURITY DATE EVENT
      *
     C     MaturityDate  IFNE      *ZERO
     C                   EXSR      IMP_MT
     C                   ENDIF
      *
     C     E_IMPORT      ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING BALANCE
      *****************************************************************
     C     IMP_OPBL      BEGSR
      *
      * Clear Position
      *
     C                   CLEAR                   P_POSN
      *
      * Position Date
     C                   Z-ADD     HKIAYY        ZWYYYY
     C                   Z-ADD     HKIAMM        ZWMTH
     C                   Z-ADD     HKIADD        ZWDAY
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        P_PDAT
      *
      * Asset/Liability
     C     HKMTYP        LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#ASLI        P_ASLI
      *
      * Accrued Int To Date
     C                   Z-ADD     AITC          P_AITC
      *
      * Int Paid To Date
     C                   Z-ADD     IPRD          P_IPRD
      *
      * Int Capitalised To Date
     C                   Z-ADD     ICTD          P_ICTD
      *
      * Accrued Int Adjustments
     C                   Z-ADD     AIAP          P_AIAD
      *
      * Total Int
     C     HKFUID        IFEQ      'Y'
     C                   Z-ADD     TOTI          P_TOTI
     C                   ENDIF
      *
      * Nominal/Principal
     C                   Z-ADD     HKAMNP        P_NOML                 99
     C   99              Z-SUB     HKAMNP        P_NOML
      *
      * Currency
     C                   MOVEL     HKCCY         P_CCY
     C                   MOVEL     HKCCY         @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * Base Rate Code
     C                   MOVEL     HKBSRC        P_BRTT
      *
      * Base Rate
      * Rate/Spread
      *
     C     P_BRTT        IFNE      *ZERO
     C     HKINTR        SUB       HKSPRD        P_BRTE
     C                   Z-ADD     HKSPRD        P_RTSP
     C                   ELSE
     C                   Z-ADD     *ZERO         P_BRTE
     C                   Z-ADD     HKINTR        P_RTSP
     C                   ENDIF
      *
      * Spread Ind
     C                   MOVEL     'A'           P_SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     HKINTR        P_IRAT
      *
      * Int Pay Method
     C     HKFUID        IFEQ      'Y'
     C                   MOVEL     'D'           P_INPM
     C                   ENDIF
      *
      * Int Capitalisation
     C                   MOVEL     HKCPTI        P_INTC
      *
      * Int Calc Method
     C                   MOVEL     HKICMT        W#ICBS            1 0
     C                   CALLB     'GOCVTICDL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    W#ICBS            1 0
     C                   PARM      *BLANK        W#ICMT            7
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P_ICMT
      *
      * Round Down
     C                   MOVEL     HKRDFC        P_RDFC
      *
      * Accrue interest
     C                   MOVE      'Y'           P_ACIN
      *
      * Amortise interest
     C                   MOVE      'N'           P_AMIN
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT DEAL DATE EVENT
      *****************************************************************
     C     IMP_DD        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     DealDate      E_PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E_EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
      *
      * Import deal date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT VALUE DATE EVENT
      *****************************************************************
     C     IMP_VD        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     ValueDate     E_PRDT
      *
      * Event Type
     C                   MOVEL     'VD'          E_EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#PAYD        E_SETD
     C                   ELSE
     C                   MOVEL     W#RECD        E_SETD
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
      *
      * Import value date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *****************************************************************
     C     IMP_MI        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     I#RDNB        E_PRDT
      *
      * Event Type
     C                   MOVEL     'MI'          E_EVTP
      *
      * Interest
     C                   Z-ADD     AIAN          E_INTA
      *
      * Import manual adjustment to accrued interest event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_IP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
      * If Front-Up interest = 'Y', value date is an interest pay date
      *
     C     HKFUID        IFEQ      'Y'
     C                   Z-ADD     ValueDate     E_PRDT
      *
      * Interest Amount
     C                   Z-ADD     TOTI          E_INTA
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
     C                   ELSE
      *
     C                   Z-ADD     HKNIYY        ZWYYYY
     C                   Z-ADD     HKNIMM        ZWMTH
     C                   Z-ADD     HKNIDD        ZWDAY
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E_PRDT
      *
      ** If no date present use maturity date (which may be zero if call)
      *
     C     E_PRDT        IFEQ      *ZERO
     C                   Z-ADD     MaturityDate  E_PRDT
     C                   END
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C                   MOVEL     HKCPTI        E_INTC
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      ** If no next interest payment date present
      ** exit this routine
      *
     C     E_PRDT        IFEQ      *ZERO
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If Front-Up interest = 'Y'
      ** or if no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     HKFUID        IFEQ      'Y'
     C     HKIPFQ        OREQ      *BLANK
     C     E_PRDT        OREQ      MaturityDate
     C     *ZERO         OREQ      MaturityDate
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E_PRDT        ZFRDAT
     C                   MOVEL     HKIPFQ        ZFRFRQ
     C                   Z-ADD     HKIPDM        ZFRBAS
     C                   MOVEL     E_SETM        ZFRSET
     C     E_SETC        IFNE      *BLANK
     C                   MOVEL     E_SETC        ZFRCCY
     C                   ELSE
     C                   MOVEL     HKCCY         ZFRCCY
     C                   ENDIF
     C                   MOVEL     E_SETA        ZFRNOS
     C                   Z-ADD     MaturityDate  ZFRMDT
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     E_PRDT        DOWLT     MaturityDate
     C     W#RTCD        ANDNE     '*FULL'
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      ** Import last interest payment date event (at maturity date)
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C     EIMP_IP       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MATURITY DATE EVENT
      *****************************************************************
     C     IMP_MT        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     MaturityDate  E_PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E_EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E_SETD
     C                   ELSE
     C                   MOVEL     W#PAYD        E_SETD
     C                   END
      *
      ** Import maturity date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT DEAL AMENDMENT EVENTS
      *****************************************************************
     C     IMP_DEAM      BEGSR
      *
     C     HKDN38        SETLL     MMDEAMP0
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HKDN38        READE     MMDEAMP0                               99    *
     C                   ENDDO
      *
      * Whilst live deal amendments can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     HNVDYY        ZWYYYY
     C                   Z-ADD     HNVDMM        ZWMTH
     C                   Z-ADD     HNVDDD        ZWDAY
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E_PRDT
      *
     C                   Z-ADD     HNAMNP        HNAMNP                 99      *
     C   99              Z-SUB     HNAMNP        HNAMNP
      *
      * If the deal amendment is a spread change
      *
     C     HNMTYP        IFEQ      'SC'
     C                   MOVEL     'SC'          E_EVTP
      * interest rate
     C                   Z-ADD     HNINTR        E_RTSP
     C                   MOVE      HNIRCF        E_IRCH
     C                   END
      *
      * Principal increase
      *
     C     HNMTYP        IFEQ      'PI'
     C                   MOVEL     'PI'          E_EVTP
     C                   Z-ADD     HNAMNP        E_PRAM
     C                   END
      *
      * Principal decrease
      *
     C     HNMTYP        IFEQ      'PD'
     C                   MOVEL     'PD'          E_EVTP
     C                   Z-ADD     HNAMNP        E_PRAM
     C                   END
      *
      * If the deal amendment is settle interest
      *
     C     HNMTYP        IFEQ      'SI'
     C                   MOVEL     'IP'          E_EVTP
     C                   END
      *
      * If the deal amendment is capitalise interest
      * Set Int Capitalisation Ind
      *
     C     HNMTYP        IFEQ      'CI'
     C                   MOVEL     'IP'          E_EVTP
     C                   MOVEL     'Y'           E_INTC
     C                   END
      *
      **  Pay and receive settlement methods, accounts & branches
      *
     C     W#ASLI        IFEQ      'A'
     C     HNMTYP        ANDEQ     'PI'
     C     W#ASLI        OREQ      'L'
     C     HNMTYP        ANDEQ     'PD'
     C     W#ASLI        OREQ      'L'
     C     HNMTYP        ANDEQ     'SI'
     C                   MOVEL     HNMOPM        E_SETM
     C                   MOVEL     HNMOPI        E_SETA
     C                   MOVEL     HNOSBR        E_SETB
     C                   MOVEL     HNSTCY        E_SETC
     C                   ELSE
     C                   MOVEL     HNORCM        E_SETM
     C                   MOVEL     HNMORI        E_SETA
     C                   MOVEL     HNOSBR        E_SETB
     C                   MOVEL     HNSTCY        E_SETC
     C                   ENDIF
      *
      ** Trade date extract only uses principal increases, dated run date
      *
     C     I#TVDI        IFEQ      'T'
     C     E_EVTP        IFEQ      'PI'
     C                   Z-ADD     I#RDNB        E_PRDT
     C                   ELSE
     C                   MOVE      *BLANK        E_EVTP
     C                   ENDIF
     C                   ENDIF
      *
      * Import deal amendment event
      *
     C     E_EVTP        IFNE      *BLANK
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HKDN38        READE     MMDEAMP0                               99    *
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE NEXT DAY
      ********************************************************************
     C     DETNXD        BEGSR
      *
     C                   CALL      'DLZFRQ'
     C                   PARM      *BLANK        ZFRRTC            5
     C                   PARM                    ZFRDAT            5 0
     C                   PARM                    ZFRFRQ            1
     C                   PARM                    ZFRBAS            2 0
     C                   PARM                    ZFRSET            2 0
     C                   PARM                    ZFRCCY            3
     C                   PARM      *BLANK        ZSTCY             3
     C                   PARM      'P'           ZRCIP             1
     C                   PARM                    ZFRNOS            2
     C                   PARM                    ZFRMDT            5 0
     C                   PARM                    BKAPDT            5 0
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM      *ZERO         ZFRZBD            5 0
     C                   PARM      *ZERO         ZFRNXD            5 0
      *
     C     ZFRRTC        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DLZFRQ'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN            8 0
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *********************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY GOCPYSRC,GOXTIMPPE
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      /COPY GOCPYSRC,GOXTWRKEDA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
      /SPACE 5
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** TABCDE/TABTYP. DEAL TYPES
IPA
TIA
CLA
LNA
DLA
FLA
LPA
DPA
ILA                                                                                           BG2937
ITL
TDL
CDL
CIL
FTL
DTL
LTL
IDL                                                                                           BG2937
