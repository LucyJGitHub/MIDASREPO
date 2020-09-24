     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT940 File Extract')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001430 - Midas GL MT940 File Extract                       *
      *                                                               *
      *  Function: This program extracts data from Posting file to    *
      *            MGx940PD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 223783             Date 28May12               *
      *  Prev Amend No. 222088             Date 28May12               *
      *                 216936             Date 28May12               *
      *                 212319             Date 28May12               *
      *                 CMG008             Date 20Feb20               *
      *                 MD031848           Date 12Mar20               *
      *                 AR401845           Date 12Mar20               *
      *                 MD055383           Date 30Apr20               *
      *                 MD045952           Date 06Jul17               *
      *                 MD046248           Date 27Oct17               *
      *                 AR549926           Date 19Aug14               *
      *                 MD026137           Date 04Apr14               *
      *                 MD025973           Date 25Mar14               *
      *                 MD025766           Date 13Mar14               *
      *                 MD024415           Date 20Jan14               *
      *                 CGL146A            Date 10Jun13               *
      *                 AR787620           Date 10Jun11               *
      *                 AR782579           Date 01Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26810           Date 04Dec09               *
      *                 BUG26381           Date 09Oct09               *
      *                 BUG26608           Date 17Nov09               *
      *                 BUG23742           Date 26May09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG22687           Date 06Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 23May02               *
      *                 216935             Date 15Apr03               *
      *                 CGL013  *CREATE    Date 23Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  223783 - Applied for AR973615 (Child: AR973617) (Recompile)  *
      *  222088 - Conditioning of CM narrative should account for     *
      *           details on heirarchy, not ICD.                      *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  216936 - Text from CM ICD should not be present on           *
      *           statements for top accounts                         *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  212319 - Default text for Zeo Balance account not reported   *
      *           on statements                                       *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD031848 - Recently Closed account not generating MT940      *
      *             Amend to include closed today.                    *
      *  AR401845 - MT940 generation does not take into account       *
      *             regional holidays (CHILD: AR401846)               *
      *           - Replace ZFREQB with ZFRQB2 which considers        *
      *             system location.                                  *
      *  MD055383 - The system is generating another set of MT942.    *
      *             Amend to flag MT941 and MD942 MRPROC = 'Y'        *
      *  MD045952 - Ensure that COB MT940s only generated if          *
      *             calling pgm is GLC001430.                         *
      *           - Recompile due to changes to CGL146_043, CGL146_044*
      *             CGL146_047, CGL146_068, CGL146_070. CGL146_074    *
      *             CGL146_076, CGL146_077                            *
      *  MD046248 - Finastra Rebranding                               *
      *  AR549926 - GLPOSTPD and MGX950PD tables have a total size    *
      *             of about 1.4GB. These tables hold  records printed*
      *             on the MT9xx SWIFT messages. Amended program to   *
      *             tag records in GLPOSTPD file as processed even    *
      *             though there is a conflict between MT Generate    *
      *             flags in Network File and in Message Suppression  *
      *             in Customer Details File.                         *
      *  MD026137 - MT940 movement generation issue                   *
      *             Reverse MD025766 and reinstate original codign for*
      *             CGL146A. Amend Hook CGL146_075                    *
      *  MD025973 - Intermitent Generation of Movement in MT940       *
      *  MD025766 - Movements are not being generated (Recompile)     *
      *  MD024415 - Correct I/C generation of MT940/MT950             *
      *            Amend hooks: CGL146_070, CGL146_072, CGL146_076    *
      *            (Recompile)                                        *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_043, CGL146_044, CGL146_045    *
      *                         CGL146_046, CGL146_047, CGL146_068    *
      *                         CGL146_069, CGL146_070, CGL146_071    *
      *                         CGL146_072, CGL146_073, CGL146_074    *
      *                         CGL146_075, CGL146_076, CGL146_077    *
      *                         CGL146_078, CGL146_107                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00174                                 *
      *             WNCPYSRC,GLH00175                                 *
      *             WNCPYSRC,GLH00176                                 *
      *             WNCPYSRC,GLH00177                                 *
      *             WNCPYSRC,GLH00178                                 *
      *             WNCPYSRC,GLH00179                                 *
      *  AR782579 - GLC001430 00001
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *             (Child: AR676229)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26810 - MT940/950 should be independent of the network    *
      *             "activity"                                        *
      *  BUG26381 - Two issues with MT940 statement generation        *
      *  BUG26608 - External Extract Program not called for other     *
      *             networks                                          *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input (Recompile)                       *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG22687 - Various error on MT94x generation                 *
      *  CER030 - Multicash German Feature                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account (recompile)   *
      *  CRE008 - Cash Management                                     *
      *  216935 - Correct the processing for frequency 'On Movement'  *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     F******GLNW94L5  IF   E           K DISK                   INFSR(*PSSR)                MD031848
     FGLNW94L1  IF   E           K DISK                   INFSR(*PSSR)                      MD031848
      ** Midas GL Network Accounts - MT94x - Live/Accnt+Dst.- Retrieve

     FGLPOSTL0  UF   E           K DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(GL)
      ** Midas GL Posting sorted by Network Account, Message Type, destination.

     FGLNWKAPD  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Activity Control File.

     FGLNW94L0  UF   E           K DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(Up)
     F                                     RENAME(GLNW94D0:UpGLNW94D0)
      ** Midas GL Network Accounts - MT94x - Live/Accnt+Dst.- Update
                                                                                              CRE008
     FREGAHLJ2  IF   E           K DISK                   INFSR(*PSSR)                        CRE008
      ** Midas RE Group Account Hierarchy Links                                               CRE008
                                                                                              212319
     FREZSHLL1  IF   E           K DISK                   INFSR(*PSSR)                        212319
      ** Midas RE Group Account Hierarchy Links                                               212319
                                                                                              222088
     FREGAHDL0  IF   E           K DISK                   INFSR(*PSSR)                        222088
      ** Midas RE Group Account Hierarchy Details                                             222088

     FMGF940PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT940 Generation Extract - Account Detail.

     FMGX940PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT940 Generation Extract - Posting Detail.

     FMGY940PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT940 Gen. Extract File - Forw. Balance.

     FGL001430AUO    E             PRINTER OFLIND(*IN21)  INFSR(*PSSR)
      ** Midas GL MT940 File Extract - Audit Report.

      /COPY OFCPYSRCZ,CGL146_078                                                             CGL146A
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 21 - Audit report overflow indicator                                   *
      * 27 - Access Network Account (LF/GLNW94L5)                              *
      * 28 - Access Postings        (LF/GLPOSTL0)                              *
      * 29 - Access Group Account   (LF/REGAHLJ2)                              *              CRE008
      * 30 - Access T/S   Account   (LF/REZSHLL1)                              *              212319
      * 35 - Access CM A/C Hierarchy (LF/REGAHDL0)                             *              222088
      * 40 - General Error                                                     *
      *    41         For tagging as Processed                        *                     AR549926
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================

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

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

      ** Arrays and Data Structures
      ** --------------------------

      /COPY OFCPYSRCZ,CGL146_043                                                             CGL146A
                                                                                             CGL146A
     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(GL)
      **  Data Structure for Posting detail in General Ledger format.
     D   EXMGADI1    E                     EXTFLD(MGADI1)                       Additional Inf 1
     D   EXMGADI2    E                     EXTFLD(MGADI2)                       Additional Inf 2
     D   EXMGADI3    E                     EXTFLD(MGADI3)                       Additional Inf 3
     D   EXMGADI4    E                     EXTFLD(MGADI4)                       Additional Inf 4
     D   EXMGADI5    E                     EXTFLD(MGADI5)                       Additional Inf 5
     D   EXMGADI6    E                     EXTFLD(MGADI6)                       Additional Inf 6
     D   EXMGAERI    E                     EXTFLD(MGAERI)                       ERI Indicator

     D MGposting     E DS                  EXTNAME(MGX940PD)
      **  Data Structure for Posting detail in Message Genration Format.
     D/COPY WNCPYSRC,GLH00385

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **  Data Structure for SD General ledger ICD
     D QQACD1        E                     EXTFLD(QQACCD)                                     CGL029

     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.

     D GLACCNT       E DS                  EXTNAME(ACCNTAB)
      **  Data Structure for Account Details.

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data Structure for Customer Details.

     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)
      **  Data Structure for Switchable features descriptions.
                                                                                              CRE008
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)                                  CRE008
      ** External DS for cash management details                                              CRE008

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.

     D FwrDtBal        DS                  OCCURS (999)
      ** Multi-occurence data structure keep the Foward Value Date and Balance.
     D  FwrDate                       5  0 INZ(*ZEROS)                          Forward Value Date
     D  FwrBal                       15  0 INZ(*ZEROS)                          Forward Balance

      ** Define an array for the non generated messages number
      ** contained in the DsCUST data structure
      *
     D  BBNGEN         S              3A   DIM(15)
     D                                     BASED(Pointer1)
     D  Pointer1       S               *   INZ(%Addr(BBNG01))

      ** Declared variables
      ** ------------------

     D KeyNWRK         S                   LIKE(GLMGNWRK)                       Network
     D KeyBRCA         S                   LIKE(GLBRCA)                         Branch Code - Alpha
     D KeyCNUM         S                   LIKE(GLCNUM)                         Customer number
     D KeyCCY          S                   LIKE(GLCCY)                          Currency code
     D KeyACOD         S                   LIKE(GLACOD)                         Account code
     D KeyACSQ         S                   LIKE(GLACSQ)                         Account sequence num
     D KeyNATY         S                   LIKE(GLMGNATY)                       Network Account Type
     D KeyDSTN         S                   LIKE(GLMGDSTN)                       Destination
     D KeyMTPY         S                   LIKE(GLMGMTPY)                       Message Type

     D KeyNwNWRK       S                   LIKE(N4NWRK)                         Network
     D KeyNwBRCA       S                   LIKE(N4BRCA)                         Branch Code - Alpha
     D KeyNwCNUM       S                   LIKE(N4CNUM)                         Customer number
     D KeyNwCCY        S                   LIKE(N4CCY)                          Currency code
     D KeyNwACCD       S                   LIKE(N4ACCD)                         Account code
     D KeyNwACSQ       S                   LIKE(N4ACSQ)                         Account sequence num
     D KeyNwNATY       S                   LIKE(N4NATY)                         Network Account Type
     D KeyNwDSTN       S                   LIKE(N4DSTN)                         Destination

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@RETL          S             10A                                        Retail Number
     D P@CNUM          S              6A                                        Customer
     D P@CUCD          S              3A                                        Currency
     D*P@ACCD***       S              4A                                        Account code  CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@BRCA          S              3A                                        Branch Code
     D P@KEY1          S             10A                                        Customer
     D P@KYST          S              7A                                        Key Status
     D P@SARD          S              6A                                        Feature Ref.
     D P@NWRK          S              6A                                        Network

     D ZFREQ           S              1A                                        Frequence
     D ZDAYNO          S              5  0                                      Day Number
     D ZCCY            S              3A                                        Currency
     D ZLOC            S              3A                                                    AR782579
     D ZMDAY           S              2  0                                      Day in month
     D ZDFIN           S              1A                                        Date Format

     D CSW022          S              1A                                        Feature CSW022
     D CRE008          S              1A                                                      CRE008
     D WkBalance       S             15P 0                                      Intermediary Balance
     D WkNbMvts        S             10U 0                                      Nb. Movements
     D SavNWRK         S                   LIKE(EDNWRK) INZ(*BLANKS)            Network
     D WkNbFwrDt       S              5U 0 INZ(1)                               Nb. Foward Date
     D WkNxtStatDt     S                   LIKE(N40NSD)                         Next Statement Date
     D WkErrRpt        S              1A   INZ('N')                             Error Reported
     D X               S              5U 0                                      Working Index
      *                                                                                       CER030
      ** Parameters for EDEXET program                                                        CER030
      *                                                                                       CER030
     D*PRtcd*****      S              7A                                             CER030 BUG22687
     D PRtcd           S             10A                                                    BUG22687
     D PMsgTyp         S              3A                                                      CER030
      *                                                                                       CER030
     D/COPY WNCPYSRC,GLH00174

      ** Input Specs
      ** -----------


      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Read each Live Network Account.

      /COPY OFCPYSRCZ,CGL146_044                                                             CGL146A
                                                                                             CGL146A
     C******LOVAL        SETLL     GLNW94L5                                                 MD031848
     C**********         READ      GLNW94L5                               27                MD031848
     C     *LOVAL        SETLL     GLNW94L1                                                 MD031848
     C                   READ      GLNW94L1                               27                MD031848
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_045                                                             CGL146A

     C                   DOW       NOT *IN27

      ** Initialize working fields.

     C                   EXSR      $InitWkFld

     C                   DO

      ** If the Network Account does not generate MT940,
      ** or the next statement date is greater than or equal to the next working date,
      ** and there is no demand,
      ** read the next record.

     C                   IF        N4G940 <> 'Y'
     C                             OR N40NSD >= BJDNWD AND N40DSI <> 'Y'
     C                             OR N4RECI = '*' AND N4CHTP = 'D'                         MD031848
     C                             AND N4LCDT < BJDNWD                                      MD031848
      /COPY OFCPYSRCZ,CGL146_047                                                             CGL146A
     C                   LEAVE
     C                   ENDIF

      ** Check if the network is active

     C                   EXSR      $ChkNwrk

     C   40              LEAVE

      ** Check Account Details.

     C                   EXSR      $ChkAccnt

     C   40              LEAVE

      ** Check if the customer allows MT940 generation.

     C                   EXSR      $ChkCust

     C   40              LEAVE

      ** Process Posting Details

     C                   EXSR      $MGX940PD

     C   40              LEAVE

     C*********          IF        CSW022 <> 'Y'                                Feature Off   216935
     C*********                    OR WkNbMvts > *ZEROS                         Or Movements  216935
     C                   IF        WkNbMvts > *ZEROS                            Movements     216935
     C                             OR CSW022 <> 'Y'                             Feature Off   216935
     C                             AND N40SFR <> *blanks                        On Movement F.216935
     C                             AND N40SFR <> 'E'                                        BUG26381
     C/COPY WNCPYSRC,GLH00175

      ** Process Account Details

     C                   EXSR      $MGF940PD

     C   40              LEAVE

      ** Process Forward Balance

     C                   EXSR      $MGY940PD

     C   40              LEAVE
     C                   ENDIF

      ** Update Network Account details.

     C                   EXSR      $GLNW94PD

     C   40              LEAVE

      ** Update MT941 & MT942 Postings for the Network Account

     C                   EXSR      $GLPOSTPD

     C   40              LEAVE

     C                   ENDDO

     C**N40*****         COMMIT                                                             AR549926
     C  N40                                                                                 AR549926
     COR 41              COMMIT                                                             AR549926
     C***40*****         ROLBK                                                              AR549926
     C   40                                                                                 AR549926
     CANN41              ROLBK                                                              AR549926

      ** Read next Live Network Account.

      /COPY OFCPYSRCZ,CGL146_068                                                             CGL146A
     C**********         READ      GLNW94L5                               27                MD031848
     C                   READ      GLNW94L1                               27                MD031848
      /COPY OFCPYSRCZ,CGL146_069                                                             CGL146A

     C                   ENDDO

      ** End of processing

     C                   IF        WkErrRpt = 'N'
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   WRITE     ENDRPT

     C                   EVAL      *INLR = *ON

      *========================================================================*
      * $MGX940PD: Extract Posting Details                                     *
      *------------------------------------------------------------------------*

     C     $MGX940PD     BEGSR
      *    ---------     -----

     C                   EVAL      KeyNWRK = N4NWRK                             Network
     C                   EVAL      KeyBRCA = N4BRCA                             Branch Code - Alpha
     C                   EVAL      KeyCNUM = N4CNUM                             Customer number
     C                   EVAL      KeyCCY  = N4CCY                              Currency code
     C                   EVAL      KeyACOD = N4ACCD                             Account code
     C                   EVAL      KeyACSQ = N4ACSQ                             Account sequence num
     C                   EVAL      KeyNATY = N4NATY                             Network Account Type
     C                   EVAL      KeyDSTN = N4DSTN                             Destination
     C                   EVAL      KeyMTPY = '940'                              Message Type

      ** Read Postings for this Network Account.

     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28

     C                   DOW       NOT *IN28 AND NOT *IN40
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_070                                                             CGL146A

      ** Report only movements in General Ledger (from EODPOPD)

     C                   IF        GLRECI = 'P'

     C                   IF        GLMGPROC <> 'Y'

     C                   EVAL      WkNbMvts = WkNbMvts + 1

      ** Calculate the new balance

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      WkBalance = WkBalance + GLPSTA
     C                   ELSE                                                   Credit
     C                   EVAL      WkBalance = WkBalance - GLPSTA
     C                   ENDIF

      ** If Extended narrative is allowed for the Network.

     C                   IF        EDENRA = 'Y'
     C                   EVAL      EXMGADI1 =  GLMGADI1                         Additional Inf 1
     C                   EVAL      EXMGADI2 =  GLMGADI2                         Additional Inf 2
     C                   EVAL      EXMGADI3 =  GLMGADI3                         Additional Inf 3
     C                   EVAL      EXMGADI4 =  GLMGADI4                         Additional Inf 4
     C                   EVAL      EXMGADI5 =  GLMGADI5                         Additional Inf 5
     C                   EVAL      EXMGADI6 =  GLMGADI6                         Additional Inf 6
     C                   EVAL      EXMGAERI =  GLMGAERI                         ERI Indicator
     C                   ELSE
     C                   EVAL      EXMGADI1 =  *BLANKS                          Additional Inf 1
     C                   EVAL      EXMGADI2 =  *BLANKS                          Additional Inf 2
     C                   EVAL      EXMGADI3 =  *BLANKS                          Additional Inf 3
     C                   EVAL      EXMGADI4 =  *BLANKS                          Additional Inf 4
     C                   EVAL      EXMGADI5 =  *BLANKS                          Additional Inf 5
     C                   EVAL      EXMGADI6 =  *BLANKS                          Additional Inf 6
     C                   EVAL      EXMGAERI =  *BLANKS                          ERI Indicator
     C                   ENDIF

      ** Format the posting details

     C                   CALLB     'GL001432'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return Code
     C                   PARM                    GLPosting                      GL Posting Detail
     C                   PARM      *BLANKS       MGPosting                      MG Posting Detail

     C                   IF        ReturnCode = 'PSSR_ERROR'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER030
     C                   EVAL      MGTRAT = *ZEROS                                            CER030
     C                   EVAL      PRtcd = *BLANKS                                            CER030
     C                   EVAL      *IN99 = *OFF                                               CER030
      *                                                                                       CER030
     C**********         IF        EDMCNW = 'Y' AND                                  CER030 BUG23284
     C**********         IF        (EDMCNW = 'Y' OR MGNWRK ='SWIFT') AND           BUG23284 BUG26608
     C**********                   (EDEXET <> *BLANKS AND                            CER030 BUG26608
     C                   IF        (EDEXET <> *BLANKS AND                                   BUG26608
     C                             EDEXET <> '*NONE')                                         CER030
     C                   EVAL      PMsgTyp = '940'                                            CER030
      *                                                                                       CER030
     C                   CALL      EDEXET                               99                    CER030
     C                   PARM                    PRtcd                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    GLPosting                                    CER030
     C                   PARM                    MGPosting                                    CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = 'PSSR_ERROR'                                       CER030
     C                             OR *IN99 = *ON                                             CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
     C/COPY WNCPYSRC,GLH00386
     C/COPY WNCPYSRC,GLH00176

     C**********         IF        ReturnCode = *BLANKS                                       CER030
     C                   IF        ReturnCode = *BLANKS AND                                   CER030
     C                             PRtcd = *BLANKS                                            CER030
     C/COPY WNCPYSRC,GLH00177

      ** Add record in MT940 Generation Extract - Posting Detail

     C                   WRITE     MGX940D0

     C                   ELSE

      ** Add the issue on the audit report.

     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Posting extract failed'
     C**********         DUMP                                                               MD025973
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @MGX940PD
     C                   ENDIF

     C                   ENDIF

      ** Retrieve balance by value date in the future

     C                   IF        GLVALD >= BJDNWD

      ** Initialize the first Forward Date to the first Posting Valur Date greater than run day

     C                   IF        FwrDate = *ZEROS
     C                   EVAL      FwrDate = GLVALD
     C                   ENDIF

      ** Totalize movement by value date

     C                   IF        GLVALD > FwrDate                             Next Foward Date
     C                   EVAL      WkNbFwrDt = WkNbFwrDt + 1
     C     WkNbFwrDt     OCCUR     FwrDtBal
     C                   EVAL      FwrDate = GLVALD
     C                   ENDIF

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      FwrBal = FwrBal + GLPSTA
     C                   ELSE                                                   Credit
     C                   EVAL      FwrBal = FwrBal - GLPSTA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Mark the posting as processed

     C                   EVAL      GLMGPROC = 'Y'
     C                   UPDATE    GLPOSTD0
      /COPY OFCPYSRCZ,CGL146_071                                                             CGL146A

      ** Read Next Posting for this Network Account.

     C     KeyPost       READE     GLPOSTD0                               28

     C                   ENDDO


      *    ---------     -----
     C     @MGX940PD     ENDSR

      *========================================================================*
      * $MGF940PD: Extract Account Details                                     *
      *------------------------------------------------------------------------*

     C     $MGF940PD     BEGSR
      *    ---------     -----

     C                   EVAL      MGNWRK = N4NWRK                              Network
     C                   EVAL      MGBRCA = N4BRCA                              Branch Code - Alpha
     C                   EVAL      MGCNUM = N4CNUM                              Customer number
     C                   EVAL      MGCCY  = N4CCY                               Currency code
     C                   EVAL      MGACCD = N4ACCD                              Account code
     C                   EVAL      MGACSQ = N4ACSQ                              Account sequence num
     C                   EVAL      MGNATY = N4NATY                              Network Account Type
     C                   EVAL      MGDSTN = N4DSTN                              Destination
     C                   IF        ED0DMS <> *BLANKS
     C                   EVAL      MGDMST = ED0DMS                              Default Message Stat
     C                   ELSE
     C                   EVAL      MGDMST = 'C'                                 Default Message Stat
     C                   ENDIF
     C                   EVAL      MGACNO = ACNO                                Retail account numbe
     C                   EVAL      MGIBAN = IBAN                                IBAN
      *                                                                                       CRE008
      *  If Cash Management feature is installed and the account is                           CRE008
      *  a part of a group account hierarchy, use group account narrative                     CRE008
      *  instead                                                                              CRE008
     C                   IF        CRE008 = 'Y'                                               CRE008
     C     KeyAcntBl     Chain     REGAHLJ2                           29                      CRE008
     C                   IF        *IN29 = *OFF                                               222088
     C     CLHIER        CHAIN     REGAHDL0                           35                      222088
     C                   IF        *IN35 = *ON                                                222088
     C                   EXSR      *PSSR                                                      222088
     C                   ENDIF                                                                222088
     C                   ENDIF                                                                222088
     C                   If        *IN29 = *OFF                                               CRE008
     C                             AND CLCCAT <> 'T'                                          216936
     C                             AND GDTOPB = 'Y'                                           222088
     C                             OR  *IN29 = *OFF                                           222088
     C                             AND CLCCAT = 'T'                                           222088
     C                             AND GDTOPB = 'N'                                           222088
     C                   EVAL      MGMIO1 = CMTXTG                                            CRE008
     C                   EVAL      MGMIO2 = %subst(CMTXTG:66:65)                              CRE008
     C                   EVAL      MGMIO3 = %subst(CMTXTG:131:65)                             CRE008
     C                   EVAL      MGMIO4 = %subst(CMTXTG:196:5)                              CRE008
     C                   EVAL      MGMIO5 = *blanks                                           CRE008
     C                   EVAL      MGMIO6 = *blanks                                           CRE008
     C                   Else                                                                 CRE008
     C     KeyAcntBg     CHAIN     REZSHLL1                           30                      212319
     C                   IF        *IN30 = *OFF                                               212319
     C                   EVAL      MGMIO1 = CMTXTZ                                            212319
     C                   EVAL      MGMIO2 = %subst(CMTXTZ:66:65)                              212319
     C                   EVAL      MGMIO3 = %subst(CMTXTZ:131:65)                             212319
     C                   EVAL      MGMIO4 = %subst(CMTXTZ:196:5)                              212319
     C                   EVAL      MGMIO5 = *blanks                                           212319
     C                   EVAL      MGMIO6 = *blanks                                           212319
     C                   ELSE                                                                 212319
     C                   EVAL      MGMIO1 = N40MI1                              Manual Prod Msg leve
     C                   EVAL      MGMIO2 = N40MI2                              Manual Prod Msg leve
     C                   EVAL      MGMIO3 = N40MI3                              Manual Prod Msg leve
     C                   EVAL      MGMIO4 = N40MI4                              Manual Prod Msg leve
     C                   EVAL      MGMIO5 = N40MI5                              Manual Prod Msg leve
     C                   EVAL      MGMIO6 = N40MI6                              Manual Prod Msg leve
     C                   Endif                                                                CRE008
     C                   Endif                                                                CRE008
     C                   ENDIF                                                                212319
     C*                                                                                       CRE008
     C                   EVAL      MGSTNO = N40LSN + 1                          Last Statement Page
     C                   EVAL      MGLSDT = N40LSD                              Last Statement Date
     C                   EVAL      MGIOBL = N40LCA                              Initial Opening Bala
     C                   EVAL      MGFCBL = N40LCA + WkBalance                  Final Closing Balanc
     C                   EVAL      MGCLBL = CLBL                                Available Balance
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_072                                                             CGL146A

     C                   WRITE     MGF940D0
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_073                                                             CGL146A

      *    ---------     -----
     C     @MGF940PD     ENDSR

      *========================================================================*
      * $MGY940PD: Forward Balance                                             *
      *------------------------------------------------------------------------*

     C     $MGY940PD     BEGSR
      *    ---------     -----

     C                   EVAL      MGNWRK = N4NWRK                              Network
     C                   EVAL      MGBRCA = N4BRCA                              Branch Code - Alpha
     C                   EVAL      MGCNUM = N4CNUM                              Customer number
     C                   EVAL      MGCCY  = N4CCY                               Currency code
     C                   EVAL      MGACCD = N4ACCD                              Account code
     C                   EVAL      MGACSQ = N4ACSQ                              Account sequence num
     C                   EVAL      MGNATY = N4NATY                              Network Account Type
     C                   EVAL      MGDSTN = N4DSTN                              Destination

     C                   EVAL      MGFAMT = CLBL                                Available Fund

     C     1             DO        WkNbFwrDt     X
     C     X             OCCUR     FwrDtBal
     C                   IF        FwrDate <> *ZEROS
     C                   EVAL      MGFVDT = FwrDate                             Forward Date
     C                   EVAL      MGFAMT = MGFAMT + FwrBal                     Forward Balance
     C                   WRITE     MGY940D0
     C                   ENDIF
     C                   ENDDO

      *    ---------     -----
     C     @MGY940PD     ENDSR

      *========================================================================*
      * $GLNW94PD: Update Network Account details.                             *
      *------------------------------------------------------------------------*

     C     $GLNW94PD     BEGSR
      *    ---------     -----

      ** Retrieve next statement date

      ** Only if it is not a demand.

     C                   IF        N40NSD < BJDNWD

      ** If frequency is 'Z' on request, the next statement date is in 6 months.

     C                   IF        N40SFR = 'Z'
     C                   EVAL      WkNxtStatDt = BJRDNB + 183                   Next Statement Date
     C                   ELSE

      ** Otherwise, calculate the next working date.

     C                   IF        N40SFR = *Blanks                             On Movement   216935
     C                   EVAL      ZFREQ = 'D'                                  Frequence     216935
     C                   ELSE                                                                 216935
     C                   EVAL      ZFREQ = N40SFR                               Frequence     216935
     C                   ENDIF                                                                216935

     C**********         CALLB     'ZFREQB'                                                 AR401845
     C                   CALLB     'ZFRQB2'                                                 AR401845
     C                   PARM      *BLANKS       RetCodeIn                      Return Code
     C**********         PARM      N40SFR        ZFREQ                          Frequence     216935
     C                   PARM                    ZFREQ                          Frequence     216935
     C                   PARM      BJRDNB        ZDAYNO                         Start Date
     C                   PARM      BJLCCY        ZCCY                           Local Currency
     C                   PARM      BJSLCD        ZLOC                                       AR782579
     C                   PARM      N40SDM        ZMDAY                          Day in Month
     C                   PARM      BJDFIN        ZDFIN                          Date Format Indicato
     C     SDGELR        PARM      SDGELR        DSFDY                          General ledger ICD
     C
     C                   IF        RetCodeIn = *BLANKS
     C                   EVAL      WkNxtStatDt = ZDAYNO                         Next Statement Date
     C                   ELSE
     C
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Calculation of the next +
     C                                       statement date failed'
     C**********         DUMP                                                               MD025973
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @GLNW94PD
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Access the Networl Account for update

     C                   EVAL      KeyNwNWRK = N4NWRK                           Network
     C                   EVAL      KeyNwBRCA = N4BRCA                           Branch Code - Alpha
     C                   EVAL      KeyNwCNUM = N4CNUM                           Customer number
     C                   EVAL      KeyNwCCY  = N4CCY                            Currency code
     C                   EVAL      KeyNwACCD = N4ACCD                           Account code
     C                   EVAL      KeyNwACSQ = N4ACSQ                           Account sequence num
     C                   EVAL      KeyNwNATY = N4NATY                           Network Account Type
     C                   EVAL      KeyNwDSTN = N4DSTN                           Destination

     C     KeyNwrkAc     CHAIN     GLNW94L0                           99

     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Network Account not found +
     C                                       for update'
     C**********         DUMP                                                               MD025973
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @GLNW94PD
     C                   ENDIF

      ** Process MT940 Details.

      ** If no message generation due to no movement to report,                               216935
      ** update only the next statement date                                                  216935
      *                                                                                       216935
     C                   IF        WkNbMvts    = *ZEROS                         Movements     216935
     C                             AND CSW022  = 'Y'                            Feature Off   216935
     C                             OR WkNbMvts = *ZEROS                         Movements     216935
     C                             AND N40SFR  = *BLANKS                        On Movement F.216935
     C                             OR WkNbMvts = *ZEROS                                     BUG26381
     C                             AND N40SFR  = 'E'                                        BUG26381
     C/COPY WNCPYSRC,GLH00178
     C                   EVAL      UpN40DSI = 'N'                               Demand Stateme216935
     C                   IF        N40NSD < BJDNWD                              Not a demand  216935
     C/COPY OFCPYSRCZ,CGL146_074                                                             CGL146A
     C                   EVAL      UpN40NSD = WkNxtStatDt                       Next Statement216935
     C                   ENDIF                                                                216935
      *                                                                                       216935
      ** Otherwise, update all details                                                        216935
      *                                                                                       216935
     C                   ELSE                                                                 216935
      *                                                                                       216935
     C                   EVAL      UpN40DSI = 'N'                               Demand Statement ind
     C                   EVAL      UpN40LSD = BJRDNB                            Last Statement Date
     C/COPY OFCPYSRCZ,CGL146_075                                                             CGL146A
     C                   TIME                    UpN40LST                       Last Statement Time
     C                   EVAL      UpN40LSN = N40LSN + 1                        Last Statement Page
     C                   EVAL      UpN40LCA = N40LCA + WkBalance                Final Closing Balanc
     C                   IF        N40NSD < BJDNWD                              Not a demand
     C/COPY OFCPYSRCZ,CGL146_074                                                             CGL146A
     C                   EVAL      UpN40NSD = WkNxtStatDt                       Next Statement Date
     C                   ENDIF


      ** Process MT941 Details.

     C                   IF        N4G941 = 'Y'
     C                   EVAL      UpN41LSD = UpN40LSD                          Last Statement Date
     C                   EVAL      UpN41LST = UpN40LST                          Last Statement Time
     C                   EVAL      UpN41LDN = *ZEROS                            Last sum of DB Numbe
     C                   EVAL      UpN41LDA = *ZEROS                            Last sum of DB Amnt
     C                   EVAL      UpN41LCN = *ZEROS                            Last sum of CR Numbe
     C                   EVAL      UpN41LCA = *ZEROS                            Last sum of CR Amnt
     C                   EVAL      UpN41LCB = UpN40LCA                          Final Closing Balanc
     C                   ENDIF

      ** Process MT942 Details.

     C                   IF        N4G942 = 'Y'
     C                   EVAL      UpN42LSD = UpN40LSD                          Last Statement Date
     C                   EVAL      UpN42LST = UpN40LST                          Last Statement Time
     C                   EVAL      UpN42LDN = *ZEROS                            Last sum of DB Numbe
     C                   EVAL      UpN42LDA = *ZEROS                            Last sum of DB Amnt
     C                   EVAL      UpN42LCN = *ZEROS                            Last sum of CR Numbe
     C                   EVAL      UpN42LCA = *ZEROS                            Last sum of CR Amnt
     C                   ENDIF
      *                                                                                       216935
     C                   ENDIF                                                                216935

     C                   UPDATE    UpGLNW94D0
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_107                                                             CGL146A

      *    ---------     -----
     C     @GLNW94PD     ENDSR

      *========================================================================*
      * $GLPOSTPD: Update MT941 & MT942 Posting for the Network account        *
      *------------------------------------------------------------------------*

     C     $GLPOSTPD     BEGSR
      *    ---------     -----

     C                   EVAL      KeyNWRK = N4NWRK                             Network
     C                   EVAL      KeyBRCA = N4BRCA                             Branch Code - Alpha
     C                   EVAL      KeyCNUM = N4CNUM                             Customer number
     C                   EVAL      KeyCCY  = N4CCY                              Currency code
     C                   EVAL      KeyACOD = N4ACCD                             Account code
     C                   EVAL      KeyACSQ = N4ACSQ                             Account sequence num
     C                   EVAL      KeyNATY = N4NATY                             Network Account Type
     C                   EVAL      KeyDSTN = N4DSTN                             Destination

      ** Process MT941 Details.

     C                   IF        N4G941 = 'Y'

     C                   EVAL      KeyMTPY = '941'                              Message Type

      ** Read Postings for this Network Account.

     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28

     C                   DOW       NOT *IN28

      ** Report only movements in General Ledger (from EODPOPD)

     C                   IF        GLMGPROC <> 'Y'

     C                   EVAL      GLMGPROC = 'Y'
     C                   UPDATE    GLPOSTD0
     C                   ENDIF

      ** Read Next Posting for this Network Account.

     C     KeyPost       READE     GLPOSTD0                               28

     C                   ENDDO
     C                   ENDIF

      ** Process MT942 Details.

     C                   IF        N4G942 = 'Y'

     C                   EVAL      KeyMTPY = '942'                              Message Type

      ** Read Postings for this Network Account.

     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28

     C                   DOW       NOT *IN28

      ** Report only movements in General Ledger (from EODPOPD)

     C                   IF        GLMGPROC <> 'Y'

     C                   EVAL      GLMGPROC = 'Y'
     C                   UPDATE    GLPOSTD0
     C                   ENDIF

      ** Read Next Posting for this Network Account.

     C     KeyPost       READE     GLPOSTD0                               28

     C                   ENDDO
     C                   ENDIF

      *    ---------     -----
     C     @GLPOSTPD     ENDSR

      *========================================================================*
      * $InitWkFld: Initialize working fields.                                 *
      *------------------------------------------------------------------------*

     C     $InitWkFld    BEGSR
      *    ----------    -----

     C                   EVAL      *IN40 = *OFF                                 General Indicator
     C                   EVAL      *IN41 = *OFF                                             AR549926

     C                   EVAL      WkBalance = *ZEROS                           Intermediary Balance

     C                   EVAL      WkNbMvts = *ZEROS                            Nb. Movements

     C                   EVAL      WkNxtStatDt = N40NSD                         Next Statement Date

     C     1             DO        WkNbFwrDt     X
     C     X             OCCUR     FwrDtBal
     C                   EVAL      FwrDate = *ZEROS                             Forward Date
     C                   EVAL      FwrBal  = *ZEROS                             Forward Balance
     C                   ENDDO
     C                   EVAL      WkNbFwrDt = 1                                Foward Balance
     C     WkNbFwrDt     OCCUR     FwrDtBal

     C     @InitWkFld    ENDSR
      *    --------      -----

      *========================================================================*
      * $ChkNwrk: Check if the Network is active.                              *
      *------------------------------------------------------------------------*

     C     $ChkNwrk      BEGSR
      *    --------      -----

     C                   IF        N4NWRK <> SavNWRK

      **  Check if the Network exists.

     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      N4NWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Network ' + %TRIM(N4NWRK) +
     C                                      ' does not exist'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      **  Check if the Network authorizes MT940.

     C                   IF        EDM940 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Network ' + %TRIM(N4NWRK) +
     C                                      ' does not authorize MT940'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      ****Check*if*the*network*is*active.                                                   BUG26810

     C*****N4NWRK        CHAIN     GLNWKAPD                           99                    BUG26810

     C**********         IF        *IN99                                                    BUG26810
     C**********                   OR NOT *IN99 AND MTSSTS <> 'A'                           BUG26810
     C**********         EVAL      *IN40 = *ON                                              BUG26810
     C**********         EVAL      P4CMNT = 'Network ' + %TRIM(N4NWRK) + ' is +             BUG26810
     C**********                             not active'                                    BUG26810
     C**********         EXSR      $AuditRpt                                    Report IssueBUG26810
     C**********         GOTO      @ChkNwrk                                                 BUG26810
     C**********         ENDIF                                                              BUG26810

     C/COPY OFCPYSRCZ,CGL146_076                                                            MD025973
                                                                                            MD025973
     C  N40              EVAL      SAvNWRK = N4NWRK
                                                                                             CGL146A
     C***/COPY*OFCPYSRCZ,CGL146_076                                                 CGL146A MD025973

     C                   ENDIF

      *    ---------     -----
     C     @ChkNwrk      ENDSR

      *========================================================================*
      * $ChkAccnt: Check Account details                                       *
      *------------------------------------------------------------------------*

     C     $ChkAccnt     BEGSR
      *    ---------     -----

     C                   MOVE      N4CNUM        P@CNUM                         Customer
     C                   MOVE      N4ACCD        P@ACCD                         Account code
     C                   MOVE      N4ACSQ        P@ACSQ                         Account Sequence

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      N4CCY         P@CUCD                         Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      N4BRCA        P@BRCA                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Midas Account Detail not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

      *    ---------     -----
     C     @ChkAccnt     ENDSR

      *========================================================================*
      * $ChkCust: Check if the customer allows MT940 generation.               *
      *------------------------------------------------------------------------*

     C     $ChkCust      BEGSR
      *    --------      -----

     C                   MOVEL(P)  N4CNUM        P@KEY1                         Customer

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM                    P@KEY1                         Customer
     C                   PARM                    P@KYST                         Key Status
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      P4CMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkCust
     C                   ENDIF
      *                                                                                     AR549926
     C                   EVAL      *IN41 = *OFF                                             AR549926

      ** Add the issue on the audit report.

     C     '940'         LOOKUP    BBNGEN                                 99
     C     '941'         LOOKUP    BBNGEN                                 98                AR549926
      *                                                                                     AR549926
     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON                                              AR549926
     C                   EVAL      P4CMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' does not allow MT940 generation'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

     C                   IF        *IN41                                                    AR549926
     C                   EXSR      $TAGPROC                                                 AR549926
     C                   ENDIF                                                              AR549926
      *    ---------     -----
     C     @ChkCust      ENDSR

      *========================================================================*
      * $AuditRpt: Report issues                                               *
      *------------------------------------------------------------------------*

     C     $AuditRpt     BEGSR
      *    ---------     -----

     C                   IF        *IN21                                        Printer Overflow
     C                   WRITE     HEADAU
     C                   WRITE     SUBTL                                21
     C                   ENDIF
     C                   WRITE     DETAIL

     C                   EVAL      WkErrRpt = 'Y'                               Error Reported

      *    ---------     -----
     C     @AuditRpt     ENDSR

      *****************************************************************                     AR549926
      *  $TAGPROC: Tag Records as Processed                           *                     AR549926
      *****************************************************************                     AR549926
      *                                                                                     AR549926
     C     $TAGPROC      BEGSR                                                              AR549926
     C                   EVAL      KeyNWRK = N4NWRK                                         AR549926
     C                   EVAL      KeyBRCA = N4BRCA                                         AR549926
     C                   EVAL      KeyCNUM = N4CNUM                                         AR549926
     C                   EVAL      KeyCCY  = N4CCY                                          AR549926
     C                   EVAL      KeyACOD = N4ACCD                                         AR549926
     C                   EVAL      KeyACSQ = N4ACSQ                                         AR549926
     C                   EVAL      KeyNATY = N4NATY                                         AR549926
     C                   EVAL      KeyDSTN = N4DSTN                                         AR549926
     C                   EVAL      KeyMTPY = '940'                                          AR549926
      *                                                                                     AR549926
      ** Read Postings for this Network Account and tag as Processed                        AR549926
      *                                                                                     AR549926
     C     KeyPost       SETLL     GLPOSTD0                                                 AR549926
     C     KeyPost       READE     GLPOSTD0                               28                AR549926
     C                   DOW       NOT *IN28                                                AR549926
     C                   EVAL      GLMGPROC = 'Y'                                           AR549926
     C                   UPDATE    GLPOSTD0                                                 AR549926
     C     KeyPost       READE     GLPOSTD0                               28                AR549926
     C                   ENDDO                                                              AR549926
      *                                                                                     AR549926
     C**********         IF        *IN98                                           AR549926 MD055383
     C                   EXSR      $GLPOSTPD                                                AR549926
     C**********         ENDIF                                                     AR549926 MD055383
      *                                                                                     AR549926
     C                   ENDSR                                                              AR549926
      *****************************************************************                     AR549926
      *========================================================================*
      * *INSZR: Initial Sub-routine                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----
                                                                                              CGL146
      /COPY OFCPYSRCZ,CGL146_077                                                              CGL146

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA.

     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Check if feature CSW022 is installed
      ** CSW022 - Suppress generation of SWIFT Statement messages if account has no movements.

     C                   EVAL      CSW022 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*VERIFY'     P@OPTN                         Option
     C                   PARM      'CSW022 '     P@SARD                         Feature Ref.
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      CSW022 = 'Y'
     C                   ENDIF
                                                                                              CRE008
      ** Check if feature CRE008 (Cash Management feature) is installed                       CRE008
                                                                                              CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
                                                                                              CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CRE008
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CRE008
     C                   PARM      'CRE008 '     P@SARD                         Feature Ref.  CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
     C                   IF        P@RTCD = *BLANKS                                           CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
                                                                                              CRE008
      *  Access Cash Management ICD                                                           CRE008
     C                   CALLB     'AOCMANR0'                                                 CRE008
     C                   PARM      *BLANKS       P@RTCD                                       CRE008
     C                   PARM      '*FIRST  '    P@OPTN                                       CRE008
     C     SDCMAN        PARM      SDCMAN        DSSDY                                        CRE008
                                                                                              CRE008
     C                   ENDIF                                                                CRE008
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_046                                                             CGL146A
     C/COPY WNCPYSRC,GLH00387
     C/COPY WNCPYSRC,GLH00179

      ** Write audit report title.

     C                   WRITE     HEADAU
     C                   WRITE     SUBTL                                21

      ** Key to access Posting details.

     C     KeyPost       KLIST
     C                   KFLD                    KeyNWRK                        Network
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyNATY                        Network Account Type
     C                   KFLD                    KeyDSTN                        Destination
     C                   KFLD                    KeyMTPY                        Message Type

      ** Key to access Network Account.

     C     KeyNwrkAc     KLIST
     C                   KFLD                    KeyNwNWRK                      Network
     C                   KFLD                    KeyNwBRCA                      Branch Code - Alpha
     C                   KFLD                    KeyNwCNUM                      Customer number
     C                   KFLD                    KeyNwCCY                       Currency code
     C                   KFLD                    KeyNwACCD                      Account code
     C                   KFLD                    KeyNwACSQ                      Account sequence num
     C                   KFLD                    KeyNwNATY                      Network Account Type
     C                   KFLD                    KeyNwDSTN                      Destination
                                                                                              CRE008
     C     KeyAcntBl     KLIST                                                                CRE008
     C                   KFLD                    KeyCNUM                                      CRE008
     C                   KFLD                    KeyCCY                                       CRE008
     C                   KFLD                    KeyACOD                                      CRE008
     C                   KFLD                    KeyACSQ                                      CRE008
     C                   KFLD                    KeyBRCA                                      CRE008
                                                                                              212319
     C     KeyAcntBg     KLIST                                                                212319
     C                   KFLD                    KeyBRCA                                      212319
     C                   KFLD                    KeyCNUM                                      212319
     C                   KFLD                    KeyCCY                                       212319
     C                   KFLD                    KeyACOD                                      212319
     C                   KFLD                    KeyACSQ                                      212319

      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    -----         -----

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

      *    -----         -----
     C     @PSSR         ENDSR

      *========================================================================*
**CTDATA CPY@
(c) Finastra International Limited 2002
