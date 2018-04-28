     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA DEAMS Record Linkages Update')                *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZADMLINKUD - DEAL AMENDMENT RECORD LINKAGES UPDATE           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
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
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 158027             Date 29Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL008 - Continuous Linked Settlement (recompile DEALSDB)    *
      *  158027 - Correct update of next deal amend number            *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDELULL  UF   E           K DISK    INFDS(@FDS)
     F                                     COMMIT
     F                                     INCLUDE(DEALSDCF: DEALSDDF)
     FMMDEMULL  UF   E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEAMSDIF:DEAMSDJF)
 
      ** DEFINE FIELDS
     D IGDA38          S              6S 0
     D IGDVSD          S              5P 0
     D IGDS38          S              3S 0
      *
      **  Information data structure for MMDELULL
     D @FDS            DS
     D  ##FORM           *RECORD
     C*****************************************************************
      *
      * PROCESS DEAL AMENDMENT RECORD LINKAGES ON INSERT
      *
     C     IGCHTP        IFEQ      'I'
     C                   EXSR      DALINS
     C                   END
      *
      * PROCESS DEAL AMENDMENT RECORD LINKAGES ON REVERSAL
      *
     C     IGCHTP        IFEQ      'R'
     C                   EXSR      DALREV
     C                   END
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DALINS - PROCESS DEAL AMENDMENT RECORD LINKAGES ON INSERT     *
      *                                                               *
      *****************************************************************
     C     DALINS        BEGSR
      *
      ** Initialize output fields
      *
     C                   Z-ADD     *ZERO         @@NAAD
     C                   Z-ADD     *ZERO         @@NASN
      *
      ** Access the related deal from DEALSDC or DEALSDD.
      *
     C                   Z-ADD     IGDA38        DLNO
     C     DLNO          CHAIN     MMDELULL                           99
      *
      * ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
      *
      ** Deal amendment value date on deal record is zero.
      *
     C     DAVD          IFEQ      *ZERO
     C                   Z-ADD     *ZERO         @@NAAD
     C                   Z-ADD     *ZERO         @@NASN
     C                   Z-ADD     IGDVSD        W#VDAT
     C                   Z-ADD     IGDS38        W#DASN
     C                   EXSR      UPDDEL
     C                   GOTO      EDAINS
     C                   END
      *
      ** Deal amendment value date on deal record is non-zero,
      ** and greater than the input value date.
      *
     C     DAVD          IFGT      IGDVSD
     C                   Z-ADD     DAVD          @@NAAD
     C                   Z-ADD     DASN          @@NASN
     C                   Z-ADD     IGDVSD        W#VDAT
     C                   Z-ADD     IGDS38        W#DASN
     C                   EXSR      UPDDEL
     C                   GOTO      EDAINS
     C                   END
      *
      ** Deal amendment value date on deal record is non-zero,
      ** and less than or equal to the input value date.
      *
      * Set up DEAMSDI key.
      * -------------------
      *
     C                   Z-ADD     DAVD          VDAT
     C                   Z-ADD     DASN          DASN
      *
      * LOOP THROUGH DEAL AMENDMENTS
      *
     C     NAAD          DOUEQ     *ZERO
     C     NAAD          ORGT      IGDVSD
      *
     C     DEAMK         CHAIN     DEAMSDIF                           99
      *
      * ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
      *
     C     NAAD          IFNE      *ZERO
     C     NAAD          ANDLE     IGDVSD
     C                   MOVE      NAAD          VDAT
     C                   Z-ADD     NASN          DASN
     C                   END
     C                   END
      *
      ** Next amendment action date on DEAMSDI record is zero.
      *
     C     NAAD          IFEQ      *ZERO
     C                   Z-ADD     *ZERO         @@NAAD
     C                   Z-ADD     *ZERO         @@NASN
     C                   Z-ADD     VDAT          W#VDAT
     C                   Z-ADD     DASN          W#DASN
     C                   Z-ADD     IGDVSD        W#NAAD            5 0
     C                   Z-ADD     IGDS38        W#NASN            3 0
     C                   EXSR      UPDDEM
     C                   GOTO      EDAINS
     C                   END
      *
      ** Next amendment action date on DEAMSDI record is greater
      ** than the input value date.
      *
     C     NAAD          IFGT      IGDVSD
     C                   Z-ADD     NAAD          @@NAAD
     C                   Z-ADD     NASN          @@NASN
     C                   Z-ADD     VDAT          W#VDAT
     C                   Z-ADD     DASN          W#DASN
     C                   Z-ADD     IGDVSD        W#NAAD
     C                   Z-ADD     IGDS38        W#NASN
     C                   EXSR      UPDDEM
     C                   END
      *
     C     EDAINS        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDDEM - UPDATE DEAMSDI                                       *
      *                                                               *
      *****************************************************************
     C     UPDDEM        BEGSR
      *
      ** Set up key to DEAMSDI
      *
     C                   Z-ADD     W#VDAT        VDAT
     C                   Z-ADD     W#DASN        DASN
      *
      * ACCESS DEAMSDI
      *
     C     DEAMK         CHAIN     DEAMSDIF                           99
      *
      * ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
      *
      * UPDATE DEAMSDI
      *
     C                   Z-ADD     W#NAAD        NAAD
     C                   Z-ADD     W#NASN        NASN
      *
     C                   UPDATE    DEAMSDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDDEL - UPDATE DEALSDC OR DEALSDD                            *
      *                                                               *
      *****************************************************************
     C     UPDDEL        BEGSR
      *
     C                   Z-ADD     W#VDAT        DAVD
     C                   Z-ADD     W#DASN        DASN
      *
     C     IGMTYP        IFEQ      'SI'
     C     IGMTYP        OREQ      'CI'
     C                   BITON     '5'           DNSI
     C                   END
      *
     C                   BITOFF    '1'           CNFI
     C     NIDT          IFNE      *ZERO
     C     IGDVSD        ANDLE     NIDT
     C                   BITOFF    '2'           CNFI
     C                   END
      *
      * UPDATE DEALSDC OR DEALSDD
      *
     C     ##FORM        IFEQ      'DEALSDCF'
     C                   UPDATE    DEALSDCF
     C                   ELSE
     C                   UPDATE    DEALSDDF
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DALINS - PROCESS DEAL AMENDMENT RECORD LINKAGES ON REVERSAL   *
      *                                                               *
      *****************************************************************
     C     DALREV        BEGSR
      *
      ** Get the related deal
      *
     C                   Z-ADD     IGDA38        DLNO
     C     DLNO          CHAIN     MMDELULL                           99
      *
      * ERROR
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
      *
      ** Position deal amendment file to first live amendment record
      *
     C                   MOVE      DAVD          VDAT
     C                   MOVE      DASN          DASN
     C     DEAMK         CHAIN     DEAMSDIF                           99
      *
      * ERROR
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
      *
      ** Update deals file record
      *
     C     IGDVSD        IFEQ      DAVD
     C     IGDS38        ANDEQ     DASN
      *
     C                   Z-ADD     @@TAAD        DAVD
     C                   Z-ADD     @@TASN        DASN
      *
      * UPDATE DEALSDC OR DEALSDD
      *
     C     ##FORM        IFEQ      'DEALSDCF'
     C                   EXCEPT    UDEALSDC
     C                   ELSE
     C                   EXCEPT    UDEALSDD
     C                   END
      *
     C                   GOTO      EDALRE
     C                   END
      *
      ** Update Previous Deal Amendment to Point to next live deal
      *
     C                   MOVE      IGDVSD        W#VDAT            5 0
     C                   MOVE      IGDS38        W#DASN            3 0
     C*****W#VDAT        DOWNE     NAAD                                         158027
     C*****W#DASN        ORNE      NASN                                         158027
     C     IGDVSD        DOWNE     NAAD                                         158027
     C     IGDS38        ORNE      NASN                                         158027
     C                   MOVE      NAAD          W#VDAT
     C                   MOVE      NASN          W#DASN
     C     DEAMKX        CHAIN     DEAMSDIF                           99
      *
      * ERROR
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*ERROR'      @@RTCD
     C                   RETURN
     C                   END
     C                   END
      *
     C                   Z-ADD     @@TAAD        NAAD
     C                   Z-ADD     @@TASN        NASN
     C                   UPDATE    DEAMSDIF
      *
     C     EDALRE        ENDSR
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
     C                   PARM                    @@RTCD            7
     C                   PARM                    IGCHTP            1
     C                   PARM                    IGDA38
     C                   PARM                    IGDVSD
     C                   PARM                    IGDS38
     C                   PARM                    IGMTYP            2
     C                   PARM                    @@TAAD            5 0
     C                   PARM                    @@TASN            3 0
      *
      ** OUTPUT
      *
     C                   PARM                    @@NAAD            5 0
     C                   PARM                    @@NASN            3 0
      *
      * KEY LISTS
      *
     C     DEAMK         KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    VDAT
     C                   KFLD                    DASN
      *
     C     DEAMKX        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    W#VDAT
     C                   KFLD                    W#DASN
      *
     C                   ENDSR
      *****************************************************************
     ODEALSDCF  E            UDEALSDC
     O                       DAVD
     O                       DASN
     ODEALSDDF  E            UDEALSDD
     O                       DAVD
     O                       DASN
