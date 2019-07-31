     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of NAs Purchased')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTNASP - Extract for Money Market NAs Purchased            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3860 - (recompile)                                        *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     FMMDENSL0  IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD**             179    198                                                       CGL029
     D  E_SETD               185    210
 
 
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D DEALDD        E DS                  EXTNAME(DEALSDD)
     D  DEALRONS     E                     EXTFLD(RONSQQ)                                     CGL029
     D  DEALPONS     E                     EXTFLD(PONSQQ)                                     CGL029
 
 
     D W#PAYD          DS
     D  W#PAYM                 1      2
     D**W#PAYA**               3     14                                                       CGL029
     D**W#PAYB**              15     17                                                       CGL029
     D**W#PSCY**              18     20                                                       CGL029
     D  W#PAYA                 3     20                                                       CGL029
     D  W#PAYB                21     23                                                       CGL029
     D  W#PSCY                24     26                                                       CGL029
     D W#RECD          DS
     D  W#RECM                 1      2
     D**W#RECA**               3     14                                                       CGL029
     D**W#RECB**              15     17                                                       CGL029
     D**W#RSCY**              18     20                                                       CGL029
     D  W#RECA                 3     20                                                       CGL029
     D  W#RECB                21     23                                                       CGL029
     D  W#RSCY                24     26                                                       CGL029
 
 
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
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    I#TVDI            1
     C                   PARM                    MMDENB
     C                   PARM                    DEALDD
 
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
     C                   CALLB     'GOSETNASP'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDENB
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETNASP'
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
     C                   MOVEL     HLMOPM        W#PAYM                         * pay method
     C                   MOVEL     HLMOPI        W#PAYA                         * pay account
     C                   MOVEL     HLPOBR        W#PAYB                         * pay branch
     C                   MOVEL     HLSTCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     HLORCM        W#RECM                         * rec method
     C                   MOVEL     HLMORI        W#RECA                         * rec account
     C                   MOVEL     HLROBR        W#RECB                         * rec branch
     C                   MOVEL     HLSTCY        W#RSCY                         * rec settle ccy
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
     C     HLMTYP        IFEQ      'C1'
     C     HLMTYP        OREQ      'C2'
     C     HLMTYP        OREQ      'BP'
     C     HLMTYP        OREQ      'BD'
     C                   EXSR      IMP_IP
     C                   ENDIF
      *
      * IMPORT MATURITY DATE EVENT
      *
     C                   EXSR      IMP_MT
      *
      * IMPORT DEAL AMENDMENT EVENTS
      *
     C                   EXSR      IMP_DEAM
      *
      * IMPORT NA'S SOLD
      *
     C                   EXSR      IMP_NASS
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
     C                   Z-ADD     HLIAYY        ZWYYYY                         ¦ interest
     C                   Z-ADD     HLIAMM        ZWMTH                          ¦ accrual
     C                   Z-ADD     HLIADD        ZWDAY                          ¦ control date
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        P_PDAT                           Midas day no.
      *
      * Asset/Liability
     C                   MOVEL     'A'           P_ASLI
      *
      * Accrued Int To Date
     C                   Z-ADD     AITC          P_AITC
      *
      * Int Paid To Date
     C                   Z-ADD     IPRD          P_IPRD
      *
      * Accrued Int Adjustments
     C                   Z-ADD     AIAP          P_AIAD
      *
      * Nominal/Principal
     C                   Z-ADD     HLFVAL        P_NOML                 99      *
     C   99              Z-SUB     HLFVAL        P_NOML
      *
      * Currency
     C                   MOVEL     HLCCY         P_CCY
     C                   MOVEL     HLCCY         @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * If interest bearing
      * Rate/Spread   = face rate
      * Interest Rate = face rate
      *
     C     HLMTYP        IFEQ      'C1'
     C     HLMTYP        OREQ      'C2'
     C     HLMTYP        OREQ      'BP'
     C     HLMTYP        OREQ      'BD'
     C                   Z-ADD     HLFRAT        P_RTSP
     C                   Z-ADD     HLFRAT        P_IRAT
     C                   ENDIF
      *
      * Int Calc Method
     C                   MOVEL     HLICMT        W#ICBS            1 0
     C                   CALLB     'GOCVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P_ICMT
      *
      * Round Down
     C                   MOVEL     HLRDFC        P_RDFC
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
      * Total amount (countervalue)
     C                   Z-ADD     HLAMNP        E_TAMT                 99      *
     C   99              Z-SUB     HLAMNP        E_TAMT
      *
      * Nominal
     C                   Z-ADD     HLFVAL        E_NOML                         *
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#PAYD        E_SETD                         * Pay details
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
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
      *
     C                   Z-ADD     HLNIYY        ZWYYYY                         ¦
     C                   Z-ADD     HLNIMM        ZWMTH                          ¦ next int date
     C                   Z-ADD     HLNIDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E_PRDT                           Midas day no.
      *
      ** If no date present use maturity date
      *
     C     E_PRDT        IFEQ      *ZERO
     C                   Z-ADD     MaturityDate  E_PRDT                           Midas day no.
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#RECD        E_SETD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** exit this routine
      *
     C     HLIPFQ        IFEQ      *BLANK
     C     E_PRDT        OREQ      MaturityDate
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E_PRDT        ZFRDAT                         *DATE
     C                   MOVEL     HLIPFQ        ZFRFRQ                         *FREQUENCY
     C                   Z-ADD     HLIPDM        ZFRBAS                         *BASE DAY
     C                   MOVEL     E_SETM        ZFRSET                         *SETT.METH
     C     E_SETC        IFNE      *BLANK
     C                   MOVEL     E_SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     HLCCY         ZFRCCY                         *CURRENCY
     C                   ENDIF
     C                   MOVEL     E_SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     MaturityDate  ZFRMDT                         *MAT DATE
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
     C                   MOVEL     W#RECD        E_SETD                         * Rec details
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
     C     HLDN38        SETLL     MMDEAMP0
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HLDN38        READE     MMDEAMP0                               99    *
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
     C                   Z-ADD     HNVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HNVDMM        ZWMTH                          ¦ value date of
     C                   Z-ADD     HNVDDD        ZWDAY                          ¦ deal amendment
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E_PRDT
      *
      * If the deal amendment is settle interest
      *
     C     HNMTYP        IFEQ      'SI'
     C                   MOVEL     'IP'          E_EVTP
     C                   END
      *
      **  Pay and receive settlement method, account & branch
      *
     C                   MOVEL     HNORCM        E_SETM
     C                   MOVEL     HNMORI        E_SETA
     C                   MOVEL     HNOSBR        E_SETB
     C                   MOVEL     HNSTCY        E_SETC
      *
      * Import deal amendment event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HLDN38        READE     MMDEAMP0                               99    *
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT NA'S SOLD
      *****************************************************************
     C     IMP_NASS      BEGSR
      *
     C                   MOVEL     HLDN38        HMDADN
     C     HMDADN        SETLL     MMDENSP0
     C     *IN99         DOUEQ     '1'
     C     HMDDLT        OREQ      *BLANK
     C     HMDSTS        ANDNE     'M'
     C     HMDADN        READE     MMDENSP0                               99    *
     C                   ENDDO
      *
      * Whilst live NAs sold can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     HMVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HMVDMM        ZWMTH                          ¦ value date of
     C                   Z-ADD     HMVDDD        ZWDAY                          ¦ deal amendment
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E_PRDT
      *
      * Event Type
     C                   MOVEL     'PD'          E_EVTP
      *
      * Event reference
     C                   MOVEL     HMDN38        E_EVRF
      *
      * Nominal
     C                   Z-ADD     HMFVAL        E_PRAM                         *
      *
      * Total amount (countervalue)
     C                   Z-ADD     HMAMNP        E_TAMT                 99      *
     C   99              Z-SUB     HMAMNP        E_TAMT
      *
      **  Receive settlement method, account & branch
     C                   MOVEL     HMORCM        E_SETM
     C                   MOVEL     HMMORI        E_SETA
     C                   MOVEL     HMROBR        E_SETB
     C                   MOVEL     HMSTCY        E_SETC
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E_SSET
      *
      * Import NA sold event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     HMDDLT        OREQ      *BLANK
     C     HMDSTS        ANDNE     'M'
     C     HMDADN        READE     MMDENSP0                               99    *
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
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2003
