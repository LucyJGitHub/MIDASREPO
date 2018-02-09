     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of Customer Loans')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTLOAN - Extract for Customer Lending Loans                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD037863           Date 27Jul16               *
      *                 MD022920           Date 19Nov13               *
      *                 AR1081071          Date 13Jan15               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 BUG28040A          Date 26Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA102             Date 28Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037863 - Generate maturity repayment event only when       *
      *             repayment date falls on maturity date.            *
      *  MD022920 - Principal Repayment was decreased on exposure but *
      *             the loan is non auto settle. Ensure that RE event *
      *             will not be posted in GPPOSNPD when AUTO is N.    *
      *  AR1081071 - Task split GOCXCLTS failed                       *
      *              When auto settled loan is C use rundate or       *
      *              next working date as processing date for         *
      *              maturity date event                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG28040A - Missing GPPOSNPD record for live loans past its  *
      *              maturity date.                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompile)                   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3860 - (recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
      **  Loan types
     D TABCDE          S              2  0 DIM(12) CTDATA PERRCD(1)
     D TABTYP          S              2    DIM(12) ALT(TABCDE)
 
 
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)
     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)
 
 
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
     D  W#TYP                  1      1
     D  W#ASLI                 2      2
 
 
      * Power array
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     ILOAMSDKF
     I              RECI                        LARECI
     I              VDAT                        LAVDAT
     I              PTYP                        LAPTYP
     I              AMTP                        LAAMTP
     I              PRSQ                        LAPRSQ
     I              BRTT                        LABRTT
     I              RTSP                        LARTSP
     I              CCY                         LACCY
     I              PRAM                        LAPRAM
     I              INTA                        LAINTA
     I              TAMT                        LATAMT
     I              SETP                        LASETP
     I              OSAC                        LAOSAC
     I              OSBR                        LAOSBR
     I              SCCY                        LASCCY
     I              FSRP                        LAFSRP
     I              IRCF                        LAIRCF
     I              FRCF                        LAFRCF
     I              AUTO                        LAAUTO                                      MD022920
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    I#TVDI            1
     C                   PARM                    LOANCL
     C                   PARM                    LOANCK
     C**********         PARM                    SL_CNUM           6 0                        CSD027
     C                   PARM                    SL_CNUM           6                          CSD027
     C**********         PARM                    SL_MLNR           6 0                        CLE148
     C                   PARM                    SL_MLNR           6                          CLE148
     C**********         PARM                    SL_OLNO           6 0                        CSD027
     C                   PARM                    SL_OLNO           6                          CSD027
 
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
     C                   CALLB     'GOSETLOAN'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    LOANCL
     C                   PARM                    SL_CNUM
     C                   PARM                    SL_MLNR
     C                   PARM                    SL_OLNO
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETLOAN'
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
 
     C                   MOVEL     'N'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETUP SETTLEMENT INSTRUCTIONS
      *****************************************************************
     C     SETUP_SETI    BEGSR
 
      * Asset/Liability
     C     CL_PTYP       LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
      *
      **  Pay and receive settlement methods, accounts & branches
      *
     C     W#ASLI        IFEQ      'A'
      *
     C                   MOVEL     CL_SDST       W#PAYM                           * pay method
     C                   MOVEL     CL_OSDA       W#PAYA                           * pay account
     C                   MOVEL     CL_OSDB       W#PAYB                           * pay branch
     C                   MOVEL     CL_SCCY       W#PSCY                           * pay settle ccy
      *
     C                   MOVEL     CL_MDST       W#RECM                           * rec method
     C                   MOVEL     CL_OMDA       W#RECA                           * rec account
     C                   MOVEL     CL_OMDB       W#RECB                           * rec branch
     C                   MOVEL     CL_SCCY       W#RSCY                           * rec settle ccy
      *
     C                   ENDIF
      *
     C     W#ASLI        IFEQ      'L'
      *
     C                   MOVEL     CL_SDST       W#RECM                           * rec method
     C                   MOVEL     CL_OSDA       W#RECA                           * rec account
     C                   MOVEL     CL_OSDB       W#RECB                           * rec branch
     C                   MOVEL     CL_SCCY       W#RSCY                           * rec settle ccy
      *
     C                   MOVEL     CL_MDST       W#PAYM                           * pay method
     C                   MOVEL     CL_OMDA       W#PAYA                           * pay account
     C                   MOVEL     CL_OMDB       W#PAYB                           * pay branch
     C                   MOVEL     CL_SCCY       W#PSCY                           * pay settle ccy
      *
     C                   ENDIF
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
      * IMPORT LOAN AMENDMENT EVENTS
      *
     C                   EXSR      IMP_LOAM
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
     C     CL_AIMN       IFNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C                   EXSR      IMP_IP
      *
      * IMPORT REPAYMENT DATE EVENTS
      *
     C     CL_NRPD       IFNE      *ZERO
     C     CL_AUTO       ANDNE     'N'                                                      MD022920
     C                   EXSR      IMP_RE
     C                   ENDIF
      *
      * IMPORT NEXT ROLLOVER DATE EVENT
      *
     C     CL_RLDT       IFNE      *ZERO
     C                   EXSR      IMP_RO
     C                   ENDIF
      *
      * If date present (ie not a call/notice loan)
      * IMPORT MATURITY DATE EVENT
      *
     C     CL_MDAT       IFNE      *ZERO
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
      * CLEAR POSITION
      *
     C                   CLEAR                   P_POSN
      *
      * Position Date
     C                   Z-ADD     CL_IACD       P_PDAT
      *
      * Asset/Liability
     C                   MOVEL     W#ASLI        P_ASLI
      *
      * Accrued Int To Date
     C                   Z-ADD     CL_AITC       P_AITC
      *
      * Int Paid To Date
     C                   Z-ADD     CL_IPRD       P_IPRD
      *
      * Int Capitalised To Date
     C                   Z-ADD     CL_ICTD       P_ICTD
      *
      * Int Written Off To Date
     C                   Z-ADD     CL_IWOD       P_IWOD
      *
      * Accrued Int Adjustments
     C                   Z-ADD     CL_AIAP       P_AIAD
      *
      * Total Int
     C     W#TYP         IFEQ      'D'
     C                   Z-ADD     CL_TOTI       P_TOTI
     C                   ENDIF
      *
      * Nominal/Principal
     C                   Z-ADD     CL_CPAM       P_NOML
      *
      * Currency
     C                   MOVEL     CL_CCY        P_CCY
     C                   MOVEL     CL_CCY        @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * Base Rate Code
     C                   MOVEL     CL_BRTT       P_BRTT
      *
      * Base Rate
     C                   Z-ADD     CL_BRTE       P_BRTE
      *
      * Rate/Spread
     C                   Z-ADD     CL_RTSP       P_RTSP
      *
      * Spread Ind
     C                   MOVEL     CL_SPIN       P_SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     CL_INTR       P_IRAT
      *
      * Change Ind
     C                   MOVEL     CL_CHIN       P_CHIN
      *
      * Int Pay Method
     C     W#TYP         IFEQ      'D'
     C                   MOVEL     'D'           P_INPM
     C                   ENDIF
      *
      * Int Capitalisation
     C                   MOVEL     CL_INTC       P_INTC
      *
      * Int Calc Method
     C                   CALLB     'GOCVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      CL_ICBS       W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P_ICMT
      *
      * Accrue interest
     C                   MOVE      'Y'           P_ACIN
      *
      * Round Down
     C                   MOVEL     CL_RDFC       P_RDFC
      *
      * Repayment Type
     C                   Z-ADD     CL_REPT       P_REPT
      *
      * Stop Accruals
     C                   TESTB     '3'           CL_LONI                  99
     C   99              MOVEL     'Y'           P_STAC
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
     C                   Z-ADD     CL_DDAT       E_PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E_EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           CL_ACEI                  99      *
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
     C                   Z-ADD     CL_VDAT       E_PRDT
      *
      * Event Type
     C                   MOVEL     'VD'          E_EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
     C                   ELSE
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '1'           CL_ACEI                  99      *
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
     C                   Z-ADD     CL_AIMN       E_INTA
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
      * If discounted loan, value date is an interest pay date
      *
     C     W#TYP         IFEQ      'D'
     C                   Z-ADD     CL_VDAT       E_PRDT
      *
      * Interest Amount
     C                   Z-ADD     CL_TOTI       E_INTA
      *
      * Processed?
      *
     C                   TESTB     '1'           CL_ACEI                  99      *
     C   99              MOVE      'Y'           E_PRCD
     C                   ELSE
     C                   Z-ADD     CL_NIDT       E_PRDT
      *
      ** If no date present use maturity date (which may be zero if call)
      *
     C     E_PRDT        IFEQ      *ZERO
     C                   Z-ADD     CL_MDAT       E_PRDT
     C                   END
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C                   MOVEL     CL_INTC       E_INTC
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
     C                   END
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
      ** If interest is discounted
      *
     C     W#TYP         IFEQ      'D'
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** If no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_IPFR       IFEQ      *BLANK
     C     E_PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E_PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_IPFR       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_IFDY       ZFRBAS                           *BASE DAY
     C                   MOVEL     E_SETM        ZFRSET                         *SETT.METH
     C     E_SETC        IFNE      *BLANK
     C                   MOVEL     E_SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E_SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     E_PRDT        DOWLT     CL_MDAT
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
      * IMPORT REPAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_RE        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     CL_NRPD       E_PRDT
      *
      * Principal Amount
     C                   Z-ADD     CL_RAMT       E_PRAM
      *
      * Total Amount
     C                   Z-ADD     CL_RAMT       E_TAMT
      *
      * Event Type
     C                   MOVEL     'RE'          E_EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
     C                   END
      *
      ** Import next repayment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no repayment frequency is present
      ** or if next repayment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_RFRQ       IFEQ      *BLANK
     C     E_PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_RE
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E_PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_RFRQ       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_RDYN       ZFRBAS                           *BASE DAY
     C                   MOVEL     E_SETM        ZFRSET                         *SETT.METH
     C     E_SETC        IFNE      *BLANK
     C                   MOVEL     E_SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E_SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next repayment date
      *
     C**********         EXSR      DETNXD                                                   MD037863
     C                   EXSR      DETNXD2                                                  MD037863
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all repayments prior to maturity date
      *
     C     E_PRDT        DOWLT     CL_MDAT
     C     W#RTCD        ANDNE     '*FULL'
      *
      ** Import next repayment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next repayment date
      *
     C**********         EXSR      DETNXD                                                   MD037863
     C                   EXSR      DETNXD2                                                  MD037863
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      ** Import last repayment date event (at maturity date)
      *
     C     E_PRDT        IFEQ      CL_MDAT                                                  MD037863
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF                                                              MD037863
      *
     C     EIMP_RE       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT ROLLOVER DATE EVENTS
      *****************************************************************
     C     IMP_RO        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     CL_RLDT       E_PRDT
      *
      * Event Type
     C                   MOVEL     'RO'          E_EVTP
      *
      * (New) Base Rate Code
     C                   Z-ADD     CL_NBRA       E_BRTT
      *
      * (New) Rate/Spread
     C                   Z-ADD     CL_NRTS       E_RTSP
      *
      * (New) Spread Ind
     C                   MOVEL     CL_NSIN       E_SPIN
      *
      * Interest Rate Change
     C     CL_NCAS       IFNE      0
     C                   MOVE      'Y'           E_IRCH
     C                   END
      *
      * (New) Int Calculation Method
     C     CL_NCAS       IFNE      0
     C                   CALLB     'GOCVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM      CL_NCAS       W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        E_ICMT
     C                   ENDIF
      *
      * New Nominal
     C                   Z-ADD     CK_NCPA       E_NOML
      *
      * New Currency
     C                   MOVEL     CK_NCCY       E_CCY
      *
      * New Ccy Dec Places
     C     CK_NCCY       IFNE      *BLANK
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        E_NCDP
     C                   ENDIF
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
     C                   END
      *
      ** Import next rollover date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no rollover frequency is present
      ** or if next rollover date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_RLFQ       IFEQ      *BLANK
     C     E_PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_RO
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E_PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_RLFQ       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_RLDY       ZFRBAS                           *BASE DAY
     C                   MOVEL     E_SETM        ZFRSET                         *SETT.METH
     C     E_SETC        IFNE      *BLANK
     C                   MOVEL     E_SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E_SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next rollover date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all rollovers prior to maturity date
      *
     C     E_PRDT        DOWLT     CL_MDAT
     C     W#RTCD        ANDNE     '*FULL'
      *
      ** Import next rollover date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next rollover date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E_PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
     C     EIMP_RO       ENDSR
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
     C     CL_RECI       IFEQ      'D'                                                     BUG28040A
     C     CL_AUTO       ANDEQ     'N'                                                     BUG28040A
     C     CL_MDAT       ANDLT     BJRDNB                                                  BUG28040A
     C     I#LOC         ANDEQ     'GLOB'                                                  BUG28040A
     C     CL_RECI       OREQ      'D'                                                     AR1081071
     C     CL_AUTO       ANDEQ     'C'                                                     AR1081071
     C     CL_MDAT       ANDLT     BJRDNB                                                  AR1081071
     C     I#LOC         ANDEQ     'GLOB'                                                  AR1081071
     C                   Z-ADD     BJRDNB        E_PRDT                                    BUG28040A
     C                   ELSE                                                              BUG28040A
     C     CL_RECI       IFEQ      'D'                                                     BUG28040A
     C     CL_AUTO       ANDEQ     'N'                                                     BUG28040A
     C     CL_MDAT       ANDLT     BJDNWD                                                  BUG28040A
     C     I#LOC         ANDEQ     'ZONE'                                                  BUG28040A
     C     CL_RECI       OREQ      'D'                                                     AR1081071
     C     CL_AUTO       ANDEQ     'C'                                                     AR1081071
     C     CL_MDAT       ANDLT     BJDNWD                                                  AR1081071
     C     I#LOC         ANDEQ     'ZONE'                                                  AR1081071
     C                   Z-ADD     BJDNWD        E_PRDT                                    BUG28040A
     C                   ELSE                                                              BUG28040A
     C                   Z-ADD     CL_MDAT       E_PRDT
     C                   ENDIF                                                             BUG28040A
     C                   ENDIF                                                             BUG28040A
      *
      * Event Type
     C                   MOVEL     'MT'          E_EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
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
      * IMPORT LOAN AMENDMENT EVENTS
      *****************************************************************
     C     IMP_LOAM      BEGSR
      *
     C     CL_LNRF       SETLL     LOAMSDKF
     C     *IN99         DOUEQ     '1'
     C     LARECI        OREQ      'D'
     C     CL_LNRF       READE     LOAMSDKF                               99      *
     C                   ENDDO
      *
      * Whilst loan amendments can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     LAVDAT        E_PRDT
      *
      * Processing Seq
     C                   MOVEL     LAPRSQ        E_PRSQ
      *
      * If the loan amendment is a base rate change
      *
     C     LAAMTP        IFEQ      'BC'
     C                   MOVEL     'BC'          E_EVTP
     C                   Z-ADD     LABRTT        E_BRTT
     C                   END
      *
      * If the loan amendment is a spread change
      *
     C     LAAMTP        IFEQ      'SC'
     C                   MOVEL     'SC'          E_EVTP
      * interest rate
     C                   Z-ADD     LARTSP        E_RTSP
     C                   MOVE      LAIRCF        E_IRCH
     C                   END
      *
      * Principal increase
      *
     C     LAAMTP        IFEQ      'PI'
     C     LAAMTP        OREQ      'PT'
     C                   MOVEL     'PI'          E_EVTP
     C                   Z-ADD     LAPRAM        E_PRAM
     C                   END
      *
      * Principal decrease
      *
     C     LAAMTP        IFEQ      'PF'
     C                   MOVEL     'PD'          E_EVTP
     C                   Z-ADD     LAPRAM        E_PRAM
     C                   END
      *
      * Repayment schedule
      *
     C     LAAMTP        IFEQ      'RE'
     C     LAAUTO        ANDNE     'N'                                                      MD022920
      * convert
     C     LACCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'RE'          E_EVTP
     C                   Z-ADD     LAPRAM        E_PRAM
     C                   Z-ADD     LAINTA        E_INTA
     C                   Z-ADD     LATAMT        E_TAMT
     C                   END
      *
      * Manual repayment
      *
     C     LAAMTP        IFEQ      'MR'
      * convert
     C     LACCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'MR'          E_EVTP
     C                   Z-ADD     LAPRAM        E_PRAM
     C                   Z-ADD     LAINTA        E_INTA
     C                   Z-ADD     LATAMT        E_TAMT
     C                   END
      *
      * Past Due Payment
      *
     C     LAAMTP        IFEQ      'PD'
     C                   MOVEL     'OD'          E_EVTP
     C                   Z-ADD     LAPRAM        E_PRAM
     C                   Z-ADD     LAINTA        E_INTA
     C                   Z-ADD     LATAMT        E_TAMT
     C                   END
      *
      **  Settlement method, account & branch
      *
     C                   MOVEL     LASETP        E_SETM
     C                   MOVEL     LAOSAC        E_SETA
     C                   MOVEL     LAOSBR        E_SETB
     C                   MOVEL     LASCCY        E_SETC
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
      * Import loan amendment event
      *
     C     E_EVTP        IFNE      *BLANK
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Read next record
      *
     C     *IN99         DOUEQ     '1'
     C     LARECI        OREQ      'D'
     C     CL_LNRF       READE     LOAMSDKF                               99      *
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
     C                   PARM                    ZFRDAT            5 0          * DATE
     C                   PARM                    ZFRFRQ            1            * FREQUENCY
     C                   PARM                    ZFRBAS            2 0          * BASE DAY
     C                   PARM                    ZFRSET            2 0          * SETT.METH.
     C                   PARM                    ZFRCCY            3            * CURRENCY
     C                   PARM      *BLANK        ZSTCY             3
     C                   PARM      'P'           ZRCIP             1
     C                   PARM                    ZFRNOS            2            * NOSTRO
     C                   PARM                    ZFRMDT            5 0          * MAT.DATE
     C                   PARM                    BKAPDT            5 0
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM      *ZERO         ZFRZBD            5 0          * BASE DATE
     C                   PARM      *ZERO         ZFRNXD            5 0          * NEXT DATE
      *
     C     ZFRRTC        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DLZFRQ'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************                  MD037863
      /SPACE 5                                                                              MD037863
      ********************************************************************                  MD037863
      * DETERMINE NEXT DAY 2                                                                MD037863
      ********************************************************************                  MD037863
     C     DETNXD2       BEGSR                                                              MD037863
      *                                                                                     MD037863
     C                   CALLB     'ZFREQB'                                                 MD037863
     C                   PARM                    RetCodeIn                                  MD037863
     C                   PARM                    ZFRFRQ                         * FREQUENCY MD037863
     C                   PARM                    ZFRDAT                         * DATE      MD037863
     C                   PARM                    ZFRCCY                         * CURRENCY  MD037863
     C                   PARM                    BJSLCD                                     MD037863
     C                   PARM                    ZFRBAS                         * BASE DAY  MD037863
     C                   PARM                    BJDFIN                                     MD037863
     C     SDGELR        PARM                    SDGELR                                     MD037863
      *                                                                                     MD037863
     C     RetCodeIn     IFEQ      '*ERROR'                                                 MD037863
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO ZFREQB'                       MD037863
     C                   EXSR      *PSSR                                                    MD037863
     C                   END                                                                MD037863
     C                   EVAL      ZFRNXD = ZFRDAT                                          MD037863
      *                                                                                     MD037863
     C                   ENDSR                                                              MD037863
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT LOAN AMENDMENT (FACILITY) CURRENCY TO LOAN CURRENCY
      ********************************************************************
     C     CONVLM        BEGSR
      *
      **   ACCESS LOAN AMENDMENT CURRENCY DETAILS
      *
     C                   MOVEL     LACCY         @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        ZCDPI
      *
      **   ACCESS LOAN CURRENCY DETAILS
      *
     C                   MOVEL     CL_CCY        @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        ZCDPO
      *
      ** CONVERSION DONE USING FACILITY CURRENCY EXCHANGE/M/D IND
      *
     C                   Z-ADD     CL_FCXR       ZEXCH
     C     CL_FMDI       IFEQ      'D'
     C                   MOVE      'M'           ZMD
     C                   ELSE
     C                   MOVE      'D'           ZMD
     C                   ENDIF
      * principal
     C                   Z-ADD     LAPRAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LAPRAM
      * interest
     C                   Z-ADD     LAINTA        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LAINTA
      * total
     C                   Z-ADD     LATAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LATAMT
      *
     C                   ENDSR
      ********************************************************************
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
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      **********************************************************************
      **
      **   ZCONVN - SUBROUTINE TO CONVERT AN  AMOUNT FROM ONE CURRENCY
      **               TO ANOTHER
      **
      **   INPUT  - ZAMTCI (15,0) AMOUNT INPUT
      **            ZEXCH  (13,8) EXCHANGE RATE
      **            ZMD    (1)    MULTIPLY/DIVIDE INDICATOR
      **            ZCDPI  (1,0)  CURRENCY DECIMAL PLACES INPUT
      **            ZCDPO  (1,0)  CURRENCY DECIMAL PLACES TO BE CONVERTED TO
      **            POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED
      **                          IN THE PROGRAM SOURCE
      **
      **  OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT
      **
      **********************************************************************
     C     ZCONVN        BEGSR                                                  ** ZCONVN **
      *
      * DEFINE INPUT AND OUTPUT FIELDS
      *
     C                   Z-ADD     ZAMTCI        ZAMTCI           15 0
     C                   Z-ADD     0             ZAMTCO           15 0
     C                   Z-ADD     ZCDPI         ZCDPI             1 0
     C                   Z-ADD     ZCDPO         ZCDPO             1 0
     C                   Z-ADD     ZEXCH         ZEXCH            13 8
     C                   MOVE      ZMD           ZMD               1
      *
      * IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
      *
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCNVN
     C                   END
      *
      * IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
      *
     C     ZCDPI         IFEQ      ZCDPO
      *
      ***  CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
      *** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
      *** ON INDICATOR
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
      *
      *** IF DECIMAL PLACES DIFFER -
      ***      CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POWER INDEX
      *
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0
     C                   ADD       4             ZPX
      *
      *** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
      ***  POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
      ***  DEPENDING ON INDICATOR
      *
     C     POWER(ZPX)    IFLT      1                                            from d.p *LT
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE                                                   from d.p. *GT
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI                           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   END
      *
      *
     C                   END
      *
     C     EZCNVN        ENDSR                                                  ** EZCNVN **
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
(c) Finastra International Limited 2003
** TABCDE/TABTYP. LOAN PROCESSING TYPES
61CA
62TA
63DA
64TA
65DA
66TL
67DL
68CA
69CL
70 A
71 A
72 L
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
