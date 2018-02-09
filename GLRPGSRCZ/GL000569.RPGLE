     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Inactive Retail Accounts Extract')            *
/*XBIA*: OVRDBF FILE(AXFIAZZ) TOFILE(RTZZ) MBR(AXFI)                : *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL000569 - Inactive Retail Accounts Extract                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1097467          Date 16Apr13               *
      *                 CGL127AP *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1097467B - Expected 15% COB run optimization not met       *
      *  CGL127AP - COB Restructure - GL COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    41 - Print Retail Records count                            *
      *    42 - Print IBPA record output count                        *
      *    43 - Print AXFI record output count                        *
      *    44 - Print RETAC record output count                       *
      *                                                               *
      *****************************************************************
      *
      ** File Declarations
      *
     F***REINACL0  IF   E             DISK    INFSR(*PSSR)                                AR1097467B
     FREINACPD  IF   E             DISK    INFSR(*PSSR)                                   AR1097467B
      ** Retail Accounts to be Transferred to Inactive
 
     FAXFIAX    O    E             DISK    INFSR(*PSSR)
      ** Retail Accounts Transfer to Inactive Status
 
     FAXFIAZZ   O    E             DISK    RENAME(RTZZF : AXFIATRL)
     F                                     PREFIX('AXFIA')
     F                                     INFSR(*PSSR)
      ** RTZZ trailer file member AXFIAX
 
     FGL000570AUO    E             PRINTER USROPN
      ** GL Accounts Detail Extract - Audit
 
      /EJECT
      *
      ** DS/Variable/Constant Declarations
      *
     D PgmName         C                   CONST('GL000571')
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
     D RptNameOffset   S              5U 0 INZ
     D PSSRDone        S              1N   INZ
     D AXFIACount      S                   INZ LIKE(RAXFICTR)
 
      ** Bit constants for testing bits of RETB
 
     D Bit4            C                   X'08'
 
     D LDA           E DS                  INZ EXTNAME(LDA)
      ** Data Area Data structure for LDA
     D                                     DTAARA('LDA')
     D                                     QUALIFIED
 
     D SDBANKDS      E DS                  INZ EXTNAME(SDBANKPD)
      ** Data structure for Bank Details
 
     D DSFDY         E DS                  INZ EXTNAME(DSFDY)
      ** Short Dummy Data Structure for Access Object programs
 
     D PSSRDS          DS                  INZ LIKEDS(LDA)
      ** Data structure for PSSR error logging
 
     D AOPgmParm       DS                  INZ
      ** Access Object program parameters
     D  PRetCode                      7A
     D  POption                       7A
     D  PKey                         10A
     D  PKeyStatus                    7A
 
      ** Name *IN indicators
 
     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D Indicator       DS                  BASED(IndicatorPtr)
     D  PrtRecCount           41     41
     D  PrtIBPACount          42     42
     D  PrtAXFICount          43     43
     D  PrtRETACCount         44     44
 
D     /EJECT
      ****************************************************************
      *                                                              *
      *                    MAIN PROCESSING                           *
      *                                                              *
      ****************************************************************
 
      ** Copy Records from REINACL0 to AXFIAX
 
     C                   READ      REINACD0
     C**********         DOW       NOT %EOF(REINACL0) AND NOT *INU7                       AR1097467B
     C                   DOW       NOT %EOF(REINACPD) AND NOT *INU7                       AR1097467B
     C                   WRITE     AXFIAXF
     C                   EVAL      AXFIACount = AXFIACount + 1
     C                   READ      REINACD0
     C                   ENDDO
 
      ** Write trailer file for AXFIAX
      ** Add 2 for header and trailer
 
     C                   EVAL      AXFIARECI = 'T'
     C                   EVAL      AXFIACount = AXFIACount + 2
     C                   MOVE      AXFIACount    AXFIANORE
     C                   WRITE     AXFIATRL
 
      ** Print audit report GL000570AU
 
     C                   OPEN      GL000570AU
     C                   WRITE     HEADAU
 
      ** Setup fields for GL000570AU/CONTROL details
 
     C                   EVAL      RAXFICTR = AXFIACount
 
     C                   WRITE     CONTROL
 
      ** Print DBERROR in audit report for errors
 
     C                   IF        *INU7
     C                   EVAL      RDBASE = PSSRDS.DBase
     C                   EVAL      RDBFILE = PSSRDS.DBFile
     C                   EVAL      RDBKEY = PSSRDS.DBKey
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   CLOSE     GL000570AU
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine for initial program processing    *
      * Called by: At first program startup                           *
      * Calls : AOBANKR0                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANKDS      PARM      SDBANKDS      DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      PSSRDS.DBFile = 'SDBANKPD'
     C                   EVAL      PSSRDS.DBKey = POption
     C                   EVAL      PSSRDS.DBProc = POption
     C                   EVAL      PSSRDS.DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set DBPGM to be equal to program name
 
     C                   EVAL      PSSRDS.DBPGM = PgmName
 
      ** Setup Report Header fields
 
     C                   EVAL      RREFNAME = PgmName
     C                   EVAL      RMRDT = BJMRDT
 
      ** Set-up and center Report Name
 
     C                   EVAL      RptNameOffset = (%LEN(RURPT) -
     C                               %LEN(%TRIM(BJURPT)))/2 + 1
     C                   EVAL      %SUBST(RURPT : RptNameOffset) =
     C                                BJURPT
 
      ** Setup which record counts are to be printed
 
     C                   EVAL      PrtRecCount = False
     C                   EVAL      PrtIBPACount = False
     C                   EVAL      PrtRETACCount = False
     C                   EVAL      PrtAXFICount = True
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *PSSR - Subroutine to handle and report program errors        *
      * Called by: Program exception errors or EXSR                   *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
     C                   IF        NOT PSSRDone
     C     *LOCK         IN        LDA
     C                   EVAL-CORR LDA = PSSRDS
     C                   OUT       LDA
     C                   DUMP
     C                   EVAL      PSSRDone = True
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
