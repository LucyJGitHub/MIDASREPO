     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Collateral and Credit Lines ICD')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009113 - Collateral and Credit Lines ICD                   *
      *                                                               *
      *  Function:  This module enables the user to maintain and      *
      *             enquire upon Collateral and Credit Lines data.    *
      *                                                               *
      *  Component of: SD009113                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3644            Date 12Jul04               *
      *  Prev Amend No. CGL014             Date 20Oct03               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         Protect Indicator for Enquiry Mode              *
      *    26         FX Valuation by Forward Rate or NPV error ind.  *
      *    27         Margin Calc by Date or Open Pos error ind.      *
      *    28         Deflt Coll Prices for SE Valuation error ind.   *                       CGL014
      *    29         Include Collateral Events in Diary error ind.   *                       CGL014
      *    30         Collaterals Account Key Generation error ind.   *                       CGL014
      *    31         Apply to All Pledged Securities error ind.      *                       CGL014
      *    50         CLE025 on                                       *                       CGL014
      *    52         CGL014 on                                       *                       CGL014
      *    53         Apply to All Pledged Securities display in.     *                       CGL014
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process initial screen                           *
      *  SRMove - Move file fields to screen fields                   *
      *  SRDisplay - Display Screen                                   *
      *  SRValid - Validate Screen Details                            *
      *  SRUpdate - Write/Update Record in file SDCOCCPD              *
      *  SRSndErr- Send Error Message                                 *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
     FSD009113DFCF   E             WORKSTN
      ** Collateral and Credit Lines ICD Display
 
     FSDCOCCL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Collateral and Credit Lines Data
 
     FSDFCTLL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Standing Data Controls Update index
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Switchable features                                      CGL014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL014
                                                                                              CGL014
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure for Screen Fields
     D #1DBRC          DS            22
     D   WLCD                 16     18  0
     D   WTODT                20     22  0
 
      ** Collateral and Credit Lines ICD File
     D @1DBRC        E DS                  EXTNAME(SDCOCCPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCodeIn      S              7
     D PColl           S              4
     D PMode           S              1
     D PRetCode        S              7
     D POption         S              7
     D PMsgFile        S             10    INZ('GBSDUSRMSG')
     D PMsgID          S             10
     D WColl           S             10
     D WrkLCD          S              5  0
     D WNumRec         S              5  0
     D WNumIns         S              5  0
     D WNumAmd         S              5  0
     D WNumDel         S              5  0
     D WError          S              1
     D WRun            S              1
     D CLE025          S              1                                                       CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
     D PSEQ            S              5                                                       CGL014
     D PLEV            S              1                                                       CGL014
     D PENT            S              3                                                       CGL014
     D WFileDCPS       S              1                                                       CGL014
     D WPrevDCPS       S              1                                                       CGL014
     D WPrevAAPS       S              1                                                       CGL014
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
 
      ** Process initial screen
 
     C                   EXSR      SRProcess
 
     C                   DOU       *INKC = *ON  OR  WError = 'N'
 
     C                   EXSR      SRDisplay
 
     C                   IF        PMode <> 'E'  AND  *INKC <> *ON
     C                   EXSR      SRValid
     C                   IF        WError <> 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   IF        WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   IF        CGL014 = 'Y'  AND  WFileDCPS <> #1DCPS  AND                CGL014
     C                             #1AAPS = 'Y'                                               CGL014
     C                   CALL      'GLC000010'                                                CGL014
     C                   PARM                    PSEQ                                         CGL014
     C                   PARM                    PLEV                                         CGL014
     C                   PARM                    PENT                                         CGL014
 
     C                   IF        #1DFER = 'N'                                               CGL014
     C                   EVAL      PRetCodeIn = '*UPDATE'                                     CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Initial Screen                           *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Check for existing record
 
     C                   EVAL      WColl = PColl
     C     WColl         CHAIN     SDCOCCL0
 
      ** Record does not exist
 
     C                   IF        NOT %FOUND(SDCOCCL0)
     C                   EVAL      WError = 'Y'
 
      ** Send message 'Collateral and Credit Lines ICD not found'
 
     C                   IF        PMode = 'E'
     C                   EVAL      PMsgID = 'USR4023'
     C                   ELSE
     C                   EVAL      PMsgID = 'USR4024'
     C                   ENDIF
 
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   EXSR      SRMove
     C                   ENDIF
 
     C                   UNLOCK    SDCOCCL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMove - Move File Fields to Screen Fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
      ** FX Valuation by Forward Rate or NPV
 
     C                   IF        CLE025 = 'Y'                                               CGL014
     C                   EVAL      #1FVFN = CCFVFN
     C                   EVAL      #1MCDO = CCMCDO
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      #1DCPS = CCDCPS                                            CGL014
     C                   EVAL      #1ICED = CCICED                                            CGL014
     C                   EVAL      #1CAKG = CCCAKG                                            CGL014
     C                   EVAL      WFileDCPS = CCDCPS                                         CGL014
     C                   ENDIF                                                                CGL014
 
      ** Hold existing record image
 
     C                   EVAL      #1DBRC = @1DBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display and process detail screen                *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   WRITE     SD009113C0
     C***************    EXFMT     SD009113F0
     C                   Write     SD009113F0
     C                   Read      SD009113F0
 
      ** Clear messages from program message queue
 
     C                   IF        PMode <> 'E'
     C                   CALL      'ZA0250'
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   MOVEA     '0000'        *IN(28)                                      CGL014
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Validate Details                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValid       BEGSR
 
     C                   EVAL      WError = 'N'
 
      ** If entered, FX Valuation by Forward Rate must be
      ** 'Y' (by Forward Rate) or 'N' (by Net Present Value)
 
     C                   IF        CLE025 = 'Y'                                               CGL014
     C                   IF        #1FVFN <> *BLANKS
 
     C                   IF        #1FVFN <> 'Y'  AND  #1FVFN <> 'N'
     C                   EVAL      PMsgID = 'USR4025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Default to 'Y' when left blank
 
     C                   ELSE
     C                   EVAL      #1FVFN = 'Y'
     C                   ENDIF
 
      ** If entered, the Margin Calculation by Open Position
      ** must be 'Y' (by Open Position) or 'N' (by Date) only
 
     C                   IF        #1MCDO <> *BLANKS
 
     C                   IF        #1MCDO <> 'Y'  AND  #1MCDO <> 'N'
     C                   EVAL      PMsgID = 'USR4036'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN27 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #1MCDO = 'Y'
     C                   ENDIF
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
                                                                                              CGL014
      ** If entered, the Default Collateral Price for SE Valuation                            CGL014
      ** must be 'M' (Mid), 'B' (Bid), or 'O' (Offer)                                         CGL014
                                                                                              CGL014
     C                   IF        #1DCPS <> *BLANKS                                          CGL014
                                                                                              CGL014
     C                   IF        #1DCPS <> 'M'  AND  #1DCPS <> 'B'  AND                     CGL014
     C                             #1DCPS <> 'O'                                              CGL014
     C                   EVAL      PMsgID = 'USR4032'                                         CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   EVAL      *IN28 = *ON                                                CGL014
     C                   EXSR      SRSndErr                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Default to 'M' when left blank                                                       CGL014
                                                                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      #1DCPS = 'M'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If entered, Include Collateral Events in Diary must be 'Y'or 'N' only                CGL014
                                                                                              CGL014
     C                   IF        #1ICED <> *BLANKS                                          CGL014
                                                                                              CGL014
     C                   IF        #1ICED <> 'Y'  AND  #1ICED <> 'N'                          CGL014
     C                   EVAL      PMsgID = 'USR4033'                                         CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   EVAL      *IN29 = *ON                                                CGL014
     C                   EXSR      SRSndErr                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Default to 'Y' when left blank                                                       CGL014
                                                                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      #1ICED = 'Y'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If entered, Collateral Account Key Generation must be 'Y'or 'N' only                 CGL014
                                                                                              CGL014
     C                   IF        #1CAKG <> *BLANKS                                          CGL014
                                                                                              CGL014
     C                   IF        #1CAKG <> 'Y'  AND  #1CAKG <> 'N'                          CGL014
     C                   EVAL      PMsgID = 'USR4034'                                         CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   EVAL      *IN30 = *ON                                                CGL014
     C                   EXSR      SRSndErr                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Default to 'Y' when left blank                                                       CGL014
                                                                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      #1CAKG = 'Y'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Validate 'Apply to All Pledged Securities' only if 'Collateral                       CGL014
      ** Prices for SE Valuation' has changed (different from file value)                     CGL014
                                                                                              CGL014
     C                   IF        *IN53 = *ON  AND  #1DCPS <> WFileDCPS  AND                 CGL014
     C                             *IN28 = *OFF                                               CGL014
                                                                                              CGL014
     C                   IF        #1AAPS <> 'Y'  AND  #1AAPS <> 'N'                          CGL014
     C                   EVAL      PMsgID = 'USR4035'                                         CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   EVAL      *IN31 = *ON                                                CGL014
     C                   EXSR      SRSndErr                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Validate 'Defer Revaluation in COB' only if                                          CGL014
      ** 'Apply to All Pledged Securities' is 'Y'                                             CGL014
                                                                                              CGL014
     C                   IF        *IN54 = *ON  AND  #1AAPS = 'Y'                             CGL014
                                                                                              CGL014
     C                   IF        #1DFER <> 'Y'  AND  #1DFER <> 'N'                          CGL014
     C                   EVAL      PMsgID = 'USR4039'                                         CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   EVAL      *IN32 = *ON                                                CGL014
     C                   EXSR      SRSndErr                                                   CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If screen value was changed by user                                                  CGL014
                                                                                              CGL014
     C                   IF        WPrevDCPS <> #1DCPS                                        CGL014
     C                   EVAL      WPrevDCPS = #1DCPS                                         CGL014
                                                                                              CGL014
      ** Display 'Apply to All Pledged Securities' only if 'Collateral                        CGL014
      ** Prices for SE Valuation' has changed (different from file value)                     CGL014
                                                                                              CGL014
     C                   IF        *IN28 = *OFF  AND  #1DCPS <> WFileDCPS                     CGL014
     C                   EVAL      *IN53 = *ON                                                CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      *IN53 = *OFF                                               CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Display  'Defer Revaluation in COB' only if                                          CGL014
      ** 'Apply to All Pledged Securities' is 'Y'                                             CGL014
                                                                                              CGL014
     C                   IF        WPrevAAPS <> #1AAPS                                        CGL014
     C                   EVAL      WPrevAAPS = #1AAPS                                         CGL014
     C                   IF        #1AAPS = 'Y'                                               CGL014
     C                   EVAL      *IN54 = *ON                                                CGL014
     C                   EVAL      WError = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      *IN54 = *OFF                                               CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Record in PF/SDCOCCPD                      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C     WColl         CHAIN     SDCOCCL0
 
      ** Write new ICD record
 
     C                   IF        NOT %FOUND(SDCOCCL0)
 
     C                   EVAL      CCCOCC = PColl
                                                                                              CGL014
     C                   IF        CLE025 = 'Y'                                               CGL014
     C                   EVAL      CCFVFN = #1FVFN
     C                   EVAL      CCMCDO = #1MCDO
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C**********         EVAL      CCDCPS = *BLANK                                            CGL014
     C**********         EVAL      CCICED = *BLANK                                            CGL014
     C**********         EVAL      CCCAKG = *BLANK                                            CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      CCDCPS = #1DCPS                                            CGL014
     C                   EVAL      CCICED = #1ICED                                            CGL014
     C                   EVAL      CCCAKG = #1CAKG                                            CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   EVAL      CCLCD  = BJRDNB
     C                   EVAL      CCTYLC = 'I'
     C                   EVAL      CCTODT = *ZERO
 
     C                   WRITE     SDCOCCD0
 
      ** Update saved record image
 
     C                   EVAL      #1DBRC = @1DBRC
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     1             WNumRec
     C                   Z-ADD     1             WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
     C                   EXSR      SRSDCntrl
     C                   ENDIF
 
      ** Update SDCOCCL0
 
     C                   IF        %FOUND(SDCOCCL0)
 
      ** Check for changed record
 
     C                   IF        #1DBRC <> @1DBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgID = 'USR9235'
     C                   EXSR      SRSndErr
     C                   UNLOCK    SDCOCCL0
 
     C                   ELSE
 
      ** Update File
 
     C                   EVAL      WrkLCD = CCLCD
                                                                                              CGL014
     C                   IF        CLE025 = 'Y'                                               CGL014
     C                   EVAL      CCFVFN = #1FVFN
     C                   EVAL      CCMCDO = #1MCDO
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      CCDCPS = #1DCPS                                            CGL014
     C                   EVAL      CCICED = #1ICED                                            CGL014
     C                   EVAL      CCCAKG = #1CAKG                                            CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   EVAL      CCLCD  = BJRDNB
     C                   EVAL      CCTYLC = 'A'
 
     C                   UPDATE    SDCOCCD0
 
      ** Only update file controls if record has not been updated already
 
     C     WrkLCD        IFNE      BJRDNB
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     1             WNumAmd
     C                   EXSR      SRSDCntrl
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDCntrl - Update Standing Data Controls                    *
      *                                                               *
      *****************************************************************
 
     C     SRSDCntrl     BEGSR
 
     C                   EVAL      AHFLNM = 'SDCOCCPD'
 
     C     AHFLNM        CHAIN     SDFCTLL0
 
      ** Database error if record not found
 
     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY  = 'SDCOCCPD'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   ADD       WNumRec       AHNORC
     C                   ADD       WNumIns       AHNOIN
     C                   ADD       WNumAmd       AHNOAM
     C                   ADD       WNumDel       AHNODL
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Send Error Message                                *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PColl
     C                   PARM                    PMode
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C     PRetCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL014
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CLE025'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CLE025'                                          CGL014
     C                   EVAL      DBASE  = 3                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
      *                                                                                       CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CLE025 = 'Y'                                               CGL014
     C                   EVAL      *IN50 = *ON                                                CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CLE025 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 4                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
      *                                                                                       CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   EVAL      *IN52 = *ON                                                CGL014
     C                   EVAL      *IN53 = *OFF                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
 
      ** Move Workstation ID to screen field
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0PGMQ = PSProcName
 
      ** Initialise Work Fields
 
     C                   EVAL      WError = 'Y'
     C                   EVAL      WrkLCD = *ZEROS
     C                   EVAL      WNumRec = *ZEROS
     C                   EVAL      WNumIns = *ZEROS
     C                   EVAL      WNumDel = *ZEROS
     C                   EVAL      WNumAmd = *ZEROS
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      *IN53 = *ON                                                CGL014
     C                   ELSE
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   MOVEA     '0000'        *IN(28)                                      CGL014
 
      ** Initialise detail screen
 
     C                   EVAL      #1FVFN = *BLANK
     C                   EVAL      #1MCDO = *BLANK
     C                   EVAL      #1DCPS = *BLANK                                            CGL014
     C                   EVAL      #1ICED = *BLANK                                            CGL014
     C                   EVAL      #1CAKG = *BLANK                                            CGL014
     C                   EVAL      #1AAPS = *BLANK                                            CGL014
     C                   EVAL      #1DFER = *BLANK                                            CGL014
     C                   EVAL      WFileDCPS = *BLANK                                         CGL014
     C                   EVAL      WPrevDCPS = *BLANK                                         CGL014
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
