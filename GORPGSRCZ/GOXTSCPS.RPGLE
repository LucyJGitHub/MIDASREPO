     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of SE Cust Positions')                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTSCPS - Projected Extract for Securities Customer Positions
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 264185             Date 19Aug14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248214             Date 20Jun07               *
      *                 246728             Date 11Apr07               *
      *                 BUG14267           Date 16Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3860            Date 11Aug04               *
      *                 TDA102             Date 28Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  264185 - Correct conversion of Nominal. If Price Basis is P, *
      *           ZPRC should be 100. While if Price Basis is U, ZPRC *
      *           should be 1.                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248214 - GOC0020 seq 00011 failed due to 'Processing Date is *
      *           Invalid.' Annotated as BUG14267.                    *
      *  246728 - Skip processing imported events rather thank        *
      *           invoking *PSSR when record is not found in          *
      *           GOWEVNTPD - Midas GO Work Events file.              *
      *           Annotated as BUG14267.                              *
      *  BUG14267 - Apply Fix in GEMS 248214 and 246728.              *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3860 - (recompile)                                        *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FTDPBT     IF   E           K DISK    RENAME(TRADSDF:TRADSDF_T)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_T)
     F                                     RENAME(DPTMVDF:DPTMVDF_T)
     F                                     RENAME(DPTMVTF:DPTMVTF_T)
     F                                     IGNORE(SEDVPRD0)
     FTDPBV     IF   E           K DISK    RENAME(TRADSDF:TRADSDF_V)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_V)
     F                                     RENAME(DPTMVDF:DPTMVDF_V)
     F                                     RENAME(DPTMVTF:DPTMVTF_V)
     F                                     IGNORE(SEDVPRD0)
     FSECET     IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
     D CPOSN         E DS                  EXTNAME(CPOSND)
     D CPOSN_RECI    E                     EXTFLD(RECI)
     D CPOSN_TNLU    E                     EXTFLD(TNLU)
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SECTY_RECI    E                     EXTFLD(RECI)
     D SECTY_ZZ05    E                     EXTFLD(ZZ005)
     D SECTY_TNLU    E                     EXTFLD(TNLU)
     D CDArr                 183    230
     D CRArr                 231    242
     D INVTP         E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(IN_)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)
 
 
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
     D W#POSS          DS
     D  W#POSM                 1      2
     D  W#POSA                 3     20                                                       TDA102
     D  W#POSB                21     23                                                       TDA102
     D  W#POSY                24     26                                                       TDA102
     D**W#POSA**************** 3     14                                                       TDA102
     D**W#POSB****************15     17                                                       TDA102
     D**W#POSY****************18     20                                                       TDA102
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     IDPTMVDF_T
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPMD                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVTF_T
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPDO                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVDF_V
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPMD                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVTF_V
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPDO                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     ISEDEVDF
     I              RECI                        SEDEV_RECI
     I              NMCY                        SEDEV_NMCY
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    I#DNWD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    I#TVDI            1
     C                   PARM                    CPOSN
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
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
      *                                                                                     BUG14267
      ** Skip updates when record read has no valid event.                                  BUG14267
      *                                                                                     BUG14267
     C     W#RTCD        IFNE      '*NOREC '                                                BUG14267
 
      * WRITE TRANSACTION INDEX RECORD
 
     C     I#TVDI        IFEQ      'T'
      * Commitment Cycle ID
     C                   Z-ADD     I#CCID        T_CCID
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
     C                   ENDIF                                                              BUG14267
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
     C                   CALLB     'GOSETSCPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    CSBA
     C                   PARM                    CSCN
     C                   PARM                    CSSC
     C                   PARM                    CSDA
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    PRICE
     C                   PARM                    NomCcyDec         1 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSCPS'
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
 
      **  Position settlement instructions
 
     C                   MOVE      *BLANK        W#POSM                         * settle method
     C                   MOVE      *BLANK        W#POSA                         * settle A/C
     C                   MOVE      *BLANK        W#POSB                         * settle branch
     C                   MOVE      *BLANK        W#POSY                         * settle currency
 
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
      * IMPORT TRADE EVENTS
      *
     C                   EXSR      IMP_TRAD
      *
      * END IF TRADE DATE
      *
     C     I#TVDI        CABEQ     'T'           E_IMPORT
      *
      * If interest bearing
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C     MATY          IFNE      *ZERO
     C     CRArr         ANDNE     *BLANK
     C                   EXSR      IMP_IP
     C                   ENDIF
      *
      * If interest bearing
      * IMPORT INTEREST RATE CHANGE DATE EVENTS
      *
     C     MATY          IFNE      *ZERO
     C     CRArr         ANDNE     *BLANK
     C                   EXSR      IMP_IR
     C                   ENDIF
      *
      * IMPORT PART PAYMENT DATE EVENTS
      *
     C     PPDI          IFEQ      'Y'
     C                   EXSR      IMP_PP
     C                   END
      *
      * IMPORT MORTGAGE PAYMENT DATE EVENTS
      *
     C     IN_PROT       IFEQ      '8'
     C                   EXSR      IMP_MP
     C                   END
      *
      * If date present
      * IMPORT MATURITY DATE EVENT
      *
     C     MATY          IFNE      *ZERO
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
     C                   Z-ADD     CSDA          P_PDAT                           Midas day no.
      *
      * Nominal/Principal
     C     I#TVDI        IFEQ      'T'
     C                   Z-ADD     CSNT          W#NOML
     C                   ELSE
     C                   Z-ADD     CSNV          W#NOML
     C                   ENDIF
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        P_NOML
      *
      * Ex-coupon nominal
     C     I#TVDI        IFEQ      'T'
     C                   Z-ADD     0             W#NOML
     C                   ELSE
     C                   Z-ADD     CSEX          W#NOML
     C                   ENDIF
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        P_ONOM
      *
      * Currency
     C                   MOVEL     NMCY          P_CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     NomCcyDec     P_NCDP
      *
      * Nominal Dec Places
     C     IN_PROT       IFEQ      '1'
     C     IN_PROT       OREQ      '3'
     C     IN_PROT       OREQ      '5'
     C     IN_PROT       OREQ      '6'
     C     IN_PROT       OREQ      '8'
     C     IN_PROT       OREQ      '9'
     C                   MOVEL     NomCcyDec     P_NMDP
     C                   ELSE
     C                   MOVEL     NMDP          P_NMDP
     C                   ENDIF
      *
      * Int Calc Method
     C     DYBS          IFNE      ' '
     C     DYBS          ANDNE     '4'
 
     C                   MOVEL     DYBS          W#DYBS
     C                   MOVEL     DVBS          W#DVBS
     C                   CALLB     'GOCVTICSE'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    W#DYBS            1 0          * DAY BASIS
     C                   PARM                    W#DVBS            1 0          * DIV BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCVTICSE'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P_ICMT
 
     C                   ENDIF
      *
      * Initialization for determination of next interest payment date
      *
     C                   MOVEL     '*INIT     '  W#MODE_SIP
     C                   EXSR      GETSIPD
      *
      * Int Payments/Year
     C                   Z-ADD     W#IPY         P_IPY
      *
      * Accrue Negative Balance
     C                   MOVEL     'Y'           P_ACNG
      *
      * Accrue interest
     C     DYBS          IFNE      ' '
     C     DYBS          ANDNE     '4'
     C                   MOVE      'Y'           P_ACIN
     C                   ENDIF
      *
      * Security price basis
     C                   MOVEL     SPBS          P_SPBS
      *
      * Yen Bond?
     C     IN_PROT       IFEQ      '5'
     C                   MOVEL     'Y'           P_YBON
     C                   ENDIF
      *
      * Schuldschein?
     C     IN_PROT       IFEQ      '6'
     C                   MOVEL     'Y'           P_SCHU
     C                   ENDIF
      *
      * Mortgage backed bond?
     C     IN_PROT       IFEQ      '8'
     C                   MOVEL     'Y'           P_MORT
     C                   ENDIF
      *
      * Partly paid bond?
     C                   MOVEL     PPDI          P_PART
      *
      * Fully paid price
     C                   Z-ADD     SFPP          P_FUPP
      *
      * Accuracy
     C                   Z-ADD     9             P_ACUR
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL  '  W#MODE
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
      * Processing Date = previous interest payment date
     C     W#PIDT        IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     W#PIDT        E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#POSS        E_SETD
      *
      ** Import previous interest payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Do all interest payments prior to maturity date
      *
     C     W#RTCD_SIP    DOWNE     '*EOD   '
     C     W#RTCD        ANDNE     '*FULL'
      *
      * Processing Date
     C     W#NIDT        IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     W#NIDT        E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next interest payment date
      *
     C                   MOVEL     *BLANK        W#MODE_SIP
     C                   EXSR      GETSIPD
      *
     C                   ENDDO
      *
     C     EIMP_IP       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST RATE CHANGE DATE EVENTS
      *****************************************************************
     C     IMP_IR        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Event Type
     C                   MOVEL     'IR'          E_EVTP
 
      * Pick up interest rates from the security diary
 
     C                   MOVE      'IR'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current rate on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date = initial date
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
      *
      * Interest Rate
     C                   Z-ADD     CPNR          E_IRAT
      *
      ** Import interest rate change date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all interest rate changes
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E_PRDT
     C                   ELSE
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
     C                   ENDIF
      *
      * Interest Rate
     C                   Z-ADD     SDNC          E_IRAT
      *
      ** Import interest rate change date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT PART PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_PP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Event Type
     C                   MOVEL     'PP'          E_EVTP
 
      * Pick up part payments from the security diary
 
     C                   MOVE      'PP'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current partly paid price on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date
     C*****ITLD*         IFNE      *ZERO                                                    BUG14267
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE
     C                   Z-ADD     1             E_PRDT
     C                   ENDIF
      *
      * Current PP %
     C                   Z-ADD     *ZERO         E_CPDP
     C                   MOVE      CPDP          E_CPDP
      *
      ** Import part payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all part payments
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E_PRDT
     C                   ELSE
     C*****ITLD*         IFNE      *ZERO                                                    BUG14267
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE
     C                   Z-ADD     1             E_PRDT
     C                   ENDIF
     C                   ENDIF
      *
      * Total PP call %
     C                   Z-ADD     *ZERO         E_CPDP
     C                   MOVE      SDTP          E_CPDP
      *
      ** Import part payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MORTGAGE PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_MP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Event Type
     C                   MOVEL     'MP'          E_EVTP
 
      * Pick up mortage payments from the security diary
 
     C                   MOVE      'MP'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current factor on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date = initial date
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
      *
      * Current Factor
     C                   Z-ADD     CFCT          E_CFCT
      *
      ** Import mortgage payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all mortgage payments
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E_PRDT
     C                   ELSE
     C     ITLD          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     ITLD          E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
     C                   ENDIF
      *
      * Current Factor
     C                   Z-ADD     SDCP          E_CFCT
      *
      ** Import mortgage payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
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
     C     MATY          IFGT      *ZERO                                                    BUG14267
     C                   Z-ADD     MATY          E_PRDT
     C                   ELSE                                                               BUG14267
     C                   Z-ADD     1             E_PRDT                                     BUG14267
     C                   ENDIF                                                              BUG14267
      *
      * Event Type
     C                   MOVEL     'MT'          E_EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#POSS        E_SETD
      *
      ** Import maturity date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT TRADE EVENTS
      *****************************************************************
     C     IMP_TRAD      BEGSR
 
     C     I#TVDI        IFEQ      'T'
     C     TRADKF        SETGT     TDPBT
     C                   ELSE
     C     TRADKF        SETGT     TDPBV
     C                   ENDIF
 
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     I#TVDI        IFEQ      'T'
     C     TRADKP        READE     TDPBT                                  99    *
     C                   ELSE
     C     TRADKP        READE     TDPBV                                  99
     C                   ENDIF
     C                   ENDDO
      *
      * Whilst live trades can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C     I#TVDI        IFEQ      'T'
     C     TDDT          IFEQ      0
     C                   Z-ADD     TDVD          E_PRDT
     C                   ELSE
     C                   Z-ADD     TDDT          E_PRDT
     C                   ENDIF
     C                   Z-ADD     TDVD          E_NIND
     C                   ELSE
     C                   Z-ADD     TDVD          E_PRDT
     C                   ENDIF
      *
      * Trade type
     C
     C                   SELECT
     C     TDTP          WHENEQ    'WI'
     C                   MOVEL     'TP'          E_EVTP
     C     TDTP          WHENEQ    'WO'
     C                   MOVEL     'TS'          E_EVTP
     C     TDTP          WHENEQ    'TP'
     C                   MOVEL     'TS'          E_EVTP
     C                   OTHER
     C                   MOVEL     'TP'          E_EVTP
     C                   ENDSL
      *
      * Trade reference
     C                   MOVEL     TDRF          E_EVRF
      *
      * total amount (countervalue in settlement currency)
     C                   Z-ADD     0             E_TAMT
      *
      * nominal
     C                   Z-ADD     NOML          W#NOML
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        E_NOML                         *
      *
      * accrued indicator
     C                   MOVE      ACIN          E_ACIN
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
      *
      * Import trade event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     I#TVDI        IFEQ      'T'
     C     TRADKP        READE     TDPBT                                  99    *
     C                   ELSE
     C     TRADKP        READE     TDPBV                                  99
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE NEXT DAY
      ********************************************************************
     C     GETSIPD       BEGSR
 
     C                   CALLB     'GOGETSIPD'
      * inputs
     C                   PARM      *BLANK        W#RTCD_SIP        7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS_SIP       30            * ERROR MESSAGE
     C                   PARM                    W#MODE_SIP       10
     C                   PARM      CSDA          W#ZECD            5 0          * SPOT DATE
     C                   PARM                    CDArr                          * INT.DAY   X12
     C                   PARM                    CRArr                          * INT.RT/PY X12
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ISSD              5 0          * INITIAL DATE
     C                   PARM                    ITLD              5 0          * INITIAL DATE
     C                   PARM                    FCPN              5 0          * FIRST COUPON
     C                   PARM                    MATY              5 0          * MATURITY DATE
     C                   PARM                    BJDFIN            1
     C                   PARM                    NMCY
     C                   PARM                    SITP
     C                   PARM                    BCNV
      * outputs
     C                   PARM                    W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#PIDT            5 0          * PREC INT DATE
     C                   PARM                    W#NIDT            5 0          * PAYMENT DATES
      *
     C     W#RTCD_SIP    IFEQ      '*ERROR '
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOGETSIPD'
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
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT NOMINAL (TO VALUE)
      ********************************************************************
     C     CNV_NOML      BEGSR
      *                                                                                       264185
      ** If Price Basis is 'P'ercentage, ZPRC is 100. While if Price                          264185
      ** Basis is 'U'nit, ZPRC is 1.                                                          264185
      *                                                                                       264185
     C                   IF        SPBS = 'P'                                                 264185
     C                   Z-ADD     100           ZPRC                                         264185
     C                   ELSEIF    SPBS = 'U'                                                 264185
     C                   Z-ADD     1             ZPRC                                         264185
     C                   ENDIF                                                                264185
      *
      * If interest bearing, convert nominal to face value
      *
     C     IN_PROT       IFEQ      '1'
     C     IN_PROT       OREQ      '3'
     C     IN_PROT       OREQ      '5'
     C     IN_PROT       OREQ      '6'
     C     IN_PROT       OREQ      '8'
     C     IN_PROT       OREQ      '9'
     C                   CALLB     'ZCNSD'
     C                   PARM      W#NOML        ZNOML            15 0
     C**********         PARM      100           ZPRC             16 9                        264185
     C                   PARM                    ZPRC             16 9                        264185
     C                   PARM      SPBS          W#SPBS            1
     C                   PARM      NMDP          W#NMDP            1 0
     C                   PARM      NomCcyDec     W#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0
     C                   Z-ADD     ZCONS         W#NOML           15 0
     C                   ENDIF
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
      /COPY GOCPYSRC,GOXTWRKEDS
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Securities Trading details
 
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      * Key lists
 
     C     TRADKF        KLIST
     C                   KFLD                    CSBA
     C                   KFLD                    CSCN
     C                   KFLD                    CSSC
     C                   KFLD                    CSDA
     C     TRADKP        KLIST
     C                   KFLD                    CSBA
     C                   KFLD                    CSCN
     C                   KFLD                    CSSC
 
     C     SEDEVKF       KLIST
     C                   KFLD                    CSSC
     C                   KFLD                    SDET
     C                   KFLD                    CSDA
     C     SEDEVK        KLIST
     C                   KFLD                    CSSC
     C                   KFLD                    SDET
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
