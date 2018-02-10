     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access (SE) Book Position Balances')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBKPB - Access (Securities) Book Position Balances       *
      *                                                               *
      *  Function:  This module accesses book positions               *
      *             from BKPOSD.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Securities Book Position Balances
     D BKPBAL        E DS                  EXTNAME(MXBKPBPD)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
 
      ** Security Details
     D SECTY_DS      E DS                  EXTNAME(SECTYD)
     D SEC_MKPR      E                     EXTFLD(MKPR)
 
 
     D ZPRCIN          S             15P 8
     D ZFDATE          S              5P 0
     D ZNOML           S             15P 0
     D WRKPI           S             15P 9
     D SCUMEX          S              1A
     D ZYLDOk          S              1A
     D ZPRCOT          S             15P 8
 
 
      * Base Currency Equivalent Amount
     D BCYE          E DS                  EXTNAME(MXBCYEPD)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for CURRENCY details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_BPBA            3
     C                   MOVEL     I#LFD2        A_BPBK            2
     C                   MOVEL     I#LFD3        A_BPSC           10
     C                   MOVEL     I#LFD4        A_BPMK            1
     C                   MOVEL     I#LFD5        A_BPTV            1
 
      * Error if no branch is supplied
 
     C     A_BPBA        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BRANCH'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no book is supplied
 
     C     A_BPBK        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK BOOK'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no security is supplied
 
     C     A_BPSC        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK SECURITY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no market is supplied
 
     C     A_BPMK        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK MARKET'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no Trade/Value date basis is supplied
 
     C     A_BPTV        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK T/V DATE BASIS'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new book position
 
     C                   MOVEL     A_BPBA        BPBA
     C                   MOVEL     A_BPBK        BPBK
     C                   MOVEL     A_BPSC        BPSC
     C                   MOVEL     A_BPMK        BPMK
     C                   MOVEL     A_BPTV        BPTV
 
     C     BPBA          IFNE      P_BPBA
     C     BPBK          ORNE      P_BPBK
     C     BPSC          ORNE      P_BPSC
     C     BPMK          ORNE      P_BPMK
     C     BPTV          ORNE      P_BPTV
 
      * If new security, access securities details
 
     C     BPSC          IFNE      P_BPSC
     C                   EXSR      GET_SECUR
     C                   ENDIF
 
     C                   MOVEL     BPBA          P_BPBA
     C                   MOVEL     BPBK          P_BPBK
     C                   MOVEL     BPSC          P_BPSC
     C                   MOVEL     BPMK          P_BPMK
     C                   MOVEL     BPTV          P_BPTV
 
     C                   CLEAR                   BKPBAL
     C                   MOVEL     A_BPBA        BPBA
     C                   MOVEL     A_BPBK        BPBK
     C                   MOVEL     A_BPSC        BPSC
     C                   MOVEL     A_BPMK        BPMK
     C                   MOVEL     A_BPTV        BPTV
 
     C                   Z-ADD     *ZERO         Num_BkPsRcs       5 0
     C                   Z-ADD     CURSOM        Posn_Date
 
      * Get the starting position date from BKPOSD
 
     C     BKPOKYF       SETLL     BKPOSDF
     C     BKPOKYP       READPE    BKPOSDF                                99     *
 
      * If a position is found at or prior to the current
      * start of month date, start from the current start of month date
 
     C     *in99         IFEQ      '0'
     C                   Z-ADD     CURSOM        Posn_Date
     C                   ELSE
 
      * If no position is found at or prior to the current
      * start of month date, find the first position after this date
 
     C     BKPOKYF       SETLL     BKPOSDF
     C     BKPOKYP       READE     BKPOSDF                                99     *
      * If no records at all exist,
      * output a single position as at the current end of month date
      * Otherwise, start from the first position date found.
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     CUREOM        Posn_Date
     C                   ELSE
     C                   Z-ADD     BPPD          Posn_Date
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * If the current end of month is passed
      * or if maturity date is passed
      * then end
 
     C     Posn_Date     IFGT      CUREOM
     C     Num_BkPsRcs   ANDNE     *zero
     C     Posn_Date     ORGT      MATY
     C     *ZERO         ANDNE     MATY
     C     Num_BkPsRcs   ANDNE     *zero
 
     C                   MOVEL     '*EODATA'     I#RTCD
 
      * Otherwise (if the current end of month has not been passed)
 
     C                   ELSE
 
      * Set position date on output format
 
     C                   Z-ADD     Posn_Date     BPPD
 
      * If past maturity date then the position will be zero
 
     C     BPPD          IFGE      MATY
     C     *ZERO         ANDNE     MATY
     C                   Z-ADD     *ZERO         NPSN
     C                   Z-ADD     *ZERO         MKPR
     C                   Z-ADD     *ZERO         BKPR
     C                   Z-ADD     *ZERO         MVNC
     C                   Z-ADD     *ZERO         BVNC
     C                   Z-ADD     *ZERO         MVBC
     C                   Z-ADD     *ZERO         BVBC
     C                   ELSE
 
      * Get position as at the current position date
 
     C     BKPOKYF       CHAIN     BKPOSDF                            99         *
 
      * Get Market Price at current position date
 
     C                   EXSR      GET_MKPRIC
 
      * Set Book price
 
     C                   EVAL      BKPR = APPB
 
      * Calculate Market Value in Nominal Currency
 
     C                   EXSR      CALC_MKV_N
 
      * Set Book Value in Nominal Currency
 
     C                   EVAL      BVNC = APNC
 
      * Calculate Market Value in Base Currency
 
     C                   EXSR      CALC_MKV_B
 
      * Calculate Book Value in Base Currency
 
     C                   EXSR      CALC_BKV_B
 
     C                   ENDIF
 
     C                   ADD       1             Num_BkPsRcs
     C                   Z-ADD     Num_BkpsRcs   CNTM
 
 
      * Set up output data
 
     C                   EVAL      InData = BKPBAL
 
     C                   ADD       1             Posn_Date
 
     C                   ENDIF
 
      * Restore input parameters
 
     C                   EXSR      RST_INPARM
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * GET MARKET PRICE AS AT POSITION DATE
      ********************************************************************
     C     GET_MKPRIC    BEGSR
 
     C                   MOVEL     BPSC          Q_SNSN
     C                   MOVEL     'PR'          Q_SNET
     C                   Z-ADD     Posn_Date     Q_SNDT
 
     C     SECEKYF       SETLL     SNDEVDF
     C     SECEKYP       READE     SNDEVDF                                99     *
 
     C     *in99         IFEQ      '0'
     C                   EXSR      CNVYLD2PRC
     C                   ELSE
     C                   EVAL      MKPR = 0
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * CALCULATE MARKET VALUE IN NOMINAL CURRENCY
      ********************************************************************
     C     CALC_MKV_N    BEGSR
 
     C                   Z-ADD     NPSN          ZNOML
     C                   Z-ADD     MKPR          ZPRC
     C                   MOVEL     SPBS          ZSPBS
     C                   Z-ADD     NMDP          ZNMDP
 
     C                   CALLB     'ZCNSD'
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    ZSPBS             1
     C                   PARM                    ZNMDP             1 0
     C                   PARM                    NomCcyDec         1 0
 
      * OUTPUTS
      **  Consideration
     C                   PARM                    ZCONS            15 0
 
     C                   EVAL      MVNC = ZCONS
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * CALCULATE MARKET VALUE IN BASE CURRENCY
      ********************************************************************
     C     CALC_MKV_B    BEGSR
 
      * Access the base curency euivalent amount
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     NMCY          I#LFD1
     C                   MOVEL     *BLANK        I#LFD2
     C                   MOVEL     Posn_Date     I#LFD2
     C                   MOVEL     *BLANK        I#LFD3
     C                   MOVEL     MVNC          I#LFD3
     C                   CALLB     'MXACSBCYE'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error in the conversion
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CONVERSION:'
     C                             + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      BCYE = InData
     C                   EVAL      MVBC = BEBCYE
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * CALCULATE BOOK VALUE IN BASE CURRENCY
      ********************************************************************
     C     CALC_BKV_B    BEGSR
 
      * Access the base curency euivalent amount
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     NMCY          I#LFD1
     C                   MOVEL     *BLANK        I#LFD2
     C                   MOVEL     Posn_Date     I#LFD2
     C                   MOVEL     *BLANK        I#LFD3
     C                   MOVEL     BVNC          I#LFD3
     C                   CALLB     'MXACSBCYE'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error in the conversion
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CONVERSION:'
     C                             + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      BCYE = InData
     C                   EVAL      BVBC = BEBCYE
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * CONVERT YIELD TO %PRICE
      *****************************************************************
     C     CNVYLD2PRC    BEGSR
 
      ** Price/Discount/Yield
      ** Value Date
 
     C                   Z-ADD     SNPR          ZPRCIN
     C                   Z-ADD     SNDT          ZFDATE
 
      * Nominal
 
     C                   Z-ADD     NPSN          ZNOML
 
      ** Calculate PI as a fraction of Nominal
 
     C     NPSN          IFNE      0
     C     PILP          DIV       NPSN          WRKPI
     C                   ELSE
     C                   Z-ADD     0             WRKPI
     C                   END
 
      * Cum/Ex ind.
 
     C                   MOVE      'C'           SCUMEX
 
      ** Calculate % price from yield
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTY_DS
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM      *ZERO         ZPRCOT
 
     C                   EVAL      MKPR = ZPRCOT
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * GET_SECUR Get Security details
      ********************************************************************
     C     GET_SECUR     BEGSR
 
      * Access security and investment type details
 
     C     BPSC          CHAIN     SECTYDF                            99
     C     INVTPK        CHAIN     INVTPDF                            99
 
      * Get the nominal currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     NMCY          I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the currency was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:'
     C                             + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set currency decimal places
 
     C                   EVAL      SDCURR = InData
     C                   Z-ADD     A6NBDP        NomCcyDec         1 0
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * RESTORE INPUT PARAMETERS
      ********************************************************************
     C     RST_INPARM    BEGSR
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     *BLANK        I#LFD2
     C                   MOVEL     *BLANK        I#LFD3
     C                   MOVEL     *BLANK        I#LFD4
     C                   MOVEL     *BLANK        I#LFD5
     C                   MOVEL     A_BPBA        I#LFD1
     C                   MOVEL     A_BPBK        I#LFD2
     C                   MOVEL     A_BPSC        I#LFD3
     C                   MOVEL     A_BPMK        I#LFD4
     C                   MOVEL     A_BPTV        I#LFD5
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Base Currency Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL
 
     C                   MOVEL     *BLANK        P_BPSC           10
     C                   MOVEL     *BLANK        P_BPBA            3
     C                   MOVEL     *BLANK        P_BPBK            2
     C                   MOVEL     *BLANK        P_BPMK            1
     C                   MOVEL     *BLANK        P_BPTV            1
     C                   Z-ADD     *ZERO         Posn_Date         5 0
 
      * Book Positions key list
 
     C     BKPOKYF       KLIST
     C                   KFLD                    BPSC
     C                   KFLD                    BPBA
     C                   KFLD                    BPBK
     C                   KFLD                    BPMK
     C                   KFLD                    BPTV
     C                   KFLD                    Posn_Date
     C     BKPOKYP       KLIST
     C                   KFLD                    BPSC
     C                   KFLD                    BPBA
     C                   KFLD                    BPBK
     C                   KFLD                    BPMK
     C                   KFLD                    BPTV
 
      * Security Events key list
 
     C     SECEKYF       KLIST
     C                   KFLD                    Q_SNSN           10
     C                   KFLD                    Q_SNET            2
     C                   KFLD                    Q_SNDT            5 0
     C     SECEKYP       KLIST
     C                   KFLD                    Q_SNSN           10
     C                   KFLD                    Q_SNET            2
 
      * Investment type key list
 
     C     INVTPK        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
