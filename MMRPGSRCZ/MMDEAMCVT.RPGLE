     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal Amendment cnv: file to screen format')   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMCVT - Deal Amendment Conversion: File to Screen Format *
      *                                                               *
      *  Function: This module converts the fields of a Deal Amendment*
      *            from their format as on file to a screen format.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 01Sep14               *
      *  Prev Amend No. MD027637           Date 19Aug14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 221673             Date 10Feb05               *
      *                 BUG3620            Date 12Jul04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154453             Date 06Nov98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD027637 - Zero spread/interest rate not accepted in auth.   *
      *  CRE073 - Interest Rate Rounding                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  221673 - Display negative spread rate with correct sign on   *
      *           deal amendment screen. Applied fix 221126.          *
      *  BUG3620- Apply Base Rate at Value Date for Spread Changes    *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CDE002 - Revenue Analysis                                    *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  154453 - Applied fix 128710.                                 *
      *           Base ccy rate tolerance work field is to small.     *
      *           Increased the size of @ULIM.  Applied fix 114480.   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
 
      * Deam Status
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)
 
      * Deam in File Format
     D DeamFilFmt    E DS                  EXTNAME(MMDEAMPP)
 
      * Deam in Screen Format
     D DeamScnFmt    E DS                  EXTNAME(MMDEAMPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D PDaynoIn        S              5P 0                                                    CDL017
      ** Midas Day number                                                                     CDL017
                                                                                              CDL017
     D PDateOut        S              8S 0                                                    CDL017
      ** Formatted date field for use in the parameter list                                   CDL017
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  @@SXP1                 1      1  0
     D  @@SXP2                 2      2  0
 
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CRE073          S              1A                                                      CRE073
                                                                                              CRE073
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
     C**  Deam number.
     C                   MOVE      HNDA38        DDDLNO
     C*
     C**  Deam type.
     C                   MOVE      HNMTYP        DDMTYP
     C*
     C**  Format the value date.
     C                   Z-ADD     HNVDYY        @@YEAR
     C                   Z-ADD     HNVDMM        @@MNTH
     C                   Z-ADD     HNVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   END
     C*
     C**  Sequence Number AS400.
     C     HNDS38        IFEQ      0
     C                   MOVE      *BLANKS       DDDS38
     C                   ELSE
     C                   MOVE      HNDS38        DDDS38
     C                   END
     C*
     C**  Customer.
     C                   MOVE      *BLANKS       DDCSNM
     C*****HNCNUM        IFNE      0                                                          CSD027
     C     HNCNUM        IFNE      *BLANKS                                                    CSD027
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     HNCNUM        DDCSNM
     C                   ELSE
     C                   MOVEL     HNCSNM        DDCSNM
     C                   END
     C                   END
     C*
     C**  Interest Rate/spread.
     C*
     C**  Interest Rate.
     C**  - Execute FMTAMT to format the rate, using 8 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
 
     C     HNMTYP        IFNE      'SC'
     C     HNMTYP        ANDNE     'EM'                                                       CDL017
     C     HNMTYP        ANDNE     'BC'                                                       CDL022
     C                   MOVE      *BLANKS       DDINTR
     C                   ELSE
      *                                                                                       CDL017
     C     HNINTR        IFEQ      0                                                          CDL017
     C                   MOVE      *BLANKS       DDINTR                                       CDL017
      *                                                                                     MD027637
     C                   IF        HNMTYP = 'SC'                                            MD027637
     C                   EVAL      @@AMTW = 0                                               MD027637
     C                   EVAL      @@QECN = 7                                               MD027637
     C                   EXSR      FMTAMT                                                   MD027637
     C                   EVAL      DDINTR = @@AMTD                                          MD027637
     C                   ENDIF                                                              MD027637
      *                                                                                     MD027637
     C                   ELSE                                                                 CDL017
      *                                                                                       CDL017
     C     HNINTR        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C*
     C****Reverse*sign*for*display*if*amount*-ve.**********************                       221673
     C*****@@AMTW        IFLT      0                                                          221673
     C**********         Z-SUB     @@AMTW        @@AMTW                                       221673
     C**********         END                                                                  221673
     C*
     C                   EXSR      FMTAMT
      *
      **  If Anal Acctg is installed and Int Rate Chg Flag = 'N'
      **  or Revenue Analysis is installed and Int Rate Chg Flag = 'N'          CDE002
      **  DDINTR = blanks
      *
     C     BGN0ST        IFEQ      'Y'
     C     HNIRCF        ANDEQ     'N'
     C     CDE002        OREQ      'Y'                                          CDE002
     C     HNIRCF        ANDEQ     'N'                                          CDE002
     C                   MOVE      *BLANKS       DDINTR
     C                   ELSE
     C                   MOVE      @@AMTD        DDINTR
     C                   ENDIF
     C                   ENDIF                                                                CDL017
     C                   END
      *
      **  Process Funding Spread/Rate if Anal Acctg is installed
      **  or Revenue Analysis is installed                                      CDE002
      **  - Execute FMTAMT to format the rate, using 8 decimal places
      **    and adjusting the file figure to have only implied decimal
      **    places.
      *
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002
      *
     C     HNMTYP        IFNE      'SC'
     C                   MOVE      *BLANKS       DDFSRP
     C                   ELSE
     C     HNFSRP        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
      *
      **  Reverse sign for display if amount -ve.
      *
     C     @@AMTW        IFLT      0
     C                   Z-SUB     @@AMTW        @@AMTW
     C                   ENDIF
      *
     C                   EXSR      FMTAMT
      *
      **  If Fund Rate Chg Flag = 'N', DDFSRP = blanks
      *
     C     HNFRCF        IFEQ      'N'
     C                   MOVE      *BLANKS       DDFSRP
     C                   ELSE
     C                   MOVE      @@AMTD        DDFSRP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C**  Currency Code.
     C                   MOVE      HNCCY         DDCCY
     C*
     C**  Deam Amount.
     C**  Format Deam Amount, using deal ccy decimal places
     C*
     C     HNAMNP        IFEQ      0
     C     HNMTYP        OREQ      'SI'
     C     HNMTYP        OREQ      'CI'
     C     HNMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   MOVE      *BLANKS       DDAMNP
     C                   ELSE
     C                   Z-ADD     HNCYDP        @@QECN
     C*
     C**  Reverse sign for display if amount -ve.
     C     HNAMNP        IFGT      0
     C                   Z-ADD     HNAMNP        @@AMTW
     C                   ELSE
     C                   Z-SUB     HNAMNP        @@AMTW
     C                   END
     C*
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C                   END
     C*
     C**  Set up text for deam status.
     C*
     C     HNDSTS        IFEQ      'C'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
      *                                                                                       CDL017
      **  Penalty Pay/Receive                                                                 CDL017
     C                   MOVE      HNPENP        DDPENP                                       CDL017
      *                                                                                       CDL017
      **  Early Maturity Date (Converted from Miday day to YYYYMMDD to DDMMYY)                CDL017
     C     HNEMDT        IFNE      *ZEROS                                                     CDL017
     C                   MOVE      HNEMDT        PDaynoIn                                     CDL017
     C                   EXSR      FMTDAT                                                     CDL017
     C                   MOVE      PDateOut      @@DTIN                                       CDL017
     C                   EXSR      CVTDAT                                                     CDL017
     C                   MOVE      @@DTOU        DDEMDT                                       CDL017
     C                   ELSE                                                                 CDL017
     C                   MOVE      *BLANKS       DDEMDT                                       CDL017
     C                   ENDIF                                                                CDL017
      *                                                                                       CDL022
      **  Base Rate                                                                           CDL022
     C                   MOVE      HNBSRT        DDBSRT                                       CDL022
      *                                                                                       CDL020
      **  Actual Interest Rate if CDL020 is installed                                         CDL020
     C     CDL020        IFEQ      'Y'                                                        CDL020
      *                                                                                       CDL020
     C*****HNMTYP********IFNE      'BC'                                                CDL020BUG3620
     C     HNBRTE        IFEQ      0                                                         BUG3620
     C                   MOVE      *BLANKS       DDAIR                                        CDL020
     C                   ELSE                                                                 CDL020
     C     HNBRTE        ADD       HNINTR        WAIR             11 7                        CDL020
     C     WAIR          MULT      10000000      @@AMTW                                       CDL020
     C                   Z-ADD     7             @@QECN                                       CDL020
      *                                                                                       CDL020
      **  Reverse sign for display if amount -ve.                                             CDL020
      *                                                                                       CDL020
     C     @@AMTW        IFLT      0                                                          CDL020
     C                   Z-SUB     @@AMTW        @@AMTW                                       CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                       CDL020
     C                   EXSR      FMTAMT                                                     CDL020
     C                   MOVE      @@AMTD        DDAIR                                        CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                       CDL020
     C                   ENDIF                                                                CDL020
      *                                                                                       CDL020
      *                                                                                       CRE073
      ** Contractual Spread                                                                   CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   IF        HNCNSP <> *ZEROS                                           CRE073
     C                   MOVE      *BLANKS       @@AMTW                                       CRE073
     C     HNCNSP        MULT      10000000      @@AMTW                                       CRE073
     C                   Z-ADD     7             @@QECN                                       CRE073
     C                   EXSR      FMTAMT                                                     CRE073
     C                   MOVE      @@AMTD        DDCNSP                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Rounding Method                                                                      CRE073
      *                                                                                       CRE073
     C                   MOVEL     HNRDMT        DDRDMT                                       CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
      *                                                                                       CRE073
     C                   MOVEL     HNRDFD        DDRDFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C     HNDSTS        IFEQ      'A'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
     C*
     C     HNDSTS        IFEQ      'R'
     C                   MOVE      @STSA(3)      DDSTS
     C                   END
     C*
     C     HNDSTS        IFEQ      'M'
     C                   MOVE      @STSA(4)      DDSTS
     C                   END
     C*
     C     HNDDLT        IFEQ      'D'
     C                   MOVE      @STSA(5)      DDSTS
     C                   END
     C*
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
      *****************************************************************                       CDL017
      /EJECT                                                                                  CDL017
      *****************************************************************                       CDL017
      * FMTDAT - FORMAT DATE FOR DISPLAY                              *                       CDL017
      *****************************************************************                       CDL017
     C     FMTDAT        BEGSR                                                                CDL017
      *                                                                                       CDL017
     C                   CALLB     'ZDATE9'                                                   CDL017
     C                   PARM                    PDaynoIn                                     CDL017
     C                   PARM                    PDateOut                                     CDL017
     C                   PARM                    PRetCode          1                          CDL017
      *                                                                                       CDL017
     C                   ENDSR                                                                CDL017
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
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAM FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        DeamScnFmt
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
      * Deam in file format
     C                   PARM                    DeamFilFmt
      *
      * Output parameters
      *
      * Deam in screen format
     C                   PARM                    DeamScnFmt
      *
      * Deam Status
     C                   PARM                    DDSTS            24
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMCVT'   DBPGM
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
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
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
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
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
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
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
     C                   MOVEL     '904'         DBASE                                        CDL011
     C                   EXSR      *PSSR                                                      CDL011
     C                   END                                                                  CDL011
     C*                                                                                       CDL011
     C     @RTCD         IFEQ      *BLANK                                                     CDL011
     C                   MOVEL     'S'           CustFormat                                   CDL011
     C                   END                                                                  CDL011
      *
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
      *                                                                         CDE002
     C                   CallB     'AOSARDR0'                                   CDE002
     C                   Parm      *Blanks       PRTCD             7            CDE002
     C                   Parm      '*VERIFY'     POPTN             7            CDE002
     C                   Parm      'CDE002'      PSARD             6            CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C                   Move      'N'           CDE002            1            CDE002
     C                   If        PRTCD = *Blanks                              CDE002
     C                   Eval      CDE002 = 'Y'                                 CDE002
     C                   Endif                                                  CDE002
      *                                                                         CDL020
      ** Access SAR details file to determine if CDL020 is switched on          CDL020
      *                                                                         CDL020
     C                   CallB     'AOSARDR0'                                   CDL020
     C                   Parm      *Blanks       PRTCD                          CDL020
     C                   Parm      '*VERIFY'     POPTN                          CDL020
     C                   Parm      'CDL020'      PSARD                          CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                          CDL020
      *                                                                         CDL020
     C                   Move      'N'           CDL020            1            CDL020
     C                   If        PRTCD = *Blanks                              CDL020
     C                   Eval      CDL020 = 'Y'                                 CDL020
     C                   Endif                                                  CDL020
                                                                                              CDL033
      ** Determine if Floating Rate CD Issued feature is                                      CDL033
      ** switched on.                                                                         CDL033
     C                   MOVE      'N'           CDL033            1                          CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
                                                                                              CDL033
     C     PRTCD         IFEQ      *BLANKS                                                    CDL033
     C                   MOVE      'Y'           CDL033                                       CDL033
     C                   ELSE                                                                 CDL033
     C     PRTCD         IFNE      '*NRF   '                                                  CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   MOVE      '911'         DBASE                                        CDL033
     C                   MOVEL     'CDL033  '    DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CRE073
      ** Determine if CRE073 is switched on                                                   CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C     PRTCD         IFEQ      *BLANKS                                                    CRE073
     C                   MOVE      'Y'           CRE073                                       CRE073
     C                   ELSE                                                                 CRE073
     C     PRTCD         IFNE      '*NRF   '                                                  CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   MOVE      '912'         DBASE                                        CRE073
     C                   MOVEL     'CRE073  '    DBKEY                                        CRE073
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
 
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
** TEXT FOR DEAM STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
MATURED
DELETED
