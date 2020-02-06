     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate purchase price for NAs bought')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNABPPRC - Validate Purchase price for NAs bought          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Purchase price and confirms whether it has a      *
      *             valid value.                                      *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *  Prev Amend No. MD000091           Date 13Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP076             Date 03Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191870             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178763             Date 22Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 140931             Date 17Aug98               *
      *                 CAP002  *CREATE    Date 28Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Code Substitution                           *
      *           - Applied for MD025735                              *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in /CPY MM1008C             *
      *           (new parameter to ZINTDY)                           *
      *  191870 - Calculation Basis 6 error.                          *
      *           Recompile due to changes to /COPY MM1008C           *
      *  178763 - Purchase price incorrectly calculated for deal      *
      *           Types TB, DA and TA.                                *
      *  140931 - Purch/sale price not correct if multi-period deal.  *
      *           (Recompiled with changed /COPY)                     *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the declares for the MM1008 subroutine
      /COPY MMCPYSRC,MM1008D
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Customer Details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** FO CUSTOMER DETAILS ACCESSED VIA ACCESS PROGRAM
     D SDFOCS        E DS                  EXTNAME(SDFOCSPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Warning message code 1 received as a parameter
     D Wmsgid1         S                   LIKE(#MSGID)
 
      ** Error message data field received as a parameter
     D WMsgData1       S                   LIKE(#MsgData)
 
      ** DEAL TYPE received as a parameter
     D DDMTYP          S              2A
 
      ** PURCHASE PRICE received as a parameter
     D DDAMNP          S             15A
 
      ** Currency Decimal separator received as parameter
     D BNDCSP          S              1A
 
      ** Next Interest Payment Date received as parameter
     D IHNIPD          S              5  0
 
      ** Start/Last Interest Date received as parameter
     D IHSLID          S              5  0
 
      ** Amount received as parameter
     D IHAMNP          S             15  0
      *
      ** NAS net value received as parameter
     D IHNANV          S             15  0
      *
      ** Interest rate received as parameter
     D IHINTR          S             11  7
      *
      ** Discount rate received as parameter
     D IHDCRT          S             11  7
      *
      ** Face rate received as parameter
     D IHFRAT          S             11  7
      *
      ** Face value received as parameter
     D IHFVAL          S             15  0
      *
      ** Interest calculation method received as parameter
     D IHICMT          S              1A
      *
      ** MIDAS deal type received as parameter
     D IHMTYP          S              2A
      *
      ** Interest payment frequency received as parameter
     D IHIPFQ          S              1A
      *
      ** Ldi int payment day in month received as parameter
     D IHIPDM          S             02S 0
      *
      ** Currency code received as parameter
     D IHCCY           S              3A
      *
      ** Maturity Date in Midas Dayno. format received as a parameter
     D @MDYNO          S              5  0
 
      ** Value Date in Midas Dayno. format received as a parameter
     D @VDYNO          S              5  0
 
      ** Currency Number of Decimal Places received as a parameter
     D A6NBDP          S              1S 0
 
      ** Deal Type validation indicator received as a parameter
     D DDMtypOK        S              1A
 
      ** Currency validation indicator received as a parameter
     D DDCcyOK         S              1A
 
      ** Value Date validation indicator received as a parameter
     D DDVdatOK        S              1A
 
      ** Maturity Date validation indicator received as a parameter
     D DDMdatOK        S              1A
 
      ** Face Value validation indicator received as a parameter
     D DDFvalOK        S              1A
 
      ** Interest Rate validation indicator received as a parameter
     D DDIntrOK        S              1A
 
      ** Interest Calculation Method validation indicator
      ** received as a parameter
     D DDIcmtOK        S              1A
 
      ** Start/Last Interest Date validation indicator
      ** received as a parameter
     D DDSlidOK        S              1A
 
     D DDipfqOK        S              1A
 
      ** ========================================================
      ** Fields for checking that number is numeric
      ** (used in call to ZA0840)
 
      ** 16-alpha version of the Purchase Price
     D PriceAlpha      S             16A
 
      ** Number of integers
     D NoOfInt         S              3P 0 INZ(6)
 
      ** Number of decimals
     D NoOfDec         S              3P 0 INZ(0)
 
      ** 15-numeric returned version of number
     D AmountOut       S             15P 0
 
      ** Millions/Thousands id
     D MillThou        S              1A   INZ('N')
 
      ** Error code
     D ErrorCode       S              1  0
 
      ** End of fields for numeric checking
      ** ==================================
 
      ** ========================================================
      ** Fields used in call to ZDATE9
 
      ** Formatted date field for use in the parameter list
     D DateOut         S              8S 0
 
      ** Return Code
     D @@Rtn           S              1A
 
      ** End of fields for ZDATE9
 
      ** ========================================================
      ** Fields used in call to ZA0920
 
      ** Purchase Price field in - 13,0
     D InAmount        S             13P 0
 
      ** 14A returned version of Purchase Price
     D OutAmount       S             14A
 
      ** Number of decimals
     D @@QECN          S              1P 0 INZ(0)
 
      ** End of fields for ZA0920
      ** ==================================
 
     D @@RONS          S             18A                                                      CGL029
                                                                                            MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   RESET                   WarnGlobal
      *
      *  *-------------------------*
      *  * Validate Purchase Price *
      *  *-------------------------*
      *
      **  If the deal type is invalid then no further validation can be do
      *
     C     DDMtypOK      IFNE      'N'
      *
      **  If deal type is 'C1' and Purchase Price has been entered
      **  then it is an error.
     C     DDMTYP        IFEQ      'C1'
     C     DDAMNP        ANDNE     *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0403'     Msgid1
      *
      **  If deal type is not 'C1' and Purchase Price has not been entered
      **  then it is an error.
     C                   ELSE
     C     DDMTYP        IFNE      'C1'
     C     DDAMNP        ANDEQ     *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0404'     Msgid1
     C                   END
      *
     C                   END
      *
      **  If the currency is invalid then no further validation can be done
     C     DDCcyOK       IFNE      'N'
     C     ErrorFound    ANDEQ     'N'
     C     DDAMNP        ANDNE     *BLANK
      *
      **  Verify that the amount entered is valid numeric.
     C                   Z-ADD     A6NBDP        NoOfDec
     C     13            SUB       A6NBDP        NoOfInt
     C                   MOVE      *BLANKS       PriceAlpha
     C                   MOVE      DDAMNP        PriceAlpha
     C                   MOVE      'Y'           MillThou
     C                   CALLB     'ZA0840'
     C                   PARM                    ReturnCode
     C                   PARM                    PriceAlpha
     C                   PARM                    NoOfDec
     C                   PARM                    NoOfInt
     C                   PARM                    MillThou
     C                   PARM                    ErrorCode
     C                   PARM                    AmountOut
     C                   PARM                    BNDCSP
 
     C     ErrorCode     IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0405'     Msgid1
      *
      **  If the amount is a valid number, cross validate the actual
      **  amount. (Only if all the fields used are valid.)
     C                   ELSE
      *
     C                   MOVE      PriceAlpha    DDAMNP
     C                   Z-SUB     AmountOut     IHAMNP
     C                   Z-ADD     IHAMNP        IHNANV
      *
     C     DDVdatOK      IFNE      'N'
 
     C     DDMdatOK      IFNE      'N'
 
     C     DDFvalOK      IFNE      'N'
     C     DDIntrOK      ANDNE     'N'
     C     DDIcmtOK      ANDNE     'N'
     C     DDSlidOK      ANDNE     'N'
     C     DDipfqOK      ANDNE     'N'
      *
      **  Set up the fields for the execution of the routine to
      **  calculate price from the yield.
      *
     C                   Z-ADD     @MDYNO        @@DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN
     C                   Z-ADD     DateOut       @@MDAT
 
     C                   Z-ADD     @VDYNO        @@DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN
     C                   Z-ADD     DateOut       @@VDAT
 
     C                   Z-ADD     IHNIPD        @@DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN
     C                   Z-ADD     DateOut       @@IDAT
 
     C                   Z-ADD     IHSLID        @@DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN
     C                   Z-ADD     DateOut       @@SDAT
 
      *
      ** FOR INTEREST BEARING NAS USE INTEREST RATE (IHINTR),
      ** ELSE, USE DISCOUNT RATE (IHDCRT)
     C     DDMTYP        IFEQ      'C1'
     C     DDMTYP        OREQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
     C                   Z-ADD     IHINTR        @@DRAT
     C                   ELSE
     C                   Z-ADD     IHDCRT        @@DRAT
     C                   END
     C                   Z-ADD     IHFRAT        @@FACR
     C                   Z-ADD     IHFVAL        @@FVAL
     C                   MOVE      IHICMT        ZZCALC
     C**********         MOVE      IHMTYP        @@TYPE                                       178763
     C                   MOVE      DDMTYP        @@TYPE                                       178763
     C                   MOVE      IHIPFQ        @@FREQ
     C                   Z-ADD     IHIPDM        @@MDAY
     C                   MOVE      IHCCY         @@CCY
     C                   Z-ADD     *ZEROS        @@RSTM            2 0
     C**********         MOVE      *BLANKS       @@RONS           12                          CGL029
     C                   MOVE      *BLANKS       @@RONS                                       CGL029
      *
     C                   EXSR      MM1008
      *
      **  Find the difference between the input and calculated price
      **  - if the difference is greater than 1 currency unit, this is
      **    an error.
     C     IHAMNP        ADD       @@PRIC        Difference
      *
     C     Difference    IFLT      0
     C                   Z-SUB     Difference    Difference
     C                   END
      *
     C                   MOVE      '0'           *IN18
      *
     C     A6NBDP        IFEQ      0
     C     Difference    ANDGT     1
     C                   MOVE      '1'           *IN18
     C                   END
      *
     C     A6NBDP        IFEQ      1
     C     Difference    DIV(H)    10            @WK151
     C     @WK151        IFGT      1
     C                   MOVE      '1'           *IN18
     C                   END
     C                   END
      *
     C     A6NBDP        IFEQ      2
     C     Difference    DIV(H)    100           @WK152
     C     @WK152        IFGT      1
     C                   MOVE      '1'           *IN18
     C                   END
     C                   END
      *
     C     A6NBDP        IFEQ      3
     C     Difference    DIV(H)    1000          @WK153
     C     @WK153        IFGT      1
     C                   MOVE      '1'           *IN18
     C                   END
     C                   END
      *
     C     *IN18         IFEQ      '1'
     C                   MOVE      'Y'           WarnFound
     C                   MOVE      'Y'           WarnGlobal
     C                   MOVEL     'MMM0407'     WMsgid1
 
     C                   Z-ADD     @@PRIC        InAmount
     C                   Z-ADD     A6NBDP        @@QECN
 
     C                   CALLB     'ZA0920'
     C                   PARM                    ReturnCode
     C                   PARM                    InAmount
     C                   PARM                    @@QECN
     C                   PARM                    BNDCSP
     C                   PARM                    OutAmount
 
     C**********         MOVEL     OutAmount     WMsgData1                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(OutAmount))                            MD000091
     C                   EVAL      WMsgData1 = LenStr +%TRIM(OutAmount)                     MD000091
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
      **  If the amount is valid, output it
      *
     C     DDCcyOK       IFNE      'N'
     C     ErrorFound    ANDEQ     'N'
     C     DDAMNP        IFNE      *BLANK
     C                   Z-ADD     IHAMNP        IHAMNP
     C                   MOVE      PriceAlpha    DDAMNP
     C                   ELSE
     C                   Z-ADD     *ZERO         IHAMNP
     C                   END
     C                   Z-ADD     IHAMNP        IHNANV
     C     DDMTYP        IFEQ      'C1'
     C                   Z-SUB     IHFVAL        IHAMNP
     C                   ENDIF
     C                   END
      *
      ** If an error was found, set the return code appropriately
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ** Include the MM1008 subroutine
      /COPY MMCPYSRC,MM1008C
      *****************************************************************
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
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgData1
     C                   PARM                    DDAMNP
     C                   PARM                    DDMTYP
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
     C                   PARM                    IHNIPD
     C                   PARM                    IHSLID
     C                   PARM                    IHAMNP
     C                   PARM                    IHNANV
     C                   PARM                    IHINTR
     C                   PARM                    IHDCRT
     C                   PARM                    IHFRAT
     C                   PARM                    IHFVAL
     C                   PARM                    IHICMT
     C                   PARM                    IHMTYP
     C                   PARM                    IHIPFQ
     C                   PARM                    IHIPDM
     C                   PARM                    IHCCY
     C                   PARM                    @MDYNO
     C                   PARM                    @VDYNO
     C                   PARM                    DDMtypOK
     C                   PARM                    DDCcyOK
     C                   PARM                    DDVdatOK
     C                   PARM                    DDMdatOK
     C                   PARM                    DDFvalOK
     C                   PARM                    DDIntrOK
     C                   PARM                    DDIcmtOK
     C                   PARM                    DDSlidOK
     C                   PARM                    DDipfqOK
     C                   PARM                    WarnGlobal
 
     C                   MOVE      DDMTYP        IHMTYP
 
     C** Define work fields
     C     *LIKE         DEFINE    IHAMNP        Difference
     C     *LIKE         DEFINE    IHAMNP        @WK151
     C     *LIKE         DEFINE    IHAMNP        @WK152
     C     *LIKE         DEFINE    IHAMNP        @WK153
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
