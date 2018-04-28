     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits Display Warnings')             *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIWRN - MM Loans/Deposits Display Warnings module        *
      *                                                               *
      *  Function:  This module processes warnings if a fiduciary     *
      *             transaction is selected for deletion.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 BUG10718           Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10677           Date 23Feb06               *
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
      *                 CDL006 *Create     Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG10718 - Deletion of Fiduciary Placing Associated Takings  *
      *             not deleted, no warning message.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10677-Do not need to import CDL006 as it is switched on   *
      *           if this module is called and the deal types in the  *
      *           conditioned code are only available if CDL006=Y     *
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
     FMMDELDL3  IF   E           K DISK    INFSR(*PSSR)
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D Ix              S              3P 0
      ** Index for arrays
 
     D*****CDL006          S              1A   IMPORT                                       BUG10677
 
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      *****************************************************************
 
     C*****CDL006        IFEQ      'Y'                                                      BUG10677
 
      ** Read file to access all related taking deals of the fiduciary
      ** placing deal.
 
     C     PDealType     IFEQ      'FL'
     C     PDealType     OREQ      'LP'
     C     PDealType     OREQ      'DP'
 
     C                   MOVE      PDealNo       WDLNO             6 0
     C     WDLNO         SETLL     MMDELDL3
     C     WDLNO         READE     MMDELDL3                               60
     C     *IN60         DOWEQ     *OFF
     C     HKDDLT        IFNE      'D'
     C     HKDSTS        ANDEQ     'C'
     C     HKDDLT        ORNE      'D'
     C     HKDSTS        ANDEQ     'A'
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      WFldNamArr(Ix)
     C**********         MOVEL     'MMM9008'     WMsgIdArr(Ix)                              BUG10718
     C                   MOVEL     'MMM9045'     WMsgIdArr(Ix)                              BUG10718
     C                   MOVEL     HKDN38        WMsgDtaArr(Ix)
     C                   ENDIF
     C     WDLNO         READE     MMDELDL3                               60
     C                   ENDDO
 
     C                   ENDIF
 
      ** A Fiduciary taking deal should have a new matching Fiduciary
      ** placing deal.
 
     C     PDealType     IFEQ      'FT'
     C     PDealType     OREQ      'LT'
     C     PDealType     OREQ      'DT'
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      WFldNamArr(Ix)
     C                   MOVEL     'MMM9009'     WMsgIdArr(Ix)
     C                   ENDIF
 
     C**********         ENDIF                                                              BUG10677
 
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
     C                   PARM                    PDealNo           6
     C                   PARM                    PDealType         2
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Ix
 
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
