     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account maintenance screen 4 defaults')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD4DT  - GL Commission and Overrides Defaults (scrn 4)   *
      *                                                               *
      *  Function: This Program Defaults fields                       *
      *            for Commissions and Overrides screen               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG22573           Date 04Feb09               *
      *                 CER047             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Feb00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176842  *CREATE    Date 30May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165  - Dual Withholding Tax (Recompile)                   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  BUG22573 - Avoid DB error in case of *NRF for AOCURRR0       *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  176842 - Dedicated module for defaulting values to 4th screen*
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Customer Group Code
     FTABLEV4   IF   E             DISK    INFSR(*PSSR)

      ** Retail ICD by currency
     FRECCY     IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array Index
     D Idx1            S              2P 0 INZ(0)

      ** Client Group Code
     D GRP             S              1    DIM(8)
      ** Account Commission Indicators
     D AIN1            S              1    DIM(8)
      ** Max. Dr. Balance Commission Indicators
     D AIN2            S              1    DIM(8)
      ** Debit Interest Commission Indicators
     D AIN3            S              1    DIM(8)
      ** Inactive Commission Indicators
     D AIN4            S              1    DIM(8)
      ** Minimum Balance Indicators
     D AIN5            S              1    DIM(8)
      ** Daily Statement Commission Indicators
     D AIN6            S              1    DIM(8)
      ** Fixed Commission Indicators
     D AIN7            S              1    DIM(8)

     D   ZFIELD        S             16A

     D   ZADEC         S              1P 0

      ** DATA STRUCTURE TO GET THE RIGHT CUSTOMER GROUP
     D                 DS
     D  ZZ010                  1     10
     D  CGRP                  10     10

      * Account in File Format
     D AccnFilFmt    E DS                  EXTNAME(GLVAMADPD)
     D ExBXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExRIFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExCOFilFmt    E DS                  EXTNAME(GLVAMCOPD)
     D GLCOACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D ExPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)
     D GLPWACOD      E                     EXTFLD(QQACOD)                                     CGL029

      * Account in Screen Format
     D AccScnMast    E DS                  EXTNAME(GLAMADPD)
     D AccScnDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccScnCred    E DS                  EXTNAME(GLAMCIPD)
     D AccScnComm    E DS                  EXTNAME(GLAMCOPD)
     D AccScnOthe    E DS                  EXTNAME(GLAMODPD)

      * External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      * Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CDE002          S              1A                                        CDE002
     D DDDRMG1         S             12A                                        CDE002
     D DDCRMG1         S             12A                                        CDE002

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Initial Processing
     C                   EXSR      INIT

      *
      *  Rerieve default commisions
      *
     C                   EXSR      SRRTVCG
     C                   EXSR      SRRTVCM

      * RETURN
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTVCG - Routine to retrieve and validate customer group
      *****************************************************************
     C     SRRTVCG       BEGSR
      *
      ** CHECK IF CUSTOMER GROUP IS OK
     C                   Z-ADD     1             IDX1
     C     @BCGRP        LOOKUP    GRP(Idx1)                              10
      *
     C     *IN10         IFNE      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     AMCNUM        DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRTVCM - Routine to retrieve defaults for commissions
      *****************************************************************
     C     SRRTVCM       BEGSR
      *
      ** Initialize/reset fields
     C                   MOVEL     *BLANKS       DDCEXA1
     C                   MOVEL     *BLANKS       DDCEXB1
     C                   MOVEL     *BLANKS       DDCEXC1
     C                   MOVEL     *BLANKS       DDCEXD1
     C                   MOVEL     *BLANKS       DDCEXE1
     C                   MOVEL     *BLANKS       DDCEXF1
     C                   MOVEL     *BLANKS       DDCEXG1
     C                   MOVEL     *BLANKS       DDDRMG1                        CDE002
     C                   MOVEL     *BLANKS       DDCRMG1                        CDE002
      *
      ** Setup key
     C                   MOVEL     *BLANKS       K1FLD1           12
     C                   MOVEL     *BLANKS       WU004A            4
     C                   MOVEL     AMCCY         WU004A
     C                   MOVE      'D'           WU004A
     C                   MOVE      WU004A        K1FLD1
      *
      ** Retrieve defaults
     C     K1FLD1        CHAIN     RECCY                              99
      *
     C     *IN99         IFEQ      '0'
      *
      ** A - Highest overdraft commission
     C     AIN2(IDX1)    IFEQ      'Y'
     C                   MOVE      HORT          ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXA1= %SUBST(ZOUT21:10:12)
     C                   ENDIF
      *
      ** B - Turnover commission
     C     AIN1(IDX1)    IFEQ      'Y'
     C                   MOVE      ACRT          ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXB1= %SUBST(ZOUT21:10:12)
     C                   ENDIF
      *
      ** C - Debit interest commission
     C     AIN3(IDX1)    IFEQ      'Y'
     C                   MOVE      DIRT          ZFLD15
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXC1= %SUBST(ZOUT21:10:12)
     C                   ENDIF
      *
      ** D - Inactive account commission
     C     AIN4(IDX1)    IFEQ      'Y'
     C                   MOVE      INFC          ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXD1= %SUBST(ZOUT21:13:9)
     C                   ENDIF
      *
      ** E - Minimum CR balance commission
     C     AIN5(IDX1)    IFEQ      'Y'
      *
      ** Current or Savings?
     C     AMSTYP        IFEQ      'S'
     C                   MOVE      MSFC          ZFLD15
     C                   ELSE
     C                   MOVE      MCFC          ZFLD15
     C                   ENDIF
      *
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXE1= %SUBST(ZOUT21:13:9)
     C                   ENDIF
      *
      ** F - Extra daily statement commission
     C     AIN6(IDX1)    IFEQ      'Y'
     C     DDSTFQ        IFEQ      'E'
     C                   MOVE      DSFC          ZFLD15
     C                   ELSE
     C                   MOVE      *ZEROS        ZFLD15
     C                   ENDIF
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXF1= %SUBST(ZOUT21:13:9)
     C                   ENDIF
      *
      ** G - Fixed commission
     C     AIN7(IDX1)    IFEQ      'Y'
     C                   MOVE      FCFC          ZFLD15
     C                   EVAL      ZDECS=A6NBDP
     C                   EXSR      FMTAMT
     C                   EVAL      DDCEXG1= %SUBST(ZOUT21:13:9)
     C                   ENDIF
      *
      ** CCRM Revenue Analysis                                                  CDE002
     C     CDE002        IFEQ      'Y'                                          CDE002
      *                                                                         CDE002
      ** Debit Margin Rate                                                      CDE002
     C     BXOVRD        IFNE      'Y'                                          208221
     C                   MOVE      DRMG          ZFLD15                         CDE002
     C                   EVAL      ZDECS=7                                      CDE002
     C                   EXSR      FMTAMT                                       CDE002
     C                   EVAL      DDDRMG1= %SUBST(ZOUT21:9:12)                 CDE002
     C                   ENDIF                                                  208221
      *                                                                         CDE002
      ** Credit Margin Rate                                                     CDE002
     C     BXOVRC        IFNE      'Y'                                          208221
     C                   MOVE      CRMG          ZFLD15                         CDE002
     C                   EXSR      FMTAMT                                       CDE002
     C                   EVAL      DDCRMG1= %SUBST(ZOUT21:9:12)                 CDE002
     C                   ENDIF                                                  208221
      *                                                                         CDE002
     C                   ENDIF                                                  CDE002
      *                                                                         CDE002
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      ZFLD15 = *ZEROS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INIT - INITIALIZATION                                        *
      *****************************************************************

     C     INIT          BEGSR
      *
      ** Get the currency decimal places of accounting ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      AMCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'                                                   BUG22573
     C                   MOVEL     AMCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      *PSSR                                        ************
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    RetCodeIn

      * Customer Retail Group
     C                   PARM                    @BCGRP            1

      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                CDE002
      * Account in file format
     C                   PARM                    AccnFilFmt
      * Valid Account layout (extension file) (DS) from/to caller               208221
     C                   PARM                    ExBXFilFmt                     208221

      * OUTPUTS
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1                        CDE002
     C                   PARM                    DDCRMG1                        CDE002
      *                                                                         CDE002

      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'GLAMAD4DT'   DBPGM
     C                   Out       LDA

      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      *
      ** READ UP TO EIGHT GROUP RECORDS AND STORE RELEVANT DETAILS
      ** IN INTERNAL ARRAYS
      *
     C                   Z-ADD     0             IDX1
     C                   Move      *Off          *IN10
     C     1             SETLL     TABLEV4F
      *
     C     *IN10         DOUEQ     *On
     C                   READ      TABLEV4F                               10
     C     *IN10         IFEQ      *Off
     C                   ADD       1             Idx1
     C                   MOVE      CGRP          GRP(Idx1)
     C                   MOVE      ACMI          AIN1(Idx1)
     C                   MOVE      MDBI          AIN2(Idx1)
     C                   MOVE      DINI          AIN3(Idx1)
     C                   MOVE      INAI          AIN4(Idx1)
     C                   MOVE      MINI          AIN5(Idx1)
     C                   MOVE      DYSI          AIN6(Idx1)
     C                   MOVE      FIXI          AIN7(Idx1)
      *
      ** ONLY EIGHT CUSTOMER GROUP ARE POSSIBLE
      *
     C     Idx1          IFEQ      8
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
