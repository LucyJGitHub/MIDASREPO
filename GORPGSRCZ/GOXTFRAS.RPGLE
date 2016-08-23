     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of FRAs')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTFRAS - Extract for Forward Rate Agreements               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3860            Date 11Aug04               *
      *                 TDA102             Date 28Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3860 - (recompile)                                        *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
     D FRAS          E DS                  EXTNAME(DEALSDG)
 
 
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
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
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
     C                   PARM                    FRAS
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * NO VALUE DATE POSITION EXTRACT IS REQUIRED IF MATURED
 
     C     I#TVDI        IFEQ      'V'
     C     T_MATI        ANDEQ     'Y'
     C                   RETURN
     C                   ENDIF
 
      * SETUP SETTLEMENT INSTRUCTIONS
 
     C                   EXSR      SETUP_SETI
 
 
      * 'ASSET' POSITION
      * ----------------
 
     C                   MOVE      'A'           W#ASLI            1
 
      * IMPORT OPENING POSITION AND EVENTS
 
     C                   EXSR      IMPORT
 
      * PROCESS IMPORTED EVENTS
 
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   EXSR      WRKEDTA
 
      * 'LIABILITY' POSITION
      * --------------------
 
     C                   MOVE      'L'           W#ASLI
 
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
     C                   CALLB     'GOSETFRAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    FRAS
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    FltRateSet        1
     C                   PARM                    FltRateTyp        1
     C                   PARM                    FltRate          11 7
     C                   PARM                    FixRate          11 7
     C                   PARM                    SettleAmt        15 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFRAS'
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
 
     C                   MOVEL     PSETM         W#PAYM                         * pay method
     C                   MOVEL     UPACC         W#PAYA                         * pay account
     C                   MOVEL     POBR          W#PAYB                         * pay branch
     C                   MOVEL     PSCY          W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     RSETM         W#RECM                         * rec method
     C                   MOVEL     URACC         W#RECA                         * rec account
     C                   MOVEL     ROBR          W#RECB                         * rec branch
     C                   MOVEL     RSCY          W#RSCY                         * rec settle ccy
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      ** SET UP WORK FIELDS WITH 'OUR' OR THEIR DETAILS
      *
     C     W#ASLI        CASEQ     'L'           OUR
     C     W#ASLI        CASEQ     'A'           THEIR
     C                   ENDCS
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
      * END IF TRADE DATE
      *
     C     I#TVDI        CABEQ     'T'           E_IMPORT
      *
      ** IF FLOATING RATE
      ** RATE CHANGE IS ON VALUE DATE
      ** IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      *
     C     W#BRTT        IFNE      *ZERO
     C                   EXSR      IMP_BC_I
     C                   ENDIF
      *
      * IMPORT VALUE DATE EVENT
      *
     C                   EXSR      IMP_VD
      *
      * IMPORT MATURITY DATE EVENT
      *
     C                   EXSR      IMP_MT
      *
     C     E_IMPORT      ENDSR
      *****************************************************************
      /SPACE 5
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
     C                   Z-ADD     W#IACD        P_PDAT                   99    *
     C   99              Z-ADD     VDAT          P_PDAT                         *
      *
      * Asset/Liability
     C                   MOVEL     W#ASLI        P_ASLI
      *
      * Accrued Int To Date
     C                   Z-ADD     W#AITC        P_AITC
      *
      * Int Paid To Date
     C                   Z-ADD     W#IPRD        P_IPRD
      *
      * Int Capitalised To Date
     C                   Z-ADD     *ZERO         P_ICTD
      *
      * Accrued Int Adjustments
     C                   Z-ADD     W#AIAP        P_AIAD
      *
      * Nominal/Principal
     C                   Z-ADD     W#PAMT        P_NOML                         *
      *
      * Currency
     C                   MOVEL     W#CUCY        P_CCY
     C                   MOVEL     W#CUCY        @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * Base Rate Code
     C                   MOVEL     W#BRTT        P_BRTT
      *
      * Base Rate
     C                   Z-ADD     W#BRTE        P_BRTE
      *
      * Rate/Spread
     C                   Z-ADD     W#RTSP        P_RTSP
      *
      * Spread Ind
     C                   MOVEL     W#SPIN        P_SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     W#EINR        P_IRAT
      *
      * Int Calc Method
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
      * Accrue interest
     C                   MOVE      'N'           P_ACIN
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
      **************************************************************************
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
     C                   Z-ADD     DDAT          E_PRDT
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
      ********************************************************************
      * IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      ********************************************************************
     C     IMP_BC_I      BEGSR
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      * Processing Date
      *
     C                   Z-ADD     VDAT          E_PRDT
      *
      * Processing Sequence
     C                   Z-ADD     05            E_PRSQ
      *
      * Event Type
     C                   MOVEL     'BC'          E_EVTP
      *
      * Base Rate Code
     C                   Z-ADD     W#BRTT        E_BRTT
 
      * If the floating rate has been fixed, use the appropriate rate
 
     C     FltRateSet    IFEQ      'Y'
 
     C     FltRateTyp    IFEQ      'A'
     C                   Z-ADD     FltRate       E_IRAT
     C                   MOVEL     'A'           E_IRTP
     C                   ELSE
     C                   Z-ADD     FltRate       E_BRTE
     C                   MOVEL     'C'           E_IRTP
     C                   ENDIF
 
      * else the rate will be a forward rate
 
     C                   ELSE
     C                   MOVEL     'F'           E_IRTP
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
      *
      ** Import initial base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
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
     C                   Z-ADD     VDAT          E_PRDT
      *
      * Processing Sequence
     C                   Z-ADD     10            E_PRSQ
      *
      * Event Type
     C                   MOVEL     'VD'          E_EVTP
 
      * If the floating rate has been fixed
      * the settlement amount is payable on value date
 
     C     FltRateSet    IFEQ      'Y'
     C     SettleAmt     ANDLT     *ZERO
     C     W#ASLI        ANDEQ     'L'
     C     FltRateSet    OREQ      'Y'
     C     SettleAmt     ANDGE     *ZERO
     C     W#ASLI        ANDEQ     'A'
 
      ** Set settlement amount, in/out indicator and settlement details
 
     C     SettleAmt     IFLT      *ZERO
     C                   Z-SUB     SettleAmt     E_INTA
     C                   MOVE      'O'           E_IO
     C                   MOVEL     W#PAYD        E_SETD
     C                   ELSE
     C                   Z-ADD     SettleAmt     E_INTA
     C                   MOVE      'I'           E_IO
     C                   MOVEL     W#RECD        E_SETD
     C                   ENDIF
 
     C                   ELSE
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#PAYD        E_SETD
     C                   ELSE
     C                   MOVEL     W#RECD        E_SETD
     C                   END
 
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
      * IMPORT MATURITY DATE EVENT
      *****************************************************************
     C     IMP_MT        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     MDAT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E_EVTP
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
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
      /SPACE 5
      ********************************************************************
      * MOVE 'OUR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     OUR           BEGSR
      *
     C                   MOVE      'U'           W#OTIN            1
      *
     C                   MOVE      UCUCY         W#CUCY            3
     C                   Z-ADD     UPAMT         W#PAMT           13 0
     C                   Z-ADD     UBRTT         W#BRTT            2 0
     C                   Z-ADD     UBRTE         W#BRTE           11 7
     C                   Z-ADD     URTSP         W#RTSP           11 7
     C                   Z-ADD     UEINR         W#EINR           11 7
     C                   MOVE      USPIN         W#SPIN            1
     C                   Z-ADD     UICBS         W#ICBS            1 0
     C                   Z-ADD     UINFD         W#INFD            5 0
      *
     C                   Z-ADD     UIACD         W#IACD            5 0
     C                   Z-ADD     UAITC         W#AITC           13 0
     C                   Z-ADD     UAIAN         W#AIAN           13 0
     C                   Z-ADD     UAIAP         W#AIAP           13 0
     C                   Z-ADD     UIPRD         W#IPRD           13 0
      *
     C                   MOVE      UDNSI         W#DNSI            1
     C                   MOVE      UDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'THEIR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     THEIR         BEGSR
      *
     C                   MOVE      'T'           W#OTIN            1
      *
     C                   MOVE      TCUCY         W#CUCY            3
     C                   Z-ADD     TPAMT         W#PAMT           13 0
     C                   Z-ADD     TBRTT         W#BRTT            2 0
     C                   Z-ADD     TBRTE         W#BRTE           11 7
     C                   Z-ADD     TRTSP         W#RTSP           11 7
     C                   Z-ADD     TEINR         W#EINR           11 7
     C                   MOVE      TSPIN         W#SPIN            1
     C                   Z-ADD     TICBS         W#ICBS            1 0
     C                   Z-ADD     TINFD         W#INFD            5 0
      *
     C                   Z-ADD     TIACD         W#IACD            5 0
     C                   Z-ADD     TAITC         W#AITC           13 0
     C                   Z-ADD     TAIAN         W#AIAN           13 0
     C                   Z-ADD     TAIAP         W#AIAP           13 0
     C                   Z-ADD     TIPRD         W#IPRD           13 0
      *
     C                   MOVE      TDNSI         W#DNSI            1
     C                   MOVE      TDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
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
      *********************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY GOCPYSRC,GOXTIMPPE
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
     C/COPY GOCPYSRC,GOXTWRKEDA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
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
