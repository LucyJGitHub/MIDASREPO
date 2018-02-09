     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('SD Central Data Acceptance on Effective Date Ctrl')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000061 - SD Central Data Acceptance on Effective Date Ctrl.*
      *                                                               *
      *  Function:  This calls the corresponding acceptance program   *
      *             to update the zones with the centralised data     *
      *             being held in the acceptance file.                *
      *                                                               *
      *  Called By: SDC000061 - SD Central Data Acceptance on         *
      *                         Effective Date.                       *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12604           Date 13Nov06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  BUG12604 - Prevent record locking in Currency Details        *
      *             Acceptance.                                       *
      *  CSD031 - Enhanced Centralised Standing Data.                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    40         READ Indicator                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRACOD - Accept Account Code routine                          *
      * SRAKEY - Accept Account Keys routine                          *
      * SRFAKY - Accept FO Account Keys routine                       *
      * SRSAKY - Accept SE Account Keys routine                       *
      * SRCUST - Accept Customer Details routine                      *
      * SRDLST - Accept Deal Sub-Type routine                         *
      * SRDTST - Accept Deal Type/Sub-Type routine                    *
      * SRFACT - Accept Facility Type routine                         *
      * SRHOLI - Accept Holidays routine                              *
      * SRLOAN - Accept Loan Type/Sub-Type routine                    *
      * SRCURR - Accept Currencies Details routine                    *
      * SRNARR - Accept Narrative Codes routine                       *
      * SRACOF - Accept Account Officer routine                       *
      * SRCTRY - Accept Country Code routine                          *
      * SRLOCN - Accept Location Code routine                         *
      * SRREGN - Accept Region Code routine                           *
      * SRBRCH - Accept Branch Code routine                           *
      * SRRECG - Accept RE Customer Group routine                     *
      * SRLENO - Accept Loan Number Ranges routine                    *
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
     FSDAACDL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDAAKYL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDAFAKL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDASAKL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDACSTL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDADSTL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDADTSL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDAFCTL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDAHDYL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDALTSL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     F***SDACURL2  UF   E           K DISK    USROPN                                        BUG12604
     F**********                           INFSR(*PSSR)                                     BUG12604
     FSDANARL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDAACOL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDACTYL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDALCNL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDARGNL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDABRCL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDARCGL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDALENL2  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
     FSDACURL2  IF   E           K DISK    USROPN                                           BUG12604
     F                                     RENAME(SDCURRD0:SDACURD2)                        BUG12604
     F                                     INFSR(*PSSR)                                     BUG12604
     FSDACURL4  UF   E           K DISK    USROPN                                           BUG12604
     F                                     RENAME(SDCURRD0:SDACURD4)                        BUG12604
     F                                     INFSR(*PSSR)                                     BUG12604
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
      *
      ** Data Area giving Installation Control Details
     D @SDAACD       E DS                  EXTNAME(SDZACODPD)
     D @SDAAKY       E DS                  EXTNAME(SDAAKYPD)
     D @SDAFAK       E DS                  EXTNAME(SDAFAKPD) PREFIX(F_)
     D @SDASAK       E DS                  EXTNAME(SDASAKPD) PREFIX(K_)
     D @SDACST       E DS                  EXTNAME(SDZCUSTPD)
     D @SDADST       E DS                  EXTNAME(SDADSTPD)
     D @SDADTS       E DS                  EXTNAME(SDADTSPD)
     D @SDAFCT       E DS                  EXTNAME(SDAFCTPD)
     D @SDAHDY       E DS                  EXTNAME(SDAHDYPD)
     D @SDALTS       E DS                  EXTNAME(SDALTSPD)
     D L_PLDPCD      E                     EXTFLD(PLDPCD)
     D L_PLDRCD      E                     EXTFLD(PLDRCD)
     D L_PLCRED      E                     EXTFLD(PLCRED)
     D @SDACUR       E DS                  EXTNAME(SDZCURRPD)
     D @SDANAR       E DS                  EXTNAME(SDANARPD)
     D @SDAACO       E DS                  EXTNAME(SDZACOFPD)
     D  A_ZZLCD      E                     EXTFLD(ZZLCD)
     D  A_ZZEACC     E                     EXTFLD(ZZEACC)
     D @SDACTY       E DS                  EXTNAME(SDACTYPD)
     D @SDALCN       E DS                  EXTNAME(SDALCNPD)
     D @SDARGN       E DS                  EXTNAME(SDARGNPD)
     D @SDABRC       E DS                  EXTNAME(SDZBRCHPD)
     D ZQDFAC        E                     EXTFLD(QQDFAC)
     D @SDARCG       E DS                  EXTNAME(SDARCGPD)
     D R_RECI        E                     EXTFLD(RECI)
     D R_LCD         E                     EXTFLD(LCD)
     D R_CHTP        E                     EXTFLD(CHTP)
     D R_TNLU        E                     EXTFLD(TNLU)
     D R_ZONE        E                     EXTFLD(ZONE)
     D R_IUSR        E                     EXTFLD(IUSR)
     D R_AUSR        E                     EXTFLD(AUSR)
     D R_XUSR        E                     EXTFLD(XUSR)
     D R_AACC        E                     EXTFLD(AACC)
     D R_EACC        E                     EXTFLD(EACC)
     D R_GPDT        E                     EXTFLD(GPDT)
     D @SDALEN       E DS                  EXTNAME(SDALENPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D S_LCD         E                     EXTFLD(LCD)
     D S_ZONE        E                     EXTFLD(ZONE)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D PDATA           S           4000A
     D PRETCODE        S              7A   INZ('       ')
     D PPROGRAM        S             10A   INZ('SDC000061')
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CSD032          S              1A
     D CSD033          S              1A
     D CSD034          S              1A
     D CSD036          S              1A
     D CSD037          S              1A
     D CSD038          S              1A
     D CSD039          S              1A
     D CSD040          S              1A
     D CSD041          S              1A
     D CSD042          S              1A
     D CSD043          S              1A
     D CSD044          S              1A
     D CSD045          S              1A
     D CSD046          S              1A
     D CSD047          S              1A
     D CSD048          S              1A
     D CSD049          S              1A
     D CSD050          S              1A
     D CSD051          S              1A
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D WACD6           S             10A
     D ZZLCD           S              5  0
     D ZZEACC          S              5  0
     D KCyCd           S                   LIKE(A6CYCD)                                     BUG12604
 
     ISDBRCHD0
     I              QQDFAC                      ZQDFAC
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Execute corresponding routines based on switchable features.
      *
     C                   IF        CSD032 = 'Y'
     C                   EXSR      SRACOD
     C                   ENDIF
      *
     C                   IF        CSD033 = 'Y'
     C                   EXSR      SRAKEY
     C                   ENDIF
      *
     C                   IF        CSD034 = 'Y'
     C                   EXSR      SRFAKY
     C                   ENDIF
      *
     C                   IF        CSD036 = 'Y'
     C                   EXSR      SRSAKY
     C                   ENDIF
      *
     C                   IF        CSD037 = 'Y'
     C                   EXSR      SRCUST
     C                   ENDIF
      *
     C                   IF        CSD038 = 'Y'
     C                   EXSR      SRDLST
     C                   ENDIF
      *
     C                   IF        CSD039 = 'Y'
     C                   EXSR      SRDTST
     C                   ENDIF
      *
     C                   IF        CSD040 = 'Y'
     C                   EXSR      SRFACT
     C                   ENDIF
      *
     C                   IF        CSD041 = 'Y'
     C                   EXSR      SRHOLI
     C                   ENDIF
      *
     C                   IF        CSD042 = 'Y'
     C                   EXSR      SRLOAN
     C                   ENDIF
      *
     C                   IF        CSD043 = 'Y'
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   IF        CSD044 = 'Y'
     C                   EXSR      SRNARR
     C                   ENDIF
      *
     C                   IF        CSD045 = 'Y'
     C                   EXSR      SRACOF
     C                   ENDIF
      *
     C                   IF        CSD046 = 'Y'
     C                   EXSR      SRCTRY
     C                   ENDIF
      *
     C                   IF        CSD047 = 'Y'
     C                   EXSR      SRLOCN
     C                   ENDIF
      *
     C                   IF        CSD048 = 'Y'
     C                   EXSR      SRREGN
     C                   ENDIF
      *
     C                   IF        CSD049 = 'Y'
     C                   EXSR      SRBRCH
     C                   ENDIF
      *
     C                   IF        CSD050 = 'Y'
     C                   EXSR      SRRECG
     C                   ENDIF
      *
     C                   IF        CSD051 = 'Y'
     C                   EXSR      SRLENO
     C                   ENDIF
      *
      ** Close any files open previously
      *
     C                   IF        CSD032 = 'Y'
     C                   CLOSE     SDAACDL2
     C                   ENDIF
      *
     C                   IF        CSD033 = 'Y'
     C                   CLOSE     SDAAKYL2
     C                   ENDIF
      *
     C                   IF        CSD034 = 'Y'
     C                   CLOSE     SDAFAKL2
     C                   ENDIF
      *
     C                   IF        CSD036 = 'Y'
     C                   CLOSE     SDASAKL2
     C                   ENDIF
      *
     C                   IF        CSD037 = 'Y'
     C                   CLOSE     SDACSTL2
     C                   ENDIF
      *
     C                   IF        CSD038 = 'Y'
     C                   CLOSE     SDADSTL2
     C                   ENDIF
      *
     C                   IF        CSD039 = 'Y'
     C                   CLOSE     SDADTSL2
     C                   ENDIF
      *
     C                   IF        CSD040 = 'Y'
     C                   CLOSE     SDAFCTL2
     C                   ENDIF
      *
     C                   IF        CSD041 = 'Y'
     C                   CLOSE     SDAHDYL2
     C                   ENDIF
      *
     C                   IF        CSD042 = 'Y'
     C                   CLOSE     SDALTSL2
     C                   ENDIF
      *
     C                   IF        CSD043 = 'Y'
     C                   CLOSE     SDACURL2
     C                   CLOSE     SDACURL4                                                 BUG12604
     C                   ENDIF
      *
     C                   IF        CSD044 = 'Y'
     C                   CLOSE     SDANARL2
     C                   ENDIF
      *
     C                   IF        CSD045 = 'Y'
     C                   CLOSE     SDAACOL2
     C                   ENDIF
      *
     C                   IF        CSD046 = 'Y'
     C                   CLOSE     SDACTYL2
     C                   ENDIF
      *
     C                   IF        CSD047 = 'Y'
     C                   CLOSE     SDALCNL2
     C                   ENDIF
      *
     C                   IF        CSD048 = 'Y'
     C                   CLOSE     SDARGNL2
     C                   ENDIF
      *
     C                   IF        CSD049 = 'Y'
     C                   CLOSE     SDABRCL2
     C                   ENDIF
      *
     C                   IF        CSD050 = 'Y'
     C                   CLOSE     SDARCGL2
     C                   ENDIF
      *
     C                   IF        CSD051 = 'Y'
     C                   CLOSE     SDALENL2
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
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
      *
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 40
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      DBPGM = 'SD000061'
      *
     C     @PLIST        PLIST
     C                   PARM                    PDATA
     C                   PARM                    PRETCODE
     C                   PARM                    PPROGRAM
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Check if switchable feature CSD032 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD032'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     1             DBASE
     C                   EVAL      DBKEY = 'CSD032'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD032 = 'Y'
     C                   OPEN      SDAACDL2
     C                   ELSE
     C                   EVAL      CSD032 = 'N'
     C                   ENDIF
      *
      ** Check if switchable feature CSD033 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD033'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     2             DBASE
     C                   EVAL      DBKEY = 'CSD033'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD033 = 'Y'
     C                   OPEN      SDAAKYL2
     C                   ELSE
     C                   EVAL      CSD033 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD034 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD034'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     3             DBASE
     C                   EVAL      DBKEY = 'CSD034'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD034 = 'Y'
     C                   OPEN      SDAFAKL2
     C                   ELSE
     C                   EVAL      CSD034 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD036 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     4             DBASE
     C                   EVAL      DBKEY = 'CSD036'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD036 = 'Y'
     C                   OPEN      SDASAKL2
     C                   ELSE
     C                   EVAL      CSD036 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD037 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD037'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     5             DBASE
     C                   EVAL      DBKEY = 'CSD037'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD037 = 'Y'
     C                   OPEN      SDACSTL2
     C                   ELSE
     C                   EVAL      CSD037 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD038 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD038'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     6             DBASE
     C                   EVAL      DBKEY = 'CSD038'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD038 = 'Y'
     C                   OPEN      SDADSTL2
     C                   ELSE
     C                   EVAL      CSD038 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD039 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD039'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     7             DBASE
     C                   EVAL      DBKEY = 'CSD039'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD039 = 'Y'
     C                   OPEN      SDADTSL2
     C                   ELSE
     C                   EVAL      CSD039 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD040 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD040'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     8             DBASE
     C                   EVAL      DBKEY = 'CSD040'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD040 = 'Y'
     C                   OPEN      SDAFCTL2
     C                   ELSE
     C                   EVAL      CSD040 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD041 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD041'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     9             DBASE
     C                   EVAL      DBKEY = 'CSD041'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD041 = 'Y'
     C                   OPEN      SDAHDYL2
     C                   ELSE
     C                   EVAL      CSD041 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD042 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     10            DBASE
     C                   EVAL      DBKEY = 'CSD042'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD042 = 'Y'
     C                   OPEN      SDALTSL2
     C                   ELSE
     C                   EVAL      CSD042 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD043 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD043'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     11            DBASE
     C                   EVAL      DBKEY = 'CSD043'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD043 = 'Y'
     C                   OPEN      SDACURL2
     C                   OPEN      SDACURL4                                                 BUG12604
     C                   ELSE
     C                   EVAL      CSD043 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD044 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD044'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     12            DBASE
     C                   EVAL      DBKEY = 'CSD044'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD044 = 'Y'
     C                   OPEN      SDANARL2
     C                   ELSE
     C                   EVAL      CSD044 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD045 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD045'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     13            DBASE
     C                   EVAL      DBKEY = 'CSD045'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD045 = 'Y'
     C                   OPEN      SDAACOL2
     C                   ELSE
     C                   EVAL      CSD045 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD046 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD046'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     14            DBASE
     C                   EVAL      DBKEY = 'CSD046'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD046 = 'Y'
     C                   OPEN      SDACTYL2
     C                   ELSE
     C                   EVAL      CSD046 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD047 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD047'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     15            DBASE
     C                   EVAL      DBKEY = 'CSD047'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD047 = 'Y'
     C                   OPEN      SDALCNL2
     C                   ELSE
     C                   EVAL      CSD047 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD048 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD048'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     16            DBASE
     C                   EVAL      DBKEY = 'CSD048'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD048 = 'Y'
     C                   OPEN      SDARGNL2
     C                   ELSE
     C                   EVAL      CSD048 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD049 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD049'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     17            DBASE
     C                   EVAL      DBKEY = 'CSD049'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD049 = 'Y'
     C                   OPEN      SDABRCL2
     C                   ELSE
     C                   EVAL      CSD049 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD050 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD050'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     18            DBASE
     C                   EVAL      DBKEY = 'CSD050'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD050 = 'Y'
     C                   OPEN      SDARCGL2
     C                   ELSE
     C                   EVAL      CSD050 = 'N'
     C                   ENDIF
      *
      *
      ** Check if switchable feature CSD051 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD051'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     19            DBASE
     C                   EVAL      DBKEY = 'CSD051'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD051 = 'Y'
     C                   OPEN      SDALENL2
     C                   ELSE
     C                   EVAL      CSD051 = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACOD - Accept Account Code routine                          *
      *                                                               *
      *****************************************************************
     C     SRACOD        BEGSR
 
     C     *LOVAL        SETLL     SDAACDL2
     C                   READ      SDAACDL2                               40
 
     C                   DOW       *IN40 = *OFF
     C                   IF        A5TYLC <> 'D'
     C                   IF        A5EACC < BJDNWD
     C                   EXSR      SRAACD2Z
     C                   EVAL      PDATA = @SDAACD
     C                   CALL      'SDACODACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDAACDL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAACDL2'
     C                   EVAL      ZDAYNO = A5EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = A5ACCN+' '+ZADATE
     C                   EVAL      DBASE = 20
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAACDL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAKEY - Accept Account Keys routine                          *
      *                                                               *
      *****************************************************************
     C     SRAKEY        BEGSR
     C     *LOVAL        SETLL     SDAAKYL2
     C                   READ      SDAAKYL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        CHTP <> 'D'
     C                   IF        EACC < BJDNWD
     C                   EVAL      PDATA = @SDAAKY
     C                   CALL      'SDAKEYACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    ACKEYALF
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAAKYL2'
     C                   EVAL      ZDAYNO = EACC
     C                   EXSR      CNVDAT
     C                   MOVE      ACD6          WACD6
     C                   EVAL      DBKEY = WACD6+' '+ZADATE
     C                   EVAL      DBASE = 21
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAAKYL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFAKY - Accept FO Account Keys routine                       *
      *                                                               *
      *****************************************************************
     C     SRFAKY        BEGSR
     C     *LOVAL        SETLL     SDAFAKL2
     C                   READ      SDAFAKL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        CHTP <> 'D'
     C                   IF        EACC < BJDNWD
     C                   EVAL      F_RECI = RECI
     C                   EVAL      F_FFKY = FFKY
     C                   EVAL      F_ZZ002 = ZZ002
     C                   EVAL      F_ACD1QQ = ACD1QQ
     C                   EVAL      F_ACD2QQ = ACD2QQ
     C                   EVAL      F_ACD3QQ = ACD3QQ
     C                   EVAL      F_ACD4QQ = ACD4QQ
     C                   EVAL      F_ACD5QQ = ACD5QQ
     C                   EVAL      F_ACD6QQ = ACD6QQ
     C                   EVAL      F_NRC1 = NRC1
     C                   EVAL      F_NRC2 = NRC2
     C                   EVAL      F_NRC3 = NRC3
     C                   EVAL      F_NRC4 = NRC4
     C                   EVAL      F_NRC5 = NRC5
     C                   EVAL      F_NRC6 = NRC6
     C                   EVAL      F_PRF1 = PRF1
     C                   EVAL      F_PRF2 = PRF2
     C                   EVAL      F_PRF3 = PRF3
     C                   EVAL      F_PRF4 = PRF4
     C                   EVAL      F_PRF5 = PRF5
     C                   EVAL      F_PRF6 = PRF6
     C                   EVAL      F_ZZ034 = ZZ034
     C                   EVAL      F_LCD = LCD
     C                   EVAL      F_CHTP = CHTP
     C                   EVAL      F_TNLU = TNLU
     C                   EVAL      F_ACD1 = ACD1
     C                   EVAL      F_ACD2 = ACD2
     C                   EVAL      F_ACD3 = ACD3
     C                   EVAL      F_ACD4 = ACD4
     C                   EVAL      F_ACD5 = ACD5
     C                   EVAL      F_ACD6 = ACD6
     C                   EVAL      F_ZONE = ZONE
     C                   EVAL      F_IUSR = IUSR
     C                   EVAL      F_AUSR = AUSR
     C                   EVAL      F_XUSR = XUSR
     C                   EVAL      F_AACC = AACC
     C                   EVAL      F_EACC = EACC
     C                   EVAL      F_GPDT = GPDT
     C                   EVAL      PDATA = @SDAFAK
     C                   CALL      'SDFAKYACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDAFAKL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAFAKL2'
     C                   EVAL      ZDAYNO = EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = FFKY+' '+ZADATE
     C                   EVAL      DBASE = 22
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAFAKL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSAKY - Accept SE Account Keys routine                       *
      *                                                               *
      *****************************************************************
     C     SRSAKY        BEGSR
     C     *LOVAL        SETLL     SDASAKL2
     C                   READ      SDASAKL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        CHTP <> 'D'
     C                   IF        EACC < BJDNWD
     C                   EVAL      K_RECI = RECI
     C                   EVAL      K_ACKE = ACKE
     C                   EVAL      K_ACD1QQ = ACD1QQ
     C                   EVAL      K_ACD2QQ = ACD2QQ
     C                   EVAL      K_ACD3QQ = ACD3QQ
     C                   EVAL      K_ACD4QQ = ACD4QQ
     C                   EVAL      K_ACD5QQ = ACD5QQ
     C                   EVAL      K_ACD6QQ = ACD6QQ
     C                   EVAL      K_NCDA1 = NCDA1
     C                   EVAL      K_NCDA2 = NCDA2
     C                   EVAL      K_NCDA3 = NCDA3
     C                   EVAL      K_NCDA4 = NCDA4
     C                   EVAL      K_NCDA5 = NCDA5
     C                   EVAL      K_NCDA6 = NCDA6
     C                   EVAL      K_PRF1 = PRF1
     C                   EVAL      K_PRF2 = PRF2
     C                   EVAL      K_PRF3 = PRF3
     C                   EVAL      K_PRF4 = PRF4
     C                   EVAL      K_PRF5 = PRF5
     C                   EVAL      K_PRF6 = PRF6
     C                   EVAL      K_LCD = LCD
     C                   EVAL      K_CHTP = CHTP
     C                   EVAL      K_TNLU = TNLU
     C                   EVAL      K_ACD1 = ACD1
     C                   EVAL      K_ACD2 = ACD2
     C                   EVAL      K_ACD3 = ACD3
     C                   EVAL      K_ACD4 = ACD4
     C                   EVAL      K_ACD5 = ACD5
     C                   EVAL      K_ACD6 = ACD6
     C                   EVAL      K_ZONE = ZONE
     C                   EVAL      K_IUSR = IUSR
     C                   EVAL      K_AUSR = AUSR
     C                   EVAL      K_XUSR = XUSR
     C                   EVAL      K_AACC = AACC
     C                   EVAL      K_EACC = EACC
     C                   EVAL      K_GPDT = GPDT
     C                   EVAL      PDATA = @SDASAK
     C                   CALL      'SDSAKYACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDASAKL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDASAKL2'
     C                   EVAL      ZDAYNO = EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = ACKE+' '+ZADATE
     C                   EVAL      DBASE = 23
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDASAKL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Accept Customer Details routine                      *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
     C     *LOVAL        SETLL     SDACSTL2
     C                   READ      SDACSTL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        BBTYLC <> 'D'
     C                   IF        BBEACC < BJDNWD
     C                   EXSR      SRACST2Z
     C                   EVAL      PDATA = @SDACST
     C                   CALL      'SDCUSTACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDACSTL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDACSTL2'
     C                   EVAL      ZDAYNO = BBEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = BBCUST+' '+ZADATE
     C                   EVAL      DBASE = 24
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDACSTL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLST - Accept Deal Type/Sub Type routine                    *
      *                                                               *
      *****************************************************************
     C     SRDLST        BEGSR
     C     *LOVAL        SETLL     SDADSTL2
     C                   READ      SDADSTL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        ASTYLC <> 'D'
     C                   IF        ASEACC < BJDNWD
     C                   EVAL      PDATA = @SDADST
     C                   CALL      'SDDLSTACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDADSTL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDADSTL2'
     C                   EVAL      ZDAYNO = ASEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = ASDSTC+' '+ZADATE
     C                   EVAL      DBASE = 25
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDADSTL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDTST - Accept Deal Type/Sub Type routine                    *
      *                                                               *
      *****************************************************************
     C     SRDTST        BEGSR
     C     *LOVAL        SETLL     SDADTSL2
     C                   READ      SDADTSL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        TYLC11 <> 'D'
     C                   IF        EACC11 < BJDNWD
     C                   EVAL      PDATA = @SDADTS
     C                   CALL      'SDDTSTACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDADTSL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDADTSL2'
     C                   EVAL      ZDAYNO = EACC11
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = DTPE11+'/'+DLST11+' '+ZADATE
     C                   EVAL      DBASE = 26
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDADTSL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFACT - Accept Facilty Type routine                          *
      *                                                               *
      *****************************************************************
     C     SRFACT        BEGSR
     C     *LOVAL        SETLL     SDAFCTL2
     C                   READ      SDAFCTL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        AMTYLC <> 'D'
     C                   IF        AMEACC < BJDNWD
     C                   EVAL      PDATA = @SDAFCT
     C                   CALL      'SDFACTACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDAFCTL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAFCTL2'
     C                   EVAL      ZDAYNO = AMEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = AMFCTY+' '+ZADATE
     C                   EVAL      DBASE = 27
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAFCTL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHOLI - Accept Holidays routine                              *
      *                                                               *
      *****************************************************************
     C     SRHOLI        BEGSR
     C     *LOVAL        SETLL     SDAHDYL2
     C                   READ      SDAHDYL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        DGTYLC <> 'D'
     C                   IF        DGEACC < BJDNWD
     C                   EVAL      PDATA = @SDAHDY
     C                   CALL      'SDHOLIACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDAHDYL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAHDYL2'
     C                   EVAL      ZDAYNO = DGEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = DGCYCD+' '+DGLCCD+' '+DGYRNB+' '
     C                                     +ZADATE
     C                   EVAL      DBASE = 28
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAHDYL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAN - Accept Loan Type/Sub-Type routine                    *
      *                                                               *
      *****************************************************************
     C     SRLOAN        BEGSR
     C     *LOVAL        SETLL     SDALTSL2
     C                   READ      SDALTSL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        AYTYLC <> 'D'
     C                   IF        AYEACC < BJDNWD
     C                   EVAL      L_PLDPCD = PLDPCD
     C                   EVAL      L_PLDRCD = PLDRCD
     C                   EVAL      L_PLCRED = PLCRED
     C                   EVAL      PDATA = @SDALTS
     C                   CALL      'SDLOANACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDALTSL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDALTSL2'
     C                   EVAL      ZDAYNO = AYEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = AYLNTY+'/'+AYLNST+' '+
     C                                     ZADATE
     C                   EVAL      DBASE = 28
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDALTSL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR - Accept Currencies Details routine                    *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
     C     *LOVAL        SETLL     SDACURL2
     C                   READ      SDACURL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        A6TYLC <> 'D'
     C                   IF        A6EACC < BJDNWD
     C                   EXSR      SRACUR2Z
     C                   EVAL      PDATA = @SDACUR
     C                   CALL      'SDCURRACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      KCyCd = A6CYCD                                           BUG12604
     C     KCyCd         CHAIN     SDACURL4                                                 BUG12604
     C                   IF        %FOUND                                                   BUG12604
     C                   DELETE    SDACURL4                                                 BUG12604
     C                   ENDIF                                                              BUG12604
     C**********         DELETE    SDACURL2                                                 BUG12604
     C                   ELSE
     C                   EVAL      DBFILE = 'SDACURL2'
     C                   EVAL      ZDAYNO = A6EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = A6CYCD+' '+ZADATE
     C                   EVAL      DBASE = 29
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDACURL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNARR - Accept Narrative Codes routine                       *
      *                                                               *
      *****************************************************************
     C     SRNARR        BEGSR
     C     *LOVAL        SETLL     SDANARL2
     C                   READ      SDANARL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        ALTYLC <> 'D'
     C                   IF        ALEACC < BJDNWD
     C                   EVAL      PDATA = @SDANAR
     C                   CALL      'SDNARRACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDANARL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDANARL2'
     C                   EVAL      ZDAYNO = ALEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = ALNVCD+' '+ZADATE
     C                   EVAL      DBASE = 30
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDANARL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACOF - Accept Account Officer routine                       *
      *                                                               *
      *****************************************************************
     C     SRACOF        BEGSR
     C     *LOVAL        SETLL     SDAACOL2
     C                   READ      SDAACOL2                               40
 
     C                   DOW       *IN40 = *OFF
 
     C                   IF        AZTYLC <> 'D'
     C                   IF        AZEACC < BJDNWD
     C                   EXSR      SRAACO2Z
     C                   EVAL      PDATA = @SDAACO
     C                   CALL      'SDACOFACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDAACOL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDAACOL2'
     C                   EVAL      ZDAYNO = AZEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = AZACOC+' '+ZADATE
     C                   EVAL      DBASE = 31
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDAACOL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCTRY - Accept Country Code routine                          *
      *                                                               *
      *****************************************************************
     C     SRCTRY        BEGSR
     C     *LOVAL        SETLL     SDACTYL2
     C                   READ      SDACTYL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        A4TYLC <> 'D'
     C                   IF        A4EACC < BJDNWD
     C                   EVAL      PDATA = @SDACTY
     C                   CALL      'SDCTRYACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDACTYL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDACTYL2'
     C                   EVAL      ZDAYNO = A4EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = A4CNCD+' '+ZADATE
     C                   EVAL      DBASE = 32
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDACTYL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOCN - Accept Location Code routine                         *
      *                                                               *
      *****************************************************************
     C     SRLOCN        BEGSR
     C     *LOVAL        SETLL     SDALCNL2
     C                   READ      SDALCNL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        DVTYLC <> 'D'
     C                   IF        DVEACC < BJDNWD
     C                   EVAL      PDATA = @SDALCN
     C                   CALL      'SDLOCNACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDALCNL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDALCNL2'
     C                   EVAL      ZDAYNO = DVEACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = DVLCCD+' '+ZADATE
     C                   EVAL      DBASE = 33
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDALCNL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREGN - Accept Region Code routine                           *
      *                                                               *
      *****************************************************************
     C     SRREGN        BEGSR
     C     *LOVAL        SETLL     SDARGNL2
     C                   READ      SDARGNL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        A3TYLC <> 'D'
     C                   IF        A3EACC < BJDNWD
     C                   EVAL      PDATA = @SDARGN
     C                   CALL      'SDREGNACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDARGNL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDARGNL2'
     C                   EVAL      ZDAYNO = A3EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = A3RGCD+' '+ZADATE
     C                   EVAL      DBASE = 34
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDARGNL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBRCH - Accept Branch Code routine                           *
      *                                                               *
      *****************************************************************
     C     SRBRCH        BEGSR
     C     *LOVAL        SETLL     SDABRCL2
     C                   READ      SDABRCL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        A8TYLC <> 'D'
     C                   IF        A8EACC < BJDNWD
     C                   EXSR      SRABRC2Z
     C                   EVAL      PDATA = @SDABRC
     C                   CALL      'SDBRCHACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDABRCL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDABRCL2'
     C                   EVAL      ZDAYNO = A8EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = A8BRCD+' '+ZADATE
     C                   EVAL      DBASE = 35
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDABRCL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRECG - Accept RE Customer Group routine                     *
      *                                                               *
      *****************************************************************
     C     SRRECG        BEGSR
     C     *LOVAL        SETLL     SDARCGL2
     C                   READ      SDARCGL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        CHTP <> 'D'
     C                   IF        EACC < BJDNWD
     C                   EVAL      R_RECI = RECI
     C                   EVAL      R_LCD  = LCD
     C                   EVAL      R_CHTP = CHTP
     C                   EVAL      R_TNLU = TNLU
     C                   EVAL      R_ZONE = ZONE
     C                   EVAL      R_IUSR = IUSR
     C                   EVAL      R_AUSR = AUSR
     C                   EVAL      R_XUSR = XUSR
     C                   EVAL      R_AACC = AACC
     C                   EVAL      R_EACC = EACC
     C                   EVAL      R_GPDT = GPDT
     C                   EVAL      PDATA = @SDARCG
     C                   CALL      'SDRECGACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDARCGL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDARCGL2'
     C                   EVAL      ZDAYNO = EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = GRPN+' '+ZADATE
     C                   EVAL      DBASE = 36
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDARCGL2                               40
     C                   ENDDO
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLENO - Accept Loan Number Ranges routine                    *
      *                                                               *
      *****************************************************************
     C     SRLENO        BEGSR
     C     *LOVAL        SETLL     SDALENL2
     C                   READ      SDALENL2                               40
     C                   DOW       *IN40=*OFF
     C                   IF        F9TYLC <> 'D'
     C                   IF        F9EACC < BJDNWD
     C                   EVAL      PDATA = @SDALEN
     C                   CALL      'SDLENOACP'   @PLIST
 
     C                   IF        PRetCode = *BLANKS
     C                   DELETE    SDALENL2
     C                   ELSE
     C                   EVAL      DBFILE = 'SDALENL2'
     C                   EVAL      ZDAYNO = F9EACC
     C                   EXSR      CNVDAT
     C                   EVAL      DBKEY = F9RGNB+' '+ZADATE
     C                   EVAL      DBASE = 37
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      SDALENL2                               40
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CNVDAT - Convert Effective Date                               *
      *                                                               *
      *****************************************************************
     C     CNVDAT        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAACD2Z - Convert A/c Code Acceptance to screen format.      *
      *                                                               *
      *****************************************************************
     C     SRAACD2Z      BEGSR
 
     C                   MOVE      A5LCD         ACLCD1
     C                   MOVE      A5TYLC        ACCHTP
     C                   MOVE      A5ACTY        ACACTY
     C                   MOVE      A5ACCN        ACACCN
     C                   MOVE      A5SRLC        ACSRLC1
     C                   MOVE      A5SRFC        ACSRFC1
     C                   MOVE      A5TOIN        ACTOIN
     C                   MOVE      A5RPCD        ACRPCD1
     C                   MOVE      A5ACSC        ACACSC
     C                   MOVE      A5ACST        ACACST
     C                   MOVE      A5ACPR        ACACPR1
     C                   MOVE      A5TRFD        ACTRFD
     C                   MOVE      A5MISU        ACMISU1
     C                   MOVE      A5ACGC        ACACGC
     C                   MOVE      A5INNR        ACINNR
     C                   MOVE      A5MAPC        ACMAPC
     C                   MOVE      A5MABK        ACMABK
     C                   MOVE      A5MAAC        ACMAAC
     C                   MOVE      A5MATR        ACMATR
     C                   MOVE      A5MAPR        ACMAPR
     C                   MOVE      A5FNAC        ACFNAC
     C                   MOVE      A5FNBR        ACFNBR
     C                   MOVE      A5CAAC        ACCAAC
     C                   MOVE      A5TIAT        ACTIAT
     C                   MOVE      A5TFCT        ACTFCT
     C                   MOVE      A5VOST        ACVOST
     C                   MOVE      A5LORO        ACLORO
     C                   MOVE      A5NARR        ACDESC
     C                   MOVE      A5ZONE        ACZONE
     C                   MOVE      A5ACCD        ACGACD
     C                   MOVE      A5CIAD        ACCIAD
     C                   MOVE      A5CIAC        ACCIAC
     C                   MOVE      A5DIAC        ACDIAC
     C                   MOVE      A5DIAD        ACDIAD
     C                   MOVE      A5ICIC        ACICIC
     C                   MOVE      A5ICID        ACICID
     C                   MOVE      A5DIPD        ACDIPD
     C                   MOVE      A5DIPC        ACDIPC
     C                   MOVE      A5CIPC        ACCIPC
     C                   MOVE      A5CISU        ACCISU
     C                   MOVE      A5CINS        ACCINS
     C                   MOVE      A5WTAC        ACWTAC
     C                   MOVE      A5FNIC        ACFNIC
     C                   MOVE      A5FNAA        ACFNAA
     C                   MOVE      A5TRDA        ACTRDA1
     C                   MOVE      A5TRCA        ACTRCA1
     C                   MOVE      A5TRAN        ACTRAN
     C                   MOVE      A5IUSR        ACIUSR
     C                   MOVE      A5AUSR        ACCUSR
     C                   MOVE      A5XUSR        ACXUSR
     C                   MOVE      A5AACC        ACAACC
     C                   MOVE      A5EACC        ACEACC1
     C                   MOVE      A5GPDT        ACGPDT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAACO2Z - Convert A/c Officer Acceptance to screen format.   *
      *                                                               *
      *****************************************************************
     C     SRAACO2Z      BEGSR
 
     C                   MOVE      AZLCD         A_ZZLCD
     C                   MOVE      AZACOT        ZZACOT
     C                   MOVE      AZEACC        A_ZZEACC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRABRC2Z - Convert Branch Code Acceptance to screen format.   *
      *                                                               *
      *****************************************************************
     C     SRABRC2Z      BEGSR
 
     C                   MOVE      A8LCD         Z8LCD
     C                   MOVE      A8STCD        Z8STCD
     C                   MOVE      A8SUOP        Z8SUOP
     C                   MOVE      A8SUCL        Z8SUCL
     C                   MOVE      A8MOOP        Z8MOOP
     C                   MOVE      A8MOCL        Z8MOCL
     C                   MOVE      A8TUOP        Z8TUOP
     C                   MOVE      A8TUCL        Z8TUCL
     C                   MOVE      A8WEOP        Z8WEOP
     C                   MOVE      A8WECL        Z8WECL
     C                   MOVE      A8THOP        Z8THOP
     C                   MOVE      A8THCL        Z8THCL
     C                   MOVE      A8FYOP        Z8FYOP
     C                   MOVE      A8FYCL        Z8FYCL
     C                   MOVE      A8SAOP        Z8SAOP
     C                   MOVE      A8SACL        Z8SACL
     C                   MOVE      A8SYCU        Z8SYCU
     C                   MOVE      A8EDAT        Z8EDAT
     C                   MOVE      A8COTI        Z8COTI
     C                   MOVE      A8TCPP        Z8TCPP
     C                   MOVE      A8TMOF        Z8TMOF
     C                   MOVE      A8STOF        Z8STOF
     C                   MOVE      A8EACC        Z8EACC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACUR2Z - Convert Currency Code Acceptance to screen format. *
      *                                                               *
      *****************************************************************
     C     SRACUR2Z      BEGSR
 
     C                   MOVEL     A6CYNM        ZZDESC
     C                   MOVE      A6NBDP        Z6NBDP
     C                   MOVE      A6SPRT        ZZSPRT
     C                   MOVE      A6LCD         Z6LCD
     C                   MOVE      A6AUSR        GCCUSR
     C                   MOVE      A6TXND        Z6TXND
     C                   MOVE      A6PRRT        Z6PRRT
     C                   MOVE      A6SRC1        Z6SRC1
     C                   MOVE      A6SRC2        Z6SRC2
     C                   MOVE      A6SSNB        Z6SSNB
     C                   MOVE      A6ERLC        Z6ERLC
     C                   MOVE      A6SPDY        Z6SPDY
     C                   MOVE      A6HSRT        Z6HSRT
     C                   MOVE      A6LSPR        Z6LSPR
     C                   MOVE      A6FXSD        Z6FXSD
     C                   MOVE      A6MMSD        Z6MMSD
     C                   MOVE      A6NQDP        Z6NQDP
     C                   MOVE      A6SCEX        Z6SCEX
     C                   MOVE      A6HBRT        Z6HBRT
     C                   MOVE      A6ENC1        Z6ENC1
     C                   MOVE      A6ENC2        Z6ENC2
     C                   MOVE      A6CNMC        Z6CNMC
     C                   MOVE      A6DPBF        Z6DPBF
     C                   MOVE      A6BYSR        Z6BYSR
     C                   MOVE      A6SLSR        Z6SLSR
     C                   MOVE      A6RMCM        Z6RMCM
     C                   MOVE      A6RKSQ        Z6RKSQ
     C                   MOVE      A6TKCC        Z6TKCC
     C                   MOVE      A6CQCD        Z6CQCD
     C                   MOVE      A6SMLD        Z6SMLD
     C                   MOVE      A6ISON        Z6ISON
     C                   MOVE      A6EUER        Z6EUER
     C                   MOVE      A6TPSD        Z6TPSD
     C                   MOVE      A6TPED        Z6TPED
     C                   MOVE      A6INER        Z6INER
     C                   MOVE      A6EXWC        Z6EXWC
     C                   MOVE      A6POWC        Z6POWC
     C                   MOVE      A6CYD1        Z6CYD1
     C                   MOVE      A6CYD2        Z6CYD2
     C                   MOVE      A6CYD3        Z6CYD3
     C                   MOVE      A6RENO        Z6RENO
     C                   MOVE      A6SWDP        Z6SWDP
     C                   MOVE      A6SWDT        Z6SWDT
     C                   MOVE      A6EFDT        Z6EFDT
     C                   MOVE      A6DFTS        Z6DFTS
     C                   MOVE      A6SRTM        ZZSRTM
     C                   MOVE      A6SETD        Z6SETD
     C                   MOVE      A6IRDP        Z6IRDP
     C                   MOVE      A6FXDY        Z6FXDY
     C                   MOVE      A6EACC        Z6EACC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACST2Z - Convert Customer Acceptance to screen format.      *
      *                                                               *
      *****************************************************************
     C     SRACST2Z      BEGSR
 
     C                   MOVEL     BBCUST        CUGCUS
     C                   MOVEL     BBACOC        CUGACO
     C                   MOVE      BBCHID        CUCHID
     C                   MOVE      BBCHSC        CUCHSC
     C                   MOVE      BBCABA        CUCABA
     C                   MOVE      BBABA2        CUABA2
     C                   MOVE      BBFWCD        CUFWCD
     C                   MOVE      BBDOIC        CUDOIC
     C                   MOVE      BBSSDT        CUSSDT
     C                   MOVE      BBDTDL        CUDTDL
     C                   MOVE      BBLCD         CULCD
     C                   MOVE      BBDEDT        CUDEDT
     C                   MOVE      BBMGTP        CUMGTP
     C                   MOVE      BBEACC        CUEACC
 
     C                   ENDSR
      *****************************************************************
      *
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
     C                   CALL      'DBERRCTL'
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
