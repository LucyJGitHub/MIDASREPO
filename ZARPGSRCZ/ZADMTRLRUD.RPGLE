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
      *  Last Amend No. MD037057           Date 22Mar16               *
      *  Prev Amend No. AR856140           Date 22Mar16               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
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
      *  MD037057 - Comment out subroutine HASHTO on top of applied   *
      *             fix for AR856140; subroutine not used anymore     *
      *  AR856140 - DLC0601B fails in CoB because of deal amendments  *
      *             report shows file out of balance. Replaced hash   *
      *             totaling subroutine.                              *
      *           - Applied for MD037057                              *
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
                                                                                            MD037057
     D @@NINT          S             15P 0                                                  MD037057
     D @@NDEC          S              3P 0                                                  MD037057
      *                                                                                     AR856140
      ** Subprocedures Prototypes                                                           AR856140
      *                                                                                     AR856140
     D HashTotal       PR                                                                   AR856140
     D MergeNum        PR            18S 0                                                  AR856140
     D  FNum                         15S 0 Value                                            AR856140
     D  LNum                          3S 0 Value                                            AR856140
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
     C**********         EXSR      HASHTO                                                   AR856140
     C                   CallP     HashTotal                                                AR856140
      *
     C                   Z-ADD     @@NINT        VRIF
     C                   Z-ADD     @@NDEC        VRIL
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VIPF          @@OINT                         136431
     C                   Z-ADD     VIPL          @@ODEC                         136431
      *                                                                         136431
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
      *                                                                         136431
     C                   Z-ADD     @@NINT        VIPF                           136431
     C                   Z-ADD     @@NDEC        VIPL                           136431
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VLAF          @@OINT
     C                   Z-ADD     VLAL          @@ODEC
      *
     C**********         EXSR      HASHTO                                                   AR856140
     C                   CallP     HashTotal                                                AR856140
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
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
      *                                                                         136431
     C                   Z-ADD     @@NINT        VRIF                           136431
     C                   Z-ADD     @@NDEC        VRIL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VDPF          @@OINT                         136431
     C                   Z-ADD     VDPL          @@ODEC                         136431
      *                                                                         136431
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
      *                                                                         136431
     C                   Z-ADD     @@NINT        VDPF                           136431
     C                   Z-ADD     @@NDEC        VDPL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VLAF          @@OINT                         136431
     C                   Z-ADD     VLAL          @@ODEC                         136431
      *                                                                         136431
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
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
     C**********         EXSR      HASHTO                                                   AR856140
     C                   CallP     HashTotal                                                AR856140
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
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
      *                                                                         136431
     C                   Z-ADD     @@NINT        VIPF                           136431
     C                   Z-ADD     @@NDEC        VIPL                           136431
      *
      ** ADD INTEGER & DECIMAL TO HASH TOTALS
      *
     C                   Z-ADD     VLAF          @@OINT           15 0
     C                   Z-ADD     VLAL          @@ODEC            3 0
      *
     C**********         EXSR      HASHTO                                                   AR856140
     C                   CallP     HashTotal                                                AR856140
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
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
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
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
      *                                                                         136431
     C                   Z-ADD     @@NINT        VDPF                           136431
     C                   Z-ADD     @@NDEC        VDPL                           136431
      *                                                                         136431
      ** ADD INTEGER & DECIMAL TO HASH TOTALS                                   136431
      *                                                                         136431
     C                   Z-ADD     VLAF          @@OINT           15 0          136431
     C                   Z-ADD     VLAL          @@ODEC            3 0          136431
      *                                                                         136431
     C**********         EXSR      HASHTO                                            136431 AR856140
     C                   CallP     HashTotal                                                AR856140
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
    C**HASHTO*-**HASH*TOTALLING**************************************                       MD037057
     C*                                                              *
     C****************************************************************
     C*****HASHTO        BEGSR                                                              MD037057
      **********                                                                            MD037057
     C****Initialise*output*field*with*input*field********************                      MD037057
      **********                                                                            MD037057
     C**********         Z-ADD     @@OINT        @@NINT           15 0                      MD037057
      **********                                                                            MD037057
     C***Ensure*that*the*decimal*has*the*same*sign*as*the*integer*****                      MD037057
     C***(On*file*the*decimal*already*has*a*sign)*********************                      MD037057
      **********                                                                            MD037057
     C*****@@AINT        IFLT      *ZERO                                                    MD037057
     C*****@@ADEC        ANDGT     *ZERO                                                    MD037057
     C**********         Z-SUB     @@ADEC        @@ADEC                                     MD037057
     C**********         END                                                                MD037057
      **********                                                                            MD037057
      ****Decimals                                                                          MD037057
      ****--------                                                                          MD037057
     C****Add*the*decimals*to*the*old*total***************************                      MD037057
      **********                                                                            MD037057
     C*****@@ADEC        ADD       @@ODEC        @TOTDC            4 0                      MD037057
      **********                                                                            MD037057
     C****Monitor*for*overflow*(eg.*-15*+*-990*=*-1005)***************                      MD037057
      **********                                                                            MD037057
     C*****@TOTDC        IFLT      -999                                                     MD037057
     C**********         SUB       1             @@NINT                                     MD037057
     C**********         END                                                                MD037057
      **********                                                                            MD037057
     C****Monitor*for*overflow*(eg.*15*+*990*=*1005)******************                      MD037057
      **********                                                                            MD037057
     C*****@TOTDC        IFGT      999                                                      MD037057
     C**********         ADD       1             @@NINT                                     MD037057
     C**********         END                                                                MD037057
      **********                                                                            MD037057
      ****Integers                                                                          MD037057
      ****--------                                                                          MD037057
     C****Add*the*integers*to*the*overflow*corrected*old*total********                      MD037057
      **********                                                                            MD037057
     C**********         ADD       @@AINT        @@NINT                                     MD037057
      **********                                                                            MD037057
     C****COMPENSATE*FOR*THE*DECIMALS*GOING*UNDER*0*******************                      MD037057
      **********                                                                            MD037057
     C*****@@ODEC        IFGE      0                                                        MD037057
     C*****@@NINT        ANDGT     0                                                        MD037057
     C*****@TOTDC        ANDLT     0                                                        MD037057
     C**********         SUB       1             @@NINT                                     MD037057
     C**********         ADD       1000          @TOTDC                                     MD037057
     C**********         END                                                                MD037057
     C*****@@ODEC        IFLT      0                                                        MD037057
     C*****@@NINT        ANDLT     0                                                        MD037057
     C*****@TOTDC        ANDGE     0                                                        MD037057
     C**********         ADD       1             @@NINT                                     MD037057
     C**********         SUB       1000          @TOTDC                                     MD037057
     C**********         END                                                                MD037057
     C**********                                                                            MD037057
     C**********         MOVE      @TOTDC        @@NDEC            3 0                      MD037057
     C**********                                                                            MD037057
     C**********         ENDSR                                                              MD037057
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
     P HashTotal       B                                                                    AR856140
     D HashTotal       PI                                                                   AR856140
      ** Data Structure for use with hash totalling                                         AR856140
     D                 DS                  Inz                                              AR856140
     D  HashTot                1     18S 0                                                  AR856140
     D  HashFTot               1     15S 0                                                  AR856140
     D  HashLTot              16     18S 0                                                  AR856140
      *                                                                                     AR856140
      ** Merge first and last part of numbers                                               AR856140
      ** Separate the total to @@NINT and @@NDEC                                            AR856140
      *                                                                                     AR856140
     C                   Eval      HashTot =                                                AR856140
     C                                       MergeNum(@@OINT:@@ODEC)                        AR856140
     C                                       +                                              AR856140
     C                                       MergeNum(@@AINT:@@ADEC)                        AR856140
                                                                                            AR856140
     C                   If        HashTot < 0                                              AR856140
     C                   Eval      @@NINT = 0 - %ABS(HashFTot)                              AR856140
     C                   Eval      @@NDEC = 0 - %ABS(HashLTot)                              AR856140
     C                   Else                                                               AR856140
     C                   Eval      @@NINT = HashFTot                                        AR856140
     C                   Eval      @@NDEC = HashLTot                                        AR856140
     C                   EndIf                                                              AR856140
                                                                                            AR856140
     P                 E                                                                    AR856140
                                                                                            AR856140
     P MergeNum        B                                                                    AR856140
     D MergeNum        PI            18S 0                                                  AR856140
     D  FNum                         15S 0 Value                                            AR856140
     D  LNum                          3S 0 Value                                            AR856140
                                                                                            AR856140
     D MergedNum       S             18S 0 Inz                                              AR856140
      *                                                                                     AR856140
      ** Merge the numeric parts by adding them                                             AR856140
      ** Retain original numeric sign                                                       AR856140
      *                                                                                     AR856140
     C                   Eval      MergedNum = %ABS(FNum) * 1000                            AR856140
     C                                         + %ABS(LNum)                                 AR856140
     C                   If        FNum < 0                                                 AR856140
     C                   Eval      MergedNum = 0 - MergedNum                                AR856140
     C                   EndIf                                                              AR856140
                                                                                            AR856140
     C                   Return    MergedNum                                                AR856140
     P                 E                                                                    AR856140

