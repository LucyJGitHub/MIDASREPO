     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade Portfolio Exchange Rate Calculation')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETPTXRCAL - Trade Portfolio Exchange Rate Calculation       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 18Apr98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FPMHSEXPD  IF   E           K DISK
 
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
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      * Initialize outputs
      *
     C                   Z-ADD     0             SPXR
     C                   MOVEL     *BLANK        SPMD
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
      *
      * Calculate Trade Portfolio Exchange Rate
      *
     C                   EXSR      PTXRCAL
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * PTXRCAL - Calculate Trade Portfolio Exchange Rate             *
      *                                                               *
      *****************************************************************
     C     PTXRCAL       BEGSR
      *
      ** IF SETTLEMENT CURRENCY AND PORTFOLIO CURRENCY ARE THE SAME
      ** SET CROSS RATE TO 1 AND MULTIPLY/DIVIDE INDICATOR TO 'M'
      ** AND SKIP STRAIGHT TO RATE FORMATING
      *
     C     DDSETC        IFEQ      PortCcy
     C                   MOVE      'M'           ZCRSMD
     C                   Z-ADD     1             ZCRSRT
     C                   GOTO      FMTRAT
     C                   END
      *
      **  OBTAIN FX RATE AT TRADE DATE BETWEEN SETTLEMENT CURRENCY
      **  AND BASE CURRENCY FOR ACCOUNTING
      **  EXCEPT IF TRADE DATE IS EQUAL TO THE RUN DATE.
      *
     C     TDDT          IFNE      BJRDNB
     C                   MOVE      DDSETC        HSEXCY            3
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               44
     C     *IN44         IFEQ      '1'
     C     DDSETC        ORNE      Q8CCY
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               44
     C                   END
     C                   ELSE
     C                   SETON                                            44
     C                   END
      *
      * If rate not found, use spot rate for settlement currency
      *
     C     *IN44         IFEQ      '1'
     C     DDSETC        ORNE      Q8CCY
     C                   MOVE      DDSETC        @AJCD
     C                   EXSR      AOCURR
     C                   Z-ADD     A6SPRT        Q8SPOT
     C                   MOVE      A6MDIN        Q8MDV1
     C                   Z-ADD     A6NBDP        Q8CDP
     C                   END
      *
      **  SET 'FROM' DETAILS (SETTLEMENT CURRENCY) FOR ZCCYCN
      *
     C                   Z-ADD     Q8SPOT        ZRATEF
     C                   MOVE      Q8MDV1        ZMDINF
     C                   Z-ADD     Q8CDP         ZCDPF
     C                   MOVE      DDSETC        ZCCYF
      *
      **  OBTAIN FX RATE AT TRADE DATE BETWEEN PORTFOLIO CURRENCY
      **  AND BASE CURRENCY FOR ACCOUNTING
      **  EXCEPT IF TRADE DATE IS EQUAL TO THE RUN DATE.
      *
     C     TDDT          IFNE      BJRDNB
     C                   MOVE      PortCcy       HSEXCY
     C     HSEXKY        SETGT     PMHSEXPD
     C                   READP     PMHSEXPD                               44
     C     *IN44         IFEQ      '1'
     C     PortCcy       ORNE      Q8CCY
     C     HSEXKY        SETLL     PMHSEXPD
     C                   READ      PMHSEXPD                               44
     C                   END
     C                   ELSE
     C                   SETON                                            44
     C                   END
      *
      * If rate not found, use spot rate for portfolio currency
      *
     C     *IN44         IFEQ      '1'
     C     PortCcy       ORNE      Q8CCY
     C                   MOVE      PortCcy       @AJCD
     C                   EXSR      AOCURR
     C                   Z-ADD     A6SPRT        Q8SPOT
     C                   MOVE      A6MDIN        Q8MDV1
     C                   Z-ADD     A6NBDP        Q8CDP
     C                   END
      *
      **  SET 'TO' DETAILS (PORTFOLIO CURRENCY) FOR ZCCYCN
      *
     C                   Z-ADD     Q8SPOT        ZRATET
     C                   MOVE      Q8MDV1        ZMDINT
     C                   Z-ADD     Q8CDP         ZCDPT
     C                   MOVE      PortCcy       ZCCYT
      *
      **  CALCULATE CROSS RATE BETWEEN SETTLEMENT CURRENCY AND PORTFOLIO
      **  CURRENCY USING STANDARD SUBROUTINE ZCCYCN
      *
     C                   Z-ADD     0             ZAMTF
     C                   EXSR      ZCCYCN
      *
      ** Format the cross rate
      *
     C     FMTRAT        TAG
 
     C                   MOVE      ZCRSRT        SPXR
     C                   MOVE      ZCRSMD        SPMD
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      ZCRSRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDSPXR
     C                   MOVE      ZCRSMD        DDSPMD
 
     C     EPTXRCAL      ENDSR
      *****************************************************************
      /EJECT
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZCCYCN - Convert an amount into another currency              *
      *                                                               *
      *****************************************************************
     C     ZCCYCN        BEGSR
 
     C                   CALLB     'ZCCYCN'
 
      * INPUTS
 
      * Amount in 'FROM' currency (15P 0)                                      *
      * From Currency (3A)                                                     *
      * TO currency (3A)                                                       *
      * Spot Rate for 'FROM' currency (13P 8)                                  *
      * Spot Rate for 'TO' currency (13P 8)                                    *
      * Multiply/Divide Indicator for 'FROM' currency  (1A)                    *
      * Multiply/Divide Indicator for 'TO' currency (1A)                       *
      * Currency Decimal places for 'FROM' currency (1P 0)                     *
      * Currency Decimal places for 'TO' currency (1P 0)
     C                   PARM                    ZAMTF            15 0
     C                   PARM                    ZCCYF             3
     C                   PARM                    ZCCYT             3
     C                   PARM                    ZRATEF           13 8
     C                   PARM                    ZRATET           13 8
     C                   PARM                    ZMDINF            1
     C                   PARM                    ZMDINT            1
     C                   PARM                    ZCDPF             1 0
     C                   PARM                    ZCDPT             1 0
 
      * OUTPUTS
 
      * Amount in 'TO' Currency (i.e. Converted Amount) (15P 0)                *
      * Cross Exchange Rate (13P 8)
      * Cross Rate Multiply/Divide Indicator (1A)
 
     C                   PARM      *ZERO         ZAMTT            15 0
     C                   PARM      *ZERO         ZCRSRT           13 8
     C                   PARM      *BLANK        ZCRSMD            1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AOCURR - ACCESS CURRENCY DETAILS                             *
      *****************************************************************
     C     AOCURR        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM                    @AJCD             3                           S0111
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Trade details
      *  Settlement Currency
      *  Trade date
     C                   PARM                    DDSETC            3
     C                   PARM                    TDDT              5 0
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** Run date
     C                   PARM                    BJRDNB            5 0
 
      * OUTPUTS
 
      * Trade portfolio exchange rate
      * Trade portfolio exchange rate M/D ind
      * Trade portfolio exchange rate in screen format
      * Trade portfolio exchange rate M/D ind in screen format
     C                   PARM                    SPXR             13 8
     C                   PARM                    SPMD              1
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
 
 
     C     HSEXKY        KLIST                                                                 S0148
     C                   KFLD                    HSEXCY            3                           S0148
     C                   KFLD                    TDDT                                          S0148
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
