     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of X-Ccy Int. Rate Swaps')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTCIRS - Extract for Cross Currency Interest Rate Swaps    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR375200           Date 30Sep15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 242258             Date 15Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3860            Date 11Aug04               *
      *                 TDA102             Date 28Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR375200 - There is no CIRS Principal Increase event when    *
      *             nominal difference is zero. This will cause       *
      *             GOXTWRKEDA dumps due to event type field being    *
      *             blank.                                            *
      *             Applied for MD-35089.                             *
      *  242258 - Supress generation of 'VD' event.                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3860 - (recompile)                                        *
      *  TDA102 - 10-digit a/c code error. GO* programs dump.         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FDLDTSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLPCSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLCFSCPD  IF   E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
     D CIRS          E DS                  EXTNAME(DEALSDG)
 
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
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
     C                   PARM                    CIRS
 
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
     C                   CALLB     'GOSETCIRS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    CIRS
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETCIRS'
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
      ** SET UP WORK FIELDS WITH 'OUR' OR 'THEIR' DETAILS
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
      * IMPORT VALUE DATE EVENT
      *
     C                   EXSR      IMP_VD
      *
      * IMPORT FEE PAYMENT DATE EVENT
      *
     C     UPVD          IFNE      *ZERO
 
     C     W#ASLI        IFEQ      'A'
     C     UPPR          ANDEQ     'R'
     C     W#ASLI        OREQ      'L'
     C     UPPR          ANDEQ     'P'
 
     C                   EXSR      IMP_FE
     C                   ENDIF
     C                   ENDIF
      *
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *
     C     W#AIAN        IFNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      ** IF FLOATING RATE
      ** FIRST RATE CHANGE IS ON VALUE DATE
      ** IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      *
     C     W#BRTT        IFNE      *ZERO
     C                   EXSR      IMP_BC_I
     C                   ENDIF
      *
      * IF FLOATING RATE
      * IMPORT BASE RATE CHANGE EVENTS
      *
     C     W#BRTT        IFNE      *ZERO
     C     W#NICD        ANDNE     *ZERO
     C     W#NICD        ANDLT     MDAT
      *
      * IMPORT BASE RATE CHANGE EVENTS - FROM SCHEDULE
      *
     C     W#ICFR        IFEQ      'Z'
     C                   EXSR      IMP_BC_S
     C                   ELSE
      *
      * IMPORT BASE RATE CHANGE EVENTS - FROM FREQUENCY CODE
      *
     C                   EXSR      IMP_BC_F
     C                   END
     C                   END
      *
      * IMPORT PRINCIPAL CHANGE EVENTS
      *
     C     W#NPCD        IFNE      *ZERO
     C                   EXSR      IMP_PIPD
     C                   END
      *
     C                   SELECT
      *
      * IMPORT CASHFLOWS DEFINED AS A SCHEDULE
      *
     C     W#IPFR        WHENEQ    'C'
      *
     C                   EXSR      IMP_IP_CF
      *
      * IMPORT INTEREST PAYABLE UP FRONT (MUST BE PART OF A SCHEDULE)
      *
     C     W#INPM        WHENEQ    'D'
     C     W#INPM        OREQ      'Y'
      *
      * IMPORT INTEREST PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
      *
     C     W#IPFR        OREQ      'Z'
      *
     C                   EXSR      IMP_IP_S
      *
      * IMPORT INTEREST PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
      *
     C                   OTHER
     C                   EXSR      IMP_IP_F
     C                   ENDSL
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
     C                   Z-ADD     W#IACD        P_PDAT
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
      * Int Pay Method
     C                   MOVEL     W#INPM        P_INPM
      *
      * Int Capitalisation
     C                   MOVEL     *BLANK        P_INTC
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
     C     W#IPFR        IFNE      'C'
     C                   MOVE      'Y'           P_ACIN
     C                   ENDIF
      *
      * Amortise interest
     C     W#IPFR        IFEQ      'C'
     C                   MOVE      'Y'           P_AMIN
     C                   ENDIF
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
      * Event Type
     C                   MOVEL     'VD'          E_EVTP
      *
      * Suppress Settlement Y
      *
     C     DTYP          IFEQ      'RS'
     C                   MOVEL     'Y'           E_SSET
     C                   END
      *                                                                                       242258
     C     DTYP          IFEQ      'RX'                                                       242258
     C     VDEI          ANDNE     'Y'                                                        242258
     C                   MOVEL     'Y'           E_SSET                                       242258
     C                   END                                                                  242258
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
     C                   TESTB     '1'           ACEI                     99
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
      * IMPORT FEE PAYMENT DATE EVENT
      *****************************************************************
     C     IMP_FE        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     UPVD          E_PRDT
      *
      * Event Type
     C                   MOVEL     'FE'          E_EVTP
      *
      * Fees = premium paid
      *
     C                   Z-ADD     UPFE          E_FEE
      *
      * Currency decimal places
      *
     C                   MOVEL     A6NBDP        E_NCDP
      *
      ** Set up settlement details
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     W#PAYD        E_SETD
     C                   ELSE
     C                   MOVEL     W#RECD        E_SETD
     C                   ENDIF
      *
      * Processed?
      *
     C                   TESTB     '3'           ACEI                     99
     C   99              MOVE      'Y'           E_PRCD
      *
      ** Incoming/outgoing
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     'O'           E_IO
     C                   ELSE
     C                   MOVEL     'I'           E_IO
     C                   ENDIF
      *
      * Import fee payment date event
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
     C                   Z-ADD     W#AIAN        E_INTA
      *
      * Import manual adjustment to accrued interest event
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
      *
      * Processing Date
     C                   Z-ADD     VDAT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'BC'          E_EVTP
      *
      * Base Rate Code
     C                   Z-ADD     W#BRTT        E_BRTT
      *
      * Rate Type
     C                   TESTB     '0'           W#DNSI                   99
      *
      ** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     W#EINR        E_IRAT
     C                   MOVEL     'A'           E_IRTP
     C                   ELSE
      *
      ** IF RATE DUE FOR FIXING, GET CURRENT BASE RATE
      *
     C     W#INFD        IFLE      I#RDNB
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        E_BRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        E_BRTE
     C                   ENDIF
     C                   MOVEL     'C'           E_IRTP
      *
      ** ELSE FORWARD RATE
      *
     C                   ELSE
     C                   MOVEL     'F'           E_IRTP
     C                   END
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99
     C   99              MOVE      'Y'           E_PRCD
      *
      ** Import first base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
     C/SPACE 5
      ********************************************************************
      * IMPORT BASE RATE CHANGE EVENTS - FROM SCHEDULE
      ********************************************************************
     C     IMP_BC_S      BEGSR
      *
      ** SET FILE POINTER TO NEXT RATE CHANGE DATE
      *
     C                   MOVEL     W#OTIN        OTIN
     C                   MOVEL     'R'           RCIP
     C                   Z-ADD     W#NICD        PRDT
     C     DLDTSK        CHAIN     DLDTSCPD                           99        *
      *
      ** DO WHILE RATE CHANGES ARE FOUND
      *
     C     *IN99         DOWEQ     '0'
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     PRDT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'BC'          E_EVTP
      *
      * Base Rate Code
     C                   Z-ADD     W#BRTT        E_BRTT
      *
      * Base Rate & Rate Type
      *
      * If the next rate fix date > this rate change date
      * the rate for this rate change date has already been fixed
      *
     C     W#INFD        IFGT      E_PRDT
     C                   Z-ADD     W#BRTE        E_BRTE
     C                   MOVEL     'C'           E_IRTP
     C                   ELSE
      *
      * If this is the next rate change date
      * and this rate is due for fixing, get the current base rate
      *
     C     W#NICD        IFEQ      E_PRDT
     C     W#INFD        ANDLE     I#RDNB
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        E_BRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        E_BRTE
     C                   ENDIF
     C                   MOVEL     'C'           E_IRTP
      *
      ** ELSE FORWARD RATE
      *
     C                   ELSE
     C                   MOVEL     'F'           E_IRTP
     C                   END
     C                   END
      *
      * Processed?
      *
     C                   MOVE      DTPR          E_PRCD
      *
      ** Import next base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** GET NEXT RATE CHANGE DATE
      *
     C     DLDTSP        READE     DLDTSCPD                               99
      *
     C                   ENDDO
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT BASE RATE CHANGE EVENTS - FROM FREQUENCY CODE
      ********************************************************************
     C     IMP_BC_F      BEGSR
      *
      ** Set up variables used in frequency calculation
      *
     C                   MOVEL     W#ICFR        ZFRFRQ
     C                   Z-ADD     W#ICFD        ZFRBAS
     C                   MOVEL     W#INTM        ZFRSET
     C     W#ISCY        IFNE      *BLANK
     C                   MOVEL     W#ISCY        ZFRCCY
     C                   ELSE
     C                   MOVEL     W#CUCY        ZFRCCY
     C                   ENDIF
     C                   MOVEL     W#INTA        ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
      *
      ** Set up next rate change date
      *
     C                   Z-ADD     W#NICD        ZFRDAT
      *
      ** Do all rate changes prior to maturity date
      *
     C     ZFRDAT        DOWLT     MDAT
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     ZFRDAT        E_PRDT
      *
      * Event Type
     C                   MOVEL     'BC'          E_EVTP
      *
      * Base Rate Code
     C                   Z-ADD     W#BRTT        E_BRTT
      *
      * Base Rate & Rate Type
      *
      * If the next rate fix date > this rate change date
      * the rate for this rate change date has already been fixed
      *
     C     W#INFD        IFGT      E_PRDT
     C                   Z-ADD     W#BRTE        E_BRTE
     C                   MOVEL     'C'           E_IRTP
     C                   ELSE
      *
      * If this is the next rate change date
      * and this rate is due for fixing, get the current base rate
      *
     C     W#NICD        IFEQ      E_PRDT
     C     W#INFD        ANDLE     I#RDNB
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        E_BRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        E_BRTE
     C                   ENDIF
     C                   MOVEL     'C'           E_IRTP
      *
      ** ELSE FORWARD RATE
      *
     C                   ELSE
     C                   MOVEL     'F'           E_IRTP
     C                   END
     C                   END
      *
      ** Import next base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next base rate change date event
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
     C                   ENDSR
      **************************************************************************
     C/SPACE 5
      ********************************************************************
      * IMPORT PRINCIPAL CHANGE EVENTS
      ********************************************************************
     C     IMP_PIPD      BEGSR
      *
      ** Get next principal change date
      *
     C     DTYP          IFEQ      'RX'
     C                   MOVEL     W#OTIN        OTIN
     C                   ELSE
     C                   MOVEL     *BLANK        OTIN
     C                   END
     C                   Z-ADD     W#NPCD        PRDT
     C     DLPCSK        CHAIN     DLPCSCPD                           99        *
      *
      ** Do while principal changes found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     PRDT          E_PRDT
      *
      * Change in principal
      *
     C     PAMT          SUB       W#PAMT        W#DIFF           15 0
     C                   Z-ADD     PAMT          W#PAMT
      *
      * Principal increase
      *
     C*****W#DIFF        IFGT      0                                                        AR375200
     C     W#DIFF        IFGE      0                                                        AR375200
     C                   MOVEL     'PI'          E_EVTP
     C                   Z-ADD     W#DIFF        E_PRAM
     C                   END
      *
      * Principal decrease
      *
     C     W#DIFF        IFLT      0
     C                   MOVEL     'PD'          E_EVTP
     C                   Z-SUB     W#DIFF        E_PRAM
     C                   END
      *
      * Processed?
      *
     C                   MOVE      DTPR          E_PRCD
      *                                                                                       242258
     C     DTYP          IFEQ      'RX'                                                       242258
     C     PDEI          ANDNE     'Y'                                                        242258
     C                   MOVEL     'Y'           E_SSET                                       242258
     C                   END                                                                  242258
      *
      * Import principal change event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Get next principal change date
      *
     C     DLPCSP        READE     DLPCSCPD                               99    *
     C                   END
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT CASHFLOWS DEFINED AS A SCHEDULE
      ********************************************************************
     C     IMP_IP_CF     BEGSR
      *
      ** Get next cash flow
      *
     C                   MOVEL     W#OTIN        OTIN
     C                   Z-ADD     W#NIPD        PRDT
     C     DLCFSK        CHAIN     DLCFSCPD                           99        *
      *
     C     *IN99         DOWEQ     '0'
      *
      ** If cash flow amount is present
      *
     C     CFLA          IFNE      *ZERO
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     PRDT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Interest amount
     C                   Z-ADD     CFLA          E_INTA
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      * Processed?
      *
     C                   MOVE      DTPR          E_PRCD
      *
      ** Import cash flow event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   END
      *
      ** Get next cash flow
      *
     C     DLCFSP        READE     DLCFSCPD                               99    *
     C                   END
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT INTEREST PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
      ********************************************************************
     C     IMP_IP_S      BEGSR
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * If interest is 'up-front', first interest payment is on value date
      *
     C     W#INPM        IFEQ      'D'
     C     W#INPM        OREQ      'Y'
      *
      * Processing Date
     C                   Z-ADD     VDAT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E_PRCD
      *
      ** Import interest payment event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDIF
      *
      ** SET FILE POINTER TO NEXT INTEREST PAYMENT DATE
      *
     C                   MOVEL     W#OTIN        OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     W#NIPD        PRDT
     C     DLDTSK        CHAIN     DLDTSCPD                           99        *
      *
      ** DO WHILE INTEREST PAYMENTS ARE FOUND
      *
     C     *IN99         DOWEQ     '0'
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     PRDT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C     W#INPM        IFEQ      'C'
     C     W#INPM        OREQ      'K'
     C                   MOVEL     'Y'           E_INTC
     C                   ENDIF
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      * Processed?
      *
     C                   MOVE      DTPR          E_PRCD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** GET NEXT INTEREST PAYMENT DATE
      *
     C     DLDTSP        READE     DLDTSCPD                               99    *
      *
     C                   ENDDO
      *
      * If interest is not 'up-front', last interest payment is at maturity
      *
     C     W#INPM        IFNE      'D'
     C     W#INPM        ANDNE     'Y'
     C     E_PRDT        ANDLT     MDAT
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     MDAT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C     W#INPM        IFEQ      'C'
     C     W#INPM        OREQ      'K'
     C                   MOVEL     'Y'           E_INTC
     C                   ENDIF
      *
      * Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDIF
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT INTEREST PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
      ********************************************************************
     C     IMP_IP_F      BEGSR
      *
      ** Set up variables used in frequency calculation
      *
     C                   MOVEL     W#IPFR        ZFRFRQ
     C                   Z-ADD     W#IPFD        ZFRBAS
     C                   MOVEL     W#INTM        ZFRSET
     C     W#ISCY        IFNE      *BLANK
     C                   MOVEL     W#ISCY        ZFRCCY
     C                   ELSE
     C                   MOVEL     W#CUCY        ZFRCCY
     C                   ENDIF
     C                   MOVEL     W#INTA        ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
      *
      ** Set up next interest payment date
      *
     C                   Z-ADD     W#NIPD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     ZFRDAT        DOWLT     MDAT
     C     ZFRDAT        ANDNE     *ZERO
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     ZFRDAT        E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C     W#INPM        IFEQ      'C'
     C     W#INPM        OREQ      'K'
     C                   MOVEL     'Y'           E_INTC
     C                   ENDIF
      *
      * Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      ** Import interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      * Last interest payment is at maturity
      *
      * Clear event
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     MDAT          E_PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E_EVTP
      *
      *  Int Capitalisation Ind
      *
     C     W#INPM        IFEQ      'C'
     C     W#INPM        OREQ      'K'
     C                   MOVEL     'Y'           E_INTC
     C                   ENDIF
      *
      * Set up settlement details
      *
     C                   MOVEL     W#INTS        E_SETD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
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
     C     DTYP          IFEQ      'RS'
     C                   MOVEL     'Y'           E_SSET
     C                   END
      *                                                                                       242258
     C     DTYP          IFEQ      'RX'                                                       242258
     C     MDEI          ANDNE     'Y'                                                        242258
     C                   MOVEL     'Y'           E_SSET                                       242258
     C                   END                                                                  242258
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
     C                   Z-ADD     UNICD         W#NICD            5 0
     C                   Z-ADD     UICBD         W#ICBD            5 0
     C                   MOVE      UICFR         W#ICFR            1
     C                   Z-ADD     UICFD         W#ICFD            2 0
     C                   Z-ADD     UNIPD         W#NIPD            5 0
     C     W#NIPD        IFEQ      *ZERO
     C                   Z-ADD     MDAT          W#NIPD
     C                   END
     C                   Z-ADD     UIPBD         WIPBD             5 0
     C                   Z-ADD     USLIP         W#SLIP            5 0
     C                   MOVE      UIPFR         W#IPFR            1
     C                   Z-ADD     UIPFD         W#IPFD            2 0
     C                   Z-ADD     UIACD         W#IACD            5 0
     C                   Z-ADD     UAITC         W#AITC           13 0
     C                   Z-ADD     UAIAN         W#AIAN           13 0
     C                   Z-ADD     UAIAP         W#AIAP           13 0
     C                   Z-ADD     UIPRD         W#IPRD           13 0
     C                   MOVE      UDNSI         W#DNSI            1
     C                   MOVE      UDSTI         W#DSTI            1
      *
     C                   MOVE      UINPM         W#INPM            1
      *
     C                   MOVE      UNPCD         W#NPCD            5 0
      *
     C                   MOVE      W#PAYD        W#INTS
      *
     C                   MOVE      TCUCY         W#OCCY            3
     C                   Z-ADD     TPAMT         W#OAMT           13 0
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'THEIR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     THEIR         BEGSR
      *
     C                   MOVE      'T'           W#OTIN
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
     C                   Z-ADD     TNICD         W#NICD            5 0
     C                   Z-ADD     TICBD         W#ICBD            5 0
     C                   MOVE      TICFR         W#ICFR            1
     C                   Z-ADD     TICFD         W#ICFD            2 0
     C                   Z-ADD     TNIPD         W#NIPD            5 0
     C     W#NIPD        IFEQ      *ZERO
     C                   Z-ADD     MDAT          W#NIPD
     C                   END
     C                   Z-ADD     TIPBD         WIPBD             5 0
     C                   Z-ADD     TSLIP         W#SLIP            5 0
     C                   MOVE      TIPFR         W#IPFR            1
     C                   Z-ADD     TIPFD         W#IPFD            2 0
     C                   Z-ADD     TIACD         W#IACD            5 0
     C                   Z-ADD     TAITC         W#AITC           13 0
     C                   Z-ADD     TAIAN         W#AIAN           13 0
     C                   Z-ADD     TAIAP         W#AIAP           13 0
     C                   Z-ADD     TIPRD         W#IPRD           13 0
     C                   MOVE      TDNSI         W#DNSI            1
     C                   MOVE      TDSTI         W#DSTI            1
      *
     C                   MOVE      TINPM         W#INPM            1
      *
     C     DTYP          IFEQ      'RX'
     C                   MOVE      TNPCD         W#NPCD            5 0
     C                   ELSE
     C                   MOVE      UNPCD         W#NPCD            5 0
     C                   END
      *
     C                   MOVE      W#RECD        W#INTS
      *
     C                   MOVE      UCUCY         W#OCCY            3
     C                   Z-ADD     UPAMT         W#OAMT           13 0
      *
     C                   ENDSR
      **************************************************************************
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
      ********************************************************************
      * ACCESS BASE RATE DETAILS
      ********************************************************************
     C     ACSBSR        BEGSR
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C                   PARM                    @DWNB             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
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
      ** KEY LISTS FOR ACCESS OF DATE SCHEDULE
      *
     C     DLDTSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C                   KFLD                    PRDT
     C     DLDTSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
      *
      ** KEY LISTS FOR ACCESS OF CASHFLOWS
      *
     C     DLCFSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
     C     DLCFSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
      *
      ** KEY LISTS FOR ACCESS OF PRINCIPAL CHANGES
      *
     C     DLPCSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
     C     DLPCSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
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
