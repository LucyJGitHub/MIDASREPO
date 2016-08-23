     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA DEALS File Trailer Update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZADLTRLRUD - DEALS FILE TRAILER UPDATE                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025467           Date 08May14               *
      *                 MD025244           Date 08May14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD025244 - Trailer allocation problem                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL008 - Continuous Linked Settlement (recompile DEALSDB)    *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDELULL  UF   E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDFF)
     F***DEALSDFX  O    E             DISK    COMMIT                               MD025244 MD025467
     FDLDEAZTD  O    E             DISK    COMMIT                                           MD025467
     F                                     RENAME(DEALSDFF : DEALSDFFX)                     MD025244
      ** Midas DL Deals File - Temporary Trailer                                            MD025244
      *                                                                                     MD025244
 
     D**  Array for aligning integer/decimal portions of amount
 
      **  Data Structure for aligning integer/decimal purchase amount
     D                 DS            18
     D  @@AINT                 1     15  0
     D  @@ADEC                16     18  0
     D  @@ID                   1     18
     D                                     DIM(18)
     C*****************************************************************
     C*
     C**  DEALS FILE TRAILER UPDATE
     C*
     C                   EXSR      DEALTU
     C*
     C** RETURN
     C*
     C                   RETURN
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DEALTU -  DEALS FILE TRAILER UPDATE                          *
     C*                                                              *
     C****************************************************************
     C     DEALTU        BEGSR
      *
      * Access trailer
      *
     C     EAPIC         IFEQ      *BLANKS                                                  MD025244
     C     999999        CHAIN     DEALSDFF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
     C                   ENDIF                                                              MD025244
      *
      ** FORMAT HASH TOTAL AMOUNTS
      *
     C                   EXSR      HASHFT
                                                                                            MD025244
     C                   IF        %SUBST(EAPIC: 1: 4) = 'LDNI'                             MD025244
     C                   EXSR      Initialise                                               MD025244
     C                   ENDIF                                                              MD025244
      *
      ** INSERTS
      *
     C     @@CHTP        IFEQ      'I'
      *
     C                   ADD       1             NORE
     C                   ADD       1             NINS
     C                   ADD       1             NLRA
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VRIF          @@OINT           15 0
     C                   Z-ADD     VRIL          @@ODEC            3 0
      *
     C                   EXSR      HASHTO
      *
     C                   Z-ADD     @@NINT        VRIF
     C                   Z-ADD     @@NDEC        VRIL
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VLAF          @@OINT
     C                   Z-ADD     VLAL          @@ODEC
      *
     C                   EXSR      HASHTO
      *
     C                   Z-ADD     @@NINT        VLAF
     C                   Z-ADD     @@NDEC        VLAL
      *                                                                                     MD025244
     C                   IF        %SUBST(EAPIC: 1: 4) = 'LDNI'                             MD025244
     C                   MOVE      'I'           RCDT                                       MD025244
     C                   ENDIF                                                              MD025244
      *                                                                                     MD025244
     C                   END
      *
      ** DELETIONS
      *
     C     @@CHTP        IFEQ      'R'
      *
     C                   ADD       1             NDEL
     C                   SUB       1             NLRA
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VRDF          @@OINT           15 0
     C                   Z-ADD     VRDL          @@ODEC            3 0
      *
     C                   EXSR      HASHTO
      *
     C                   Z-ADD     @@NINT        VRDF
     C                   Z-ADD     @@NDEC        VRDL
      *
      **   Subtract new amounts (reverse signs and add)
      *
     C                   Z-SUB     @@AINT        @@AINT
     C                   Z-SUB     @@ADEC        @@ADEC
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VLAF          @@OINT           15 0
     C                   Z-ADD     VLAL          @@ODEC            3 0
      *
     C                   EXSR      HASHTO
      *
     C                   Z-ADD     @@NINT        VLAF
     C                   Z-ADD     @@NDEC        VLAL
      *                                                                                     MD025244
     C                   IF        %SUBST(EAPIC: 1: 4) = 'LDNI'                             MD025244
     C                   MOVE      'R'           RCDT                                       MD025244
     C                   ENDIF                                                              MD025244
      *                                                                                     MD025244
     C                   END
      *
      ** Update trailer record
      *
     C                   IF        %SUBST(EAPIC: 1: 4) = 'LDNI'                             MD025244
     C                   MOVEL     'D'           RECI                                       MD025244
     C                   MOVE      EAPIC         DLNO                                       MD025244
     C                   Z-ADD     99            RCDC                                       MD025244
     C                   MOVE      '999999'      CNUM                                       MD025244
     C                   Z-ADD     BJRDNB        LCD                                        MD025244
     C                   MOVE      'I'           CHTP                                       MD025244
     C                   WRITE     DEALSDFFX                                                MD025244
     C                   ELSE                                                               MD025244
     C                   MOVE      'T'           RECI
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      @@CHTP        CHTP
      *
     C                   UPDATE    DEALSDFF
     C                   ENDIF                                                              MD025244
      *
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* HASHFT -  HASH FORMATTING                                    *
     C*                                                              *
     C****************************************************************
     C     HASHFT        BEGSR
      *
      ** Initialize Integer and Decimal
      *
     C                   Z-ADD     *ZERO         @@AINT
     C                   Z-ADD     *ZERO         @@ADEC
      *
      ** Ensure Principal is positive
      *
     C     @@AMNP        IFLT      0
     C                   Z-SUB     @@AMNP        @@AMNP
     C                   END
      *
      ** Move Amount into Integer and Decimal
      *
     C                   MOVE      @@AMNP        @@X15            15
     C                   MOVEA     @@X15         @@ID(4)
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* HASHTO -  HASH TOTALLING                                     *
     C*                                                              *
     C****************************************************************
     C     HASHTO        BEGSR
      *
      **  Initialise output field with input field
      *
     C                   Z-ADD     @@OINT        @@NINT           15 0
      *
      ** Ensure that the decimal has the same sign as the integer
      ** (On file the decimal already has a sign)
      *
     C     @@AINT        IFLT      *ZERO
     C     @@ADEC        ANDGT     *ZERO
     C                   Z-SUB     @@ADEC        @@ADEC
     C                   END
      *
      **  Decimals
      **  --------
      **  Add the decimals to the old total
      *
     C     @@ADEC        ADD       @@ODEC        @TOTDC            4 0
      *
      **  Monitor for overflow (eg. -15 + -990 = -1005)
      *
     C     @TOTDC        IFLT      -999
     C                   SUB       1             @@NINT
     C                   END
      *
      **  Monitor for overflow (eg. 15 + 990 = 1005)
      *
     C     @TOTDC        IFGT      999
     C                   ADD       1             @@NINT
     C                   END
      *
      **  Integers
      **  --------
      **  Add the integers to the overflow corrected old total
      *
     C                   ADD       @@AINT        @@NINT
      *
      **  COMPENSATE FOR THE DECIMALS GOING UNDER 0
      *
     C     @@ODEC        IFGE      0
     C     @@NINT        ANDGT     0
     C     @TOTDC        ANDLT     0
     C                   SUB       1             @@NINT
     C                   ADD       1000          @TOTDC
     C                   END
     C     @@ODEC        IFLT      0
     C     @@NINT        ANDLT     0
     C     @TOTDC        ANDGE     0
     C                   ADD       1             @@NINT
     C                   SUB       1000          @TOTDC
     C                   END
     C*
     C                   MOVE      @TOTDC        @@NDEC            3 0
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD025244
      *****************************************************************                     MD025244
      * Initialise - Initialise trailer fields                        *                     MD025244
      *****************************************************************                     MD025244
     C     Initialise    BEGSR                                                              MD025244
      *                                                                                     MD025244
     C                   EVAL      NORE = 0                                                 MD025244
     C                   EVAL      NLRB = 0                                                 MD025244
     C                   EVAL      NINS = 0                                                 MD025244
     C                   EVAL      NDEL = 0                                                 MD025244
     C                   EVAL      NLRA = 0                                                 MD025244
     C                   EVAL      VLBF = 0                                                 MD025244
     C                   EVAL      VLBL = 0                                                 MD025244
     C                   EVAL      VRIF = 0                                                 MD025244
     C                   EVAL      VRIL = 0                                                 MD025244
     C                   EVAL      VRDF = 0                                                 MD025244
     C                   EVAL      VRDL = 0                                                 MD025244
     C                   EVAL      VLAF = 0                                                 MD025244
     C                   EVAL      VLAL = 0                                                 MD025244
      *                                                                                     MD025244
     C                   ENDSR                                                              MD025244
      *****************************************************************                     MD025244
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
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Return Code
     C                   PARM                    @@RTCD            7
      *
      ** Change Type
     C                   PARM                    @@CHTP            1
      *
      ** Amount
     C                   PARM                    @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC            10                        MD025244
      *
     C                   ENDSR
     C****************************************************************
