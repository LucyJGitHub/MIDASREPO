     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate Base Ccy Equiv - Dealing')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZACALBED _ Calculate Base Ccy Equivalent - Dealing           *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
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
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFXCCYPLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDCCYPP0:FXCCYPL0)
     FFDCCYPLL  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
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
 
      ** Include the ZA standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @DC             S              4  0 DIM(4) CTDATA PERRCD(4)              Dec.Plcs Correct
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)             Scaling Factors
     D @AD             S              9  0 DIM(8) CTDATA PERRCD(1)              Adjust Decimal
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND       Year Days
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND     Month Days
 
     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YY                   3      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
     D  @@YYYY                 1      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
 
      ** External data structure for currency codes file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
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
      * Initialize outputs = Base ccy dealing and dealt spot base
      *
     C                   Z-ADD     0             @@DBCE                         base ccy dealing
     C                   Z-ADD     0             @@DSBC                         dealt spot base
      *
      ** Calculate the base currency for dealing amount
      *
     C                   MOVE      DDBCCY        @@CCY1            3
     C                   MOVE      DDSCCY        @@CCY2            3
     C                   EXSR      ZA0800
      *
      ** Calculate the dealt spot base currency equivalent
      *
     C                   Z-ADD     @@DAM1        @@DFA            15 0          first amt
     C                   Z-ADD     @@DAM2        @@DSA            15 0          secnd amt
     C                   MOVE      DDBCCY        @@DFC             3            first ccy
     C                   MOVE      DDSCCY        @@DSC             3            secnd ccy
     C*
     C                   EXSR      ZA0810
      *
      * RETURN
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      * ZA0800   - Calculate Dealt Base Equivalent                    *
      *****************************************************************
     C     ZA0800        BEGSR
      *
      ** IF EITHER CURRENCY IS BASE CURRENCY FOR DEALING SET BCFD
      ** EQUAL TO CORRESPONDING AMOUNT.
      *
     C     @@CCY1        IFEQ      BNCYDL
     C     @@CCY2        OREQ      BNCYDL
      *
     C                   Z-ADD     @CDP1         @@CDP1
     C                   Z-ADD     @CDP2         @@CDP2
      *
     C     @@CCY1        IFEQ      BNCYDL
     C                   Z-ADD     @@DAM1        @@DBCE           15 0
     C                   END
      *
     C     @@CCY2        IFEQ      BNCYDL
     C                   Z-SUB     @@DAM2        @@DBCE
     C                   END
      *
      ** IF NEITHER CURRENCY BCFD CALCULATE DBCE
      *
     C                   ELSE
      *
      * P R O C E S S   F I R S T   C U R R E N C Y
      *
     C                   Z-ADD     @CDP1         @@CDP1            1 0
     C                   MOVEL     @RDCY1        @RDCY1            1
     C                   Z-ADD     @@NDP1        A6NQDP            1 0
     C                   Z-ADD     @@SXP1        A6SCEX            1 0
     C                   MOVE      @@MDF1        A6MDIN            1
     C                   MOVE      @@MDX1        A6MDEX            1
     C                   Z-ADD     @@LSP1        A6LSPR           13 8
     C                   Z-ADD     @@HSP1        A6HSRT           13 8
     C                   Z-ADD     @@SPD1        A6FXSD            8 0
     C                   MOVE      @@CCY1        @@CCY             3
     C                   MOVE      'B'           @@BYSL            1
      *
      ** GET FORWARD OUTRIGHT RATE (@@MOR) AND M/D INDICATOR  (@@MDI1)
      *
     C                   EXSR      ZA0630
     C     *INU7         CABEQ     '1'           ZA0809
      *
      ** CALCULATE DBCE FOR DEAL FIRST CURRENCY AMOUNT
      *
     C     @@MDI1        IFEQ      'M'
     C     @@DAM1        MULT      @@MOR         @@DBC1           15 0
     C                   ELSE
     C     @@DAM1        DIV(H)    @@MOR         @@DBC1
     C                   END
      *
      ** ENSURE THAT DBCE FOR DEAL FIRST CURRENCY AMOUNT POSITIVE
      *
     C     @@DBC1        IFLT      0
     C                   Z-SUB     @@DBC1        @@DBC1
     C                   END
      *
      ** MUST ENSURE VALUE HAS DECIMAL PLACES AS BASE CURRENCY DP'S
      *
     C     @DLDP         SUB       @@CDP1        @@WDP
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@DBC1
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@DBC1
     C                   END
      *
      * P R O C E S S   S E C O N D  C U R R E N C Y
      *
     C                   Z-ADD     @CDP2         @@CDP2            1 0
     C                   MOVEL     @RDCY2        @RDCY2            1
     C                   Z-ADD     @@NDP2        A6NQDP            1 0
     C                   Z-ADD     @@SXP2        A6SCEX            1 0
     C                   MOVE      @@MDF2        A6MDIN            1
     C                   MOVE      @@MDX2        A6MDEX            1
     C                   Z-ADD     @@LSP2        A6LSPR           13 8
     C                   Z-ADD     @@HSP2        A6HSRT           13 8
     C                   Z-ADD     @@SPD2        A6FXSD            8 0
     C                   MOVE      @@CCY2        @@CCY             3
     C                   MOVE      'S'           @@BYSL
      *
      ** GET FORWARD OUTRIGHT RATE (@@MOR) AND M/D INDICATOR  (@@MDI1)
      *
     C                   EXSR      ZA0630
     C     *INU7         CABEQ     '1'           ZA0809
      *
      ** CALCULATE DBCE FOR DEAL SECOND CURRENCY AMOUNT
      *
     C     @@MDI1        IFEQ      'M'
     C     @@DAM2        MULT      @@MOR         @@DBC2           15 0
     C                   ELSE
     C     @@DAM2        DIV(H)    @@MOR         @@DBC2
     C                   END
      *
      ** ENSURE THAT DBCE FOR DEAL SECOND CURRENCY AMOUNT POSITIVE
      *
     C     @@DBC2        IFLT      0
     C                   Z-SUB     @@DBC2        @@DBC2
     C                   END
      *
      ** MUST ENSURE VALUE HAS DECIMAL PLACES AS BASE CURRENCY DP'S
      *
     C     @DLDP         SUB       @@CDP2        @@WDP
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@DBC2
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@DBC2
     C                   END
      *
      ** ADD TWO AMOUNTS TOGETHER AND DIVIDE BY TWO TO OBTAIN DBCE
      *
     C     @@DBC1        ADD       @@DBC2        @@DBCE
     C                   DIV(H)    2             @@DBCE
     C                   END
      *
     C     ZA0809        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0810   - Calculate Dealt Spot Rate                          *
      *****************************************************************
     C     ZA0810        BEGSR
      *
      **  CHECK WHETHER TO USE HIGH OR LOW SPOT RATE FOR BOTH CCY'S
      *
      **  CCY 1
      *
     C     @@MDX1        IFEQ      'D'
     C                   Z-ADD     @@LSP1        @@WRT1           13 8
     C                   ELSE
     C                   Z-ADD     @@HSP1        @@WRT1
     C                   END
      *
      **  CCY 2
      *
     C     @@MDX2        IFEQ      'M'
     C                   Z-ADD     @@LSP2        @@WRT2           13 8
     C                   ELSE
     C                   Z-ADD     @@HSP2        @@WRT2
     C                   END
      *
      **  I F  B O T H  C U R R E N C I E S  A R E  N O T  B A S E  C C Y
      *
     C     @@DFC         IFNE      BNCYDL
     C     @@DSC         ANDNE     BNCYDL
      *
     C     @@MDX1        IFEQ      'D'
     C     @@DFA         DIV(H)    @@WRT1        @@WA1            15 0
     C                   ELSE
     C     @@DFA         MULT(H)   @@WRT1        @@WA1
     C                   END
      *
      ** MUST ENSURE VALUE HAS DECIMAL PLACES AS BASE CURRENCY DP'S
      *
     C     @DLDP         SUB       @@CDP1        @@WDP             1 0
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@WA1
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@WA1
     C                   END
      *
      **  REPEAT FOR SECOND CCY
      **  CHECK WETHER TO RETRIEVE HIGH OR LOW SPOT RATE
      *
     C     @@MDX2        IFEQ      'D'
     C     @@DSA         DIV(H)    @@WRT2        @@WA2            15 0
     C                   ELSE
     C     @@DSA         MULT(H)   @@WRT2        @@WA2
     C                   END
      *
      **  MUST ENSURE WORK AMOUNT FIELD IS POSITIVE
     C     @@WA2         IFLT      0
     C                   Z-SUB     @@WA2         @@WA2
     C                   END
      *
      ** MUST ENSURE VALUE HAS DECIMAL PLACES AS BASE CURRENCY DP'S
      *
     C     @DLDP         SUB       @@CDP2        @@WDP             1 0
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@WA2
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@WA2
     C                   END
      *
      **  CALCULATE AVERAGE
      *
     C     @@WA1         ADD       @@WA2         @@DSBC           15 0
     C                   DIV(H)    2             @@DSBC
      *
      **  SKIP FURTHER PROCESSING
     C                   GOTO      ZA0819
     C                   END
      *
      **  E I T H E R   C U R R E N C Y  I S  B A S E  C C Y
      *
      *  IF VALUE DATE  = EITHER SPOT DATE
      *
     C     @@VDT         IFEQ      @@SPD1
     C     @@VDT         OREQ      @@SPD2
      *
      **  FIND BASE CCY AMOUNT OF DEAL
      *
     C     @@DFC         IFEQ      BNCYDL
     C                   Z-ADD     @@DFA         @@DSBC
     C                   ELSE
     C                   Z-ADD     @@DSA         @@DSBC
     C                   END
      *
      **  SKIP FURTHER PROCESSING
     C                   GOTO      ZA0818
     C                   END
      *
      ** OTHERWISE (VALUE DATE NOT EITHER SPOT DATE)
      *
      **  USE NON BASE CCY AMOUNT
      *
     C     @@DFC         IFNE      BNCYDL
     C                   Z-ADD     @@DFA         @@WA1
     C                   MOVE      @@MDX1        @@WMD             1
     C                   Z-ADD     @@CDP1        @@WDP
      *
      *  IF FWD POINTS ARE ZERO USE HIGH/LOW SPOT FROM FILE
      *
     C     @@DFP         IFEQ      *ZERO
     C                   Z-ADD     @@WRT1        @@WRT            13 8
     C                   ELSE
     C                   Z-ADD     @@DXR         @@WRT
     C                   END
      *
     C                   ELSE
     C                   Z-ADD     @@DSA         @@WA1
     C                   MOVE      @@MDX2        @@WMD
     C                   Z-ADD     @@CDP2        @@WDP
      *
      *  IF FWD POINTS ARE ZERO USE HIGH/LOW SPOT FROM FILE
      *
     C     @@DFP         IFEQ      *ZERO
     C                   Z-ADD     @@WRT2        @@WRT
     C                   ELSE
     C                   Z-ADD     @@DXR         @@WRT
     C                   END
     C                   END
      *
      **  MULTIPLY/DIVIDE NON BASE CCY AMOUNT BY RATE CALCULATED
      *
     C     @@WMD         IFEQ      'M'
     C     @@WA1         MULT(H)   @@WRT         @@DSBC
     C                   ELSE
     C     @@WA1         DIV(H)    @@WRT         @@DSBC
     C                   END
      *
      ** MUST ENSURE VALUE HAS DECIMAL PLACES AS BASE CURRENCY DP'S
      *
     C     @DLDP         SUB       @@WDP         @@WDP
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@DSBC
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@DSBC
     C                   END
      *
      ** ENSURE AMOUNT IS +VE
     C     ZA0818        TAG
     C     @@DSBC        IFLT      *ZERO
     C                   Z-SUB     @@DSBC        @@DSBC
     C                   END
     C     ZA0819        ENDSR
      *****************************************************************
      /EJECT
     C****************************************************************
     C* ZA0630 - CALCULATE THE FORWARD OUTRIGHT RATE                 *
     C****************************************************************
     C     ZA0630        BEGSR
      *
     C     *LIKE         DEFINE    A6SCEX        @@SFAC
     C     A6SCEX        ADD       1             @@SFAC
      *
     C     @@BYSL        IFEQ      'B'
     C*
     C** If multiply/divide indicator is 'M' move high spot rate to
     C** spot rate work field otherwise fill with low spot rate.
     C*
     C     A6MDEX        IFEQ      'M'
     C                   MOVE      A6HSRT        @@SPRT           13 8
     C                   ELSE
     C                   MOVE      A6LSPR        @@SPRT
     C                   END
     C                   END
     C*
     C     @@BYSL        IFEQ      'S'
     C*
     C** If multiply/divide indicator is 'M' move low spot rate to
     C** spot rate work field otherwise fill with high spot rate.
     C*
     C     A6MDEX        IFEQ      'M'
     C                   MOVE      A6LSPR        @@SPRT
     C                   ELSE
     C                   MOVE      A6HSRT        @@SPRT
     C                   END
     C                   END
     C*
     C** Store multiply/divide indicator for output from routine.
     C                   MOVE      A6MDEX        @@MDI1            1
     C*
     C**  Convert Spot rate to scaled rate
     C**  Determine forward points(@@FPT).
     C*
     C                   EXSR      ZA0700
     C*
     C** Calculate forward outright rate by adding high/low spot rate
     C** to forward points & then dividing the result by 10 to the
     C** power of NQDP (normally quoted decimal places).
     C*
     C     A6NQDP        IFNE      0
     C     @@FPT         DIV(H)    @AD(A6NQDP)   @@MOR                          Adjust F/Pts.
     C                   ELSE
     C                   Z-ADD     @@FPT         @@MOR                          Adjust F
     C                   END
     C*
     C     @@MOR         DIV(H)    @SF(@@SFAC)   @@MOR                          Adjust O RATE
     C                   ADD       @@SPRT        @@MOR            13 8          Fwd.O'Rt.Rate
     C*
     C     ZA0639        ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** ZA0700 - CALCULATE FORWARD POINTS
      *****************************************************************
     C     ZA0700        BEGSR
      *
      **  Find first record on file for currency.
      *
     C                   MOVE      *LOVAL        @@DTWF            8 0
      *
      **  Load key used to access LF/FXCCYPLL.
      *
     C     CCYLOW        KLIST
     C                   KFLD                    @@CCY
     C                   KFLD                    @@DTWF
     C     CCYLOW        SETLL     FXCCYPLL
     C                   READ      FXCCYPLL                               81
      *
      ** If currency for record has not been found
      ** then there is a database error.
      *
     C     @@CCY         IFNE      XPCCY
     C                   MOVEL     'FXCCYPLL'    DBFILE
     C                   MOVEL     '991'         DBASE
     C                   MOVEL     @@CCY         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** If the value date is spot date , or before the first record
      ** on file for the currency then the points are zero.
      *
     C     @@VDT         IFEQ      A6FXSD
     C     @@VDT         ORLT      XPPRDD
     C                   Z-ADD     0             @@FPT             7 2
     C                   GOTO      ZA0709
     C                   END
      *
      **  Load key used to access LF/FXCCYPLL.
      *
     C     CCYVDT        KLIST
     C                   KFLD                    @@CCY
     C                   KFLD                    @@VDT
     C     CCYVDT        SETLL     FXCCYPLL
     C                   READ      FXCCYPLL                               81
      *
      ** If currency has not been found check previous record.
      *
     C     @@CCY         IFNE      XPCCY
     C     *IN81         OREQ      '1'
      *
      ** IF *IN81 IS ON, EOF IS ENCOUNTERED AND NEED TO REPOSITION FILE
      ** TO EOF MARK AND RESET THE EOF STATUS SAVE UP BY SYSTEM.
      *
     C     *IN81         IFEQ      '1'
     C     CCYVDT        SETGT     FXCCYPLL
     C                   END
     C                   GOTO      ZA0708
     C                   END
      *
      ** Find midas day number of value date.
      *
     C                   Z-ADD     @@VDT         @@DTIN
     C     @@DTIN        IFNE      0
     C                   EXSR      ZA0680
     C                   ELSE
     C                   Z-ADD     0             @@MDNO
     C                   END
     C                   Z-ADD     @@MDNO        @@VDAT            5 0
      *
      ** IF record with = date found
      *
     C     @@VDT         IFEQ      XPPRDD
      *
      ** IF Type of period is not 'D'
     C     XPTPRD        IFNE      'D'
      *
      ** If the buy/sell rate indicator is 'B' & the currency multiply
      ** /divide exchange rate indicator is 'D' ,
      ** or 'S' & 'M' respectively,use low points otherwise use high
      ** points.
     C     @@BYSL        IFEQ      'B'
     C     A6MDIN        ANDEQ     'D'
     C                   MOVE      XPLOPT        @@FPT
     C                   GOTO      ZA0709
     C                   END
     C     @@BYSL        IFEQ      'S'
     C     A6MDIN        ANDEQ     'M'
     C                   MOVE      XPLOPT        @@FPT
     C                   GOTO      ZA0709
     C                   END
     C                   MOVE      XPHIPT        @@FPT
     C                   GOTO      ZA0709
     C                   END
      *
      ** The type of period is 'D'.
      ** Date is spot + 1 , spot - 1 or spot - 2 days.
      ** Linear interpolation or extrapolation used between one week
      ** rate & 0 on the spot date.
      *
      *
      ** Find the one week rate.
      ** Define search argument for chain to LF/FDCCYPLL.
     C                   MOVE      'W'           @@TPRD            1
     C                   Z-ADD     1             @@PRD             2 0
     C     WEEKRT        KLIST
     C                   KFLD                    @@CCY
     C                   KFLD                    @@TPRD
     C                   KFLD                    @@PRD
      *
      ** CHAIN TO FILE FDCCYPLL
      *
     C     WEEKRT        CHAIN     FDCCYPLL                           80
     C     XPDLTF        IFEQ      '*'
     C                   MOVE      '1'           *IN80
     C                   END
      *
      ** DEAL WITH DATA BASE ERROR
      *
     C     *IN80         IFEQ      '1'
     C                   MOVEL     'FDCCYPLL'    DBFILE
     C                   MOVEL     '992'         DBASE
     C                   MOVEL     @@CCY         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** If the buy/sell rate indicator is 'B' & the currency multiply
      ** /divide exchange rate indicator is 'D' ,
      ** or 'S' & 'M' respectively,use low points otherwise use high
      ** points.
      *
     C     @@BYSL        IFEQ      'B'
     C     A6MDIN        ANDEQ     'D'
     C                   MOVE      XPLOPT        @@FP2             7 2
     C                   ELSE
     C     @@BYSL        IFEQ      'S'
     C     A6MDIN        ANDEQ     'M'
     C                   MOVE      XPLOPT        @@FP2
     C                   ELSE
     C                   MOVE      XPHIPT        @@FP2
     C                   END
     C                   END
      *
      ** Find 1 week date & spot date as a day number.
      *
     C                   Z-ADD     XPPRDD        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@D2              5 0
     C                   Z-ADD     A6FXSD        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@FXSP            5 0
      *
      ** Forward points can now be calculated.
      *
     C     @@VDAT        SUB       @@FXSP        @@WF1            15 8
     C     @@FP2         MULT      @@WF1         @@WF1
     C     @@D2          SUB       @@FXSP        @@WF2             8 0
     C     @@WF1         DIV       @@WF2         @@FPT
     C                   GOTO      ZA0709
     C                   END
      *
      ** IF    record with > date found
      *
     C     XPPRDD        IFGT      @@VDT
      *
      ** If the buy/sell rate indicator is 'B' & the currency multiply
      ** /divide exchange rate indicator is 'D' ,
      ** or 'S' & 'M' respectively,use low points otherwise use high
      ** points.
      *
     C     @@BYSL        IFEQ      'B'
     C     A6MDIN        ANDEQ     'D'
     C                   MOVE      XPLOPT        @@FP2             7 2
     C                   ELSE
     C     @@BYSL        IFEQ      'S'
     C     A6MDIN        ANDEQ     'M'
     C                   MOVE      XPLOPT        @@FP2
     C                   ELSE
     C                   MOVE      XPHIPT        @@FP2
     C                   END
     C                   END
      *
      ** Find day number of date.
      *
     C                   Z-ADD     XPPRDD        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@D2              5 0
      *
      ** READ PREVIOUS record on LF/FXCCYPLL
      *
     C                   READP     FXCCYPLL                             8180
      *
      ** IF read prior was unsuccessful then there is a database error.
      *
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     'FXCCYPLL'    DBFILE
     C                   MOVEL     '993'         DBASE
     C                   MOVEL     @@CCY         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @@BYSL        IFEQ      'B'
     C     A6MDIN        ANDEQ     'D'
     C                   MOVE      XPLOPT        @@FP1             7 2
     C                   ELSE
     C     @@BYSL        IFEQ      'S'
     C     A6MDIN        ANDEQ     'M'
     C                   MOVE      XPLOPT        @@FP1
     C                   ELSE
     C                   MOVE      XPHIPT        @@FP1
     C                   END
     C                   END
      *
      ** Find day number of date.
      *
     C                   Z-ADD     XPPRDD        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@D1              5 0
      *
      ** Forward points can now be calculated.
      *
     C     @@FP2         SUB       @@FP1         @@WF1
     C     @@VDAT        SUB       @@D1          @@WF2
     C     @@WF1         MULT      @@WF2         @@WF1
     C     @@D2          SUB       @@D1          @@WF2
     C     @@WF1         DIV       @@WF2         @@WF1
     C     @@WF1         ADD(H)    @@FP1         @@FPT
     C                   GOTO      ZA0709
     C                   END
      *
      ** No record with > or = date has been found at this stage
      ** of processing so the points on the furthest forward
      ** record are used.
      ** Find the furthest forward record
      *
      ** READ PREVIOUS record on LF/FXCCYPLL
      *
     C     ZA0708        TAG
     C                   READP     FXCCYPLL                             8081
     C     @@CCY         IFNE      XPCCY
     C                   MOVE      '1'           *IN80
     C                   END
      *
      ** IF read prior was unsuccessful then there is a database error.
      *
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     'FXCCYPLL'    DBFILE
     C                   MOVEL     '994'         DBASE
     C                   MOVEL     @@CCY         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** If the buy/sell rate indicator is 'B' & the currency multiply
      ** /divide exchange rate indicator is 'D' ,
      ** or 'S' & 'M' respectively,use low points otherwise use high
      ** points.
      *
     C     @@BYSL        IFEQ      'B'
     C     A6MDIN        ANDEQ     'D'
     C                   MOVE      XPLOPT        @@FPT
     C                   GOTO      ZA0709
     C                   END
     C     @@BYSL        IFEQ      'S'
     C     A6MDIN        ANDEQ     'M'
     C                   MOVE      XPLOPT        @@FPT
     C                   GOTO      ZA0709
     C                   END
      *
     C                   MOVE      XPHIPT        @@FPT
      *
     C     ZA0709        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0680 - CONVERTS YYYYMMDD FORMAT DATE TO MIDAS DAY NUMBER    *
      *****************************************************************
     C     ZA0680        BEGSR
      *
     C                   Z-ADD     0             @@MDNO            5 0
      *
      **   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
      *
     C     @@YYYY        IFGE      2072
      *
      **    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0
     C     @@WK2         MULT      36524         @@MDNO
      *
      **  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO
     C                   END
      *
     C     @@YYYY        ADD       28            @@WK2
      *
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
      *
      **    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
      *
      **  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0
     C     @@MTH         ANDGT     2
     C                   ADD       1             @@MDNO
     C                   END
      *
      **  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0
     C                   ADD       @YD(@@REM)    @@MDNO
     C                   END
      *
      **  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
      *
      **  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C     ZA0689        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Buy  & Sell currencies
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * Date effective, exchange rate, forward points
      *
     C                   PARM                    @@VDT             8 0          value date
     C                   PARM                    @@DXR            13 8          exch rate
     C                   PARM                    @@DFP             7 2          forward pts
      *
      * Buy amount and Sell amount
      *
     C                   PARM                    @@DAM1           15 0          amount
     C                   PARM                    @@DAM2           15 0          amount
      *
      * buy: spot rate, ccy dec places, round down, norm quot decs
      *      scaling exponent, mult/div ind, mult/div ind-exch,
      *      low spot rate, high spot rate, FX spot date
      *
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @@MDX1            1            mult/div ind,exch
     C                   PARM                    @@LSP1           13 8          low spot rate
     C                   PARM                    @@HSP1           13 8          high spot rate
     C                   PARM                    @@SPD1            8 0          FX spot date
      *
      * sell: spot rate, ccy dec places, round down, norm quot decs
      *       scaling exponent, mult/div ind, mult/div ind-exch,
      *       low spot rate, high spot rate, FX spot date
      *
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @@MDX2            1            mult/div ind,exch
     C                   PARM                    @@LSP2           13 8          low spot rate
     C                   PARM                    @@HSP2           13 8          high spot rate
     C                   PARM                    @@SPD2            8 0          FX spot date
      *
      * ICD
     C                   PARM                    BNCYDL            3            mult/div ind
      *
      * OUTPUTS
      *
      * Base ccy dealing and dealt spot base
      *
     C                   PARM                    @@DBCE           15 0          base ccy dealing
     C                   PARM                    @@DSBC           15 0          dealt spot base
      *
      ** Get the currency decimal places of dealing base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BNCYDL        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** If error occurs...
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     BNCYDL        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        @DLDP             1 0
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  DECIMAL PLACES CORRECTION ARRAY   @DC
0001001001001000
** Scaling factors array - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
** @AD Adjust Decimals (for applying NQDP)
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
** @YD
00366007310109601461
** @MD
00000000310005900090001200015100181002120024300273003040033400365
