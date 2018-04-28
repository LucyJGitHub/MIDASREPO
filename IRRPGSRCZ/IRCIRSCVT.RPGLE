     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS convert file to scrn fmt')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSCVT - Cross  Ccy Interest Rate Swaps Conversion:       *
      *             File to Screen Format                             *
      *                                                               *
      *  Function:  This module converts the fields of a              *
      *             Cross Currency Interest Swap Deal                 *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 245692             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 244404             Date 13Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11950           Date 25Aug06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6544            Date 08Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA081             Date 07Apr04               *
      *                 TDA081             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 219135             Date 26May03               *
      *                 218641             Date 10Jun03               *
      *                 CIR011             Date 15Apr02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208053             Date 12Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 164607             Date 19Jul99               *
      *                 163378             Date 02Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 154453             Date 11Mar99               *
      *                 CAP003  *CREATE    Date 22Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  244404 - Setup Buy out amount correctly                      *
      *         - annotated as BUG11950                               *
      *  BUG11950 - A serious Midas error upon completion of          *
      *             Transaction                                       *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6544- Formatted buy amount is put into wrong field        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines                                        *
      *  TDA081 - Improve first TDA081 changes.                       *
      *  TDA081 - Fix will ensure that the correct value of rate fix  *
      *           day will be shown on the screen.                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  219135 - Collateral Agreement Indicator does not display     *
      *           upon enquire.                                       *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  208053 - Decimal point missing in Brokerage Amount.  Amended *
      *           program in a way that currency used for identifying *
      *           number of decimal places is based on Broker code.   *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date. (Recompiled)                 *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - Recompile for Swift 97 changes (MT34* & MT36*)      *
      *  164607 - Amounts in FRA/IRS inputs should not be editted     *
      *           using decimal separator from SDDEALPD               *
      *  163378 - Our/ Their  Fix/Floating  Rate Days  is defaulting  *
      *           to '02'  instead to  '00' . Amended the pgm to      *
      *           default to '00' if no value entered .               *
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
     D*@STSA****       S             24    DIM(2) CTDATA PERRCD(1)                            CIR008
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)                            CIR008
 
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
     D DGLCD         E                     EXTFLD(LCD)
     D  BsDayFil            2063   2190                                         CIR005
                                                                                              CLE025
      * Deal Extension in File Format                                                         CLE025
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(IRCIRSPD)
     D**BsDayScn*************243    370                                                CIR005 218641
     D**BsDayScn*************253    380                                                218641 CAS005
     D**BsDayScn*************263    390                                                CAS005 CLE025
     D**BsDayScn             278    405                                               CLE025 BUG6472
     D  BsDayScn             288    415                                                      BUG6472
 
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
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)                                  208053
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     208053
                                                                                              208053
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
                                                                                              CIR008
     D CIR008          S              1A                                                      CIR008
     D CDL028          S              1A                                                      CDL028
                                                                                              CAS001
      ** Variables defined for CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
 
     D CIR011          S              1A                                                      CIR011
     D PNDADJ          S              1  0                                                    CIR011
     D PUFRFD          S              2  0                                                    CIR011
     D PTFRFD          S              2  0                                                    CIR011
                                                                                              CAP043
     D CIR001          S              1A                                                      CAP043
     D WUNBDP          S              1  0                                                    CAP043
     D WTNBDP          S              1  0                                                    CAP043
                                                                                              CAS005
      ** Variables defined for CAS005                                                         CAS005
     D CAS005          S              1A                                                      CAS005
 
     D CLE025          S              1A                                                      CLE025
                                                                                              CLE025
      ** Variables defined for CAS008                                                         CAS008
     D CIR003          S              1A                                                      CAS008
     D CAS008          S              1A                                                      CAS008
                                                                                              CAS008
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
     C                   PARM      DDAT          WQ0001            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C**
     C                   MOVE      ZDATE         SDDAT
     C*
     C**  Branch code.
     C     BRCA          IFNE      *BLANKS
     C                   MOVE      BRCA          SBRCA
     C                   END
                                                                                              219135
      ** Output file field collateral agr. Ind. to screen field.                              219135
                                                                                              219135
     C                   EVAL      SCAIN = CAIN                                               219135
     C*
     C**  Broker Code.
     C                   MOVE      BRKC          SBRKC
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
     C                   CALLB     'AOBROKR0'                                                 208053
     C                   PARM      *BLANK        @RTCD             7                          208053
     C                   PARM      '*KEY   '     @OPTN             7                          208053
     C                   PARM      BRKC          @BQTX             4                          208053
     C     SDBROK        PARM      SDBROK        DSSDY                                        208053
      *                                                                                       208053
     C**********         MOVE      UCUCY         @AJCD                                        208053
     C                   MOVE      A9BRCY        @AJCD                                        208053
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
     C                   MOVE      @@AMTD        SBAGE
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
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
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
     C                   PARM      VDAT          WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         SVDAT
     C*
     C**  Maturity Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C                   CALLB     'ZDATE2'
     C                   PARM      MDAT          WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         SMDAT
     C*
     C**  Account Sequence Number.
     C     CDAS          IFNE      0
     C                   MOVE      CDAS          SCDAS
     C                   END
     C*
     C**  Book code.
     C                   MOVE      BOKC          SBOKC
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
     C**  Profit Centre
     C                   MOVE      PRFC          SPRFC
     C*
     C**  Originating Branch
     C                   MOVE      ORBR          SORBR
     C*
     C**  Value Date Exchange Indicator
     C                   MOVE      VDEI          SVDEI
     C*
     C**  Maturity Date Exchange Indicator
     C                   MOVE      MDEI          SMDEI
     C*
     C**  Principal Change Date Exchange Indicator
     C                   MOVE      PDEI          SPDEI
     C*
     C**  Our Currency Code.
     C                   MOVE      UCUCY         SUCUCY
     C*
     C**  Our Deal Amount.
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
     C                   Z-ADD     A6NBDP        WUNBDP                                       CAP043
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SUPAMT
     C*
     C**  Our Federal funds indicator
      **  (Federal Funds Indicator is a bit setting on DEALSDG)
     C                   TESTB     '2'           UDSTI                    77
     C     *IN77         IFEQ      '1'
     C                   MOVE      'Y'           SUFFI
     C                   ELSE
     C                   MOVE      *BLANK        SUFFI
     C                   END
     C*
     C**  Our Base Currency Rate.
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
      *                                                                         154453
      * Fix to allow for 5 integers, if required (& only 7 decimal)             154453
     C                   MOVE      *ZERO         WPOS1             1 0          154453
     C                   MOVEL     @@SCRT        WPOS1                          154453
     C     WPOS1         IFNE      *ZERO                                        154453
     C                   Z-ADD     7             @@QECN                         154453
     C     @@AMTW        DIV       10            @@AMTW                         154453
     C                   END                                                    154453
      *                                                                         154453
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SUBCXR
     C                   END
     C*
     C**  Our Base Rate Code
     C     UBRTT         IFNE      *ZERO
     C                   MOVE      UBRTT         SUBRTT
     C                   ENDIF
     C*
     C**  Our Spread/Rate.
     C**  Scale the 'Our Spread Rate'.
     C*
     C     URTSP         IFNE      *ZERO
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     URTSP         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 7 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SURTSP
     C                   END
     C                   END
     C*
     C**  Our Spread Indicator
     C                   MOVE      USPIN         SUSPIN
     C*
     C**  Our Rate Fix Days.
     C*****UFRFD         IFNE      *ZERO                                                      TDA081
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     UICFR         ANDNE     'O'                                                        CIR011
     C     UBRTT         ANDNE     *ZERO                                                      TDA081
                                                                                              CIR011
      ** Get The rate fix days from the currency file                                         CIR011
                                                                                              CIR011
     C                   MOVE      UCUCY         @AJCD                                        CIR011
                                                                                              CIR011
     C                   CALLB     'AOCURRR0'                                                 CIR011
     C                   PARM      *BLANK        @RTCD                                        CIR011
     C                   PARM      '*KEY   '     @OPTN                                        CIR011
     C                   PARM                    @AJCD                                        CIR011
     C     SDCURR        PARM      SDCURR        DSSDY                                        CIR011
                                                                                              CIR011
     C                   Z-ADD     A6FXDY        PNDADJ                                       CIR011
     C     UFRFD         ADD       PNDADJ        PUFRFD                                       CIR011
     C                   MOVE      PUFRFD        SUFRFD                                       CIR011
                                                                                              CIR011
     C                   ELSE                                                                 CIR011
     C     UFRFD         IFNE      *ZERO                                                      TDA081
     C/COPY WNCPYSRC,IRCIRSNC01
     C                   MOVE      UFRFD         SUFRFD
     C                   ELSE                                                                 TDA081
     C     UBRTT         IFNE      *ZERO                                                      TDA081
     C                   MOVE      '00'          SUFRFD                                       TDA081
     C                   ENDIF                                                                TDA081
     C                   ENDIF                                                                TDA081
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C/COPY WNCPYSRC,IRCIRSNC02
     C**********         ELSE                                                          163378 TDA081
     C*****UBRTT         IFNE      *ZERO                                               163378 TDA081
     C**********         MOVE      '00'          SUFRFD                                163378 TDA081
     C**********         END                                                           163378 TDA081
     C**********         END                                                                  TDA081
     C*
     C**  Our Rate Change Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C     UNICD         IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      UNICD         WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         SUNICD
     C                   END
     C*
     C**  Our Rate Change Frequency
     C                   MOVE      UICFR         SUICFR
     C*
     C**  Our Rate Change Day in Month
     C     UICFD         IFNE      *ZERO
     C                   MOVE      UICFD         SUICFD
     C                   END
     C*
     C**  Our Short Term Rate.
     C**  Scale the Rate
     C*
     C                   TESTB     '0'           UDNSI                    85
     C     *IN85         IFEQ      '1'
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     UEINR         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 7 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C     @@AMTW        IFLT      0                                                         BUG6472
     C                   MULT      -1            @@AMTW                                      BUG6472
     C                   ENDIF                                                               BUG6472
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SUEINR
     C                   END
     C                   END
      *                                                                                      BUG6472
      ** Output sign of our short term interest rate                                         BUG6472
      *                                                                                      BUG6472
     C     SUEINR        IFEQ      *BLANKS                                                   BUG6472
     C                   MOVE      ' '           SUSSGN                                      BUG6472
     C                   ELSE                                                                BUG6472
      *                                                                                      BUG6472
     C     UEINR         IFLT      0                                                         BUG6472
     C                   MOVE      '-'           SUSSGN            1                         BUG6472
     C                   ELSE                                                                BUG6472
     C                   MOVE      '+'           SUSSGN                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C                   ENDIF                                                               BUG6472
     C*
     C**  Our Next Interest Payment Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C     UNIPD         IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      UNIPD         WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         SUNIPD
     C                   END
     C*
     C**  Our Interest Payment Frequency
     C                   MOVE      UIPFR         SUIPFR
     C*
     C**  Our Interest Payment Day in Month
     C     UIPFD         IFNE      *ZERO
     C                   MOVE      UIPFD         SUIPFD
     C                   END
     C*
     C**  Our Interest Calculation Basis.
     C                   MOVE      UICBS         SUICBS
                                                                                              CAS001
      ** If CAS001 in on, convert our yield curve to screen format                            CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   MOVE      FSOYLC        SOYLC                                        CAS001
     C                   ENDIF                                                                CAS001
     C*
     C**  Their Currency Code.
     C                   MOVE      TCUCY         STCUCY
     C*
     C**  Their Deal Amount.
     C*
     C** Access currency for number of decimal places of deal currency.
     C*
     C                   MOVE      TCUCY         @AJCD
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C**  Format Deal Amount, using deal ccy decimal places
     C     UPAMT         IFLT      0
     C                   Z-SUB     TPAMT         @@AMTW
     C                   ELSE
     C                   Z-ADD     TPAMT         @@AMTW
     C                   END
     C                   Z-ADD     A6NBDP        @@QECN
     C                   Z-ADD     A6NBDP        WTNBDP                                       CAP043
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STPAMT
     C*
     C**  Their Federal funds indicator
      **  (Federal Funds Indicator is a bit setting on DEALSDG)
     C                   TESTB     '2'           TDSTI                    77
     C     *IN77         IFEQ      '1'
     C                   MOVE      'Y'           STFFI
     C                   ELSE
     C                   MOVE      *BLANK        STFFI
     C                   END
     C*
     C**  Their Base Currency Rate.
     C**  Scale the Base Currency Exchange Rate.
     C*
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     TBCXR         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 8 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      100000000     @@AMTW
     C                   Z-ADD     8             @@QECN
      *                                                                         154453
      * Fix to allow for 5 integers, if required (& only 7 decimal)             154453
     C                   MOVE      *ZERO         WPOS1             1 0          154453
     C                   MOVEL     @@SCRT        WPOS1                          154453
     C     WPOS1         IFNE      *ZERO                                        154453
     C                   Z-ADD     7             @@QECN                         154453
     C     @@AMTW        DIV       10            @@AMTW                         154453
     C                   END                                                    154453
      *                                                                         154453
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STBCXR
     C                   END
     C*
     C**  Their Base Rate Code
     C     TBRTT         IFNE      *ZERO
     C                   MOVE      TBRTT         STBRTT
     C                   END
     C*
     C**  Their Spread/Rate.
     C**  Scale the 'Their Spread Rate'.
     C*
     C     TRTSP         IFNE      *ZERO
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     TRTSP         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 7 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STRTSP
     C                   END
     C                   END
     C*
     C**  Their Spread Indicator
     C                   MOVE      TSPIN         STSPIN
     C*
     C**  Their Rate Fix Days.
     C*****TFRFD         IFNE      *ZERO                                                      TDA081
      *                                                                                       CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     TICFR         ANDNE     'O'                                                        CIR011
     C     TBRTT         ANDNE     *ZERO                                                      TDA081
                                                                                              CIR011
      ** Get The rate fix days from the currency file                                         CIR011
                                                                                              CIR011
     C                   MOVE      TCUCY         @AJCD                                        CIR011
                                                                                              CIR011
     C                   CALLB     'AOCURRR0'                                                 CIR011
     C                   PARM      *BLANK        @RTCD                                        CIR011
     C                   PARM      '*KEY   '     @OPTN                                        CIR011
     C                   PARM                    @AJCD                                        CIR011
     C     SDCURR        PARM      SDCURR        DSSDY                                        CIR011
                                                                                              CIR011
     C                   Z-ADD     A6FXDY        PNDADJ                                       CIR011
     C     TFRFD         ADD       PNDADJ        PTFRFD                                       CIR011
     C                   MOVE      PTFRFD        STFRFD                                       CIR011
                                                                                              CIR011
     C                   ELSE                                                                 CIR011
     C     TFRFD         IFNE      *ZERO                                                      TDA081
     C/COPY WNCPYSRC,IRCIRSNC03
     C                   MOVE      TFRFD         STFRFD
     C**********         ENDIF                                                         CIR011 TDA081
                                                                                              CIR011
     C/COPY WNCPYSRC,IRCIRSNC04
     C                   ELSE                                               163378
     C     TBRTT         IFNE      *ZERO                                    163378
     C                   MOVE      '00'          STFRFD                     163378
     C                   END                                                163378
     C                   END
     C                   END                                                                  TDA081
     C*
     C**  Their Rate Change Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C     TNICD         IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      TNICD         WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         STNICD
     C                   END
     C*
     C**  Their Rate Change Frequency
     C                   MOVE      TICFR         STICFR
     C*
     C**  Their Rate Change Day in Month
     C     TICFD         IFNE      *ZERO
     C                   MOVE      TICFD         STICFD
     C                   END
     C*
     C**  Their Short Term Rate.
     C**  Scale the Rate
     C*
     C                   TESTB     '0'           TDNSI                    85
     C     *IN85         IFEQ      '1'
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     TEINR         @@INRT
     C                   MOVE      'M'           @@FCMD
     C                   EXSR      SCLRAT
     C*
     C**  Format the rate, using 7 decimal places
     C*
     C     @@SCRT        IFNE      0
     C     @@SCRT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C     @@AMTW        IFLT      0                                                         BUG6472
     C                   MULT      -1            @@AMTW                                      BUG6472
     C                   ENDIF                                                               BUG6472
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STEINR
     C                   END
     C                   END
      *                                                                                      BUG6472
      ** Output sign of their short term interest rate                                       BUG6472
      *                                                                                      BUG6472
     C     STEINR        IFEQ      *BLANKS                                                   BUG6472
     C                   MOVE      ' '           STSSGN                                      BUG6472
     C                   ELSE                                                                BUG6472
      *                                                                                      BUG6472
     C     TEINR         IFLT      0                                                         BUG6472
     C                   MOVE      '-'           STSSGN            1                         BUG6472
     C                   ELSE                                                                BUG6472
     C                   MOVE      '+'           STSSGN                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C                   ENDIF                                                               BUG6472
     C*
     C**  Their Next Interest Payment Date.
     C** Call ZDATE2 to convert date from Midas Dayno. format to
     C** DDMMYY format.
     C*
     C     TNIPD         IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      TNIPD         WQ0001                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE                         Run-date in DDM
     C**
     C                   MOVE      ZDATE         STNIPD
     C                   END
     C*
     C**  Their Interest Payment Frequency
     C                   MOVE      TIPFR         STIPFR
     C*
     C**  Their Interest Payment Day in Month
     C     TIPFD         IFNE      *ZERO
     C                   MOVE      TIPFD         STIPFD
     C                   END
     C*
     C**  Their Interest Calculation Basis.
     C                   MOVE      TICBS         STICBS
                                                                                              CAS001
      ** If CAS001 in on, convert our yield curve to screen format                            CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   MOVE      FSTYLC        STYLC                                        CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** If CAS005 is installed, convert our/their forward yield curves                       CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   MOVE      FSOFYC        SOFYC                                        CAS005
     C                   MOVE      FSTFYC        STFYC                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS008
      ** If CIR003 and CAS008 are installed, convert our/their                                CAS008
      ** forward commitment yield curves                                                      CAS008
                                                                                              CAS008
     C                   IF        CIR003 = 'Y' AND                                           CAS008
     C                             CAS008 = 'Y'                                               CAS008
     C                   EVAL      SOFCC  = FSOFCC                                            CAS008
     C                   EVAL      STFCC  = FSTFCC                                            CAS008
     C                   ENDIF                                                                CAS008
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
     C                   IF        CIR008 = 'Y' AND RECI = 'D'                                CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      FIDSTS = 'C'                                               CIR008
     C                   EVAL      DDSTS = @STSA(3)                                           CIR008
     C                   WHEN      FIDSTS = 'A'                                               CIR008
     C                   EVAL      DDSTS = @STSA(4)                                           CIR008
     C                   WHEN      FIDSTS = 'R'                                               CIR008
     C                   EVAL      DDSTS = @STSA(5)                                           CIR008
     C                   ENDSL                                                                CIR008
     C                   ENDIF                                                                CIR008
      *                                                                         CIR005
      ** If Bus. Day Conventions enhancement is present and Amount              CIR005
      ** Convention is 'A' then display 'Next Interest Payment Date' as         CIR005
      ** 'Their/Our' Interest Payment Base Date.                                CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
      *                                                                         CIR005
     C                   IF        L1AMCN = 'A' AND                             CIR005
     C                             UIPBD <> *ZERO AND                           CIR005
     C                             UIPBD <> UNIPD                               CIR005
     C                   CALLB     'ZDATE2'                                     CIR005
     C                   PARM      UIPBD         WQ0001                         CIR005
     C                   PARM                    BJDFIN                         CIR005
     C                   PARM      *ZEROS        ZDATE                          CIR005
     C                   PARM      *BLANKS       ZADATE                         CIR005
     C                   MOVEL     ZDATE         SUNIPD                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        L2AMCN = 'A' AND                             CIR005
     C                             TIPBD <> *ZERO AND                           CIR005
     C                             TIPBD <> TNIPD                               CIR005
     C                   CALLB     'ZDATE2'                                     CIR005
     C                   PARM      TIPBD         WQ0001                         CIR005
     C                   PARM                    BJDFIN                         CIR005
     C                   PARM      *ZEROS        ZDATE                          CIR005
     C                   PARM      *BLANKS       ZADATE                         CIR005
     C                   MOVEL     ZDATE         STNIPD                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** If Business Day Convention enhancement is installed, move BDC          CIR005
      ** fields from file to screen                                             CIR005
     C                   If        CIR005 = 'Y'                                 CIR005
     C                   Eval      BsDayScn = BsDayFil                          CIR005
     C                   EndIf                                                  CIR005
                                                                                              CAP043
     C                   IF        CIR001 = 'Y'                                               CAP043
                                                                                              CAP043
      ** Convert Up-Front details to screen format                                            CAP043
                                                                                              CAP043
     C     UPVD          IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      UPVD          WQ0001                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      *ZEROS        ZDATE                                        CAP043
     C                   PARM      *BLANKS       ZADATE                                       CAP043
     C                   MOVE      ZDATE         SUFVD                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     UPFE          IFNE      *ZERO                                                      CAP043
     C                   Z-ADD     UPFE          @@AMTW                                       CAP043
     C                   IF        UPPR = 'P'                                                 CAP043
     C                   Z-ADD     WUNBDP        @@QECN                                       CAP043
     C                   ELSE                                                                 CAP043
     C                   Z-ADD     WTNBDP        @@QECN                                       CAP043
     C                   ENDIF                                                                CAP043
     C                   EXSR      FMTAMT                                                     CAP043
     C                   MOVE      @@AMTD        SUFEE                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      UPPR          SUFPR                                        CAP043
                                                                                              CAP043
      ** Convert Buy-Out details to screen format                                             CAP043
                                                                                              CAP043
     C     BOVD          IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      BOVD          WQ0001                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      *ZEROS        ZDATE                                        CAP043
     C                   PARM      *BLANKS       ZADATE                                       CAP043
     C                   MOVE      ZDATE         SBOVD                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C*****BOVD*         IFNE      *ZERO                                             CAP043 BUG11950
     C**********         Z-ADD     BOVD          @@AMTW                              CAP043 BUG11950
     C     BOAM          IFNE      *ZERO                                                    BUG11950
     C                   Z-ADD     BOAM          @@AMTW                                     BUG11950
     C                   IF        BAPR = 'P'                                                 CAP043
     C                   Z-ADD     WUNBDP        @@QECN                                       CAP043
     C                   ELSE                                                                 CAP043
     C                   Z-ADD     WTNBDP        @@QECN                                       CAP043
     C                   ENDIF                                                                CAP043
     C                   EXSR      FMTAMT                                                     CAP043
     C**********         MOVE      @@AMTD        SBOPR                                CAP043 BUG6544
     C                   MOVE      @@AMTD        SBUYA                                       BUG6544
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      BAPR          SBOPR                                        CAP043
                                                                                              CAP043
      ** Convert Principal Change details to screen format                                    CAP043
                                                                                              CAP043
     C     UNPCD         IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      UNPCD         WQ0001                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      *ZEROS        ZDATE                                        CAP043
     C                   PARM      *BLANKS       ZADATE                                       CAP043
     C                   MOVE      ZDATE         SONPCD                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      UINPM         SOIPM                                        CAP043
                                                                                              CAP043
     C     TNPCD         IFNE      *ZERO                                                      CAP043
     C                   CALLB     'ZDATE2'                                                   CAP043
     C                   PARM      TNPCD         WQ0001                                       CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      *ZEROS        ZDATE                                        CAP043
     C                   PARM      *BLANKS       ZADATE                                       CAP043
     C                   MOVE      ZDATE         STNPCD                                       CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   MOVE      TINPM         STIPM                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CLE025
      ** Set up details for Credit Lines                                                      CLE025
                                                                                              CLE025
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   EXSR      SRFCIP                                                     CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CAP043
                                                                                              CDL028
      ** If Automatic Rate Interpolations is ON                                               CDL028
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
                                                                                              CDL028
      ** Our Start Date.                                                                      CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOSDT        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOSDT        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOSDT                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our Start - 1st Term Base Rate Code                                                  CDL028
                                                                                              CDL028
     C                   IF        FSOS1B = *ZERO                                             CDL028
     C                   EVAL      SOS1B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOS1B        SOS1B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our Start - 1st Term End Date                                                        CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOS1D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOS1D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOS1D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our Start - 2nd Term Base Rate Code                                                  CDL028
                                                                                              CDL028
     C                   IF        FSOS2B = *ZERO                                             CDL028
     C                   EVAL      SOS2B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOS2B        SOS2B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our Start - 2nd Term End Date                                                        CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOS2D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOS2D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOS2D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our End Date                                                                         CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOEDT        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOEDT        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOEDT                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our End - 1st Term Base Rate Code                                                    CDL028
                                                                                              CDL028
     C                   IF        FSOE1B = *ZERO                                             CDL028
     C                   EVAL      SOE1B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOE1B        SOE1B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our End - 1st Term End Date                                                          CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOE1D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOE1D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOE1D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our End - 2nd Term Base Rate Code                                                    CDL028
                                                                                              CDL028
     C                   IF        FSOE2B = *ZERO                                             CDL028
     C                   EVAL      SOE2B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSOE2B        SOE2B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Our End - 2nd Term End Date                                                          CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSOE2D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSOE2D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         SOE2D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their Start Date.                                                                    CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTSDT        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTSDT        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STSDT                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their Start - 1st Term Base Rate Code                                                CDL028
                                                                                              CDL028
     C                   IF        FSTS1B = *ZERO                                             CDL028
     C                   EVAL      STS1B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTS1B        STS1B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their Start - 1st Term End Date                                                      CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTS1D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTS1D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STS1D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their Start - 2nd Term Base Rate Code                                                CDL028
                                                                                              CDL028
     C                   IF        FSTS2B = *ZERO                                             CDL028
     C                   EVAL      STS2B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTS2B        STS2B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their Start - 2nd Term End Date                                                      CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTS2D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTS2D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STS2D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their End Date                                                                       CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTEDT        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTEDT        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STEDT                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their End - 1st Term Base Rate Code                                                  CDL028
                                                                                              CDL028
     C                   IF        FSTE1B = *ZERO                                             CDL028
     C                   EVAL      STE1B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTE1B        STE1B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their End - 1st Term End Date                                                        CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTE1D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTE1D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STE1D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their End - 2nd Term Base Rate Code                                                  CDL028
                                                                                              CDL028
     C                   IF        FSTE2B = *ZERO                                             CDL028
     C                   EVAL      STE2B = *BLANKS                                            CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVE      FSTE2B        STE2B                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ** Their End - 2nd Term End Date                                                        CDL028
      ** Call ZDATE2 to convert date from Midas Dayno. format to DDMMYY format                CDL028
                                                                                              CDL028
     C     FSTE2D        IFNE      *ZERO                                                      CDL028
     C                   CALLB     'ZDATE2'                                                   CDL028
     C                   PARM      FSTE2D        WQ0001                                       CDL028
     C                   PARM                    BJDFIN                                       CDL028
     C                   PARM      *ZEROS        ZDATE                                        CDL028
     C                   PARM      *BLANKS       ZADATE                                       CDL028
                                                                                              CDL028
     C                   MOVE      ZDATE         STE2D                                        CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
     C                   ENDIF                                                                CDL028
      *                                                                                       CDL038
      ** Class                                                                                CDL038
      *                                                                                       CDL038
     C                   MOVE      CLAS          SCLAS                                        CDL038
                                                                                              CDL028
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE025
      * SRFCIP - Format Facility Details                              *                       CLE025
      *****************************************************************                       CLE025
     C     SRFCIP        BEGSR                                                                CLE025
                                                                                              CLE025
     C**********         IF        F1FCCU <> *ZERO                                     CLE025 CSD027
     C                   IF        F1FCCU <> *BLANKS                                          CSD027
     C                   MOVEL     F1FCCU        SFCCU                                        CLE025
     C                   ENDIF                                                                CLE025
     C                   IF        F1FACT <> *ZERO                                            CLE025
     C                   MOVEL     F1FACT        SFACT                                        CLE025
     C                   ENDIF                                                                CLE025
     C                   IF        F1FCNO <> *ZERO                                            CLE025
     C                   MOVEL     F1FCNO        SFCNO                                        CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CLE025
      /EJECT                                                                                  CLE025
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
     C***********        PARM                    @@INRT           12 8          154453
     C                   PARM                    @@INRT           13 8          154453
     C                   PARM                    @@FCMD            1
     C***********        PARM      *ZEROS        @@SCRT           12 8          154453
     C***********        PARM      *ZEROS        @@ISRT           12 8          154453
     C                   PARM      *ZEROS        @@SCRT           13 8          154453
     C                   PARM      *ZEROS        @@ISRT           13 8          154453
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
     C                   PARM                    DealXFilFmt                                  CLE025
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
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
     C                   MOVEL     'IRCIRSCVT'   DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *****************************************************************                164607 245692
      **EDIT*AMOUNTS*WITH*'.'******************************************                164607 245692
      *****************************************************************                164607 245692
     C**********         MOVE      '.'           BNDCSP                                164607 245692
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
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
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
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
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
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
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
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                         CIR005
      ** Access SAR details for Business Day Conventions                        CIR005
      *                                                                         CIR005
     C                   CALLB     'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
      ** DATABASE ERROR                                                         CIR005
      *                                                                         CIR005
     C                   IF        @RTCD <> *BLANKS AND                         CIR005
     C                             @RTCD <> '*NRF   '                           CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     907           DBASE                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANK                               CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                                       CAS001
      ** Access SAR details for Net Present Value Accounting                                  CAS001
      *                                                                                       CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
      *                                                                                       CAS001
      ** Database error                                                                       CAS001
      *                                                                                       CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   MOVEL     'CAS001'      DBKEY                                        CAS001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS001
     C                   Z-ADD     908           DBASE                                        CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANK                                             CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAP043
      ** Access SAR details for CIR001                                                        CAP043
                                                                                              CAP043
     C                   CALLB     'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRTCD                                        CAP043
     C                   PARM      '*VERIFY'     POPTN                                        CAP043
     C                   PARM      'CIR001'      PSARD                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
      *                                                                                       CAP043
      ** Database error                                                                       CAP043
      *                                                                                       CAP043
     C                   IF        PRTCD <> *BLANKS AND                                       CAP043
     C                             PRTCD <> '*NRF   '                                         CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   MOVEL     'CIR001'      DBKEY                                        CAP043
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP043
     C                   Z-ADD     909           DBASE                                        CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        PRTCD = *BLANK                                             CAP043
     C                   EVAL      CIR001 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CIR001 = 'N'                                               CAP043
     C                   ENDIF                                                                CAP043
      *                                                                                       CAS005
      ** Access SAR details for Enhancements to CAS001, CAS002 and CAS004                     CAS005
      *                                                                                       CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
      ** Database error                                                                       CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   MOVEL     'CAS005'      DBKEY                                        CAS005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS005
     C                   Z-ADD     910           DBASE                                        CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANK                                             CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
     C/COPY WNCPYSRC,IRCIRSNC05
      *
      **  Access SAR details file to determine if CIR011 is *ON                               CIR011
      *                                                                                       CIR011
     C                   CALL      'AOSARDR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*VERIFY'     @OPTN                                        CIR011
     C                   PARM      'CIR011'      @SARD                                        CIR011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR011
                                                                                              CIR011
     C     @RTCD         IFNE      *BLANKS                                                    CIR011
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR011
     C     *LOCK         IN        LDA                                                        CIR011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR011
     C                   Z-ADD     11            DBASE                                        CIR011
     C                   MOVEL     'CIR011'      DBKEY                                        CIR011
     C                   OUT       LDA                                                        CIR011
     C                   EXSR      *PSSR                                                      CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C     @RTCD         IFEQ      *BLANKS                                                    CIR011
     C                   MOVEL     'Y'           CIR011                                       CIR011
     C                   ELSE                                                                 CIR011
     C                   MOVEL     'N'           CIR011                                       CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CLE025
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       @RTCD                                        CLE025
     C                   PARM      '*VERIFY'     @OPTN                                        CLE025
     C                   PARM      'CLE025'      @SARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '                    CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   Z-ADD     12            DBASE                                        CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        @RTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CIR011
                                                                                              CDL028
      ** Check if enhancement CDL028 is ON                                                    CDL028
                                                                                              CDL028
     C                   CALL      'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       @RTCD                                        CDL028
     C                   PARM      '*VERIFY'     @OPTN                                        CDL028
     C                   PARM      'CDL028'      @SARD                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   IF        @RTCD = *BLANKS                                            CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CAS008
      ** Access SAR details for IAS39 Enhancement(CAS008)                                     CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRTCD                                        CAS008
     C                   PARM      '*VERIFY'     POPTN                                        CAS008
     C                   PARM      'CAS008'      PSARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRTCD <> *BLANKS AND                                       CAS008
     C                             PRTCD <> '*NRF   '                                         CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 910                                                CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRTCD = *BLANK                                             CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Access SAR details for CIR003                                                        CAS008
                                                                                              CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRTCD                                        CAS008
     C                   PARM      '*VERIFY'     POPTN                                        CAS008
     C                   PARM      'CIR003'      PSARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRTCD <> *BLANKS AND                                       CAS008
     C                             PRTCD <> '*NRF   '                                         CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY  = 'CIR003'                                          CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 911                                                CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRTCD = *BLANK                                             CAS008
     C                   EVAL      CIR003 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CIR003 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CDL028
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
COMPLETED                                                                                     CIR008
AUTHORISED                                                                                    CIR008
REQUIRES REAUTHORISATION                                                                      CIR008
