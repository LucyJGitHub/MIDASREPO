     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validation of link ref. for fiduciary')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVLINKFID - MM Validation of Link Reference for Fiduciary   *
      *                                                               *
      *  Function:  This module is called from MMLDNIVAL to perform   *
      *             additional validation of 'Linked Reference' field *
      *             for fiduciary deals.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006 *CREATE     Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CDL006 - Dealing fiduciary.                                  *
      *                                                               *
      *****************************************************************
     FMMDELDL2  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
 
      /COPY ZACPYSRC,STD_D_SPEC
      ** Copysource for LDA layout, copyright and named constants
      /EJECT
 
      ** MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      /EJECT
 
      /COPY ZACPYSRC,PSDS
      ** Copysource for program status data structure
      /EJECT
 
      *****************************************************************
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *****************************************************************
 
      ** Linked Reference must be blank for placings
 
     C     PDealType     IFEQ      'FL'
     C     PLinkDeal     ANDNE     *BLANKS
     C     PDealType     OREQ      'LP'
     C     PLinkDeal     ANDNE     *BLANKS
     C     PDealType     OREQ      'DP'
     C     PLinkDeal     ANDNE     *BLANKS
     C                   MOVE      'MMM9004'     PErrMsgID1
     C                   MOVEL     'Error  '     PReturnCode
     C                   ENDIF
 
      ** Linked Reference must NOT be blank for placings
 
     C     PDealType     IFEQ      'FT'
     C     PLinkDeal     ANDEQ     *BLANKS
     C     PDealType     OREQ      'LT'
     C     PLinkDeal     ANDEQ     *BLANKS
     C     PDealType     OREQ      'DT'
     C     PLinkDeal     ANDEQ     *BLANKS
     C                   MOVE      'MMM9005'     PErrMsgID1
     C                   MOVEL     'Error  '     PReturnCode
     C                   ENDIF
 
      ** Check if fiduciary taking has a corresponding placing, i.e.,
      ** FL for FT, LP for LT, and DP for DT.
 
     C     PDealType     IFEQ      'FT'
     C     PLinkDeal     ANDNE     *BLANKS
     C     PDealType     OREQ      'LT'
     C     PLinkDeal     ANDNE     *BLANKS
     C     PDealType     OREQ      'DT'
     C     PLinkDeal     ANDNE     *BLANKS
 
     C                   MOVE      PLinkDeal     WLinkDeal         6 0
     C     WLinkDeal     CHAIN     MMDELDL2                           10
     C     *IN10         IFEQ      '1'
     C                   MOVE      'MMM9006'     PErrMsgID2
     C                   MOVEL     'Error  '     PReturnCode
     C                   ELSE
     C     PDealType     IFEQ      'FT'
     C     HKTYPE        ANDNE     'FL'
     C     PDealType     OREQ      'LT'
     C     HKTYPE        ANDNE     'LP'
     C     PDealType     OREQ      'DT'
     C     HKTYPE        ANDNE     'DP'
     C                   MOVE      'MMM9007'     PErrMsgID2
     C                   MOVEL     'Error  '     PReturnCode
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
     C****************************************************************
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
 
      ** Program parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PDealType         2
     C                   PARM                    PLinkDeal         6
     C                   PARM                    PReturnCode       7
     C                   PARM                    PErrMsgID1        7
     C                   PARM                    PErrMsgID2        7
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR   - Subroutine for exception errors                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   MOVEL     'PMPFDMUPD'   DBPGM
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   IF        RunBefore <> 'Y'
 
     C                   EVAL      RunBefore = 'Y'
 
      ** Load the APDUMP fields
 
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP
     C                   DUMP
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
