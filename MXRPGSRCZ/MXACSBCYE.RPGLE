     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Base Currency Equivalent Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBCYE - Access Base Currency Equivalent Amount           *
      *                                                               *
      *  Function:  This module derives a base currency equivalent of *
      *             an amount.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 241970             Data 05Sep06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDCUHSL2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of historic spot rates
     D MaxNoHsSR       C                   CONST(1000)
 
 
      * Key to historic spot ratea
     D #_CUHS          S              8    DIM(MaxNoHsSR)
      * Historic spot rates
     D #_CUHSDT        S             14    DIM(MaxNoHsSR)
 
 
      * Historic spot rates
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
 
 
      * Base Currency Equivalent Amount
     D BCYE          E DS                  EXTNAME(MXBCYEPD)
     D  Ccy_Date               1      8
 
 
     D                 DS
     D Date5A                  1      5A
     D                 DS
     D Date3A                  1      3A
     D Date05P                 1     03P 0
 
     D                 DS
     D Amt13_13A               1     13A
     D                 DS
     D Amt13_7A                1      7A
     D Amt13_13P               1      7P 0
 
     D                 DS
     D Amt15_15A               1     15A
     D                 DS
     D Amt15_8A                1      8A
     D Amt15_8AL1              8      8A
     D Amt15_15P               1      8P 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        Currency          3
     C                   MOVEL     I#LFD2        Date5A
     C                   MOVEL     I#LFD2        Date3A
     C                   MOVEL     I#LFD3        Amt13_13A
     C                   MOVEL     I#LFD3        Amt13_7A
     C                   MOVEL     I#LFD3        Amt15_15A
     C                   MOVEL     I#LFD3        Amt15_8A
 
      **Error*if*no*currency*is*supplied                                        CMX003
      **********************************                                        CMX003
     C*****Currency******IFEQ*******BLANK                                       CMX003
     C*******************EVAL******I#ERMS = 'BLANK CURRENCY'                    CMX003
     C*******************EXSR*******PSSR                                        CMX003
     C*******************ENDIF**********                                        CMX003
 
      * Error if no date is supplied
 
     C     Date5A        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK DATE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no amount is supplied
 
     C     Amt15_15A     IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK AMOUNT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Currency
 
     C                   MOVEL     I#LFD1        BECYCD
 
      * Date
 
     C                   TESTN                   Date5A               9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Date5A        BEDATE
     C                   ELSE
     C                   Z-ADD     Date05P       BEDATE
     C                   ENDIF
 
      *  Amount
 
     C                   Z-ADD     *ZERO         BEAMTC
 
     C                   TESTN                   Amt15_15A            9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Amt15_15A     BEAMTC
     C                   ELSE
     C                   TESTN                   Amt13_13A            9898
     C     *IN98         IFEQ      '1'
     C                   MOVEL     Amt13_13A     BEAMTC
     C                   ELSE
     C     Amt15_8AL1    IFEQ      *BLANK
     C                   Z-ADD     Amt13_13P     BEAMTC
     C                   ELSE
     C                   Z-ADD     Amt15_15P     BEAMTC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                CMX003
      * If the currency is not supplied                                         CMX003
                                                                                CMX003
     C     Currency      IFEQ      *BLANK                                       CMX003
     C                   Z-ADD     *ZERO         BECDP                          CMX003
     C                   Z-ADD     *ZERO         BECRAT                         CMX003
     C                   MOVEL     *BLANK        BECMDI                         CMX003
     C                   Z-ADD     *ZERO         BEBCYE                         CMX003
     C                   MOVEL     BJCYCD        BEBCCY                         CMX003
     C                   Z-ADD     BasCcyDec     BEBCDP                         CMX003
     C                   ELSE                                                   CMX003
 
      * Calculate Base Currency Equivalent Amount
 
     C                   EXSR      CAL_BCYE
                                                                                CMX003
     C                   ENDIF                                                  CMX003
 
      * Set up output data
 
     C                   EVAL      InData = BCYE
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Calculate Base Currency Equivalent Amount
      ********************************************************************
     C     CAL_BCYE      BEGSR
 
      * Look for a historic rate for the currency and date
 
     C                   Z-ADD     1             @IX               6 0
     C     Ccy_Date      LOOKUP    #_CUHS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CUHSDT(@IX) SDCUHS
     C                   ELSE
 
      * Access the historic spot rate
 
     C                   CLEAR                   SDCUHS
     C     SDCUHSKF      CHAIN     SDCUHSD0                           99        *
 
      * If the rate was not found for the supplied date
      * get the rate prior to this date
 
     C     *in99         IFEQ      '1'
     C     SDCUHSKF      SETLL     SDCUHSD0                                     *
     C*****SDCUHSKP      READPE    SDCUHSD0                               99    CMX003
     C     SDCUHSKP      READE     SDCUHSD0                               99    CMX003
     C                   ENDIF
 
      * If a rate prior to the supplied date was not found
      * use the first rate after the supplied date
 
     C     *in99         IFEQ      '1'
     C     SDCUHSKF      SETLL     SDCUHSD0                                     *
     C*****SDCUHSKP      READE     SDCUHSD0                               99    CMX003
     C     SDCUHSKP      READPE    SDCUHSD0                               99    CMX003
     C                   ENDIF
 
      * Save the historic spot rate details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CUHS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     Ccy_Date      #_CUHS(@IX)
     C                   MOVEL     SDCUHS        #_CUHSDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     Ccy_Date      #_CUHS(@CIX)
     C                   MOVEL     SDCUHS        #_CUHSDT(@CIX)
     C     @CIX          IFEQ      MaxNoHsSR
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * Set the conversion rate and multiply/divide indicator
 
     C                   Z-ADD     G2SPRT        BECRAT
     C                   MOVEL     G2MDIN        BECMDI
 
      * Get the currency details
 
     C                   MOVEL     BECYCD        I#LFD1
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
     C                   Z-ADD     A6NBDP        BECDP
 
      * Convert the amount into base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM      BEAMTC        ZAMTCI           15 0
     C                   PARM      BECRAT        ZEXCH            13 8
     C                   PARM      BECMDI        ZMD               1
     C                   PARM      BECYCD        ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      A6NBDP        ZCDPI             1 0
     C                   PARM      BasCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   Z-ADD     ZAMTCO        BEBCYE
     C                   MOVEL     BJCYCD        BEBCCY
     C                   Z-ADD     BasCcyDec     BEBCDP
 
     C                   ENDSR
      ********************************************************************
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
 
 
     C                   Z-ADD     *ZERO         @CIX              6 0
 
      * Key lists
 
     C     SDCUHSKF      KLIST
     C                   KFLD                    BECYCD
     C                   KFLD                    BEDATE
     C     SDCUHSKP      KLIST
     C                   KFLD                    BECYCD
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
