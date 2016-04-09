     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Export account details into AML database')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000023 - Export Account Details Into AML Database          *
      *                                                               *
      *  Function:  This program will export details of the Midas     *
      *             account holdings into the AML database            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
 
     FACCNTAB   IF   E             DISK    INFSR(*PSSR)
      ** Accounts Master Detail File
 
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      ** Accounts Master Detail File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PAccDetls     E DS                  EXTNAME(ACCNTAB)
      ** External DS for Accounts Master Detail File
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** External DS for Compliance Watch Configuration Data File
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7A
     D POption         S              7A
     D*PAcCod***       S              4A                                                      CGL029
     D PAcCod          S             10A                                                      CGL029
 
     D PMode           S              1A
     D KCNUM           S              6A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read through all of the Midas accounts in ACCNTAB
 
     C                   READ      ACCNTAB                                01
     C                   DOW       *IN01 = *OFF
 
      ** For each record read, if Mode is 'A' or 'C' and last movement date of
      ** the account is equal to the rundate,
 
     C                   IF        (PMode = 'A') OR
     C                             (PMode = 'C' AND (LMVD = BJRDNB
     C                                               OR DACO = BJRDNB
     C                                               OR LCD = BJRDNB))
 
     C                   MOVE      CNUM          KCNUM
     C     KCNUM         CHAIN     SDBRCHL5                           02
 
      ** If Account Export Indicator is 'A' or 'C' and Account Type is is not
      ** 'G'
 
     C                   IF        W1AEIN = 'A' OR W1AEIN = 'C' AND
     C                             *IN02 = *ON
 
      ** Retrieve account code details
 
     C                   MOVEL     ACOD          PAcCod
     C                   EXSR      SrRtvACCO
 
      ** Call the module that populates the AML Account Holdings Details
      ** Import Table
 
     C                   IF        PMode = 'A' OR (DACO = BJRDNB
     C                             OR DACC = BJRDNB)
     C                   CALL      'SD000024'
     C                   PARM                    PMode
     C                   PARM                    PAccDetls
     C                   ENDIF
 
      ** Call the module that populates the AML Account Details Import Table
      ** Import Table
 
     C                   CALL      'SD000025'
     C                   PARM                    PMode
     C                   PARM                    PAccDetls
     C                   PARM                    SDACOD
     C                   PARM                    SDCWCD
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      ACCNTAB                                01
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvACCO - Retrieve Account Code Details File               *
      *                                                               *
      *****************************************************************
     C     SrRtvACCO     BEGSR
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcCod
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** If no record is found, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PAcCod
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
 
      ** Retrieve Bank Details by calling AOBANKR0
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If no record is found, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Compliance Watch Configuration Data File
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** If no record is found, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDCWCDPD'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
