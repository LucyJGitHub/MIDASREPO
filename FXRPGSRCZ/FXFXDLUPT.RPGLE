     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals TM database update')                    *
      *****************************************************************
      *                                                               *
      *  Midas - FX Dealer Module                                     *
      *                                                               *
      *  FXFXDLUPT - FX DEALS TM DATABASE UPDATE                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 136434  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDL008 - Continuous Linked Settlement                        *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXVFXDLPD              *
      *  136434 - Treasury Management updates were missing from FX    *
      *                                                               *
      *****************************************************************

     FFDCCYPLL  IF   E           K DISK
     FFXREVHLL  IF   E           K DISK
     FFXEPOULL  UF A E           K DISK
     F                                     COMMIT
     FFXFWMULL  UF A E           K DISK
     F                                     COMMIT
     FFXFWDULL  UF A E           K DISK
     F                                     COMMIT
     FFXCRSCLL  IF   E           K DISK
     FFXEPOCLL  UF A E           K DISK
     F                                     RENAME(FXEPOSP0:FXEPOCL1)
     F                                     COMMIT

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

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

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

     D @DP             S              7  3 DIM(7) CTDATA PERRCD(7)
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D TAB1            S              4    DIM(12) CTDATA PERRCD(1)
     D TAB2            S              2    DIM(12) ALT(TAB1)
     D @FK             S             13    DIM(14) ASCEND


     D DATE1           DS
     D  @DATE1                 1      8
     D  @D1YY                  1      4
     D  @D1MM                  5      6
     D  @D1DD                  7      8

     D RUNS1           DS
     D  RUNA                   1      7
     D  @RUND                  1      2
     D  @RUNM                  3      5
     D  @RUNY                  6      7

     D FXVFXDL       E DS                  EXTNAME(FXVFXDLPD)
     D X_RSCY        E                     EXTFLD(F3RSCY)

     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)

     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0

     D                 DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0

     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0

     D @PRLOS          DS                  OCCURS(2)
     D  @PCCY                  1      3
     D  @SPLO                  4     18  0
     D  @FPLO                 19     33  0
     D  @ADJAD                34     34

     D @FBKE           DS            13
     D  @FBCY                  1      3
     D  @FBDT                  4     11
     D  @FBSQ                 12     13



      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
     D SDTRMA        E DS                  EXTNAME(SDTRMAPD)
      * DATA STRUCTURE FOR TREASURY MANAGEMENT DETAILS
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * DATA STRUCTURE FOR DEAL DATA
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * DATA STRUCTURE FOR CURRENCY DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
      *
      ** SET DEAL DETAILS
      *
     C                   EXSR      SETDLD
      *
      ** UPDATE FORWARD BOOK
      *
     C                   EXSR      UPDFB
      *
      ** UPDATE EQUIVALENT POSITIONS
      *
     C                   EXSR      UPDEQP
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
      ****************************************************************
      * UPDFB  - UPDATE FORWARD BOOK DETAILS
      ****************************************************************
     C     UPDFB         BEGSR
      *
      ** GET ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3VDYY        @D1YY
     C                   MOVE      F3VDMM        @D1MM
     C                   MOVE      F3VDDD        @D1DD
     C                   MOVE      @DATE1        @ACTD             8 0
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3DOEY        @D1YY
     C                   MOVE      F3DOEM        @D1MM
     C                   MOVE      F3DOED        @D1DD
     C                   MOVE      @DATE1        @ACTD
     C                   END
     C                   MOVE      @ACTD         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACTD5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTD5
     C                   END
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'Y'
     C     @VDAT5        ANDLT     BJRDNB
     C                   MOVE      BJRDNB        @ACTD5
     C                   END
      *
      ** GET BEFORE ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3BVDT        @ACTDB            8 0
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3BOTD        @ACTDB
     C                   END
     C                   MOVE      @ACTDB        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACDB5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @ACDB5
     C                   END
      *
      ** CONVERT VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3BVDT        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDTB5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @VDTB5
     C                   END
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'Y'
     C     @VDTB5        ANDLT     BJRDNB
     C                   MOVE      BJRDNB        @ACDB5
     C                   END
      *
      ** GET RELATED ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      *
     C     F3DTYP        IFEQ      'T'
     C     F3DTYP        OREQ      'S'
     C                   MOVE      F3RVDT        @ACTR
     C     F3DTYP        IFEQ      'T'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3ROTD        @ACTR             8 0
     C                   END
     C                   MOVE      @ACTR         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACDR5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @ACDR5
     C                   END
      *
      ** CONVERT RELATED VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3RVDT        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDTR5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @VDTR5
     C                   END
     C     F3DTYP        IFEQ      'T'
     C     EROVDI        ANDEQ     'Y'
     C     @VDTR5        ANDLT     BJRDNB
     C                   MOVE      BJRDNB        @ACDR5
     C                   END
     C                   END
      *
      ** Initialise forward book file keys array, process count
      ** and array index.
      *
     C                   MOVE      *BLANK        @FK
     C                   Z-ADD     *ZERO         @C                2 0
     C                   Z-ADD     *ZERO         @X                2 0
      *
      ** Set up forward book file keys array with currency/date/
      ** sequence number for each update required.
      ** (there will be up to 14 events)
      ** IF DELETE OR AMEND AND CHANGES
      *
     C                   MOVE      'N'           @DOFLG            1
     C     F3LACT        IFEQ      'D'
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C     F3LACT        IFEQ      'A'
     C     @BUYA         IFNE      F3DBUY
     C     @SELA         ORNE      F3DSEL
     C     @ACTD5        ORNE      @ACDB5
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C                   END
      *
      **   i) check if deletion of old deal amounts, etc is
      *
     C     @DOFLG        IFEQ      'Y'
     C     @ACDB5        ANDGE     BJRDNB
      *
      **   set up key for buy currency before record.
      *
     C                   MOVE      F3BBCY        @FBCY
     C                   MOVE      @ACDB5        @FBDT
     C                   MOVE      '01'          @FBSQ
     C                   MOVE      @FBKE         @FK(1)
     C                   ADD       1             @C
      *
      **   set up key for sell currency before record.
      *
     C                   MOVE      F3BSCY        @FBCY
     C                   MOVE      @ACDB5        @FBDT
     C                   MOVE      '02'          @FBSQ
     C                   MOVE      @FBKE         @FK(2)
     C                   ADD       1             @C
     C                   END
      *
      **  ii) if old deal is a swap, check if deletion of
      **      related deal amounts, etc is required.
      *
     C     F3DTYP        IFEQ      'S'
     C     F3LACT        ANDEQ     'D'
     C     @ACDR5        ANDGE     BJRDNB
      *
      **  set up key for related buy currency record.
      *
     C                   MOVE      F3RBCY        @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '03'          @FBSQ
     C                   MOVE      @FBKE         @FK(3)
     C                   ADD       1             @C
      *
      **  set up key for related sell currency record.
      *
     C                   MOVE      F3RSCY        @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '04'          @FBSQ
     C                   MOVE      @FBKE         @FK(4)
     C                   ADD       1             @C
     C                   END
      *
      ** IF INSERT OR AMEND WITH CHANGES
      *
     C                   MOVE      'N'           @DOFLG
     C     F3LACT        IFEQ      'I'
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C     F3LACT        IFEQ      'A'
     C     @BUYA         IFNE      F3DBUY
     C     @SELA         ORNE      F3DSEL
     C     @ACTD5        ORNE      @ACDB5
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C                   END
      *
      ** iii) check if insertion of new deal amounts, etc is
      **      required.
      *
     C     @DOFLG        IFEQ      'Y'
     C     @ACTD5        ANDGE     BJRDNB
      *
      **  set up key for new buy currency record.
      *
     C                   MOVE      @BUYC         @FBCY
     C                   MOVE      @ACTD5        @FBDT
     C                   MOVE      '05'          @FBSQ
     C                   MOVE      @FBKE         @FK(5)
     C                   ADD       1             @C
      *
      **  set up key for new sell currency record.
      *
     C                   MOVE      @SELC         @FBCY
     C                   MOVE      @ACTD5        @FBDT
     C                   MOVE      '06'          @FBSQ
     C                   MOVE      @FBKE         @FK(6)
     C                   ADD       1             @C
     C                   END
      *
      ** IF DEAL IS A TAKEDOWN
      *
     C     F3DTYP        IFEQ      'T'
     C     @ACDR5        ANDGE     BJRDNB
      *
      **  iv) check if insertion of takedown - ie. removal of
      **      part of option.
      *
     C     F3LACT        IFEQ      'I'
      *
      **  set up key for new option buy currency record.
      *
     C                   MOVE      @BUYC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '07'          @FBSQ
     C                   MOVE      @FBKE         @FK(7)
     C                   ADD       1             @C
      *
      **  set up key for new option sell currency record.
      *
     C                   MOVE      @SELC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '08'          @FBSQ
     C                   MOVE      @FBKE         @FK(8)
     C                   ADD       1             @C
     C                   END
      *
      **   v) check if deletion of takedown - ie. re-addition
      **      of part of option.
      *
     C     F3LACT        IFEQ      'D'
      *
      **  set up key for old option buy currency record.
      *
     C                   MOVE      @BUYC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '09'          @FBSQ
     C                   MOVE      @FBKE         @FK(9)
     C                   ADD       1             @C
      *
      **  set up key for old option sell currency record.
      *
     C                   MOVE      @SELC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '10'          @FBSQ
     C                   MOVE      @FBKE         @FK(10)
     C                   ADD       1             @C
     C                   END
      *
      **  vi) check if amendment of takedown with changes.
      *
     C     F3LACT        IFEQ      'A'
     C     @BUYA         IFNE      F3DBUY
     C     @SELA         ORNE      F3DSEL
     C     @ACTD5        ORNE      @ACDB5
      *
      **  set up key for old option buy currency record.
      *
     C                   MOVE      F3BBCY        @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '11'          @FBSQ
     C                   MOVE      @FBKE         @FK(11)
     C                   ADD       1             @C
      *
      **  set up key for old option sell currency record.
      *
     C                   MOVE      F3BSCY        @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '12'          @FBSQ
     C                   MOVE      @FBKE         @FK(12)
     C                   ADD       1             @C
      *
      **  set up key for new option buy currency record.
      *
     C                   MOVE      @BUYC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '13'          @FBSQ
     C                   MOVE      @FBKE         @FK(13)
     C                   ADD       1             @C
      *
      **  set up key for new option sell currency record.
      *
     C                   MOVE      @SELC         @FBCY
     C                   MOVE      @ACDR5        @FBDT
     C                   MOVE      '14'          @FBSQ
     C                   MOVE      @FBKE         @FK(14)
     C                   ADD       1             @C
     C                   END
     C                   END
     C                   END
      *
      ** Sort forward book file keys array in ascending order.
      ** (SORTA will place empty elements at front of array)
      *
     C                   SORTA     @FK
      *
      ** Calculate array index of first required event.
      *
     C     15            SUB       @C            @X
      *
      ** Execute DO processing for the number of required events.
      *
     C                   DO        @C
      *
      ** Move array element into array element data structure.
      *
     C                   MOVE      @FK(@X)       @FBKE
      *
      **   i) deletion of old deal amounts, etc.
      **    FOR BUY CCY BEFORE AMOUNTS ETC.
      *
     C     @FBSQ         IFEQ      '01'
     C                   MOVE      'R'           @RREV             1
     C                   MOVE      F3BBCY        @RCCY             3
     C                   MOVE      F3DBUY        @RAMT            15 0
     C                   MOVE      @DEALB        @RBCD            15 0
     C                   MOVE      @ACDB5        @RACT             8 0
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  FOR SELL CCY BEFORE AMOUNTS ETC.
      *
     C     @FBSQ         IFEQ      '02'
     C                   MOVE      'R'           @RREV
     C                   MOVE      F3BSCY        @RCCY
     C                   MOVE      F3DSEL        @RAMT
     C                   MOVE      @DEALB        @RBCD
     C                   MOVE      @ACDB5        @RACT
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  ii) deletion of related deal amounts, etc for swap.
      **     FOR RELATED BUY CCY
      *
     C     @FBSQ         IFEQ      '03'
     C                   MOVE      'R'           @RREV
     C                   MOVE      F3RBCY        @RCCY
     C                   MOVE      F3RBAT        @RAMT
     C                   MOVE      @RDELB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **    FOR RELATED SELL CCY
      *
     C     @FBSQ         IFEQ      '04'
     C                   MOVE      'R'           @RREV
     C                   MOVE      F3RSCY        @RCCY
     C                   Z-SUB     F3RSAT        @RAMT
     C                   MOVE      @RDELB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      ** iii) insertion of new deal amounts, etc.
      **      FOR BUY CCY
      *
     C     @FBSQ         IFEQ      '05'
     C                   MOVE      ' '           @RREV
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACTD5        @RACT
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **    FOR SELL CCY
      *
     C     @FBSQ         IFEQ      '06'
     C                   MOVE      ' '           @RREV
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACTD5        @RACT
     C                   EXSR      UPDFBD
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  iv) insertion of takedown - use 'removal of option
      **      FOR BUY CCY CURRENT AMOUNTS
      *
     C     @FBSQ         IFEQ      '07'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN           10 9
     C                   MOVE      ' '           @RREV
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   MOVE      @B12          @R12              1
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   MOVE      F3DAM1        @RTPA1           15 0
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **    FOR SELL CCY CURRENT AMOUNTS
      *
     C     @FBSQ         IFEQ      '08'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      ' '           @RREV
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   MOVE      @S12          @R12              1
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **   v) deletion of takedown - use 'removal of option
      **     FOR BUY CCY
      *
     C     @FBSQ         IFEQ      '09'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      'R'           @RREV
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   MOVE      @B12          @R12
     C                   MOVE      @DEALB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **   FOR SELL CCY
      *
     C     @FBSQ         IFEQ      '10'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      'R'           @RREV
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   MOVE      @S12          @R12
     C                   MOVE      @DEALB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  vi) amendment of takedown with changes.
      **   FOR BUY CCY BEFORE
      *
     C     @FBSQ         IFEQ      '11'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     @AMT1B        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      'R'           @RREV
     C                   MOVE      F3BBCY        @RCCY
     C                   MOVE      F3DBUY        @RAMT
     C                   MOVE      @B12          @R12
     C                   MOVE      @DEALB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   MOVE      @AMT1B        @RTPA1
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  FOR SELL CCY
      *
     C     @FBSQ         IFEQ      '12'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     @AMT1B        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      'R'           @RREV
     C                   MOVE      F3BSCY        @RCCY
     C                   MOVE      F3DSEL        @RAMT
     C                   MOVE      @S12          @R12
     C                   MOVE      @DEALB        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      **  FOR BUY CCY
      *
     C     @FBSQ         IFEQ      '13'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      ' '           @RREV
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   MOVE      @B12          @R12
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   MOVE      F3DAM1        @RTPA1
     C                   EXSR      UPDFBO
     C                   GOTO      UPDFB_TAG
     C                   END
      *
      ** FOR SELL CCY
      *
     C     @FBSQ         IFEQ      '14'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
     C                   MOVE      ' '           @RREV
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   MOVE      @S12          @R12
     C                   MOVE      F3BCDE        @RBCD
     C                   MOVE      @ACDR5        @RACT
     C                   EXSR      UPDFBO
     C                   END

     C     UPDFB_TAG     TAG

     C                   ADD       1             @X
     C                   END

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPDFBD UPDATE FORWARD BOOK DAILY SCHEDULE
      ****************************************************************
     C     UPDFBD        BEGSR
      *
      ** ACCESS FXFWDULL
      *
     C     KEY5          KLIST
     C                   KFLD                    FPCCY
     C                   KFLD                    FPFWBY
     C                   KFLD                    FPFWBM
     C                   KFLD                    FPFWBD
      *
      ** CONVERT ACTION DATE TO YYYYMMDD FORM
      *
     C                   MOVE      @RACT         @@DAYN            5 0
     C     @@DAYN        IFNE      *ZEROS
     C                   EXSR      ZA0710
     C                   MOVE      @@VDT         @RACT8            8 0
     C                   ELSE
     C                   MOVE      *ZEROS        @RACT8
     C                   END
     C                   MOVE      @RACT8        @DATE1
     C                   MOVE      @D1YY         FPFWBY
     C                   MOVE      @D1MM         FPFWBM
     C                   MOVE      @D1DD         FPFWBD
     C                   MOVE      @RCCY         FPCCY
     C     KEY5          CHAIN     FXFWDULL                           64
     C     *IN64         IFEQ      '1'
      *
      ** CREATE A ZERO RECORD FOR FXFWDDP0
      *
     C                   MOVE      'FP'          FPRCID
     C                   MOVE      *BLANKS       FPDLTF
     C                   MOVE      @RUND         FPDLUP
     C                   MOVE      @RUNM         FPMLUP
     C                   MOVE      @RUNY         FPYLUP
     C                   TIME                    FPTLUP
     C                   MOVE      'I'           FPCHTP
     C                   MOVE      BJRDNB        FPLCD
     C                   MOVEL     PSUser        FPLUID
     C                   MOVE      *ZEROS        FPDYCI
     C                   MOVE      *ZEROS        FPDYCO
     C                   MOVE      *ZEROS        FPDYNM
     C                   MOVE      *ZEROS        FPDYDE
     C                   END
      *
      **  CALCULATE 'OLD' PROFIT/LOSS
      *
     C                   MOVE      @DATE1        @@VDT
     C                   Z-ADD     FPDYNM        @@AMT
     C                   Z-ADD     FPDYDE        @@DBCE
     C                   MOVE      FPCCY         @@CCY
     C     FPDYNM        IFLT      0
     C                   MOVE      'B'           @@BYSL
     C                   ELSE
     C                   MOVE      'S'           @@BYSL
     C                   END
      *
      ** ACCESS CURRENCY RECORD IN PREPARATION FOR ZA0620
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FPCCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FPCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** CALCULATE THE REVALUATION PROFIT AND LOSS
      *
     C                   MOVEL     A6MDEX        XRMD
     C                   Z-ADD     A6NBDP        CDP
     C                   EXSR      ZA0620
      *
      ** SAVE THE 'OLD' PROFIT/LOSS FOR CURRENCY
      *
     C                   Z-ADD     @@RPL         @OPL
      *
      ** DAILY CASH IN AND OUT
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
     C     @RAMT         IFGE      0
     C     FPDYCI        ADD       @RAMT         FPDYCI
     C                   ELSE
     C     FPDYCO        SUB       @RAMT         FPDYCO
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
     C     @RAMT         IFGE      0
     C     FPDYCI        SUB       @RAMT         FPDYCI
     C                   ELSE
     C     FPDYCO        ADD       @RAMT         FPDYCO
     C                   END
     C                   END
      *
      ** DAILY NET MOVEMENT
      *
     C     FPDYCI        SUB       FPDYCO        FPDYNM
      *
      ** DAILY NET DEALT BASE CCY EQUIV
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
     C     @RAMT         IFGE      0
     C     FPDYDE        ADD       @RBCD         FPDYDE
     C                   ELSE
     C     FPDYDE        SUB       @RBCD         FPDYDE
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
     C     @RAMT         IFGE      0
     C     FPDYDE        SUB       @RBCD         FPDYDE
     C                   ELSE
     C     FPDYDE        ADD       @RBCD         FPDYDE
     C                   END
     C                   END
     C     *IN64         IFEQ      '0'
     C                   MOVE      @RUND         FPDLUP
     C                   MOVE      @RUNM         FPMLUP
     C                   MOVE      @RUNY         FPYLUP
     C                   TIME                    FPTLUP
     C                   MOVE      'A'           FPCHTP
     C                   MOVE      BJRDNB        FPLCD
     C                   MOVEL     PSUser        FPLUID
     C                   UPDATE    FXFWDDP0
     C                   ELSE
     C                   WRITE     FXFWDDP0
     C                   END
      *
      **  CALCULATE 'NEW' PROFIT/LOSS
      *
     C                   MOVE      @DATE1        @@VDT
     C                   Z-ADD     FPDYNM        @@AMT
     C                   Z-ADD     FPDYDE        @@DBCE
     C                   MOVE      FPCCY         @@CCY
     C     FPDYNM        IFLT      0
     C                   MOVE      'B'           @@BYSL
     C                   ELSE
     C                   MOVE      'S'           @@BYSL
     C                   END
      *
      ** ACCESS CURRENCY RECORD IN PREPERATION FOR ZA0620
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FPCCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FPCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** CALCULATE THE REVALUATION PROFIT AND LOSS
      *
     C                   MOVEL     A6MDEX        XRMD
     C                   Z-ADD     A6NBDP        CDP
     C                   EXSR      ZA0620
      *
      ** SAVE THE 'NEW' PROFIT/LOSS FOR CURRENCY
      *
     C                   Z-ADD     @@RPL         @NPL
      *
      **  CALCULATE ADJUSTMENT AND STORE IN MULT OCC. DS. EITHER
      **  SHORT OR FORWARD FIELD
      ** DETERMINE IF FIRST OR SECOND CURRENCY BEING PROCESSED AND
      ** SET DATA STRUCTURE OCCURANCE AS APPROPRIATE
      *
     C     1             OCCUR     @PRLOS
     C     FPCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** IF ACTION FALLS WITHIN ONE MONTH DATE (@FWD5) ADD P/L INTO
      ** SHORT P/L, ELSE ADD INTO FORWARD P/L
      *
     C     @ACTD5        IFGE      BJRDNB
     C     @ACTD5        ANDLE     @FWD5
     C     @NPL          SUB       @OPL          @PLADJ
     C                   ADD       @PLADJ        @SPLO
     C                   END
     C     @ACTD5        IFGT      @FWD5
     C     @NPL          SUB       @OPL          @PLADJ
     C                   ADD       @PLADJ        @FPLO
     C                   END
      *
      ** ACCESS FXFWMULL
      *
     C     KEY6          KLIST
     C                   KFLD                    FQCCY
     C                   KFLD                    FQFWBY
     C                   KFLD                    FQFWBM
     C                   KFLD                    FQFBHM
     C                   MOVE      @RACT8        DATE1
     C                   MOVE      @D1YY         FQFWBY
     C                   MOVE      @D1MM         FQFWBM
      *
      ** FORWARD BOOK HALF MONTH
      *
     C     @D1DD         IFGE      '01'
     C     @D1DD         ANDLE     '15'
     C                   Z-ADD     1             FQFBHM
     C                   ELSE
     C                   Z-ADD     2             FQFBHM
     C                   END
     C                   MOVE      @RCCY         FQCCY
     C     KEY6          CHAIN     FXFWMULL                           65
      *
      ** CREATE A ZERO RECORD FOR FXFWDHP0
      *
     C     *IN65         IFEQ      '1'
     C                   MOVE      'FQ'          FQRCID
     C                   MOVE      *BLANKS       FQDLTF
     C                   MOVE      @RUND         FQDLUP
     C                   MOVE      @RUNM         FQMLUP
     C                   MOVE      @RUNY         FQYLUP
     C                   TIME                    FQTLUP
     C                   MOVE      'I'           FQCHTP
     C                   MOVE      BJRDNB        FQLCD
     C                   MOVEL     PSUser        FQLUID
     C                   MOVE      *BLANKS       FQHMCI
     C                   MOVE      *BLANKS       FQHMCO
     C                   MOVE      *BLANKS       FQHMNM
     C                   MOVE      *BLANKS       FQHMDE
     C                   END
      *
      ** HALF MONTH CASH IN AND OUT
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
     C     @RAMT         IFGE      0
     C     FQHMCI        ADD       @RAMT         FQHMCI
     C                   ELSE
     C     FQHMCO        SUB       @RAMT         FQHMCO
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
     C     @RAMT         IFGE      0
     C     FQHMCI        SUB       @RAMT         FQHMCI
     C                   ELSE
     C     FQHMCO        ADD       @RAMT         FQHMCO
     C                   END
     C                   END
      *
      ** HALF MONTH NET MOVEMENT
      *
     C     FQHMCI        SUB       FQHMCO        FQHMNM
      *
      ** HALF MONTH NET MM INTEREST NOT UPDATED
      ** HALF MONTH NET DEALT BASE CCY EQUIV
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
     C     @RAMT         IFGE      0
     C     FQHMDE        ADD       @RBCD         FQHMDE
     C                   ELSE
     C     FQHMDE        SUB       @RBCD         FQHMDE
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
     C     @RAMT         IFGE      0
     C     FQHMDE        SUB       @RBCD         FQHMDE
     C                   ELSE
     C     FQHMDE        ADD       @RBCD         FQHMDE
     C                   END
     C                   END
     C     *IN65         IFEQ      '0'
     C                   MOVE      @RUND         FQDLUP
     C                   MOVE      @RUNM         FQMLUP
     C                   MOVE      @RUNY         FQYLUP
     C                   TIME                    FQTLUP
     C                   MOVE      'A'           FQCHTP
     C                   MOVE      BJRDNB        FQLCD
     C                   MOVEL     PSUser        FQLUID
     C                   UPDATE    FXFWDHP0
     C                   ELSE
     C                   WRITE     FXFWDHP0
     C                   END
     C                   ENDSR
      ********************************************************************
      *  SUBROUTINE: UPDFBO UPDATE FORWARD BOOK OPTION
      ********************************************************************
     C     UPDFBO        BEGSR
      *
      ** ACCESS FXFWDULL
      ** CONVERT ACTION DATE TO YYYYMMDD FORM
      *
     C                   MOVE      @RACT         @@DAYN            5 0
     C     @@DAYN        IFNE      *ZEROS
     C                   EXSR      ZA0710
     C                   MOVE      @@VDT         @RACT8            8 0
     C                   ELSE
     C                   MOVE      *ZEROS        @RACT8
     C                   END
     C                   MOVE      @RACT8        @DATE1
     C                   MOVE      @D1YY         FPFWBY
     C                   MOVE      @D1MM         FPFWBM
     C                   MOVE      @D1DD         FPFWBD
     C                   MOVE      @RCCY         FPCCY
     C     KEY5          CHAIN     FXFWDULL                           64
      *
      ** CREATE A ZERO RECORD FOR FXFWDDP0
      *
     C     *IN64         IFEQ      '1'
     C                   MOVE      'FP'          FPRCID
     C                   MOVE      *BLANKS       FPDLTF
     C                   MOVE      @RUND         FPDLUP
     C                   MOVE      @RUNM         FPMLUP
     C                   MOVE      @RUNY         FPYLUP
     C                   TIME                    FPTLUP
     C                   MOVE      'I'           FPCHTP
     C                   MOVE      BJRDNB        FPLCD
     C                   MOVEL     PSUser        FPLUID
     C                   MOVE      *ZEROS        FPDYCI
     C                   MOVE      *ZEROS        FPDYCO
     C                   MOVE      *ZEROS        FPDYNM
     C                   MOVE      *ZEROS        FPDYDE
     C                   END
      *
      **  CALCULATE 'OLD' PROFIT/LOSS FOR
      *
     C                   MOVE      @DATE1        @@VDT
     C                   Z-ADD     FPDYNM        @@AMT
     C                   Z-ADD     FPDYDE        @@DBCE
     C                   MOVE      FPCCY         @@CCY
     C     FPDYNM        IFLT      0
     C                   MOVE      'B'           @@BYSL
     C                   ELSE
     C                   MOVE      'S'           @@BYSL
     C                   END
      *
      ** ACCESS CURRENCY RECORD IN PREPARATION FOR ZA0620
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FPCCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FPCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '102'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** CALCULATE THE REVALUATION PROFIT AND LOSS
      *
     C                   MOVEL     A6MDEX        XRMD              1
     C                   Z-ADD     A6NBDP        CDP               1 0
     C                   EXSR      ZA0620
      *
      ** SAVE THE 'OLD' PROFIT/LOSS FOR CURRENCY
      *
     C     *LIKE         DEFINE    @@RPL         @OPL
     C                   Z-ADD     @@RPL         @OPL
      *
      ** CALCULATE THE TAKEDOWN PROPORTION
      ** DAILY CASH IN AND OUT
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RAMT         IFGE      0
     C     FPDYCI        SUB       @RAMT         FPDYCI
     C                   ELSE
     C     FPDYCO        ADD       @RAMT         FPDYCO
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
      *
      ** CALCULATE TAKEDOWN PROPORTION OF OPTION ORIGINAL SECOND AMOUNT
      *
     C     F3OOSA        MULT(H)   @TDOWN        @TPOO2           15 0
     C     @RAMT         IFGE      0
     C     FPDYCI        SUB       @TPOO2        FPDYCI
     C                   ELSE
     C     FPDYCO        ADD       @TPOO2        FPDYCO
     C                   END
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RAMT         IFGE      0
     C     FPDYCI        ADD       @RAMT         FPDYCI
     C                   ELSE
     C     FPDYCO        SUB       @RAMT         FPDYCO
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
      *
      ** CALCULATE TAKEDOWN PROPORTION OF OPTION ORIGINAL SECOND AMOUNT
      *
     C     F3OOSA        MULT(H)   @TDOWN        @TPOO2           15 0
     C     @RAMT         IFGE      0
     C     FPDYCI        ADD       @TPOO2        FPDYCI
     C                   ELSE
     C     FPDYCO        SUB       @TPOO2        FPDYCO
     C                   END
     C                   END
     C                   END
      *
      ** DAILY NET MOVEMENT
      *
     C     FPDYCI        SUB       FPDYCO        FPDYNM
      *
      ** DAILY NET DEALT BASE CCY EQUIV
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE           15 0
     C     @RAMT         IFGE      0
     C     FPDYDE        SUB       @TPBCE        FPDYDE
     C                   ELSE
     C     FPDYDE        ADD       @TPBCE        FPDYDE
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE           15 0
     C     @RAMT         IFGE      0
     C     FPDYDE        SUB       @TPBCE        FPDYDE
     C                   ELSE
     C     FPDYDE        ADD       @TPBCE        FPDYDE
     C                   END
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE           15 0
     C     @RAMT         IFGE      0
     C     FPDYDE        ADD       @TPBCE        FPDYDE
     C                   ELSE
     C     FPDYDE        SUB       @TPBCE        FPDYDE
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE           15 0
     C     @RAMT         IFGE      0
     C     FPDYDE        ADD       @TPBCE        FPDYDE
     C                   ELSE
     C     FPDYDE        SUB       @TPBCE        FPDYDE
     C                   END
     C                   END
     C                   END
     C     *IN64         IFEQ      '0'
     C                   MOVE      @RUND         FPDLUP
     C                   MOVE      @RUNM         FPMLUP
     C                   MOVE      @RUNY         FPYLUP
     C                   TIME                    FPTLUP
     C                   MOVE      'A'           FPCHTP
     C                   MOVE      BJRDNB        FPLCD
     C                   MOVEL     PSUser        FPLUID
     C                   UPDATE    FXFWDDP0
     C                   ELSE
     C                   WRITE     FXFWDDP0
     C                   END
      *
      **  CALCULATE 'NEW' PROFIT/LOSS
      *
     C                   MOVE      @DATE1        @@VDT
     C                   Z-ADD     FPDYNM        @@AMT
     C                   Z-ADD     FPDYDE        @@DBCE
     C                   MOVE      FPCCY         @@CCY
     C     FPDYNM        IFLT      0
     C                   MOVE      'B'           @@BYSL
     C                   ELSE
     C                   MOVE      'S'           @@BYSL
     C                   END
      *
      ** ACCESS CURRENCY RECORD IN PREPERATION FOR ZA0620
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FPCCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FPCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '103'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** CALCULATE THE REVALUATION PROFIT AND LOSS
      *
     C                   MOVEL     A6MDEX        XRMD
     C                   Z-ADD     A6NBDP        CDP
     C                   EXSR      ZA0620
      *
      ** SAVE THE 'NEW' PROFIT/LOSS FOR CURRENCY
      *
     C     *LIKE         DEFINE    @@RPL         @PLADJ
     C     *LIKE         DEFINE    @@RPL         @NPL
     C                   Z-ADD     @@RPL         @NPL
      *
      **  CALCULATE ADJUSTMENT AND STORE IN MULT OCC. DS. EITHER
      **  SHORT OR FORWARD FIELD
      ** DETERMINE IF FIRST OR SECOND CURRENCY BEING PROCESSED AND
      ** SET DATA STRUCTURE OCCURANCE AS APPROPRIATE
      *
     C     1             OCCUR     @PRLOS
     C     FPCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** IF ACTION FALLS WITHIN ONE MONTH DATE (@FWD5) ADD P/L INTO
      ** SHORT P/L, ELSE ADD INTO FORWARD P/L
      *
     C     @ACDR5        IFGE      BJRDNB
     C     @ACDR5        ANDLE     @FWD5
     C     @NPL          SUB       @OPL          @PLADJ
     C                   ADD       @PLADJ        @SPLO
     C                   END
     C     @ACDR5        IFGT      @FWD5
     C     @NPL          SUB       @OPL          @PLADJ
     C                   ADD       @PLADJ        @FPLO
     C                   END
      *
      ** ACCESS FXFWMULL
      *
     C                   MOVE      @RACT8        DATE1
     C                   MOVE      @D1YY         FQFWBY
     C                   MOVE      @D1MM         FQFWBM
     C     @D1DD         IFGE      '01'
     C     @D1DD         ANDLE     '15'
     C                   Z-ADD     1             FQFBHM
     C                   ELSE
     C                   Z-ADD     2             FQFBHM
     C                   END
     C                   MOVE      @RCCY         FQCCY
     C     KEY6          CHAIN     FXFWMULL                           65
      *
      ** CREATE A ZERO RECORD FOR FXFWMHP0
      *
     C     *IN65         IFEQ      '1'
     C                   MOVE      'FQ'          FQRCID
     C                   MOVE      *BLANKS       FQDLTF
     C                   MOVE      @RUND         FQDLUP
     C                   MOVE      @RUNM         FQMLUP
     C                   MOVE      @RUNY         FQYLUP
     C                   TIME                    FQTLUP
     C                   MOVE      'I'           FQCHTP
     C                   MOVE      BJRDNB        FQLCD
     C                   MOVEL     PSUser        FQLUID
     C                   MOVE      *ZEROS        FQHMCI
     C                   MOVE      *ZEROS        FQHMCO
     C                   MOVE      *ZEROS        FQHMNM
     C                   MOVE      *ZEROS        FQHMDE
     C                   END
      *
      ** DAILY CASH IN AND OUT
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RAMT         IFGE      0
     C     FQHMCI        SUB       @RAMT         FQHMCI
     C                   ELSE
     C     FQHMCO        ADD       @RAMT         FQHMCO
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
      *
      ** CALCULATE TAKEDOWN PROPORTION OF OPTION ORIGINAL SECOND AMOUNT
      *
     C     F3OOSA        MULT(H)   @TDOWN        @TPOO2
     C     @RAMT         IFGE      0
     C     FQHMCI        SUB       @TPOO2        FQHMCI
     C                   ELSE
     C     FQHMCO        ADD       @TPOO2        FQHMCO
     C                   END
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RAMT         IFGE      0
     C     FQHMCI        ADD       @RAMT         FQHMCI
     C                   ELSE
     C     FQHMCO        SUB       @RAMT         FQHMCO
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
      *
      ** CALCULATE TAKEDOWN PROPORTION OF OPTION ORIGINAL SECOND AMOUNT
      *
     C     F3OOSA        MULT(H)   @TDOWN        @TPOO2
     C     @RAMT         IFGE      0
     C     FQHMCI        ADD       @TPOO2        FQHMCI
     C                   ELSE
     C     FQHMCO        SUB       @TPOO2        FQHMCO
     C                   END
     C                   END
     C                   END
      *
      ** DAILY NET MOVEMENT
      *
     C     FQHMCI        SUB       FQHMCO        FQHMNM
      *
      ** DAILY NET DEALT BASE CCY EQUIV
      ** IF REVERSE SIGN INDICATOR NOT SET
      *
     C     @RREV         IFNE      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE
     C     @RAMT         IFGE      0
     C     FQHMDE        SUB       @TPBCE        FQHMDE
     C                   ELSE
     C     FQHMDE        ADD       @TPBCE        FQHMDE
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE
     C     @RAMT         IFGE      0
     C     FQHMDE        SUB       @TPBCE        FQHMDE
     C                   ELSE
     C     FQHMDE        ADD       @TPBCE        FQHMDE
     C                   END
     C                   END
     C                   END
      *
      ** IF REVERSE SIGN INDICATOR SET
      *
     C     @RREV         IFEQ      'R'
      *
      ** IF CCY AND AMOUNT ARE 1ST
      *
     C     @R12          IFEQ      '1'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE
     C     @RAMT         IFGE      0
     C     FQHMDE        ADD       @TPBCE        FQHMDE
     C                   ELSE
     C     FQHMDE        SUB       @TPBCE        FQHMDE
     C                   END
     C                   END
      *
      ** IF CCY AND AMOUNT ARE 2ND
      *
     C     @R12          IFEQ      '2'
     C     @RDELB        MULT(H)   @TDOWN        @TPBCE
     C     @RAMT         IFGE      0
     C     FQHMDE        ADD       @TPBCE        FQHMDE
     C                   ELSE
     C     FQHMDE        SUB       @TPBCE        FQHMDE
     C                   END
     C                   END
     C                   END
     C     *IN65         IFEQ      '0'
     C                   MOVE      @RUND         FQDLUP
     C                   MOVE      @RUNM         FQMLUP
     C                   MOVE      @RUNY         FQYLUP
     C                   TIME                    FQTLUP
     C                   MOVE      'A'           FQCHTP
     C                   MOVE      BJRDNB        FQLCD
     C                   MOVEL     PSUser        FQLUID
     C                   UPDATE    FXFWDHP0
     C                   ELSE
     C                   WRITE     FXFWDHP0
     C                   END
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPDEQP UPDATE EQUIVALENTS POSITIONS AND PROFITS             *
      ****************************************************************
     C     UPDEQP        BEGSR
      *
      ** GET ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3VDYY        @D1YY
     C                   MOVE      F3VDMM        @D1MM
     C                   MOVE      F3VDDD        @D1DD
     C                   MOVE      @DATE1        @ACTD
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3DOEY        @D1YY
     C                   MOVE      F3DOEM        @D1MM
     C                   MOVE      F3DOED        @D1DD
     C                   MOVE      @DATE1        @ACTD
     C                   END
     C                   MOVE      @ACTD         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACTD5
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTD5
     C                   END
      *
      ** CONVERT VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      @VDAT         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDAT5
     C                   ELSE
     C                   MOVE      *ZEROS        @VDAT5
     C                   END
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'Y'
     C     BJRDNB        IFGT      @VDAT5
     C                   MOVE      BJRDNB        @ACTD5
     C                   ELSE
     C                   MOVE      @VDAT5        @ACTD5
     C                   END
     C                   END
      *
      ** GET ACTION DATE IN YYYYMMDD FORM
      *
     C                   MOVE      @ACTD5        @@DAYN
     C     @@DAYN        IFNE      *ZEROS
     C                   EXSR      ZA0710
     C                   MOVE      @@VDT         @ACTD
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTD
     C                   END
      *
      ** GET BEFORE ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3BVDT        @ACTDB
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3BOTD        @ACTDB
     C                   END
     C                   MOVE      @ACTDB        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACDB5
     C                   ELSE
     C                   MOVE      *ZEROS        @ACDB5
     C                   END
      *
      ** CONVERT VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3BVDT        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDTB5
     C                   ELSE
     C                   MOVE      *ZEROS        @VDTB5
     C                   END
     C     F3DTYP        IFEQ      'O'
     C     EROVDI        ANDEQ     'Y'
     C     BJRDNB        IFGT      @VDTB5
     C                   MOVE      BJRDNB        @ACDB5
     C                   ELSE
     C                   MOVE      @VDAT5        @ACDB5
     C                   END
     C                   END
      *
      ** GET BEFORE ACTION DATE IN YYYYMMDD FORM
      *
     C                   MOVE      @ACDB5        @@DAYN
     C     @@DAYN        IFNE      *ZEROS
     C                   EXSR      ZA0710
     C                   MOVE      @@VDT         @ACTDB
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTDB
     C                   END
      *
      ** GET RELATED DEAL ACTION DATE AND CONVERT TO MIDAS DAY NUMBER
      ** ONLY IF DEAL IS A TAKEDOWN OR A SWAP
      *
     C     F3DTYP        IFEQ      'T'
     C     F3DTYP        OREQ      'S'
     C                   MOVE      F3RVDT        @ACTR
     C     F3DTYP        IFEQ      'T'
     C     EROVDI        ANDEQ     'N'
     C                   MOVE      F3ROTD        @ACTR
     C                   END
     C                   MOVE      @ACTR         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ACTR5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTR5
     C                   END
      *
      ** CONVERT RELATED VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      F3RVDT        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDTR5
     C                   ELSE
     C                   MOVE      *ZEROS        @VDTR5
     C                   END
     C     F3DTYP        IFEQ      'T'
     C     EROVDI        ANDEQ     'Y'
     C     BJRDNB        IFGT      @VDTR5
     C                   MOVE      BJRDNB        @ACTR5
     C                   ELSE
     C                   MOVE      @VDTR5        @ACTR5
     C                   END
     C                   END
      *
      ** GET ACTION DATE IN YYYYMMDD FORM
      *
     C                   MOVE      @ACTR5        @@DAYN
     C     @@DAYN        IFNE      *ZEROS
     C                   EXSR      ZA0710
     C                   MOVE      @@VDT         @ACTR
     C                   ELSE
     C                   MOVE      *ZEROS        @ACTR
     C                   END
     C                   END
      *
      ** to stop program locking problem do the update twice
      ** once for buy and once for sell currency. The currency
      ** is sorted alphabatically and the lowest currency is done
      ** on the first DO.
      *
     C                   MOVE      ' '           @BUYSL            1
     C     @BUYC         IFLT      @SELC
     C                   MOVE      'B'           @BUYSL
     C                   ELSE
     C                   MOVE      'S'           @BUYSL
     C                   END
     C                   DO        2
      *
      ** IF DEAL TYPE INDICATOR NE T
      *
     C     F3DTYP        IFNE      'T'
      *
      ** IF INSERT ADD IN EXPOSURES FOR THIS DEAL
      *
     C     F3LACT        IFEQ      'I'
      *
      ** check buy/sell indicator before start of update
      *
     C     @BUYSL        IFEQ      'B'
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   EXSR      UPEPAD
     C                   ELSE
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   EXSR      UPEPAD
     C                   END
     C                   END
      *
      ** IF DELETE REMOVE EXPOSURES FOR BEFORE DEAL
      *
     C     F3LACT        IFEQ      'D'
     C     @BUYSL        IFEQ      'B'
     C                   MOVE      F3BBCY        @RCCY
     C                   MOVE      F3DBUY        @RAMT
     C                   EXSR      UPEPRV
     C                   ELSE
     C                   MOVE      F3BSCY        @RCCY
     C                   MOVE      F3DSEL        @RAMT
     C                   EXSR      UPEPRV
     C                   END
     C                   END
      *
      ** IF AMEND AND THINGS CHANGED
      ** REMOVE EXPOSURES FOR BEFORE DEAL
      ** ADD IN EXPOSURES FOR THIS DEAL
      *
     C                   MOVE      'N'           @DOFLG
     C     F3LACT        IFEQ      'A'
     C     F3DAM1        IFNE      @AMT1B
     C     F3DAM2        ORNE      @AMT2B
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C     @ACTD5        IFLT      BJRDNB
     C     @ACDB5        ANDGE     BJRDNB
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C     @ACTD5        IFGE      BJRDNB
     C     @ACDB5        ANDLT     BJRDNB
     C                   MOVE      'Y'           @DOFLG
     C                   END
     C                   END
     C     @DOFLG        IFEQ      'Y'
     C     @BUYSL        IFEQ      'B'
      *
      ** PERFORM DELETE PROCESSING FOR BEFORE UPDATE FIELDS
      *
     C                   MOVE      F3BBCY        @RCCY
     C                   MOVE      F3DBUY        @RAMT
     C                   EXSR      UPEPRV
     C                   ELSE
     C                   MOVE      F3BSCY        @RCCY
     C                   MOVE      F3DSEL        @RAMT
     C                   EXSR      UPEPRV
     C                   END
     C     @BUYSL        IFEQ      'B'
      *
      ** PERFORM INSERT PROCESSING FOR CURRENT FIELDS
      *
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   EXSR      UPEPAD
     C                   ELSE
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   EXSR      UPEPAD
     C                   END
     C                   END
      *
      ** DELETING A SWAP DEAL
      ** REMOVE EXPOSURES FOR RELATED DEAL
      *
     C     F3DTYP        IFEQ      'S'
     C     F3LACT        ANDEQ     'D'
     C     @BUYSL        IFEQ      'S'
     C                   MOVE      F3RBCY        @RCCY
     C                   MOVE      F3RBAT        @RAMT
     C                   EXSR      UPEPRR
     C                   ELSE
     C                   MOVE      F3RSCY        @RCCY
     C                   Z-SUB     F3RSAT        @RAMT
     C                   EXSR      UPEPRR
     C                   END
     C                   END
     C                   END
      *
      ** IF DEAL IS A TAKEDOWN
      *
     C     F3DTYP        IFEQ      'T'
     C     @BUYSL        IFEQ      'B'
      *
      ** CALCULATE TAKEDOWN PROPORTION
      *
     C     F3DAM1        DIV(H)    F3OOFA        @TDOWN
      *
      ** PROCESS CALCULATE ADJUSTMENTS FOR BUY CCY
      *
     C                   MOVE      @BUYC         @RCCY
     C                   MOVE      @BUYA         @RAMT
     C                   MOVE      @ACTD         @RACT
     C                   MOVE      F3BCDE        @RDBCE           15 0
     C                   MOVE      F3DSBE        @RDSBE           15 0
     C     @B12          IFEQ      '1'
     C                   MOVE      F3OOFA        @RAMTO           15 0
     C                   ELSE
     C                   MOVE      F3OOSA        @RAMTO
     C                   END
     C                   MOVE      @B12          @R12
     C                   EXSR      CALADJ
      *
      ** SAVE VALUES OF BUY CCY FIELDS
      *
     C                   MOVE      @NPA          @ABNPA           15 0
     C                   MOVE      @DBCEA        @ABDBC           15 0
     C                   MOVE      @DSBCA        @ABDSB           15 0
      *
      ** PUT SAVE VALUES INTO SUBROUTINE FIELDS
      *
     C                   MOVE      @ABNPA        @RNPA            15 0
     C                   MOVE      @ABDBC        @RDBC            15 0
     C                   MOVE      @ABDSB        @RDSB            15 0
      *
      ** IF INSERT UPDATE FXEPOULL
      *
     C     F3LACT        IFEQ      'I'
     C                   EXSR      UPEPTA
     C                   END
      *
      ** IF DELETE UPDATE FXEPOULL REVERSING ADDS & SUBS
      *
     C     F3LACT        IFEQ      'D'
     C                   EXSR      UPEPTR
     C                   END

     C                   ELSE
      *
      ** PROCESS CALCULATE ADJUSTMENTS FOR SEL CCY
      *
     C                   MOVE      @SELC         @RCCY
     C                   MOVE      @SELA         @RAMT
     C                   MOVE      @ACTD         @RACT
     C                   MOVE      F3BCDE        @RDBCE
     C                   MOVE      F3DSBE        @RDSBE
     C     @S12          IFEQ      '1'
     C                   MOVE      F3OOFA        @RAMTO
     C                   ELSE
     C                   MOVE      F3OOSA        @RAMTO
     C                   END
     C                   MOVE      @S12          @R12
     C                   EXSR      CALADJ
      *
      ** SAVE VALUES OF SELL CCY FIELDS
      *
     C                   MOVE      @NPA          @ASNPA           15 0
     C                   MOVE      @DBCEA        @ASDBC           15 0
     C                   MOVE      @DSBCA        @ASDSB           15 0
      *
      ** PUT SAVED FIELDS INTO SUBROUTINE FIELDS
      *
     C                   MOVE      @ASNPA        @RNPA            15 0
     C                   MOVE      @ASDBC        @RDBC            15 0
     C                   MOVE      @ASDSB        @RDSB            15 0
      *
      ** IF INSERT UPDATE FXEPOULL
      *
     C     F3LACT        IFEQ      'I'
     C                   EXSR      UPEPTA
     C                   END
      *
      ** IF DELETE UPDATE FXEPOULL REVERSING ADDS & SUBS
      *
     C     F3LACT        IFEQ      'D'
     C                   EXSR      UPEPTR
     C                   END
     C                   END
      *
      ** IF AMEND AND THINGS CHANGED
      *
     C     F3LACT        IFEQ      'A'
     C     F3DAM1        IFNE      @AMT1B
     C     F3DAM2        ORNE      @AMT2B
     C     @VDAT         ORNE      F3BVDT
      *
      ** CALCULATE ORIGINAL TAKEDOWN PROPORTION
      *
     C     @AMT1B        DIV(H)    F3OOFA        @TDOWN
     C     @BUYSL        IFEQ      'B'
      *
      ** PROCESS CALCULATE ADJUSTMENTS FOR BUY CCY
      *
     C                   MOVE      F3BBCY        @RCCY
     C                   MOVE      F3DBUY        @RAMT
     C                   MOVE      @ACTDB        @RACT
     C                   MOVE      @DEALB        @RDBCE
     C                   MOVE      @SPOTB        @RDSBE
     C     @B12          IFEQ      '1'
     C                   MOVE      F3OOFA        @RAMTO
     C                   ELSE
     C                   MOVE      F3OOSA        @RAMTO
     C                   END
     C                   MOVE      @B12          @R12
     C                   EXSR      CALADJ
      *
      ** EXTRA PROCESSING FOR DEAL BCE - IGNORE ANYTHING FROM LAST
      ** CALL TO CALADJ
      *
     C     F3BCDE        DIV       F3DAM2        @ORATE           13 8
     C     @ORATE        MULT(H)   @AMT2B        @DBCEA
      *
      ** SUBTRACT BUY - THESE ADJUSTMENTS
      *
     C     @ABNPA        SUB       @NPA          @TBNPA           15 0
     C     @ABDBC        SUB       @DBCEA        @TBDBC           15 0
     C     @ABDSB        SUB       @DSBCA        @TBDSB           15 0
      *
      ** UPDATE FXEPOULL
      *
     C                   MOVE      @TBNPA        @RNPA            15 0
     C                   MOVE      @TBDBC        @RDBC            15 0
     C                   MOVE      @TBDSB        @RDSB            15 0
     C                   EXSR      UPEPTU
     C                   ELSE
      *
      ** PROCESS CALCULATE ADJUSTMENTS FOR SELL CCY
      *
     C                   MOVE      F3BSCY        @RCCY
     C                   MOVE      F3DSEL        @RAMT
     C                   MOVE      @ACTDB        @RACT
     C                   MOVE      @DEALB        @RDBCE
     C                   MOVE      @SPOTB        @RDSBE
     C     @S12          IFEQ      '1'
     C                   MOVE      F3OOFA        @RAMTO
     C                   ELSE
     C                   MOVE      F3OOSA        @RAMTO
     C                   END
     C                   MOVE      @S12          @R12
     C                   EXSR      CALADJ
      *
      ** EXTRA PROCESSING FOR DEAL BCE - IGNORE ANYTHING FROM LAST
      ** CALL TO CALADJ
      *
     C     F3BCDE        DIV       F3DAM1        @ORATE           13 8
     C     @ORATE        MULT(H)   @AMT1B        @DBCEA
      *
      ** SUBTRACT SELL- THESE ADJUSTMENTS
      *
     C     @ASNPA        SUB       @NPA          @TSNPA           15 0
     C     @DBCEA        SUB       @ASDBC        @TSDBC           15 0
     C     @ASDSB        SUB       @DSBCA        @TSDSB           15 0
      *
      ** UPDATE FXEPOULL
      *
     C                   MOVE      @TSNPA        @RNPA            15 0
     C                   MOVE      @TSDBC        @RDBC            15 0
     C                   MOVE      @TSDSB        @RDSB            15 0
     C                   EXSR      UPEPTU
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** change buy/sell indicator for second round of update
      *
     C     @BUYSL        IFEQ      'B'
     C                   MOVE      'S'           @BUYSL
     C                   ELSE
     C                   MOVE      'B'           @BUYSL
     C                   END
     C                   END
      *
      ** CROSS CURRENCIES POSITION UPDATE PROCESSING
      ** If first currency of deal is not base currency for
      ** dealing check cross currency file to see whether
      ** a position is being kept for this currency combination.
      *
     C     F3CCY1        IFNE      BNCYDL
     C     F3LACT        ANDNE     'X'
     C                   MOVE      F3CCY1        @CPCCY
     C                   MOVE      F3CCY2        @CSCCY
     C     @CCKEY        CHAIN     FXCRSCLL                           67
      *
      ** If record found then a position is being kept
      ** which needs updating for this deal.
      *
     C     *IN67         IFEQ      '0'
     C                   MOVE      F3CCY2        @RCCY
     C                   MOVE      F3CCY2        @EECCY
     C                   MOVE      F3CCY1        @EPCCY
     C                   Z-ADD     F3DAM2        @CCAMT           15 0
     C                   Z-ADD     F3DAM1        @CCEQV           15 0
     C                   Z-ADD     F3DSEL        @CCOAM           15 0
     C                   Z-ADD     F3DBUY        @CCOEQ           15 0
     C                   EXSR      UPCCEP
     C                   END
     C                   END
      *
      ** If second currency of deal is not base currency for
      ** dealing check cross currency file to see whether
      ** a position is being kept for this currency combination.
      *
     C     F3CCY2        IFNE      BNCYDL
     C     F3LACT        ANDNE     'X'
     C                   MOVE      F3CCY2        @CPCCY
     C                   MOVE      F3CCY1        @CSCCY
     C     @CCKEY        CHAIN     FXCRSCLL                           67
      *
      ** If record found then a position is being kept
      ** which needs updating for this deal.
      *
     C     *IN67         IFEQ      '0'
     C                   MOVE      F3CCY1        @RCCY
     C                   MOVE      F3CCY1        @EECCY
     C                   MOVE      F3CCY2        @EPCCY
     C                   Z-ADD     F3DAM1        @CCAMT           15 0
     C                   Z-ADD     F3DAM2        @CCEQV           15 0
     C                   Z-ADD     F3DBUY        @CCOAM           15 0
     C                   Z-ADD     F3DSEL        @CCOEQ           15 0
     C                   EXSR      UPCCEP
     C                   END
     C                   END
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  CALADJ - CALCULATE ADJUSTMENTS
      ****************************************************************
     C     CALADJ        BEGSR
      *
      ** IF CURRENCY IS DEAL 1ST CURRENCY
      *
     C     @R12          IFEQ      '1'
     C     F3LACT        ANDNE     'A'
     C                   Z-ADD     0             @NPA             15 0
     C                   Z-ADD     0             @DBCEA           15 0
     C                   Z-ADD     0             @DSBCA           15 0
      *
      ** IF CURRENCY IS DEAL 2ND CURRENCY
      *
     C                   ELSE
      *
      ** NET POSITION ADJUSTMENT
      ** IF THIS IS A TAKEDOWN DON'T WANT TO ADD IN THIS AGAIN
      ** BECAUSE THIS IS A TOTAL - ALREADY IN
      *
     C     F3LACT        IFNE      'A'
     C     @TDOWN        MULT(H)   F3OOSA        @WORK1           15 0
     C     @RAMT         SUB       @WORK1        @NPA
     C                   ELSE
     C                   Z-ADD     0             @NPA
     C                   END
      *
      ** DEALT BASE CCY EQUIV
      **  SPECIAL PROCESSING FOR AMEND OF OPTION TAKEDOWNS
      **  TO CATER FOR ANY RATE CHANGES
      *
     C     F3LACT        IFEQ      'A'
     C     F3DTYP        ANDEQ     'T'
     C     1             SUB       @TDOWN        @WTDWN           13 8
     C     @WTDWN        MULT(H)   @RDELB        @WORK1
     C     @RDBCE        ADD       @WORK1        @DBCEA
     C                   ELSE
     C     @TDOWN        MULT(H)   @RDELB        @WORK1
     C     @RDBCE        SUB       @WORK1        @DBCEA
     C                   END
      *
      ** DEALT SPOT BASE CCY EQUIV
      *
     C     @TDOWN        MULT(H)   @RDSPB        @WORK1
     C     @RDSBE        SUB       @WORK1        @DSBCA
     C                   END
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPEPAD  UPDATE FXEPOULL - ADD IN DEAL
      ****************************************************************
     C     UPEPAD        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
      *
      ** CREATE A ZERO RECORD FOR FXEPOSP0
      *
     C     *IN66         IFEQ      '1'
     C                   EXSR      CRT0EP
     C                   END
     C                   MOVE      @RCCY         FOCCY
      *
      ** IF ACTION DATE LT RUN DATE
      *
     C     @ACTD5        IFLT      BJRDNB
     C     FONNCP        ADD       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        ADD       F3BCDE        FONDBC
     C                   ELSE
     C     FONDBC        SUB       F3BCDE        FONDBC
     C                   END
     C                   END
     C     FOTNTP        ADD       @RAMT         FOTNTP
     C     @RAMT         IFGE      0
     C     FOTDPE        ADD       F3BCDE        FOTDPE
     C                   ELSE
     C     FOTDPE        SUB       F3BCDE        FOTDPE
     C                   END
     C     @RAMT         IFGE      0
     C     FOBDSE        ADD       F3DSBE        FOBDSE
     C                   ELSE
     C     FOBDSE        SUB       F3DSBE        FOBDSE
     C                   END
     C                   MOVE      @RCCY         @@CCY
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C     *IN66         IFEQ      '1'
     C                   WRITE     FXEPOSP0
     C                   ELSE
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C                   END
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPEPRV - UPDATE FXEPOULL - REVERSE DEAL AMOUNTS
      ****************************************************************
     C     UPEPRV        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
     C     *IN66         IFEQ      '1'
     C                   MOVEL     @RCCY         DBKEY
     C                   MOVEL     'FXEPOULL'    DBFILE
     C                   MOVEL     '200'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C                   MOVE      @RCCY         FOCCY
      *
      ** IF ACTION DATE LT RUN DATE
      *
     C     @ACDB5        IFLT      BJRDNB
     C     FONNCP        SUB       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        SUB       @DEALB        FONDBC
     C                   ELSE
     C     FONDBC        ADD       @DEALB        FONDBC
     C                   END
     C                   END
     C     FOTNTP        SUB       @RAMT         FOTNTP
     C     @RAMT         IFGE      0
     C     FOTDPE        SUB       @DEALB        FOTDPE
     C                   ELSE
     C     FOTDPE        ADD       @DEALB        FOTDPE
     C                   END
     C     @RAMT         IFGE      0
     C     FOBDSE        SUB       @SPOTB        FOBDSE
     C                   ELSE
     C     FOBDSE        ADD       @SPOTB        FOBDSE
     C                   END
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C     EPEPRV        ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPEPRR - UPDATE FXEPOULL - REMOVE RELATED DEAL
      ****************************************************************
     C     UPEPRR        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
     C     *IN66         IFEQ      '1'
     C                   MOVEL     @RCCY         DBKEY
     C                   MOVEL     'FXEPOULL'    DBFILE
     C                   MOVEL     '201'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C                   MOVE      @RCCY         FOCCY
      *
      ** IF ACTION DATE LT RUN DATE
      *
     C     @ACTR5        IFLT      BJRDNB
     C     FONNCP        SUB       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        SUB       @RDELB        FONDBC
     C                   ELSE
     C     FONDBC        ADD       @RDELB        FONDBC
     C                   END
     C                   END
     C     FOTNTP        SUB       @RAMT         FOTNTP
     C     @RAMT         IFGE      0
     C     FOTDPE        SUB       @RDELB        FOTDPE
     C                   ELSE
     C     FOTDPE        ADD       @RDELB        FOTDPE
     C                   END
     C     @RAMT         IFGE      0
     C     FOBDSE        SUB       @RDSPB        FOBDSE
     C                   ELSE
     C     FOBDSE        ADD       @RDSPB        FOBDSE
     C                   END
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C     EPEPRR        ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPEPTA   UPDATE FXEPOULL - ADD TAKEDOWN
      ****************************************************************
     C     UPEPTA        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
      *
      ** CREATE A ZERO RECORD FOR FXEPOUP0
      *
     C     *IN66         IFEQ      '1'
     C                   EXSR      CRT0EP
     C                   END
     C                   MOVE      @RCCY         FOCCY
     C     @ACTD5        IFLT      BJRDNB
     C     FONNCP        ADD       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        ADD       F3BCDE        FONDBC
     C                   ELSE
     C     FONDBC        SUB       F3BCDE        FONDBC
     C                   END
     C                   END
      *
      ** TOTAL NET POSITION
      *
     C     FOTNTP        ADD       @RNPA         FOTNTP
     C     @BUYC         IFEQ      @RCCY
      *   FOR BUY CCY
     C     FOTDPE        ADD       @RDBC         FOTDPE
     C                   ELSE
      *   FOR SELL CCY
     C     FOTDPE        SUB       @RDBC         FOTDPE
     C                   END
      *
      **  FOR OPTION TAKEDOWNS MUST INVERT THE SIGN OF THE
      **  SELL ADJUSTMENT. B'COS ALL BCE ARE +VE ON DEALS FILE
      *
     C     F3DTYP        IFEQ      'T'
     C     @RAMT         ANDLT     0
     C                   Z-SUB     @RDSB         @RDSB
     C                   END
     C     FOBDSE        ADD       @RDSB         FOBDSE
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C     *IN66         IFEQ      '1'
     C                   WRITE     FXEPOSP0
     C                   ELSE
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C                   END
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPEPTR - UPDATE FXEPOULL - REVERSE TAKEDOWN
      ****************************************************************
     C     UPEPTR        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
     C     *IN66         IFEQ      '1'
     C                   MOVEL     @RCCY         DBKEY
     C                   MOVEL     'FXEPOULL'    DBFILE
     C                   MOVEL     '202'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVE      @RCCY         FOCCY
     C     @ACTD5        IFLT      BJRDNB
     C     FONNCP        SUB       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        SUB       F3BCDE        FONDBC
     C                   ELSE
     C     FONDBC        ADD       F3BCDE        FONDBC
     C                   END
     C                   END
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C     EPEPTR        ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * UPEPTU UPDATE FXEPOULL - AMEND TAKEDOWN
      ****************************************************************
     C     UPEPTU        BEGSR
      *
      ** ACCESS FXEPOULL
      *
     C     @RCCY         CHAIN     FXEPOULL                           66
     C     *IN66         IFEQ      '1'
     C                   MOVEL     @RCCY         DBKEY
     C                   MOVEL     'FXEPOULL'    DBFILE
     C                   MOVEL     '203'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVE      @RCCY         FOCCY
     C     @VDTB5        IFLT      BJRDNB
     C     FONNCP        SUB       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        SUB       @DEALB        FONDBC
     C                   ELSE
     C     FONDBC        ADD       @DEALB        FONDBC
     C                   END
     C                   END
     C     @VDAT5        IFLT      BJRDNB
     C     FONNCP        ADD       @RAMT         FONNCP
     C     @RAMT         IFGE      0
     C     FONDBC        ADD       F3BCDE        FONDBC
     C                   ELSE
     C     FONDBC        SUB       F3BCDE        FONDBC
     C                   END
     C                   END
      *
      ** TOTAL NET POSITION
      *
     C     FOTNTP        ADD       @RNPA         FOTNTP
     C     FOTDPE        ADD       @RDBC         FOTDPE
      *
      **  FOR OPTION TAKEDOWNS MUST INVERT THE SIGN OF THE
      **  SELL ADJUSTMENT. B'COS ALL BCE ARE +VE ON DEALS FILE
      *
     C     F3DTYP        IFEQ      'T'
     C     @RAMT         ANDLT     0
     C                   Z-SUB     @RDSB         @RDSB
     C                   END
     C     FOBDSE        ADD       @RDSB         FOBDSE
      *
      **  CALCULATE PROFIT/LOSS FIGURES
      *
     C     1             OCCUR     @PRLOS
     C     @RCCY         IFNE      @PCCY
     C     2             OCCUR     @PRLOS
     C                   END
      *
      ** ONLY ADD AJUSTMENTS TO FILE FIELDS IF NOT ALREADY DONE
      *
     C     @ADJAD        IFEQ      'N'
     C                   ADD       @SPLO         FOSHPL
     C                   ADD       @FPLO         FOFWPL
     C                   MOVE      'Y'           @ADJAD
     C                   END
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOSP0
     C     EPEPTU        ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *  UPCCEP - UPDATE FXEPOCLL
      ****************************************************************
     C     UPCCEP        BEGSR
      *
      ** Access positions file.
      *
     C     @EPKEY        CHAIN     FXEPOCLL                           68
      *
      ** If record not found currency combination is newly
      ** set up so need to initialise record
      *
     C     *IN68         IFEQ      '1'
     C                   EXSR      CRT0EP
     C                   END
      *
      ** Set up Cross currency total net position (FOCTNP) and
      ** Cross currency equivalent in primary currency (FOCTEP)
      ** If action code is insert:
      *
     C     F3LACT        IFEQ      'I'
     C     FOCTNP        ADD       @CCAMT        FOCTNP
     C     FOCTEP        SUB       @CCEQV        FOCTEP
     C                   MOVE      @EPCCY        FOPCCY
     C                   END
      *
      ** If action code is delete:
      *
     C     F3LACT        IFEQ      'D'
     C     FOCTNP        SUB       @CCAMT        FOCTNP
     C     FOCTEP        ADD       @CCEQV        FOCTEP
     C                   END
      *
      ** If action code is amend:
      *
     C     F3LACT        IFEQ      'A'
     C     FOCTNP        SUB       @CCOAM        FOCTNP
     C     FOCTNP        ADD       @CCAMT        FOCTNP
     C     FOCTEP        ADD       @CCOEQ        FOCTEP
     C     FOCTEP        SUB       @CCEQV        FOCTEP
     C                   END
      *
     C     *IN68         IFEQ      '1'
     C                   WRITE     FXEPOCL1
     C                   ELSE
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'A'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   UPDATE    FXEPOCL1
     C                   END
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * CRT0EP CREATE A ZERO RECORD FOR FXEPOULL
      ****************************************************************
     C     CRT0EP        BEGSR
     C                   MOVE      'FO'          FORCID
     C                   MOVE      *BLANKS       FODLTF
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'I'           FOCHTP
     C                   MOVE      BJRDNB        FOLCD
     C                   MOVEL     PSUser        FOLUID
     C                   MOVE      @RCCY         FOCCY
     C                   MOVE      *ZEROS        FONNCP
     C                   MOVE      *ZEROS        FONDBC
     C                   MOVE      *ZEROS        FOTNTP
     C                   MOVE      *ZEROS        FOTDPE
     C                   MOVE      *ZEROS        FOBDSE
     C                   MOVE      *ZEROS        FOSHPL
     C                   MOVE      *ZEROS        FOFWPL
     C                   MOVE      *ZEROS        FOCTNP
     C                   MOVE      *ZEROS        FOCTEP
     C                   MOVE      *BLANKS       FOPCCY
     C                   ENDSR
      ****************************************************************
      /EJECT
      *******************************************************************
      * ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
      *******************************************************************
     C     ZA0680        BEGSR
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C     @@YYYY        IFGE      2072
     C**    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0
     C     @@WK2         MULT      36524         @@MDNO
     C**  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO
     C                   END
     C     @@YYYY        ADD       28            @@WK2
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0
     C     @@MTH         ANDGT     2
     C                   ADD       1             @@MDNO
     C                   END
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0
     C                   ADD       @YD(@@REM)    @@MDNO
     C                   END
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C     ZA0689        ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
     C* ZA0620 - THIS SUBROUTINE CALCULATES THE REVALUATION PROFIT
      ********************************************************************
     C     ZA0620        BEGSR
     C**   DEFINE @@AMT.
     C                   Z-ADD     @@AMT         @@AMT            15 0
     C**   OBTAIN MARKET OUTRIGHT RATE
     C                   EXSR      ZA0640

      **   CHECK MULTIPLY/DIVIDE INDICATOR

     C     XRMD          IFEQ      'M'
     C**   CALCULATE THE RETURN BASE CURRENCY EQUIVALENT, AND ALSO
     C**   STORE THE RESULTING DECIMAL PLACES.
     C     @@AMT         MULT      @@MOR         @@RBCE           15 0
     C     @@AMT         MULT(H)   @@MOR         @@DEC             3 3
     C                   ELSE
     C     @@AMT         DIV       @@MOR         @@RBCE
     C     @@AMT         DIV(H)    @@MOR         @@DEC
     C                   END
     C**  CORRECT DECIMAL PLACES OF REVALUED BASE CCY EQUIVALENT
     C     CDP           SUB       @@NDPB        @@P               1 0
     C                   ADD       4             @@P
     C     @@RBCE        MULT(H)   @DP(@@P)      @@RBCE
     C     @@DEC         MULT      @DP(@@P)      @@MDEC            6 3
     C**  CALCULATE EXACT VALUE OF @@RBCE (INCLUDES DEC. PLACES FIGURE)
     C     @@MDEC        ADD(H)    @@RBCE        @@RBCE
     C**  CALCULATE PROFIT/LOSS
     C     @@RBCE        SUB       @@DBCE        @@RPL            15 0
     C     ZA0629        ENDSR
      /EJECT
      *******************************************************************
      * ZA0640 - THIS SUBROUTINE CALCULATES THE FORWARD OUTRIGHT
      *******************************************************************
     C     ZA0640        BEGSR
      *
      **   If the currency requested is Base for dealing, assume
      **     a Rate of 1.00.
      *
     C     BNCYDL        IFEQ      @@CCY
     C                   Z-ADD     0001.00       @@MOR
     C                   ELSE
      *
      **  KEY LIST FOR FXREVHLL READ
      **  DATE KEY MUST BE ZONED NOT PACKED
      *
     C                   Z-ADD     @@VDT         @@VTE
     C     @@KREV        KLIST
     C                   KFLD                    @@CCY             3
     C                   KFLD                    @@VTE
      *
      **  Clear database field from previous executions.
      *
     C                   MOVE      *BLANKS       FVCCY
      *
      **  SETLL FOR NEXT READP
      *
     C     @@KREV        SETLL     FXREVHP0
     C     @@CCY         READE     FXREVHP0                             8685
      *
      **  If record not found, or locked, try for record
      **   with date less than that provided. Read last
      **   record for currency.
      *
     C     *IN85         IFEQ      '1'
     C     *IN86         OREQ      '1'
     C     @@CCY         SETGT     FXREVHP0
     C                   READP     FXREVHP0                             8685
      *
      **  No record whatsoever exists for the currency,
      **   perform error processing. Set IN85, cause
      **   Non Extrapolation processing.
      *
     C     @@CCY         CABNE     FVCCY         ZA0648
     C                   MOVE      '1'           *IN85
     C                   END
      *
      **  RECORD EXISTS FOR CCY
      **         and VALUE DATE = that on file.
      **         or  VALUE DATE > than any on file.
      *
     C     @@VTE         IFEQ      FVPRDT
     C     *IN85         OREQ      '1'
      *
      **  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
      *
     C     XRMD          IFEQ      'M'
     C     @@BYSL        ANDEQ     'B'
     C     XRMD          OREQ      'D'
     C     @@BYSL        ANDEQ     'S'
      *
      **   USE HIGH OUTRATE RATE
      *
     C                   Z-ADD     FVHORT        @@MOR
     C                   ELSE
      *
      **   USE LOW OUTRATE RATE
      *
     C                   Z-ADD     FVLORT        @@MOR
     C                   END
      *
      **  EXIT ROUTINE
      *
     C                   GOTO      ZA0649
     C                   END
      *
      **  Setting up of  @@VDAT
      **  Convert the Value Date to MIDAS No. and store in @@VDAT
      *
     C                   Z-ADD     @@VDT         @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@VDAT
      *
      **  SAVE FIRST READ VALUES
      *
     C                   MOVE      FVCCY         @@FCCY
     C                   MOVE      *BLANKS       FVCCY
      *
      ** CONVERT TO MIDAS DAY NUMBER FORMAT
      *
     C                   Z-ADD     FVPRDT        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@PRD1
     C                   Z-ADD     FVHORT        @@HRT1
     C                   Z-ADD     FVLORT        @@LRT1
      *
      **  READ PREVIOUS RECORD
      *
     C                   READP     FXREVHP0                               85
      *
      **  MUST EXTRAPOLATE TO GET RATE FOR VALUE DATE
      *
     C     @@FCCY        IFEQ      @@CCY
     C     FVCCY         ANDEQ     @@CCY
     C     @@PRD1        ANDGT     @@VDAT
     C     *IN85         ANDEQ     '0'
      *
      **  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
      *
     C     XRMD          IFEQ      'M'
     C     @@BYSL        ANDEQ     'B'
     C     XRMD          OREQ      'D'
     C     @@BYSL        ANDEQ     'S'
      *
      **   USE HIGH OUTRATE RATE
      *
     C                   Z-ADD     FVHORT        @@SRAT
     C                   Z-ADD     @@HRT1        @@FRAT
     C                   ELSE
      *
      **   USE LOW OUTRATE RATE
      *
     C                   Z-ADD     FVLORT        @@SRAT
     C                   Z-ADD     @@LRT1        @@FRAT
     C                   END
      *
      **  CALCULATION:
      **  RATE DIFFERENCE
      *
     C     @@FRAT        SUB       @@SRAT        @@RATD
      *
      **  DATE DIFFERENCE
      **  CONVERT TO MIDAS DAY NUMBER FORMAT
      *
     C                   Z-ADD     FVPRDT        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @@PRD2
      *
      **  DATE EXCESS
      *
     C     @@VDAT        SUB       @@PRD2        @@EDAT
     C     @@PRD1        SUB       @@PRD2        @@DATD
     C     @@EDAT        DIV(H)    @@DATD        @@WK6            10 9
     C     @@WK6         MULT(H)   @@RATD        @@MOR
     C                   ADD       @@SRAT        @@MOR
      *
      **  EXIT ROUTINE
      *
     C                   GOTO      ZA0649
     C                   END
      *
      **  ONLY ONE REVALUATION RECORD FOR THIS CCY SO CANNOT EXTRAPOLATE
      *
     C     @@FCCY        IFEQ      @@CCY
     C     FVCCY         ANDNE     @@CCY
      *
      **  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
      *
     C     XRMD          IFEQ      'M'
     C     @@BYSL        ANDEQ     'B'
     C     XRMD          OREQ      'D'
     C     @@BYSL        ANDEQ     'S'
      *
      **   USE HIGH OUTRATE RATE
      *
     C                   Z-ADD     @@HRT1        @@MOR
     C                   ELSE
      *
      **   USE LOW OUTRATE RATE
      *
     C                   Z-ADD     @@LRT1        @@MOR
     C                   END
      *
      **  EXIT ROUTINE
      *
     C                   GOTO      ZA0649
     C                   END
      *
      **  ONLY ONE REVALUATION RECORD FOR THIS CCY SO CANNOT EXTRAPOLATE
      *
     C     FVCCY         IFEQ      @@CCY
     C     @@FCCY        ANDNE     @@CCY
      *
      **  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
      *
     C     XRMD          IFEQ      'M'
     C     @@BYSL        ANDEQ     'B'
     C     XRMD          OREQ      'D'
     C     @@BYSL        ANDEQ     'S'
      *
      **   USE HIGH OUTRATE RATE
      *
     C                   Z-ADD     FVHORT        @@MOR
     C                   ELSE
      *
      **   USE LOW OUTRATE RATE
      *
     C                   Z-ADD     FVLORT        @@MOR
     C                   END
      *
      **  EXIT ROUTINE
      *
     C                   GOTO      ZA0649
     C                   END
      *
      **  ANY OTHER RESULTS MUST BE A DATABASE ERROR
      *
     C     ZA0648        TAG
     C                   MOVE      @@CCY         DBKEY
     C                   MOVEL     'FXREVHLL'    DBFILE
     C                   MOVE      '204'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  FIELD DEFINITIONS
      *
     C     *LIKE         DEFINE    @@MDNO        @@EDAT
     C     *LIKE         DEFINE    FVHORT        @@RATD
     C     *LIKE         DEFINE    FVCCY         @@FCCY
     C     *LIKE         DEFINE    @@MDNO        @@VDAT
     C     *LIKE         DEFINE    A6SPRT        @@MOR
     C     *LIKE         DEFINE    FVPRDT        @@VTE
     C     *LIKE         DEFINE    @@MDNO        @@PRD1
     C     *LIKE         DEFINE    FVHORT        @@HRT1
     C     *LIKE         DEFINE    FVLORT        @@LRT1
     C     *LIKE         DEFINE    FVHORT        @@SRAT
     C     *LIKE         DEFINE    FVHORT        @@FRAT
     C     *LIKE         DEFINE    @@MDNO        @@PRD2
     C     *LIKE         DEFINE    @@MDNO        @@DATD
     C                   GOTO      ZA0649
     C                   MOVE      @@BYSL        @@BYSL            1
     C                   Z-ADD     @@DBCE        @@DBCE           15 0
     C     ZA0649        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZA0710        BEGSR
     C                   SETOFF                                       8081
     C                   Z-ADD     0             @@RTN             1 0
     C                   Z-ADD     0             @@VDT
     C                   Z-ADD     1             @@I               2 0
     C                   Z-ADD     1             @@J               2 0
     C                   Z-ADD     1             @@LEAP            1 0
      *
      * ERROR IN DATE
      *
     C     @@DAYN        IFLT      1
     C                   Z-ADD     1             @@RTN
     C                   GOTO      ZA0719
     C                   END
      *
      * DIVISION TO DETERMINE WETHER LEAP YEAR.
      *
     C     @@DAYN        DIV       1461          @@Z71Y
     C                   MVR                     @@RDAY            5 0
      *
      * CALCULATING YEAR.
      *
     C     @@Z71Y        MULT      4             @@Z71Y
     C                   ADD       1972          @@Z71Y
      *
      * CHECKING IF YEAR IS GREATER THAN OR EQUAL TO 2100
      *
     C     @@Z71Y        IFGE      2100
     C                   ADD       @@SSY2        @@RDAY
     C                   END
      *
      * LOKUP ARRAY @YD TO SEE HOW MANY YEARS OF A FOUR YEAR CYCLE
      * HAVE PASSED.
      *
     C     @@RDAY        LOOKUP    @YD(@@I)                             8080
      *
      * IF YEAR IS A LEAP YEAR SSLEAP IS SET TO ZERO.
      *
     C     *IN80         IFEQ      '0'
     C                   Z-ADD     0             @@LEAP
     C                   END
      *
      * ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST '@@RDAY'.
      *
     C     @@LEAP        IFEQ      1
     C     @@RDAY        SUB       @YD(@@I)      @@RDAY
     C                   ADD       @@I           @@Z71Y
     C                   END
      *
      * PROCESSING FOR A LEAP YEAR.
      *
     C     @@LEAP        IFEQ      0
      *
      * IF '@@RDAY' = 60 DATE MUST BE 29TH OF FEBRUARY.
      *
     C     @@RDAY        IFEQ      60
     C                   Z-ADD     29            @@Z71D
     C                   Z-ADD     2             @@Z71M
     C                   GOTO      ZA0711
     C                   END
      *
      * IF '@@RDAY' > 60 DATE IS AFTER 29TH OF FEBRUARY,CONVERSION CAN
      * PROCEED AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
      * YEAR. NOTE : '@@RDAY' < 60 CONVERSION PROCEEDS AS USUAL.
      *
     C     @@RDAY        IFGT      60
     C     @@RDAY        SUB       1             @@RDAY
     C                   END
     C                   END
      *
      * IF DAY '@@DAYN' IS EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS
      * IN 4 YEARS) THEN DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR
      * GROUP.
      *
     C     @@RDAY        IFEQ      0
     C                   Z-ADD     31            @@Z71D
     C                   Z-ADD     12            @@Z71M
     C                   SUB       1             @@Z71Y
     C                   GOTO      ZA0711
     C                   END
      *
      * LOOK UP ARRAY ARRAY @MD TO DETERMINE WHICH MONTH '@@RDAY'
      * OCCURS IN
      *
     C     @@RDAY        LOOKUP    @MD(@@J)                             81
     C                   Z-ADD     @@J           @@Z71M
     C     @@RDAY        SUB       @MD(@@J)      @@Z71D
      *
      * DS @@VDT  IS RETURNED IN YYYYMMDD FORMAT
      *
     C     ZA0711        TAG
     C                   MOVE      @@Z71Y        @@YR
     C     ZA0719        ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SETDLD - SET DEAL DETAILS
      ****************************************************************
     C     SETDLD        BEGSR
      *
      ** INITIALIZE RELATED DEAL DEALT BCE
      ** INITIALIZE RELATED DEAL DEALT SPOT BCE
      ** INITIALIZE RELATED DEAL BUY AND SELL AMOUNTS
      ** INITIALIZE RELATED DEAL BUY AND SELL CURRENCIES
      ** INITIALIZE RELATED DEAL VALUE DATE AND OPTION TO DATE
      *
     C                   Z-ADD     *ZERO         @RDELB           15 0
     C                   Z-ADD     *ZERO         @RDSPB           15 0
     C                   Z-ADD     *ZERO         F3RBAT           15 0
     C                   Z-ADD     *ZERO         F3RSAT           15 0
     C                   MOVE      *BLANK        F3RBCY            3
     C                   MOVE      *BLANK        F3RSCY            3
     C                   Z-ADD     *ZEROS        F3RVDT            8 0
     C                   Z-ADD     *ZEROS        F3ROTD            8 0
      *
      ** IF PRESENT, GET THE RELATED DEAL
      ** AND SET THE 'RELATED DEAL' FIELDS
      *
     C     Z#WSTS        IFNE      *BLANK

     C                   MOVEL     Z#WSTS        FXVFXDL

     C                   MOVE      F3BCDE        @RDELB
     C                   MOVE      F3DSBE        @RDSPB
     C                   Z-ADD     F3DBUY        F3RBAT
     C                   Z-ADD     F3DSEL        F3RSAT
     C     F3DAM1        IFGE      0
     C                   MOVE      F3CCY1        F3RBCY
     C                   MOVE      F3CCY2        F3RSCY
     C                   ELSE
     C                   MOVE      F3CCY2        F3RBCY
     C                   MOVE      F3CCY1        F3RSCY
     C                   END
     C                   MOVE      F3VDYY        @D1YY
     C                   MOVE      F3VDMM        @D1MM
     C                   MOVE      F3VDDD        @D1DD
     C                   MOVE      DATE1         F3RVDT
     C                   MOVE      F3DOEY        @D1YY
     C                   MOVE      F3DOEM        @D1MM
     C                   MOVE      F3DOED        @D1DD
     C                   MOVE      DATE1         F3ROTD
     C                   END
      *
      ** INITIALIZE BEFORE UPDATE DEAL BASE CCY FOR DEALING EQUIVALENT
      ** INITIALIZE BEFORE UPDATE DEAL SPOT BASE CCY FOR DEALING EQUIVALENT
      ** INITIALIZE BEFORE UPDATE DEAL 1ST AND 2ND AMOUNTS
      ** INITIALIZE BEFORE UPDATE DEAL BUY AND SELL CURRENCIES
      ** INITIALIZE BEFORE UPDATE DEAL VALUE DATE AND OPTION TO DATE
      *
     C                   Z-ADD     *ZEROS        @DEALB
     C                   Z-ADD     *ZEROS        @SPOTB
     C                   Z-ADD     *ZEROS        @AMT1B
     C                   Z-ADD     *ZEROS        @AMT2B
     C                   MOVE      *BLANK        F3BBCY
     C                   MOVE      *BLANK        F3BSCY
     C                   Z-ADD     *ZEROS        F3BVDT
     C                   Z-ADD     *ZEROS        F3BOTD
      *
      ** IF NOT INSERT, GET THE 'BEFORE' STATUS OF THE DEAL
      ** AND SET THE 'BEFORE UPDATE' FIELDS
      *
     C     @@LACT        IFNE      'I'

     C                   MOVEL     Z#BSTS        FXVFXDL

     C                   MOVE      F3BCDE        @DEALB           15 0
     C                   MOVE      F3DSBE        @SPOTB           15 0
     C                   MOVE      F3DAM1        @AMT1B           15 0
     C                   MOVE      F3DAM2        @AMT2B           15 0
     C     F3DAM1        IFGE      0
     C                   MOVE      F3CCY1        F3BBCY            3
     C                   MOVE      F3CCY2        F3BSCY            3
     C                   ELSE
     C                   MOVE      F3CCY1        F3BSCY
     C                   MOVE      F3CCY2        F3BBCY
     C                   END
     C                   MOVE      F3VDDD        @D1DD
     C                   MOVE      F3VDMM        @D1MM
     C                   MOVE      F3VDYY        @D1YY
     C                   MOVE      DATE1         F3BVDT            8 0
     C                   MOVE      F3DOED        @D1DD
     C                   MOVE      F3DOEM        @D1MM
     C                   MOVE      F3DOEY        @D1YY
     C                   MOVE      DATE1         F3BOTD            8 0
     C                   END
      *
      * GET THE 'AFTER' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#ASTS        FXVFXDL
      *
      ** Make sell amount negative
      *
     C                   Z-SUB     F3DSEL        F3DSEL
      *
      ** FIND AND STORE DEAL BUY AMOUNT AND SELL AMOUNT AND CURRENCY
      ** ALSO STORE INDICATION OF WHICH AMOUNT (1 OR 2) IS BUY AND SELL
      *
     C     F3DAM1        IFGE      0
     C                   MOVE      F3DAM1        @BUYA            15 0
     C                   MOVE      F3CCY1        @BUYC             3
     C                   MOVE      '1'           @B12              1
     C                   MOVE      F3DAM2        @SELA            15 0
     C                   MOVE      F3CCY2        @SELC             3
     C                   MOVE      '2'           @S12              1
     C                   ELSE
     C                   MOVE      F3DAM2        @BUYA
     C                   MOVE      F3CCY2        @BUYC
     C                   MOVE      '2'           @B12              1
     C                   MOVE      F3DAM1        @SELA
     C                   MOVE      F3CCY1        @SELC
     C                   MOVE      '1'           @S12              1
     C                   END
      *
      ** STORE VALUE DATE FROM DEAL
      *
     C                   MOVE      F3VDYY        @D1YY
     C                   MOVE      F3VDMM        @D1MM
     C                   MOVE      F3VDDD        @D1DD
     C                   MOVE      DATE1         @VDAT             8 0
      *
      ** CONVERT VALUE DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      @VDAT         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @VDAT5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @VDAT5
     C                   END
      *
      ** STORE OPTION TO DATE FROM DEAL
      *
     C                   MOVE      F3DOEY        @D1YY
     C                   MOVE      F3DOEM        @D1MM
     C                   MOVE      F3DOED        @D1DD
     C                   MOVE      @DATE1        @ODAT             8 0
      *
      ** CONVERT OPTION DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      @ODAT         @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @ODAT5            5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @ODAT5
     C                   END
      *
      ** INITIALISE P/L ACCUMULATORS
      *
     C     1             OCCUR     @PRLOS
     C                   Z-ADD     0             @SPLO
     C                   Z-ADD     0             @FPLO
     C                   MOVE      @BUYC         @PCCY
     C                   MOVE      'N'           @ADJAD
     C     2             OCCUR     @PRLOS
     C                   Z-ADD     0             @SPLO
     C                   Z-ADD     0             @FPLO
     C                   MOVE      @SELC         @PCCY
     C                   MOVE      'N'           @ADJAD
      *
     C                   ENDSR
      *******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    @@LACT            1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
      *
      ** Keylist for FXCRSCLL
      *
     C     @CCKEY        KLIST
     C                   KFLD                    @CPCCY            3
     C                   KFLD                    @CSCCY            3
      *
      ** Keylist for FXEPOCLL
      *
     C     @EPKEY        KLIST
     C                   KFLD                    @EECCY            3
     C                   KFLD                    @EPCCY            3

     C                   MOVEL     'FXFXDLUPT'   DBPGM
      *
      ** ACCESS BANK DETAILS VIA ACCESS PROGRAM TO GET RUN DATES
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** MIDAS RUN DATE
      *
     C                   MOVE      BJMRDT        RUNA              7
      *
      ** ACCESS TREASURY MANAGEMENT DETAILS VIA ACCESS PROGRAM
      *
     C                   CALL      'AOTRMAR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRMA        PARM      SDTRMA        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRMAPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C     KEY1          KLIST
     C                   KFLD                    XPCCY
     C                   KFLD                    XPTPRD
     C                   KFLD                    XPPRD
      *
      ** Local currency
      *
     C                   MOVEL     BJLCCY        XPCCY
      *
      ** If short period end date is not spot, get this period date
      *
     C     ERSPRE        IFNE      'SP'
     C     ERSPRE        LOOKUP    TAB1          TAB2                     50
     C                   MOVEL     TAB2          @TEMP             1
     C                   MOVE      TAB2          XPTPRD
     C                   MOVE      @TEMP         XPPRD
     C     KEY1          CHAIN     FDCCYPLL                           63
     C     *IN63         IFEQ      '1'
     C     XPDLTF        OREQ      '*'
     C                   MOVEL     XPPRD         DBKEY
     C                   MOVE      XPTPRD        DBKEY
     C                   MOVEL     'FDCCYPLL'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** If short period end date IS spot, get this date
      *
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      XPCCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     XPCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   MOVEL     A6FXSD        XPPRDD
     C                   END
      *
      ** CONVERT FORWARD DATE TO MIDAS DAY NUMBER
      *
     C                   MOVE      XPPRDD        @@DTIN
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        @FWD5             5 0
     C                   ELSE
     C                   MOVE      *ZEROS        @FWD5
     C                   END
      *
      ** ACCESS DEALING DETAILS VIA ACCESS PROGRAM TO GET RUN DATES
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** OBTAIN BASE CURRENCY FOR DEALING DECIMAL PLACES
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BNCYDL        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     BNCYDL        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR
     C                   END

     C     *LIKE         DEFINE    A6NBDP        @@NDPB
     C                   Z-ADD     A6NBDP        @@NDPB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FXFXDLUPT'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @DP USED BY SR. ZA0680 - DECIMAL PLACES CORRECTION ARRAY
1000000010000000100000001000000010000000100000001
** @YD  USED BY SR. ZA0680 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZA0680 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
** TAB1 AND TAB2 TO DETERMINE SHORT OR FORWARD P/L PERIOD
OVR 0D
TOMN1D
SPN 2D
SP1W1W
SP2W2W
SP3W3W
SP1M1M
SP2M2M
SP3M3M
SP6M6M
SP9M9M
SPYR1Y
