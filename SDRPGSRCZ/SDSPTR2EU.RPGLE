     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Calculate euro rates')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTR2EU - Calculate euro rates                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057   *CREATE   Date 30Oct00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      *
      * Currency codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Bank details Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * General Ledger Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** SWIFT currency code + Dealing Ccy Indicator
     D DLSW            DS
     D  #DLSW                         6
     D  #DLCY                         1    OVERLAY(#DLSW:1)
      ** SWIFT currency code + Dealing Ccy Indicator line 2
     D DLSW2           DS
     D  #DLSW2                             LIKE(#DLSW)
     D  #DLCY2                             OVERLAY(#DLSW2:1) LIKE(#DLCY)
 
      ** Parameters
     D WRECIP          S              1
     D #SPRA           S             14
     D #SMDIN          S                   LIKE(PIMDIN)
     D #SPRA2          S                   LIKE(#SPRA)
     D #SMDI2          S                   LIKE(PIMDIN)
 
      ** Working variables
     D #1SPRT          S                   LIKE(PISPRT)
     D #1INER          S                   LIKE(PIINER)
     D #1INMD          S              1
     D EuroTxt         S                   LIKE(#DLSW)
      *
      ** Init program
     C                   EXSR      INIPGM
      ** If flag euro rate is on then compute ccy rate against EURO
      **                                      ccy rate against base
     C                   SELECT
     C     WRECIP        WHENEQ    'Y'
     C                   EXSR      FRSTRT
     C                   EXSR      SCNDRT
      *
     C     WRECIP        WHENEQ    'N'
      ** Spot rate is determined by PISPRT
      ** ---------------------------------
     C                   MOVE      PIMDIN        #SMDIN
     C                   MOVEL     PIDLCI        #DLCY
     C                   MOVE      PISWCY        #DLSW
     C                   Z-ADD     PISPRT        #1SPRT
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1SPRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        #SPRA
      *
     C                   ENDSL
      *
     C                   RETURN
      *****************************************************************
      * INIPGM - Init program                                         *
      *****************************************************************
     C     INIPGM        BEGSR
      ** Reset output parameters
     C                   MOVEL     *BLANK        RetCodeIn
     C                   MOVEL     *BLANK        #SPRA
     C                   MOVEL     *BLANK        DLSW
     C                   MOVEL     *BLANK        #SMDIN
     C                   MOVEL     *BLANK        #SPRA2
     C                   MOVEL     *BLANK        DLSW2
     C                   MOVEL     *BLANK        #SMDI2
     C                   ENDSR
      *****************************************************************
      * FRSTRT - First rate                                           *
      *****************************************************************
     C     FRSTRT        BEGSR
      ** Spot rate is determined by A6INER, if null then defaulted
      ** ---------------------------------------------------------
     C     PIINER        IFEQ      *ZERO
     C                   EXSR      SRDEFT
     C                   MOVE      W#DEFI        #SMDIN
     C                   Z-ADD     W#DEFR        #1SPRT
     C                   ELSE
     C                   Z-ADD     PIINER        #1SPRT
     C                   MOVEL     PIINMD        #SMDIN
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1SPRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        #SPRA
      *
     C                   MOVEL     EuroTxt       #DLSW
     C                   ENDSR
      *****************************************************************
      * SCNDRT - Second rate                                          *
      *****************************************************************
     C     SCNDRT        BEGSR
     C     *LIKE         DEFINE    #1SPRT        SpotRate
     C     *LIKE         DEFINE    #SMDIN        MultDiv
      *
     C                   MOVEL     PIDLCI        #DLCY2
     C                   MOVE      PISWCY        #DLSW2
      *
      ** Recalculation Xrate OUT ccy vs IN Base
     C                   CALLB     'SDSPTR3EU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM      #1SPRT        SpotRate
     C                   PARM      #SMDIN        MultDiv
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
     C                   MOVE      #1INMD        #SMDI2
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      #1INER        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        #SPRA2
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRDEFT - Subroutine to do calculate the default value        *
      *           of 'Input Euro Rate' and 'Input Multiply/Divide     *
      *           Indicator' fields.                                  *
      *                                                               *
      *  Called By:                                                   *
      *  Calls:                                                       *
      *  *PSSR  - Error Control Program                               *
      *                                                               *
      *****************************************************************
      *
     C     SRDEFT        BEGSR
      *
      ** Initialise default Rate and Mult/Div Ind
     C                   Z-ADD     *ZERO         W#DEFR           13 8
     C                   MOVE      *BLANK        W#DEFI            1
      *
      ** 'OUT' Ccy/Base Ccy Spot Rate and Mult/Div Ind
     C                   Z-ADD     PISPRT        ZRATE1
     C                   MOVE      PIMDIN        ZMDI1
      *
      ** Reverse the Base Ccy EMU Mult/Divide Ind (A6EUMD)
     C     EUMDIN        IFEQ      'D'
     C                   MOVE      'M'           ZMDI2
     C                   ELSE
     C                   MOVE      'D'           ZMDI2
     C                   ENDIF
      *
      ** Base Ccy/EUR EMU Exchange Rate (A6EUER)
     C                   Z-ADD     EUSPRT        ZRATE2
      *
     C                   EXSR      ZXRATE
      *
      ** If the rate output is less than 1 (this must be the
      ** reciprocal rate), call SR/ZXRATE again with the input
      ** rate reversed to get the correct Spot Rate.
      *
     C                   MOVE      ZMDI1         W#DEFI
     C     ZRATEX        IFLT      1
      *
      ** SR/ZXRATE is of no use if the M/D indicator of the two currency
      ** is not the same.  (See SR/ZXRATE)
      *
     C     ZMDI2         ANDEQ     ZMDI1
      *
     C                   Z-ADD     EUSPRT        ZRATE1
     C                   Z-ADD     PISPRT        ZRATE2
     C                   EXSR      ZXRATE
     C     ZMDI1         IFEQ      'D'
     C                   MOVE      'M'           W#DEFI
     C                   ELSE
     C     ZMDI1         IFEQ      'M'
     C                   MOVE      'D'           W#DEFI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     ZRATEX        W#DEFR
      *
     C                   ENDSR
      *****************************************************************
      * RTVBCY - Retrieve base currency details                       *
      *****************************************************************
     C     RTVBCY        BEGSR
     C     *LIKE         DEFINE    A6EUER        EUSPRT
     C     *LIKE         DEFINE    A6EUMD        EUMDIN
      *
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFEQ      '*ERROR*'
     C     *IN90         OREQ      '1'
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'                           90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *IN90         OREQ      '1'
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     A6EUER        EUSPRT
     C                   MOVEL     A6EUMD        EUMDIN
      *
     C                   ENDSR
      *****************************************************************
      * RTVEUR - Retrieve EURO currency details                       *
      *****************************************************************
     C     RTVEUR        BEGSR
      *
      ** Access general ledger for Euro currency name
      *
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
 
      ** Retrieve Euro text
     C                   CALL      'SDC1460'
     C                   PARM      'SDM0085'     P@RTMI            7
     C                   PARM      'SDUSRMSG'    P@RTMF           10
     C                   PARM      BKEURO        P@RTMD          132
     C     EuroTxt       PARM      *BLANKS       P@RTT1          132
     C                   PARM      *BLANKS       P@RTT2          512
 
     C                   ENDSR
      *****************************************************************
      * ZXRATE - Compute exchange rate                                *
      *****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      ** Rate for IN base currency
     C                   PARM                    WRECIP
      ** Multiply/Divide indicator
     C                   PARM                    PIMDIN
      ** Spot Rate
     C                   PARM                    PISPRT
      ** OUT/EURO Exchange Rate
     C                   PARM                    PIINER
      ** OUT/EURO Multiply/Divide Ind
     C                   PARM                    PIINMD
      ** Dealing currency
     C                   PARM                    PIDLCI
      ** Swift currency code
     C                   PARM                    PISWCY
      * OUPUTS
      *
      ** Spot rate in screen format
     C                   PARM                    #SPRA
      ** Dealing currency + SWIFT currency
     C                   PARM                    DLSW
      ** Multiply/divide indicator
     C                   PARM                    #SMDIN
      ** Spot rate against dealing/base currency when #SPRA is
      ** expressed against BKEURO
     C                   PARM                    #SPRA2
      ** Dealing currency + SWIFT currency
     C                   PARM                    DLSW2
      ** Multiply/divide indicator for 2nd line
     C                   PARM                    #SMDI2
      *
     C     *LIKE         DEFINE    A6MDIN        PIMDIN
     C     *LIKE         DEFINE    A6SPRT        PISPRT
     C     *LIKE         DEFINE    A6INER        PIINER
     C     *LIKE         DEFINE    A6INMD        PIINMD
     C     *LIKE         DEFINE    A6DLCI        PIDLCI
     C     *LIKE         DEFINE    A6SWCY        PISWCY
      *
     C                   EXSR      RTVBCY
     C                   EXSR      RTVEUR
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      /COPY ZACPYSRC,PSSR_ILE
