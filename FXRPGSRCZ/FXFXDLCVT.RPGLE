     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal Cnv: File to Screen Format')             *
      *****************************************************************
      *                                                               *
      *  Midas - Foriegn Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLCVT - FX Deal Conversion: File to Screen Format        *
      *                                                               *
      *  Function:  This module converts the fields of an FX Deal     *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25240           Date 29Jul09               *
      *                 BUG23668           Date 01Apr09               *
      *                 BUG21427           Date 28Oct08               *
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
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 196952             Date 06May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154453             Date 09FEB99               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25240 - Reciprocal Rate Indicator Function                *
      *  BUG23668 - Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG21427 - Exchange Rate value being changed after pre       *
      *             confirmation                                      *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  196952 - Ensure Rate has 5 digits before decimal separator   *
      *           and 8 digits after. Use DDRAT1 instead of DDRATE.   *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompiled due to changes in FXDEALPP               *
      *  CPB001 - 'Private Banking' Module                            *
      *  154453 - Allow 5 digit exchange rate (i.e. 5,7 or 4,8)       *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
     D @STSA           S             24    DIM(6) CTDATA PERRCD(1)
      * Scaling Factors
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)

      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)

      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D OutCDL099     E DS                  EXTNAME(FXDLEXPD)                                  CDL099
      ** FX Deal Extra Data Layout Definition (output)                                        CDL099
                                                                                              CDL099
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
     D CER043          S              1A                                                      CER043
     D CDL099          S              1A                                                      CDL099
     D/COPY WNCPYSRC,FXH00231

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
      *
      * Deal number
      *
     C                   MOVE      FHDN38        DDDLNO
      *
      * Deal type
      *
     C                   MOVE      FHTYPE        DDDLTP
      *
      * Deal sub type
      *
     C                   MOVE      FHSTYP        DDDLST
      *
      * Fed funds ind.
      *
     C                   MOVE      FHFEDF        DDFEDF
      *
      * Deal date
      *
     C                   Z-ADD     FHDDYY        @@YEAR
     C                   Z-ADD     FHDDMM        @@MNTH
     C                   Z-ADD     FHDDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDDLDT
     C                   END
      *
      * Branch
      *
     C                   MOVE      FHMBCA        DDBRSN
      *
      * Broker
      *
     C                   MOVE      FHBROK        DDBRKR
      *
      * Brokerage
      *
     C     FHBRKG        IFEQ      *ALL'9'
     C                   MOVE      *BLANKS       DDBKRG
     C                   ELSE
     C     FHBRKG        IFEQ      *ALL'0'
     C                   MOVE      *BLANKS       DDBKRG
     C                   MOVEL     'NIL'         DDBKRG
     C                   ELSE
     C     FHBRKG        IFEQ      0
     C                   MOVE      *BLANKS       DDBKRG
     C                   MOVE      '0'           DDBKRG
     C                   ELSE
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FHBKCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '101'         DBASE                          * DBERR 101*
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     FHBRKG        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBKRG
     C                   END
     C                   END
     C                   END
      *
      * SW/OP deal number
      *
     C                   MOVE      FHDADN        DDSDNO
      *
      * Customer
      *
     C                   MOVE      *BLANKS       DDCUST
     C*****FHDCNO        IFNE      0                                                          CSD027
     C     FHDCNO        IFNE      *BLANKS                                                    CSD027
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     FHDCNO        DDCUST
     C                   ELSE
     C                   MOVEL     FHDCSN        DDCUST
     C                   END
     C                   END
      *
      * Value date
      *
     C                   Z-ADD     FHVDYY        @@YEAR
     C                   Z-ADD     FHVDMM        @@MNTH
     C                   Z-ADD     FHVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   ELSE
     C                   MOVE      *BLANK        DDVDAT
     C                   END
      *
      * Option to date
      *
     C                   Z-ADD     FHDOEY        @@YEAR
     C                   Z-ADD     FHDOEM        @@MNTH
     C                   Z-ADD     FHDOED        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDODAT
     C                   ELSE
     C                   MOVE      *BLANK        DDODAT
     C                   END
      *
      * Book
      *
     C                   MOVE      FHBOKC        DDBOKC
      *
      * Linked Reference
      *
     C     FHLNKN        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDLNKN
     C                   ELSE
     C                   MOVE      FHLNKN        DDLNKN
     C                   END
      *
      ** Portfolio Reference
      *
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     FHPTFR        IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      FCR997        DDPTFR
     C                   ELSE
     C                   MOVE      FHPTFR        DDPTFR
     C                   END
     C                   END
      *
      ** Buy Currency
      *
     C                   MOVE      FHCCY1        DDBCCY
      *
      ** Sell Currency
      *
     C                   MOVE      FHCCY2        DDSCCY
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '102'         DBASE                          * DBERR 102*
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Buy currency details
      *
     C                   Z-ADD     A6NQDP        @@NDP1
     C                   Z-ADD     A6SCEX        @@SXP1
      *
      * Edit Buy amount
      *
     C                   Z-ADD     FHDAM1        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBAMT
      *
      * FX Netting fields:
      * Buy/Sell Net Indicators
      * Buy/Sell References
      * Matched Deal
      *
     C     CDL002        IFEQ      'Y'
     C                   MOVE      FHNBUY        DDNBUY
     C                   MOVE      FHNBRF        DDNBRF
     C                   MOVE      FHNSEL        DDNSEL
     C                   MOVE      FHNSRF        DDNSRF
     C                   MOVE      FHMTCH        DDMTCH
     C                   END
      *
      * Sell currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDSCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '103'         DBASE                          * DBERR 103*
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NQDP        @@NDP2
     C                   Z-ADD     A6SCEX        @@SXP2
      *
      * Edit Sell amount
      *
     C                   Z-SUB     FHDAM2        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDSAMT
      *
      ** If S01453 is installed the dealt rate is the original spot rate
      *
     C     S01453        IFEQ      'Y'
     C     CER043        OREQ      'Y'                                                      BUG25240
     C                   Z-ADD     FHOSRT        @@RATE           13 8
     C                   ELSE
      *
      ** If S01453 is not installed the dealt rate is the
      ** outright exchange rate MINUS the forward points
      *
     C                   Z-SUB     FHFWPP        @@FPNT            7 2
      *
     C**********         IF        CER043 = 'Y' AND                                BUG23668 BUG25240
     C**********                   FHREIN = 'Y'                                    BUG23668 BUG25240
     C**********         EVAL(H)   FHDXRT = 1/FHDXRT                               BUG23668 BUG25240
     C**********         ENDIF                                                     BUG23668 BUG25240
      **********                                                                   BUG23668 BUG25240
      * Apply Forward Points to a Rate
      *
     C                   CALLB     'ZA0780'
      * INPUTS
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C                   PARM                    BNCYDL            3            sell ccy
     C                   PARM      FHDXRT        @@IRAT           13 8          exchange rate
     C                   PARM      FHDMD1        @@DMD1            1            1st ccy ml/dv ind
     C                   PARM                    @@FPNT            7 2          forward points
     C                   PARM      'Y'           @@SCAL            1            scale rate?
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
      * OUTPUTS
     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
      *
      **  If either currency is base, display scaled rate
      *
     C     DDSCCY        IFEQ      BNCYDL
     C     DDBCCY        OREQ      BNCYDL
     C                   Z-ADD     @@GSRT        @@RATE
      * else unscaled rate
     C                   ELSE
     C                   Z-ADD     @@GURT        @@RATE
     C                   END
      *
     C                   END
      **********                                                                   BUG21427 BUG23668
     C**********         IF        CER043 = 'Y' AND                                BUG21427 BUG23668
     C**********                   FHREIN = 'Y'                                    BUG21427 BUG23668
     C*****1****         DIV(H)    @@RATE        @@RATE                            BUG21427 BUG23668
     C**********         ENDIF                                                     BUG21427 BUG23668
      *
      * Prepare the exchange rate for editing for display
      *
     C     DDSCCY        IFEQ      BNCYDL
     C     8             SUB       @@SXP1        X1                5 0
     C     X1            ADD       1             Y1                5 0
     C     @@RATE        MULT      @SF(Y1)       @@AMTW
     C                   Z-ADD     X1            @@QECN
     C                   ELSE
     C     DDBCCY        IFEQ      BNCYDL
     C     8             SUB       @@SXP2        X1
     C     X1            ADD       1             Y1
     C     @@RATE        MULT      @SF(Y1)       @@AMTW
     C                   Z-ADD     X1            @@QECN
     C                   ELSE
     C     @@RATE        MULT      100000000     @@AMTW
     C                   Z-ADD     8             @@QECN
     C                   END
     C                   END
      **Fix*to*allow*for*5*integers,*if*required*(&*only*7*decimal)****                154453 196952
     C**********         MOVE      *ZERO         WPOS1             1 0                 154453 196952
     C**********         MOVEL     @@RATE        WPOS1                                 154453 196952
     C*****WPOS1         IFNE      *ZERO                                               154453 196952
     C**********         Z-ADD     7             @@QECN                                154453 196952
     C*****@@AMTW        DIV       10            @@AMTW                                154453 196952
     C**********         END                                                           154453 196952
      *
      * Edit the exchange rate for display
      *
     C                   EXSR      FMTAMT
     C**********         MOVE      @@AMTD        DDRATE                                       196952
     C                   MOVE      @@AMTD        DDRAT1                                       196952
      *
      * Forward Points
      *
     C     FHFWPP        IFLT      0
     C                   Z-SUB     FHFWPP        @@FPNT            7 2
     C                   ELSE
     C                   Z-ADD     FHFWPP        @@FPNT
     C                   END
     C     @@FPNT        MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFPNT
      *
      * Forward points sign
      *
     C     FHFWPP        IFLT      0
     C                   MOVE      '-'           DDSIGN
     C                   ELSE
     C                   MOVE      '+'           DDSIGN
     C                   END
      *
      ** Margin Points and Margin Points Buy/Sell Indicator
      *
     C     S01453        IFEQ      'Y'
     C     FHMGPT        IFLT      *ZERO
     C                   Z-SUB     FHMGPT        @@MGPT            7 2
     C                   ELSE
     C                   Z-ADD     FHMGPT        @@MGPT
     C                   END
     C     @@MGPT        MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMGIN
     C                   MOVE      FHMGBS        DDMBSI
     C                   END
      *
      * Base currency equivalent
      *
     C     FHBCAE        IFNE      0
     C     DDSCCY        ANDNE     BJCYCD
     C     DDBCCY        ANDNE     BJCYCD
     C                   Z-ADD     FHBCAE        @@AMTW
     C                   Z-ADD     @@BCDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBCE
     C                   ELSE
     C                   MOVE      *BLANKS       DDBCE
     C                   END
      *
      * Originating Branch
      *
     C                   MOVE      FHORBR        DDORBR
      *
      * Profit Centre
      *
     C                   MOVE      FHPRFC        DDPRFC
      *
      ** DL Base Spot Rate
      *
     C     S01453        IFEQ      'Y'
     C     FHBDBS        MULT      100000000     @@AMTW
     C                   Z-ADD     8             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDBSR
     C                   END
      *
      ** Buy DL Base forward points & sign
      *
     C     S01453        IFEQ      'Y'
     C     FHBDBF        IFLT      *ZERO
     C                   Z-SUB     FHBDBF        @@BDBF            7 2
     C                   MOVE      '-'           @@BBFS            1
     C                   ELSE
     C                   Z-ADD     FHBDBF        @@BDBF
     C                   MOVE      '+'           @@BBFS
     C                   END
     C     @@BDBF        MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBBFP
     C                   MOVE      @@BBFS        DDBBFS
     C                   END
      *
      ** Sell DL Base forward points & sign
      *
     C     S01453        IFEQ      'Y'
     C     FHSDBF        IFLT      0
     C                   Z-SUB     FHSDBF        @@SDBF            7 2
     C                   MOVE      '-'           @@SBFS            1
     C                   ELSE
     C                   Z-ADD     FHSDBF        @@SDBF
     C                   MOVE      '+'           @@SBFS
     C                   END
     C     @@SDBF        MULT      100           @@AMTW
     C                   Z-ADD     2             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDSBFP
     C                   MOVE      @@SBFS        DDSBFS
     C                   END
      *
      * Deal status
      *
     C     FHDSTS        IFEQ      'C'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
     C     FHDSTS        IFEQ      'A'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
     C     FHDSTS        IFEQ      'R'
     C                   MOVE      @STSA(3)      DDSTS
     C                   END
     C     FHDSTS        IFEQ      'E'
     C                   MOVE      @STSA(4)      DDSTS
     C                   END
     C     FHDSTS        IFEQ      'M'
     C                   MOVE      @STSA(5)      DDSTS
     C                   END
     C     FHDDLT        IFEQ      'D'
     C                   MOVE      @STSA(6)      DDSTS
     C                   END
      *                                                                         CDL008
      ** Set CLS settlement field if feature CDL008 is installed.               CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   EVAL      DDCLSS = FHCLSS                              CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C/COPY WNCPYSRC,FXH00232
     C                   EVAL      DDOYLC = FHOYLC                                            CAS001
     C                   EVAL      DDTYLC = FHTYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CDL038
      * Class                                                                                 CDL038
      *                                                                                       CDL038
     C                   MOVE      FHCLAS        DDCLAS                                       CDL038
      *                                                                                       CER043
      **  Reciprocal rate indicator                                                           CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EVAL      DDREIN = FHREIN                                            CER043
     C                   ENDIF                                                                CER043
      *
      *                                                                                       CDL049
      * Format Reference Rate                                                                 CDL049
     C     CDL049        IFEQ      'Y'                                                        CDL049
     C                   MOVE      FHRRAT        @@AMTW                                       CDL049
     C                   Z-ADD     8             @@QECN                                       CDL049
     C                   EXSR      FMTAMT                                                     CDL049
     C                   MOVE      @@AMTD        DDRRAT                                       CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL099
     C                   IF        CDL099 = 'Y'                                               CDL099
      *                                                                                       CDL099
      ** Update only if Sell Date Year is not zero to avoid Substring Error                   CDL099
     C                   IF        FHVS2Y <> *ZEROS                                           CDL099
      *                                                                                       CDL099
     C                   MOVE      FHVS2M        TEMMM             2                          CDL099
     C                   MOVE      FHVS2D        TEMDD             2                          CDL099
      *                                                                                       CDL099
      ** If BJDFIN = 'M', DDSDAT is MMDDYY, else DDSDAT is DDMMYY                             CDL099
     C                   IF        BJDFIN = 'M'                                               CDL099
     C                   EVAL      DDSDAT = TEMMM + TEMDD                                     CDL099
     C                                      + %SUBST(%CHAR(FHVS2Y):3:2)                       CDL099
     C                   ELSE                                                                 CDL099
     C                   EVAL      DDSDAT = TEMDD + TEMMM                                     CDL099
     C                                      + %SUBST(%CHAR(FHVS2Y):3:2)                       CDL099
     C                   ENDIF                                                  BJDFIN = 'M'  CDL099
      *                                                                                       CDL099
     C                   ELSE                                                                 CDL099
      *                                                                                       CDL099
     C                   EVAL      DDSDAT = *ZEROS                                            CDL099
      *                                                                                       CDL099
     C                   ENDIF                                                  FHVS2Y <> 0   CDL099
     C                   ENDIF                                                                CDL099
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
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
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAL FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        DealScnFmt
     C                   MOVEL     ##ACTN        DDACTN
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
      *
      * Output parameters
      *
      * Deal in screen format
     C                   PARM                    DealScnFmt
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
      *
      * Deal Status
     C                   PARM                    DDSTS            24
     C                   PARM                    OutCDL099                                    CDL099
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLCVT'   DBPGM
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
      ** Get the currency decimal places of accounting base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        @@BCDP            1 0
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
     C                   MOVEL     '902'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
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
     C                   MOVEL     '903'         DBASE                          * DBERR 902 *
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
     C                   MOVEL     '904'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Margin & FX/Position Points
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01453'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01453'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01453            1
     C                   ELSE
     C                   MOVEL     'N'           S01453
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
      *                                                                         CDL011
      ** ACCESS SAR DETAILS FOR Expansion of Customer Number                    CDL011
      *                                                                         CDL011
     C                   CALLB     'AOSARDR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*VERIFY'     @OPTN                          CDL011
     C                   PARM      'CDL011'      @SARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
      *                                                                         CDL011
      * DATABASE ERROR                                                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFNE      *BLANKS                                      CDL011
     C     @RTCD         ANDNE     '*NRF   '                                    CDL011
     C                   MOVEL     'CDL011'      DBKEY                          CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL011
     C                   MOVEL     '910'         DBASE                          CDL011
     C                   EXSR      *PSSR                                        CDL011
     C                   END                                                    CDL011
     C*                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL     'S'           CustFormat                     CDL011
     C                   END                                                    CDL011
      *
      ** ACCESS SAR DETAILS FOR FX Netting
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '907'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL002            1
     C                   ELSE
     C                   MOVEL     'N'           CDL002
     C                   END
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
                                                                                CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '908'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
                                                                                CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 909                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
     C/COPY WNCPYSRC,FXH00233
      *                                                                                       CDL049
      ** Access SAR details for Additional Reference Rate (CDL049)                            CDL049
      *                                                                                       CDL049
     C                   CallB     'AOSARDR0'                                                 CDL049
     C                   Parm      *Blanks       PRTCD                                        CDL049
     C                   Parm      '*VERIFY'     POPTN                                        CDL049
     C                   Parm      'CDL049'      PSARD                                        CDL049
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL049
      *                                                                                       CDL049
     C                   Move      'N'           CDL049            1                          CDL049
     C                   If        PRTCD = *Blanks                                            CDL049
     C                   Eval      CDL049 = 'Y'                                               CDL049
     C                   Endif                                                                CDL049
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 911                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
      *
      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
      *                                                                                       CDL099
     C                   EVAL      CDL099 = 'N'                                               CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRTCD                                        CDL099
     C                   PARM      '*VERIFY'     POPTN                                        CDL099
     C                   PARM      'CDL099'      PSARD                                        CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
                                                                                              CDL099
     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
     C                             PRTCD <> '*NRF   '                                         CDL099
     C     *LOCK         IN        LDA                                                        CDL099
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBASE = 912                                                CDL099
     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
     C                   OUT       LDA                                                        CDL099
     C                   EXSR      *PSSR                                                      CDL099
     C                   ENDIF                                                                CDL099
                                                                                              CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   EVAL      CDL099 = 'Y'                                               CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** TEXT FOR DEAL STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
EXPIRED
MATURED
DELETED
** @SF Scaling factors
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
