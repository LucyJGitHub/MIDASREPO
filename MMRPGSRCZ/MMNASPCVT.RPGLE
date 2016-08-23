     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs purchased cnv: file to screen format')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPCVT - NA's Purchased Conversion: File to Screen Format *
      *                                                               *
      *  Function:  This module converts the fields of an NA Purchased*
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR814519           Date 10Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 191947             Date 14Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147069             Date 06Nov98               *
      *                 154453             Date 06Nov98               *
      *                 CAP002  *CREATE    Date 06Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR814519 - Allow negative base rate.                         *
      *           - Applied for MD033488                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  191947 - Bill Depot ID not properly passed.                  *
      *  147069 - Add hooks for branch mods                           *
      *  154453 - Applied fix 128710.                                 *
      *           Base ccy rate tolerance work field is to small.     *
      *           Increased the size of @ULIM.  Applied fix 114480.   *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFORAT     IF   E           K DISK
 
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
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)
 
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDENBPP)
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMNASPPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  191947
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                     191947
                                                                                              191947
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
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
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
                                                                                              CAS005
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      INIT
      *
      ** Set Output Screen Fields
      *
     C                   EXSR      SETFLD
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set Output Screen Fields
      *****************************************************************
     C     SETFLD        BEGSR
      *
      **  Deal number.
     C                   MOVE      HLDN38        DDDLNO
      *
      **  Deal type.
     C                   MOVE      HLMTYP        DDMTYP
      *
      **  Deal sub-type.
     C                   MOVE      HLSTYP        DDSTYP
      *
      **  Federal funds indicator
     C                   MOVE      HLFEDF        DDFEDF
      *
      ** Deal date.
     C                   Z-ADD     HLDDYY        @@YEAR
     C                   Z-ADD     HLDDMM        @@MNTH
     C                   Z-ADD     HLDDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDDLDT
     C                   END
      *
      **  Branch code.
     C     HLBRCA        IFNE      *BLANKS
     C                   MOVE      HLBRCA        DDBRCA
     C                   END
      *
      **  Broker Code.
     C                   MOVE      HLBKCD        DDBKCD
      *
      **  Brokerage amount.
      **  IF BROKER CODE TELX PHON MAIL OR BLANK OUTPUT BLANKS
     C     HLBKCD        IFEQ      'PHON'
     C     HLBKCD        OREQ      'TELX'
     C     HLBKCD        OREQ      'MAIL'
     C     HLBKCD        OREQ      *BLANK
     C                   MOVE      *BLANK        DDBRKG
     C                   ELSE
     C                   SELECT
      ** If Brokerage = 0, output '0'
     C     HLBRKG        WHENEQ    *ZERO
     C                   MOVE      *BLANK        DDBRKG
     C                   MOVE      '0'           DDBRKG
      ** If Brokerage = 9's, output BLANK
     C     HLBRKG        WHENEQ    *ALL'9'
     C                   MOVE      *BLANK        DDBRKG
      *
     C                   OTHER
      *
     C                   MOVE      HLBKCY        @AJCD             3
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
      ** Format brokerage
     C                   Z-ADD     HLBRKG        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBRKG
     C                   ENDSL
     C                   ENDIF
 
      **  Customer. (Issued by:)
     C                   MOVE      *BLANKS       DDISUR
     C*****HLISCN        IFNE      0                                                          CSD027
     C     HLISCN        IFNE      *BLANKS                                                    CSD027
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     HLISCN        DDISUR                         *1
     C                   ELSE
     C                   MOVEL     HLISUR        DDISUR
     C                   END
     C                   END
 
      **  Customer. (Bought from:)
     C                   MOVE      *BLANKS       DDCSNM
     C*****HLCNUM        IFNE      0                                                          CSD027
     C     HLCNUM        IFNE      *BLANKS                                                    CSD027
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     HLCNUM        DDCSNM                         *1
     C                   ELSE
     C                   MOVE      HLCSNM        DDCSNM
     C                   END
     C                   END
      *
     C     HLMTYP        IFEQ      'C1'
     C                   MOVE      *BLANKS       DDCSNM
     C                   END
 
      **  Value date.
     C                   Z-ADD     HLVDYY        @@YEAR
     C                   Z-ADD     HLVDMM        @@MNTH
     C                   Z-ADD     HLVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   END
 
      **  Maturity Date.
     C                   Z-ADD     HLMDYY        @@YEAR
     C                   Z-ADD     HLMDMM        @@MNTH
     C                   Z-ADD     HLMDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDMDAT
     C                   END
 
      **  Account Sequnce Number.
     C     HLACSQ        IFNE      0
     C                   MOVE      HLACSQ        DDACSQ
     C                   END
 
      **  Currency Code.
     C                   MOVE      HLCCY         DDCCY
 
      **  Face Value
      **  Format Face Value, using deal ccy decimal places
      *
     C                   Z-ADD     HLFVAL        @@AMTW
     C                   Z-ADD     HLCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFVAL
      *
      **  Deal Amount
      **  Format Deal Amount, using deal ccy decimal places
      *
     C     HLAMNP        IFLT      0
     C                   Z-SUB     HLAMNP        @@AMTW
     C                   ELSE
     C                   Z-ADD     HLAMNP        @@AMTW
     C                   END
     C                   Z-ADD     HLCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C     HLAMNP        IFEQ      *ZERO
     C     HLMTYP        OREQ      'C1'
     C                   MOVE      *BLANKS       DDAMNP
     C                   END
 
      ** book code
     C                   MOVE      HLBOKC        DDBOKC
 
      **  Linked reference number.
     C     HLLNKN        IFNE      *ZEROS
     C                   MOVE      HLLNKN        DDLNKN
     C                   END
 
      **  Bill Depot ID
     C     HLBDID        IFNE      *ZEROS
      *                                                                                       191947
      ** Retrieve true shortname for customer.                                                191947
      *                                                                                       191947
     C                   MOVEL     *BLANKS       @CUSNO           10                          191947
     C                   MOVEL     HLBDID        @CUSNO                                       191947
     C                   CALL      'AOCUSTR0'                                                 191947
     C                   PARM      '       '     @RTCD             7                          191947
     C                   PARM      '*KEY   '     @OPTN             7                          191947
     C                   PARM      @CUSNO        @CLKEY           10                          191947
     C                   PARM      '       '     @KYSTS            7                          191947
     C     SDCUST        PARM      SDCUST        DSSDY                                        191947
     C     @RTCD         IFEQ      '       '                                                  191947
     C                   MOVE      BBCSSN        DDBDID                                       191947
     C                   ENDIF                                                                191947
     C**********         MOVEL     HLBDID        DDBDID                         *1             S0112
     C                   END                                                    E1             S0112
 
      **  Interest Rate.
      **  Format the rate, using 8 decimal places and
      **  adjusting the file figure to have only implied decimal places.
      **
     C     HLFRAT        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDINTR
     C     HLFRAT        IFEQ      *ZERO
     C     DDMTYP        IFNE      'C1'
     C     DDMTYP        ANDNE     'C2'
     C     DDMTYP        ANDNE     'BP'
     C     DDMTYP        ANDNE     'BD'
     C                   MOVE      *BLANKS       DDINTR
     C                   END
     C                   END
 
      **  Interest Calculation Method.
     C                   MOVE      HLICMT        DDICMT
 
      **  Interest Payment Frequency.
     C                   MOVE      HLIPFQ        DDIPFQ
 
      **  Format the Next Interest Date.
     C                   Z-ADD     HLNIYY        @@YEAR
     C                   Z-ADD     HLNIMM        @@MNTH
     C                   Z-ADD     HLNIDD        @@DAY
     C     @@DTIN        IFNE      *ZERO
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDNDAT
     C                   END
 
      **  Format the Start/Last Interest Date.
     C                   Z-ADD     HLLIYY        @@YEAR
     C                   Z-ADD     HLLIMM        @@MNTH
     C                   Z-ADD     HLLIDD        @@DAY
     C     @@DTIN        IFNE      *ZERO
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDSLID
     C                   END
      *
      **  Yield/Discount Rate.
      **  Format the rate, using 8 decimal places and
      **  adjusting the file figure to have only implied decimal places
      **
      ** For Int. bearing NAs use interset rate else use discount rate
     C     DDMTYP        IFEQ      'C1'
     C     DDMTYP        OREQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
     C     HLINTR        MULT      10000000      @@AMTW
     C                   ELSE
     C     HLDCRT        MULT      10000000      @@AMTW
     C                   END
      *
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDCRT
     C     HLMTYP        IFEQ      'C1'
     C                   MOVE      *BLANKS       DDDCRT
     C                   END
 
      **  Interest Payment Day of Month.
     C     HLIPDM        IFNE      *ZEROS
     C                   MOVE      HLIPDM        DDIPDM
     C                   END
     C     HLIPFQ        IFEQ      *BLANK
     C     HLIPDM        ANDNE     0
     C                   MOVE      *BLANKS       DDIPDM
     C                   END
 
      **  Total interest amount.
      *
     C*****HLMTTI        IFLT      0                                                        AR814519
     C**********         Z-SUB     HLMTTI        @@AMTW                                     AR814519
     C**********         ELSE                                                               AR814519
     C                   Z-ADD     HLMTTI        @@AMTW
     C**********         END                                                                AR814519
     C                   Z-ADD     HLCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMTTI
     C     HLMTYP        IFNE      'C1'                                         B1
     C                   MOVE      *BLANKS       DDMTTI                         *1
     C                   END                                                    E1
 
      **  Base Currency Rate.
      **  Access the currency file to find the dealing currency
      **  scaling exponent.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Scale the Base Currency Exchange Rate.
      *
     C                   Z-ADD     A6SCEX        @@SXP1
     C                   Z-ADD     0             @@SXP2
     C                   Z-ADD     HLBRAT        @@INRT
     C                   MOVE      'M'           @@FCMD
      *
     C                   EXSR      SCLRAT
      *
      **  Format the rate, using 8 decimal places
      *
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
     C                   MOVE      @@AMTD        DDBRAT
     C                   END
     C     HLBRAT        IFEQ      *ZERO                                        B1
     C                   MOVE      *BLANKS       DDBRAT                         *1
     C                   END                                                    E1
 
      **  Round Down Interest Indicator
     C                   MOVE      HLRDFC        DDRDFC
 
      ** Parcel Flag
     C                   MOVE      HLPCLI        DDPCLI
 
      ** Format Parcel Size
      ** If zero, put out blanks; otherwise treat as numeric with no
      ** decimal places.
     C                   IF        HLPSZE = *zero
     C                   EVAL      DDPSZE = *blanks
     C                   ELSE
     C                   Z-ADD     HLPSZE        @@AMTW
     C                   Z-ADD     0             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDPSZE
     C                   ENDIF
 
      **  Originating Branch
     C                   MOVE      HLORBR        DDORBR
 
      **  Profit Centre
     C                   MOVE      HLPRFC        DDPRFC
 
      **  C.D. Reference Number.
     C                   MOVE      HLCDRF        DDCDRF
 
      **  Funding Spread/Rate.
     C     HLFSRP        IFNE      0
     C     HLFPRC        ORNE      *BLANKS
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      HLFSRP        @@AMTW
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFSRP
     C                   ENDIF
 
      **  Funding Profit Centre.
     C                   MOVEL     HLFPRC        DDFPRC
 
      *
      **  Set up text for deal status.
      *
     C     HLDSTS        IFEQ      'C'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
      *
     C     HLDSTS        IFEQ      'A'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
      *
     C     HLDSTS        IFEQ      'R'
     C                   MOVE      @STSA(3)      DDSTS
     C                   END
      *
     C     HLDSTS        IFEQ      'M'
     C                   MOVE      @STSA(4)      DDSTS
     C                   END
      *
     C     HLDDLT        IFEQ      'D'
     C                   MOVE      @STSA(5)      DDSTS
     C                   END
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      DDOYLC = HLOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      *
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     HLLQPR        MULT      10000000      @@AMTW                                       CAS005
     C                   Z-ADD     7             @@QECN                                       CAS005
     C                   EXSR      FMTAMT                                                     CAS005
     C                   MOVE      @@AMTD        DDLQPR                                       CAS005
     C                   EVAL      DDLQPS = HLLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C                   MOVE      HLCLAS        DDCLAS                                       CDL038
      *                                                                                       CDL049
      * Format Reference Rate                                                                 CDL049
     C     CDL049        IFEQ      'Y'                                                        CDL049
     C                   MOVE      HLRRAT        @@AMTW                                       CDL049
     C                   Z-ADD     8             @@QECN                                       CDL049
     C                   EXSR      FMTAMT                                                     CDL049
     C                   MOVE      @@AMTD        DDRRAT                                       CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL049
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
      * SCLRAT - SCALE RATE                                           *
      *****************************************************************
     C     SCLRAT        BEGSR
      *
     C                   CALLB     'ZA1150'
     C                   PARM                    @@SXP1            1 0
     C                   PARM                    @@SXP2            1 0
     C*****              PARM                    @@INRT           12 8          154453
     C                   PARM                    @@INRT           13 8          154453
     C                   PARM                    @@FCMD            1
     C*****              PARM      *ZEROS        @@SCRT           12 8          154453
     C*****              PARM      *ZEROS        @@ISRT           12 8          154453
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
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMNASPCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
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
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
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
      *
      ** ACCESS SAR DETAILS FOR Customer Format
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDL005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                                       CDL011
      ** ACCESS SAR DETAILS FOR Expansion of Customer Number                                  CDL011
      *                                                                                       CDL011
     C                   CALLB     'AOSARDR0'                                                 CDL011
     C                   PARM      *BLANKS       @RTCD                                        CDL011
     C                   PARM      '*VERIFY'     @OPTN                                        CDL011
     C                   PARM      'CDL011'      @SARD                                        CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL011
      *                                                                                       CDL011
      * DATABASE ERROR                                                                        CDL011
      *                                                                                       CDL011
     C     @RTCD         IFNE      *BLANKS                                                    CDL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL011
     C                   MOVEL     'CDL011'      DBKEY                                        CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL011
     C                   MOVEL     '906'         DBASE                                        CDL011
     C                   EXSR      *PSSR                                                      CDL011
     C                   END                                                                  CDL011
     C*                                                                                       CDL011
     C     @RTCD         IFEQ      *BLANK                                                     CDL011
     C                   MOVEL     'S'           CustFormat                                   CDL011
     C                   END                                                                  CDL011
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
     C                   EVAL      DBASE = 903                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 904                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
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
      *
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
(c) Misys International Banking Systems Ltd. 2001
** TEXT FOR DEAL STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
MATURED
DELETED
