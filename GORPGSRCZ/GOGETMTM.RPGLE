     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get Mark To Market Revaluation')              *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGETMTM - Get Mark To Market Revaluation                    *
      *                                                               *
      *  Function:  This program will get the Mark To Market          *
      *             Revaluation for FX or FRA.                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
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
      *                 CDL028             Date 07Feb05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDGF)
 
     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      **------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D ZWDTIN                  1      8S 0
     D  ZWYYYY                 1      4S 0
     D  ZWMTH                  5      6S 0
     D  ZWDAY                  7      8S 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D SDCOCC        E DS                  EXTNAME(SDCOCCPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program parameters
     D I#RTCD          S              7
     D I#ALIAS         S              4
     D I#DLNO          S              6S 0
     D PCCY1           S              3
     D PCCY2           S              3
     D PDAM1           S             15  0
     D PDAM2           S             15  0
     D PDBUY           S             15  0
     D PDSEL           S             15  0
     D PBCAE           S             15  0
     D PTYPE           S              2
     D PVDYY           S              4S 0
     D PVDMM           S              2S 0
     D PVDDD           S              2S 0
     D PDOEY           S              4S 0
     D PDOEM           S              2S 0
     D PDOED           S              2S 0
     D I#ERMS          S             50
     D MARKETVAL       S             15  0
     D VALCCY          S              3
 
     D PRetCode        S              7
     D POption         S              7
     D PCurrency       S              3
     D*PBRTT****       S              2                                                       CSD103
     D PBRTT           S              2A                                                      CSD103
     D W#RTCD          S              7
     D W#ERMS          S             50
     D BUYSELL         S              1
     D PDBCE           S             13  0
     D I#RDNB          S              5  0
     D I#DNWD          S              5  0
     D I#PCOD          S              5  0
     D I#AMRD          S              5  0
     D BaseCDP         S              1  0
     D BaseICB         S              1
     D PBaseCDP        S              1  0
     D PBaseICB        S              1
     D PYldBuy         S              5
     D PYldSel         S              5
     D REVA            S             13  0
     D RATE            S             13  8
     D PLAM            S             13  0
     D ZZMDNO          S              5  0
     D BUY_PLAM        S             13  0
     D SELL_PLAM       S             13  0
     D W#CUCY          S              3
     D W#PAMT          S             13  0
     D FixRate         S             11  7
     D FltRate         S             11  7
     D*W#BRTT***       S              2  0                                                    CSD103
     D W#BRTT          S              2                                                       CSD103
     D W#EINR          S             11  7
     D W#ICBS          S              1  0
     D W#INFD          S              5  0
     D W#IANP          S             13  0
     D W#RDS           S             13  0
     D SettleAmt       S             15  0
     D FltRateSet      S              1
     D FltRateTyp      S              1
     D W#DNSI          S              1
     D W#CCY           S              3
     D T_EDAT          S              5  0
     D PEDAT           S              5  0
     D W#AMT           S             13  0
     D WSkip           S              1
     D WRun            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   SELECT
 
      *  ******************************
      ** Process Foreign Exchange deals
      *  ******************************
 
     C                   WHEN      I#ALIAS = 'FXDL'  AND  PTYPE <> 'SW'
 
      ** Get base currency decimal places
 
     C                   MOVEL     BJCYCD        PCurrency
     C                   EXSR      SRCurr
     C                   MOVEL     A6NBDP        BaseCDP
     C                   MOVEL     A6DICB        BaseICB
 
      ** Set End Date
 
     C     PTYPE         IFEQ      'OP'
     C                   Z-ADD     PDOEY         ZWYYYY
     C                   Z-ADD     PDOEM         ZWMTH
     C                   Z-ADD     PDOED         ZWDAY
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN
     C                   PARM                    ZZMDNO
     C                   Z-ADD     ZZMDNO        T_EDAT
 
     C                   ELSE
     C                   Z-ADD     PVDYY         ZWYYYY
     C                   Z-ADD     PVDMM         ZWMTH
     C                   Z-ADD     PVDDD         ZWDAY
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN
     C                   PARM                    ZZMDNO
     C                   Z-ADD     ZZMDNO        T_EDAT
     C                   ENDIF
 
      ** Revalue the buy leg
 
     C                   EXSR      SRBuyCcy
     C                   MOVE      'B'           BUYSELL
     C                   EXSR      SRRevalue
     C                   Z-ADD     PLAM          BUY_PLAM
 
      ** Revalue the sell leg
 
     C                   EXSR      SRSelCcy
     C                   MOVE      'S'           BUYSELL
     C                   EXSR      SRRevalue
     C                   Z-ADD     PLAM          SELL_PLAM
 
      ** Market value
 
     C     BUY_PLAM      ADD       SELL_PLAM     MARKETVAL
     C                   MOVEL     BJCYCD        VALCCY
 
      *  *******************************
      ** Process Forward Rate Agreements
      *  *******************************
 
     C                   WHEN      I#ALIAS = 'FRAS'
 
     C     I#DLNO        CHAIN     DEALALL
     C                   IF        %FOUND(DEALALL)
 
      ** Get floating side fields
 
     C*****UBRTT         IFNE      *ZERO                                                      CSD103
     C     UBRTT         IFNE      *BLANKS                                                    CSD103
     C                   MOVE      UCUCY         W#CUCY
     C                   Z-ADD     UPAMT         W#PAMT
     C**********         Z-ADD     UBRTT         W#BRTT                                       CSD103
     C                   MOVE      UBRTT         W#BRTT                                       CSD103
     C                   Z-ADD     UEINR         W#EINR
     C                   Z-ADD     UICBS         W#ICBS
     C                   Z-ADD     UINFD         W#INFD
     C                   MOVE      UDNSI         W#DNSI
     C                   Z-ADD     TEINR         FixRate
 
     C                   ELSE
     C                   MOVE      TCUCY         W#CUCY
     C                   Z-ADD     TPAMT         W#PAMT
     C**********         Z-ADD     TBRTT         W#BRTT                                       CSD103
     C                   MOVE      TBRTT         W#BRTT                                       CSD103
     C                   Z-ADD     TEINR         W#EINR
     C                   Z-ADD     TICBS         W#ICBS
     C                   Z-ADD     TINFD         W#INFD
     C                   MOVE      TDNSI         W#DNSI
     C                   Z-ADD     UEINR         FixRate
     C                   ENDIF
 
      ** If initial rate set, use effective interest rate
 
     C                   TESTB     '0'           W#DNSI                   99
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           FltRateSet
     C                   MOVEL     'A'           FltRateTyp
     C                   Z-ADD     W#EINR        FltRate
     C                   ELSE
 
      ** Get extract control information
 
     C                   CALLB     'GOGETEXCT'
 
     C                   PARM      *BLANK        W#RTCD
     C                   PARM      *BLANK        W#ERMS
 
      ** Outputs
 
     C                   PARM      *ZERO         I#RDNB
     C                   PARM      *ZERO         I#DNWD
     C                   PARM      *ZERO         I#PCOD
     C                   PARM      *ZERO         I#AMRD
 
      ** Error detected  (*PSSR will end the program)
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOGETEXCT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If rate due for fixing, get current base rate
 
     C     W#INFD        IFLT      I#DNWD
     C                   MOVEL     W#CUCY        PCurrency
     C                   MOVEL     W#BRTT        PBRTT
     C                   EXSR      SRBranch
     C                   MOVEL     'Y'           FltRateSet
     C                   MOVEL     'C'           FltRateTyp
 
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        FltRate
     C                   ELSE
     C                   Z-ADD     BANBRT        FltRate
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     'N'           FltRateSet
     C                   MOVEL     ' '           FltRateTyp
     C                   Z-ADD     0             FltRate
     C                   EVAL      WSkip = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Calculate FRA settlement amount
 
     C                   IF        WSkip <> 'Y'
 
     C     UIPRD         IFNE      *ZERO
     C                   Z-SUB     UIPRD         SettleAmt
     C                   ELSE
 
     C     TIPRD         IFNE      *ZERO
     C                   Z-ADD     TIPRD         SettleAmt
     C                   ELSE
 
     C                   CALLB     'GOCALFRST'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM                    BYSL
     C                   PARM                    SETF
     C                   PARM                    VDAT
     C                   PARM                    MDAT
     C                   PARM                    W#PAMT
     C                   PARM                    FixRate
     C                   PARM                    FltRate
     C                   PARM                    W#ICBS
     C                   PARM      *ZERO         W#IANP
     C                   PARM      *ZERO         W#RDS
     C                   PARM      *ZERO         SettleAmt
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCALFRST'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Current Market Value
 
     C     FltRateSet    IFEQ      'Y'
     C                   Z-ADD     SettleAmt     MARKETVAL
     C                   ELSE
     C                   Z-ADD     UNRL          MARKETVAL
     C                   ENDIF
 
      ** Valuation Currency
 
     C                   MOVEL     UCUCY         VALCCY
     C                   ENDIF
 
     C                   ENDSL
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRevalue - Revalue amounts                                  *
      *****************************************************************
     C     SRRevalue     BEGSR
 
      ** If FX Valuation is by Forward Rate, call Forward Rate Revaluation Module
 
     C                   IF        CCFVFN = 'Y'
 
      ** Revalue currency amounts
 
     C                   CALLB     'GOFWDREVN'
     C                   PARM      *BLANKS       W#RTCD
     C                   PARM      *BLANKS       W#ERMS
     C                   PARM                    BUYSELL
     C                   PARM                    W#CCY
     C                   PARM      T_EDAT        PEDAT
     C                   PARM                    W#AMT
     C                   PARM      PBCAE         PDBCE
     C                   PARM                    BJRDNB
     C                   PARM                    BJCYCD
     C                   PARM      BaseCDP       PBaseCDP
     C                   PARM                    SDCURR
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Else, call Revaluation by NPV method module
 
     C                   ELSE
 
     C                   CALLB     'GONPVREVN'
      * Inputs
     C                   PARM      *BLANK        W#RTCD
     C                   PARM      *BLANK        W#ERMS
     C                   PARM                    BUYSELL
     C                   PARM                    PYldBuy
     C                   PARM                    PYldSel
     C                   PARM                    W#CCY
     C                   PARM      T_EDAT        PEDAT
     C                   PARM                    W#AMT
     C                   PARM      PBCAE         PDBCE
     C                   PARM                    I#RDNB
     C                   PARM                    BJCYCD
     C                   PARM      BaseCDP       PBaseCDP
     C                   PARM      BaseICB       PBaseICB
     C                   PARM                    SDCURR
      * Outputs
     C                   PARM      *ZERO         REVA
     C                   PARM      *ZERO         RATE
     C                   PARM      *ZERO         PLAM
      *
     C                   IF        W#RTCD = '*ERROR'
     C                   EVAL      W#ERMS = 'ERROR IN CALL TO GONPVREVN'
     C                   EVAL      DBMod = 'GONPVREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBuyCcy - Move buy currency details to work fields          *
      *****************************************************************
     C     SRBuyCcy      BEGSR
      *
     C                   MOVE      PCCY1         W#CCY
     C                   Z-ADD     PDBUY         W#AMT
     C     PTYPE         IFEQ      'OP'
     C     I#DLNO        CHAIN     FXDEALLL
     C                   IF        %FOUND(FXDEALLL)
     C                   Z-ADD     FHDAM1        W#AMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         PCurrency
     C                   EXSR      SRCurr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSelCcy - Move sell currency details to work fields         *
      *****************************************************************
     C     SRSelCcy      BEGSR
      *
     C                   MOVE      PCCY2         W#CCY
     C                   Z-ADD     PDSEL         W#AMT
     C     PTYPE         IFEQ      'OP'
     C     I#DLNO        CHAIN     FXDEALLL
     C                   IF        %FOUND(FXDEALLL)
     C                   Z-SUB     FHDAM2        W#AMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         PCurrency
     C                   EXSR      SRCurr
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  SRCurr - Access Currency Details
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    PRetCode
     C                   PARM      '*KEY    '    POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBranch -  Access Branch Details                            *
      *****************************************************************
     C     SRBranch      BEGSR
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*DBERR  '    PRetCode
     C                   PARM      '*KEY    '    POption
     C                   PARM                    PCurrency
     C                   PARM                    PBRTT
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initialisation subroutine                           *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD
     C                   PARM                    I#ALIAS
     C                   PARM                    I#DLNO
     C                   PARM                    PCCY1
     C                   PARM                    PCCY2
     C                   PARM                    PDBUY
     C                   PARM                    PDSEL
     C                   PARM                    PYldBuy
     C                   PARM                    PYldSel
     C                   PARM                    PBCAE
     C                   PARM                    PTYPE
     C                   PARM                    PVDYY
     C                   PARM                    PVDMM
     C                   PARM                    PVDDD
     C                   PARM                    PDOEY
     C                   PARM                    PDOEM
     C                   PARM                    PDOED
 
      ** OUTPUTS
     C                   PARM                    I#ERMS
     C                   PARM                    MARKETVAL
     C                   PARM                    VALCCY
 
      ** Initialise output fields
 
     C                   EVAL      I#ERMS = *BLANKS
     C                   EVAL      MARKETVAL = *ZERO
     C                   EVAL      VALCCY = *BLANKS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    PRetCode
     C                   PARM      '*FIRST  '    POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   EVAL      I#RTCD = *BLANKS
     C                   EVAL      I#ERMS = *BLANKS
     C                   EVAL      MARKETVAL = *ZERO
     C                   EVAL      VALCCY = *BLANKS
     C                   EVAL      WSkip = *BLANK
 
      ** Access Collateral and Credit Lines ICD
 
     C                   CALLB     'AOCOCCR0'
     C                   PARM      '*DBERR  '    PRetCode
     C                   PARM      '*FIRST  '    POption
     C     SDCOCC        PARM      SDCOCC        DSFDY
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      I#RTCD = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2004
