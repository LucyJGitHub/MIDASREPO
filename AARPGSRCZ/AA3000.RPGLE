     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AA AADTA maintenence')
      *****************************************************************
      *                                                               *
      *  Midas - AA Initialisation                                    *
      *                                                               *
      *  AA3000 - AADTA Maintenece                                    *
      *                                                               *
      *  Function:  This program Allows maintenece of the data area   *
      *             AADTA by way of a menu.                           *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 186368             Date 22Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  186368 - Accnt Post Profit Centre not displayed on screen    *
      *         - and correct the "?" processing.                     *
      *  184967 - PCA Implementation Utilities                        *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         RE Swiched On                                   *
      *    26         DL (FX, NAP) Swiched On                         *
      *    27         LE Swiched On                                   *
      *    28         SE Swiched On                                   *
      *    29         FF Swiched On                                   *
      *    30         PM Swiched On                                   *
      *    31         DL (MM) Swiched On                              *
      *    32         Nostro PRFC Error   - Not on File               *
      *    33         FX PRFC Error   - Not on File                   *
      *    34         MM PRFC Error   - Not on File                   *
      *    35         NA Purch PRFC - Not On File                     *
      *    36         Cust Lend PRFC Error   - Not on File            *
      *    37         Re Cusex PRFC Error   - Not on File             *
      *    38         FX Pos PRFC Error   - Not on File               *
      *    39         Dump PRFC Error   - Not on File                 *
      *    40         Book PRFC Error   - Not on File                 *
      *    41         Trans PRFC Error   - Not on File                *
      *    42         Man A/C Anal PRFC (Y/N) Error                   *
      *    43         Man A/C Anal Book (Y/N) Error                   *
      *    44         Man A/C Anal Assoc cust (Y/N) error             *
      *    45         Man A/C Anal Prod (Y/N) Error                   *
      *    46         MA Analysis by Assoc Cust (Y/N) error           *
      *    47         Direct Fund PRFC (Y/N) Error                    *
      *    48         FX Position PRFC (Y/N) Error                    *
      *    49         Default Local Fund PRFC Error   - Not on File   *
      *    50         Default Foreign Fund PRFC Error   - Not on File *
      *    51         FX Position PRFC Error   -  Not on File         *
      *    52         Accnt Post PRFC Error   - Not on File           *
      *    53         FF Book PRFC Error   - Not on File              *
      *    54         FF Trans PRFC Error   - Not on File             *
      *    55         PM PRFC Error   - Not on File                   *
      *    56         Retail PRFC Error   - Not on File               *
      *    80         Function is Enquiry                             *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
     FAA3000DF  CF   E             WORKSTN
      *  Profit Centre Display File
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      * Indicator reset constant
     DResetInd         C                   '0000000000000000000000000'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(IndicatorPtr)
     D  F03Key                 3      3
     D  NotProfitC            70     70
     D  NotAllowExit          71     71
     D  Enquiry               80     80
 
     D AADTA         E DS                  EXTNAME(AADTA)
      **  AA Data Area
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas modules details
 
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      **  Profit Centre Details
 
     D DSFDY         E DS
      **  Short Data Structure for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D RtnCode         S              7
     D Option          S              7
     D ProfC           S              4
     D UNSPC           S                   LIKE(AANSPC)
     D UDMPC           S                   LIKE(AADMPC)
     D ULFPC           S                   LIKE(AALFPC)
     D UREPC           S                   LIKE(AAREPC)
     D UFFPC           S                   LIKE(AAFFPC)
     D UXPPC           S                   LIKE(AAXPPC)
     D UPRFC           S                   LIKE(AAPRFC)
     D UMAPC           S                   LIKE(AAMAPC)
     D UMABK           S                   LIKE(AAMABK)
     D UMAAC           S                   LIKE(AAMAAC)
     D UMAPR           S                   LIKE(AAMAPR)
     D UMCAC           S                   LIKE(AAMCAC)
     D UDFPI           S                   LIKE(AADFPI)
     D UFXPI           S                   LIKE(AAFXPI)
     D UCXPC           S                   LIKE(AACXPC)
     D UFXPC           S                   LIKE(AAFXPC)
     D UNAPC           S                   LIKE(AANAPC)
     D UFPPC           S                   LIKE(AAFPPC)
     D UMMPC           S                   LIKE(AAMMPC)
     D ULEPC           S                   LIKE(AALEPC)
     D UBKPC           S                   LIKE(AABKPC)
     D UTRPC           S                   LIKE(AATRPC)
     D UPMPC           S                   LIKE(AAPMPC)
     D UFFBP           S                   LIKE(AAFFBP)
     D UFFTP           S                   LIKE(AAFFTP)
     D DDPRFC          S              4
     D Function        S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  AADTA
     C                   IN        RUNDAT
     C     *LOCK         IN        AADTA
      *
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SRUNA = AGMRDT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
      * Move fields from AADTA into work fields for the general
      * purpose always showing fields
     C                   MOVEL     AANSPC        UNSPC
     C                   MOVEL     AADMPC        UDMPC
     C                   MOVEL     AALFPC        ULFPC
     C                   MOVEL     AAFFPC        UFFPC
     C                   MOVEL     AAXPPC        UXPPC
     C                   MOVEL     AAPRFC        UPRFC
     C                   MOVEL     AAMAPC        UMAPC
     C                   MOVEL     AAMABK        UMABK
     C                   MOVEL     AAMAAC        UMAAC
     C                   MOVEL     AAMAPR        UMAPR
     C                   MOVEL     AAMCAC        UMCAC
     C                   MOVEL     AADFPI        UDFPI
     C                   MOVEL     AAFXPI        UFXPI
 
     C                   IF        BGRTBN = 'Y'
     C                   MOVEL     AAREPC        UREPC
     C                   MOVEL     AACXPC        UCXPC
     C                   ENDIF
 
     C                   IF        BGDLFX = 'Y'
     C                   MOVEL     AAFXPC        UFXPC
     C                   MOVEL     AANAPC        UNAPC
     C                   MOVEL     AAFPPC        UFPPC
     C                   ENDIF
 
     C                   IF        BGDLMM = 'Y'
     C                   MOVEL     AAMMPC        UMMPC
     C                   ENDIF
 
     C                   IF        BGCSLN = 'Y'
     C                   MOVEL     AALEPC        ULEPC
     C                   ENDIF
 
     C                   IF        BGSECS = 'Y'
     C                   MOVEL     AABKPC        UBKPC
     C                   MOVEL     AATRPC        UTRPC
     C                   ENDIF
 
     C                   IF        BGFUOP = 'Y'
     C                   MOVEL     AAFFBP        UFFBP
     C                   MOVEL     AAFFTP        UFFTP
     C                   ENDIF
 
     C                   IF        BGPFMG = 'Y'
     C                   MOVEL     AAPMPC        UPMPC
     C                   ENDIF
 
     C                   EVAL      NotAllowExit = '1'
 
      * Do While F3 not pressed, An error on the validation, or If F03Key is entered and
      * An error on the validation is still present.
     C                   DOW       F03KEY = '0' OR
     C                             NotAllowExit = '1' OR
     C                             (F03Key = '1' AND
     C                             NotAllowExit = '1')
      * Set F03Key to OFF
     C                   EVAL      F03Key = '0'
      *
      *Execute SR Validate to validate entries
     C                   EXSR      Validate
     C                   WRITE     AA3000C
     C                   WRITE     AA3000F0
     C                   EXFMT     AA3000F1
     C                   ENDDO
 
     C                   OUT       AADTA
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate the fields entered                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     Validate      BEGSR
 
      * Reset Indicators and Clear subfile messages
     C                   EVAL      NotAllowExit = '0'
     C                   MOVEA     ResetInd      *IN(32)
     C                   EXSR      CLEAR
 
     C                   IF        UDMPC <> AADMPC
     C                   EVAL      DDPRFC = AADMPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN39 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN39 = '0'
     C                   EVAL      AADMPC = ProfC                               186368
     C                   EVAL      UDMPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UNSPC <> AANSPC
     C                   EVAL      DDPRFC = AANSPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN32 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN32 = '0'
     C                   EVAL      AANSPC = ProfC                               186368
     C                   EVAL      UNSPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        ULFPC <> AALFPC
     C                   EVAL      DDPRFC = AALFPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN49 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN49 = '0'
     C                   EVAL      AALFPC = ProfC                               186368
     C                   EVAL      ULFPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UFFPC <> AAFFPC
     C                   EVAL      DDPRFC = AAFFPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN50 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN50 = '0'
     C                   EVAL      AAFFPC = ProfC                               186368
     C                   EVAL      UFFPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UXPPC <> AAXPPC
     C                   EVAL      DDPRFC = AAXPPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN51 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN51 = '0'
     C                   EVAL      AAXPPC = ProfC                               186368
     C                   EVAL      UXPPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UPRFC <> AAPRFC
     C                   EVAL      DDPRFC = AAPRFC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN52 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN52 = '0'
     C                   EVAL      AAPRFC = ProfC                               186368
     C                   EVAL      UPRFC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
      *IF Retail is switched ON Test fields
     C                   IF        BGRTBN = 'Y'
      *
     C                   IF        UREPC <> AAREPC
     C                   EVAL      DDPRFC = AAREPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN56 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN56 = '0'
     C                   EVAL      AAREPC = ProfC                               186368
     C                   EVAL      UREPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UCXPC <> AACXPC
     C                   EVAL      DDPRFC = AACXPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN37 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN37 = '0'
     C                   EVAL      AACXPC = ProfC                               186368
     C                   EVAL      UCXPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
      *IF Dealing (FX/Neg. Assets) is switched ON test fields
     C                   IF        BGDLFX = 'Y'
      *
     C                   IF        UFXPC <> AAFXPC
     C                   EVAL      DDPRFC = AAFXPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN33 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN33 = '0'
     C                   EVAL      AAFXPC = ProfC                               186368
     C                   EVAL      UFXPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UNAPC <> AANAPC
     C                   EVAL      DDPRFC = AANAPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN35 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN35 = '0'
     C                   EVAL      AANAPC = ProfC                               186368
     C                   EVAL      UNAPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UFPPC <> AAFPPC
     C                   EVAL      DDPRFC = AAFPPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN38 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN38 = '0'
     C                   EVAL      AAFPPC = ProfC                               186368
     C                   EVAL      UFPPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
     C                   IF        BGDLMM = 'Y'
      *
     C                   IF        UMMPC <> AAMMPC
     C                   EVAL      DDPRFC = AAMMPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN34 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN34 = '0'
     C                   EVAL      AAMMPC = ProfC                               186368
     C                   EVAL      UMMPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
      *IF Customer Lending is switched ON test fields
     C                   IF        BGCSLN = 'Y'
      *
     C                   IF        ULEPC <> AALEPC
     C                   EVAL      DDPRFC = AALEPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN36 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN36 = '0'
     C                   EVAL      AALEPC = ProfC                               186368
     C                   EVAL      ULEPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
      *IF Securities is switched ON test fields
     C                   IF        BGSECS = 'Y'
      *
     C                   IF        UBKPC <> AABKPC
     C                   EVAL      DDPRFC = AABKPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN40 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN40 = '0'
     C                   EVAL      AABKPC = ProfC                               186368
     C                   EVAL      UBKPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UTRPC <> AATRPC
     C                   EVAL      DDPRFC = AATRPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN41 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN41 = '0'
     C                   EVAL      AATRPC = ProfC                               186368
     C                   EVAL      UTRPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
      *IF Futures and Options is switched ON test fields
     C                   IF        BGFUOP = 'Y'
      *
     C                   IF        UFFBP <> AAFFBP
     C                   EVAL      DDPRFC = AAFFBP
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN53 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN53 = '0'
     C                   EVAL      AAFFBP = ProfC                               186368
     C                   EVAL      UFFBP  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   IF        UFFTP <> AAFFTP
     C                   EVAL      DDPRFC = AAFFTP
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN54 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN54 = '0'
     C                   EVAL      AAFFTP = ProfC                               186368
     C                   EVAL      UFFTP  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
      *
      *IF Portfolio Management is switched ON test fields
     C                   IF        BGPFMG = 'Y'
      *
     C                   IF        UPMPC <> AAPMPC
     C                   EVAL      DDPRFC = AAPMPC
     C                   EXSR      SRPRFC
     C                   IF        NotProfitC = '1'
     C                   EVAL      NotAllowExit = '1'
     C                   EVAL      *IN55 = '1'
     C***********        ENDIF                                                  186368
     C                   ELSE
     C                   EVAL      *IN55 = '0'
     C                   EVAL      AAPMPC = ProfC                               186368
     C                   EVAL      UPMPC  = ProfC                               186368
     C                   ENDIF                                                  186368
     C                   ENDIF
     C                   EVAL      NotProfitC = '0'
      *
     C                   ENDIF
 
     C                   IF        NotAllowExit = '1'
     C                   EVAL      ZAMSID = 'USR0647'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRFC - Profit Centre Retrieval Sub Routine                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRPRFC        BEGSR
 
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*KEY   '     Option
     C     DDPRFC        PARM      DDPRFC        ProfC             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
 
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      NotProfitC = '1'
     C                   ENDIF
      *
     C                   ENDSR
 
      **********************************************************************
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
 
     C     *Entry        PLIST
     C                   PARM                    Function
      *
      * If the function is an Enquiry then the fields should be protected
     C                   If        Function = 'E'
     C                   EVAL      Enquiry = '1'
     C                   ENDIF
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      *IF Retail is switched ON turn on Indicator
     C                   IF        BGRTBN = 'Y'
     C                   EVAL      *IN25 = '1'
     C                   ENDIF
      *
      *IF Dealing (FX/Neg. Assets) is switched ON turn on Indicator
     C                   IF        BGDLFX = 'Y'
     C                   EVAL      *IN26 = '1'
     C                   ENDIF
      *
      *IF Customer Lending is switched ON turn on Indicator
     C                   IF        BGCSLN = 'Y'
     C                   EVAL      *IN27 = '1'
     C                   ENDIF
      *
      *IF Securities is switched ON turn on Indicator
     C                   IF        BGSECS = 'Y'
     C                   EVAL      *IN28 = '1'
     C                   ENDIF
      *
      *IF Futures and Options is switched ON turn on Indicator
     C                   IF        BGFUOP = 'Y'
     C                   EVAL      *IN29 = '1'
     C                   ENDIF
      *
      *IF Portfolio Management is switched ON turn on Indicator
     C                   IF        BGPFMG = 'Y'
     C                   EVAL      *IN30 = '1'
     C                   ENDIF
      *
      *IF Dealing (Money Markets) is switched ON turn on Indicator
     C                   IF        BGDLMM = 'Y'
     C                   EVAL      *IN31 = '1'
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                               *
      *   ZASNMS - Subroutine which handles the display of error      *
      *            messages                                           *
      *                                                               *
      *   Called by: Validate                                         *
      *                                                               *
      *   Calls    : Y2SNMGC - Send a message                         *
      *                                                               *
      ********************************************************************
      *
     C     ZASNMS        BEGSR
     C                   IF        ZAPGMQ = *BLANK
     C                   EVAL      ZAPGMQ = 'AA3000'
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program Queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA           30            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   CLEAR - Subroutine which clears the message file            *
      *                                                               *
      *   Called by: Main                                             *
      *                                                               *
      *   Calls    : Y2CLMSC - Clear message file                     *
      *                                                               *
      *****************************************************************
      *
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      'AA3000'      ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
