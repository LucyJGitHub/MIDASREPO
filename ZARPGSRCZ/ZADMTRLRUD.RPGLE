     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA DEAMS File Trailer Update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZADMTRLRUD - DEAMS FILE TRAILER UPDATE                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8069            Date 25May06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CDL038             Date 10May05               *
      *                 136431             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
/*    *  BUG8069 - DLC0601B 00001 file out of balance in DL0215AU     *
/*    *            Prevent commitment control error on DEAMS          *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  136431 - Trailer wrongly updated                             *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDEMULL  UF   E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEAMSDJF)
     F                                     INFSR(*PSSR)                                      BUG8069
 
     D**  Array for aligning integer/decimal portions of amount
 
      **  Data Structure for aligning integer/decimal purchase amount
     D                 DS            18
     D  @@AINT                 1     15  0
     D  @@ADEC                16     18  0
     D  @@ID                   1     18
     D                                     DIM(18)
     C*****************************************************************
     C*
     C**  DEAMS FILE TRAILER UPDATE
     C*
     C                   EXSR      DEAMTU
     C*
     C** RETURN
     C*
     C                   RETURN
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DEAMTU -  DEAMS FILE TRAILER UPDATE                          *
     C*                                                              *
     C****************************************************************
     C     DEAMTU        BEGSR
      *
      * Access trailer
      *
     C     999999        CHAIN     DEAMSDJF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      ** FORMAT HASH TOTAL AMOUNTS
      *
     C                   EXSR      HASHFT
      *
      ** INSERTS - GENERAL
      *
     C     @@CHTP        IFEQ      'I'
      *
     C                   ADD       1             NORE
     C                   ADD       1             NINS
     C                   ADD       1             NLRA
      *                                                                         136431
     C                   END                                                    136431
      *                                                                         136431
      ** INSERTS - PRINCIPAL INCREASES                                          136431
      *                                                                         136431
     C     @@CHTP        IFEQ      'I'                                          136431
     C     @@TYPE        ANDEQ     'PI'                                         136431
      *                                                                         136431
     C                   ADD       1             NIPR                           136431
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
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VIPF          @@OINT                         136431
     C                   Z-ADD     VIPL          @@ODEC                         136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VIPF                           136431
     C                   Z-ADD     @@NDEC        VIPL                           136431
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
     C                   END
      *                                                                         136431
      ** INSERTS - PRINCIPAL DECREASES                                          136431
      *                                                                         136431
     C     @@CHTP        IFEQ      'I'                                          136431
     C     @@TYPE        ANDEQ     'PD'                                         136431
      *                                                                         136431
     C                   ADD       1             NDPR                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VRIF          @@OINT           15 0          136431
     C                   Z-ADD     VRIL          @@ODEC            3 0          136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VRIF                           136431
     C                   Z-ADD     @@NDEC        VRIL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VDPF          @@OINT                         136431
     C                   Z-ADD     VDPL          @@ODEC                         136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VDPF                           136431
     C                   Z-ADD     @@NDEC        VDPL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VLAF          @@OINT                         136431
     C                   Z-ADD     VLAL          @@ODEC                         136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VLAF                           136431
     C                   Z-ADD     @@NDEC        VLAL                           136431
     C                   END                                                    136431
      *
      ** DELETIONS - GENERAL
      *
     C     @@CHTP        IFEQ      'R'
      *
     C                   ADD       1             NDEL
     C                   SUB       1             NLRA
      *                                                                         136431
     C                   END                                                    136431
      *                                                                         136431
      ** DELETIONS - PRINCIPAL INCREASES                                        136431
      *                                                                         136431
     C     @@CHTP        IFEQ      'R'                                          136431
     C     @@TYPE        ANDEQ     'PI'                                         136431
      *                                                                         136431
     C                   SUB       1             NIPR                           136431
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
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VIPF          @@OINT           15 0          136431
     C                   Z-ADD     VIPL          @@ODEC            3 0          136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VIPF                           136431
     C                   Z-ADD     @@NDEC        VIPL                           136431
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
     C                   END
      *                                                                         136431
      ** DELETIONS - PRINCIPAL DECREASES                                        136431
      *                                                                         136431
     C     @@CHTP        IFEQ      'R'                                          136431
     C     @@TYPE        ANDEQ     'PD'                                         136431
      *                                                                         136431
     C                   SUB       1             NDPR                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VRDF          @@OINT           15 0          136431
     C                   Z-ADD     VRDL          @@ODEC            3 0          136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VRDF                           136431
     C                   Z-ADD     @@NDEC        VRDL                           136431
      *                                                                         136431
      **   Subtract new amounts (reverse signs and add)                         136431
      *                                                                         136431
     C                   Z-SUB     @@AINT        @@AINT                         136431
     C                   Z-SUB     @@ADEC        @@ADEC                         136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VDPF          @@OINT           15 0          136431
     C                   Z-ADD     VDPL          @@ODEC            3 0          136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VDPF                           136431
     C                   Z-ADD     @@NDEC        VDPL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VLAF          @@OINT           15 0          136431
     C                   Z-ADD     VLAL          @@ODEC            3 0          136431
      *                                                                         136431
     C                   EXSR      HASHTO                                       136431
      *                                                                         136431
     C                   Z-ADD     @@NINT        VLAF                           136431
     C                   Z-ADD     @@NDEC        VLAL                           136431
     C                   END                                                    136431
      *
      ** Update trailer record
      *
     C                   MOVE      'T'           RECI
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      @@CHTP        CHTP
      *
     C                   UPDATE    DEAMSDJF
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
      *                                                                         136431
      ** Deal Amendment Type                                                    136431
     C                   PARM                    @@TYPE            2            136431
      *
      ** Amount
     C                   PARM                    @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
      *
     C                   ENDSR
     C****************************************************************
      *                                                               *                      BUG8069
      * *PSSR  - Program Exception Error Routine                      *                      BUG8069
      *                                                               *                      BUG8069
      *****************************************************************                      BUG8069
     C     *PSSR         BEGSR                                                               BUG8069
      *                                                                                      BUG8069
     C                   MOVEL     '*ERROR '     @@RTCD                                      BUG8069
     C                   RETURN                                                              BUG8069
      *                                                                                      BUG8069
     C                   ENDSR                                                               BUG8069
     C****************************************************************
