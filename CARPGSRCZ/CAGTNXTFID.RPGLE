     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CA Next fiduciary deal number module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  CAGTNXTFID - MM Next Fiduciary Deal Number Module            *
      *                                                               *
      *  Function:  This module gets the next fiduciary deal number.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FSDDLNOL0  UF   E           K DISK    INFSR(*PSSR) COMMIT
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D FKDN38          S              6S 0
      ** Redefine external field as a Zoned decimal to prevent errors
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External data structure for deal details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** First DS for Access Programs, Short Data Structure
 
      *****************************************************************
      *                                                               *
      *    Main Routine                                               *
      *                                                               *
      *****************************************************************
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE                          ************
     C                   MOVEL     'SDDEALPD'    DBFILE                         * DBERR 01 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     DEALTYPE      IFEQ      'FL'
     C     BNDNRP        ANDNE     0
     C     DEALTYPE      OREQ      'DP'
     C     BNDNRP        ANDNE     0
     C     DEALTYPE      OREQ      'LP'
     C     BNDNRP        ANDNE     0
     C     DEALTYPE      OREQ      'FT'
     C     BNDNRT        ANDNE     0
     C     DEALTYPE      OREQ      'DT'
     C     BNDNRT        ANDNE     0
     C     DEALTYPE      OREQ      'LT'
     C     BNDNRT        ANDNE     0
 
      ** Access file to retrieve next available deal number
 
     C                   MOVE      *BLANKS       WBNDNR            2
     C                   MOVE      BNDNRP        WBNDNRP          16
     C                   MOVE      BNDNRT        WBNDNRT          16
 
     C     DEALTYPE      IFEQ      'FL'
     C     DEALTYPE      OREQ      'DP'
     C     DEALTYPE      OREQ      'LP'
     C                   CALLB     'ZEDIT'
     C                   PARM      WBNDNRP       ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   MOVE      ZFIELD        WBNDNR
     C                   ELSE
     C                   CALLB     'ZEDIT'
     C                   PARM      WBNDNRT       ZFIELD
     C                   PARM      0             ZADEC
     C                   MOVE      ZFIELD        WBNDNR
     C                   ENDIF
 
     C     WBNDNR        CHAIN     SDDLNOL0                           22
 
     C     *IN22         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     002           DBASE                          ************
     C                   MOVEL     'SDDLNOL0'    DBFILE                         * DBERR 02 *
                                                                                ************
     C     DEALTYPE      IFEQ      'FL'
     C     DEALTYPE      OREQ      'DP'
     C     DEALTYPE      OREQ      'LP'
     C                   MOVEL     BNDNRP        DBKEY
     C                   ELSE
     C                   MOVEL     BNDNRT        DBKEY
     C                   ENDIF
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     ARNADN        CHAIN     DEALSALL                           23
     C     *IN23         DOWEQ     *OFF
     C                   ADD       1             ARNADN
     C     ARNADN        CHAIN     DEALSALL                           23
     C                   ENDDO
 
     C                   MOVE      ARNADN        DEALNO
     C                   ADD       1             ARNADN
     C                   UPDATE    @ARREC2
 
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RETCODEIN        10
     C                   PARM      *BLANKS       #MSGID
     C                   PARM      *BLANKS       DDDLNO            6
     C                   PARM      0             FKDN38
 
     C                   MOVE      FKDN38        DEALNO
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR : Entry Parameters                                     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    DEALTYPE          2
     C                   PARM                    DEALNO            6 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
