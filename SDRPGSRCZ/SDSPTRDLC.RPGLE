     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Default Exchange Rate Limit Ccy')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRDLC - Default Exchange Rate Limit Ccy                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057   *CREATE   Date 08Nov00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Currency codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR GENERAL LEDGER CURRENCY DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Working Variable
     D BaseCurrIn      S              1
      *
      ** Init program
     C                   EXSR      INIPGM
 
      *
      ** Retrieve limit currency details
     C                   IF        CcyLim = *BLANK
     C                   EVAL      LimCcyDtl = 'N'
     C                   ELSE
     C                   EXSR      LIMCCY
     C                   ENDIF
 
      ** Retrieve currency details
     C                   EXSR      CCYDTL
      ** Calculate Limit Rate and Multiply/Divide Indicator
     C                   EXSR      CALCLIM
 
     C                   RETURN
      *****************************************************************
      * CCYDTL - Retrieve currency details                            *
      *****************************************************************
     C     CCYDTL        BEGSR
      *
      ** Here we fill all the variables prefixed by AVxxxx
     C     *LIKE         DEFINE    A6INCY        AVINCY
     C     *LIKE         DEFINE    A6SPRT        AVSPRT
      *
     C                   CALLB     'AOCURRR0'                           90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCYCD        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *IN90         OREQ      '1'
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     A6INCY        AVINCY
     C                   Z-ADD     A6INER        AVINER
      *
      ** Take spot rate from the screen NOT from the file
      **                ---------------
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDSPRT        ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C                   IF        ZALIGNok = 'N'
     C                   MOVEL     DDSPRT        DBKEY
     C                   MOVEL     'ZALIGN'      DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZFIELD        AVSPRT
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * LIMCCY - Retrieve base currency limit details                 *
      *****************************************************************
     C     LIMCCY        BEGSR
     C     *LIKE         DEFINE    A6CYCD        CcyLim
     C     *LIKE         DEFINE    A6SPRT        CcyLimSprt
     C     *LIKE         DEFINE    A6MDIN        CcyLimMdin
     C                   MOVEL     'N'           LimCcyDtl         1
     C                   EVAL      CcyLimSprt = 0
     C                   EVAL      CcyLimMdin = *BLANK
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CcyLim        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RTCD <> *BLANK
     C                   GOTO      ELMCCY
     C                   ENDIF
 
     C                   IF        A6SPRT = 0
     C                   EVAL      LimCcyDtl = 'N'
     C                   ELSE
     C                   EVAL      LimCcyDtl = 'Y'
     C                   EVAL      CcyLimSprt = A6SPRT
     C                   EVAL      CcyLimMdin = A6MDIN
     C                   ENDIF
 
     C     ELMCCY        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * CALCLIM - Calculate Limit Rate and Multiply/Divide Indicator  *
      *****************************************************************
     C     CALCLIM       BEGSR
     C     *LIKE         DEFINE    A6INER        AVINER
     C     *LIKE         DEFINE    A6INER        #1INER
      ** Principle:
      ** We need to get the spot rate against base.
      *
      ** Depending the context we cannot use xxSPRT straigh away
      ** For instance when CEU002 is on and when SPSPTR1EU returns
      ** P@OutIn = 'Y', then the spot rate is expressed against BKEURO
      ** Therefore we need to perfom further computations in order to
      ** have this spot rate against Base Currency.
      *
      *
     C                   IF        CEU002 = 'N'
      ** Never be used in this S/R, tests done afterwards will prevent
      ** this.
     C                   Z-ADD     AVINER        #1INER
     C                   ELSE
      ** Assume its OUT against EURO and racalculate against base.
      ** After this S/R
      ** #INER no longer holds a Xrate against Euro but is actually
      ** expressed against base
     C                   EXSR      RECALC
     C                   ENDIF
      *
      ** Determine value of #1ERLC (UCSUBR simplified and revisited)
     C                   EXSR      DETERLC
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * INIPGM - Init program                                         *
      *****************************************************************
     C     INIPGM        BEGSR
      ** Reset output parameters
     C                   MOVEL     *BLANK        RetCodeIn
     C                   Z-ADD     0             #1ERLC
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RECALC - Recalculation Xrate OUT ccy vs IN Base               *
      *****************************************************************
     C     RECALC        BEGSR
      *
     C     *LIKE         DEFINE    A6INMD        #1INMD
     C     *LIKE         DEFINE    AVSPRT        SpotRate
     C     *LIKE         DEFINE    DDMDIN        MultDiv
      *
     C                   CALLB     'SDSPTR3EU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM      AVSPRT        SpotRate
     C                   PARM      DDMDIN        MultDiv
     C                   PARM                    #1INER
     C                   PARM                    #1INMD
     C     RetCodeIn     IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'SDSPTR3EU'   DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * DETERLC - Determine value of #1ERLC                           *
      *****************************************************************
     C     DETERLC       BEGSR
      * CASE: WRK.Base CCY Limits Found? is Yes
     C     LimCcyDtl     IFEQ      'Y'
      * CASE: WRK.Base Currency NE RCD.Currency Code
     C     BaseCcy       IFNE      DDCYCD
      * CASE: WRK.Base Currency for Limits NE RCD.Currency Code
     C     CcyLim        IFNE      DDCYCD
      * CASE: RCD.Multiply/Divide Indicator EQ WRK.Base Limits CCY M/D In
      *
     C     AVINCY        IFNE      'Y'
     C     BaseCurrIn    ANDEQ     'Y'
     C     DDCYCD        ANDNE     BKEURO
      *
     C     DDMDIN        IFEQ      CcyLimMdin
     C     #1INER        DIV(H)    CcyLimSprt    #1ERLC
     C                   ELSE
     C     #1INER        MULT(H)   CcyLimSprt    #1ERLC
     C                   ENDIF
     C                   ELSE
      *
     C     DDMDIN        IFEQ      CcyLimMdin
     C     AVSPRT        DIV(H)    CcyLimSprt    #1ERLC
     C                   ELSE
     C     AVSPRT        MULT(H)   CcyLimSprt    #1ERLC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * CASE: WRK.Base Currency EQ RCD.Currency Code
     C     BaseCcy       IFEQ      DDCYCD
     C     1             DIV(H)    CcyLimSprt    #1ERLC
     C                   END
      * CASE: WRK.Base Currency for Limits EQ RCD.Currency Code
     C     CcyLim        IFEQ      DDCYCD
     C                   Z-ADD     1             #1ERLC
     C                   ENDIF
     C                   ENDIF
     C     EDTERL        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * INPUTS
      *
      ** Return code
     C                   PARM                    RetCodeIn
      ** Limit ccy
     C                   PARM                    CcyLim
      ** Currency code
     C                   PARM                    DDCYCD
      ** Multiply /Divide Indicator
     C                   PARM                    DDMDIN
      ** Spot Rate
     C                   PARM                    DDSPRT           14
      *
      * OUTPUTS
      *
      ** Exchange Rate - Limit ccy
     C                   PARM                    #1ERLC
      *
     C     *LIKE         DEFINE    A6CYCD        DDCYCD
     C     *LIKE         DEFINE    A6MDIN        DDMDIN
     C     *LIKE         DEFINE    A6ERLC        #1ERLC
     C     *LIKE         DEFINE    BJCYCD        BaseCcy
      *
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   ENDIF
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   MOVEL     BJCYCD        BaseCcy
      *
      ** Access currency file for base rate details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up Base Currency In indicator
      *
     C                   CALLB     'SDSPTR4EU'
     C                   PARM                    ReturnCode
     C                   PARM      A6INCY        P@incy            1
     C                   PARM      A6TPSD        P@tpsd            5 0
     C     BaseCurrIn    PARM                    CurrIsIn          1
     C     ReturnCode    IFNE      *BLANKS
     C                   MOVEL     'SDSPTR4EU'   DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access general ledger for Euro currency name
      *
     C                   IF        CEU002 = 'Y'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
