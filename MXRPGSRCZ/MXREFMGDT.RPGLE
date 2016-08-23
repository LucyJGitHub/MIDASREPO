     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Reformat Message Data')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXREFMGDT - Reformat Message Data                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface (Recompile)    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * R E F O R M A T   D A T A
     D/COPY MXCPYSRC,MXRFMDD
 
      * G E T   F O R M A T   F I E L D S
     D/COPY MXCPYSRC,MXGTFF
 
 
      ** Number field 30,10
     D InNumber        S             30S10
 
      ** Alpha field 32 long, returned from reformatting procedures
     D fmAlpNum32      S             32A
 
      ** Length and decimal positions passed in to reformatting procedures
     D fmLength        S              2S 0
     D fmDecPos        S              2S 0
 
      ** Required decimal separator passed in to reformatting procedures
     D fmDecSep        S              1A
 
      ** Show Positive Sign flag passed in to reformatting procedures
     D fmShwPsSgn      S              1A
 
     DFmtInp           DS
     D FmtInp30A               1     30A
     D FmtInp01P               1     01P 0
     D FmtInp03P               1     02P 0
     D FmtInp05P               1     03P 0
     D FmtInp07P               1     04P 0
     D FmtInp09P               1     05P 0
     D FmtInp11P               1     06P 0
     D FmtInp13P               1     07P 0
     D FmtInp15P               1     08P 0
     D FmtInp17P               1     09P 0
     D FmtInp19P               1     10P 0
     D FmtInp21P               1     11P 0
     D FmtInp23P               1     12P 0
     D FmtInp25P               1     13P 0
     D FmtInp27P               1     14P 0
     D FmtInp29P               1     15P 0
     D FmtInp01S               1     01S 0
     D FmtInp02S               1     02S 0
     D FmtInp03S               1     03S 0
     D FmtInp04S               1     04S 0
     D FmtInp05S               1     05S 0
     D FmtInp06S               1     06S 0
     D FmtInp07S               1     07S 0
     D FmtInp08S               1     08S 0
     D FmtInp09S               1     09S 0
     D FmtInp10S               1     10S 0
     D FmtInp11S               1     11S 0
     D FmtInp12S               1     12S 0
     D FmtInp13S               1     13S 0
     D FmtInp14S               1     14S 0
     D FmtInp15S               1     15S 0
     D FmtInp16S               1     16S 0
     D FmtInp17S               1     17S 0
     D FmtInp18S               1     18S 0
     D FmtInp19S               1     19S 0
     D FmtInp20S               1     20S 0
     D FmtInp21S               1     21S 0
     D FmtInp22S               1     22S 0
     D FmtInp23S               1     23S 0
     D FmtInp24S               1     24S 0
     D FmtInp25S               1     25S 0
     D FmtInp26S               1     26S 0
     D FmtInp27S               1     27S 0
     D FmtInp28S               1     28S 0
     D FmtInp29S               1     29S 0
     D FmtInp30S               1     30S 0
 
 
     D  InAlpha        S             30A   INZ(*BLANKS)
     D  InPtr          S              2S 0 INZ(1)
     D  OutPtr         S              2S 0 INZ(1)
 
 
     D FieldOsize      S              4P 0
     D FieldO          S             30A
     D FieldSiz        S              4P 0
 
 
      * Reference ID SubFields & Sizes
     D REFSF           S             20    DIM(9)
     D REFSFSZ         S              4S 0 DIM(9)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    InData
     C                   PARM                    #_FLDD
     C                   PARM                    #_FLDS
     C                   PARM                    #_SELC
      * OUTPUTS
     C                   PARM                    OutPos
     C                   PARM                    OutData
     C                   PARM                    ReferID
     C                   PARM                    Select_EXP
 
      * Clear outputs
 
     C                   Z-ADD     1             OutPos
     C                   Clear                   OutData
     C                   MOVEL     *BLANK        ReferID
     C                   MOVEL     'N'           Select_EXP
 
      * Clear Reference ID SubFields & Sizes
 
     C                   Clear                   REFSF
     C                   Clear                   REFSFSZ
 
      * Error if no fields are supplied
 
     C     #_FLDD(1)     IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO DATA PASSED TO MXREFMGDT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set up the variables for formatting that will not change if
      * Replication formatting is required.
      * Decimal separator is '.', Signs are not shown for Positive numbers
 
     C                   EVAL      fmDecSep = '.'
     C                   EVAL      fmShwPsSgn = 'N'
 
      ** Process all fields on the format.
 
     C                   Z-ADD     1             FD                5 0
     C     #_FLDD(FD)    DOWNE     *BLANK
     C                   MOVEL     #_FLDD(FD)    FLDD
 
      ** Select type of processing required according to field type ..
     C                   SELECT
 
      * Field Type = PACKED Numeric
 
     C     WHFLDT        WHENEQ    'P'
     C                   EXSR      #SRPack
     C                   EVAL      %subst(OutData:OutPos:FieldOSize) =
     C                               %subst(fmAlpNum32:1:FieldOSize)
 
      * Field Type = SIGNED Numeric
 
     C     WHFLDT        WHENEQ    'S'
     C                   EXSR      #SRSign
     C                   EVAL      %subst(OutData:OutPos:FieldOSize) =
     C                               %subst(fmAlpNum32:1:FieldOSize)
 
      * Field Type = 'OTHER' (ALPHAMERIC)
 
     C                   OTHER
     C                   EVAL      FieldOSize  = WHFLDB
     C                   EVAL      %subst(OutData:OutPos:FieldOSize) =
     C                               %subst(InData:WHFOBO:WHFLDB)
 
     C                   ENDSL
 
      * Update output position
 
     C                   EVAL      OutPos = OutPos + FieldOSize
 
      * Update Reference ID Sub-Fields
 
     C     WHSREF        IFNE      *BLANK
     C                   EXSR      UPD_REFSF
     C                   ENDIF
 
      * Update Field Values of Fields For Selection
 
     C     Fld_4_Sel     IFEQ      'Y'
     C                   EXSR      UPD_FLDVL
     C                   ENDIF
 
      ** Process next record
     C                   ADD       1             FD
     C                   ENDDO
 
      * Determine Reference ID
 
     C                   EXSR      DET_REFID
 
      * Determine whether to select for export
 
     C     #_SELC(1)     IFNE      *BLANK
     C                   EXSR      DET_SELECT
     C                   ELSE
     C                   MOVEL     'Y'           Select_EXP
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      *****************************************************************
      *                                                               *
      * #SRPack - Process Packed Fields                               *
      *           Called by process ProcFormat for each Packed field  *
      *           on the format.                                      *
      *                                                               *
      *****************************************************************
     C     #SRPack       BEGSR
 
      ** Packed field
     C                   EVAL      fmLength = WHFLDD
     C                   EVAL      fmDecPos = WHFLDP
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)
 
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      InNumber   = 0
     C                   ELSE
 
     C                   SELECT
     C     WHFLDB        WHENEQ    01
     C                   EVAL      InNumber   = FmtInp01P
     C     WHFLDB        WHENEQ    02
     C                   EVAL      InNumber   = FmtInp03P
     C     WHFLDB        WHENEQ    03
     C                   EVAL      InNumber   = FmtInp05P
     C     WHFLDB        WHENEQ    04
     C                   EVAL      InNumber   = FmtInp07P
     C     WHFLDB        WHENEQ    05
     C                   EVAL      InNumber   = FmtInp09P
     C     WHFLDB        WHENEQ    06
     C                   EVAL      InNumber   = FmtInp11P
     C     WHFLDB        WHENEQ    07
     C                   EVAL      InNumber   = FmtInp13P
     C     WHFLDB        WHENEQ    08
     C                   EVAL      InNumber   = FmtInp15P
     C     WHFLDB        WHENEQ    09
     C                   EVAL      InNumber   = FmtInp17P
     C     WHFLDB        WHENEQ    10
     C                   EVAL      InNumber   = FmtInp19P
     C     WHFLDB        WHENEQ    11
     C                   EVAL      InNumber   = FmtInp21P
     C     WHFLDB        WHENEQ    12
     C                   EVAL      InNumber   = FmtInp23P
     C     WHFLDB        WHENEQ    13
     C                   EVAL      InNumber   = FmtInp25P
     C     WHFLDB        WHENEQ    14
     C                   EVAL      InNumber   = FmtInp27P
     C     WHFLDB        WHENEQ    15
     C                   EVAL      InNumber   = FmtInp29P
     C                   OTHER
     C                   EVAL      InNumber   = 0
     C                   ENDSL
     C                   ENDIF
 
      ** Adjust input field for the number of decimal places.
     C                   SELECT
     C     fmDecPos      WHENEQ    0
     C     fmDecPos      WHENEQ    7
     C                   EVAL      InNumber    = InNumber  /10000000
     C     fmDecPos      WHENEQ    8
     C                   EVAL      InNumber    = InNumber  /100000000
     C                   OTHER
     C                   EVAL      InNumber    = InNumber  /(10**fmDecPos)
     C                   endsl
 
     C                   EXSR      RPPSIGN
 
     C                   EVAL      FieldOSize  = WHFLDD + 2
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * #SRSign - Process Signed Fields                               *
      *           Called by process ProcFormat for each Signed field  *
      *           on the format.                                      *
      *                                                               *
      *****************************************************************
     C     #SRSign       BEGSR
      *
      ** Signed field
     C                   EVAL      fmLength = WHFLDD
     C                   EVAL      fmDecPos = WHFLDP
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)
 
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      InNumber   = 0
     C                   ELSE
 
     C                   SELECT
     C     WHFLDB        WHENEQ    01
     C                   EVAL      InNumber   = FmtInp01S
     C     WHFLDB        WHENEQ    02
     C                   EVAL      InNumber   = FmtInp02S
     C     WHFLDB        WHENEQ    03
     C                   EVAL      InNumber   = FmtInp03S
     C     WHFLDB        WHENEQ    04
     C                   EVAL      InNumber   = FmtInp04S
     C     WHFLDB        WHENEQ    05
     C                   EVAL      InNumber   = FmtInp05S
     C     WHFLDB        WHENEQ    06
     C                   EVAL      InNumber   = FmtInp06S
     C     WHFLDB        WHENEQ    07
     C                   EVAL      InNumber   = FmtInp07S
     C     WHFLDB        WHENEQ    08
     C                   EVAL      InNumber   = FmtInp08S
     C     WHFLDB        WHENEQ    09
     C                   EVAL      InNumber   = FmtInp09S
     C     WHFLDB        WHENEQ    10
     C                   EVAL      InNumber   = FmtInp10S
     C     WHFLDB        WHENEQ    11
     C                   EVAL      InNumber   = FmtInp11S
     C     WHFLDB        WHENEQ    12
     C                   EVAL      InNumber   = FmtInp12S
     C     WHFLDB        WHENEQ    13
     C                   EVAL      InNumber   = FmtInp13S
     C     WHFLDB        WHENEQ    14
     C                   EVAL      InNumber   = FmtInp14S
     C     WHFLDB        WHENEQ    15
     C                   EVAL      InNumber   = FmtInp15S
     C     WHFLDB        WHENEQ    16
     C                   EVAL      InNumber   = FmtInp16S
     C     WHFLDB        WHENEQ    17
     C                   EVAL      InNumber   = FmtInp17S
     C     WHFLDB        WHENEQ    18
     C                   EVAL      InNumber   = FmtInp18S
     C     WHFLDB        WHENEQ    19
     C                   EVAL      InNumber   = FmtInp19S
     C     WHFLDB        WHENEQ    20
     C                   EVAL      InNumber   = FmtInp20S
     C     WHFLDB        WHENEQ    21
     C                   EVAL      InNumber   = FmtInp21S
     C     WHFLDB        WHENEQ    22
     C                   EVAL      InNumber   = FmtInp22S
     C     WHFLDB        WHENEQ    23
     C                   EVAL      InNumber   = FmtInp23S
     C     WHFLDB        WHENEQ    24
     C                   EVAL      InNumber   = FmtInp24S
     C     WHFLDB        WHENEQ    25
     C                   EVAL      InNumber   = FmtInp25S
     C     WHFLDB        WHENEQ    26
     C                   EVAL      InNumber   = FmtInp26S
     C     WHFLDB        WHENEQ    27
     C                   EVAL      InNumber   = FmtInp27S
     C     WHFLDB        WHENEQ    28
     C                   EVAL      InNumber   = FmtInp28S
     C     WHFLDB        WHENEQ    29
     C                   EVAL      InNumber   = FmtInp29S
     C     WHFLDB        WHENEQ    30
     C                   EVAL      InNumber   = FmtInp30S
     C                   OTHER
     C                   EVAL      InNumber   = 0
     C                   ENDSL
     C                   ENDIF
 
      ** Adjust input field for the number of decimal places.
     C                   SELECT
     C     fmDecPos      WHENEQ    0
     C     fmDecPos      WHENEQ    7
     C                   EVAL      InNumber    = InNumber  /10000000
     C     fmDecPos      WHENEQ    8
     C                   EVAL      InNumber    = InNumber  /100000000
     C                   OTHER
     C                   EVAL      InNumber    = InNumber  /(10**fmDecPos)
     C                   endsl
 
     C                   EXSR      RPPSIGN
 
     C                   EVAL      FieldOSize  = WHFLDD + 2
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * RPPSIGN                                                       *
      *                                                               *
      *****************************************************************
     C     RPPSIGN       BEGSR
 
     C                   MOVEL     *BLANK        InAlpha
     C                   Z-ADD     1             InPtr
     C                   Z-ADD     1             OutPtr
     C                   CLEAR                   fmAlpNum32
 
      ** Place the incoming number into an alpha field for substringing
      **  purposes
     C                   movel     InNumber      InAlpha
 
      ** If the number of decimal places is 0, increase the length by 1
      **  so that a leading zero is introduced.
 
     C                   If        fmDecPos = 0
     C                   Eval      fmLength = fmLength + 1
     C                   EndIf
 
      ** Set the first byte of the Output field as the sign, only put in
      **  a positive sign if specifically requested.
     C                   if        InNumber < 0
     C                   eval      %subst(fmAlpNum32:OutPtr:1) = '-'
 
     C                   else
 
     C                   if        fmShwPsSgn = 'Y'
     C                   eval      %subst(fmAlpNum32:OutPtr:1) = '+'
     C                   endif
 
     C                   endif
 
     C                   eval      OutPtr = OutPtr + 1
 
      ** Extract the digits to the left of the decimal point
      ** As the whole number is aligned on the decimal point, and there are
      **  20 character to the left of the dp, this data will start at
      **  20 - N + 1, where N is the number digits to the left of the dp.
      **  N = Length - Decimal positions.
     C                   eval      InPtr = 20 - (fmLength-fmDecPos) + 1
     C                   eval      %subst(fmAlpNum32:OutPtr:(fmLength-fmDecPos))
     C                              = %subst(InAlpha:InPtr:(fmLength-fmDecPos))
 
     C                   eval      InPtr = InPtr + (fmLength-fmDecPos)
     C                   eval      OutPtr = OutPtr + (fmLength-fmDecPos)
 
      ** If requested, insert a decimal separator and there are any decimals
     C                   if            fmDecSep <> *blank
     C                             and fmDecPos > 0
 
     C                   eval      %subst(fmAlpNum32:OutPtr:1) = fmDecSep
 
     C                   eval      OutPtr = OutPtr + 1
 
     C                   endif
 
      ** Extract the digits to the right of the decimal point if there are
      **  any
     C                   if        fmDecPos > 0
 
     C                   eval      %subst(fmAlpNum32:OutPtr:fmDecPos) =
     C                              %subst(InAlpha:InPtr:fmDecPos)
 
     C                   endif
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Reference ID Sub-Fields
      ********************************************************************
     C     UPD_REFSF     BEGSR
 
     C                   MOVEL     WHSREF        SQ_RF             1 0
 
     C     WHFLDT        IFEQ      'P'
     C     WHFLDT        OREQ      'S'
     C                   EVAL      FieldO = %subst(fmAlpNum32:3:WHFLDD)
     C                   MOVEL     FieldO        REFSF(SQ_RF)
     C                   Z-ADD     WHFLDD        REFSFSZ(SQ_RF)
     C                   ELSE
     C                   EVAL      FieldO = %subst(InData:WHFOBO:WHFLDB)
     C                   MOVEL     FieldO        REFSF(SQ_RF)
     C                   Z-ADD     WHFLDB        REFSFSZ(SQ_RF)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Field Values of Fields For Selection
      ********************************************************************
     C     UPD_FLDVL     BEGSR
 
     C                   Z-ADD     1             SC                5 0
     C     WHFOBO        LOOKUP    #_FLDS(SC)                             99    *
     C     *in99         DOWEQ     '1'
 
     C     WHFLDT        IFEQ      'P'
     C     WHFLDT        OREQ      'S'
     C                   EVAL      Fld_Value = %subst(fmAlpNum32:3:WHFLDD)
     C                   ELSE
     C                   EVAL      Fld_Value = %subst(InData:WHFOBO:WHFLDB)
     C                   ENDIF
 
     C                   MOVE      Fld_Value     #_SELC(SC)
 
     C                   ADD       1             SC
     C     SC            IFLE      99
     C     WHFOBO        LOOKUP    #_FLDS(SC)                             99    *
     C                   ELSE
     C                   MOVE      '0'           *IN99
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine Reference ID
      ********************************************************************
     C     DET_REFID     BEGSR
 
      * Step through Reference ID Sub-Fields
      * to create the Reference ID
 
     C                   Z-ADD     1             RIDPtr            4 0
     C                   Z-ADD     *ZERO         SQ_RF
 
     C     SQ_RF         DOUEQ     9
 
     C                   ADD       1             SQ_RF
 
     C                   EVAL      FieldO     = REFSF(SQ_RF)
     C                   EVAL      FieldSiz   = REFSFSZ(SQ_RF)
 
     C     FieldSiz      ifne      *ZERO
     C     RIDPtr        andle     40
     C                   EVAL      %subst(ReferID:RIDPtr:FieldSiz) =
     C                               %subst(FieldO:1:FieldSiz)
     C                   EVAL      RIDPtr = RIDPtr + FieldSiz
     C                   endif
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine whether to select for export
      ********************************************************************
     C     DET_SELECT    BEGSR
 
     C                   Z-ADD     1             SC                5 0
     C                   Z-ADD     *ZERO         No_VCmps          5 0
     C                   Z-ADD     *ZERO         No_Cmps           5 0
 
     C     SC            DOWLE     99
     C     #_SELC(SC)    ANDNE     *BLANK
 
     C                   MOVEL     #_SELC(SC)    SELC
 
     C     ESSIAO        IFEQ      'IF '
     C     ESSIAO        OREQ      'OR '
     C     No_VCmps      IFNE      *ZERO
     C     No_VCmps      ANDEQ     No_Cmps
     C                   MOVEL     'Y'           Select_Exp
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     *ZERO         No_VCmps
     C                   Z-ADD     *ZERO         No_Cmps
     C                   ENDIF
 
     C                   SELECT
     C     ESSCMP        WHENEQ    'EQ'
     C     Fld_Value     COMP      ESSCPV                                 99    *
     C     ESSCMP        WHENEQ    'NE'
     C     Fld_Value     COMP      ESSCPV                             9999      *
     C     ESSCMP        WHENEQ    'GT'
     C     Fld_Value     COMP      ESSCPV                             99        *
     C     ESSCMP        WHENEQ    'GE'
     C     Fld_Value     COMP      ESSCPV                             99  99    *
     C     ESSCMP        WHENEQ    'LT'
     C     Fld_Value     COMP      ESSCPV                               99      *
     C     ESSCMP        WHENEQ    'LE'
     C     Fld_Value     COMP      ESSCPV                               9999    *
     C                   ENDSL
 
     C   99              ADD       1             No_VCmps          5 0
     C                   ADD       1             No_Cmps           5 0
 
     C                   ADD       1             SC
     C                   ENDDO
 
     C     No_VCmps      IFNE      *ZERO
     C     No_VCmps      ANDEQ     No_Cmps
     C                   MOVEL     'Y'           Select_Exp
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
