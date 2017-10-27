     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of FX Deals')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTFXDL - Extract for Foreign Exchange Deals                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 TDA102             Date 28Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
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


     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
     D DEALDB        E DS                  EXTNAME(DEALSDB)


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
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0

     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    I#TVDI            1
     C                   PARM                    FXDEAL
     C                   PARM                    DEALDB
     C                   PARM                    OL_ACEI           1

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
     C                   CALLB     'GOSETFXDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    FXDEAL
     C                   PARM                    OTDT
      * OUTPUTS
     C                   PARM                    T_TRAP

     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    OptnEndDate       5 0            Midas day no.

     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFXDL'
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
      *
      **  Pay and receive settlement methods, accounts & branches
      *
     C                   MOVEL     FHMOPM        W#PAYM                         * pay method
     C                   MOVEL     FHMOPI        W#PAYA                         * pay account
     C                   MOVEL     FHPOBR        W#PAYB                         * pay branch
     C                   MOVEL     FHPSCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     FHORCM        W#RECM                         * rec method
     C                   MOVEL     FHMORI        W#RECA                         * rec account
     C                   MOVEL     FHROBR        W#RECB                         * rec branch
     C                   MOVEL     FHRSCY        W#RSCY                         * rec settle ccy
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      ** SET UP WORK FIELDS WITH BUY OR SELL CURRENCY DETAILS
      *
     C     W#ASLI        CASEQ     'A'           BUYCCY
     C     W#ASLI        CASEQ     'L'           SELLCCY
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
      * IMPORT VALUE DATE EVENT
      *
     C     FSLI          IFEQ      2
     C                   EXSR      IMP_VD
     C                   ENDIF
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
     C     FSLI          IFEQ      2
     C                   Z-ADD     OTDT          P_PDAT
     C                   ELSE
     C                   Z-ADD     T_TDAT        P_PDAT                         *
     C                   ENDIF
      *
      * Asset/Liability
     C                   MOVEL     W#ASLI        P_ASLI
      *
      * Nominal/Principal
     C                   Z-ADD     W#AMT         P_NOML                         *
      *
      * Currency
     C                   MOVEL     W#CCY         P_CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * Other Asset/Liaibility
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     'L'           P_OASL                         *
     C                   ELSE
     C                   MOVEL     'A'           P_OASL                         *
     C                   ENDIF
      *
      * Other Nominal/Principal
     C                   Z-ADD     W#OAMT        P_ONOM                         *
      *
      * Other Currency
     C                   MOVEL     W#OCCY        P_OCCY
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
     C                   Z-ADD     DealDate      E_PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E_EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           ACEI                     99    *
     C  N99ORED          COMP      I#RDNB                               99
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
     C                   Z-ADD     OTDT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'VD'          E_EVTP
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
      *
      * Processed?
      *
     C                   TESTB     '1'           OL_ACEI                  99
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
      * IMPORT MATURITY DATE EVENT
      *****************************************************************
     C     IMP_MT        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     T_EDAT        E_PRDT
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
      /SPACE 5
      ********************************************************************
      * MOVE BUY CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     BUYCCY        BEGSR
      *
     C                   MOVE      FHCCY1        W#CCY             3
     C                   Z-ADD     FHDBUY        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-ADD     FHDAM1        W#AMT
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY

     C                   MOVE      FHCCY2        W#OCCY            3
     C                   Z-ADD     FHDSEL        W#OAMT           13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-SUB     FHDAM2        W#OAMT
     C                   ENDIF
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE SELL CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     SELLCCY       BEGSR
      *
     C                   MOVE      FHCCY2        W#CCY             3
     C                   Z-ADD     FHDSEL        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-SUB     FHDAM2        W#AMT
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   MOVE      FHCCY1        W#OCCY            3
     C                   Z-ADD     FHDBUY        W#OAMT           13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-ADD     FHDAM1        W#OAMT
     C                   ENDIF
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
