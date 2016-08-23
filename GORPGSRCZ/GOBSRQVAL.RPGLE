     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas GO BSPL Request Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQVAL - BSPL Request Validation                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FI_GRBRCHG1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCOMPL0IF   E           K DISK    INFSR(*PSSR)
 
     FSDRPSTL0  IF   E           K DISK    INFSR(*PSSR)
     FI_GRBSPLH1IF   E           K DISK    INFSR(*PSSR)
 
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)
 
     FFCSOUTL0  IF   E           K DISK    INFSR(*PSSR)
 
 
     D ZSFRQ           S              1    DIM(7) CTDATA PERRCD(7)
 
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
 
      ** Message data
     D #MsgData        S             45A
      ** Message ID
     D #MsgID          S              7A
 
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** CAS014 variables                                                                     CAS014
     D CAS014          S              1A                                                      CAS014
     D PRTCD           S              7                                                       CAS014
     D POPTN           S              7                                                       CAS014
     D PSARD           S              6                                                       CAS014
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
 
      * BSPL Request - Screen Format
     D GOBSRQ        E DS                  EXTNAME(GOBSRQPD)
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
 
      ** Switchable Feature descriptions                                                      CAS014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS014
                                                                                              CAS014
     D LDA           E DS           256    EXTNAME(LDA)                                       CAS014
      *                                                                                       CAS014
      ** Local data area for database error details                                           CAS014
      ** *LOCK IN LDA immediately before and OUT LDA immediately                              CAS014
      ** after each database error handling.                                                  CAS014
      **                                                                                      CAS014
      **                                    134 141 DBFILE                                    CAS014
      **       Defines:                     142 170 DBKEY                                     CAS014
      **                                    171 180 DBPGM                                     CAS014
      **                                    181 1830DBASE                                     CAS014
      *                                                                                       CAS014
 
      * Validate Zone/Global Indicator
 
     C                   EXSR      V_ZONEGLOB
 
      * Validate Zone to Run Report
 
     C                   EXSR      V_ZONE
 
      * Validate Branch Details
 
     C                   EXSR      V_BRANCHDETAIL
 
      * Validate BSPL Report Set/Hierarchy
 
     C                   EXSR      V_BSPLRPSET
 
      * Validate Hierarchy Depth
 
     C                   EXSR      V_HIERDEPTH
 
      * Validate Chart of Accounts
 
     C                   EXSR      V_CHART
 
      * Validate Relative Period Number
 
     C     DDRQTYP       IFEQ      'S'
     C                   EXSR      V_RELPERDNO
     C                   ENDIF
 
      * Validate Calendar Year and Month
 
     C     DDRQTYP       IFEQ      'I'
     C                   EXSR      V_CALYRMTH
     C                   ENDIF
 
      * Validate Report Type
 
     C                   EXSR      V_REPORTTYP
 
      * Validate Report Movement Duration
 
     C                   EXSR      V_REPMOVEDUR
 
      * Validate Interim Currency Details
 
     C                   EXSR      V_INTCCYDETLS
 
      * Validate Report Currency Details
 
     C                   EXSR      V_REPCCYDETLS
 
      * Validate A/c Code Breakdown
 
     C                   EXSR      V_ACCODEBRK
 
      * Validate Print Zero Balances
 
     C                   EXSR      V_PRINTZEROB
 
      * Validate Rounding
 
     C                   EXSR      V_ROUNDING
 
      * Validate A/c Code Breakdown
 
     C                   EXSR      V_ACCODEBRK
 
      * Validate Include For. Ccy Transfer and Include Base Ccy Transfer
 
     C                   EXSR      V_INCTRANSFERS
 
      * Validate Instruction ID
 
     C                   EXSR      V_INSID
 
      * Validate Description
 
     C     DDRQTYP       IFEQ      'S'
     C                   EXSR      V_DESC
     C                   ENDIF
 
      * Validate Export
 
     C                   EXSR      V_EXPORT
 
      * Validate Report Frequency
 
     C     DDRQTYP       IFEQ      'S'
     C                   EXSR      V_RFREQ
     C                   ENDIF
 
      * Validate Report Day Number
 
     C     DDRQTYP       IFEQ      'S'
     C                   EXSR      V_RDAYN
     C                   ENDIF
 
      * Validate (Next) Report Date
 
     C     DDRQTYP       IFEQ      'S'
     C                   EXSR      V_RDATE
     C                   ENDIF
 
     C     CAS014        IFEQ      'Y'                                                        CAS014
                                                                                              CAS014
      ** Retrieve Interim Conversion of I/E Using Average Rates                               CAS014
                                                                                              CAS014
     C                   MOVEL     DDINCAV       SCINCAV                                      CAS014
                                                                                              CAS014
      ** Retrieve Interim Average Rate Period                                                 CAS014
                                                                                              CAS014
     C                   MOVEL     DDINAPD       SCINAPD                                      CAS014
                                                                                              CAS014
      ** Retrieve Interim Average Period End                                                  CAS014
                                                                                              CAS014
     C                   MOVEL     DDINAPE       SCINAPE                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Conversion of I/E Using Average Rate                              CAS014
                                                                                              CAS014
     C                   MOVEL     DDRPCAV       SCRPCAV                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Average Rate Period                                               CAS014
                                                                                              CAS014
     C                   MOVEL     DDRPAPD       SCRPAPD                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Average Period End                                                CAS014
                                                                                              CAS014
     C                   MOVEL     DDRPAPE       SCRPAPE                                      CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Zone/Global Indicator
      ********************************************************************
     C     V_ZONEGLOB    BEGSR
 
      * 'The BSPL reporting must be Zone (Z) or Global (G)'
 
     C     DDZNGL        IFNE      'Z'
     C     DDZNGL        ANDNE     'G'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDZNGL  '    FldNameArr(Ix)
     C                   MOVEL     'GO00510'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDZNGL        SCZNGL
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Zone to Run Report
      ********************************************************************
     C     V_ZONE        BEGSR
 
      * 'The Zone is not valid'
 
     C     DDZONE        CHAIN     GPZONED0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDZONE  '    FldNameArr(Ix)
     C                   MOVEL     'GO00511'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDZONE        SCZONE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Branch Details
      ********************************************************************
     C     V_BRANCHDETAILBEGSR
 
      * 'Either Branch Code or Branch Group can be specified, not both'
 
     C     DDBRC         IFNE      *BLANK
     C     DDBRGRP       ANDNE     *BLANK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRC   '    FldNameArr(Ix)
     C                   MOVEL     'GO00512'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Invalid Branch'
 
     C     DDBRC         IFNE      *BLANK
     C     DDBRC         CHAIN     SDBRCHD0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRC   '    FldNameArr(Ix)
     C                   MOVEL     'GO00513'     MsgIDArr(Ix)
     C                   ELSE
 
      * 'For zone reporting, the branch must be a branch in the zone'
 
     C     DDZNGL        IFEQ      'Z'
     C     DDZONE        ANDNE     A8ZONE
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRC   '    FldNameArr(Ix)
     C                   MOVEL     'GO00514'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Validate Branch Group
 
     C     DDBRGRP       IFNE      *BLANK
 
     C                   EVAL      DDBRGRP = %TRIM(DDBRGRP)
 
     C                   SELECT
      * ZONE
      * 'Invalid Branch Group (Company)'
 
     C     DDZNGL        WHENEQ    'Z'
     C                   MOVEL     DDBRGRP       Company           3
     C     Company       CHAIN     SDCOMPD0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRGRP '    FldNameArr(Ix)
     C                   MOVEL     'GO00515'     MsgIDArr(Ix)
     C                   ENDIF
      * GLOBAL
      * 'Invalid Branch Group'
 
     C     DDZNGL        WHENEQ    'G'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBRGRP       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        BGID
     C     BGID          CHAIN     I_GRBRCHG1                         99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRGRP '    FldNameArr(Ix)
     C                   MOVEL     'GO00516'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDIF
 
      * Default
 
     C     DDBRCON       IFEQ      *BLANK
     C                   MOVEL     'N'           DDBRCON
     C                   ENDIF
 
      * 'Branch Consolidation must be Yes (Y) or No (N)'
 
     C     DDBRCON       IFNE      'Y'
     C     DDBRCON       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCON '    FldNameArr(Ix)
     C                   MOVEL     'GO00517'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDBRC         SCBRC
     C                   MOVEL     DDBRGRP       SCBRGRP
     C                   MOVEL     DDBRCON       SCBRCON
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate BSPL Report Set/Hierarchy
      ********************************************************************
     C     V_BSPLRPSET   BEGSR
 
     C                   EVAL      DDRPSET = %TRIM(DDRPSET)
 
      * Either a report set/hierarchy must be supplied or chart of accounts must be Y (yes)
 
     C     DDRPSET       IFNE      *BLANK
     C     DDCHART       OREQ      'N'
     C     DDCHART       OREQ      ' '
 
     C                   SELECT
 
      * ZONE
      * 'Invalid zone report set'
 
     C     DDZNGL        WHENEQ    'Z'
     C                   MOVEL     DDRPSET       G5RSNO
     C     G5RSNO        CHAIN     SDRPSTL0                           99        *
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRPSET '    FldNameArr(Ix)
     C                   MOVEL     'GO00518'     MsgIDArr(Ix)
     C                   ENDIF
 
      * GLOBAL
      * 'Invalid global BSPL hierarchy'
 
     C     DDZNGL        WHENEQ    'G'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDRPSET       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     15            ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RHID
     C     RHID          CHAIN     I_GRBSPLH1                         99        *
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRPSET '    FldNameArr(Ix)
     C                   MOVEL     'GO00519'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   MOVEL     DDRPSET       SCRPSET
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Hierarchy Depth
      ********************************************************************
     C     V_HIERDEPTH   BEGSR
 
      * Default
 
     C     DDHDPTH       IFEQ      *BLANK
     C                   MOVEL     '99'          DDHDPTH
     C                   ENDIF
 
      * Convert to numeric
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDHDPTH       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        SCHDPTH
     C                   ELSE
     C                   Z-ADD     *ZERO         SCHDPTH
     C                   ENDIF
 
      * 'Invalid Hierarchy Depth'
     C     ZALIGNok      IFNE      'Y'
     C     SCHDPTH       OREQ      0
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDHDPTH  '   FldNameArr(Ix)
     C                   MOVEL     'GO00520'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Chart of Accounts
      ********************************************************************
     C     V_CHART       BEGSR
 
      * Default
 
     C     DDCHART       IFEQ      *BLANK
     C                   MOVEL     'N'           DDCHART
     C                   ENDIF
 
      * 'Chart of accounts must be yes (Y) or no (N)'
 
     C     DDCHART       IFNE      'Y'
     C     DDCHART       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCHART '    FldNameArr(Ix)
     C                   MOVEL     'GO00521'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Chart of accounts cant be yes (Y) if a BSPL report set/hierarchy is defined'
 
     C     DDCHART       IFEQ      'Y'
     C     DDRPSET       ANDNE     *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCHART '    FldNameArr(Ix)
     C                   MOVEL     'GO00522'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDCHART       SCCHART
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Relative Period Number
      ********************************************************************
     C     V_RELPERDNO   BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDRELPN       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        Period            2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C     Period        ANDLT     24
     C                   MOVE      ZFIELD        SCRELPN
     C                   ELSE
 
      * 'Invalid Relative Period Number '
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRELPN  '   FldNameArr(Ix)
     C                   MOVEL     'GO00523'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Calendar Year and Month
      ********************************************************************
     C     V_CALYRMTH    BEGSR
 
      * Default
 
     C     DDCYR         IFEQ      *BLANK
     C                   MOVEL     CurYear       DDCYR
     C                   ENDIF
 
      * Convert to numeric
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDCYR         ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        Year
 
      * 'Invalid calendar year'
 
     C     ZALIGNok      IFNE      'Y'
     C     Year          ORLT      *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYR   '    FldNameArr(Ix)
     C                   MOVEL     'GO00524'     MsgIDArr(Ix)
     C                   ENDIF
 
      * Default
 
     C     DDCMTH        IFEQ      *BLANK
     C                   MOVEL     CurMonth      DDCMTH
     C                   ENDIF
 
      * Convert to numeric
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDCMTH        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        Month
 
      * 'Invalid calendar month'
 
     C     ZALIGNok      IFNE      'Y'
     C     Month         ORLE      *ZERO
     C     Month         ORGT      12
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMTH  '    FldNameArr(Ix)
     C                   MOVEL     'GO00525'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     Year          ReqYearMonth
     C                   MOVE      Month         ReqYearMonth      4 0
 
      * 'Requested year and month is in the future'
 
     C     ReqYearMonth  IFGT      CurYearMonth
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMTH  '    FldNameArr(Ix)
     C                   MOVEL     'GO00556'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     Year          SCCYR
     C                   MOVEL     Month         SCCMTH
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Report Type
      ********************************************************************
     C     V_REPORTTYP   BEGSR
 
      * 'Report Type must be Balances (B) or Movements (M)'
 
     C     DDRPTYP       IFNE      'B'
     C     DDRPTYP       ANDNE     'M'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRPTYP '    FldNameArr(Ix)
     C                   MOVEL     'GO00526'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDRPTYP       SCRPTYP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Report Movement Duration
      ********************************************************************
     C     V_REPMOVEDUR  BEGSR
 
      * 'Report Movement Duration should only be defined if the Report Type is Movements'
 
     C     DDRPTYP       IFEQ      'B'
 
     C     DDRMDUR       IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRMDUR '    FldNameArr(Ix)
     C                   MOVEL     'GO00527'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ELSE
 
      * 'Report Movement Duration must be yearly (Y), half-yearly (X), quarterly (Q) or monthly (M)'
 
     C     DDRPTYP       IFEQ      'M'
     C     DDRMDUR       ANDNE     'Y'
     C     DDRMDUR       ANDNE     'X'
     C     DDRMDUR       ANDNE     'Q'
     C     DDRMDUR       ANDNE     'M'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRMDUR '    FldNameArr(Ix)
     C                   MOVEL     'GO00528'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     DDRMDUR       SCRMDUR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Interim Currency Details
      ********************************************************************
     C     V_INTCCYDETLS BEGSR
 
      * 'Interim Currency must be None (N), Base (B) or Defined (D)'
 
     C     DDINT         IFNE      'N'
     C     DDINT         ANDNE     'B'
     C     DDINT         ANDNE     'D'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINT   '    FldNameArr(Ix)
     C                   MOVEL     'GO00529'     MsgIDArr(Ix)
     C                   ELSE
 
      * 'Interim Currency must NOT be present'
 
     C     DDINT         IFNE      'D'
     C     DDINTCCY      ANDNE     *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINTCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00530'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Interim Currency must be present'
 
     C     DDINT         IFEQ      'D'
     C     DDINTCCY      ANDEQ     ' '
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINTCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00531'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Interim Currency is invalid'
 
     C     DDINT         IFEQ      'D'
     C     DDINTCCY      ANDNE     ' '
     C     DDINTCCY      CHAIN     GPCURRD0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINTCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00532'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * 'Interim Currency Conversion Method must be Zone Rates(Z), Nominated Zone Rates (N) or
      *  Head-Office Rates (H)'
 
     C     DDINTCNV      IFNE      'Z'
     C     DDINTCNV      ANDNE     'N'
     C     DDINTCNV      ANDNE     'H'
     C     DDINT         ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINTCNV'    FldNameArr(Ix)
     C                   MOVEL     'GO00533'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Zone for Nominated Zone Rates is invalid'
 
     C     DDINTCNV      IFEQ      'N'
     C     DDINTCZN      CHAIN     GPZONED0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINTCZN '   FldNameArr(Ix)
     C                   MOVEL     'GO00534'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     DDINT         SCINT
     C                   MOVEL     DDINTCCY      SCINTCCY
     C                   MOVEL     DDINTCNV      SCINTCNV
     C                   MOVEL     DDINTCZN      SCINTCZN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Report Currency Details
      ********************************************************************
     C     V_REPCCYDETLS BEGSR
 
      * 'Report Currency must be Actual (A), Base (B), Head-Office Currency (H) or Defined (D)'
 
     C     DDREP         IFNE      'A'
     C     DDREP         ANDNE     'B'
     C     DDREP         ANDNE     'H'
     C     DDREP         ANDNE     'D'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREP   '    FldNameArr(Ix)
     C                   MOVEL     'GO00535'     MsgIDArr(Ix)
     C                   ELSE
 
      * 'Report Currency must NOT be present'
 
     C     DDREP         IFNE      'D'
     C     DDREPCCY      ANDNE     *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREPCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00536'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Report Currency must be present'
 
     C     DDREP         IFEQ      'D'
     C     DDREPCCY      ANDEQ     ' '
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREPCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00537'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Report Currency is invalid'
 
     C     DDREP         IFEQ      'D'
     C     DDREPCCY      ANDNE     ' '
     C     DDREPCCY      CHAIN     GPCURRD0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREPCCY'    FldNameArr(Ix)
     C                   MOVEL     'GO00538'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
      * 'Report Currency Conversion Method must be Zone Rates(Z), Nominated Zone Rates (N) or
      *  Head-Office Rates (H)'
 
     C     DDREPCNV      IFNE      'Z'
     C     DDREPCNV      ANDNE     'N'
     C     DDREPCNV      ANDNE     'H'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREPCNV'    FldNameArr(Ix)
     C                   MOVEL     'GO00539'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Zone for Nominated Zone Rates is invalid'
 
     C     DDREPCNV      IFEQ      'N'
     C     DDREPCZN      CHAIN     GPZONED0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDREPCZN '   FldNameArr(Ix)
     C                   MOVEL     'GO00540'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     DDREP         SCREP
     C                   MOVEL     DDREPCCY      SCREPCCY
     C                   MOVEL     DDREPCNV      SCREPCNV
     C                   MOVEL     DDREPCZN      SCREPCZN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate A/c Code Breakdown
      ********************************************************************
     C     V_ACCODEBRK   BEGSR
 
      * Default
 
     C     DDACDBD       IFEQ      *BLANK
     C                   MOVEL     'N'           DDACDBD
     C                   ENDIF
 
      * 'Account Code Breakdown must be Yes (Y) or No (N)'
 
     C     DDACDBD       IFNE      'Y'
     C     DDACDBD       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACDBD '    FldNameArr(Ix)
     C                   MOVEL     'GO00541'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDACDBD       SCACDBD
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Print Zero Balances
      ********************************************************************
     C     V_PRINTZEROB  BEGSR
 
      * Default
 
     C     DDPRTZB       IFEQ      *BLANK
     C                   MOVEL     'N'           DDPRTZB
     C                   ENDIF
 
      * 'Print Zero Balances must be Yes (Y) or No (N)'
 
     C     DDPRTZB       IFNE      'Y'
     C     DDPRTZB       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDPRTZB '    FldNameArr(Ix)
     C                   MOVEL     'GO00542'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDPRTZB       SCPRTZB
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Rounding
      ********************************************************************
     C     V_ROUNDING    BEGSR
 
      * 'Rounding must be Thousands (T), Units (U) or None (N)'
 
     C     DDROUND       IFNE      'T'
     C     DDROUND       ANDNE     'U'
     C     DDROUND       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDROUND '    FldNameArr(Ix)
     C                   MOVEL     'GO00543'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDROUND       SCROUND
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Include For. Ccy Transfer and Include Base Ccy Transfer
      ********************************************************************
     C     V_INCTRANSFERSBEGSR
 
      * 'Include Foreign Currency Transfer must be Yes (Y) or No (N)'
 
     C     DDIFCTFR      IFNE      'Y'
     C     DDIFCTFR      ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDIFCTFR'    FldNameArr(Ix)
     C                   MOVEL     'GO00544'     MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Include Base Currency Transfer must be Yes (Y) or No (N)'
 
     C     DDIBCTFR      IFNE      'Y'
     C     DDIBCTFR      ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDIBCTFR'    FldNameArr(Ix)
     C                   MOVEL     'GO00545'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDIFCTFR      SCIFCTFR
     C                   MOVEL     DDIBCTFR      SCIBCTFR
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Instruction ID
      ********************************************************************
     C     V_INSID       BEGSR
 
      * 'Invalid instruction id'
 
     C     DDINSID       IFNE      *BLANK
     C     DDINSID       CHAIN     FCSOUTL0                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDINSID '    FldNameArr(Ix)
     C                   MOVEL     'GO00546'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     DDINSID       SCINSID
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Description
      ********************************************************************
     C     V_DESC        BEGSR
 
      * 'Description must be defined'
 
     C     DDDESC        IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDDESC  '    FldNameArr(Ix)
     C                   MOVEL     'GO00547'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDDESC        SCDESC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Export
      ********************************************************************
     C     V_EXPORT      BEGSR
 
      * Default
 
     C     DDEXPRT       IFEQ      *BLANK
     C                   MOVEL     'N'           DDEXPRT
     C                   ENDIF
 
      * 'Export must be yes (Y) or no (N)'
 
     C     DDEXPRT       IFNE      'Y'
     C     DDEXPRT       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDEXPRT '    FldNameArr(Ix)
     C                   MOVEL     'GO00548'     MsgIDArr(Ix)
     C                   ENDIF
 
     C                   MOVEL     DDEXPRT       SCEXPRT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Report Frequency
      ********************************************************************
     C     V_RFREQ       BEGSR
 
      * 'Report frequency must be defined'
 
     C     DDRFREQ       IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRFREQ  '   FldNameArr(Ix)
     C                   MOVEL     'GO00549 '    MsgIDArr(Ix)
     C                   ELSE
 
      * 'Report frequency must be D, W, F, M, Q, X, or Y'
 
     C     DDRFREQ       LOOKUP    ZSFRQ                                  99
     C     *IN99         IFEQ      '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRFREQ  '   FldNameArr(Ix)
     C                   MOVEL     'GO00550 '    MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     DDRFREQ       SCRFREQ
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Report Day Number
      ********************************************************************
     C     V_RDAYN       BEGSR
 
     C     DDRFREQ       IFEQ      'M'
     C     DDRFREQ       OREQ      'Q'
     C     DDRFREQ       OREQ      'X'
     C     DDRFREQ       OREQ      'Y'
 
      *  Default to Report Day Number when blank and
      *  Frequency Code is 'M', 'Q', 'X' or 'Y'
 
     C     DDRDAYN       IFEQ      *BLANK
     C     DDRDAYN       OREQ      '00'
     C     BJDFIN        IFEQ      'D'
     C     2             SUBST     DDRDATE:1     DDRDAYN
     C                   ELSE
     C     2             SUBST     DDRDATE:3     DDRDAYN
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDRDAYN       ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        SCRDAYN
     C                   ENDIF
 
      * 'Report day must range from 01-31 when entered'
 
     C     SCRDAYN       IFLT      1
     C     SCRDAYN       ORGT      31
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDAYN  '   FldNameArr(Ix)
     C                   MOVEL     'GO00551 '    MsgIDArr(Ix)
     C                   ENDIF
 
      * 'Report day must be blank if frequency is not M, Q, X or Y'
 
     C                   ELSE
     C     DDRDAYN       IFNE      *BLANK
     C     DDRDAYN       ANDNE     '00'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDAYN  '   FldNameArr(Ix)
     C                   MOVEL     'GO00552 '    MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate (Next) Report Date
      ********************************************************************
     C     V_RDATE       BEGSR
 
      * 'Report date must be present'
 
     C     DDRDATE       IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDATE  '   FldNameArr(Ix)
     C                   MOVEL     'GO00553 '    MsgIDArr(Ix)
     C                   ELSE
 
      * It must be a valid date
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDRDATE       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Report Date'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDATE  '   FldNameArr(Ix)
     C                   MOVEL     'GO00554 '    MsgIDArr(Ix)
     C                   ELSE
     C                   Z-ADD     ZDAYNO        SCRDATE
     C                   END
 
      * 'Report Date cant be before run date'
 
     C     SCRDATE       IFGT      *ZERO
     C     SCRDATE       ANDLT     BJRDNB
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDATE  '   FldNameArr(Ix)
     C                   MOVEL     'GO00555 '    MsgIDArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a date into a day number
      ********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Digits to a Number
      ********************************************************************
     C     ZALIGN        BEGSR
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      **********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * INPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    GOBSRQ
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Convert current run date to day, month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
     C                   MOVEL     Year          CurYearMonth
     C                   MOVE      Month         CurYearMonth      4 0
     C                   MOVE      Year          CurYear           2 0
     C                   MOVE      Month         CurMonth          2 0
 
                                                                                              CAS014
     C     *DTAARA       DEFINE                  LDA                                          CAS014
                                                                                              CAS014
      ** Determine if CAS014 is switched on                                                   CAS014
                                                                                              CAS014
     C                   CALL      'AOSARDR0'                                                 CAS014
     C                   PARM      *BLANKS       PRTCD                                        CAS014
     C                   PARM      '*VERIFY'     POPTN                                        CAS014
     C                   PARM      'CAS014'      PSARD                                        CAS014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS014
                                                                                              CAS014
     C                   EVAL      CAS014 = 'N'                                               CAS014
     C                   IF        PRTCD = *BLANKS                                            CAS014
     C                   EVAL      CAS014 = 'Y'                                               CAS014
     C                   ELSE                                                                 CAS014
                                                                                              CAS014
     C                   IF        PRTCD <> '*NRF   '                                         CAS014
                                                                                              CAS014
     C     *LOCK         IN        LDA                                                        CAS014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS014
     C                   EVAL      DBASE = 01                                                 CAS014
     C                   EVAL      DBKEY = 'CAS014'                                           CAS014
     C                   OUT       LDA                                                        CAS014
                                                                                              CAS014
     C                   EXSR      *PSSR                                                      CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDIF                                                                CAS014
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  ZSFRQ
DWFMQXY
