     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Cross-validate sale/purchase price (NASS)')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSALVPUR - Cross-validate sale price against purchase      *
      *               price for Negotiable Assets Sold                *
      *                                                               *
      *  Function:  This module checks that the sale price of a       *
      *             Negotiable Asset Sold matches the purchase price  *
      *             of the associated Negotiable Asset Purchased.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL069             Date 09Oct18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP076             Date 03Jun02               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191870             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 140931             Date 17Aug98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL069 - True Discount for Negotiable Assets                 *
      *           Recompile due to change in /CPYs MM1008C & MM1008D  *
      *  MD046248 - Finastra Rebranding                               *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in /CPY MM1008C             *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  191870 - Calculation Basis 6 error.                          *
      *           Recompile due to changes to /COPY MM1008C           *
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

      *****************************************************************
      ** Include the declares for the MM1008 subroutine
      /COPY MMCPYSRC,MM1008D
      *****************************************************************
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

     D                 DS
     D**  DATA STRUCTURE FOR DATE INPUT TO VARIOUS SUBROUTINES
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@MM                   5      6  0
     D  @@MTH                  5      6  0
     D  @@DD                   7      8  0
     D  @@DAY                  7      8  0

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                     CDL069
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CDL069
                                                                                CDL069
      ** Switchable Feature Details                                             CDL069
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL069

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** ==========
      ** Parameters

      ** Warning message ID (7A, returned to caller
     D WMsgID1         S                   LIKE(#MsgID)

      ** Message data (45A, returned to caller
     D MsgDta1         S                   LIKE(#MsgData)

      ** Negotiable Asset purchased data structure (received from caller)
     D NAPurch       E DS                  EXTNAME(MMDENBPP)

      ** Value date in Midas day number format (5,0P, transaction via caller)
     D ILDVSD          S              5P 0

      ** Number of decimal places in currency (3,0P, from SDCURRPD via
      ** caller)
     D A6NBDP          S              1S 0

      ** Decimal separator (1A, from SDDEALPD via caller)
     D BNDCSP          S              1A

      ** Formated version of Yield Rate (11,7P, from transaction via caller)
      **   @@DRAT is declared in the MM1008D /COPY member, as it is only
      **   used in the MM1008 subroutine.

      ** Formated version of Sale Price (15,0P, from transaction via caller)
     D ILAMNP          S             15P 0

      ** Formated version of Face Value (15,0P, from transaction via caller)
     D ILFVAL          S             15P 0

      ** Associated deal number OK flag (1A, from caller)
     D DDDADNOK        S              1A

      ** Value date OK flag (1A, from caller)
     D DDVDATOK        S              1A

      ** Currency OK flag (1A, from caller)
     D DDCCYOK         S              1A

      ** Face value OK flag (1A, from caller)
     D DDFVALOK        S              1A

      ** Sale price OK flag (1A, from caller)
     D DDAMNPOK        S              1A

      ** Yield rate OK flag (1A, from caller)
     D DDINTROK        S              1A

      ** End of parameters
      ** =================

      ** Amount passed to ZA0920 for editing
     D @@AMTW          S             13P 0

      ** Edited amount received from ZA0920
     D @@AMTD          S             14A

      ** Number of decimal places field to pass to ZA0920 (packed, while the
      ** incoming one is zoned)
     D @@QECN          S              1P 0

      ** Return code for ZDATE9
     D @@RTN           S              1A
     D @@RONS          S             18A                                                      CGL029

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

      ** Reset error flag and message ID and data fields to prevent
      ** problems on subsequent calls.
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   WMsgID1
     C                   RESET                   MsgDta1

     C**  If all related fields are valid (assoc. deal, value date,
     C**  ccy, yield, face value and sale price) perform cross validation
     C**  checks
     C     DDDADNOK      IFNE      'N'
     C     DDVDATOK      ANDNE     'N'
     C     DDCCYOK       ANDNE     'N'
     C     DDFVALOK      ANDNE     'N'
     C     DDAMNPOK      ANDNE     'N'
     C     DDINTROK      ANDNE     'N'

      **  Set up the fields for the execution of the routine to
      **  calculate price from the yield. Take value date and yield
      **  from screen entry and get remaining fields from assoc. deal

      ** Must convert Value Date from Midas day number form to YYYYMMDD,
      ** for MM1008 (which will promptly convert it back, but that's
      ** reverse engineering).

     C                   CALLB     'ZDATE9'
     C                   PARM                    ILDVSD
     C                   PARM                    @@VDAT
     C                   PARM                    @@RTN

     C                   Z-ADD     HLMDYY        @@YYYY
     C                   Z-ADD     HLMDMM        @@MTH
     C                   Z-ADD     HLMDDD        @@DAY
     C                   Z-ADD     @@DTIN        @@MDAT

     C                   Z-ADD     HLNIYY        @@YYYY
     C                   Z-ADD     HLNIMM        @@MTH
     C                   Z-ADD     HLNIDD        @@DAY
     C                   Z-ADD     @@DTIN        @@IDAT

     C                   Z-ADD     HLLIYY        @@YYYY
     C                   Z-ADD     HLLIMM        @@MTH
     C                   Z-ADD     HLLIDD        @@DAY
     C                   Z-ADD     @@DTIN        @@SDAT

     C                   Z-ADD     HLFRAT        @@FACR
      *
      ** If parcelled NA must obtain face value from NAS std deal parm
      ** if not parcelled obtain from NAB. This is because a parcelled
      ** NA may be selling only a portion of the NAB.
     C     HLPCLI        IFNE      'P'
     C                   Z-ADD     HLFVAL        @@FVAL
     C                   ELSE
     C                   Z-ADD     ILFVAL        @@FVAL
     C                   END
      *
     C                   MOVE      HLICMT        ZZCALC
     C                   MOVE      HLMTYP        @@TYPE
     C                   MOVE      HLIPFQ        @@FREQ
     C                   Z-ADD     HLIPDM        @@MDAY
     C*
     C** Save fields used in ZCHKH
     C                   MOVEL     HLRSTM        @@RSTM            2 0
     C**********         MOVE      HLRONS        @@RONS           12                          CGL029
     C                   MOVE      HLRONS        @@RONS                                       CGL029

      ** Set up currency fieled used by MM1008
     C     HLSTCY        IFNE      *BLANK
     C                   EVAL      @@CCY = HLSTCY
     C                   ELSE
     C                   EVAL      @@CCY = HLCCY
     C                   END
     C                   EXSR      MM1008
     C*
     C**  Find the difference between the input and calculated price
     C**  - if the difference is greater than 1 currency unit, this is
     C**    an error.
     C     ILAMNP        IFGT      @@PRIC
     C     ILAMNP        SUB       @@PRIC        @DIFI            15 0
     C                   ELSE
     C     @@PRIC        SUB       ILAMNP        @DIFI
     C                   END
     C*
     C     A6NBDP        IFEQ      0
     C     @DIFI         ANDGT     1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C*
     C     A6NBDP        IFEQ      1
     C     @DIFI         DIV(H)    10            @WK151           15 1
     C     @WK151        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C*
     C     A6NBDP        IFEQ      2
     C     @DIFI         DIV(H)    100           @WK152           15 2
     C     @WK152        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C*
     C     A6NBDP        IFEQ      3
     C     @DIFI         DIV(H)    1000          @WK153           15 3
     C     @WK153        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C*
     C     ErrorFound    IFEQ      'Y'
     C                   Z-ADD     @@PRIC        @@AMTW

     C                   RESET                   ReturnCode
     C                   EVAL      @@QECN = A6NBDP
     C                   CALLB     'ZA0920'
     C                   PARM                    ReturnCode
     C                   PARM                    @@AMTW
     C                   PARM                    @@QECN
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTD

     C                   MOVEL     @@AMTD        MsgDta1
     C                   MOVEL     'MMM0411'     WMsgID1
     C                   EVAL      WarnFound = 'Y'
     C                   END
     C                   END

      ** Reset ErrorFound, as this module can only return warnings
     C                   RESET                   ErrorFound

      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** Include the MM1008 subroutine
      /COPY MMCPYSRC,MM1008C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Warning message ID (7A, returned to caller)
     C                   PARM                    WMsgid1
      ** Message data (45A, returned to caller)
     C                   PARM                    MsgDta1
      ** Negotiable assets purchases data structure (MMDENBPP layout,
      ** from caller)
     C                   PARM                    NAPurch
      ** Value date in Midas day number format (5,0P, transaction via caller)
     C                   PARM                    ILDVSD
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD
      ** via caller)
     C                   PARM                    A6NBDP
      ** Decimal separator (1A, from SDDEALPD via caller)
     C                   PARM                    BNDCSP
      ** Formated version of Yield Rate (11,7P, from transaction via caller)
     C                   PARM                    @@DRAT
      ** Formated version of Sale Price (15,0P, from transaction via caller)
     C                   PARM                    ILAMNP
      ** Formated version of Face Value (15,0P, from transaction via caller)
     C                   PARM                    ILFVAL
      ** Associated deal number OK flag (1A, from caller)
     C                   PARM                    DDDADNOK
      ** Value date OK flag (1A, from caller)
     C                   PARM                    DDVDATOK
      ** Currency OK flag (1A, from caller)
     C                   PARM                    DDCCYOK
      ** Face value OK flag (1A, from caller)
     C                   PARM                    DDFVALOK
      ** Sale price OK flag (1A, from caller)
     C                   PARM                    DDAMNPOK
      ** Yield rate OK flag (1A, from caller)
     C                   PARM                    DDINTROK

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C/COPY ZACPYSRC,DBFIELDS

      ** Check if CDL069 is active                                              CDL069
      *                                                                         CDL069
     C                   MOVE      'N'           CDL069            1            CDL069
     C                   CALLB     'AOSARDR0'                                   CDL069
     C                   PARM      *BLANKS       PRtCd             7            CDL069
     C                   PARM      '*VERIFY'     POptn             7            CDL069
     C                   PARM      'CDL069'      PSARD             6            CDL069
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL069
                                                                                CDL069
     C                   IF        PRtCd = *Blanks                              CDL069
     C                   EVAL      CDL069 = 'Y'                                 CDL069
     C                   ENDIF                                                  CDL069

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
