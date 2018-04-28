     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA convert file to screen format')           *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRACVT - Forward Rate Agreements Conversion:               *
      *             File to Screen Format                             *
      *                                                               *
      *  Function:  This module converts the fields of an FRA deal    *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 245692             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 258454             Date 15Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4535            Date 13Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CIR011             Date 15Feb02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 164607             Date 19Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 154453             Date 11Mar99               *
      *                 CAP003  *CREATE    Date 22May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  258454 - Collateral Agreement Ind. field on the screen is    *
      *           correctly populated.                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4535- Error code MMA0064 when attempting to authorise a   *
      *           completed FRA                                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - Recompile for Swift 97                              *
      *  164607 - Amounts in FRA/IRS inputs should not be editted     *
      *           using decimal separator from SDDEALPD               *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  154453 - Allow 5 digit in integer part of the base ccy rate. *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Include the MM standard declares
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Deal Status
     D*@STSA****       S             24    DIM(2) CTDATA PERRCD(1)
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)
 
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
     D DGLCD         E                     EXTFLD(LCD)
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(IRFRAPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  @@SXP1                 1      1  0
     D  @@SXP2                 2      2  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CIR008          S              1A
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D CAS006          S              1
 
     D CIR011          S              1A
     D PDADJ           S              1  0
     D PUFRFD          S              2  0
     D PTFRFD          S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
     C*
     C**  Deal number.
     C                   MOVE      DLNO          SDLNO
     C*
     C**  Deal type.
     C                   MOVE      DTYP          SDTYP
     C*
     C**  Deal sub-type.
     C                   MOVE      DLST          SDLST
     C*
     C** Deal date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C                   CALLB     'ZDATE2'
     C                   PARM      DDAT          WQ0001            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
     C**
     C                   MOVE      ZDATE         SDDAT
     C*
     C**  Branch code.
     C     BRCA          IFNE      *BLANKS
     C                   MOVE      BRCA          SBRCA
     C                   END
     C*
     C**  Broker Code.
     C                   MOVE      BRKC          SBRKC
     C*                                                                                       258454
     C**  Collateral Agreement Indicator                                                      258454
     C                   MOVE      CAIN          SCAIN                                        258454
     C*
     C**  Brokerage amount.
     C*
     C     BAGE          IFEQ      *ZERO
     C                   MOVE      *BLANKS       SBAGE
     C                   END
     C*
     C**  If Brokerage a number, reformat
     C*
     C     BAGE          IFNE      *ALL'9'
     C     BAGE          ANDNE     *ZERO
     C*
     C** Access currency for number of decimal places of broker currency.
     C*
     C                   MOVE      UCUCY         @AJCD
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C** Format brokerage
     C                   Z-ADD     BAGE          @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVEL     @@AMTD        SBAGE                                       BUG4535
     C**********         MOVE      @@AMTD        SBAGE                                       BUG4535
     C                   END
     C*
     C**  Linked Deal Number.
     C     LNKDN         IFEQ      *ZERO
     C                   MOVE      *BLANKS       SLNKDN
     C                   ELSE
     C                   MOVE      LNKDN         SLNKDN
     C                   END
     C*
     C**  Customer.
     C**  Customer can be displayed in cust. no. or shortname format
     C**  depending on ICD flag
     C*
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     CNUM          SCNUM
     C                   ELSE
     C*
     C** Access customer file for shortname
     C                   MOVEL     CNUM          @CLKEY
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CLKEY           10
     C                   PARM      '       '     @KYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *  Error if not on file
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     CNUM          DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     BBCSSN        SCNUM
     C                   END
     C*
     C                   END
     C*
     C**  Value date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C                   CALLB     'ZDATE2'
     C                   PARM      VDAT          WQ0001
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C**
     C                   MOVE      ZDATE         SVDAT
     C*
     C**  Maturity Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C                   CALLB     'ZDATE2'
     C                   PARM      MDAT          WQ0001
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C**
     C                   MOVE      ZDATE         SMDAT
     C*
     C**  Account Sequence Number.
     C     CDAS          IFNE      0
     C                   MOVE      CDAS          SCDAS
     C                   END
     C*
     C**  Currency Code.
     C                   MOVE      UCUCY         SUCUCY
     C*
     C**  Deal Amount.
     C*
     C** Access currency for number of decimal places of deal currency.
     C*
     C                   MOVE      UCUCY         @AJCD
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Format Deal Amount, using deal ccy decimal places
     C     UPAMT         IFLT      0
     C                   Z-SUB     UPAMT         @@AMTW
     C                   ELSE
     C                   Z-ADD     UPAMT         @@AMTW
     C                   END
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SUPAMT
     C*
     C**  Federal funds indicator
      **  (Federal Funds Indicator is a bit setting on DEALSDG)
     C                   TESTB     '2'           UDSTI                    77
     C     *IN77         IFEQ      '1'
     C                   MOVE      'Y'           SUFFI
     C                   ELSE
     C                   MOVE      *BLANK        SUFFI
     C                   END
     C*
     C**  Base Currency Rate.
     C**  Scale the Base Currency Exchange Rate.
     C*
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     UBCXR         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 8 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      100000000     @@AMTW
     C                   Z-ADD     8             @@QECN
      *
      * Fix to allow for 5 integers, if required (& only 7 decimal)
     C                   MOVE      *ZERO         WPOS1             1 0
     C                   MOVEL     @@SCRT        WPOS1
     C     WPOS1         IFNE      *ZERO
     C                   Z-ADD     7             @@QECN
     C     @@AMTW        DIV       10            @@AMTW
     C                   END
      *
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SUBCXR
     C                   END
     C*
     C**  Book code.
     C                   MOVE      BOKC          SBOKC
     C*
     C**  Interest Calculation Basis.
     C**  If the value is zero display blanks on screen
     C     UICBS         IFNE      0
     C                   MOVE      UICBS         SUICBS
     C                   ELSE
     C                   MOVE      *BLANKS       SUICBS
     C                   END
     C*
     C**  Taxable Indicator.
     C*
     C** IF BRT SAR IS INSTALLED
     C*
     C     S01383        IFEQ      'Y'
     C                   MOVE      TAXI          STAXI
     C                   ELSE
     C     TAXI          IFEQ      *BLANKS
     C                   MOVE      'N'           STAXI
     C                   ELSE
     C                   MOVE      TAXI          STAXI
     C                   END
     C                   END
     C*
     C**  Rate Fix Days.
     C     BYSL          IFEQ      'B'
 
     C     CIR011        IFEQ      'Y'
 
      ** Get The rate fix days from the currency file
 
     C                   MOVE      UCUCY         @AJCD
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6FXDY        PDADJ
     C     TFRFD         ADD       PDADJ         PTFRFD
     C                   MOVE      PTFRFD        SUFRFD
 
     C                   ELSE
     C/COPY WNCPYSRC,IRFRANC001
     C                   MOVE      TFRFD         SUFRFD
     C                   ENDIF
 
     C/COPY WNCPYSRC,IRFRANC002
     C                   ELSE
 
     C     CIR011        IFEQ      'Y'
 
      ** Get the rate fix days from the currency file
 
     C                   MOVE      UCUCY         @AJCD
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6FXDY        PDADJ
     C     UFRFD         ADD       PDADJ         PUFRFD
     C                   MOVE      PUFRFD        SUFRFD
 
     C                   ELSE
 
     C/COPY WNCPYSRC,IRFRANC003
     C                   MOVE      UFRFD         SUFRFD
     C                   ENDIF
 
     C/COPY WNCPYSRC,IRFRANC004
     C                   END
     C*
     C**  Profit Centre
     C                   MOVE      PRFC          SPRFC
     C*
     C**  Originating Branch
     C                   MOVE      ORBR          SORBR
     C*
     C**  Buy/Sell Indicator.
     C                   MOVE      BYSL          SBYSL
     C*
     C**  Settlement Formula.
     C                   MOVE      SETF          SSETF
     C*
     C**  Reference Rate.
     C     BYSL          IFEQ      'B'
     C                   MOVE      TBRTT         SRFRTE
     C                   ELSE
     C                   MOVE      UBRTT         SRFRTE
     C                   ENDIF
     C
     C**  Contract Rate.
     C**  Scale the 'Our Spread Rate'.
     C*
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C     BYSL          IFEQ      'B'
     C                   Z-ADD     URTSP         @@INRT
     C                   ELSE
     C                   Z-ADD     TRTSP         @@INRT
     C                   ENDIF
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 7 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCRTE
     C                   END
      *
      ** Format Risk Value Factor
      *
     C                   IF        CAS006 = 'Y'
     C                   EVAL      SRKSN = FSRKSN
     C                   EVAL      @@AMTW = FSRKVL * 10000000
     C                   EVAL      @@QECN = 7
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SRKVL
     C                   ENDIF
      *
      ** If FRA/IRS Business Day Conventions SAR installed.
      *
     C     CIR005        IFEQ      'Y'
      *
     C                   MOVE      L1CYR1        SCYR1
     C                   MOVE      L1CYR2        SCYR2
     C                   MOVE      L1CYR3        SCYR3
     C                   MOVE      L1CYR4        SCYR4
     C                   MOVE      L1CYR5        SCYR5
     C                   MOVE      L1CYR6        SCYR6
     C                   MOVE      L1CYR7        SCYR7
     C                   MOVE      L1CYR8        SCYR8
     C                   MOVE      L1CYR9        SCYR9
     C                   MOVE      L1CYR0        SCYR0
      *
     C                   ENDIF
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      CLAS          SCLAS                                        CDL038
     C*
     C**  Set up text for deal status.
     C*
     C     RECI          IFEQ      'R'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
     C*
     C     RECI          IFEQ      'M'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
     C*
     C                   IF        CIR008 = 'Y' AND RECI = 'D'
     C                   SELECT
     C                   WHEN      FIDSTS = 'C'
     C                   EVAL      DDSTS = @STSA(3)
     C                   WHEN      FIDSTS = 'A'
     C                   EVAL      DDSTS = @STSA(4)
     C                   WHEN      FIDSTS = 'R'
     C                   EVAL      DDSTS = @STSA(5)
     C                   ENDSL
     C                   ENDIF
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCLRAT - SCALE RATE                                           *
      *****************************************************************
     C     SCLRAT        BEGSR
      *
     C                   CALLB     'ZA1150'
     C                   PARM                    @@SXP1            1 0
     C                   PARM                    @@SXP2            1 0
     C***********        PARM                    @@INRT           12 8
     C                   PARM                    @@INRT           13 8
     C                   PARM                    @@FCMD            1
     C***********        PARM      *ZEROS        @@SCRT           12 8
     C***********        PARM      *ZEROS        @@ISRT           12 8
     C                   PARM      *ZEROS        @@SCRT           13 8
     C                   PARM      *ZEROS        @@ISRT           13 8
     C                   PARM      *ZEROS        @@ERCD            1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAL FORMAT)
      *
     C                   MOVEL     SACCD         ##ACTN            1
     C                   MOVEL     *BLANK        DealScnFmt
     C                   MOVEL     ##ACTN        SACCD
     C                   MOVEL     *BLANK        DDSTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Deal in file format
     C                   PARM                    DealFilFmt
 
      ** Switchable feature CIR008
     C                   PARM                    CIR008
      *
      * Output parameters
      *
      * Deal in screen format
     C                   PARM                    DealScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Initialize program name
      *
     C                   MOVEL     'IRFRACVT'    DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *****************************************************************                       245692
      **EDIT*AMOUNTS*WITH*'.'******************************************                       245692
      *****************************************************************                       245692
     C**********         MOVE      '.'           BNDCSP                                       245692
      *
      ** ACCESS MIDAS MODULES
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Basic Rate Tax
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01383'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Customer Format
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *
      **  Access SAR details file to determine if Bus. Day Convention is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     907           DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR005            1
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR011 is *ON
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     'CIR011'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR011
     C                   ELSE
     C                   MOVEL     'N'           CIR011
     C                   ENDIF
      *
      ** Access SAR details file to determine if Hedge Accounting Phase B is
      ** installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     908           DBASE
     C                   MOVEL     'CAS006'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CAS006
     C                   ELSE
     C                   MOVEL     'N'           CAS006
     C                   ENDIF
 
     C/COPY WNCPYSRC,IRFRANC005
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TEXT FOR DEAL STATUS
DELETED
MATURED
COMPLETED
AUTHORISED
REQUIRES REAUTHORISATION
