     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validation of Customer for Fiduciary deal')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVCUSTFID - MM Validation of Customer for Fiduciary Deals   *
      *                                                               *
      *  Function:  This module performs additional validation of     *
      *             'Customer' field for Fiduciary transactions.      *
      *             Customer must have a valid Trust Agreement in     *
      *             place for takings.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG1069            Date 28Feb06               *
      *                 BUG1069            Date 25Feb06               *
      *                 BUG10675           Date 24Feb06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006   *CREATE   Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10697 - Add condition when checking customer details for  *
      *             deal types LP, LT and FT (Reopen)                 *
      *  BUG10697 - Deal types LP and LT are only allowed with        *
      *             Non-Bank Clients                                  *
      *  BUG10675 - Added deal type DP when checking fudiciary deal   *
      *             for non-bank                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL006 - Dealing fiduciary.                                  *
      *                                                               *
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      /EJECT
 
      *****************************************************************
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for customer details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D CDL006          S              1A   IMPORT
 
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *****************************************************************
 
      ** A Fiduciary Trust Agreement Status 'Not Received' or 'Incomplete'
 
     C     PDealType     IFEQ      'FT'
     C     PDealType     OREQ      'LT'
     C     PDealType     OREQ      'DT'
     C     BBTRAS        IFNE      '3'
     C     BBTRAS        ANDNE     '4'
     C                   MOVEL     'MMM9010'     PWMsgID1
     C                   ENDIF
     C                   ENDIF
 
      ** Customer must be a bank for FL
 
     C     PDealType     IFEQ      'FL'
     C     BBBNBI        ANDNE     'Y'
     C                   MOVEL     'MMM9011'     PErrMsgID1
     C                   MOVEL     'Error  '     PReturnCode
     C                   ENDIF
 
      ** Customer must be a bank for DP                                                     BUG10675
                                                                                            BUG10675
     C                   If        PDealType = 'DP'                                         BUG10675
     C                             And BBBNBI <> 'Y'                                        BUG10675
     C                   Eval      PErrMsgID1  = 'MMM9043'                                  BUG10675
     C                   Eval      PReturnCode = 'Error  '                                  BUG10675
     C                   EndIf                                                              BUG10675
                                                                                            BUG10675
      ***Customer*must*be*a*Nonbank*for*FL*****************************                     BUG10697
      ** Customer must be a Nonbank for FT, LP and LT                                       BUG10697
 
     C     PDealType     IFEQ      'FT'
     C     BBBNBI        ANDEQ     'Y'                                                      BUG10697
     C     PDealType     OREQ      'LP'                                                     BUG10697
     C     BBBNBI        ANDEQ     'Y'                                                      BUG10697
     C     PDealType     OREQ      'LT'                                                     BUG10697
     C     BBBNBI        ANDEQ     'Y'
     C**********         MOVEL     'MMM9012'     PErrMsgID2                                 BUG10697
     C                   MOVEL     'MMM9044'     PErrMsgID2                                 BUG10697
     C                   MOVEL     'Error  '     PReturnCode
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
     C                   PARM                    PCustNo           6 0
     C                   PARM                    SDCUST
     C                   PARM                    PReturnCode       7
     C                   PARM                    PErrMsgID1        7
     C                   PARM                    PErrMsgID2        7
     C                   PARM                    PWMsgID1          7
 
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
