     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Populate AML Cust. Details Import Table')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000022 - Populate AML Customer Details Import Table        *
      *                                                               *
      *  Function:  This program will populate the AML Customer       *
      *             details import table (PF/SDCUSIPD).               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
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
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCUSIPD  IF A E             DISK    INFSR(*PSSR)
 
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
 
      **  Customer Details
     D PCustDetls    E DS                  EXTNAME(SDCUSTPD)
 
      **  Additional Customer Details
     D PAdCustdet    E DS                  EXTNAME(SDACUSPD)
 
      **  Account Officer Details
     D PAcOfcrDet    E DS                  EXTNAME(SDACOFPD)
 
      **  Switchable Feature Details                                                         BUG3031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3031
                                                                                             BUG3031
      **  Short Access Object Data Structure                                                 BUG3031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG3031
                                                                                             BUG3031
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PMode           S              1
 
      ** Parameter for ZACVTDATE
     D PRtrnCode       S             10
     D PInDate         S              5
     D POutDate        S               D
     D PCvtdDate       S             10
 
      ** Access Object Parameters                                                            BUG3031
     D PRtCd           S              7A                                                     BUG3031
     D POptn           S              7A                                                     BUG3031
     D PSARD           S              6A                                                     BUG3031
                                                                                             BUG3031
      ** Switchable Features                                                                 BUG3031
     D CGP001          S              1A                                                     BUG3031
                                                                                             BUG3031
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
 
      **  Fill up fields for SDCUSIPD.
 
      **  Switch to global customer format if CGP001 is enabled.                             BUG3031
                                                                                             BUG3031
     C                   IF        CGP001 = 'Y'                                              BUG3031
     C                   EVAL      X3CUCD = BBBRCD + '-' + BBCUST                            BUG3031
     C                   ELSE                                                                BUG3031
     C                   EVAL      X3CUCD = BBCUST
     C                   ENDIF                                                               BUG3031
 
     C                   CLEAR                   X3BRTH
     C                   IF        E5BRTH <> 0
     C                   MOVE      E5BRTH        PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X3BRTH = PCvtdDate
     C                   ENDIF
 
     C                   EVAL      X3SNAM = BBCNA1
     C                   EVAL      X3ADD1 = BBCNA1
     C                   EVAL      X3ADD2 = BBCNA2
     C                   EVAL      X3ADD3 = BBCNA3
     C                   EVAL      X3ADD4 = BBCNA4
     C                   EVAL      X3HTEL = BBCTNB
     C                   EVAL      X3CFAX = E5FXNB
     C                   EVAL      X3BRCA = BBBRCD
 
     C                   CLEAR                   X3SINC
     C                   IF        BBDOIC <> 0
     C                   Move      BBDOIC        PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X3SINC = PCvtdDate
     C                   ENDIF
 
     C                   EVAL      X3MNGE = AZACON
     C                   EVAL      X3RISK = BBRWCD
 
     C                   IF        BBSSDT = *ZERO
     C                   EVAL      X3STAT = 'N'
     C                   ELSE
     C                   EVAL      X3STAT = 'Y'
     C                   ENDIF
 
     C                   EVAL      X3NATL = BBCNCZ
     C                   EVAL      X3RESD = BBCOLC
 
     C                   IF        PMode  = 'A'
     C                   EVAL      X3ACTN = 'I'
     C                   ELSE
     C                   EVAL      X3ACTN = BBTYLC
     C                   ENDIF
 
     C                   WRITE     SDCUSID0
 
     C                   EVAL      *INLR = *ON
 
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
 
     C     *entry        PLIST
     C                   PARM                    PMode
     C                   PARM                    PCustdetls
     C                   PARM                    PAdCustDet
     C                   PARM                    PAcOfcrDet
                                                                                             BUG3031
      ** Check if CGP001 is enabled.                                                         BUG3031
                                                                                             BUG3031
     C                   EVAL      CGP001 = 'N'                                              BUG3031
                                                                                             BUG3031
     C                   CALL      'AOSARDR0'                                                BUG3031
     C                   PARM      *BLANKS       PRtCd                                       BUG3031
     C                   PARM      '*VERIFY'     POptn                                       BUG3031
     C                   PARM      'CGP001'      PSARD                                       BUG3031
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3031
                                                                                             BUG3031
     C                   IF        PRtCd = *BLANKS                                           BUG3031
     C                   EVAL      CGP001 = 'Y'                                              BUG3031
     C                   ELSE                                                                BUG3031
                                                                                             BUG3031
     C                   IF        PRtCd <> '*NRF   '                                        BUG3031
     C     *LOCK         IN        LDA                                                       BUG3031
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3031
     C                   EVAL      DBKey = 'CGP001'                                          BUG3031
     C                   EVAL      DBase = 1                                                 BUG3031
     C                   OUT       LDA                                                       BUG3031
     C                   EVAL      *INU7 = *ON                                               BUG3031
     C                   EVAL      *INU8 = *ON                                               BUG3031
     C                   EXSR      *PSSR                                                     BUG3031
     C                   ENDIF                                                               BUG3031
                                                                                             BUG3031
     C                   ENDIF                                                               BUG3031
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ZaCvtDate                                              *
      *                                                               *
      *****************************************************************
 
     C     SrCvtDate     BEGSR
 
     C                   CALLB     'ZACVTDATE'
     C                   PARM      *Blanks       PRtrnCode
     C                   PARM                    PInDate
     C                   PARM                    POutDate
     C                   PARM                    PCvtdDate
 
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
(c) Finastra International Limited 2002
