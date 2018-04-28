     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Calculate Effective Offset')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  SD001008 - Midas SD Calculate Effective Offset               *
      *                                                               *
      *  Function:  This program will calculate the effective         *
      *             offset for a time zone on a specific date.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG21289           Date 13Oct08               *
      *  Prev Amend No. BUG20226           Date 15Aug08               *
      *                 BUG19628           Date 29Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG21289 - Various Timezone and DST errors. Applied fix      *
      *             21018                                             *
      *  BUG21018 - Different behaviour for time between FXDN and LDNN*
      *  BUG20226 - Database error occurred during "Copy" mode        *
      *             (Recompile)                                       *
      *  BUG19628  - DST is being switched on even if start time is   *
      *              not yet reached                                  *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Control indicator                               *
      *    U8         Control indicator                               *
      *    LR         Last Record indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR         - Error processing                              *
      * *INZSR        - Initialise                                    *
      * SRRtvHist     - Retrieve sign and offset from Time Zone       *
      *                 History File                                  *
      * SRRtvDetl     - Retrieve sign and offset from Time Zone       *
      *                 and DST file                                  *
      * SRCalcDate    - Calculate DST Start and End date              *
      * SRCalcOff     - Calculate Effective Offset                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDTZLVL2  IF   E           K DISK    RENAME(SDTZLVD0:SDTZLV_S)
      ** Midas SD Time Zone Keyed by Time Zone Level
      *
     FSDTZLVL3  IF   E           K DISK    RENAME(SDTZLVD0:SDTZLV_B)
      ** Midas SD Time Zone Keyed by Time Zone Level and Branch Code
      *
     FSDTIZOL1  IF   E           K DISK
      ** Midas SD Time Zone Keyed by Time Zone Level
      *
     FSDTZLHL2  IF   E           K DISK    RENAME(SDTZLHD0:SDTZLH_S)
      ** Midas SD Time Zone History
      *
     FSDTZLHL3  IF   E           K DISK    RENAME(SDTZLHD0:SDTZLH_B)
      ** Midas SD Time Zone History
      *
     FSDTZLHL4  IF   E           K DISK    RENAME(SDTZLHD0:SDTZLH_M)
      ** Midas SD Time Zone History
      *
     FSDTIZHL3  IF   E           K DISK
      ** Midas SD Time Zone History
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
     D SDDSTC        E DS                  EXTNAME(SDDSTCPD)
      ** External DS for SDDSTCPD
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for SDBANKPD
      *
     D SDMICP        E DS                  EXTNAME(SDMICCPD)
      ** External DS for SDMICCPD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters
     D PTZLevel        S              1A
     D PTZCode         S             10A
     D PMICCode        S              4A
     D PBrca           S              3A
     D PZone           S             10A
     D PInDate         S              5P 0
     D PEffOffset      S              4A
     D PSign           S              1A
     D PTime           S              6S 0                                                 BUG19628
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PTZYear         S              4A
     D PDst            S             10A
     D @RUN            S              1A
      *
      ** ZM0065 Parameters
     D ZMDAY           S              5P 0
     D ZSDATE          S              6A
     D ZSDATC          S              8A
      *
      ** ZFINDDATE Parameters
     D PInWkDay        S              2A
     D PInWkNum        S              1A
     D PInMonth        S              2A
     D PInYear         S              4A
     D PDateFmt        S              1A
     D POutDate5S      S              5S 0
     D POutDate5E      S              5S 0
     D POutDate8       S              8A
      *
      ** Work variables
     D WEndDate        S              6A
     D WTmpOffset      S              4S 0
     D WTZYear         S              4A
     D WTZYearN        S              4S 0
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D WTmp            S              6A
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D WYear           S              4A
     D WTZRecFnd       S               N    INZ(*OFF)
     D WTizoCode       S                   LIKE(PTZCode) INZ(*Blanks)
     D DSTFlag         S              1A    INZ(*BLANKS)                                   BUG19628
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Perform subroutine to access sign and offset from Time Zone History Hile
      *
     C                   EXSR      SRRtvHist
      *
      ** Perform subroutine to access sign and offset from Time Zone and DST File
      *
     C                   IF        PEffOffset = *Zeros
     C                             OR PInDate > BJRDNB
     C                   EXSR      SRRtvDetl
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvDetl - Retrieve Time Zone File                           *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: SrProcessDST                                           *
      *                                                               *
      *****************************************************************
     C     SRRtvDetl     BEGSR
      *
     C     KTIZO_S       KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    WYear
      *
     C     KTIZO_B       KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PBrca
     C                   KFLD                    WYear
      *
     C                   SELECT
      *
      ** System Level Time Zone Processing
      *
     C                   WHEN      PTZLevel = 'S'
     C                   EVAL      WYear = WTZYear
     C     KTIZO_S       CHAIN     SDTZLVL2
     C                   IF        NOT(%FOUND(SDTZLVL2))
     C                   EVAL      WYear = *BLANKS
     C     KTIZO_S       CHAIN     SDTZLVL2
     C                   IF        %FOUND(SDTZLVL2)
     C                   EVAL      WTizoCode = TLTZCD
     C                   EXSR      srRtvTZDtls
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WTizoCode = TLTZCD
     C                   EXSR      srRtvTZDtls
     C                   ENDIF
      *
      ** Branch Level Time Zone Processing
      *
     C                   WHEN      PTZLevel = 'B'
     C                   EVAL      WYear = WTZYear
     C     KTIZO_B       CHAIN     SDTZLVL3
     C                   IF        NOT(%FOUND(SDTZLVL3))
     C                   EVAL      WYear = *BLANKS
     C     KTIZO_B       CHAIN     SDTZLVL3
     C                   IF        %FOUND(SDTZLVL3)
     C                   EVAL      WTizoCode = TLTZCD
     C                   EXSR      srRtvTZDtls
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WTizoCode = TLTZCD
     C                   EXSR      srRtvTZDtls
     C                   ENDIF
      *
      ** Time Zone Leve Processing
      *
     C                   WHEN      PTZLevel = 'M'
     C                             AND PTZCode <> *Blanks
     C                   EVAL      WTizoCode = PTZCode
     C                   EXSR      srRtvTZDtls
      *
     C                   ENDSL
      *
     C                   IF        WTZRecFnd
     C                   EXSR      SrProcessDST
     C                   ENDIF
     C
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTZDtls - Retrieve record from timezone file              *
      *                                                               *
      * Called by: SRRtvDetl                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvTZDtls   BEGSR
      *
     C     KTIZO         KLIST
     C                   KFLD                    WTizoCode
     C                   KFLD                    WYear
      *
     C                   EVAL      WTZRecFnd = *OFF
     C                   EVAL      WYear = WTZYear
     C     KTIZO         CHAIN     SDTIZOL1
     C                   IF        %FOUND(SDTIZOL1)
     C                   EVAL      WTZRecFnd = *ON
      *
     C                   ELSE
     C                   EVAL      WYear = *BLANKS
     C     KTIZO         CHAIN     SDTIZOL1
     C                   IF        %FOUND(SDTIZOL1)
     C                   EVAL      WTZRecFnd = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcessDST - Process DST Offset                             *
      *                                                               *
      * Called by: SRRtvTizo                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProcessDST  BEGSR
      *
     C                   IF        TZDSTF = 'Y'
      *
      ** Call AODSTCR0 to get DST Details
      *
     C                   CALL      'AODSTCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TZDSTC        PDst
     C                   PARM      WTZYear       PTZYear
     C     SDDSTC        PARM      SDDSTC        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   CALL      'AODSTCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TZDSTC        PDst
     C                   PARM      *BLANKS       PTZYear
     C     SDDSTC        PARM      SDDSTC        DSFDY
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      DSTFlag = 'Y'                                           BUG19628
     C                   SELECT
     C                   WHEN      PInDate >= DSDSDT AND
     C                             PInDate <= DSDSED
     C                   IF        PInDate = DSDSDT AND                                    BUG19628
     C                             PTime  <  DSDSDH                                        BUG19628
     C                   EVAL      DSTFlag = 'N'                                           BUG19628
     C                   ENDIF                                                             BUG19628
     C                   IF        PInDate = DSDSED AND                                    BUG19628
     C                             PTime  >= DSDENH                                        BUG19628
     C                   EVAL      DSTFlag = 'N'                                           BUG19628
     C                   ENDIF                                                             BUG19628
     C                   IF        DSTFlag = 'Y'                                           BUG19628
     C                   EVAL      WOfSt = DSOFFS
     C                   ENDIF                                                             BUG19628
     C                   EXSR      SRCalcOff
     C                   WHEN      PInDate > DSDSED
     C                   EXSR      SrCalcDate
     C                   WHEN      PInDate < DSDSDT
     C                   EVAL      WOfSt = *ZEROS
     C                   EXSR      SRCalcOff
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      WOfSt = *ZEROS
     C                   EXSR      SRCalcOff
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WOfSt = *ZEROS
     C                   EXSR      SRCalcOff
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvHist - Retrieve Time Zone from History File              *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: SRCalcOff                                              *
      *                                                               *
      *****************************************************************
     C     SRRtvHist     BEGSR
      *
     C                   EVAL      PEffOffset = *ZEROS
     C                   EVAL      PSign      = '+'
     C                   SELECT
     C                   WHEN      PTZLevel = 'B'
     C                   EXSR      SRTZLevelB
     C                   WHEN      PTZLevel = 'S'
     C                   EXSR      SRTZLevelS
     C                   WHEN      PTZLevel = 'M'
     C                   EXSR      SRTZLevelM
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcDate - Calculate DST Start and End date                 *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: SRCalcOff                                              *
      *                                                               *
      *****************************************************************
     C     SRCalcDate    BEGSR
      *
      ** Calculate Start Date
      *
     C                   MOVE      DSDSTD        PInWkDay
     C                   MOVE      DSDSTW        PInWkNum
     C                   MOVE      DSDSTM        PInMonth
      *
     C                   CALL      'ZFINDDATE'
     C                   PARM                    PInWkDay
     C                   PARM                    PInWkNum
     C                   PARM                    PInMonth
     C                   PARM      WTZYear       PInYear
     C                   PARM      BJDFIN        PDateFmt
     C                   PARM                    POutDate5S
     C                   PARM                    POutDate8
      *
      ** Calculate End Date
      *
     C                   MOVE      DSDEND        PInWkDay
     C                   MOVE      DSDENW        PInWkNum
     C                   MOVE      DSDENM        PInMonth
      *
      ** If Start Month is greater than End Month, add 1 to Year
      *
     C                   IF        DSDSTM > DSDENM
     C                   MOVE      WTZYear       WTZYearN
     C                   ADD       1             WTZYearN
     C                   MOVE      WTZYearN      PInYear
     C                   ENDIF
      *
     C                   CALL      'ZFINDDATE'
     C                   PARM                    PInWkDay
     C                   PARM                    PInWkNum
     C                   PARM                    PInMonth
     C                   PARM                    PInYear
     C                   PARM      BJDFIN        PDateFmt
     C                   PARM                    POutDate5E
     C                   PARM                    POutDate8
      *
     C                   IF        PInDate >= POutDate5S  AND
     C                             PInDate <= POutDate5E
     C                   EVAL      WOfSt = DSOFFS
     C                   EXSR      SRCalcOff
     C                   ELSE
     C                   EVAL      WOfSt = 0
     C                   EXSR      SRCalcOff
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcOff - Calculate Offset                                  *
      *                                                               *
      * Called by: MAIN Processing, SRRtvHist, SRCalcDate             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCalcOff     BEGSR
      *
      ** Calculate Offset
      *
     C                   EVAL      WTmpOffset = TZGMT
     C                   MOVEL     '000000'      WTmp
     C                   MOVEL     WTmpOffset    WTmp
     C                   EVAL      WTime = %Time(WTmp:*Hms0)
     C                   IF        (TZGMTS = '+')
     C                   ADDDUR    WOfSt:*MN     WTime
     C                   ELSE
     C                   SUBDUR    WOfSt:*MN     WTime
     C                   ENDIF
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)
     C                   MOVEL     WTime1        PEffOffset
     C                   EVAL      PSign = TZGMTS
      *
     C                   ENDSR
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
      *
     C     *ENTRY        PLIST
      *
      ** Time Zone Level Code
      *
     C                   PARM                    PTZLevel
      *
      ** Time Zone Code
      *
     C                   PARM                    PTZCode
      *
      ** MIC Code
      *
     C                   PARM                    PMICCode
      *
      ** Branch Code
      *
     C                   PARM                    PBrca
      *
      ** Zone
      *
     C                   PARM                    PZone
      *
      ** Date
      *
     C                   PARM                    PInDate
      *
      ** Effective Offset
      *
     C                   PARM                    PEffOffset
      *
      ** Offset Sign
      *
     C                   PARM                    PSign
      *                                                                                    BUG19628
      ** Current Time                                                                      BUG19628
      *                                                                                    BUG19628
     C                   PARM                    PTime                                     BUG19628
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine PInDate in Midas Format
      *
      ** Extract Year in CCYYMMDD Format
      *
     C                   CALL      'ZM0065'
     C                   PARM      PInDate       ZMDAY
     C                   PARM                    ZSDATE
     C                   PARM                    ZSDATC
      *
     C                   MOVEL     ZSDATC        WTZYear
      *
      ** Call AOMICCR0 to get Market Identification details
      *
     C                   IF        PTZCode  = *BLANKS  AND
     C                             PTZLevel = 'M'
     C                   CALL      'AOMICCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM                    PMICCode
     C     SDMICP        PARM      SDMICP        DSFDY
 
     C                   IF        (PRtCd  <> *Blanks)
     C                   EVAL      PEffOffset = '0000'
     C                   EVAL      PSign      = '+'
     C                   ELSE
     C                   EVAL      PTZCode = MITZCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTZLevelT - Access Time Zone History For Time Zone Level     *
      *              is Time Zone                                     *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: SRSetHstVal                                            *
      *                                                               *
      *****************************************************************
     C     SRTZLevelM    BEGSR
     C     KHIST_T       KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PMICCode
     C                   KFLD                    PInDate
      *
     C     KHIST_TP      KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PMICCode
      *
     C     KHIST_T       SETGT     SDTZLHL4
     C     KHIST_TP      READPE    SDTZLHL4
     C                   IF        NOT(%EOF(SDTZLHL4))
     C                   EXSR      SRSetHstVal
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTZLevelB - Access Time Zone History For Time Zone Level     *
      *              is Branch Code                                   *
      *                                                               *
      * Called by: MAIN Processing                                    *
      *                                                               *
      * Calls: SRSetHstVal                                            *
      *                                                               *
      *****************************************************************
     C     SRTZLevelB    BEGSR
     C     KHIST_B       KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PBrca
     C                   KFLD                    PInDate
      *
     C     KHIST_BP      KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PBrca
      *
     C     KHIST_B       SETGT     SDTZLHL3
     C     KHIST_BP      READPE    SDTZLHL3
     C                   IF        NOT(%EOF(SDTZLHL3))
     C                   EXSR      SRSetHstVal
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTZLevelS - Access Time Zone History For Time Zone Level     *
      *              is System                                        *
      *                                                               *
      * Called by: SRRtvHist                                          *
      *                                                               *
      * Calls: SRSetHstVal                                            *
      *                                                               *
      *****************************************************************
     C     SRTZLevelS    BEGSR
      *
     C     KHIST_S       KLIST
     C                   KFLD                    PTZLevel
     C                   KFLD                    PInDate
      *
     C     KHIST_SP      KLIST
     C                   KFLD                    PTZLevel
      *
     C     KHIST_S       SETGT     SDTZLHL2
     C     KHIST_SP      READPE    SDTZLHL2
     C                   IF        NOT(%EOF(SDTZLHL2))
     C                   EXSR      SRSetHstVal
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetHstVal - Set value based on record from history file     *
      *                                                               *
      * Called by: SRTZLevelT, SRTZLevelB, SRTZLevelS                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSetHstVal   BEGSR
      *
     C     KHIST         KLIST
     C                   KFLD                    TVTZCD
     C                   KFLD                    PInDate
      *
     C     KHISTP        KLIST
     C                   KFLD                    TVTZCD
      *
     C     KHIST         SETGT     SDTIZHL3
     C     KHISTP        READPE    SDTIZHL3
     C                   IF        NOT(%EOF(SDTIZHL3))
     C                   DOW       NOT(%EOF(SDTIZHL3))                                      BUG21018
     C                   IF        THYEAR = WTZYear                                         BUG21018
     C                   MOVE      THEFFO        PEffOffset
     C                   EVAL      PSign      = THEFFS
     C                   LEAVE                                                              BUG21018
     C                   ENDIF                                                              BUG21018
     C     KHISTP        READPE    SDTIZHL3                                                 BUG21018
     C                   ENDDO                                                              BUG21018
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
