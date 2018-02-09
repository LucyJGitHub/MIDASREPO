     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD AML Corp. Details Import Table Populator')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000021 - AML Corporate Details Import Table Populator      *
      *                                                               *
      *  Function:  This module populates the AML Corporate Details   *
      *             Import Table by using Customer, Local Industry    *
      *             Code, and Account Officer details.                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 MD033670           Date 23Jun15               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 06Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3031            Date 03Jun02               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD033670 - BNI SG Midas to SAM Interface File Duplicate Data *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3031 - Compliance Watch AML export data corrections       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
      ** AML Corporate Details Import Table
      *
     F***SDCORIPD  IF A E             DISK    INFSR(*PSSR)                                  MD033670
     FSDCORIL0  IF A E           K DISK    INFSR(*PSSR)                                     MD033670
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structure. They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** First DS for access programs, short data structure                                  BUG3031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG3031
                                                                                             BUG3031
      ** External DS for SAR details                                                         BUG3031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3031
      *
      ** Program Parameters
      ** ==================
      *
      ** Customer Details Data Structure
      *
     D CustDet       E DS                  EXTNAME(SDCUSTPD)
      *
      ** Additional Customer Details Data Structure
      *
     D AddCustDet    E DS                  EXTNAME(SDACUSPD)
      *
      ** Account Officer Details Data Structure
      *
     D AccOffDet     E DS                  EXTNAME(SDACOFPD)
      *
      ** Local Industry Code Details Data Structure
      *
     D LocIndCdeDet  E DS                  EXTNAME(SDINDSPD)
      *
      ** Parent Customer Details Data Structure
      *
     D PrntDet       E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(CD:2)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Additional Parent Customer Details Data Structure
      *
     D AddPrntDet    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(AD:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Program Parameter
      *
     D PMode           S              1
 
      **  Switchable Feature                                                                 BUG3031
     D CGP001          S              1A                                                     BUG3031
                                                                                             BUG3031
      ** Access Object Parameters                                                            BUG3031
     D PRtCd           S              7A                                                     BUG3031
     D POptn           S              7A                                                     BUG3031
     D PSard           S              6A                                                     BUG3031
                                                                                             BUG3031
     D KYCOCD          S             20A                                                    MD033670
                                                                                            MD033670
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *
      ** Initialise the relevant Import Table fields.
      *
     C                   IF        CGP001 = 'Y'                                              BUG3031
     C                   IF        BBBRCD <> *BLANK AND BBCUST <> *BLANK                     BUG3031
     C                   EVAL      X2COCD = BBBRCD + '-' + BBCUST                            BUG3031
     C                   ENDIF                                                               BUG3031
     C                   ELSE                                                                BUG3031
     C                   EVAL      X2COCD = BBCUST
     C                   ENDIF                                                               BUG3031
     C                   EVAL      X2CONM = BBCNA1
     C                   EVAL      X2COTP = BBLINC
     C                   EVAL      X2BDES = AOLINA
     C                   EVAL      X2COA1 = BBCNA1
     C                   EVAL      X2COA2 = BBCNA2
     C                   EVAL      X2COA3 = BBCNA3
     C                   EVAL      X2COA4 = BBCNA4
     C                   EVAL      X2COTN = BBCTNB
     C                   EVAL      X2COFX = E5FXNB
     C                   EVAL      X2HQNM = CDCNA1
     C                   IF        CGP001 = 'Y'                                              BUG3031
     C                   IF        CDBRCD <> *BLANK AND CDCUST <> *BLANK                     BUG3031
     C                   EVAL      X2HQCD = CDBRCD + '-' + CDCUST                            BUG3031
     C                   ENDIF                                                               BUG3031
     C                   ELSE                                                                BUG3031
     C                   EVAL      X2HQCD = CDCUST
     C                   ENDIF                                                               BUG3031
     C                   EVAL      X2HQA1 = CDCNA1
     C                   EVAL      X2HQA2 = CDCNA2
     C                   EVAL      X2HQA3 = CDCNA3
     C                   EVAL      X2HQA4 = CDCNA4
     C                   EVAL      X2HQTN = CDCTNB
     C                   EVAL      X2HQFX = ADFXNB
     C                   EVAL      X2CSTS = BBRWCD
     C                   EVAL      X2RMGR = AZACON
      *
     C                   IF        PMode = 'A'
     C                   EVAL      X2ACTN = 'I'
     C                   ELSE
     C                   EVAL      X2ACTN = BBTYLC
     C                   ENDIF
      *
      ** Add the collected information to the Import Table.
      *
     C                   CLEAR                   KYCOCD                                     MD033670
     C                   EVAL      KYCOCD = X2COCD                                          MD033670
      *                                                                                     MD033670
     C     KYCOCD        CHAIN     SDCORIL0                                                 MD033670
     C                   IF        NOT %FOUND(SDCORIL0)                                     MD033670
      *                                                                                     MD033670
     C                   WRITE     SDCORID0
      *                                                                                     MD033670
     C                   ENDIF                                                              MD033670
      *
     C                   EVAL      *INLR = True
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Subroutine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter List
      ** ==============
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters:
      *
      ** Mode
      ** Customer Details
      ** Additional Customer Details
      ** Account Officer Details
      ** Local Industry Code Details
      ** Parent Customer Details
      ** Parent Customer Additional Details
      *
     C                   PARM                    PMode
     C                   PARM                    CustDet
     C                   PARM                    AddCustDet
     C                   PARM                    AccOffDet
     C                   PARM                    LocIndCdeDet
     C                   PARM                    PrntDet
     C                   PARM                    AddPrntDet
      *
      ** End of Parameter List
      ** =====================
                                                                                             BUG3031
      ** Determine if Global Processing (CGP001) enhancement is on.                          BUG3031
                                                                                             BUG3031
     C                   EVAL      CGP001 = 'N'                                              BUG3031
                                                                                             BUG3031
     C                   CALL      'AOSARDR0'                                                BUG3031
     C                   PARM      *BLANKS       PRtCd                                       BUG3031
     C                   PARM      '*VERIFY'     POptn                                       BUG3031
     C                   PARM      'CGP001'      PSard                                       BUG3031
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3031
                                                                                             BUG3031
     C                   IF        PRtCd <> *BLANKS                                          BUG3031
     C                             AND PRtCd <> '*NRF   '                                    BUG3031
     C     *LOCK         IN        LDA                                                       BUG3031
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3031
     C                   EVAL      DBKEY  = 'CGP001'                                         BUG3031
     C                   Z-ADD     1             DBASE                                       BUG3031
     C                   OUT       LDA                                                       BUG3031
     C                   EXSR      *PSSR                                                     BUG3031
     C                   ENDIF                                                               BUG3031
                                                                                             BUG3031
     C                   IF        PRtCd = *BLANKS                                           BUG3031
     C                   EVAL      CGP001 = 'Y'                                              BUG3031
     C                   ENDIF                                                               BUG3031
                                                                                             BUG3031
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------------------------------+
      ** ¦ Program, module, and procedure        ¦
      ** ¦ names for DB error processing         ¦
      ** ¦ =============================         ¦
      ** +---------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY includes the DB error processing routines.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2002
