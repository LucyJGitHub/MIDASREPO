     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of Cap/Floor/Collars')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTCFCO - Extract for Caps, Floors and Collars              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
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
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D**E_SETD***************179    198                                                       TDA102
     D  E_SETD               185    210                                                       TDA102
 
 
     D CFCOS         E DS                  EXTNAME(DEALSDG)
 
 
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
 
      * NOTES ABOUT CAPS, FLOORS, COLLARS
      * ---------------------------------
      * Buy floor   They pay us if effective int rate < floor rate.
      *             Ceiling rate is set to 9999.9999999
      *             Deal details found in 'OUR' fields except for
      *             AITC & AIPD which is TAITC & TAIPD.
      * Sell floor  We pay them if effective int rate < floor rate.
      *             Ceiling rate is set to 9999.9999999
      *             Deal details found in 'THEIR' fields except for
      *             AITC & AIPD which is UAITC & UAIPD.
      * Buy cap     They pay us if effective int rate > ceiling rate
      *             Floor rate is set to 0.
      *             ALL deal details found in 'THEIR' fields.
      * Sell cap    We pay them if effective int rate > ceiling rate
      *             Floor rate is set to 0.
      *             ALL deal details found in 'OUR' fields.
      * Buy collar  = selling a floor and buying a cap.
      *             Deal details found in 'THEIR' fields.
      *             We pay them if effective int rate < floor rate.
      *             (our payments in UAITC & UAIPD).
      *             They pay us if effective int rate > ceiling rate
      *             (their payments in TAITC & TAIPD).
      * Sell collar = buying a floor and selling a cap.
      *             Deal details found in 'OUR' fields.
      *             We pay them if effective int rate > ceiling rate
      *             (our payments in UAITC & UAIPD).
      *             They pay us if effective int rate < floor rate.
      *             (their payments in TAITC & TAIPD).
 
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
     C                   PARM                    CFCOS
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * NO VALUE DATE POSITION EXTRACT IS REQUIRED IF MATURED
 
     C     I#TVDI        IFEQ      'V'
     C     T_MATI        ANDEQ     'Y'
     C                   RETURN
     C                   ENDIF
 
      * SETUP SETTLEMENT INSTRUCTIONS
 
     C                   EXSR      SETUP_SETI
 
 
      * 'ASSET' POSITION (Asset details only if a buy or a collar)
      * ----------------
 
     C     BYSL          IFEQ      'B'
     C     DTYP          OREQ      'RR'
 
     C                   MOVE      'A'           W#ASLI            1
 
      * IMPORT OPENING POSITION AND EVENTS
 
     C                   EXSR      IMPORT
 
      * PROCESS IMPORTED EVENTS
 
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
 
      * 'LIABILITY' POSITION (Liability details only if a sell or a collar)
      * --------------------
 
     C     BYSL          IFEQ      'S'
     C     DTYP          OREQ      'RR'
 
     C                   MOVE      'L'           W#ASLI
 
      * IMPORT OPENING POSITION AND EVENTS
 
     C                   EXSR      IMPORT
 
      * PROCESS IMPORTED EVENTS
 
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
 
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
     C                   CALLB     'GOSETCFCO'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    CFCOS
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETCFCO'
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
      ** ('our' if sell cap, buy floor, or sell collar)
      *
     C     BYSL          IFEQ      'S'
     C     DTYP          ANDEQ     'RP'
     C     BYSL          OREQ      'B'
     C     DTYP          ANDEQ     'RF'
     C     BYSL          OREQ      'S'
     C     DTYP          ANDEQ     'RR'
     C                   EXSR      OUR
     C                   ELSE
     C                   EXSR      THEIR
     C                   ENDIF
      *
      * Set up accrued interest to control date
      * and interest instructions
      * (according to whether asset - receiving - or liability - paying)
      *
     C     W#ASLI        IFEQ      'A'
     C                   Z-ADD     TAITC         W#AITC
     C                   MOVE      W#RECD        W#INTS
     C                   ELSE
     C                   Z-ADD     UAITC         W#AITC
     C                   MOVE      W#PAYD        W#INTS
     C                   ENDIF
 
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
 
     C     DTYP          IFNE      'RR'
 
     C     DTYP          OREQ      'RR'
     C     W#ASLI        ANDEQ     'A'
     C     UPPR          ANDEQ     'R'
 
     C     DTYP          OREQ      'RR'
     C     W#ASLI        ANDEQ     'L'
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
     C*****W#BRTT        IFNE      *ZERO                                                      CSD103
     C     W#BRTT        IFNE      *BLANKS                                                    CSD103
     C                   EXSR      IMP_BC_I
     C                   ENDIF
      *
      * IF FLOATING RATE
      * IMPORT BASE RATE CHANGE EVENTS
      *
     C*****W#BRTT        IFNE      *ZERO                                                      CSD103
     C     W#BRTT        IFNE      *BLANKS                                                    CSD103
     C     W#NICD        ANDNE     *ZERO
     C     W#NICD        ANDLT     MDAT
      *
      * IMPORT BASE RATE CHANGE EVENTS
      *
     C                   EXSR      IMP_BC
     C                   END
      *
      * IMPORT INTEREST PAYMENTS
      *
     C     W#IPFR        IFNE      *BLANK
     C                   EXSR      IMP_IP
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
      * Ceiling & Floor Rate
      *
      * If deal type is collar
     C     DTYP          IFEQ      'RR'
     C     W#ASLI        IFEQ      'A'
     C     BYSL          ANDEQ     'B'
     C     W#ASLI        OREQ      'L'
     C     BYSL          ANDEQ     'S'
     C                   Z-ADD     CLRAT         P_CLRT
     C                   Z-ADD     *ZERO         P_FLRT
     C                   ELSE
     C                   Z-ADD     9999.9999999  P_CLRT
     C                   Z-ADD     FLRAT         P_FLRT
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     CLRAT         P_CLRT
     C                   Z-ADD     FLRAT         P_FLRT
     C                   ENDIF
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
     C                   MOVEL     'Y'           E_SSET
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
     C                   TESTB     '0'           UDNSI                    99
     C  N99              TESTB     '0'           TDNSI                    99
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
     C                   TESTB     '3'           ACEI                     99    *
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
     C**********         Z-ADD     W#BRTT        E_BRTT                                       CSD103
     C                   MOVE      W#BRTT        E_BRTT                                       CSD103
      *
      * Rate Type
     C                   TESTB     '0'           W#DNSI                   99    *INITIAL RATE SET IN
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
      ** ELSE TAKE FUTURE RATE TO BE ZERO
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         E_IRAT
     C                   MOVEL     'A'           E_IRTP
     C                   END
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '0'           W#DNSI                   99
     C   99              MOVE      'Y'           E_PRCD
      *
      ** Import first base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT BASE RATE CHANGE EVENTS
      ********************************************************************
     C     IMP_BC        BEGSR
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
     C**********         Z-ADD     W#BRTT        E_BRTT                                       CSD103
     C                   MOVE      W#BRTT        E_BRTT                                       CSD103
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
      ** ELSE TAKE FUTURE RATE TO BE ZERO
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         E_IRAT
     C                   MOVEL     'A'           E_IRTP
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
      /SPACE 5
      ********************************************************************
      * IMPORT INTEREST PAYMENTS
      ********************************************************************
     C     IMP_IP        BEGSR
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
     C                   MOVE      UCUCY         W#CUCY            3
     C                   Z-ADD     UPAMT         W#PAMT           13 0
     C**********         Z-ADD     UBRTT         W#BRTT            2 0                        CSD103
     C                   MOVE      UBRTT         W#BRTT            2                          CSD103
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
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'THEIR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     THEIR         BEGSR
      *
     C                   MOVE      TCUCY         W#CUCY            3
     C                   Z-ADD     TPAMT         W#PAMT           13 0
     C**********         Z-ADD     TBRTT         W#BRTT            2 0                        CSD103
     C                   MOVE      TBRTT         W#BRTT            2                          CSD103
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
      ********************************************************************
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
